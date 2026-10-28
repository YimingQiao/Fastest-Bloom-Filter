"""CPU2/socket0 correctness and assembly preflight only; no throughput run."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys

from source_guard import require_lease

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TARGET = "/tmp/fastest-bf-independent32-rust-singleton"


def main():
    if not __debug__:
        raise ValueError("Correctness driver requires Python without -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--resume", action="store_true", help="Reuse successful command logs after a validator-only correction")
    args = parser.parse_args()
    lease = require_lease(2)
    out = HERE / "validation"
    out.mkdir(exist_ok=True)
    metadata = (json.loads((out / "commands.json").read_text()) if args.resume
                else dict(lease=lease, timings_claimed=False, completed=[]))
    metadata["lease"] = lease
    if args.resume:
        metadata["resume_note"] = "Validator-only correction: compare complete parsed JSON values instead of Rust/C++ whitespace bytes. Compiled sources were not edited."

    def execute(name, command, separate=False):
        print(name, flush=True)
        old = next((entry for entry in metadata["completed"] if entry["name"] == name), None)
        if args.resume and name != "source-copy" and old is not None:
            if old["command"] != command or old["returncode"] != 0:
                raise SystemExit("Cannot reuse changed/failed command: " + name)
            print("reused successful log: " + name, flush=True)
            return
        if separate:
            result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
            (out / (name + ".stdout")).write_text(result.stdout)
            (out / (name + ".stderr")).write_text(result.stderr)
        else:
            with (out / (name + ".log")).open("w") as stream:
                result = subprocess.run(command, cwd=ROOT, stdout=stream, stderr=subprocess.STDOUT)
        metadata["completed"].append(dict(name=name, command=command, returncode=result.returncode))
        (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
        if result.returncode:
            raise SystemExit("Failed " + name)

    execute("format-new-tests", ["rustfmt", "--edition", "2021", str(HERE / "native/src/independent32/singleton_tests.rs")])
    execute("source-copy", [sys.executable, str(HERE / "verify_source.py")])
    for mode, feature, nightly, flags in (("normal", [], False, []), ("disable", ["--features", "disable-avx512"], False, []),
                                          ("asan", [], True, ["RUSTFLAGS=-Zsanitizer=address"])):
        common = ["env", f"CARGO_TARGET_DIR={TARGET}-{mode}", "RUST_TEST_THREADS=1", *flags, "cargo"]
        if nightly:
            common += ["+nightly"]
        target = ["--target", "x86_64-unknown-linux-gnu"] if nightly else []
        execute("native-" + mode, common + ["test", "--locked", "--lib", *target, "--manifest-path", str(HERE / "native/Cargo.toml"), *feature]
                + ([] if mode == "normal" else ["independent32::tests"]))
        execute("harness-" + mode, common + ["test", "--locked", *target, "--manifest-path", str(HERE / "benchmark/Cargo.toml"), *feature])
        parity_feature = "validation,disable-avx512" if mode == "disable" else "validation"
        execute("parity-" + mode, common + ["run", "--quiet", "--locked", *target, "--manifest-path", str(HERE / "native/Cargo.toml"),
                                            "--features", parity_feature, "--bin", "independent32-parity", "--", "--parity"], separate=True)
    reference = ROOT / "experiments/2026-10-29-independent32-native-cpp/validation/native-parity.stdout"
    parity_sha = hashlib.sha256(reference.read_bytes()).hexdigest()
    for mode in ("normal", "disable", "asan"):
        actual = out / ("parity-" + mode + ".stdout")
        if ([json.loads(line) for line in actual.read_text().splitlines()]
                != [json.loads(line) for line in reference.read_text().splitlines()]):
            raise SystemExit("C++ full-word/output mismatch: " + mode)
    (out / "parity-summary.json").write_text(json.dumps(dict(reference=str(reference.relative_to(ROOT)), sha256=parity_sha,
                                                            rows_each_mode=9, modes=["normal", "disable", "asan"], exact_parsed_values=True,
                                                            note="JSON whitespace is not part of the bitmap/output contract"), indent=2) + "\n")
    for name in ("native", "benchmark"):
        execute(name + "-clippy", ["env", f"CARGO_TARGET_DIR={TARGET}-normal", "cargo", "clippy", "--locked", "--all-targets",
                                    "--manifest-path", str(HERE / name / "Cargo.toml"), "--", "-D", "warnings"])
    execute("release-build", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0", "cargo", "build", "--locked", "--release", "--manifest-path", str(HERE / "benchmark/Cargo.toml")])
    reference_binary = "/tmp/fastest-bf-independent32-rust-screen/release/compare_benchmark"
    execute("preflight", [sys.executable, str(HERE / "check_preflight.py"), "--binary", TARGET + "/release/compare_benchmark", "--reference", reference_binary, "--cpu", "2", "--output", str(out / "preflight-results.json")])
    execute("assembly", [sys.executable, str(HERE / "audit_assembly.py"), "--binary", TARGET + "/release/compare_benchmark"])
    execute("offline-guard-tests", [sys.executable, str(HERE / "test_guard.py")])
    metadata.update(complete=True, parity_sha256=parity_sha, performance_run=False)
    (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print("PASS:CPU2 correctness/ASM preflight; no throughput results claimed", flush=True)


if __name__ == "__main__":
    main()
