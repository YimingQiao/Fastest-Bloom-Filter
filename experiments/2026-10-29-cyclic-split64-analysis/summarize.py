#!/usr/bin/env python3
"""Analyze only the frozen cyclic62 same-process training screen."""
if not __debug__:
    raise RuntimeError("Run analysis without Python -O")

import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXPERIMENT = HERE.parent / "2026-10-29-cyclic-split64-screen"
PARENT = HERE.parent / "2026-10-29-exact-budget-range"
COMMIT = "33ad882da3f5bff603f4b51559f3cd4833778fee"
CYCLIC = "CyclicSplit64RangeExperiment"
METRICS = ("lookup_ns", "hash_lookup_ns")
CAPS = (16, 32)
CEILINGS = (.01, .001, .0001)
sys.path.insert(0, str(EXPERIMENT))
from run_screen import BINARY, verify
from select_plan import select
from validate_rows import validate
from order_oracle import require, source_registry, validate_order


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wilson(fp, count):
    require(count > 0 and 0 <= fp <= count, "Invalid calibration sample")
    z = 1.959963984540054
    zz, p = z * z, fp / count
    denominator = 1 + zz / count
    center = p + zz / (2 * count)
    width = z * math.sqrt((p * (1 - p) + zz / (4 * count)) / count)
    return (0 if fp == 0 else max(0, (center - width) / denominator),
            1 if fp == count else min(1, (center + width) / denominator))


def upper(row):
    return wilson(int(row["calibration_false_positives"]), int(row["calibration_absent_queries"]))[1]


def owner(row):
    if row["filter"] == CYCLIC:
        require(row["implementation_origin"] == "project_experiment", "Wrong cyclic ownership")
        return "cyclic"
    origin = row["implementation_origin"]
    require(origin in ("external", "production_native", "project_experiment"), "Unknown ownership")
    if origin == "project_experiment":
        require(row["filter"] in ("ByteSplitRangeExperiment", "Split64RangeExperiment"), "Unknown range experiment")
        return "range"
    return "production" if origin == "production_native" else "external"


def eligible(row, cap, ceiling):
    return int(row["filter_bytes"]) * 8 <= int(row["keys"]) * cap and upper(row) <= ceiling


def available(row, metric):
    value = float(row[metric])
    if row["input_mode"] == "raw_bytes" and metric == "lookup_ns":
        require(math.isnan(value), "Raw-only API has a pure value")
        return False
    require(math.isfinite(value) and value > 0, "Invalid measured metric")
    return True


def fastest(rows, metric):
    usable = [r for r in rows if available(r, metric)]
    return min(usable, key=lambda r: (float(r[metric]), int(r["filter_bytes"]), r["configuration_id"])) if usable else None


def verify_case(entry, case, index, screen, configs, registry):
    require(entry["case"] == case, "Case changed or reordered")
    power, budget = case["key_power"], case["budget_bpk"]
    command = [str(BINARY), str(power), str(budget), "50", "22", "4096", "6", "42", ",".join(case["filters"]), str(1 << power), "24", "query-only", "0"]
    require(entry["command"] == command, "Wrong measured command")
    stem = f"case-{index:02d}-n{power}-b{budget}"
    stdout, stderr = screen / (stem + ".stdout"), screen / (stem + ".stderr")
    require(sha(stdout) == entry["stdout_sha256"] and sha(stderr) == entry["stderr_sha256"], "Changed raw case output")
    with stdout.open() as stream:
        rows = list(csv.DictReader(stream))
    expected = {configs[c]["filter"]: configs[c] for c in case["configuration_ids"]}
    require(len(expected) == len(case["configuration_ids"]) == entry["rows"], "Wrong case cardinality")
    validate(rows, expected, power=power, budget=budget, query_power=22, batch=4096, repeats=6, seed=42, calibration_power=24)
    order = validate_order(rows, registry, case["filters"], 1 << power, 1 << 22, 42, 50)
    for row in rows:
        record = expected[row["filter"]]
        row.update(configuration_id=record["configuration_id"], calibration_identity=record["calibration_identity"])
    return rows, dict(case_index=index, key_power=power, requested_bpk=budget, exact_source_derived_order=order)


def verify_aggregate(rows, ordered, configurations):
    require(len(rows) == len(configurations), "Wrong aggregate count")
    require(len({r["configuration_id"] for r in rows}) == len(rows)
            and {r["configuration_id"] for r in rows} == set(configurations), "Duplicate/missing aggregate configuration")
    require(rows == ordered, "Aggregate differs from exact ordered raw outputs")


