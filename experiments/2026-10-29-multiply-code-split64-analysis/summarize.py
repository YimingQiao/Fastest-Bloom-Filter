#!/usr/bin/env python3
"""Verify and report the fixed seed42 accuracy pilot, without executing a filter."""
if not __debug__:
    raise ValueError("Run without Python -O")

import csv
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
EXPERIMENT = HERE.parent / "2026-10-29-multiply-code-split64"
COMMIT = "079a562951c99930ec1e40d58e45bbe372b867cd"
CANDIDATE = "MultiplyCodeSplit64Range"
sys.path.insert(0, str(EXPERIMENT))
from calibrate import verify_commit
from quality_guard import require, validate, wilson


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    frozen = verify_commit(COMMIT)
    accuracy = EXPERIMENT / "accuracy"
    meta = json.loads((accuracy / "metadata.json").read_text())
    require(meta["complete"] and meta["rows"] == 24 and meta["source_commit"] == COMMIT, "Incomplete or different pilot")
    require(meta["freeze_sha256"] == sha(EXPERIMENT / "FREEZE.json") and meta["manifest_sha256"] == sha(EXPERIMENT / "manifest.json"), "Changed archive anchors")
    require(meta["command"] == [frozen["accuracy_executable"]] and meta["binary_sha256"] == frozen["binary_sha256"][frozen["accuracy_executable"]], "Wrong executable")
    require(meta["lease"]["cpu"] == 3 and meta["lease"]["socket"] == 1 and meta["lease"]["lock_path"] == "/tmp/fastest-bf-socket1.lock" and meta["lease"]["inherited_lock_descriptors"], "Wrong execution lease")
    require(meta["results_sha256"] == sha(accuracy / "results.csv"), "Changed raw accuracy output")
    with (accuracy / "results.csv").open() as stream:
        rows = list(csv.DictReader(stream))
    validate(rows)
    expected = []
    for row in rows:
        fp, count = int(row["false_positives"]), int(row["calibration_negatives"])
        lower, upper = wilson(fp, count)
        expected.append(dict(**row, observed_fpr=fp/count, wilson_lower=lower, wilson_upper=upper,
                             qualifies_1_percent=upper <= .01, qualifies_point1_percent=upper <= .001,
                             qualifies_point01_percent=upper <= .0001, reproduced_parent_control=row["filter"] != CANDIDATE))
    require(expected == json.loads((accuracy / "quality.json").read_text()), "Changed quality endpoints or qualification")
    candidate = [row for row in expected if row["filter"] == CANDIDATE]
    require(len(candidate) == 8, "Missing candidate record")
    summary = dict(scope="One fixed seed42 accuracy pilot; no timing, held-out confirmation, distributional equivalence or production promotion",
                   source_commit=COMMIT, total_rows=24, candidate_quality_records=8,
                   reused_parent_reproduction_records=16, negatives_per_record=1 << 24,
                   confidence_rule="Pointwise two-sided95% Wilson upper; not simultaneous bounds; no pooled reused streams",
                   candidate=candidate, raw_results_sha256=sha(accuracy / "results.csv"),
                   raw_metadata_sha256=sha(accuracy / "metadata.json"), raw_quality_sha256=sha(accuracy / "quality.json"),
                   analyzer_sha256=sha(Path(__file__)))
    (HERE / "summary.json").write_text(json.dumps(summary, indent=2, allow_nan=False) + "\n")
    text = ["# Fixed multiply-code accuracy pilot", "",
            "The candidate passes the pointwise0.1% gate at actual16bpk and0.01% at actual24/28/32bpk for both tested sizes on seed42. All16 old Split64Range/Cyclic rows reproduce their pinned counts and dense checksums exactly. The fixed multiplier was not changed. No throughput measurements were made.", "",
            "Each row has2^24 unique disjoint negatives. The table retains every row; Wilson bounds are pointwise95% intervals, not a simultaneous guarantee. Old controls repeat an existing stream and are reproduction checks, not extra independent samples. The eight candidate rows are separate geometry/size observations and are not pooled.", "",
            "| Keys | Actual bpk | Filter | FP count | FPR % | Wilson upper % | ≤0.1% | ≤0.01% |",
            "|---:|---:|---|---:|---:|---:|:---:|:---:|"]
    for row in expected:
        text.append(f"| {int(row['keys']):,} | {row['actual_bpk']} | {row['filter']} | {row['false_positives']} | {100*row['observed_fpr']:.6f} | {100*row['wilson_upper']:.6f} | {'yes' if row['qualifies_point1_percent'] else 'no'} | {'yes' if row['qualifies_point01_percent'] else 'no'} |")
    text.extend(["", "The candidate has both lower and higher FP counts than the original Split64Range, depending on geometry. This pilot does not establish identical mask distributions or statistically significant quality superiority. The24bpk small-size upper endpoint is0.009808%, close to0.01%; fresh fixed-seed confirmation is needed before treating that threshold as robust. Neither the quality gate nor the shorter compiled instruction sequence proves a speed benefit.", "",
                 "Source and binary were frozen at commit`" + COMMIT + "` before data. Run `python3 experiments/2026-10-29-multiply-code-split64-analysis/summarize.py` to verify the committed source/binary anchors, raw output digest, all24 row contracts, all16 reproduced controls and saved quality endpoints before regenerating this report.", ""])
    (HERE / "REPORT.md").write_text("\n".join(text))
    print("Verified24 rows,16 exact parent reproductions,8 unpooled candidate quality records; no filter executed")


if __name__ == "__main__":
    main()
