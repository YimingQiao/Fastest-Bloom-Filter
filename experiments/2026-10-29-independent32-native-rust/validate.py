"""Correctness-only native Rust port validation; run inside the socket1 lock."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MANIFEST = HERE / "native/Cargo.toml"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--execute", action="store_true", required=True)
    parser.parse_args()
    if os.sched_getaffinity(0) != {3}:
        raise RuntimeError("CPU3 affinity required; parent lease and outer flock are mandatory")
    output = HERE / "validation"
    output.mkdir(exist_ok=True)
    records = []

    def command(name, args, env=None):
        started = time.monotonic()
        result = subprocess.run(args, cwd=ROOT, env={**os.environ, **(env or {})}, capture_output=True, text=True)
        (output / (name + ".stdout")).write_text(result.stdout)
        (output / (name + ".stderr")).write_text(result.stderr)
        records.append(dict(name=name, command=args, env=env or {}, returncode=result.returncode,
                            elapsed_seconds=time.monotonic()-started))
        (output / "commands.json").write_text(json.dumps(records, indent=2)+"\n")
        print(name, result.returncode, flush=True)
        if result.returncode:
            raise RuntimeError(f"{name} failed; see validation logs")
        return result.stdout

    command("format", ["rustfmt", "--edition", "2021", str(HERE / "native/src/independent32.rs"),
                        str(HERE / "native/src/independent32/tests.rs"), str(HERE / "native/src/bin/parity.rs"),
                        str(HERE / "native/src/bin/codegen.rs")])
    command("source-copy", ["python3", str(HERE / "verify_copy.py")])
    common = ["cargo", "test", "--manifest-path", str(MANIFEST), "--lib", "independent32::tests"]
    envs = {"normal": {"CARGO_TARGET_DIR": "/tmp/fastest-bf-independent32-rust/normal"},
            "disable": {"CARGO_TARGET_DIR": "/tmp/fastest-bf-independent32-rust/disable"},
            "asan": {"CARGO_TARGET_DIR": "/tmp/fastest-bf-independent32-rust/asan", "RUSTC_BOOTSTRAP": "1", "RUSTFLAGS": "-Zsanitizer=address"}}
    command("normal-tests", common + ["--features", "validation"], envs["normal"])
    command("disable-tests", common + ["--features", "validation,disable-avx512"], envs["disable"])
    command("asan-tests", common + ["--target", "x86_64-unknown-linux-gnu", "--features", "validation"], envs["asan"])
    command("clippy", ["cargo", "clippy", "--manifest-path", str(MANIFEST), "--all-targets", "--features", "validation", "--", "-D", "warnings"], envs["normal"])
    reference = ROOT / "experiments/2026-10-29-independent32-native-cpp/validation/native-parity.stdout"
    expected = [json.loads(line) for line in reference.read_text().splitlines()]
    for name in ("normal", "disable", "asan"):
        args = ["cargo", "run", "--quiet", "--manifest-path", str(MANIFEST), "--features",
                "validation,disable-avx512" if name == "disable" else "validation", "--bin", "independent32-parity"]
        if name == "asan":
            args += ["--target", "x86_64-unknown-linux-gnu"]
        actual = [json.loads(line) for line in command(name+"-parity", args + ["--", "--parity"], envs[name]).splitlines()]
        if actual != expected:
            raise RuntimeError(name + " full C++/Rust bitmap/output fixture differs")
    codegen = {"CARGO_TARGET_DIR": "/tmp/fastest-bf-independent32-rust/codegen",
               "RUSTFLAGS": "-C target-cpu=native -C symbol-mangling-version=v0"}
    command("codegen-build", ["cargo", "build", "--release", "--manifest-path", str(MANIFEST), "--features", "validation", "--bin", "independent32-codegen"], codegen)
    binary = Path(codegen["CARGO_TARGET_DIR"]) / "release/independent32-codegen"
    command("codegen-semantic-smoke", [str(binary)])
    command("codegen-prehashed-assembly", ["objdump", "-d", "-C", "--no-show-raw-insn", "--disassemble=independent32_public_prehashed", str(binary)])
    command("codegen-fused-assembly", ["objdump", "-d", "-C", "--no-show-raw-insn", "--disassemble=independent32_public_fused", str(binary)])
    command("normal-full-library-tests", ["cargo", "test", "--manifest-path", str(MANIFEST), "--lib", "--features", "validation"], envs["normal"])
    summary = dict(correctness_only=True, performance_run=False, tests_per_build=5,
                   builds=list(envs), cpp_rust_full_fixture_rows=9,
                   cpp_reference=str(reference.relative_to(ROOT)),
                   cpp_reference_sha256=hashlib.sha256(reference.read_bytes()).hexdigest(),
                   codegen_binary=str(binary), codegen_binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
                   full_normal_library_tests=True,
                   complete=True)
    (output / "summary.json").write_text(json.dumps(summary, indent=2)+"\n")
    print("PASS: normal/disable/ASan full oracle and all nine C++/Rust bitmap/output rows; no timing", flush=True)


if __name__ == "__main__":
    main()
