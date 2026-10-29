#!/usr/bin/env python3
"""Account for every fixed public Poppy accuracy result, without latency ranking."""
import argparse
import csv
import hashlib
import io
import json
import math
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PARENT = HERE.with_name("2026-10-29-poppy-public-accuracy")
ROOT = HERE.parents[1]
sys.path.insert(0, str(PARENT))
from contract import check_coverage, constructors, need


def wilson(k, n):
    need(0 <= k <= n and n > 0, "Invalid binomial sample")
    z = 1.959963984540054
    p = k / n
    denominator = 1 + z * z / n
    center = (p + z * z / (2 * n)) / denominator
    radius = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / denominator
    return max(0.0, center - radius), min(1.0, center + radius)


def tables(rows, geometry):
    check_coverage(rows)
    quality = []
    for row, spec in zip(rows, geometry, strict=True):
        low, high = wilson(
            row["calibration_false_positives"], row["calibration_queries"]
        )
        quality.append(
            dict(
                id=row["id"],
                keys=row["real_n"],
                policy=row["policy"],
                kind=spec["kind"],
                requested_fpp=spec["fpp_decimal"],
                fpp_bits=row["fpp_bits"],
                buckets=spec["buckets"],
                probes=spec["probes"],
                cache_bytes=spec["cache_bytes"],
                actual_bytes=row["actual_bytes"],
                actual_bpk=row["actual_bytes"] * 8 / row["real_n"],
                mapping_alias_group=spec["mapping_alias_group"],
                calibration_negatives=row["calibration_queries"],
                false_positives=row["calibration_false_positives"],
                measured_fpr=row["calibration_false_positives"]
                / row["calibration_queries"],
                wilson95_low=low,
                wilson95_high=high,
                false_negatives=row["false_negatives"],
                mixed_absent=row["absent_queries"],
                mixed_false_positives=row["mixed_false_positives"],
                inserted_checksum=row["inserted_checksum"],
                query_checksum=row["query_checksum"],
                result_checksum=row["result_checksum"],
                insertions_returned_new=row["insertions_returned_new"],
            )
        )
    views, alternatives = [], []
    for n in (65536, 33554432):
        for cap in (12, 16, 24, 32):
            for ceiling in (0.01, 0.001, 0.0001):
                items = []
                for row in quality:
                    if row["keys"] != n:
                        continue
                    within = row["actual_bytes"] * 8 <= n * cap
                    passes = row["wilson95_high"] <= ceiling
                    item = dict(
                        keys=n,
                        cap_bpk=cap,
                        fpr_ceiling=ceiling,
                        id=row["id"],
                        actual_bytes=row["actual_bytes"],
                        actual_bpk=row["actual_bpk"],
                        wilson95_high=row["wilson95_high"],
                        within_cap=within,
                        passes_quality=passes,
                        eligible=within and passes,
                    )
                    alternatives.append(item)
                    items.append(item)
                views.append(
                    dict(
                        keys=n,
                        cap_bpk=cap,
                        fpr_ceiling=ceiling,
                        eligible_ids=[i["id"] for i in items if i["eligible"]],
                        failed_quality_within_cap=[
                            i["id"]
                            for i in items
                            if i["within_cap"] and not i["passes_quality"]
                        ],
                        over_budget=[i["id"] for i in items if not i["within_cap"]],
                    )
                )
    need(
        len(quality) == 86 and len(views) == 24 and len(alternatives) == 1032,
        "Incomplete output grid",
    )
    return quality, views, alternatives


def audit_raw(commit):
    need(re.fullmatch("[0-9a-f]{40}", commit), "Full immutable raw commit required")
    raw = PARENT / "results-v1"
    archive = json.loads((raw / "RAW_ARCHIVE.json").read_text())
    for name, item in {**archive["files"], "RAW_ARCHIVE.json": None}.items():
        path = raw / name
        data = path.read_bytes()
        if item:
            need(
                len(data) == item["bytes"]
                and hashlib.sha256(data).hexdigest() == item["sha256"],
                "Raw digest drift",
            )
        need(
            data
            == subprocess.check_output(
                ["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT
            ),
            "Uncommitted raw evidence",
        )
    meta = json.loads((raw / "metadata.json").read_text())
    need(
        meta["complete"] and meta["rows"] == 86 and not meta["throughput_timing"],
        "Wrong completed scope",
    )
    need(
        meta["source_commit"]
        == archive["source_commit"]
        == "950e79dc1dfb9b8e69b8fa76d70c7fd78aaca63b",
        "Wrong executed source",
    )
    geometry = constructors()
    need(
        meta["ledger"] == geometry and len(meta["commands"]) == 86,
        "Changed constructor ledger",
    )
    rows = []
    for index, (command, spec) in enumerate(
        zip(meta["commands"], geometry, strict=True)
    ):
        need(
            command["complete"]
            and command["returncode"] == 0
            and command["index"] == index
            and command["id"] == spec["id"],
            "Bad command",
        )
        need(
            command["command"] == [meta["binary"]["path"], "--accuracy", spec["id"]],
            "Wrong public invocation",
        )
        for stream in ("stdout", "stderr"):
            data = (raw / command[stream]).read_bytes()
            need(
                hashlib.sha256(data).hexdigest() == command[stream + "_sha256"],
                "Command log drift",
            )
        need(not (raw / command["stderr"]).read_bytes(), "Unexpected diagnostic")
        rows.append(json.loads((raw / command["stdout"]).read_text()))
    need(rows == json.loads((raw / "rows.json").read_text()), "Aggregate/raw mismatch")
    check_coverage(rows)
    return rows, geometry


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--raw-commit", required=True)
    args = parser.parse_args()
    need(__debug__, "Python -O forbidden")
    rows, geometry = audit_raw(args.raw_commit)
    quality, views, alternatives = tables(rows, geometry)
    output = HERE / "report"
    need(not output.exists() and not output.is_symlink(), "Preserve previous analysis")
    output.mkdir()
    for name, value in (("quality.json", quality), ("views.json", views)):
        (output / name).write_text(json.dumps(value, indent=2) + "\n")
    stream = io.StringIO(newline="")
    writer = csv.DictWriter(
        stream, fieldnames=list(alternatives[0]), lineterminator="\n"
    )
    writer.writeheader()
    writer.writerows(alternatives)
    (output / "alternatives.csv").write_text(stream.getvalue())
    groups = {}
    for row in quality:
        groups.setdefault(tuple(row["mapping_alias_group"]), []).append(row)
    group_rows = []
    for key, items in groups.items():
        fields = (
            "actual_bytes",
            "false_positives",
            "mixed_false_positives",
            "result_checksum",
            "insertions_returned_new",
        )
        equal = all(all(r[f] == items[0][f] for f in fields) for r in items)
        group_rows.append(
            dict(
                source_mapping=list(key),
                ids=[r["id"] for r in items],
                observed_counts_and_checksum_equal=equal,
            )
        )
    (output / "mapping_groups.json").write_text(json.dumps(group_rows, indent=2) + "\n")
    metadata = dict(
        raw_commit=args.raw_commit,
        rows=86,
        views=24,
        alternatives=1032,
        source_mapping_groups=len(groups),
        negatives_per_row=1 << 26,
        pooled=False,
        latency_measured=False,
        seed_status="seen training seed42",
    )
    (output / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print(json.dumps(metadata))


if __name__ == "__main__":
    main()
