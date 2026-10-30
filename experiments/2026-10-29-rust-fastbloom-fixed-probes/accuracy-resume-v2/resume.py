#!/usr/bin/env python3
"""Resume only the unperformed ASan CLI checks after Cargo path discovery."""
if not __debug__:
    raise RuntimeError("Use Python without -O")

import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
V1 = STAGE / "accuracy-validation-v1"
ACCURACY = STAGE / "accuracy"
OLD_COMMIT = "cb4b160e6f4a6a079efd1a4ccb9591f4f5bf91a6"
sys.path.insert(0, str(ACCURACY))
from contract import NAMES, need, retained_equal, validate
from source_guard import require_lease


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def blob(commit, path):
    return subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)


def test_executable(stderr):
    paths = set(re.findall(r"Running unittests .* \(([^)]+)\)", stderr))
    need(len(paths) == 1, "Require exactly one Cargo-reported test executable")
    path = Path(paths.pop()).resolve()
    target = Path("/tmp/fastest-bf-fastbloom-fixed-k-preflight/accuracy-validation-v1/asan").resolve()
    need(path.is_relative_to(target) and path.name.startswith("accuracy-") and not path.suffix,
         "Unexpected reported test executable")
    return path


def compiler_executable(stdout):
    paths = []
    for line in stdout.splitlines():
        value = json.loads(line)
        if value.get("reason") == "compiler-artifact" and value.get("target", {}).get("name") == "accuracy":
            need(value["target"]["kind"] == ["bin"] and not value["profile"]["test"], "Wrong accuracy build artifact")
            if value.get("executable"):
                paths.append(Path(value["executable"]).resolve())
    need(len(paths) == 1, "Require one structured standalone accuracy artifact")
    target = Path("/tmp/fastest-bf-fastbloom-fixed-k-preflight/accuracy-validation-v1/asan").resolve()
    need(paths[0].is_relative_to(target), "Standalone artifact outside prescribed target")
    return paths[0]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source-commit", required=True)
    p.add_argument("--output", type=Path, default=STAGE / "accuracy-validation-v2")
    args = p.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Exact committed resume source required")
    lease = require_lease(3)
    prep = HERE / "PREPARATION.json"
    need(prep.read_bytes() == blob(args.source_commit, prep), "Uncommitted resume preparation")
    prepared = json.loads(prep.read_text())
    pins = dict(prepared["inputs_sha256"])
    pins.update({str((HERE / name).relative_to(ROOT)): info["sha256"] for name, info in prepared["files"].items()})
    pins[str(prep.relative_to(ROOT))] = sha(prep)
    for name, digest in pins.items():
        path = ROOT / name
        need(sha(path) == digest and hashlib.sha256(blob(args.source_commit, path)).hexdigest() == digest,
             "Changed/uncommitted preserved resume input " + name)
    old = json.loads((V1 / "commands.json").read_text())
    need(old["source_commit"] == OLD_COMMIT and not old["complete"] and not old["formal_accuracy_run"] and not old["performance_run"], "Wrong preserved V1 state")
    need(len(old["commands"]) == 42, "Incomplete V1 command sequence")
    commands = {entry["name"]: entry for entry in old["commands"]}
    need(len(commands) == 42 and list(commands)[-2:] == ["asan-fixed-tests", "asan-accuracy-tests"], "Unexpected stopped stage")
    for entry in old["commands"]:
        need((entry["returncode"] == 0) == entry["expected_success"], "Unsuccessful retained command")
    for mode, count in [("normal", 4), ("disable", 3), ("asan", 3)]:
        need("test result: ok. 2 passed" in (V1 / (mode + "-fixed-tests.stdout")).read_text(), "Missing fixed-K success")
        need(f"test result: ok. {count} passed" in (V1 / (mode + "-accuracy-tests.stdout")).read_text(), "Missing driver success")
    for name in ["asan-fixed-tests", "asan-accuracy-tests"]:
        entry = commands[name]
        need(entry["env"] == {"CARGO_TARGET_DIR": "/tmp/fastest-bf-fastbloom-fixed-k-preflight/accuracy-validation-v1/asan", "RUSTFLAGS": "-Zsanitizer=address"}, "Changed ASan source flags")
        need(entry["command"][:3] == ["cargo", "+nightly", "test"] and "--release" in entry["command"] and
             "--locked" in entry["command"] and "--offline" in entry["command"], "Wrong retained ASan invocation")
    need(test_executable((V1 / "asan-fixed-tests.stderr").read_text()) == test_executable((V1 / "asan-accuracy-tests.stderr").read_text()), "ASan tests used different artifacts")
    reused = json.loads((HERE / "reused-asan.json").read_text())
    test_binary = test_executable((V1 / "asan-accuracy-tests.stderr").read_text())
    need(str(test_binary) == reused["recorded_cargo_test_executable"] and sha(test_binary) == reused["sha256"], "Changed exact executed ASan binary")
    need(sha(Path(reused["compiler_dependency_path"])) == reused["compiler_dependency_sha256"], "Changed ASan test dependency proof")
    binaries = dict(old["binaries_sha256"], **{str(test_binary): reused["sha256"]})

    def unchanged():
        for name, digest in old["source_sha256"].items():
            need(sha(ROOT / name) == digest and hashlib.sha256(blob(OLD_COMMIT, ROOT / name)).hexdigest() == digest, "Changed V1 compiled source")
        for dep in old["external_dependencies"]:
            for name, digest in dep["sha256"].items():
                need(sha(Path(dep["directory"]) / name) == digest, "Changed compiler dependency")
        for name, digest in binaries.items():
            need(sha(Path(name)) == digest, "Changed retained executable")
        need(sha(Path(reused["compiler_dependency_path"])) == reused["compiler_dependency_sha256"], "Retained ASan dependency file changed")
        for name, digest in pins.items():
            need(sha(ROOT / name) == digest, "Changed resume input")

    unchanged()
    expected_formal = {(f"Fastbloom017K{k}", str(1 << n), str(cap), str((1 << n) * cap), str(k), "1", str((1 << n) * cap // 8))
                       for k in range(1, 13) for n in [16, 25] for cap in [16, 24, 32]}
    formal = [line.split(",") for line in re.findall(r"FORMAL_ALLOCATION,([^\n]+)", (V1 / "normal-accuracy-tests.stdout").read_text())]
    need(len(formal) == 72 and {tuple(r) for r in formal} == expected_formal and formal == old["formal_allocation_rows"], "Formal empty allocation evidence disagrees")
    reference, rows_by_mode = {}, {}
    for cap in [16, 24, 32]:
        reference[cap] = list(csv.DictReader(io.StringIO((V1 / f"reference-{cap}.stdout").read_text())))
    for mode in ["normal", "disable"]:
        rows_by_mode[mode] = []
        for cap in [16, 24, 32]:
            rows = list(csv.DictReader(io.StringIO((V1 / f"{mode}-cli-{cap}.stdout").read_text())))
            validate(rows, 1024, cap, 4096, 42, 4096, NAMES)
            retained_equal(rows, reference[cap])
            rows_by_mode[mode].extend(rows)
        for index in range(10):
            need(not (V1 / f"{mode}-invalid-{index}.stdout").read_bytes() and (V1 / f"{mode}-invalid-{index}.stderr").read_bytes(), "Invalid retained CLI output")
    need(rows_by_mode["normal"] == rows_by_mode["disable"], "Retained mode semantic mismatch")
    args.output.mkdir(parents=True, exist_ok=False)
    metadata = dict(complete=False, formal_accuracy_run=False, performance_run=False, source_commit=args.source_commit,
        original_source_commit=OLD_COMMIT, lease=lease, reused_commands=old["commands"], reused_evidence=pins,
        source_sha256=old["source_sha256"], external_dependencies=old["external_dependencies"],
        binaries_sha256=binaries, formal_allocation_rows=formal, commands=[])
    save(args.output / "commands.json", metadata)

    def run(name, command, env=None, valid=True):
        environment = os.environ.copy()
        environment.update(CARGO_BUILD_JOBS="1", RUST_TEST_THREADS="1", RUSTFLAGS="", RUSTDOCFLAGS="",
                           ASAN_OPTIONS="detect_leaks=1:halt_on_error=1")
        environment.update(env or {})
        start = time.monotonic()
        result = subprocess.run([str(x) for x in command], cwd=ROOT, env=environment, capture_output=True)
        (args.output / (name + ".stdout")).write_bytes(result.stdout)
        (args.output / (name + ".stderr")).write_bytes(result.stderr)
        metadata["commands"].append(dict(name=name, command=[str(x) for x in command], env=env or {},
            returncode=result.returncode, elapsed_seconds=time.monotonic()-start, expected_success=valid))
        save(args.output / "commands.json", metadata)
        print(name, result.returncode, flush=True)
        if valid: need(result.returncode == 0, "Failed " + name + "; preserved")
        else: need(result.returncode != 0 and not result.stdout and result.stderr, "Invalid CLI accepted or emitted partial CSV")
        return result.stdout.decode()

    env = commands["asan-fixed-tests"]["env"]
    text = run("asan-standalone-build", ["cargo", "+nightly", "build", "--locked", "--offline", "--release",
        "--manifest-path", ACCURACY / "Cargo.toml", "--target", "x86_64-unknown-linux-gnu", "--message-format=json"], env)
    binary = compiler_executable(text)
    need(binary.is_file() and os.access(binary, os.X_OK), "Reported standalone is not executable")
    binaries[str(binary)] = sha(binary)
    rows_by_mode["asan"] = []
    for cap in [16, 24, 32]:
        text = run(f"asan-cli-{cap}", [binary, "10", str(cap), "12", "42", "12", ""])
        rows = list(csv.DictReader(io.StringIO(text)))
        validate(rows, 1024, cap, 4096, 42, 4096, NAMES)
        retained_equal(rows, reference[cap])
        rows_by_mode["asan"].extend(rows)
    need(rows_by_mode["asan"] == rows_by_mode["normal"], "ASan changed complete semantics")
    for index in range(10):
        rest = commands[f"normal-invalid-{index}"]["command"][1:]
        run(f"asan-invalid-{index}", [binary, *rest], valid=False)
    consumed = {}
    target = Path(env["CARGO_TARGET_DIR"])
    for i, path in enumerate(sorted(target.rglob("accuracy*.d"))):
        text = path.read_text()
        (args.output / f"asan-dependencies-{i}.d").write_text(text)
        for value in text.split(": ", 1)[1].splitlines()[0].split():
            source = Path(value).resolve()
            if source.is_file():
                name = str(source.relative_to(ROOT))
                need(name in old["source_sha256"] and sha(source) == old["source_sha256"][name], "Unbound compiler-consumed local source")
                consumed[name] = sha(source)
    need(str((ACCURACY / "src/driver.rs").relative_to(ROOT)) in consumed, "Missing actual standalone entry dependency")
    unchanged()
    need(require_lease(3) == lease, "Lease changed during resume")
    save(args.output / "small-fixtures.json", dict(formal_accuracy=False, timings_claimed=False,
        rows_by_mode=rows_by_mode, retained_reference_rows=reference))
    metadata.update(complete=True, source_after_equal=True, inherited_test_cases_passed=16,
        current_fixture_rows=180, retained_semantic_comparisons=72, formal_constructor_rows=72,
        malformed_cli_cases=30, consumed_local_sources=consumed)
    save(args.output / "commands.json", metadata)
    print("PASS completed focused preflight; successful V1 suites reused; no formal accuracy or timing", flush=True)


if __name__ == "__main__": main()
