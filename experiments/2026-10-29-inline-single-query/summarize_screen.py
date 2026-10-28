#!/usr/bin/env python3
"""Keep generic batch-one and optimizer-visible singleton rankings separate."""
import csv
import hashlib
import json
import math
from pathlib import Path
import run_screen
from screen_guard import validate_metadata

HERE = Path(__file__).resolve().parent
NATIVE = {
    "FastPatternBF",
    "FourSectorBloomFilter",
    "Split64BloomFilter",
    "ByteSplitBloomFilter",
}
EXPERIMENTAL = {
    "IndependentSplit32",
    "IndependentSplit32Single",
    "IndependentVbmi32",
    "IndependentVbmi32Single",
}
METRICS = ("lookup_ns", "hash_lookup_ns", "inline_lookup_ns", "inline_hash_lookup_ns")


def upper(fp, count):
    if count <= 0 or not 0 <= fp <= count:
        raise ValueError("Invalid independent calibration counts")
    z = 1.959963984540054
    p, zz = fp / count, z * z
    return (
        p + zz / (2 * count) + z * math.sqrt((p * (1 - p) + zz / (4 * count)) / count)
    ) / (1 + zz / count)


def select(rows, family, metric, n, cap, target):
    eligible = [
        r
        for r in rows
        if int(r["keys"]) == n
        and r["family"] == family
        and int(r["filter_bytes"]) * 8 <= cap * n
        and r["fpr_upper"] <= target
        and math.isfinite(float(r[metric]))
        and float(r[metric]) > 0
    ]
    if not eligible:
        return None
    r = min(eligible, key=lambda x: float(x[metric]))
    prefix = metric[:-3]
    low = r.get(prefix + "_min_ns")
    high = r.get(prefix + "_max_ns")
    return {
        "filter": r["filter"],
        "requested_bpk": int(r["requested_bpk"]),
        "filter_bytes": int(r["filter_bytes"]),
        "actual_bpk": 8 * int(r["filter_bytes"]) / n,
        "median_ns": float(r[metric]),
        "min_ns": float(low) if low else None,
        "max_ns": float(high) if high else None,
        "fpr_upper": r["fpr_upper"],
        "calibration_negatives": int(r["calibration_absent_queries"]),
        "calibration_fp": int(r["calibration_false_positives"]),
    }


