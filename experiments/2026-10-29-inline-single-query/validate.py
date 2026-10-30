#!/usr/bin/env python3
"""Validate the new scalar track under the socket0 flock before any timing matrix."""
import hashlib
import json
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def main():
    records = []
    binaries = []
    for label, count, options in (
        ("native", 18, ["-DBF_INLINE_REPRESENTATIVE=ON"]),
        ("asan", 18, ["-DBF_INLINE_REPRESENTATIVE=ON", "-DBF_SANITIZERS=ON"]),
        ("full", 60, ["-DBF_INLINE_REPRESENTATIVE=OFF"]),
    ):
        build = ROOT / f"build/inline-single-v2-direct-{label}"
        commands = [
            (
                "configure",
                [
                    "cmake",
                    "-S",
                    str(HERE),
                    "-B",
                    str(build),
                    "-DCMAKE_CXX_COMPILER=clang++",
                    *options,
                ],
            ),
            ("build", ["cmake", "--build", str(build), "--parallel", "1"]),
            ("ctest", ["ctest", "--test-dir", str(build), "--output-on-failure"]),
            (
                "cli",
                [
                    "python3",
                    str(HERE / "check_benchmark.py"),
                    str(build),
                    "--expected",
                    str(count),
                    *(["--registry", str(HERE / "registry.json")] if label == "full" else []),
                ],
            ),
        ]
        for step, command in commands:
            argv = ["taskset", "-c", "2", *command]
            start = time.time()
            with (HERE / f"v2-direct-{label}-{step}.log").open("w") as output:
                completed = subprocess.run(
                    argv, cwd=ROOT, stdout=output, stderr=subprocess.STDOUT
                )
            records.append(
                dict(
                    label=label,
                    step=step,
                    argv=argv,
                    returncode=completed.returncode,
                    elapsed_seconds=time.time() - start,
                )
            )
            (HERE / "validation-v2-direct.json").write_text(json.dumps(records, indent=2) + "\n")
            print(label, step, completed.returncode, flush=True)
            if completed.returncode:
                raise SystemExit(completed.returncode)
        binaries.extend(
            build / name for name in ("benchmark", "check", "fault_pure", "fault_raw")
        )
    sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
    sources = [
        p
        for p in HERE.iterdir()
        if p.suffix in (".cpp", ".hpp", ".py") or p.name == "CMakeLists.txt"
    ]
    prior = HERE.parent / "2026-10-29-external-parallel-query"
    manifest = json.loads((prior / "FREEZE.json").read_text())
    for name, expected in manifest["files"].items():
        path = prior / name
        assert sha(path) == expected, path
        sources.append(path)
    sources.extend(
        (ROOT / "benchmarks" / path)
        for path in (
            "cpp-external/dependencies.cmake",
            "boost-external/BoostHeaders.cmake",
            "rocksdb-external/dependencies.cmake",
        )
    )
    sources.append(HERE.parent / "2026-10-29-direct-split/direct_split.hpp")
    sources.append(HERE / "registry.json")
    freeze = dict(
        revision=subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        note="Sources/binaries frozen after correctness; assembly audit is still required before timing.",
        source_sha256={str(p.relative_to(ROOT)): sha(p) for p in sources},
        binary_sha256={str(p.relative_to(ROOT)): sha(p) for p in binaries},
    )
    (HERE / "freeze-v2-direct.json").write_text(json.dumps(freeze, indent=2) + "\n")
    print("All scalar API correctness, schema and fault checks passed", flush=True)


if __name__ == "__main__":
    main()
