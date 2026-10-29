#!/usr/bin/env python3
"""Focused correctness only, after committed source and an explicit CPU3 lease."""
if not __debug__:
    raise RuntimeError("Use Python without -O before any compilation or filter execution")

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

from contract import NAMES, need, retained_equal, validate
from source_guard import require_lease

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
INITIAL = "bbc3474cdd15b2e3301384dff4afdc12505cbfe9"
PARENT = "2c7b1668880ab5a1e3ea0c73f2034b89da0d8650"
PARENT_DIR = ROOT / "experiments/2026-10-29-split64-range-rust-screen"
REFERENCE = Path("/tmp/fastest-bf-split64-range-rust/release/compare_benchmark")
REFERENCE_SHA = "448ca811711c2ea29654208b18bc8d9f58ed876555f371aac147d787257a7a23"
TARGET = Path("/tmp/fastest-bf-fastbloom-fixed-k-preflight")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, obj):
    path.write_text(json.dumps(obj, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, default=STAGE / "accuracy-validation-v1")
    args = parser.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full source commit required")
    lease = require_lease(3)
    target_root = TARGET / args.output.name
    need(not target_root.exists(), "Use a fresh versioned output/target directory; preserve earlier binaries")
    sources = {}
    for directory, manifest in [(STAGE, "PREPARATION.json"), (HERE, "PREPARATION.json")]:
        for name, info in json.loads((directory / manifest).read_text())["files"].items():
            sources[str((directory / name).relative_to(ROOT))] = info["sha256"]
        sources[str((directory / manifest).relative_to(ROOT))] = sha(directory / manifest)
    parent_path = PARENT_DIR / "screening/freeze.json"
    parent_bytes = subprocess.check_output(["git", "show", PARENT + ":" + str(parent_path.relative_to(ROOT))], cwd=ROOT)
    need(parent_path.read_bytes() == parent_bytes, "Changed immutable parent descriptor")
    parent = json.loads(parent_bytes)
    for name, digest in parent["source_sha256"].items():
        need(name not in sources or sources[name] == digest, "Conflicting consumed source pin")
        sources[name] = digest
    dependencies = parent["external_dependencies"]

    def unchanged():
        for name, digest in sources.items():
            need(sha(ROOT / name) == digest, "Changed consumed source " + name)
        for dep in dependencies:
            for name, digest in dep["sha256"].items():
                need(sha(Path(dep["directory"]) / name) == digest, "Changed external dependency")
        need(sha(REFERENCE) == REFERENCE_SHA, "Changed immutable reference binary")

    unchanged()
    for name, digest in sources.items():
        blob = subprocess.check_output(["git", "show", args.source_commit + ":" + name], cwd=ROOT)
        need(hashlib.sha256(blob).hexdigest() == digest, "Uncommitted consumed source " + name)
    args.output.mkdir(parents=True, exist_ok=False)
    metadata = dict(complete=False, formal_accuracy_run=False, performance_run=False,
        source_commit=args.source_commit, initial_commit=INITIAL, parent_commit=PARENT,
        lease=lease, affinity=sorted(os.sched_getaffinity(0)), numa_policy="CPU3 pin only; no explicit memory binding",
        source_sha256=sources, external_dependencies=dependencies,
        binaries_sha256={str(REFERENCE): REFERENCE_SHA}, commands=[])
    save(args.output / "commands.json", metadata)

    def run(name, command, env=None, valid=True):
        environment = os.environ.copy()
        environment.update(CARGO_BUILD_JOBS="1", RUST_TEST_THREADS="1", RUSTFLAGS="", RUSTDOCFLAGS="",
                           ASAN_OPTIONS="detect_leaks=1:halt_on_error=1")
        environment.update(env or {})
        start = time.monotonic()
        result = subprocess.run([str(v) for v in command], cwd=ROOT, env=environment, capture_output=True)
        (args.output / (name + ".stdout")).write_bytes(result.stdout)
        (args.output / (name + ".stderr")).write_bytes(result.stderr)
        metadata["commands"].append(dict(name=name, command=[str(v) for v in command], env=env or {},
            returncode=result.returncode, elapsed_seconds=time.monotonic()-start, expected_success=valid))
        save(args.output / "commands.json", metadata)
        print(name, result.returncode, flush=True)
        if valid:
            need(result.returncode == 0, "Failed " + name + "; exact attempt retained")
        else:
            need(result.returncode != 0 and not result.stdout and result.stderr,
                 "Invalid CLI emitted partial output or succeeded")
        return result.stdout.decode()

    run("initial-source", [sys.executable, STAGE / "verify_source.py"])
    run("additive-source", [sys.executable, HERE / "verify_source.py"])
    run("offline-contract-tests", [sys.executable, "-m", "unittest", "discover", "-s", HERE, "-p", "test_*.py"])
    run("rustc", ["rustc", "-Vv"])
    run("nightly-rustc", ["rustc", "+nightly", "-Vv"])
    old = {}
    for cap in [16, 24, 32]:
        text = run(f"reference-{cap}", [REFERENCE, "10", str(cap), "50", "12", "4096", "4", "42", ",".join(NAMES[:8]), "1024", "12"])
        old[cap] = list(csv.DictReader(io.StringIO(text)))
    first = None
    records = []
    for mode in ["normal", "disable", "asan"]:
        cargo = ["cargo"] + (["+nightly"] if mode == "asan" else [])
        target = ["--target", "x86_64-unknown-linux-gnu"] if mode == "asan" else []
        feature = ["--features", "disable-avx512"] if mode == "disable" else []
        flags = "-Zsanitizer=address" if mode == "asan" else ""
        env = dict(CARGO_TARGET_DIR=str(target_root / mode), RUSTFLAGS=flags)
        common = ["--locked", "--offline", "--release", "--manifest-path", HERE / "Cargo.toml", *target, *feature]
        text = run(mode + "-fixed-tests", cargo + ["test", *common, "fixed_probe_tests", "--", "--test-threads=1"], env)
        need("test result: ok. 2 passed" in text, "Missing new fixed-K tests")
        skip = [] if mode == "normal" else ["--skip", "every_formal_fixed_k_constructor_reports_observed_bits_hashes_and_backing"]
        text = run(mode + "-accuracy-tests", cargo + ["test", *common, "accuracy_tests", "--", "--test-threads=1", "--nocapture", *skip], env)
        need(f"test result: ok. {4 if mode == 'normal' else 3} passed" in text, "Missing focused driver/fault tests")
        if mode == "normal":
            actual = [line.split(",") for line in re.findall(r"FORMAL_ALLOCATION,([^\n]+)", text)]
            expected = {(f"Fastbloom017K{k}", str(1 << n), str(cap), str((1 << n) * cap), str(k), "1", str((1 << n) * cap // 8))
                        for k in range(1, 13) for n in [16, 25] for cap in [16, 24, 32]}
            need(len(actual) == 72 and {tuple(row) for row in actual} == expected, "Incomplete72 formal constructor observations")
            metadata["formal_allocation_rows"] = actual
        suffix = "x86_64-unknown-linux-gnu" if mode == "asan" else ""
        test_dir = target_root / mode / suffix / "release/deps"
        test_binaries = [path for path in test_dir.glob("accuracy-*") if path.is_file() and not path.suffix and os.access(path, os.X_OK)]
        need(test_binaries, "Focused correctness executable was not retained")
        for path in test_binaries:
            metadata["binaries_sha256"][str(path)] = sha(path)
        # Native accuracy matches the old screen's release target. The disabled
        # and ASan builds keep generic auto-vectorization plus runtime dispatch.
        build_env = dict(env, RUSTFLAGS="-C target-cpu=native -C symbol-mangling-version=v0") if mode == "normal" else env
        run(mode + "-build", cargo + ["build", *common], build_env)
        binary = target_root / mode / suffix / "release/accuracy"
        metadata["binaries_sha256"][str(binary)] = sha(binary)
        current = []
        for cap in [16, 24, 32]:
            text = run(f"{mode}-cli-{cap}", [binary, "10", str(cap), "12", "42", "12", ""])
            rows = list(csv.DictReader(io.StringIO(text)))
            validate(rows, 1024, cap, 4096, 42, 4096, NAMES)
            retained_equal(rows, old[cap])
            current.extend(rows)
        need(first is None or current == first, "Backend changed complete row semantics")
        first = current
        records.extend(dict(mode=mode, **row) for row in current)
        invalid = [["10", "8", "12", "42", "12", ""], ["0", "16", "12", "42", "12", ""],
            ["10", "16", "11", "42", "12", ""], ["10", "16", "12", "42", "0", ""],
            ["10", "16", "12", "42", "12", "Fastbloom017K13"],
            ["10", "16", "12", "42", "12", "Fastbloom017K1,"],
            ["10", "16", "12", "42", "12", "Fastbloom017K1,Fastbloom017K1"],
            ["10", "16", "12", "42", "12", "Fastbloom017K1,missing"],
            ["10", "16", "12", "42", "12"], ["10", "16", "12", "42", "12", "", "extra"]]
        for index, rest in enumerate(invalid):
            run(f"{mode}-invalid-{index}", [binary, *rest], valid=False)
        dep_path = binary.with_suffix(".d")
        need(dep_path.exists(), "Missing accuracy compiler dependency file")
        (args.output / (mode + "-accuracy.d")).write_bytes(dep_path.read_bytes())
        consumed = []
        for value in dep_path.read_text().split(": ", 1)[1].splitlines()[0].split():
            path = Path(value).resolve()
            if path.is_file():
                name = str(path.relative_to(ROOT))
                need(name in sources and sha(path) == sources[name], "Unfrozen compiler-consumed local source " + name)
                consumed.append(name)
        need(consumed and str((HERE / "src/driver.rs").relative_to(ROOT)) in consumed, "Actual accuracy entry absent from compiler dependencies")
        metadata.setdefault("consumed_local_sources", {})[mode] = consumed
        save(args.output / "commands.json", metadata)
    unchanged()
    for path, digest in metadata["binaries_sha256"].items():
        need(sha(Path(path)) == digest, "Binary changed during correctness")
    save(args.output / "small-fixtures.json", dict(formal_accuracy=False, timings_claimed=False,
        cases=9, rows=records, retained_reference_rows=old))
    metadata.update(complete=True, source_after_equal=True, modes=3, current_fixture_rows=180,
        retained_semantic_comparisons=72, formal_constructor_rows=72, malformed_cli_cases=30,
        selected_timing_performed=False)
    save(args.output / "commands.json", metadata)
    print("PASS focused correctness only; no formal FPR grid or performance run", flush=True)


if __name__ == "__main__":
    main()
