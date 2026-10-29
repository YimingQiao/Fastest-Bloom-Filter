#!/usr/bin/env python3
"""Analyze only the frozen multiply70 same-process training screen."""
if not __debug__:
    raise RuntimeError("Run analysis without Python -O")

import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import sys
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXPERIMENT = HERE.parent / "2026-10-29-multiply-code-split64-screen"
PARENT = HERE.parent / "2026-10-29-exact-budget-range"
COMMIT = "9e4362f1068d37d134ef8447a44146b52c1edc9f"
PARENT_DATA_COMMIT = "fe41689efd4f283abedf066ea1416fcfbe8d9444"
MUL = "MultiplyCodeSplit64RangeExperiment"
OWNERS = ("external", "production", "range", "cyclic", "multiply")
RIVALS = ("external", "production", "range", "cyclic")
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
    origin = row["implementation_origin"]
    if row["filter"] in (MUL, CYCLIC):
        require(origin == "project_experiment", "Wrong mask-candidate ownership")
        return "multiply" if row["filter"] == MUL else "cyclic"
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
    require(meta["complete"] and meta["rows"] == 70 and len(meta["cases"]) == 13, "Incomplete matrix")
    require(meta["source_commit"] == COMMIT, "Wrong frozen source revision")
    require(meta["affinity"] == [3] and meta["socket_lock"] == "/tmp/fastest-bf-socket1.lock" and meta["inherited_lock_descriptors"], "Wrong execution lease")
    anchor = verify(COMMIT)
    require(meta["anchor"] == anchor, "Changed committed source/dependency/binary anchors")
    frozen = json.loads((EXPERIMENT / "FREEZE.json").read_text())
    require(len(frozen["source_sha256"]) == 321 and len(frozen["binary_sha256"]) == 39, "Wrong freeze cardinalities")
    plan_path = EXPERIMENT / "validation-v1/selection.json"
    plan = json.loads(plan_path.read_text())
    grid = json.loads((EXPERIMENT / "validation-v1/planned-grid.json").read_text())
    parent = json.loads((EXPERIMENT / "parent-selection.json").read_text())
    require(select(grid, parent) == plan, "Selection cannot be regenerated from fixed geometry inputs")
    require(sha(plan_path) == meta["selection_sha256"], "Selection changed")
    configs = {r["configuration_id"]: r for r in plan["configurations"]}
    require(len(configs) == 70 and len(plan["cases"]) == 13, "Wrong frozen selection")
    registry = source_registry((EXPERIMENT / "adapters.hpp").read_text(), (PARENT / "cpp-adapters.hpp").read_text(),
                               (PARENT / "boost-adapters.hpp").read_text(), (PARENT / "rocks-adapters.hpp").read_text())
    require(registry == grid["registry"], "Planner registry differs from compiled-source macros")
    ordered, orders = [], []
    for index, (entry, case) in enumerate(zip(meta["cases"], plan["cases"])):
        rows, order = verify_case(entry, case, index, screen, configs, registry)
        ordered.extend(rows)
        orders.append(order)
    require(len({r["configuration_id"] for r in ordered}) == 70 and {r["configuration_id"] for r in ordered} == set(configs), "Duplicate/missing configuration")
    result_path = screen / "results.csv"
    require(sha(result_path) == meta["results_sha256"], "Changed aggregate")
    with result_path.open() as stream:
        rows = list(csv.DictReader(stream))
    verify_aggregate(rows, ordered, configs)
    require({owner(r) for r in rows} == set(OWNERS), "Missing ownership category")
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
    path = EXPERIMENT / "prior-four-sector-quality.json"
    history = json.loads(path.read_text())
    for relative, digest in history["inputs_sha256"].items():
        require(sha(ROOT / relative) == digest, "Prior quality provenance changed")
    prior = ROOT / history["results_path"]
    require(history["records"] == prior_quality_records(prior), "Prior quality differs from raw frozen counts")
    for row in history["records"]:
        lo, hi = wilson(row["false_positives"], row["count"])
        require(row["wilson_lower"] == lo and row["wilson_upper"] == hi, "Prior quality endpoint changed")
    with (EXPERIMENT / "prior-cyclic-quality.csv").open() as stream:
        pilot = [row for row in csv.DictReader(stream) if row["filter"] == "CyclicSplit64Range"]
    require(len(pilot) == 8, "Wrong earlier cyclic pilot grid")
    history["cyclic_pilot_records"] = []
    for row in pilot:
        fp, count = int(row["false_positives"]), int(row["calibration_negatives"])
        lo, hi = wilson(fp, count)
        history["cyclic_pilot_records"].append(dict(filter=CYCLIC, keys=int(row["keys"]), filter_bytes=int(row["filter_bytes"]),
            actual_bpk=int(row["actual_bpk"]), seed=int(row["seed"]), count=count, false_positives=fp,
            wilson_lower=lo, wilson_upper=hi, scope="Earlier accuracy pilot; different counter interval, no imported latency or pooled probes"))
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
    values = [r["wilson_upper"] for r in history["records"] + history.get("cyclic_pilot_records", []) if r["filter"] == row["filter"] and r["keys"] == int(row["keys"]) and r["filter_bytes"] == int(row["filter_bytes"])]
    return bool(values) and max(values) > ceiling


