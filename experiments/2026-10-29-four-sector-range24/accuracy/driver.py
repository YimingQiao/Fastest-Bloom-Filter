#!/usr/bin/env python3
"""Build only, then separately run the committed fixed12-row accuracy pilot."""
import argparse
import csv
import hashlib
import importlib.util
import io
import json
import math
from pathlib import Path
import re
import shlex
import subprocess

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
PRIOR = ROOT / "experiments/2026-10-29-multiply-code-split64"
spec = importlib.util.spec_from_file_location("range_accuracy_lease", ROOT / "experiments/2026-10-29-multiply-code-small-confirmation/driver/source_guard.py")
lease_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lease_module)


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def exact_blob(commit, path):
    need(re.fullmatch(r"[0-9a-f]{40}", commit), "Exact full commit required")
    return subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)


def verify(commit):
    prep = HERE / "PREPARATION.json"
    need(exact_blob(commit, prep) == prep.read_bytes(), "Uncommitted preparation")
    m = json.loads(prep.read_text())
    files = dict(m["inputs_sha256"])
    files.update({str((HERE / name).relative_to(ROOT)): digest for name, digest in m["files"].items()})
    for name, digest in files.items():
        path = ROOT / name
        need(sha(path) == digest and hashlib.sha256(exact_blob(commit, path)).hexdigest() == digest,
             "Input drift: " + name)
    correctness = json.loads((STAGE / "validation-v1/metadata.json").read_text())
    need(correctness["complete"] and len(correctness["binaries"]) == 6, "Incomplete algorithm preflight")
    for record in correctness["binaries"].values():
        need(sha(Path(record["path"])) == record["sha256"], "Changed correctness executable")
    source = (PRIOR / "cpp/calibrate.cpp").read_text()
    source = source.replace('#include "multiply_code_split64.h"\n#include "cyclic_split64.h"', '#include "../four_sector_range24.h"')
    source = source.replace('for(size_t bpk:{16UL,24UL,28UL,32UL})', 'for(size_t bpk:{16UL,24UL,32UL})')
    source = source.replace('        run<CyclicSplit64Range>("CyclicSplit64Range",1UL<<power,bpk);\n        run<MultiplyCodeSplit64Range>("MultiplyCodeSplit64Range",1UL<<power,bpk);',
                            '        run<FourSectorRange24>("FourSectorRange24",1UL<<power,bpk);')
    need(source == (HERE / "calibrate.cpp").read_text(), "Unreviewed calibration derivation")
    reference = (PRIOR / "cpp/split64_reference.h").read_text().replace('#include "range_size.hpp"', '#include "../range_size.hpp"')
    need(reference == (HERE / "split64_reference.h").read_text(), "Changed Split64 reference")
    return files


def wilson(fp, n):
    need(0 <= fp <= n and n > 0, "Invalid counts")
    z = 1.959963984540054
    point = fp / n
    mid = point + z*z/(2*n)
    radius = z * math.sqrt(point*(1-point)/n + z*z/(4*n*n))
    scale = 1 + z*z/n
    return max(0., (mid-radius)/scale), min(1., (mid+radius)/scale)


