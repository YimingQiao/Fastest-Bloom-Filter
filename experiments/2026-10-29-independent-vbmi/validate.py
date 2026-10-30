#!/usr/bin/env python3
"""Run under the socket0 flock; preserve all commands and compiler/test output."""
import hashlib
import json
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BUILD = ROOT / "build/independent-vbmi"
ASAN = ROOT / "build/independent-vbmi-asan"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    records = []
    commands = [
        (
            "configure-native",
            [
                "cmake",
                "-S",
                str(HERE),
                "-B",
                str(BUILD),
                "-DCMAKE_CXX_COMPILER=clang++",
            ],
        ),
        ("build-native", ["cmake", "--build", str(BUILD), "--parallel", "1"]),
        ("ctest-native", ["ctest", "--test-dir", str(BUILD), "--output-on-failure"]),
        (
            "build-avx2",
            [
                "clang++",
                "-std=c++17",
                "-O3",
                "-mavx2",
                "-Iinclude",
                str(HERE / "check.cpp"),
                "-o",
                str(BUILD / "check_avx2"),
            ],
        ),
        ("check-avx2", [str(BUILD / "check_avx2")]),
        (
            "configure-asan",
            [
                "cmake",
                "-S",
                str(HERE),
                "-B",
                str(ASAN),
                "-DCMAKE_CXX_COMPILER=clang++",
                "-DBF_SANITIZERS=ON",
            ],
        ),
        (
            "build-asan",
            [
                "cmake",
                "--build",
                str(ASAN),
                "--parallel",
                "1",
                "--target",
                "check",
                "check_scalar",
            ],
        ),
        ("ctest-asan", ["ctest", "--test-dir", str(ASAN), "--output-on-failure"]),
    ]
    for label, command in commands:
        argv = ["taskset", "-c", "2", *command]
        start = time.time()
        with (HERE / f"{label}.log").open("w") as output:
            completed = subprocess.run(
                argv, cwd=ROOT, stdout=output, stderr=subprocess.STDOUT
            )
        records.append(
            dict(
                label=label,
                argv=argv,
                returncode=completed.returncode,
                elapsed_seconds=time.time() - start,
            )
        )
        (HERE / "validation.json").write_text(json.dumps(records, indent=2) + "\n")
        print(label, completed.returncode, flush=True)
        if completed.returncode:
            raise SystemExit(completed.returncode)
    sources = list((ROOT / "include").glob("*.h"))
    sources += [
        ROOT / "src/compare_benchmark.cpp",
        ROOT / "benchmarks/cpp-external/adapters.hpp",
        ROOT / "benchmarks/cpp-external/dependencies.cmake",
        HERE.parent / "2026-10-29-direct-split/direct_split.hpp",
    ]
    sources += [
        p
        for p in HERE.iterdir()
        if p.suffix in (".hpp", ".cpp", ".py") or p.name == "CMakeLists.txt"
    ]
    freeze = dict(
        source_revision=subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        source_sha256={str(p.relative_to(ROOT)): digest(p) for p in sources},
        binary_sha256={
            str(p.relative_to(ROOT)): digest(p)
            for p in (
                BUILD / "compare_benchmark",
                BUILD / "check",
                BUILD / "check_scalar",
                BUILD / "check_avx2",
                ASAN / "check",
                ASAN / "check_scalar",
            )
        },
    )
    (HERE / "freeze.json").write_text(json.dumps(freeze, indent=2) + "\n")
    print(
        "All correctness modes passed; sources/binaries frozen before timing",
        flush=True,
    )


if __name__ == "__main__":
    main()