def entry(row, metric, history, ceiling):
    if row is None:
        return None
    prefix = metric[:-3]
    return dict(configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row),
                requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
                median_ns=float(row[metric]), min_ns=float(row[prefix + "_min_ns"]), max_ns=float(row[prefix + "_max_ns"]),
                trials=json.loads(row[prefix + "_trials_ns"]), wilson_upper=upper(row), prior_quality_failure=prior_failure(row, history, ceiling))


def outcome(ratio):
    return "no_eligible_pair" if ratio is None else "candidate_faster" if ratio > 1 else "rival_faster" if ratio < 1 else "exact_tie"


def rankings(rows, history, exclude_prior=False):
    result, individual = [], []
    for keys in sorted({int(r["keys"]) for r in rows}):
        group = [r for r in rows if int(r["keys"]) == keys]
        for metric in METRICS:
            for cap in CAPS:
                for ceiling in CEILINGS:
                    feasible = [r for r in group if eligible(r, cap, ceiling) and not (exclude_prior and prior_failure(r, history, ceiling))]
                    picked = {label: fastest([r for r in feasible if owner(r) == label], metric) for label in OWNERS}
                    retained = fastest([r for r in feasible if owner(r) in ("production", "range", "cyclic")], metric)
                    rival_picks = {**{label: picked[label] for label in RIVALS}, "retained_project": retained}
                    item = dict(keys=keys, metric=metric, cap_bpk=cap, fpr_ceiling=ceiling,
                                **{label: entry(row, metric, history, ceiling) for label, row in picked.items()},
                                retained_project=entry(retained, metric, history, ceiling))
                    for label, rival in rival_picks.items():
                        item[label + "_over_multiply"] = float(rival[metric]) / float(picked["multiply"][metric]) if rival is not None and picked["multiply"] is not None else None
                    result.append(item)
                    for row in group:
                        valid = eligible(row, cap, ceiling) and available(row, metric) and not (exclude_prior and prior_failure(row, history, ceiling))
                        rivals = {label: float(rival[metric]) / float(row[metric]) if valid and rival is not None else None for label, rival in rival_picks.items()}
                        individual.append(dict(keys=keys, metric=metric, cap_bpk=cap, fpr_ceiling=ceiling,
                            configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row),
                            requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
                            within_cap=int(row["filter_bytes"])*8 <= keys*cap, quality_pass=upper(row) <= ceiling,
                            metric_available=available(row, metric), eligible=valid, wilson_upper=upper(row),
                            prior_quality_failure=prior_failure(row, history, ceiling),
                            candidate_ns=float(row[metric]) if available(row, metric) else None,
                            **{label + "_filter": rival["filter"] if rival is not None else None for label, rival in rival_picks.items()},
                            **{label + "_over_candidate": ratio for label, ratio in rivals.items()},
                            **{label + "_outcome": outcome(ratio) for label, ratio in rivals.items()}))
    return result, individual


def csvout(path, rows):
    require(bool(rows), "Empty report table")
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader(); writer.writerows(rows)


def retained_reproduction(rows, parent_rows):
    by_id = {row["configuration_id"]: row for row in rows}
    require(len(parent_rows) == 62 and len({row["configuration_id"] for row in parent_rows}) == 62, "Wrong retained parent count")
    fields = [field for field in parent_rows[0] if not field.endswith("_ns") and not field.endswith("_trials_ns")]
    evidence = []
    for old in parent_rows:
        current = by_id.get(old["configuration_id"])
        require(current is not None, "Missing retained control")
        require(all(current[field] == old[field] for field in fields), "Retained control semantic/calibration drift: " + old["filter"])
        evidence.append({field: current[field] for field in fields})
    return evidence


