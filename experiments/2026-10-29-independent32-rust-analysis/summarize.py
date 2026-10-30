#!/usr/bin/env python3
"""Analyze the unchanged Rust132 training screen; no benchmark execution."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
EXPERIMENT = HERE.parent / "2026-10-29-independent32-rust-screen"
sys.path.insert(0, str(EXPERIMENT))
from freeze import verify
from guard import CONTROLS, require, validate_all, workloads
from run import verify_commit

CANDIDATE = "Independent32BloomFilter"
BYTE = "ByteLeafInlineV1"
OWNERS = ("native", "native_experimental", "external")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wilson(fp, count):
    require(count > 0 and 0 <= fp <= count, "Invalid calibration count")
    z = 1.959963984540054
    p, zz = fp / count, z * z
    denominator = 1 + zz / count
    center = p + zz / (2 * count)
    width = z * math.sqrt((p * (1 - p) + zz / (4 * count)) / count)
    return (0 if fp == 0 else max(0, (center - width) / denominator),
            1 if fp == count else min(1, (center + width) / denominator))


def upper(row):
    return wilson(int(row["calibration_false_positives"]), int(row["calibration_absent_queries"]))[1]


def eligible(row, cap, ceiling):
    return int(row["filter_bytes"]) * 8 <= int(row["keys"]) * cap and upper(row) <= ceiling


def fastest(rows, metric):
    return min(rows, key=lambda row: (float(row[metric]), int(row["filter_bytes"]), row["filter"])) if rows else None


def outcome(ratio):
    return "candidate_faster" if ratio > 1 else "rival_faster" if ratio < 1 else "exact_tie"


def entry(row, metric, registry):
    if row is None:
        return None
    prefix = metric[:-3]
    return dict(filter=row["filter"], owner=registry[row["filter"]]["owner"],
                requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]),
                filter_bytes=int(row["filter_bytes"]), median_ns=float(row[metric]),
                min_ns=float(row[prefix + "_min_ns"]), max_ns=float(row[prefix + "_max_ns"]),
                wilson_upper=upper(row))


def quality_records(rows, registry):
    unique = {}
    for row in rows:
        mapping = registry[row["filter"]]["original"]
        identity = (mapping, int(row["keys"]), int(row["requested_bpk"]), int(row["seed"]))
        count, fp = int(row["calibration_absent_queries"]), int(row["calibration_false_positives"])
        values = (count, fp, int(row["filter_bytes"]), float(row["actual_bpk"]))
        if identity in unique:
            require(unique[identity][0] == values, "Repeated calibration stream disagrees")
            unique[identity][1].add(row["filter"])
        else:
            unique[identity] = (values, {row["filter"]})
    result = []
    for (mapping, keys, bpk, seed), ((count, fp, size, actual), aliases) in sorted(unique.items()):
        low, high = wilson(fp, count)
        result.append(dict(calibration_family=mapping, owner=registry[mapping]["owner"], aliases="|".join(sorted(aliases)),
                           keys=keys, requested_bpk=bpk, actual_bpk=actual, filter_bytes=size, seed=seed,
                           calibration_negatives=count, calibration_fp=fp, fpr=fp / count,
                           wilson_lower=low, wilson_upper=high))
    return result


def rankings(rows, registry, protocol):
    result, individuals = [], []
    for seed in protocol["seeds"]:
        for power in protocol["key_powers"]:
            keys = 1 << power
            for batch in protocol["batches"]:
                group = [row for row in rows if int(row["keys"]) == keys and int(row["batch"]) == batch and int(row["seed"]) == seed]
                for metric in protocol["ranking"]["metrics"]:
                    for cap in protocol["ranking"]["memory_caps_bpk"]:
                        for ceiling in protocol["ranking"]["fpr_ceilings"]:
                            feasible = [row for row in group if eligible(row, cap, ceiling)]
                            picked = {owner: fastest([r for r in feasible if registry[r["filter"]]["owner"] == owner], metric) for owner in OWNERS}
                            picked["independent32"] = fastest([r for r in feasible if r["filter"] == CANDIDATE], metric)
                            picked["byte_leaf"] = fastest([r for r in feasible if r["filter"] == BYTE], metric)
                            item = dict(keys=keys, batch=batch, seed=seed, metric=metric, memory_cap_bpk=cap, fpr_ceiling=ceiling,
                                        **{name: entry(row, metric, registry) for name, row in picked.items()})
                            for rival in ("external", "byte_leaf", "native"):
                                item[rival + "_over_independent32"] = (float(picked[rival][metric]) / float(picked["independent32"][metric])
                                                                       if picked[rival] is not None and picked["independent32"] is not None else None)
                            result.append(item)
                            # Preserve both tested allocations of every native
                            # configuration, including ineligible and losing rows.
                            for row in group:
                                if registry[row["filter"]]["owner"] == "external":
                                    continue
                                qualifies = eligible(row, cap, ceiling)
                                ext = picked["external"]
                                ratio = float(ext[metric]) / float(row[metric]) if qualifies and ext is not None else None
                                individuals.append(dict(keys=keys, batch=batch, seed=seed, metric=metric, memory_cap_bpk=cap,
                                                        fpr_ceiling=ceiling, candidate=row["filter"], owner=registry[row["filter"]]["owner"],
                                                        requested_bpk=int(row["requested_bpk"]), actual_bpk=float(row["actual_bpk"]),
                                                        filter_bytes=int(row["filter_bytes"]), wilson_upper=upper(row), eligible=qualifies,
                                                        candidate_ns=float(row[metric]), candidate_min_ns=float(row[metric[:-3] + "_min_ns"]),
                                                        candidate_max_ns=float(row[metric[:-3] + "_max_ns"]),
                                                        external=ext["filter"] if ext is not None else None,
                                                        external_requested_bpk=int(ext["requested_bpk"]) if ext is not None else None,
                                                        external_ns=float(ext[metric]) if ext is not None else None,
                                                        external_over_candidate=ratio, outcome=outcome(ratio) if ratio is not None else "no_eligible_pair"))
    return result, individuals


def ratios(rows, registry, protocol):
    index = {(r["filter"], r["keys"], r["requested_bpk"], r["batch"], r["seed"]): r for r in rows}
    pairs, api = [], []
    for row in rows:
        common = dict(keys=int(row["keys"]), requested_bpk=int(row["requested_bpk"]), batch=int(row["batch"]), seed=int(row["seed"]))
        if row["filter"] in CONTROLS:
            original = index[(CONTROLS[row["filter"]], row["keys"], row["requested_bpk"], row["batch"], row["seed"])]
            for metric in protocol["ranking"]["metrics"]:
                ratio = float(original[metric]) / float(row[metric])
                pairs.append(dict(**common, candidate=row["filter"], original=original["filter"], metric=metric,
                                  original_ns=float(original[metric]), candidate_ns=float(row[metric]), original_over_candidate=ratio,
                                  outcome=outcome(ratio)))
        for mode, generic, visible in (("prehashed", "lookup_ns", "inline_lookup_ns"), ("common_hash", "hash_lookup_ns", "inline_hash_lookup_ns")):
            ratio = float(row[generic]) / float(row[visible])
            api.append(dict(**common, filter=row["filter"], owner=registry[row["filter"]]["owner"], mode=mode,
                            generic_ns=float(row[generic]), visible_ns=float(row[visible]), generic_over_visible=ratio,
                            outcome="visible_faster" if ratio > 1 else "generic_faster" if ratio < 1 else "exact_tie"))
    return pairs, api


def aggregates(rankings, protocol):
    result = []
    for batch in protocol["batches"]:
        for metric in protocol["ranking"]["metrics"]:
            for rival in ("external", "byte_leaf", "native"):
                values = [r[rival + "_over_independent32"] for r in rankings if r["batch"] == batch and r["metric"] == metric and r[rival + "_over_independent32"] is not None]
                result.append(dict(batch=batch, metric=metric, rival=rival, comparable_views=len(values),
                                   independent32_faster=sum(x > 1 for x in values), rival_faster=sum(x < 1 for x in values), exact_ties=sum(x == 1 for x in values),
                                   minimum_ratio=min(values) if values else None, maximum_ratio=max(values) if values else None))
    return result


def csvout(path, rows):
    require(bool(rows), "Empty table: " + str(path))
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def load_checked():
    screen = EXPERIMENT / "screen"
    meta = json.loads((screen / "metadata.json").read_text())
    protocol = json.loads((EXPERIMENT / "protocol.json").read_text())
    registry = json.loads((EXPERIMENT / "registry.json").read_text())
    frozen = json.loads((EXPERIMENT / "validation/freeze.json").read_text())
    verify(frozen)
    verify_commit(meta["source_commit"], frozen)
    require(meta["complete"] and meta["rows"] == protocol["rows"] == 132 and meta["workloads"] == protocol["workloads"] == 12, "Incomplete matrix")
    require(meta["cpu"] == protocol["cpu"] == 3 and meta["affinity"] == [3], "Wrong CPU")
    require(meta["freeze_sha256"] == sha(EXPERIMENT / "validation/freeze.json") and meta["protocol_sha256"] == sha(EXPERIMENT / "protocol.json"), "Changed source manifest")
    require(meta["binary_sha256"] == protocol["binary_sha256"], "Wrong executable")
    require(meta["results_sha256"] == sha(screen / "results.csv"), "Changed aggregate results")
    expected_workloads = set(workloads(protocol))
    require(len(meta["commands"]) == len(expected_workloads) and {tuple(e["workload"]) for e in meta["commands"]} == expected_workloads, "Wrong commands")
    all_rows = []
    for command in meta["commands"]:
        power, bpk, batch, seed = command["workload"]
        require(command["complete"] and command["returncode"] == 0 and command["rows"] == 11, "Failed command")
        path = screen / f"k{power}-p{bpk}-b{batch}-s{seed}.csv"
        require(command["csv_sha256"] == sha(path), "Changed workload output")
        all_rows.extend(csv.DictReader(path.open()))
    rows = list(csv.DictReader((screen / "results.csv").open()))
    require(rows == all_rows, "Aggregate differs from ordered individual workload outputs")
    validate_all(rows, registry, protocol)
    return rows, registry, protocol, meta


def report(rankings, counts, summary):
    lines = ["# Independent32 Rust initial screen", "", "This seed42 CPU3 training screen compares eleven frozen public APIs in one executable. It is not held-out confirmation or a global-fastest claim. All132 rows, full outputs, trial vectors, phase balance, retained-control semantics and source/dependency/binary hashes passed.", "",
             "The four contracts remain separate: generic batch prehashed, generic batch with staged common hash, whole-array visible public singleton prehashed, and visible singleton with fused common hash. These are independent-key throughput tests. Visible loops process the complete array at every batch tag; those tags do not create distinct singleton algorithms.", "",
             "Key counts2^16/2^25, actual allocations16/32bpk, batches1/31/4096,50% hits,2^22 queries, eight balanced repetitions and2^24 separate calibration negatives. Whole-input build metrics remain in raw rows. CPU3/socket1 affinity and the exclusive inherited flock cover the complete matrix; memory is not explicitly NUMA-bound.", "",
             "Eligibility uses actual allocated bytes and the pointwise two-sided95% Wilson upper endpoint. Cap32 includes tested16bpk allocations. Known leaf aliases and repeated batch/mode streams do not add negatives. There are32 family/size/seed calibration records; distinct public API families can implement the same mapping and are kept separate without pooling. These are nested resource/quality views, not independent speed or confidence experiments.", "",
             "## Independent32 comparison counts", "", "Ratios are rival/Independent32; above1 favors Independent32. Ineligible pairs are omitted from these descriptive counts but retained in the detailed tables. All individual native configurations and allocations, including every loss, are in `individual-native.csv`.", "",
             "| Batch | Mode | Rival | Comparable views | Independent32 faster / rival faster / ties | Lowest ratio | Highest ratio |", "| ---: | --- | --- | ---: | --- | ---: | ---: |"]
    for item in counts:
        low = f"{item['minimum_ratio']:.3f}" if item["minimum_ratio"] is not None else "—"
        high = f"{item['maximum_ratio']:.3f}" if item["maximum_ratio"] is not None else "—"
        lines.append(f"| {item['batch']} | {item['metric']} | {item['rival']} | {item['comparable_views']} | {item['independent32_faster']}/{item['rival_faster']}/{item['exact_ties']} | {low} | {high} |")
    for batch in (1, 31, 4096):
        for metric in ("lookup_ns", "hash_lookup_ns", "inline_lookup_ns", "inline_hash_lookup_ns"):
            lines += ["", f"## Batch{batch} {metric}", "", "| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |", "| ---: | ---: | ---: | --- | --- | --- | ---: |"]
            for item in rankings:
                if item["batch"] != batch or item["metric"] != metric:
                    continue
                def fmt(value):
                    return f"{value['filter']} ({value['median_ns']:.3f},{value['actual_bpk']:g})" if value else "No qualifier"
                ratio = item["external_over_independent32"]
                lines.append(f"| {item['keys']} | {item['memory_cap_bpk']} | {item['fpr_ceiling']:.2%} | {fmt(item['independent32'])} | {fmt(item['external'])} | {fmt(item['byte_leaf'])} | {ratio:.3f} |" if ratio is not None else f"| {item['keys']} | {item['memory_cap_bpk']} | {item['fpr_ceiling']:.2%} | {fmt(item['independent32'])} | {fmt(item['external'])} | {fmt(item['byte_leaf'])} | — |")
    lines += ["", "`rankings.json` preserves all144 cap/FPR/mode/batch views, with the fastest original native, experimental native, external, Independent32 and ByteLeaf choices kept separate. `individual-native.csv` preserves2304 eligible and ineligible individual native comparisons; `leaf-ratios.csv` preserves144 exact original/leaf comparisons; `api-ratios.csv` preserves264 generic/visible ratios; `quality.csv` preserves32 family/size/seed calibration records. Trial min/max are observed ranges, not speed confidence intervals. The16/32bpk grid does not cover finer capacities, and only the three frozen Rust external families participate in this screen.", ""]
    return "\n".join(lines)


def main():
    require(__debug__, "Run analysis without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    rows, registry, protocol, meta = load_checked()
    quality = quality_records(rows, registry)
    require(len(quality) == protocol["quality_unique_records"] == 32, "Wrong family/size/seed calibration record count")
    ranked, individual = rankings(rows, registry, protocol)
    pairs, api = ratios(rows, registry, protocol)
    require((len(ranked), len(individual), len(pairs), len(api)) == (144, 2304, 144, 264), "Unexpected output counts")
    counts = aggregates(ranked, protocol)
    summary = dict(scope="Seed42 CPU3 Rust132 initial screen; no held-out or global leadership claim", source_commit=meta["source_commit"],
                   binary_sha256=meta["binary_sha256"], results_sha256=meta["results_sha256"], analysis_sha256=sha(Path(__file__)),
                   rows=132, workloads=12, configurations=11, metrics=protocol["ranking"]["metrics"],
                   rankings=144, individual_native_comparisons=2304, leaf_pairs=144, api_ratios=264,
                   family_size_seed_calibration_records=32, aggregates=counts,
                   quality_rule="Per-family/size/seed pointwise Wilson95 upper; known leaf aliases and batch/mode duplicates deduplicated; separate public families are not pooled even when mappings coincide",
                   allocation_rule="All tested allocations satisfying the cap compete, including actual16 under cap32")
    args.output.mkdir(parents=True, exist_ok=False)
    for filename, table in (("quality.csv", quality), ("individual-native.csv", individual), ("leaf-ratios.csv", pairs), ("api-ratios.csv", api)):
        csvout(args.output / filename, table)
    for name, data in (("rankings.json", ranked), ("summary.json", summary)):
        (args.output / name).write_text(json.dumps(data, indent=2, allow_nan=False) + "\n")
    (args.output / "RESULTS.md").write_text(report(ranked, counts, summary))
    print("PASS:144 rankings,2304 individual native rows,144 leaf pairs,264 API ratios,32 family/size/seed quality records")


if __name__ == "__main__":
    main()
