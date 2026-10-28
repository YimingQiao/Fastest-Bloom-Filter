#!/usr/bin/env python3
"""Run only under an explicitly leased socket flock; does not measure throughput."""
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
MANIFEST = str(ROOT / "Cargo.toml")
TARGET = "/tmp/fastest-bf-rust-sbbf-external"
OUT = ROOT / "validation"


def main():
    if os.environ.get("BF_SOCKET_LEASE") != "socket1-cpu3":
        raise SystemExit("Use the agreed socket1 lease and flock; set BF_SOCKET_LEASE=socket1-cpu3")
    OUT.mkdir(exist_ok=True)
    commands = [
        ("fmt.log", ["cargo", "fmt", "--manifest-path", MANIFEST]),
        ("normal-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST]),
        ("disable-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-disable", "RUST_TEST_THREADS=1", "cargo", "test", "--locked", "--manifest-path", MANIFEST, "--features", "disable-avx512"]),
        ("asan-tests.log", ["env", f"CARGO_TARGET_DIR={TARGET}-asan", "RUST_TEST_THREADS=1", "RUSTFLAGS=-Zsanitizer=address", "cargo", "+nightly", "test", "--locked", "--target", "x86_64-unknown-linux-gnu", "--manifest-path", MANIFEST]),
        ("clippy.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "cargo", "clippy", "--locked", "--all-targets", "--manifest-path", MANIFEST, "--", "-D", "warnings"]),
        ("release-build.log", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUSTFLAGS=-C target-cpu=native", "cargo", "build", "--locked", "--release", "--manifest-path", MANIFEST]),
        ("cli.log", [sys.executable, str(ROOT / "check_cli.py"), "--binary", f"{TARGET}/release/compare_benchmark", "--cpu", "3", "--output", str(OUT / "cli-results.json")]),
    ]
    metadata = dict(cpu=3, affinity=sorted(os.sched_getaffinity(0)),
                    flock="/tmp/fastest-bf-socket1.lock", timings_claimed=False,
                    commands=commands, completed=[])
    for name, cmd in commands:
        print(name, flush=True)
        with (OUT / name).open("w") as output:
            result = subprocess.run(cmd, cwd=REPO, stdout=output, stderr=subprocess.STDOUT)
        metadata["completed"].append(dict(log=name, returncode=result.returncode))
        (OUT / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
        if result.returncode:
            raise SystemExit(f"Failed: {name}; preserved command and log")
    print("Correctness and smoke completed; throughput remains unmeasured", flush=True)


if __name__ == "__main__":
    main()