def validate(rows, old):
    expected = [(name, 1 << power, bpk) for power in (16, 25) for bpk in (16, 24, 32)
                for name in ("Split64Range", "FourSectorRange24")]
    need([(r["filter"], int(r["keys"]), int(r["actual_bpk"])) for r in rows] == expected,
         "Incomplete/duplicated/reordered fixed12 matrix")
    controls = {(r["keys"], r["actual_bpk"]): r for r in old if r["filter"] == "Split64Range"}
    result = []
    for row in rows:
        need(set(row) == {"filter", "keys", "actual_bpk", "filter_bytes", "seed", "calibration_negatives", "false_positives", "checksum"}, "Changed accuracy schema")
        n, cap = int(row["keys"]), int(row["actual_bpk"])
        need(int(row["filter_bytes"]) == n*cap//8 and int(row["seed"]) == 42 and int(row["calibration_negatives"]) == 1 << 24, "Wrong fixed geometry or sample")
        need(0 <= int(row["checksum"]) < 1 << 64, "Invalid checksum")
        lo, hi = wilson(int(row["false_positives"]), 1 << 24)
        if row["filter"] == "Split64Range":
            need(row == controls[(row["keys"], row["actual_bpk"])], "Frozen control count/checksum did not reproduce")
        result.append(dict(row, point_fpr=int(row["false_positives"])/(1 << 24), wilson_lower=lo,
                           wilson_upper=hi, pass_1pct=hi <= .01, pass_0_1pct=hi <= .001, pass_0_01pct=hi <= .0001))
    return result


def main():
    need(__debug__, "Do not disable checks")
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source-commit", required=True)
    p.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    action = p.add_mutually_exclusive_group(required=True)
    action.add_argument("--build-only", action="store_true")
    action.add_argument("--execute-frozen", action="store_true")
    p.add_argument("--freeze-commit")
    args = p.parse_args()
    lease = lease_module.require_lease(args.cpu)
    files = verify(args.source_commit)
    build = HERE / "build-v1"
    evidence = HERE / "build-evidence-v1"
    binary = build / "calibrate"
    if args.build_only:
        need(not args.freeze_commit, "Build stage cannot consume a later freeze")
        need(not build.exists() and not evidence.exists(), "Preserve old build attempt")
        build.mkdir()
        evidence.mkdir()
        command = ["clang++", "-std=c++17", "-O3", "-march=native", "-I", str(ROOT / "include"),
                   "-MD", "-MF", str(evidence / "calibrate.d"), str(HERE / "calibrate.cpp"), "-o", str(binary)]
        proc = subprocess.run(command, cwd=ROOT, capture_output=True)
        (evidence / "build.stdout").write_bytes(proc.stdout)
        (evidence / "build.stderr").write_bytes(proc.stderr)
        meta = dict(complete=False, executed=False, source_commit=args.source_commit, lease=lease,
                    command=command, returncode=proc.returncode)
        save(evidence / "metadata.json", meta)
        need(proc.returncode == 0, "Calibration compile failed; retained")
        inputs = {}
        for token in shlex.split((evidence / "calibrate.d").read_text().replace("\\\n", " "))[1:]:
            path = Path(token)
            path = (path if path.is_absolute() else ROOT / path).resolve()
            if path.is_relative_to(ROOT):
                name = str(path.relative_to(ROOT))
                need(name in files and sha(path) == files[name], "Unprepared consumed repository input")
            inputs[str(path)] = sha(path)
        verify(args.source_commit)
        meta.update(complete=True, binary=str(binary), binary_sha256=sha(binary), consumed_inputs=inputs)
        save(evidence / "metadata.json", meta)
        save(evidence / "archive-manifest.json", dict(files={f.name: sha(f) for f in sorted(evidence.iterdir()) if f.is_file()}))
        print("Compile complete; executable has NOT run. Commit evidence before the fixed accuracy matrix.")
        return
    need(args.freeze_commit, "Compiled evidence must be committed before accuracy")
    manifest = evidence / "archive-manifest.json"
    need(exact_blob(args.freeze_commit, manifest) == manifest.read_bytes(), "Uncommitted compiled manifest")
    for name, digest in json.loads(manifest.read_text())["files"].items():
        path = evidence / name
        need(sha(path) == digest and hashlib.sha256(exact_blob(args.freeze_commit, path)).hexdigest() == digest,
             "Changed compile evidence")
    compiled = json.loads((evidence / "metadata.json").read_text())
    need(compiled["complete"] and not compiled["executed"] and compiled["source_commit"] == args.source_commit, "Wrong compile stage")

    def compiled_verify():
        need(sha(binary) == compiled["binary_sha256"], "Compiled executable drift")
        for path, digest in compiled["consumed_inputs"].items():
            need(sha(Path(path)) == digest, "Consumed input drift")

    compiled_verify()
    out = HERE / "results"
    out.mkdir(exist_ok=False)
    meta = dict(complete=False, performance_run=False, source_commit=args.source_commit,
                freeze_commit=args.freeze_commit, lease=lease, command=[str(binary)])
    save(out / "metadata.json", meta)
    proc = subprocess.run([str(binary)], cwd=ROOT, capture_output=True)
    (out / "results.stdout").write_bytes(proc.stdout)
    (out / "results.stderr").write_bytes(proc.stderr)
    meta.update(returncode=proc.returncode, stdout_sha256=sha(out / "results.stdout"), stderr_sha256=sha(out / "results.stderr"))
    save(out / "metadata.json", meta)
    need(proc.returncode == 0 and not proc.stderr, "Accuracy run failed; retained")
    rows = list(csv.DictReader(io.StringIO(proc.stdout.decode())))
    with (PRIOR / "accuracy/results.csv").open() as stream:
        old = list(csv.DictReader(stream))
    quality = validate(rows, old)
    verify(args.source_commit)
    compiled_verify()
    need(lease_module.require_lease(args.cpu) == lease, "Final lease drift")
    save(out / "quality.json", quality)
    meta.update(complete=True, rows=12, candidate_records=6, retained_control_records=6,
                quality_sha256=sha(out / "quality.json"))
    save(out / "metadata.json", meta)
    save(out / "archive-manifest.json", dict(files={f.name: sha(f) for f in sorted(out.iterdir()) if f.is_file()}))
    print("Complete: six candidate plus six unchanged reference records; no timing or pooling")


if __name__ == "__main__":
    main()
