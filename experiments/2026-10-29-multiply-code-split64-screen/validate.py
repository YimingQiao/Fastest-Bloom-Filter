#!/usr/bin/env python3
"""Compile/check the76-row registry; no large performance screen is launched."""
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import time
from source_guard import require_lease

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = ROOT / "experiments/2026-10-29-cyclic-split64-screen"
BUILD = Path("/tmp/fastest-bf-multiply-code-split64-screen")
OUT = HERE / "validation-v1"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__ or os.sched_getaffinity(0) != {3}:
        raise RuntimeError("Normal Python and CPU3 affinity required")
    lease = require_lease(3)
    from verify_source import verify
    verify()
    OUT.mkdir(exist_ok=False)
    parent = json.loads((PARENT / "FREEZE.json").read_text())
    inputs = {str(p.relative_to(ROOT)): sha(p) for p in HERE.rglob("*") if p.is_file()
              and not any(part.startswith("validation-") or part == "__pycache__" for part in p.relative_to(HERE).parts)}
    for name, expected in parent["source_sha256"].items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Frozen parent source changed: " + name)
        inputs[name] = expected
    (OUT / "inputs.json").write_text(json.dumps(inputs, indent=2)+"\n")
    records, binaries = [], {}

    def run(name, command):
        start = time.monotonic()
        with (OUT / (name+".stdout")).open("wb") as stdout, (OUT / (name+".stderr")).open("wb") as stderr:
            result = subprocess.run([str(x) for x in command], cwd=ROOT, stdout=stdout, stderr=stderr)
        records.append(dict(name=name, command=[str(x) for x in command], returncode=result.returncode, seconds=time.monotonic()-start))
        (OUT / "commands.json").write_text(json.dumps(records, indent=2)+"\n")
        print(name, result.returncode, flush=True)
        if result.returncode:
            raise RuntimeError(name+" failed; logs retained")
        return (OUT / (name+".stdout")).read_text()

    for mode, native, asan in [("native", True, False), ("avx2", False, False), ("asan", True, True)]:
        build = BUILD / mode
        run(mode+"-configure", ["cmake", "-S", HERE, "-B", build, "-DCMAKE_CXX_COMPILER=clang++",
             "-DBF_NATIVE="+("ON" if native else "OFF"), "-DBF_SANITIZERS="+("ON" if asan else "OFF"),
             "-DFETCHCONTENT_SOURCE_DIR_FASTFILTER="+str(ROOT/"build/all-external-confirmation/_deps/fastfilter-src"),
             "-DFETCHCONTENT_SOURCE_DIR_PAGEBLOOM="+str(ROOT/"build/all-external-confirmation/_deps/pagebloom-src")])
        run(mode+"-build", ["cmake", "--build", build, "-j1"])
        run(mode+"-tests", ["ctest", "--test-dir", build, "--output-on-failure"])
        shutil.copy2(build / "compile_commands.json", OUT / (mode+"-compile_commands.json"))
        for name in ("benchmark", "plan", "check", "fixtures"):
            binaries[str(build / name)] = sha(build / name)
    run("full-geometry-grid", ["python3", HERE/"make_plan.py", "--binary", BUILD/"native/plan", "--output", OUT/"planned-grid.json"])
    run("fixed-selection", ["python3", HERE/"select_plan.py", "--grid", OUT/"planned-grid.json", "--output", OUT/"selection.json"])
    semantic = ("filter_bytes", "actual_bpk", "keys", "queries", "result_checksum", "false_positives", "absent_queries",
                "calibration_false_positives", "calibration_absent_queries", "effective_probes", "probe_policy",
                "unit_count", "logical_bytes", "implementation_origin", "constructor_argument")
    comparisons = 0
    for budget in (14, 28):
        for batch in (1, 31, 4096):
            args = ["10", str(budget), "50", "12", str(batch), "2", "731", "", "1024", "12", "query-only", "0"]
            before = run(f"reference-b{budget}-batch{batch}", [Path("/tmp/fastest-bf-cyclic-split64-screen/native/benchmark"), *args])
            after = run(f"candidate-b{budget}-batch{batch}", [BUILD/"native/benchmark", *args])
            br = {r["filter"]:r for r in csv.DictReader(io.StringIO(before))}
            ar = {r["filter"]:r for r in csv.DictReader(io.StringIO(after))}
            if len(br) != 75 or len(ar) != 76 or set(ar)-set(br) != {"MultiplyCodeSplit64RangeExperiment"}:
                raise RuntimeError("Unexpected public registry")
            for name, old in br.items():
                for key in semantic:
                    if old[key] != ar[name][key]:
                        raise RuntimeError("Retained semantic field changed: "+name+"/"+key)
                comparisons += 1
    for name, expected in inputs.items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Input changed during preflight: "+name)
    for name, expected in parent["binary_sha256"].items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Parent binary changed: "+name)
    (OUT / "summary.json").write_text(json.dumps(dict(scope="Correctness only; tiny timing fields unclaimed",
        inputs_sha256=inputs, binary_sha256=binaries, retained_semantic_comparisons=comparisons,
        planned_rows=70, affinity=[3], lease=lease), indent=2)+"\n")


if __name__ == "__main__":
    main()
