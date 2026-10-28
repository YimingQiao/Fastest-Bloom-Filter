"""Correctness/ASM only; requires the authorized inherited socket1 flock."""
import json
import os
from pathlib import Path
import subprocess
import sys

from source_guard import require_lease

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MANIFEST = str(HERE / "benchmark/Cargo.toml")
TARGET = "/tmp/fastest-bf-independent32-rust-screen"


def main():
    if not __debug__:
        raise ValueError("Correctness driver requires Python without -O")
    lease = require_lease(3)
    protocol = json.loads((HERE / "protocol.json").read_text())
    out = HERE / "validation"
    out.mkdir(exist_ok=True)
    commands = [
        ("source-copy.log", [sys.executable, str(HERE / "verify_source.py")]),
        ("normal-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST]),
        ("disable-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-disable", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST, "--features", "disable-avx512"]),
        ("asan-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-asan", "RUST_TEST_THREADS=1", "RUSTFLAGS=-Zsanitizer=address", "cargo", "+nightly", "test", "--locked", "--target", "x86_64-unknown-linux-gnu", "--manifest-path", MANIFEST]),
        ("clippy.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "cargo", "clippy", "--locked", "--all-targets", "--manifest-path", MANIFEST, "--", "-D", "warnings"]),
        ("release-build.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0", "cargo", "build", "--locked", "--release", "--manifest-path", MANIFEST]),
        ("preflight.log", [sys.executable, str(HERE / "check_preflight.py"), "--binary", f"{TARGET}/release/compare_benchmark", "--reference", protocol["reference_binary"], "--cpu", "3", "--output", str(out / "preflight-results.json")]),
        ("assembly.log", [sys.executable, str(HERE / "audit_assembly.py"), "--binary", f"{TARGET}/release/compare_benchmark"]),
        ("offline-guard-tests.log", [sys.executable, str(HERE / "test_guard.py")]),
    ]
    metadata = dict(lease=lease, timings_claimed=False, commands=commands, completed=[])
    for name, command in commands:
        print(name, flush=True)
        with (out / name).open("w") as log:
            result = subprocess.run(command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT)
        metadata["completed"].append(dict(log=name, returncode=result.returncode))
        (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
        if result.returncode:
            raise SystemExit("Failed " + name)
    print("PASS: correctness/ASM preflight; no throughput results claimed", flush=True)


if __name__ == "__main__":
    main()