def load_checked():
    screen = EXPERIMENT / "screen"
    meta = json.loads((screen / "metadata.json").read_text())
    require(meta["complete"] and meta["rows"] == 62 and len(meta["cases"]) == 13, "Incomplete matrix")
    require(meta["source_commit"] == COMMIT, "Wrong frozen source revision")
    require(meta["affinity"] == [3] and meta["socket_lock"] == "/tmp/fastest-bf-socket1.lock" and meta["inherited_lock_descriptors"], "Wrong execution lease")
    anchor = verify(COMMIT)
    require(meta["anchor"] == anchor, "Changed committed source/dependency/binary anchors")
    frozen = json.loads((EXPERIMENT / "FREEZE.json").read_text())
    require(len(frozen["source_sha256"]) == 214 and len(frozen["binary_sha256"]) == 27, "Wrong freeze cardinalities")
    plan_path = EXPERIMENT / "validation-v1/selection.json"
    plan = json.loads(plan_path.read_text())
    grid = json.loads((EXPERIMENT / "validation-v1/planned-grid.json").read_text())
    parent = json.loads((EXPERIMENT / "parent-selection.json").read_text())
    require(select(grid, parent) == plan, "Selection cannot be regenerated from fixed geometry inputs")
    require(sha(plan_path) == meta["selection_sha256"], "Selection changed")
    configs = {r["configuration_id"]: r for r in plan["configurations"]}
    require(len(configs) == 62 and len(plan["cases"]) == 13, "Wrong frozen selection")
    registry = source_registry((EXPERIMENT / "adapters.hpp").read_text(), (PARENT / "cpp-adapters.hpp").read_text(),
                               (PARENT / "boost-adapters.hpp").read_text(), (PARENT / "rocks-adapters.hpp").read_text())
    require(registry == grid["registry"], "Planner registry differs from compiled-source macros")
    ordered, orders = [], []
    for index, (entry, case) in enumerate(zip(meta["cases"], plan["cases"])):
        rows, order = verify_case(entry, case, index, screen, configs, registry)
        ordered.extend(rows)
        orders.append(order)
    require(len({r["configuration_id"] for r in ordered}) == 62 and {r["configuration_id"] for r in ordered} == set(configs), "Duplicate/missing configuration")
    result_path = screen / "results.csv"
    require(sha(result_path) == meta["results_sha256"], "Changed aggregate")
    with result_path.open() as stream:
        rows = list(csv.DictReader(stream))
    verify_aggregate(rows, ordered, configs)
    require({owner(r) for r in rows} == {"external", "production", "range", "cyclic"}, "Missing ownership category")
    return rows, plan, meta, orders


def quality(rows):
    groups = {}
    for row in rows:
        identity = (row["calibration_identity"], int(row["keys"]), int(row["seed"]))
        sample = tuple(row[k] for k in ("calibration_absent_queries", "calibration_false_positives", "filter_bytes", "result_checksum", "false_positives", "absent_queries"))
        if identity in groups:
            require(groups[identity][0] == sample, "Shared calibration identity disagrees")
            groups[identity][1].append(row)
        else:
            groups[identity] = (sample, [row])
    result = []
    for (identity, keys, seed), (_, members) in sorted(groups.items()):
        row = members[0]
        count, fp = int(row["calibration_absent_queries"]), int(row["calibration_false_positives"])
        lo, hi = wilson(fp, count)
        result.append(dict(calibration_identity=identity, keys=keys, seed=seed, filter_bytes=int(row["filter_bytes"]),
                           family_aliases="|".join(r["filter"] for r in members), configuration_ids="|".join(r["configuration_id"] for r in members),
                           count=count, false_positives=fp, fpr=fp/count, wilson_lower=lo, wilson_upper=hi,
                           eligible_1pct=hi <= .01, eligible_0_1pct=hi <= .001, eligible_0_01pct=hi <= .0001))
    return result


def history_checked():
    path = HERE / "prior-quality.json"
    history = json.loads(path.read_text())
    for relative, digest in history["inputs_sha256"].items():
        require(sha(ROOT / relative) == digest, "Prior quality provenance changed")
    prior = ROOT / history["results_path"]
    require(history["records"] == prior_quality_records(prior), "Prior quality differs from raw frozen counts")
    for row in history["records"]:
        lo, hi = wilson(row["false_positives"], row["count"])
        require(row["wilson_lower"] == lo and row["wilson_upper"] == hi, "Prior quality endpoint changed")
    return history