def main():
    run_screen.verify_freeze()
    with (HERE / "screen/results.csv").open() as stream:
        rows = list(csv.DictReader(stream))
    registry = json.loads((HERE / "registry.json").read_text())["filters"]
    run_screen.validate(rows, registry)
    validate_metadata(rows)
    (HERE / "screen/analysis-validation.json").write_text(
        json.dumps(
            {
                "rows": len(rows),
                "old_and_inline_timing_fields_validated": True,
                "payload_accounting_validated": True,
                "analysis_sources": {
                    name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
                    for name in ("summarize_screen.py", "screen_guard.py", "test_screen_guard.py")
                },
                "note": "Additional analysis guards leave the measured benchmark and original runner unchanged.",
            },
            indent=2,
        ) + "\n"
    )
    for r in rows:
        name = r["filter"]
        r["family"] = (
            "native"
            if name in NATIVE
            else "experimental" if name in EXPERIMENTAL else "external"
        )
        r["fpr_upper"] = upper(
            int(r["calibration_false_positives"]), int(r["calibration_absent_queries"])
        )
    comparisons = []
    individual = []
    for n in (1 << 16, 1 << 25):
        for cap in (16, 32):
            for target in (0.01, 0.001, 0.0001):
                for metric in METRICS:
                    item = {
                        "keys": n,
                        "memory_cap_bpk": cap,
                        "fpr_target": target,
                        "metric": metric,
                    }
                    for family in ("native", "experimental", "external"):
                        item[family] = select(rows, family, metric, n, cap, target)
                    for family in ("native", "experimental"):
                        a, b = item[family], item["external"]
                        item[family + "_speedup"] = (
                            b["median_ns"] / a["median_ns"] if a and b else None
                        )
                    comparisons.append(item)
                    for name in sorted(NATIVE | EXPERIMENTAL):
                        own_rows = [r for r in rows if r["filter"] == name]
                        a = select(
                            own_rows,
                            "native" if name in NATIVE else "experimental",
                            metric,
                            n,
                            cap,
                            target,
                        )
                        b = item["external"]
                        individual.append(
                            {
                                **{
                                    k: item[k]
                                    for k in (
                                        "keys",
                                        "memory_cap_bpk",
                                        "fpr_target",
                                        "metric",
                                    )
                                },
                                "candidate": name,
                                "candidate_selected": a,
                                "external": b,
                                "speedup": (
                                    b["median_ns"] / a["median_ns"] if a and b else None
                                ),
                            }
                        )
    changes = []
    for r in rows:
        for old, new in (
            ("lookup_ns", "inline_lookup_ns"),
            ("hash_lookup_ns", "inline_hash_lookup_ns"),
        ):
            before, after = float(r[old]), float(r[new])
            changes.append(
                {
                    "filter": r["filter"],
                    "family": r["family"],
                    "keys": int(r["keys"]),
                    "requested_bpk": int(r["requested_bpk"]),
                    "metric": new,
                    "old_ns": before if math.isfinite(before) else None,
                    "new_ns": after if math.isfinite(after) else None,
                    "old_over_new": (
                        before / after
                        if math.isfinite(before) and math.isfinite(after)
                        else None
                    ),
                }
            )
    result = {
        "scope": "Seed42 exploratory throughput screen, single CPU2; no held-out performance claim",
        "rows": len(rows),
        "registered": len(registry),
        "external_configs": len(set(registry) - NATIVE - EXPERIMENTAL),
        "quality": "Two-sided95 Wilson upper from each row's independent negative calibration; duplicate API controls are never pooled",
        "comparisons": comparisons,
        "individual": individual,
        "api_changes": changes,
    }
    (HERE / "screen/summary.json").write_text(
        json.dumps(result, indent=2, allow_nan=False) + "\n"
    )
    lines = [
        "# Optimizer-visible singleton screen",
        "",
        "All 60 configurations ran on CPU2: four native layouts, four project experiments and 52 external configurations. "
        "Four workloads / 240 rows use seed42, 2^22 queries, eight balanced repetitions, full-input serial construction "
        "and 2^24 independent calibration negatives. Every timed phase validates complete dense output. "
        "This is exploratory throughput evidence, not a dependent-latency measurement or held-out claim. "
        "The runner pins CPU2 on socket0 but does not force a NUMA memory policy.",
        "",
        "Native leaders below exclude the independent-layout experiments. All external configurations remain eligible "
        "rivals, subject to exact allocation and the two-sided95 Wilson FPR upper. Page's native raw-hash path can "
        "compete only in raw metrics. Identical SingleV1 controls remain explicit rows; they do not add calibration samples.",
        "",
    ]
    for metric in METRICS:
        lines += [
            f"## {metric}",
            "",
            "| Keys | Cap bpk | FPR ceiling | Native leader | ns/key | External leader | ns/key | External/native |",
            "| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |",
        ]
        for r in comparisons:
            if r["metric"] != metric:
                continue
            a, b = r["native"], r["external"]
            cells = [
                f"{r['keys']:,}",
                str(r["memory_cap_bpk"]),
                f"{r['fpr_target']:.2%}",
                a["filter"] if a else "No qualifier",
                f"{a['median_ns']:.3f}" if a else "—",
                b["filter"] if b else "No qualifier",
                f"{b['median_ns']:.3f}" if b else "—",
                (
                    f"{r['native_speedup']:.3f}×"
                    if r["native_speedup"] is not None
                    else "—"
                ),
            ]
            lines.append("| " + " | ".join(cells) + " |")
        lines.append("")
    lines += [
        "## Interpretation",
        "",
        "The old generic batch-count-one loop and the new compiler-visible singleton loop are separate API contracts. "
        "A win in one does not replace a loss in the other. The new raw loop permits the compiler to keep the common "
        "hash in registers and optimize across keys. Boost uses its actual public `may_contain` through a force-inline "
        "shim; original adapter construction/insertion/bulk methods are unchanged. Genuine non-inlined upstream "
        "FastFilter `Contain` calls remain visible in the assembly audit.",
        "",
        "`summary.json` retains every individual native/experimental comparison, every API-induced gain or loss, "
        "chosen allocations, FPR bounds and sample ranges. No experimental layout is counted as an external rival. "
        "Speed ratios are descriptive; pointwise FPR bounds are not simultaneous selection guarantees. "
        "The frozen correctness/assembly inventory and `screen/validation.json` identify the exact executable. "
        "No production source was changed by this harness experiment.",
        "Five focused analysis regression tests reject invalid old-path timings, raw-only pure-query values and impossible allocation metadata before ranking.",
        "",
    ]
    (HERE / "screen/RESULTS.md").write_text("\n".join(lines))
    print("Wrote separate four-metric rankings and all API gains/losses")


if __name__ == "__main__":
    main()
