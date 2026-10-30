#!/usr/bin/env python3
"""Reproduce correctness only; invoke after an explicit matching socket lease."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
MANIFEST = str(HERE / "benchmark/Cargo.toml")
TARGET = "/tmp/fastest-bf-rust-leaf-inline"
REFERENCE = "/tmp/fastest-bf-rust-visible-single/release/compare_benchmark"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = parser.parse_args()
    socket = args.cpu - 2
    if os.environ.get("BF_SOCKET_LEASE") != f"socket{socket}-cpu{args.cpu}" or os.sched_getaffinity(0) != {args.cpu}:
        raise SystemExit("Requires the explicit matching socket lease/flock and CPU affinity")
    out = HERE / "validation"
    out.mkdir(exist_ok=True)
    commands = [
        ("source-diff.log", [sys.executable, str(HERE / "verify_copy.py")]),
        ("fmt.log", ["cargo", "fmt", "--manifest-path", MANIFEST]),
        ("native-normal-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-native", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--lib", "--manifest-path", str(HERE / "native/Cargo.toml")]),
        ("native-disable-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-native-disable", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--lib", "--manifest-path", str(HERE / "native/Cargo.toml"), "--features", "disable-avx512"]),
        ("native-asan-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-native-asan", "RUST_TEST_THREADS=1", "RUSTFLAGS=-Zsanitizer=address", "cargo", "+nightly", "test", "--locked", "--lib", "--target", "x86_64-unknown-linux-gnu", "--manifest-path", str(HERE / "native/Cargo.toml")]),
        ("normal-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST]),
        ("disable-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-disable", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST, "--features", "disable-avx512"]),
        ("asan-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-asan", "RUST_TEST_THREADS=1", "RUSTFLAGS=-Zsanitizer=address", "cargo", "+nightly", "test", "--locked", "--target", "x86_64-unknown-linux-gnu", "--manifest-path", MANIFEST]),
        ("clippy.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "cargo", "clippy", "--locked", "--all-targets", "--manifest-path", MANIFEST, "--", "-D", "warnings"]),
        ("release-build.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0", "cargo", "build", "--locked", "--release", "--manifest-path", MANIFEST]),
        ("preflight.log", [sys.executable, str(HERE / "check_preflight.py"), "--binary", f"{TARGET}/release/compare_benchmark", "--reference", REFERENCE, "--cpu", str(args.cpu), "--output", str(out / "preflight-results.json")]),
        ("assembly.log", [sys.executable, str(HERE / "audit_assembly.py"), "--binary", f"{TARGET}/release/compare_benchmark"]),
    ]
    metadata = dict(cpu=args.cpu, socket_lock=f"/tmp/fastest-bf-socket{socket}.lock", timings_claimed=False, commands=commands, completed=[])
    for name, command in commands:
        print(name, flush=True)
        with (out / name).open("w") as log:
            result = subprocess.run(command, cwd=REPO, stdout=log, stderr=subprocess.STDOUT)
        metadata["completed"].append(dict(log=name, returncode=result.returncode))
        (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
        if result.returncode:
            raise SystemExit("Failed " + name)
    subprocess.run([sys.executable, str(HERE / "verify_copy.py")], cwd=REPO, check=True)
    print("Validation complete; no throughput result claimed", flush=True)


if __name__ == "__main__":
    main()
