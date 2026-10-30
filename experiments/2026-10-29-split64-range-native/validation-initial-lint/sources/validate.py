#!/usr/bin/env python3
"""Correctness only; execute while holding socket0 flock and socket0 affinity."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "validation-v1"
BUILD = Path("/tmp/fastest-bf-split64-range-native")
records = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(name, args, env=None):
    start = time.monotonic()
    with (OUT / (name + ".stdout")).open("wb") as stdout, (OUT / (name + ".stderr")).open("wb") as stderr:
        result = subprocess.run([str(x) for x in args], cwd=ROOT,
                                env={**os.environ, **(env or {})}, stdout=stdout, stderr=stderr)
    records.append(dict(name=name, command=[str(x) for x in args], env=env or {},
                        returncode=result.returncode, seconds=time.monotonic() - start))
    (OUT / "commands.json").write_text(json.dumps(records, indent=2) + "\n")
    print(name, result.returncode, flush=True)
    if result.returncode:
        raise RuntimeError(f"{name} failed; retained both logs")


def main():
    if not __debug__:
        raise RuntimeError("Do not run with Python -O")
    if not set(os.sched_getaffinity(0)) <= set(range(0, 96, 2)):
        raise RuntimeError("Expected socket0 physical-core affinity")
    # A nonblocking competing lock must fail while the inherited lease is held.
    probe = subprocess.run(["flock", "--exclusive", "--nonblock", "/tmp/fastest-bf-socket0.lock", "true"])
    if probe.returncode != 1:
        raise RuntimeError("No whole-operation socket0 lease")
    OUT.mkdir(exist_ok=False)
    inputs = {str(p.relative_to(ROOT)): sha(p) for p in HERE.rglob("*")
              if p.is_file() and "validation-v1" not in p.parts and "__pycache__" not in p.parts}
    provenance = json.loads((HERE / "source-provenance.json").read_text())
    for name, expected in provenance["parents_sha256"].items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Parent changed: " + name)
    binaries = {}
    reference = None
    for mode in ("native", "avx2", "scalar"):
        for sanitizer in (False, True):
            tag = "cpp-" + mode + ("-asan" if sanitizer else "")
            build = BUILD / tag
            run(tag + "-configure", ["cmake", "-S", HERE, "-B", build,
                                    "-DCMAKE_CXX_COMPILER=clang++", "-DRANGE_ISA=" + mode,
                                    "-DRANGE_SANITIZERS=" + ("ON" if sanitizer else "OFF")])
            run(tag + "-build", ["cmake", "--build", build, "-j2"])
            run(tag + "-check", [build / "check"])
            run(tag + "-parity", [build / "check", "--parity"])
            actual = (OUT / (tag + "-parity.stdout")).read_bytes()
            if reference is None:
                reference = actual
            if actual != reference:
                raise RuntimeError("C++ fixture mismatch " + tag)
            binaries[str(build / "check")] = sha(build / "check")
    manifest = HERE / "rust/Cargo.toml"
    for mode in ("normal", "disable", "asan"):
        tag = "rust-" + mode
        env = {"CARGO_TARGET_DIR": str(BUILD / tag)}
        features = "validation" + (",disable-avx512" if mode == "disable" else "")
        target = []
        if mode == "asan":
            env.update(RUSTC_BOOTSTRAP="1", RUSTFLAGS="-Zsanitizer=address")
            target = ["--target", "x86_64-unknown-linux-gnu"]
        common = ["--manifest-path", manifest, "--features", features, *target]
        run(tag + "-test", ["cargo", "test", *common, "--lib", "split64_range::tests", "--", "--test-threads=1"], env)
        run(tag + "-parity", ["cargo", "run", "--release", *common, "--example", "parity"], env)
        if (OUT / (tag + "-parity.stdout")).read_bytes() != reference:
            raise RuntimeError("Cross-language complete fixture mismatch " + tag)
        binary = BUILD / tag
        if mode == "asan":
            binary /= "x86_64-unknown-linux-gnu"
        binary /= "release/examples/parity"
        binaries[str(binary)] = sha(binary)
    env = {"CARGO_TARGET_DIR": str(BUILD / "rust-normal")}
    run("rust-all-tests", ["cargo", "test", "--manifest-path", manifest, "--lib", "--", "--test-threads=1"], env)
    run("rust-clippy", ["cargo", "clippy", "--manifest-path", manifest, "--all-targets", "--features", "validation", "--", "-D", "warnings"], env)
    for name, expected in inputs.items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Input changed during preflight: " + name)
    (OUT / "summary.json").write_text(json.dumps(dict(
        scope="Correctness only; no throughput measurements", inputs_sha256=inputs,
        parent_sha256=provenance["parents_sha256"], binaries_sha256=binaries,
        fixture_sha256=hashlib.sha256(reference).hexdigest(), fixture_cases=12,
        affinity=sorted(os.sched_getaffinity(0)), commands=len(records)), indent=2) + "\n")


if __name__ == "__main__":
    main()
