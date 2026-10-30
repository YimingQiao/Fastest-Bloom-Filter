#!/usr/bin/env python3
"""Versioned76-registry correctness preflight; never launches a large timing matrix."""
if not __debug__:
    raise RuntimeError("Preflight uses assertions; do not use -O")

import argparse
import csv
import io
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time

from preflight_guard import HERE, ROOT, REFERENCE, require, sha, snapshot, check_bytes, check_binaries, consumed_dependencies
from source_guard import require_lease
from verify_source import verify as verify_source

BUILD = Path("/tmp/fastest-bf-multiply-code-split64-screen")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, default=HERE / "validation-v1")
    args = parser.parse_args()
    lease = require_lease(3)
    anchor = snapshot(args.source_commit)
    verify_source()
    args.output.mkdir(exist_ok=False)
    meta = dict(scope="Correctness, planning and semantic reproduction only; tiny timing fields unclaimed",
                anchor=anchor, lease=lease, commands=[], complete=False, timing_matrix_executed=False)
    (args.output / "inputs.json").write_text(json.dumps(anchor, indent=2) + "\n")

    def save():
        (args.output / "commands.json").write_text(json.dumps(meta, indent=2) + "\n")

    def run(name, command):
        check_bytes(anchor["source_sha256"])
        check_binaries(anchor["parent_binary_sha256"])
        start = time.monotonic()
        with (args.output / (name + ".stdout")).open("wb") as stdout, (args.output / (name + ".stderr")).open("wb") as stderr:
            result = subprocess.run([str(x) for x in command], cwd=ROOT, stdout=stdout, stderr=stderr)
        meta["commands"].append(dict(name=name, command=[str(x) for x in command], returncode=result.returncode,
                                     diagnostic_wall_seconds=time.monotonic()-start))
        save()
        print(name, result.returncode, flush=True)
        require(result.returncode == 0, name + " failed; retain this attempt")
        return (args.output / (name + ".stdout")).read_text()

    run("offline-guards", [sys.executable, "-m", "unittest", "discover", "-s", HERE, "-p", "test_preflight_guard.py"])
    run("compiler", ["clang++", "--version"])
    binaries, dependencies, digests = {}, {}, []
    for mode, native, sanitize in (("native", True, False), ("avx2", False, False), ("asan", True, True)):
        build = BUILD / mode
        run(mode + "-configure", ["cmake", "-S", HERE, "-B", build, "-DCMAKE_CXX_COMPILER=clang++",
            "-DBF_NATIVE=" + ("ON" if native else "OFF"), "-DBF_SANITIZERS=" + ("ON" if sanitize else "OFF"),
            "-DFETCHCONTENT_SOURCE_DIR_FASTFILTER=" + str(ROOT / "build/all-external-confirmation/_deps/fastfilter-src"),
            "-DFETCHCONTENT_SOURCE_DIR_PAGEBLOOM=" + str(ROOT / "build/all-external-confirmation/_deps/pagebloom-src")])
        run(mode + "-build", ["cmake", "--build", build, "-j1"])
        dependencies[mode] = consumed_dependencies(build, anchor["source_sha256"])
        for name in ("benchmark", "plan", "check", "fixtures"):
            binaries[str(build / name)] = sha(build / name)
        meta.update(binary_sha256=binaries, consumed_dependencies=dependencies)
        save()
        output = run(mode + "-geometry", [build / "check"])
        lines = [line for line in output.splitlines() if line.startswith("All geometry/output checks passed; checksum=")]
        require(len(lines) == 1, "Missing complete geometry/output digest")
        digests.append(lines[0])
        run(mode + "-cli", [sys.executable, HERE / "test_contract.py", build / "benchmark", build / "plan", build / "fixtures"])
        shutil.copy2(build / "compile_commands.json", args.output / (mode + "-compile_commands.json"))
    require(len(set(digests)) == 1, "Backend geometry/output digest mismatch")
    run("full-geometry-grid", [sys.executable, HERE / "make_plan.py", "--binary", BUILD / "native/plan", "--output", args.output / "planned-grid.json"])
    run("fixed-selection", [sys.executable, HERE / "select_plan.py", "--grid", args.output / "planned-grid.json", "--output", args.output / "selection.json"])
    fields = ("filter_bytes", "actual_bpk", "keys", "queries", "result_checksum", "false_positives", "absent_queries",
              "calibration_false_positives", "calibration_absent_queries", "effective_probes", "probe_policy", "unit_count",
              "logical_bytes", "implementation_origin", "constructor_argument", "input_mode", "filter_build_scratch_bytes")
    comparisons = 0
    for budget in (14, 28):
        for batch in (1, 31, 4096):
            rest = ["10", str(budget), "50", "12", str(batch), "2", "731", "", "1024", "12", "query-only", "0"]
            before = run(f"reference-b{budget}-batch{batch}", [REFERENCE, *rest])
            after = run(f"candidate-b{budget}-batch{batch}", [BUILD / "native/benchmark", *rest])
            old = {row["filter"]: row for row in csv.DictReader(io.StringIO(before))}
            new = {row["filter"]: row for row in csv.DictReader(io.StringIO(after))}
            require(len(old) == 75 and len(new) == 76 and set(new)-set(old) == {"MultiplyCodeSplit64RangeExperiment"}, "Wrong retained registry")
            for name, row in old.items():
                for field in fields:
                    require(row[field] == new[name][field], "Retained semantic drift: " + name + "/" + field)
                comparisons += 1
    require(comparisons == 450, "Wrong retained comparison count")
    require(snapshot(args.source_commit) == anchor, "Final committed-input/binary drift")
    check_binaries(binaries)
    for mode in dependencies.values():
        for name, digest in mode["system_sha256"].items():
            require(sha(Path(name)) == digest, "Consumed system header changed")
    meta.update(complete=True, native_avx2_asan_digest=digests[0], retained_semantic_comparisons=comparisons,
                planned_rows=70, cases=13, inputs_sha256=anchor["source_sha256"], binary_sha256=binaries,
                consumed_dependencies=dependencies)
    save()
    (args.output / "summary.json").write_text(json.dumps(meta, indent=2) + "\n")
    print("PASS:76 public configurations, native/AVX2/ASan,450 retained semantic rows,1016 planner geometries,70/13 selection; no performance matrix")


if __name__ == "__main__":
    main()