def control_history(rows):
    path = ROOT / "experiments/2026-10-29-cyclic-split64-screen/screen/results.csv"
    blob = subprocess.check_output(["git", "show", PARENT_DATA_COMMIT + ":" + str(path.relative_to(ROOT))], cwd=ROOT)
    require(path.read_bytes() == blob, "Retained parent data differs from immutable archive")
    with path.open() as stream:
        old = list(csv.DictReader(stream))
    return dict(scope="Semantic/quality reproduction only; no older latency is imported",
                parent_data_commit=PARENT_DATA_COMMIT, results_sha256=sha(path),
                records=retained_reproduction(rows, old))


def direct_pairs(rows):
    result = []
    for candidate in (row for row in rows if row["filter"] == MUL):
        for control in rows:
            if control["filter"] not in ("Split64RangeExperiment", CYCLIC, "Split64BloomFilter"):
                continue
            if (candidate["keys"], candidate["filter_bytes"]) != (control["keys"], control["filter_bytes"]):
                continue
            for metric in METRICS:
                result.append(dict(keys=int(candidate["keys"]), actual_bpk=float(candidate["actual_bpk"]), metric=metric,
                    candidate=MUL, control=control["filter"], control_owner=owner(control),
                    candidate_ns=float(candidate[metric]), control_ns=float(control[metric]),
                    control_over_candidate=float(control[metric])/float(candidate[metric]),
                    candidate_wilson_upper=upper(candidate), control_wilson_upper=upper(control),
                    candidate_configuration_id=candidate["configuration_id"], control_configuration_id=control["configuration_id"]))
    return result


def count_views(ranked):
    result = []
    for rival in (*RIVALS, "retained_project"):
        for metric in METRICS:
            ratios = [row[rival + "_over_multiply"] for row in ranked if row["metric"] == metric and row[rival + "_over_multiply"] is not None]
            result.append(dict(rival=rival, metric=metric, comparable_views=len(ratios),
                candidate_faster=sum(value > 1 for value in ratios), rival_faster=sum(value < 1 for value in ratios),
                exact_ties=sum(value == 1 for value in ratios), minimum_ratio=min(ratios) if ratios else None,
                maximum_ratio=max(ratios) if ratios else None))
    return result