def prior_quality_records(path):
    # Only quality columns are ever imported from the older binary's output.
    result = []
    with path.open() as stream:
        for row in csv.DictReader(stream):
            if row["filter"] != "FourSectorBloomFilter" or float(row["actual_bpk"]) != 16:
                continue
            fp, count = int(row["calibration_false_positives"]), int(row["calibration_absent_queries"])
            lo, hi = wilson(fp, count)
            result.append(dict(configuration_id=row["configuration_id"], filter=row["filter"], keys=int(row["keys"]),
                               filter_bytes=int(row["filter_bytes"]), actual_bpk=16, seed=int(row["seed"]),
                               count=count, false_positives=fp, wilson_lower=lo, wilson_upper=hi))
    require(len(result) == 6 and len({(r["keys"], r["seed"]) for r in result}) == 6, "Wrong historical quality grid")
    return result


def prior_failure(row, history, ceiling):
    values = [r["wilson_upper"] for r in history["records"] if r["filter"] == row["filter"] and r["keys"] == int(row["keys"]) and r["filter_bytes"] == int(row["filter_bytes"])]
    return bool(values) and max(values) > ceiling


def entry(row, metric, history, ceiling):
    if row is None:
        return None
    prefix = metric[:-3]
    return dict(configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row),
                requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
                median_ns=float(row[metric]), min_ns=float(row[prefix + "_min_ns"]), max_ns=float(row[prefix + "_max_ns"]),
                trials=json.loads(row[prefix + "_trials_ns"]), wilson_upper=upper(row), prior_heldout_quality_failure=prior_failure(row, history, ceiling))


def rankings(rows, history):
    result, individual = [], []
    for keys in sorted({int(r["keys"]) for r in rows}):
        group = [r for r in rows if int(r["keys"]) == keys]
        for metric in METRICS:
            for cap in CAPS:
                for ceiling in CEILINGS:
                    feasible = [r for r in group if eligible(r, cap, ceiling)]
                    picked = {label: fastest([r for r in feasible if owner(r) == label], metric) for label in ("external", "production", "range", "cyclic")}
                    item = dict(keys=keys, metric=metric, cap_bpk=cap, fpr_ceiling=ceiling,
                                **{label: entry(row, metric, history, ceiling) for label, row in picked.items()})
                    for rival in ("external", "production", "range"):
                        item[rival + "_over_cyclic"] = float(picked[rival][metric]) / float(picked["cyclic"][metric]) if picked[rival] is not None and picked["cyclic"] is not None else None
                    result.append(item)
                    for row in group:
                        valid = eligible(row, cap, ceiling) and available(row, metric)
                        rivals = {label: float(picked[label][metric]) / float(row[metric]) if valid and picked[label] is not None else None for label in ("external", "production", "range")}
                        individual.append(dict(keys=keys, metric=metric, cap_bpk=cap, fpr_ceiling=ceiling,
                                               configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row),
                                               requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
                                               within_cap=int(row["filter_bytes"]) * 8 <= keys * cap, quality_pass=upper(row) <= ceiling,
                                               metric_available=available(row, metric), eligible=valid, wilson_upper=upper(row),
                                               prior_heldout_quality_failure=prior_failure(row, history, ceiling),
                                               candidate_ns=float(row[metric]) if available(row, metric) else None,
                                               **{label + "_filter": picked[label]["filter"] if picked[label] is not None else None for label in rivals},
                                               **{label + "_over_candidate": ratio for label, ratio in rivals.items()},
                                               external_outcome=("candidate_faster" if rivals["external"] > 1 else "external_faster" if rivals["external"] < 1 else "exact_tie") if rivals["external"] is not None else "no_eligible_pair"))
    return result, individual


def csvout(path, rows):
    require(bool(rows), "Empty report table")
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader(); writer.writerows(rows)


