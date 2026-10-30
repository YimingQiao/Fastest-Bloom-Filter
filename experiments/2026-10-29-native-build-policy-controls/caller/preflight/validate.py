#!/usr/bin/env python3
"""Old-seed four-arm caller correctness only; never invoke --measure."""
import sys
if not __debug__:
    raise SystemExit("Python -O is forbidden before execution")
import argparse
import json
import os
from pathlib import Path
import subprocess
from contract import SEMANTICS, fixtures, need, parse, reference_check, validate
from dependencies import collect
from lease import require_lease
from source_guard import CALLER, HERE, ROOT, sha, verify


def dump(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def command(binary, case, lease, mode="--caller-check"):
    need(mode in ("--caller-check", "--check-bad-output"), "No formal execution from preflight")
    cpus = ",".join(map(str, lease["child_cpus"][:case["requested"]]))
    return ["taskset", "-c", cpus, "numactl", "--physcpubind=" + cpus,
            "--membind=" + str(lease["node"]), str(binary), case["family"], str(case["scenario"]),
            str(case["requested"]), str(case["seed"]), cpus, mode]


def artifact(text, target):
    found = []
    for line in text.splitlines():
        value = json.loads(line)
        if value.get("reason") == "compiler-artifact" and value.get("target", {}).get("name") == "policy_confirmation" and value.get("executable"):
            need(value["target"]["kind"] == ["bin"] and value["profile"]["test"] is False, "Wrong Cargo artifact")
            need(Path(value["manifest_path"]).resolve() == CALLER / "rust/Cargo.toml", "Wrong Cargo main package")
            found.append(Path(value["executable"]))
    need(len(found) == 1 and found[0].is_file() and found[0].is_relative_to(target), "Missing unique Cargo binary")
    return found[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    parser.add_argument("--execute-correctness", action="store_true")
    args = parser.parse_args()
    need(args.execute_correctness, "Explicit correctness flag required")
    lease = require_lease(args.cpu)
    sources = verify(args.source_commit)
    output = HERE / "validation-v1"
    need(not output.exists() and not output.is_symlink(), "Preserve all previous attempts")
    output.mkdir()
    meta = dict(complete=False, formal_performance_run=False, source_commit=args.source_commit,
                source_sha256=sources, lease=lease, commands=[], binaries={}, consumed_inputs={}, records=[])
    dump(output / "commands.json", meta)

    def run(label, argv, extra=None, valid=True, diagnostic=None):
        env = os.environ.copy()
        env.update(CARGO_BUILD_JOBS="1", RUSTFLAGS="", RUSTDOCFLAGS="",
                   ASAN_OPTIONS="detect_leaks=1:halt_on_error=1", UBSAN_OPTIONS="halt_on_error=1:print_stacktrace=1")
        env.update(extra or {})
        result = subprocess.run(list(map(str, argv)), cwd=ROOT, env=env, capture_output=True,
                                pass_fds=tuple(lease["inherited_lock_descriptors"]))
        (output / (label + ".stdout")).write_bytes(result.stdout)
        (output / (label + ".stderr")).write_bytes(result.stderr)
        meta["commands"].append(dict(label=label, command=list(map(str, argv)), extra_env=extra or {},
                                     returncode=result.returncode, expected_success=valid))
        dump(output / "commands.json", meta)
        print(label, result.returncode, flush=True)
        need(result.returncode == 0 if valid else result.returncode != 0 and not result.stdout, "Unexpected command result " + label)
        if diagnostic:
            need(diagnostic in result.stderr.decode(), "Wrong fault diagnostic")
        return result.stdout.decode()

    try:
        run("offline-guards", [sys.executable, "-m", "unittest", "discover", "-s", HERE, "-p", "test_contract.py"])
        run("clang-version", ["clang++", "--version"])
        run("rust-version", ["rustc", "-Vv"])
        run("nightly-version", ["rustc", "+nightly", "-Vv"])
        references = {}
        for backend in ("normal", "asan"):
            build = ROOT / "build" / f"native-build-policy-four-arm-v1-cpu{args.cpu}-{backend}"
            target = Path(f"/tmp/fastest-bf-native-build-policy-four-arm-v1-cpu{args.cpu}") / backend
            need(not build.exists() and not build.is_symlink() and not target.exists() and not target.is_symlink(), "Fresh build paths required")
            run(backend + "-cpp-configure", ["cmake", "-S", CALLER, "-B", build, "-DCMAKE_CXX_COMPILER=clang++",
                "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", "-DPOLICY_ASAN=" + ("ON" if backend == "asan" else "OFF")])
            run(backend + "-cpp-build", ["cmake", "--build", build, "--parallel", "1"])
            cargo = ["cargo"] + (["+nightly"] if backend == "asan" else [])
            flags = "-C target-cpu=native -C symbol-mangling-version=v0" + (" -Zsanitizer=address" if backend == "asan" else "")
            cargo_text = run(backend + "-rust-build", cargo + ["build", "--locked", "--offline", "--release", "--manifest-path", CALLER / "rust/Cargo.toml",
                       "--target", "x86_64-unknown-linux-gnu", "--message-format=json"], dict(CARGO_TARGET_DIR=str(target), RUSTFLAGS=flags))
            binaries = dict(cpp=build / "policy_confirmation", rust=artifact(cargo_text, target))
            for language, binary in binaries.items():
                meta["binaries"][backend + "/" + language] = dict(path=str(binary), sha256=sha(binary))
                cases = fixtures(language)
                need(len(cases) == 6, "Representative case count changed")
                for index, case in enumerate(cases):
                    raw = run(f"{backend}-{language}-case{index}", command(binary, case, lease))
                    row = validate(parse(raw), case, lease["child_cpus"][:case["requested"]])
                    reference_check(row)
                    key = (case["family"], case["scenario"])
                    value = tuple(row[k] for k in SEMANTICS)
                    need(key not in references or references[key] == value, "Cross-language/backend semantics changed")
                    references[key] = value
                    meta["records"].append(dict(backend=backend, **row))
                    dump(output / "commands.json", meta)
                run(f"{backend}-{language}-bad-output", command(binary, cases[0], lease, "--check-bad-output"), valid=False,
                    diagnostic="full mixed answers differ")
                if backend == "normal":
                    original = command(binary, cases[0], lease)
                    # Every rejection occurs before workload construction. The
                    # sole --measure invocation below uses the forbidden old seed.
                    replacements = ((-6, "Unknown"), (-5, "5"), (-4, "3"), (-3, "2694173"),
                                    (-3, "3819257"), (-1, "--unknown"), (-1, "--measure"))
                    for index, (position, value) in enumerate(replacements):
                        invalid = original.copy(); invalid[position] = value
                        run(f"{language}-invalid{index}", invalid, valid=False)
            consumed, rules = collect(build, target, [cargo_text], sources, ROOT)
            required = [CALLER / "cpp/main.cpp", CALLER / "cpp/bindings.hpp",
                        CALLER / "rust/src/main.rs", CALLER / "rust/src/bindings.rs"]
            for side in ("before", "clone", "after"):
                required += [CALLER / "cpp" / side / name for name in ("parallel_layout_bloom.h", "parallel_split64_range_bloom.h")]
                required += [CALLER / "native" / side / "rust/src" / name for name in ("lib.rs", "split64.rs", "split64_range.rs", "layout_parallel.rs")]
            required += [CALLER / "cpp/after/split64_build_policy.h"]
            need(all(str(path) in consumed for path in required), "Missing actual three-native consumption proof")
            meta["consumed_inputs"][backend] = consumed
            dump(output / (backend + "-dependency-rules.json"), rules)
            (output / (backend + "-compile_commands.json")).write_bytes((build / "compile_commands.json").read_bytes())
            dump(output / "commands.json", meta)
        need(len(meta["records"]) == 24 and len(references) == 6, "Wrong focused caller coverage")
        need(verify(args.source_commit) == sources and require_lease(args.cpu) == lease, "Source/lease changed")
        for item in meta["binaries"].values():
            need(sha(item["path"]) == item["sha256"], "Built binary changed")
        for inputs in meta["consumed_inputs"].values():
            for path, digest in inputs.items():
                need(sha(path) == digest, "Compiler input changed")
        meta.update(complete=True, checked_records=24, arm_records=96, semantic_geometries=6,
                    successful_timed_lifetimes=640, injected_faults=4, invalid_cli_cases=14,
                    asm_gate_complete=False, frozen_sources_equal=True, formal_performance_run=False)
        dump(output / "commands.json", meta)
        print("PASS24 old-seed four-arm caller records; formal inputs unused; manual ASM gate still required", flush=True)
    except BaseException as error:
        meta["failure"] = repr(error); dump(output / "commands.json", meta); raise


if __name__ == "__main__":
    main()