def report(allocations, ranked, counts, pairs, history, conservative):
    lines = ["# Multiply-code Split64: fixed70 training screen", "",
        "All13 cases/70 rows passed committed source, dependency and binary hashes; exact commands, source-derived row order, four ownership distinctions plus the new candidate, trial vectors and raw-to-aggregate equality. All62 retained configurations reproduce the preceding Cyclic62 screen's workload, bytes, probes, dense checksum and calibration exactly. Earlier latency values are not imported.", "",
        "This is one seed42 CPU3/socket1 binary: n=2^16/2^25, batch4096, q=2^22,50% intended hits, six alternating prehashed/common-hash phases,2^24 disjoint calibration negatives per mapping and one complete build outside query timing. Build columns are NaN. CPU affinity is recorded; no explicit NUMA memory-binding or construction-speed claim is made.", "",
        "The measured shortlist retains62 old geometries and adds all8 fixed multiply-code geometries. It is not a speed measurement of all76 registered types or held-out confirmation. The24-row accuracy pilot uses a different counter interval from this shared benchmark: its candidate counts must not be required to reproduce here, substituted for current quality or pooled with this screen.", "",
        "## All eight multiply-code allocations", "",
        "| Keys | Actual bpk | FP / negatives | Wilson95 upper FPR | Pass0.1% | Pass0.01% | Prehashed ns | Common hash+query ns |",
        "|---:|---:|---|---:|:---:|:---:|---:|---:|"]
    for row in allocations:
        if row["owner"] == "multiply":
            lines.append(f"| {row['keys']:,} | {row['actual_bpk']:g} | {row['calibration_fp']}/{row['calibration_count']} | {row['wilson_upper']:.6%} | {row['wilson_upper'] <= .001} | {row['wilson_upper'] <= .0001} | {row['lookup_ns']:.4f} | {row['hash_lookup_ns']:.4f} |")
    lines += ["", "## Eligible comparisons", "",
        "Ratios are rival/multiply; above1 favors multiply. The24 nested views reuse measurements and are not independent significance trials. Production, original range experiments, cyclic, multiply and external ownership remain distinct. `retained_project` is an explicitly labeled minimum across production/original-range/cyclic controls.", "",
        "| Rival class | Contract | Comparable views | Multiply wins / losses / ties | Minimum ratio | Maximum ratio |",
        "|---|---|---:|---|---:|---:|"]
    for row in counts:
        lo = f"{row['minimum_ratio']:.4f}" if row["minimum_ratio"] is not None else "—"
        hi = f"{row['maximum_ratio']:.4f}" if row["maximum_ratio"] is not None else "—"
        lines.append(f"| {row['rival']} | {row['metric']} | {row['comparable_views']} | {row['candidate_faster']}/{row['rival_faster']}/{row['exact_ties']} | {lo} | {hi} |")
    lines += ["", "## All24 budget/quality/contract views", "",
        "Each cell gives the chosen measured allocation and median. A dagger flags earlier quality failure at this threshold: the FourSector records were held-out; Cyclic's older records were an accuracy pilot. Current seed42 qualification does not erase either history. Allocation selection is descriptive; cap32 admits every smaller eligible tested allocation.", "",
        "| Keys | Contract | Cap | FPR ceiling | Multiply | External | Production | Original range | Cyclic | Best retained project / multiply |",
        "|---:|---|---:|---:|---|---|---|---|---|---:|"]
    def fmt(value):
        if value is None:
            return "No qualifier"
        mark = "†" if value["prior_quality_failure"] else ""
        return f"{value['filter']}{mark};{value['actual_bpk']:.4g}bpk;{value['median_ns']:.4f}ns"
    for row in ranked:
        cells = " | ".join(fmt(row[label]) for label in ("multiply", "external", "production", "range", "cyclic"))
        ratio = row["retained_project_over_multiply"]
        shown = f"{ratio:.4f}" if ratio is not None else "—"
        lines.append(f"| {row['keys']:,} | {row['metric']} | {row['cap_bpk']} | {row['fpr_ceiling']:.2%} | {cells} | {shown} |")
    lines += ["", "## Known-failure exclusion sensitivity", "",
        "The primary tables use current-seed quality and flag history. This separate descriptive sensitivity also excludes a configuration when any retained earlier upper endpoint fails the current ceiling. It does not pool counts, is not a preregistered superiority test, and has unequal historical coverage across families. All24 sensitivity views remain in history-aware-rankings.json; changed retained-project winners are shown below.", "",
        "| Keys | Contract | Cap | FPR ceiling | Best remaining project | Multiply | Remaining project / multiply |",
        "|---:|---|---:|---:|---|---|---:|"]
    for primary, alternate in zip(ranked, conservative):
        if primary["retained_project"] == alternate["retained_project"]:
            continue
        ratio = alternate["retained_project_over_multiply"]
        shown = f"{ratio:.4f}" if ratio is not None else "—"
        lines.append(f"| {alternate['keys']:,} | {alternate['metric']} | {alternate['cap_bpk']} | {alternate['fpr_ceiling']:.2%} | {fmt(alternate['retained_project'])} | {fmt(alternate['multiply'])} | {shown} |")
    lines += ["", "This distinction matters at small cap16/0.1%: the primary FourSector16 winner has a known held-out quality failure. Excluding it allows the multiply candidate to lead the remaining measured project and external controls in this training view. Fresh fixed-rival confirmation is needed before accepting that advantage.", ""]
    lines += ["", "## Same-allocation controls", "",
        "These direct pairs use the same current executable and exact bitmap size. They do not impose equal FPR; both confidence endpoints are retained. Missing old geometries are not invented or filled with older timings.", "",
        "| Keys | Actual bpk | Contract | Control | Multiply ns | Control ns | Control / multiply |",
        "|---:|---:|---|---|---:|---:|---:|"]
    for row in pairs:
        lines.append(f"| {row['keys']:,} | {row['actual_bpk']:g} | {row['metric']} | {row['control']} | {row['candidate_ns']:.4f} | {row['control_ns']:.4f} | {row['control_over_candidate']:.4f} |")
    lines += ["", "## Preserved quality history and limits", "",
        "The six historical FourSector actual16 records and eight Cyclic pilot records are retained separately in prior-quality.json. They import counts/quality only, never old latency. Cyclic16 previously failed0.1% and Cyclic24 failed0.01% at both sizes. The older FourSector16 held-out upper-bound failures remain visible. These records are not pooled with current samples.", "",
        "Known aliases collapse the70 current rows to64 mapping/size/seed quality records. Each pointwise two-sided95% Wilson endpoint has its own denominator; many-candidate selection does not provide simultaneous coverage. Different configurations can occupy different fixed sorted case processes; one shuffled seed does not balance pair order. Trial min/max are observations, not speed confidence intervals.", "",
        "all-allocations.csv keeps all70 rows, actual bytes, both complete trial vectors/min/max and case/row positions. individual-comparisons.csv keeps840 allocation alternatives, including all failed/ineligible points; multiply-comparisons.csv keeps all96 candidate alternatives. All wins, losses and exact ties remain. Source/codegen changes, allocation placement, order and noise cannot be separated by this single training run. No production promotion or global-fastest claim follows.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    rows, plan, meta, orders = load_checked()
    controls = control_history(rows)
    history = history_checked()
    q = quality(rows)
    ranked, individual = rankings(rows, history)
    candidates = [row for row in individual if row["owner"] == "multiply"]
    require((len(q), len(ranked), len(individual), len(candidates)) == (64,24,840,96), "Wrong report cardinalities")
    locations = {(1 << row["key_power"], row["requested_bpk"], name): (row["case_index"], position)
                 for row in orders for position, name in enumerate(row["exact_source_derived_order"])}
    allocations = []
    for row in rows:
        case, position = locations[(int(row["keys"]), int(row["requested_bpk"]), row["filter"])]
        value = dict(configuration_id=row["configuration_id"], filter=row["filter"], owner=owner(row), keys=int(row["keys"]),
            requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]), filter_bytes=int(row["filter_bytes"]),
            calibration_count=int(row["calibration_absent_queries"]), calibration_fp=int(row["calibration_false_positives"]),
            wilson_upper=upper(row), case_index=case, row_position=position,
            prior_0_1pct_failure=prior_failure(row, history, .001), prior_0_01pct_failure=prior_failure(row, history, .0001))
        for metric in METRICS:
            prefix = metric[:-3]
            value.update({metric: float(row[metric]) if available(row, metric) else None,
                prefix + "_min_ns": float(row[prefix+"_min_ns"]) if available(row, metric) else None,
                prefix + "_max_ns": float(row[prefix+"_max_ns"]) if available(row, metric) else None,
                prefix + "_trials_ns": row[prefix+"_trials_ns"]})
        allocations.append(value)
    counts = count_views(ranked)
    conservative, _ = rankings(rows, history, exclude_prior=True)
    conservative_counts = count_views(conservative)
    pairs = direct_pairs(rows)
    summary = dict(scope="Seed42 Multiply70 training shortlist; current CPU3 binary only; no held-out/global leadership claim",
        source_commit=COMMIT, anchor=meta["anchor"], rows=70, cases=13, retained_reproductions=62,
        unique_quality_records=64, rankings=24, individual_alternatives=840, candidate_alternatives=96,
        same_allocation_pairs=len(pairs), comparison_counts=counts, known_failure_sensitivity_counts=conservative_counts, results_sha256=meta["results_sha256"],
        metadata_sha256=sha(EXPERIMENT / "screen/metadata.json"), analysis_sha256=sha(Path(__file__)),
        quality_rule="Pointwise Wilson95 upper; no pooling; earlier quality failures retained without old timing",
        order_rule="Exact source-derived job order; one unbalanced seed and fixed sorted case groups",
        prior_accuracy_contract="Separate24-row pilot uses different counter interval; do not require candidate count reproduction",
        eligible_external_losses=[row for row in candidates if row["external_outcome"] == "rival_faster"],
        eligible_retained_project_losses=[row for row in candidates if row["retained_project_outcome"] == "rival_faster"])
    args.output.mkdir(parents=True, exist_ok=False)
    for name, values in (("quality",q),("all-allocations",allocations),("individual-comparisons",individual),("multiply-comparisons",candidates),("same-allocation-pairs",pairs)):
        csvout(args.output / (name+".csv"), values)
    for name, values in (("summary",summary),("rankings",ranked),("row-orders",orders),("prior-quality",history),("retained-reproductions",controls),("history-aware-rankings",conservative),("history-aware-counts",conservative_counts)):
        (args.output / (name+".json")).write_text(json.dumps(values, indent=2, allow_nan=False)+"\n")
    (args.output / "RESULTS.md").write_text(report(allocations, ranked, counts, pairs, history, conservative))
    print("PASS:13 exact source-derived orders;70 rows;62 retained reproductions;64 unpooled quality records;24 views;840 alternatives including96 multiply")


if __name__ == "__main__":
    main()