def report(ranked, allocations, history, counts):
    lines = ["# Cyclic Split64: fixed62 training comparison", "",
             "All62 rows/13 cases passed frozen source/dependency/binary/commit checks, exact commands and raw-to-aggregate equality. The job-order oracle expands the frozen C++ registration macros, verifies the75-type planner registry, filters each case, advances the exact workload SplitMix draws and reconstructs every Fisher–Yates permutation.", "",
             "The scope is one seed42 CPU3/socket1 executable, two key counts, batch4096,2^22 timed queries,50% intended hits,six balanced pure/common-hash repetitions and2^24 disjoint calibration negatives per mapping. Every bitmap is built once and fully validated outside query timing. Build times remain NaN; no construction-speed claim is made. CPU affinity does not impose explicit NUMA memory binding.", "",
             "The shortlist retains54 previously selected configurations and adds eight prespecified cyclic geometries. This is not an all75-type speed comparison or held-out confirmation. Every fastest allocation below is a descriptive selection within the measured shortlist. Cap32 admits smaller tested allocations, including24-bpk rivals and28-bpk cyclic. No older-binary latency enters a ratio.", "",
             "## All eight cyclic allocations", "",
             "| Keys | Actual bpk | Wilson95 upper FPR | Pass0.1% | Pass0.01% | Prehashed ns | Common hash+query ns |",
             "| ---: | ---: | ---: | --- | --- | ---: | ---: |"]
    for row in allocations:
        if row["owner"] == "cyclic":
            lines.append(f"| {row['keys']} | {row['actual_bpk']:g} | {row['wilson_upper']:.6%} | {row['wilson_upper'] <= .001} | {row['wilson_upper'] <= .0001} | {row['lookup_ns']:.4f} | {row['hash_lookup_ns']:.4f} |")
    lines += ["", "## Eligible cyclic versus retained rivals", "",
              "Ratios are rival/cyclic; above1 favors cyclic. Counts are nested budget/quality views that reuse observations, not independent significance trials.", "",
              "| Rival | Contract | Comparable views | Cyclic wins / losses / ties | Minimum ratio | Maximum ratio |",
              "| --- | --- | ---: | --- | ---: | ---: |"]
    for row in counts:
        lo = f"{row['minimum_ratio']:.4f}" if row["minimum_ratio"] is not None else "—"
        hi = f"{row['maximum_ratio']:.4f}" if row["maximum_ratio"] is not None else "—"
        lines.append(f"| {row['rival']} | {row['metric']} | {row['comparable_views']} | {row['cyclic_faster']}/{row['rival_faster']}/{row['exact_ties']} | {lo} | {hi} |")
    lines += ["", "## All24 allocation/quality/contract views", "",
              "Each cell gives filter, actual bpk and median ns. A dagger marks a configuration with a prior held-out quality failure at this threshold; a current seed42 pass does not erase it.", "",
              "| Keys | Contract | Cap | FPR limit | Cyclic | External | Production | Range experiment | External/cyclic |",
              "| ---: | --- | ---: | ---: | --- | --- | --- | --- | ---: |"]
    def fmt(value):
        if value is None:
            return "No qualifier"
        mark = "†" if value["prior_heldout_quality_failure"] else ""
        return f"{value['filter']}{mark}; {value['actual_bpk']:.4g}bpk; {value['median_ns']:.4f}ns"
    for row in ranked:
        ratio = row["external_over_cyclic"]
        value = f"{ratio:.4f}" if ratio is not None else "—"
        cells = " | ".join(fmt(row[label]) for label in ("cyclic", "external", "production", "range"))
        lines.append(f"| {row['keys']} | {row['metric']} | {row['cap_bpk']} | {row['fpr_ceiling']:.2%} | {cells} | {value} |")
    lines += ["", "## Preserved earlier quality evidence", "",
              "Only six FourSector actual16-bpk quality records are imported from the previous three-seed confirmation; no latency column is imported. Each old record keeps its separate confidence bound and never adds negatives to this training screen.", "",
              "| Keys | Earlier seed | False positives / negatives | Wilson95 upper FPR | Pass0.1% |",
              "| ---: | ---: | --- | ---: | --- |"]
    for row in history["records"]:
        lines.append(f"| {row['keys']} | {row['seed']} | {row['false_positives']}/{row['count']} | {row['wilson_upper']:.6%} | {row['wilson_upper'] <= .001} |")
    lines += ["", "## Limits and retained evidence", "",
              "Known calibration aliases collapse to56 records. No counts are pooled across mappings, sizes, seeds or earlier runs. Each quality gate uses the pointwise two-sided95% Wilson upper endpoint; selection across many candidates does not imply simultaneous coverage.", "",
              "Filter order is randomized within each selected case and verified exactly, but one seed does not balance pair order. Cases execute in sorted key-count/budget groups, so different allocations can be measured in different processes and fixed case positions. Six alternating query phases balance pure/common-hash order within each filter, not filter or case order. Observed trial min/max are retained and are not speed confidence intervals.", "",
              "all-allocations.csv retains all62 configurations, actual bytes, quality, both trial vectors, min/max and exact case/row positions. individual-comparisons.csv retains744 individual allocation alternatives, including every failed/ineligible configuration. cyclic-comparisons.csv retains all96 cyclic alternatives and pure/hash losses. rankings.json keeps production, range experiments, cyclic and external ownership separate. No candidate is promoted by this training report.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    rows, plan, meta, orders = load_checked()
    history = history_checked()
    q = quality(rows)
    ranked, individual = rankings(rows, history)
    cyclic = [r for r in individual if r["owner"] == "cyclic"]
    require((len(q), len(ranked), len(individual), len(cyclic)) == (56, 24, 744, 96), "Wrong result cardinalities")
    locations = {(1 << r["key_power"], r["requested_bpk"], name): (r["case_index"], position)
                 for r in orders for position, name in enumerate(r["exact_source_derived_order"])}
    allocations = []
    for row in rows:
        allocation = dict(configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row), keys=int(row["keys"]),
                          requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
                          calibration_count=int(row["calibration_absent_queries"]), calibration_fp=int(row["calibration_false_positives"]),
                          wilson_upper=upper(row), prior_heldout_0_1pct_failure=prior_failure(row, history, .001))
        case_index, row_position = locations[(int(row["keys"]), int(row["requested_bpk"]), row["filter"])]
        allocation.update(case_index=case_index, row_position=row_position)
        for metric in METRICS:
            prefix = metric[:-3]
            allocation.update({metric: float(row[metric]) if available(row, metric) else None,
                               prefix + "_min_ns": float(row[prefix + "_min_ns"]) if available(row, metric) else None,
                               prefix + "_max_ns": float(row[prefix + "_max_ns"]) if available(row, metric) else None,
                               prefix + "_trials_ns": row[prefix + "_trials_ns"]})
        allocations.append(allocation)
    counts = []
    for rival in ("external", "production", "range"):
        for metric in METRICS:
            values = [r[rival + "_over_cyclic"] for r in ranked if r["metric"] == metric and r[rival + "_over_cyclic"] is not None]
            counts.append(dict(rival=rival, metric=metric, comparable_views=len(values), cyclic_faster=sum(v > 1 for v in values),
                               rival_faster=sum(v < 1 for v in values), exact_ties=sum(v == 1 for v in values),
                               minimum_ratio=min(values) if values else None, maximum_ratio=max(values) if values else None))
    summary = dict(scope="Seed42 cyclic62 training shortlist, same CPU3 binary only; no held-out/global leadership claim",
                   source_commit=COMMIT, anchor=meta["anchor"], rows=62, cases=13, unique_quality_records=56,
                   rankings=24, individual_alternatives=744, cyclic_alternatives=96,
                   metrics=list(METRICS), quality_rule="Pointwise Wilson95 upper; known aliases deduplicated, no pooling; prior held-out failures remain visible",
                   order_rule="Exact source-derived job orders verified; one seed is not filter-order balanced; case groups execute in fixed sorted n/budget order",
                   results_sha256=meta["results_sha256"], metadata_sha256=sha(EXPERIMENT / "screen/metadata.json"),
                   analysis_sha256=sha(Path(__file__)), order_oracle_sha256=sha(HERE / "order_oracle.py"),
                   prior_quality_sha256=sha(HERE / "prior-quality.json"),
                   comparison_counts=counts,
                   eligible_cyclic_losses=[r for r in cyclic if r["external_outcome"] == "external_faster"])
    args.output.mkdir(exist_ok=False, parents=True)
    for name, values in (("quality", q), ("all-allocations", allocations), ("individual-comparisons", individual), ("cyclic-comparisons", cyclic)):
        csvout(args.output / (name + ".csv"), values)
    for name, values in (("summary", summary), ("rankings", ranked), ("row-orders", orders), ("prior-quality", history)):
        (args.output / (name + ".json")).write_text(json.dumps(values, indent=2, allow_nan=False) + "\n")
    (args.output / "RESULTS.md").write_text(report(ranked, allocations, history, counts))
    print("PASS:13 exact source-derived orders;62 allocations;56 unpooled quality records;24 views;744 alternatives including96 cyclic")


if __name__ == "__main__":
    main()
