"""Independent quality records and the unchanged diagnostic K rule; no timing."""
import json
import math
from pathlib import Path
import sys

STAGE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(STAGE))
from selection_rule import select_neighborhood


def need(ok, message):
    if not ok: raise ValueError(message)


def wilson(fp, n):
    need(type(fp) is int and type(n) is int and n > 0 and 0 <= fp <= n, "Bad Bernoulli counts")
    z = 1.959963984540054
    p = fp / n
    scale = 1 + z * z / n
    mid = (p + z * z / (2 * n)) / scale
    radius = z * math.sqrt((p * (1 - p) + z * z / (4 * n)) / n) / scale
    return (0.0 if fp == 0 else max(0.0, mid-radius), 1.0 if fp == n else min(1.0, mid+radius))


def quality_records(rows):
    expected = {(name, 1 << case["key_power"], case["budget_bpk"])
                for case in json.loads((STAGE / "proposal.json").read_text())["cases"] for name in case["filters"]}
    keys = [(r["filter"], int(r["keys"]), int(r["requested_bpk"])) for r in rows]
    need(len(rows) == len(set(keys)) == 112 and set(keys) == expected, "Full fixed112 quality grid required")
    groups, api = {}, []
    for row in rows:
        name, n, cap = row["filter"], int(row["keys"]), int(row["requested_bpk"])
        # Only this constructor alias has complete public-bitmap proof. Equal
        # observed counts from different public families imply no new alias.
        mapping = "Fastbloom017" if name == "Fastbloom017K11" and cap == 16 else name
        key = (mapping, n, cap)
        fp, count = int(row["calibration_false_positives"]), int(row["calibration_absent_queries"])
        low, high = wilson(fp, count)
        record = dict(filter=name, keys=n, actual_bpk=float(row["actual_bpk"]), budget_bpk=cap,
            filter_bytes=int(row["filter_bytes"]), seed=int(row["seed"]), calibration_queries=count,
            false_positives=fp, point_fpr=fp/count, wilson_lower=low, wilson_upper=high,
            pass_1pct=high <= .01, pass_0_1pct=high <= .001, pass_0_01pct=high <= .0001)
        api.append(record)
        if key in groups:
            prior = groups[key]
            for field in ["filter_bytes", "seed", "calibration_queries", "false_positives"]:
                need(record[field] == prior[field], "Known alias quality differs")
            prior["api_labels"].append(name)
        else:
            groups[key] = dict(record, mapping=mapping, api_labels=[name])
    need(len(groups) == 110 and sum(len(r["api_labels"]) == 2 for r in groups.values()) == 2,
         "Unexpected quality alias deduction")
    diagnostics = []
    for n in [1 << 16, 1 << 25]:
        for cap in [16, 24, 32]:
            selected = [dict(K=int(r["filter"].removeprefix("Fastbloom017K")),
                false_positives=r["false_positives"], negatives=r["calibration_queries"])
                for r in api if r["keys"] == n and r["budget_bpk"] == cap and r["filter"].startswith("Fastbloom017K")]
            diagnostics.append(dict(keys=n, budget_bpk=cap, **select_neighborhood(selected)))
    return dict(api_records=api, mapping_records=list(groups.values()), diagnostic_K_neighborhoods=diagnostics,
        pooling=False, performance_ranking=False,
        note="Original40 streams reproduce prior evidence; only default16/K11 alias collapsed, no sample pooling; all12 remain eligible for later timing")
