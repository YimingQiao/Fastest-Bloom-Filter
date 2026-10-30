#!/usr/bin/env python3
"""Correctness/assembly only, after a reviewed commit and explicit CPU3 lease."""
import argparse
import csv
import hashlib
import io
import itertools
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time

from checks import NAMES, RANGE, require, validate_cli, validate_dense, validate_old_rows
from source_guard import require_lease

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
INITIAL = "d93d45c6cf09e8da687981fa77bb01b5fecbda70"
REFERENCE = Path("/tmp/fastest-bf-independent32-rust-singleton/release/compare_benchmark")
REFERENCE_SHA = "4f2395141ed9a893f74abed06aa3548c33d958117f5ec56aab6cb3b7e29fe16c"
TARGET = Path("/tmp/fastest-bf-split64-range-rust-preflight")
RELEASE = Path("/tmp/fastest-bf-split64-range-rust")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, obj):
    path.write_text(json.dumps(obj, indent=2) + "\n")


def main():
    require(__debug__, "Run preflight without Python -O")
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source-commit", required=True)
    p.add_argument("--output", type=Path, default=STAGE / "validation-v1")
    args = p.parse_args()
    require(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full source commit required")
    lease = require_lease(3)
    initial = json.loads((STAGE / "manifest.json").read_text())["files"]
    initial["manifest.json"] = sha(STAGE / "manifest.json")
    additive = json.loads((HERE / "PREPARATION.json").read_text())["files"]
    inputs = {str((STAGE / name).relative_to(ROOT)): digest for name, digest in initial.items()}
    inputs.update({str((HERE / name).relative_to(ROOT)): digest for name, digest in additive.items()})
    inputs[str((HERE / "PREPARATION.json").relative_to(ROOT))] = sha(HERE / "PREPARATION.json")
    for path, digest in inputs.items():
        require(sha(ROOT / path) == digest, "Changed prepared source: " + path)
        blob = subprocess.check_output(["git", "show", args.source_commit + ":" + path], cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest() == digest, "Uncommitted prepared source: " + path)
    for name, digest in initial.items():
        blob = subprocess.check_output(["git", "show", INITIAL + ":" + str((STAGE / name).relative_to(ROOT))], cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest() == digest, "Changed initial committed artifact: " + name)
    require(sha(REFERENCE) == REFERENCE_SHA, "Changed retained-reference executable")
    parent_freeze = ROOT / "experiments/2026-10-29-independent32-rust-singleton-screen/validation/freeze.json"
    dependencies = json.loads(parent_freeze.read_text())["external_dependencies"]
    def verify_dependencies():
        for dependency in dependencies:
            for name, digest in dependency["sha256"].items():
                require(sha(Path(dependency["directory"]) / name) == digest, "Changed pinned dependency")
    verify_dependencies()
    args.output.mkdir(parents=True, exist_ok=False)
    metadata = dict(complete=False, performance_run=False, source_commit=args.source_commit,
                    initial_source_commit=INITIAL, lease=lease, affinity=sorted(os.sched_getaffinity(0)),
                    numa_policy="CPU3 affinity only; no explicit NUMA memory binding", inputs_sha256=inputs,
                    external_dependencies=dependencies, commands=[], binaries_sha256={str(REFERENCE): REFERENCE_SHA})
    save(args.output / "commands.json", metadata)

    def run(name, command, env=None):
        environment = os.environ.copy()
        environment.update(CARGO_BUILD_JOBS="1", RUST_TEST_THREADS="1", RUSTFLAGS="", RUSTDOCFLAGS="")
        environment.update(env or {})
        started = time.monotonic()
        result = subprocess.run([str(x) for x in command], cwd=ROOT, env=environment, capture_output=True)
        (args.output / (name + ".stdout")).write_bytes(result.stdout)
        (args.output / (name + ".stderr")).write_bytes(result.stderr)
        metadata["commands"].append(dict(name=name, command=[str(x) for x in command], env=env or {},
                                         returncode=result.returncode, seconds=time.monotonic()-started))
        save(args.output / "commands.json", metadata)
        print(name, result.returncode, flush=True)
        require(result.returncode == 0, "Failed " + name + "; logs preserved")
        return result.stdout.decode()

    run("initial-source", [sys.executable, STAGE / "verify_source.py"])
    run("additive-source", [sys.executable, HERE / "verify_preparation.py"])
    run("guard-tests", [sys.executable, "-m", "unittest", "discover", "-s", HERE, "-p", "test_*.py"])
    run("rustc", ["rustc", "-Vv"])
    run("nightly-rustc", ["rustc", "+nightly", "-Vv"])
    cpp = ROOT / "experiments/2026-10-29-split64-range-native/validation-v1/cpp-native-parity.stdout"
    require(sha(cpp) == "511faca6e2b3933b5cf607e3b753e803be7877d03f9b7bda2bb8c90d5531f075", "Changed12-fixture C++ oracle")
    expected_cpp = [json.loads(line) for line in cpp.read_text().splitlines()]
    require(len(expected_cpp) == 12, "Wrong C++ fixture count")
    first_dense = None
    for mode in ("normal", "disable", "asan"):
        cargo = ["cargo"] + (["+nightly"] if mode == "asan" else [])
        target = ["--target", "x86_64-unknown-linux-gnu"] if mode == "asan" else []
        features = ["--features", "disable-avx512"] if mode == "disable" else []
        # Generic-target tests still exercise runtime SIMD helpers. This avoids
        # enabling AVX512 auto-vectorization in the disabled-dispatch test build.
        flags = "-Zsanitizer=address" if mode == "asan" else ""
        env = dict(CARGO_TARGET_DIR=str(TARGET / mode), RUSTFLAGS=flags)
        native = run("native-" + mode, cargo + ["test", "--locked", "--offline", "--lib", *target,
                     "--manifest-path", STAGE / "native/Cargo.toml", *features, "--", "--test-threads=1"], env)
        passed = re.search(r"test result: ok\. (\d+) passed", native)
        require(passed is not None and int(passed[1]) >= 34, "Incomplete full native suite")
        run("harness-" + mode, cargo + ["test", "--locked", "--offline", *target,
            "--manifest-path", STAGE / "benchmark/Cargo.toml", *features, "--", "--test-threads=1"], env)
        fixture_features = "validation,disable-avx512" if mode == "disable" else "validation"
        fixture = run("range-fixture-" + mode, cargo + ["run", "--quiet", "--locked", "--offline", *target,
                      "--manifest-path", STAGE / "native/Cargo.toml", "--features", fixture_features, "--example", "parity"], env)
        require([json.loads(line) for line in fixture.splitlines()] == expected_cpp, "Full C++/Rust fixture mismatch")
        suffix = Path("x86_64-unknown-linux-gnu") if mode == "asan" else Path()
        fixture_binary = TARGET / mode / suffix / "debug/examples/parity"
        metadata["binaries_sha256"][str(fixture_binary)] = sha(fixture_binary)
        dense = {}
        for kind in ("current", "reference"):
            text = run("dense-" + kind + "-" + mode, cargo + ["run", "--quiet", "--locked", "--offline", "--release", *target,
                       "--manifest-path", HERE / ("audit-" + kind) / "Cargo.toml", *features],
                       dict(env, CARGO_TARGET_DIR=str(TARGET / (mode + "-" + kind))))
            dense[kind] = [json.loads(line) for line in text.splitlines()]
            audit_binary = TARGET / (mode + "-" + kind) / suffix / "release/dense_dump"
            metadata["binaries_sha256"][str(audit_binary)] = sha(audit_binary)
        counts = validate_dense(dense["current"], dense["reference"])
        require(first_dense is None or dense == first_dense, "Backend mode changed full fixture answers")
        first_dense = dense
        metadata.setdefault("dense_comparisons", {})[mode] = counts
    env = dict(CARGO_TARGET_DIR=str(TARGET / "normal"), RUSTFLAGS="-C target-cpu=native")
    for family in ("native", "benchmark"):
        run(family + "-clippy", ["cargo", "clippy", "--locked", "--offline", "--all-targets",
            "--manifest-path", STAGE / family / "Cargo.toml", *( ["--features", "validation"] if family == "native" else []), "--", "-D", "warnings"], env)
    run("release-build", ["cargo", "build", "--locked", "--offline", "--release", "--manifest-path", STAGE / "benchmark/Cargo.toml"],
        dict(CARGO_TARGET_DIR=str(RELEASE), RUSTFLAGS="-C target-cpu=native -C symbol-mangling-version=v0"))
    binary = RELEASE / "release/compare_benchmark"
    binary_sha = sha(binary)
    source = (STAGE / "benchmark/src/main.rs").read_text()
    cli_records = []
    for cap, hit, batch in itertools.product((16, 24, 32), (0, 50, 100), (1, 31, 4096)):
        rest = ["10", str(cap), str(hit), "12", str(batch), "4", "42", ",".join(sorted(NAMES)), "1024", "12"]
        text = run(f"cli-p{cap}-h{hit}-b{batch}", [binary, *rest])
        rows = list(csv.DictReader(io.StringIO(text)))
        validate_cli(rows, source, 10, cap, hit, batch)
        cli_records.extend(rows)
        if cap != 24:
            old_args = list(rest)
            old_args[1], old_args[7] = str(cap // 2), ",".join(sorted(NAMES - {RANGE}))
            old = run(f"reference-p{cap}-h{hit}-b{batch}", [REFERENCE, *old_args])
            validate_old_rows(rows, list(csv.DictReader(io.StringIO(old))))
    invalid = [("10", "8", "1", "4", "FastPatternBF"), ("10", "24", "0", "4", "FastPatternBF"),
               ("10", "24", "1", "5", "FastPatternBF"), ("5", "16", "1", "4", "FastPatternBF"),
               ("10", "24", "1", "4", "Split64Range"), ("10", "24", "1", "4", "FastPatternBF,missing"),
               ("10", "24", "1", "4", "FastPatternBF,FastPatternBF"), ("10", "24", "1", "4", "FastPatternBF,")]
    for index, (power, cap, batch, reps, names) in enumerate(invalid):
        command = [str(binary), power, cap, "50", "12", batch, reps, "42", names]
        result = subprocess.run(command, capture_output=True)
        (args.output / f"invalid-{index}.stdout").write_bytes(result.stdout)
        (args.output / f"invalid-{index}.stderr").write_bytes(result.stderr)
        require(result.returncode != 0 and not result.stdout and result.stderr, "Invalid CLI accepted/emitted partial CSV")
        metadata.setdefault("invalid_commands", []).append(dict(command=command, returncode=result.returncode))
    save(args.output / "cli-results.json", dict(timings_claimed=False, current_cases=27, current_rows=216, retained_reference_cases=18, retained_semantic_rows=126, rows=cli_records))
    run("assembly", [sys.executable, HERE / "audit_assembly.py", "--binary", binary, "--output", args.output / "assembly"])
    require(sha(binary) == binary_sha and sha(REFERENCE) == REFERENCE_SHA, "Changed executable during preflight")
    verify_dependencies()
    for path, digest in metadata["binaries_sha256"].items():
        require(sha(Path(path)) == digest, "Correctness executable changed during preflight")
    for path, digest in inputs.items():
        require(sha(ROOT / path) == digest, "Source changed during preflight")
    metadata["binaries_sha256"][str(binary)] = binary_sha
    metadata.update(complete=True, source_after_equal=True, cpp_fixture_sha256=sha(cpp), cpp_fixtures=12,
                    current_cli_rows=216, retained_cli_semantic_rows=126, invalid_cli_cases=8,
                    assembly_requires_manual_review=True)
    save(args.output / "commands.json", metadata)
    print("PASS correctness and actual16 public loop capture; no performance matrix executed", flush=True)


if __name__ == "__main__":
    main()
