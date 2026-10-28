#!/usr/bin/env python3
"""Validate and summarize the complete, unpromoted VBMI screen."""
import csv
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from rank_external import upper95


def main():
    freeze = json.loads((HERE / "freeze.json").read_text())
    for path, expected in freeze["source_sha256"].items():
        assert hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected, path
    for path, expected in freeze["binary_sha256"].items():
        assert hashlib.sha256((ROOT / path).read_bytes()).hexdigest() == expected, path
    rows = list(csv.DictReader((HERE / "screen/results.csv").open()))
    assert len(rows) == 132
    groups = {}
    for r in rows:
        key = tuple(int(r[f]) for f in ("keys", "requested_bpk", "batch", "seed"))
        assert r["seed"] == "42" and r["repeats"] == "5"
        assert int(r["queries"]) == 1 << 22 and r["hit_percent"] == "50"
        assert int(r["insert_batch"]) == int(r["keys"])
        assert int(r["calibration_absent_queries"]) == 1 << 24
        group = groups.setdefault(key, {})
        assert r["filter"] not in group
        group[r["filter"]] = r
    assert len(groups) == 12 and all(len(g) == 11 for g in groups.values())
    family = (
        "IndependentVbmi32",
        "IndependentVbmi32Single",
        "IndependentSplit32",
        "IndependentSplit32Single",
    )
    records = []
    table = []
    strict = []
    for (n, bpk, batch, seed), group in sorted(groups.items()):
        for field in (
            "filter_bytes",
            "result_checksum",
            "false_positives",
            "calibration_false_positives",
        ):
            assert len({group[name][field] for name in family}) == 1, (
                n,
                bpk,
                batch,
                field,
            )
        old, new = group["IndependentSplit32Single"], group["IndependentVbmi32Single"]
        bound = upper95(
            int(new["calibration_false_positives"]),
            int(new["calibration_absent_queries"]),
        )
        ratios = {
            metric: float(old[metric]) / float(new[metric])
            for metric in ("lookup_ns", "hash_lookup_ns", "hash_insert_ns")
        }
        records.append(
            dict(
                keys=n,
                requested_bpk=bpk,
                batch=batch,
                seed=seed,
                filter_bytes=int(new["filter_bytes"]),
                fpr_upper95=bound,
                old_over_new=ratios,
            )
        )
        table.append(
            f"| {n:,} | {bpk * 2} | {batch} | {ratios['lookup_ns']:.3f}× | {ratios['hash_lookup_ns']:.3f}× | {ratios['hash_insert_ns']:.3f}× | {bound:.5%} |"
        )
        if bpk == 16:
            assert bound < 0.0001
            eligible = [
                r
                for r in rows
                if int(r["keys"]) == n
                and int(r["batch"]) == batch
                and int(r["filter_bytes"]) <= n * 4
                and r["filter"].startswith("FastFilter")
                and upper95(
                    int(r["calibration_false_positives"]),
                    int(r["calibration_absent_queries"]),
                )
                < 0.0001
            ]
            for metric in ("lookup_ns", "hash_lookup_ns"):
                best = min(eligible, key=lambda r: float(r[metric]))
                strict.append(
                    f"| {n:,} | {batch} | {metric} | {float(new[metric]):.3f} | {best['filter']} | {float(best[metric]):.3f} | {float(best[metric]) / float(new[metric]):.3f}× |"
                )
    report = (
        """# VBMI screen: unchanged mapping, separate timing outcomes

CPU 2, seed 42, 12 workloads × 11 configurations = 132 rows, five repetitions,
2^22 mixed queries and 2^24 independent calibration negatives per insertion set.
The source/binary hashes still match the pre-timing freeze. The four independent
layout variants have identical full-output checksums, FPR counts and allocation.
Repeated calibration across query batches is the same stream, not extra evidence.

Ratios are old/new latency (above one is faster). This first table compares the
explicit single-key shortcuts; their bulk paths also retain the changed mask.
The complete CSV retains both versions without the shortcut too.

| Keys | Actual bits/key | Batch | Pure query | Hash+query | Hash+insert | FPR upper95 |
| --- | --- | --- | --- | --- | --- | --- |
"""
        + "\n".join(table)
        + """

For the strict 0.01% FPR ceiling, both actual allocations may compete under 32 bits/key.
These external leaders are selected from this limited FastFilter shortlist,
not the full modern suite. The candidate remains unpromoted; these are exploratory
timings on one seed and do not establish a global or production-library win.

| Keys | Batch | Metric | VBMI ns/key | FastFilter leader | ns/key | External/VBMI |
| --- | --- | --- | --- | --- | --- | --- |
"""
        + "\n".join(strict)
        + "\n"
    )
    (HERE / "screen/report.md").write_text(report)
    (HERE / "screen/summary.json").write_text(json.dumps(records, indent=2) + "\n")
    print(
        "Validated all132 rows and unchanged source/binary digests; wrote screen report"
    )


if __name__ == "__main__":
    main()
