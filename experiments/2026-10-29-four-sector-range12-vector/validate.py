#!/usr/bin/env python3
"""Compile and validate six correctness-only backend/sanitizer combinations."""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shlex
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LEASE = ROOT / "experiments/2026-10-29-multiply-code-small-confirmation/driver/source_guard.py"
spec = importlib.util.spec_from_file_location("range12_vector_lease", LEASE)
lease_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lease_module)


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def main():
    need(__debug__, "Do not disable assertions")
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source-commit", required=True)
    p.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = p.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full committed source required")
    lease = lease_module.require_lease(args.cpu)
    preparation = json.loads((HERE / "PREPARATION.json").read_text())
    files = {str((HERE / name).relative_to(ROOT)): digest for name, digest in preparation["files"].items()}
    files.update(preparation["inputs_sha256"])
    files[str((HERE / "PREPARATION.json").relative_to(ROOT))] = sha(HERE / "PREPARATION.json")

    def verify():
        for name, digest in files.items():
            need(sha(ROOT / name) == digest, "Changed input: " + name)
            blob = subprocess.check_output(["git", "show", args.source_commit + ":" + name], cwd=ROOT)
            need(hashlib.sha256(blob).hexdigest() == digest, "Uncommitted input: " + name)

    verify()
    out = HERE / "validation-v1"
    out.mkdir(exist_ok=False)
    (out / "binaries").mkdir()
    meta = dict(complete=False, performance_run=False, source_commit=args.source_commit,
                lease=lease, source_sha256=files, commands=[], binaries={}, consumed_inputs={})

    def save():
        (out / "metadata.json").write_text(json.dumps(meta, indent=2) + "\n")

    def run(label, command):
        command = [str(x) for x in command]
        env = dict(os.environ, ASAN_OPTIONS="detect_leaks=1:halt_on_error=1", UBSAN_OPTIONS="halt_on_error=1:print_stacktrace=1")
        result = subprocess.run(command, cwd=ROOT, capture_output=True, env=env,
                                pass_fds=tuple(lease["inherited_lock_descriptors"]))
        stdout, stderr = out / (label + ".stdout"), out / (label + ".stderr")
        stdout.write_bytes(result.stdout)
        stderr.write_bytes(result.stderr)
        meta["commands"].append(dict(label=label, command=command, returncode=result.returncode,
            stdout_sha256=sha(stdout), stderr_sha256=sha(stderr)))
        save()
        need(result.returncode == 0, "Failed operation; raw evidence retained: " + label)
        return result.stdout

    save()
    run("derive", ["python3", HERE / "derive.py", "--verify"])
    run("compiler", ["clang++", "--version"])
    reference = None
    for backend, flags in (("native", ["-march=native"]), ("avx2", ["-march=x86-64-v3"]),
                           ("scalar", ["-march=x86-64", "-mno-avx", "-mno-sse4.1", "-mno-ssse3"])):
        for sanitizer in (False, True):
            verify()
            need(lease_module.require_lease(args.cpu) == lease, "Lease drift")
            name = backend + ("-asan" if sanitizer else "")
            binary, dep = out / "binaries" / name, out / (name + ".d")
            options = ["-O1", "-fsanitize=address,undefined", "-fno-sanitize-recover=all", "-fno-omit-frame-pointer"] if sanitizer else ["-O3"]
            run(name + "-build", ["clang++", "-std=c++17", *options, *flags,
                "-I", ROOT / "include", "-MD", "-MF", dep, HERE / "check.cpp", "-o", binary])
            meta["binaries"][name] = dict(path=str(binary), sha256=sha(binary))
            consumed = {}
            for token in shlex.split(dep.read_text().replace("\\\n", " "))[1:]:
                path = Path(token)
                path = (path if path.is_absolute() else ROOT / path).resolve()
                need(path.is_file(), "Missing consumed dependency")
                if path.is_relative_to(ROOT):
                    relative = str(path.relative_to(ROOT))
                    need(relative in files, "Unprepared repository input: " + relative)
                    need(sha(path) == files[relative], "Compiled source drift")
                consumed[str(path)] = sha(path)
            meta["consumed_inputs"][name] = consumed
            save()
            actual = run(name + "-check", [binary])
            rows = [json.loads(line) for line in actual.decode().splitlines()]
            need(rows == [dict(k=12, requested_bytes=b, bytes=b//64*64, inserted=20480, tail_cases=548)
                          for b in (128,129,192,320,262208,2097216,100663296)],
                 "Incomplete calibrated-K12 vector correctness fixtures")
            if reference is None:
                reference = actual
            need(actual == reference, "Backend oracle digest disagreement")
            need(not (out / (name + "-check.stderr")).read_bytes(), "Correctness diagnostic emitted")
            for path, digest in consumed.items():
                need(sha(Path(path)) == digest, "Consumed header drift")
            print("PASS " + name, flush=True)
    verify()
    need(lease_module.require_lease(args.cpu) == lease, "Final lease drift")
    for record in meta["binaries"].values():
        need(sha(Path(record["path"])) == record["sha256"], "Validated executable drift")
    meta.update(complete=True, digest_output=reference.decode(), correctness_cases=42, calibration_mapping="scalar K12 at 4e2277bc2c777cc5382a4c9d18ca60b7955ea929")
    save()


if __name__ == "__main__":
    main()
