"""CPU3 correctness and assembly preflight. No performance matrix."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tomllib

from source_guard import require_lease

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TARGET = "/tmp/fastest-bf-independent32-rust-scalar-inline"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__:
        raise ValueError("Do not disable preflight assertions")
    lease = require_lease(3)
    out = HERE / "validation-v2"
    out.mkdir(exist_ok=False)
    inputs = {}
    visited = set()

    def crate(directory):
        directory = directory.resolve()
        if directory in visited:
            return
        visited.add(directory)
        for path in directory.rglob("*"):
            if path.is_file() and (path.suffix == ".rs" or path.name in ("Cargo.toml", "Cargo.lock")):
                inputs[str(path.relative_to(ROOT))] = sha(path)
        manifest = tomllib.loads((directory / "Cargo.toml").read_text())
        for dependency in manifest.get("dependencies", {}).values():
            if isinstance(dependency, dict) and "path" in dependency:
                crate(directory / dependency["path"])

    crate(HERE / "benchmark")
    for path in HERE.glob("*.py"):
        inputs[str(path.relative_to(ROOT))] = sha(path)
    reference = Path("/tmp/fastest-bf-independent32-rust-singleton/release/compare_benchmark")
    expected_reference = "4f2395141ed9a893f74abed06aa3548c33d958117f5ec56aab6cb3b7e29fe16c"
    assert sha(reference) == expected_reference
    previous = HERE / "validation-v1"
    earlier = json.loads((previous / "commands.json").read_text())
    for path, digest in earlier["inputs_sha256"].items():
        if path.endswith(".rs") or path.endswith("Cargo.toml") or path.endswith("Cargo.lock"):
            assert inputs[path] == digest, "Changed compiled input: " + path
    metadata = dict(lease=lease, inputs_sha256=inputs, completed=[], performance_run=False,
                    previous_commands_sha256=sha(previous / "commands.json"),
                    correction="Copy missing unchanged SBBF/support modules; no previously compiled source changed. Reuse only successful native-normal result.")

    def execute(name, command, separate=False):
        print(name, flush=True)
        if name == "native-normal":
            old = next(item for item in earlier["completed"] if item["name"] == name)
            assert old["command"] == command and old["returncode"] == 0
            logs = {str((previous / (name + suffix)).relative_to(ROOT)): sha(previous / (name + suffix)) for suffix in (".stdout", ".stderr")}
            metadata["completed"].append(dict(old, reused_logs_sha256=logs))
            print("Reused unchanged native-normal:36 tests passed", flush=True)
            return
        environment = os.environ.copy()
        environment["RUST_TEST_THREADS"] = "1"
        result = subprocess.run(command, cwd=ROOT, env=environment, capture_output=True)
        (out / (name + ".stdout")).write_bytes(result.stdout)
        (out / (name + ".stderr")).write_bytes(result.stderr)
        metadata["completed"].append(dict(name=name, command=command, returncode=result.returncode))
        (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
        if result.returncode:
            raise SystemExit("Failed " + name + "; retained stdout/stderr")

    execute("source-copy", [sys.executable, str(HERE / "verify_source.py")])
    for mode, feature, nightly, flags in (
        ("normal", [], False, []),
        ("disable", ["--features", "disable-avx512"], False, []),
        ("asan", [], True, ["RUSTFLAGS=-Zsanitizer=address"]),
    ):
        common = ["env", f"CARGO_TARGET_DIR={TARGET}-{mode}", *flags, "cargo"]
        if nightly:
            common += ["+nightly"]
        target = ["--target", "x86_64-unknown-linux-gnu"] if nightly else []
        execute("native-" + mode, common + ["test", "--locked", "--lib", *target, "--manifest-path", str(HERE / "native/Cargo.toml"), *feature]
                + ([] if mode == "normal" else ["independent32::tests"]))
        execute("harness-" + mode, common + ["test", "--locked", *target, "--manifest-path", str(HERE / "benchmark/Cargo.toml"), *feature])
        parity_feature = "validation,disable-avx512" if mode == "disable" else "validation"
        execute("parity-" + mode, common + ["run", "--quiet", "--locked", *target, "--manifest-path", str(HERE / "native/Cargo.toml"), "--features", parity_feature, "--bin", "independent32-parity", "--", "--parity"])
    cpp = ROOT / "experiments/2026-10-29-independent32-native-cpp/validation/native-parity.stdout"
    expected = [json.loads(line) for line in cpp.read_text().splitlines()]
    assert len(expected) == 9
    for mode in ("normal", "disable", "asan"):
        actual = [json.loads(line) for line in (out / ("parity-" + mode + ".stdout")).read_text().splitlines()]
        assert actual == expected, mode
    metadata["cpp_parity"] = dict(path=str(cpp.relative_to(ROOT)), sha256=sha(cpp), rows=9, modes=3)
    for name in ("native", "benchmark"):
        execute(name + "-clippy", ["env", f"CARGO_TARGET_DIR={TARGET}-normal", "cargo", "clippy", "--locked", "--all-targets", "--manifest-path", str(HERE / name / "Cargo.toml"), "--", "-D", "warnings"])
    execute("release-build", ["env", f"CARGO_TARGET_DIR={TARGET}", "RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0", "cargo", "build", "--locked", "--release", "--manifest-path", str(HERE / "benchmark/Cargo.toml")])
    binary = Path(TARGET + "/release/compare_benchmark")
    binary_sha = sha(binary)
    execute("preflight", [sys.executable, str(HERE / "check_preflight.py"), "--binary", str(binary), "--reference", str(reference), "--cpu", "3", "--output", str(out / "preflight-results.json")])
    execute("assembly-visible", [sys.executable, str(HERE / "audit_assembly.py"), "--binary", str(binary)])
    execute("assembly-batch", [sys.executable, str(HERE / "audit_batch.py"), "--binary", str(binary)])
    assert sha(binary) == binary_sha and sha(reference) == expected_reference
    for path, digest in inputs.items():
        assert sha(ROOT / path) == digest, path
    metadata.update(complete=True, binaries_sha256={str(binary): binary_sha, str(reference): expected_reference}, source_after_equal=True)
    (out / "commands.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print("PASS: correctness and assembly captured; manual codegen review required before any speed experiment", flush=True)


if __name__ == "__main__":
    main()
