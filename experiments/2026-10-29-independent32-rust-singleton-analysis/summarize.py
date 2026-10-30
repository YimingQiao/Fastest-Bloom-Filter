#!/usr/bin/env python3
"""Analyze the unchanged Rust192 singleton training screen; no benchmark execution."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
EXPERIMENT = HERE.parent / "2026-10-29-independent32-rust-singleton-screen"
sys.path.insert(0, str(EXPERIMENT))
from freeze import verify
from guard import CONTROLS, require, validate_all, workloads
from run import verify_commit

CANDIDATE = "Independent32SingletonV1"
BEFORE = "Independent32BloomFilter"
from order_oracle import validate_order
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
    orders = {}
    for row in rows:
        key = tuple(row[k] for k in ("keys", "requested_bpk", "batch", "seed"))
        orders.setdefault(key, []).append(row["filter"])
    pairs, api = [], []
    for row in rows:
        common = dict(keys=int(row["keys"]), requested_bpk=int(row["requested_bpk"]), batch=int(row["batch"]), seed=int(row["seed"]))
        if row["filter"] in CONTROLS:
            original = index[(CONTROLS[row["filter"]], row["keys"], row["requested_bpk"], row["batch"], row["seed"])]
            for metric in protocol["ranking"]["metrics"]:
                ratio = float(original[metric]) / float(row[metric])
                prefix = metric[:-3]
                order = orders[tuple(row[k] for k in ("keys", "requested_bpk", "batch", "seed"))]
                pairs.append(dict(**common, candidate=row["filter"], original=original["filter"], metric=metric,
                                  original_ns=float(original[metric]), candidate_ns=float(row[metric]), original_over_candidate=ratio,
                                  original_min_ns=float(original[prefix + "_min_ns"]), original_max_ns=float(original[prefix + "_max_ns"]),
                                  candidate_min_ns=float(row[prefix + "_min_ns"]), candidate_max_ns=float(row[prefix + "_max_ns"]),
                                  original_trials=original[prefix + "_trials"], candidate_trials=row[prefix + "_trials"],
                                  original_position=order.index(original["filter"]), candidate_position=order.index(row["filter"]),
                                  candidate_first=order.index(row["filter"]) < order.index(original["filter"]),
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
    require(meta["complete"] and meta["rows"] == protocol["rows"] == 192 and meta["workloads"] == protocol["workloads"] == 16, "Incomplete matrix")
    require(meta["cpu"] == protocol["cpu"] == 2 and meta["affinity"] == [2], "Wrong CPU")
    require(meta["lease"]["lease"] == "socket0" and meta["lease"]["cpu"] == 2
            and meta["socket_lock"] == meta["lease"]["lock_path"] == "/tmp/fastest-bf-socket0.lock"
            and bool(meta["lease"]["inherited_lock_descriptors"]), "Wrong matrix lease")
    require(meta["freeze_sha256"] == sha(EXPERIMENT / "validation/freeze.json") and meta["protocol_sha256"] == sha(EXPERIMENT / "protocol.json"), "Changed source manifest")
    require(meta["binary_sha256"] == protocol["binary_sha256"], "Wrong executable")
    require(meta["results_sha256"] == sha(screen / "results.csv"), "Changed aggregate results")
    expected_workloads = list(workloads(protocol))
    require([tuple(e["workload"]) for e in meta["commands"]] == expected_workloads, "Wrong command sequence")
    all_rows = []
    source = (EXPERIMENT / "benchmark/src/main.rs").read_text()
    order_records = []
    for command in meta["commands"]:
        power, bpk, batch, seed = command["workload"]
        require(command["complete"] and command["returncode"] == 0 and command["rows"] == 12, "Failed command")
        path = screen / f"k{power}-p{bpk}-b{batch}-s{seed}.csv"
        require(command["csv_sha256"] == sha(path), "Changed workload output")
        case_rows = list(csv.DictReader(path.open()))
        expected_command = ["taskset", "-c", "2", protocol["binary"], str(power), str(bpk),
                            str(protocol["hit_percent"]), str(protocol["query_power"]), str(batch),
                            str(protocol["repeats"]), str(seed), ",".join(protocol["filters"]),
                            str(1 << power), str(protocol["calibration_power"])]
        require(command["command"] == expected_command, "Wrong measured command")
        order = validate_order(case_rows, protocol, command["workload"], source)
        order_records.append(dict(workload=command["workload"], exact_source_derived_order=order))
        all_rows.extend(case_rows)
    rows = list(csv.DictReader((screen / "results.csv").open()))
    require(rows == all_rows, "Aggregate differs from ordered individual workload outputs")
    validate_all(rows, registry, protocol)
    meta = dict(meta, verified_row_orders=order_records)
    return rows, registry, protocol, meta


def controlled_groups(pairs):
    result = []
    candidates = sorted({row["candidate"] for row in pairs})
    for candidate in candidates:
        for batch in sorted({row["batch"] for row in pairs}):
            for metric in ("lookup_ns", "hash_lookup_ns", "inline_lookup_ns", "inline_hash_lookup_ns"):
                group = [r for r in pairs if (r["candidate"], r["batch"], r["metric"]) == (candidate, batch, metric)]
                values = [r["original_over_candidate"] for r in group]
                require(bool(values), "Missing controlled condition")
                result.append(dict(candidate=candidate, batch=batch, metric=metric, conditions=len(values),
                                   geomean_original_over_candidate=math.exp(sum(math.log(v) for v in values) / len(values)),
                                   minimum_ratio=min(values), maximum_ratio=max(values),
                                   candidate_faster=sum(v > 1 for v in values), original_faster=sum(v < 1 for v in values),
                                   exact_ties=sum(v == 1 for v in values)))
    return result


def report(ranked, counts, summary, pairs, controlled):
    lines = ["# Independent32 singleton shortcut: CPU2 training screen", "",
             "This compares the exact four-line public lookup shortcut with the unchanged Independent32 implementation and ten retained controls in one executable. It is a seed42 training screen, not fresh-seed confirmation or a global-fastest claim.", "",
             "All192 rows from16 workloads pass full-output, clone, phase, trial-vector, quality and cross-batch checks. A separate sidecar reconstructs every row permutation from the frozen Rust producer's RNG consumption and source registration order. Source/dependency/binary hashes and committed blobs are checked before interpreting measurements.", "",
             "The four contracts remain separate: generic batch prehashed; generic batch with staged common hash; whole-array visible public singleton prehashed; and visible singleton with fused common hash. Every visible loop still processes the whole query array at every batch tag. Measurements describe independent-query throughput, not dependent lookup latency.", "",
             "CPU2/socket0, one complete inherited exclusive flock lease, n=2^16/2^25, actual16/32bpk, batch1/2/31/4096,2^20 timed queries,50% hits,four balanced query repetitions,2^20 independent calibration negatives,whole-input insertion. CPU affinity does not impose explicit NUMA memory binding. No cross-CPU or earlier-binary timing ratios are used.", "",
             "Filter row order is randomized but this one-seed screen is not pair-order balanced: the shortcut appears at zero-based position1 for n=2^16 and0 for n=2^25, while unchanged Independent32 is position9 in both. Four-mode phase balance does not remove that between-filter order limitation. A confirmation would need fresh seeds and retained/reversed pair-order strata.", "",
             "The source change preserves mapping, allocation and insertion, but compiled bulk code is not identical: the new public lookup saves six callee-saved registers rather than one, and its portable scalar remainder calls contains_scalar. These are part of the candidate being measured. The prior public visible API is unchanged in source; placement/code generation can still change its timing.", "",
             "## Exact before/after comparison", "",
             "Ratios are unchanged Independent32 / shortcut; above1 favors the shortcut. Each row below summarizes the four size/allocation conditions descriptively; min/max are the paired median-ratio range, not a confidence interval.", "",
             "| Batch | Contract | Shortcut wins / losses / ties | Geometric mean ratio | Minimum | Maximum |",
             "| ---: | --- | --- | ---: | ---: | ---: |"]
    for row in controlled:
        if row["candidate"] != CANDIDATE:
            continue
        lines.append(f"| {row['batch']} | {row['metric']} | {row['candidate_faster']}/{row['original_faster']}/{row['exact_ties']} | {row['geomean_original_over_candidate']:.4f} | {row['minimum_ratio']:.4f} | {row['maximum_ratio']:.4f} |")
    lines += ["", "All64 exact shortcut/before comparisons follow, including visible and larger-batch losses. Each underlying trial vector and observed min/max remains in controlled-ratios.csv.", "",
              "| Keys | Actual bpk | Batch | Contract | Before ns | Shortcut ns | Before / shortcut |",
              "| ---: | ---: | ---: | --- | ---: | ---: | ---: |"]
    for row in sorted((r for r in pairs if r["candidate"] == CANDIDATE), key=lambda r: (r["keys"], r["requested_bpk"], r["batch"], r["metric"])):
        lines.append(f"| {row['keys']} | {2 * row['requested_bpk']} | {row['batch']} | {row['metric']} | {row['original_ns']:.4f} | {row['candidate_ns']:.4f} | {row['original_over_candidate']:.4f} |")
    lines += ["", "## Quality-gated external comparisons", "",
              "Each mode independently selects the fastest measured external allocation under the actual-byte cap and pointwise two-sided95% Wilson upper FPR limit. Actual16bpk configurations compete under cap32. These are postprocessed nested budget/FPR views; they are not independent significance trials or a simultaneous confidence guarantee.", "",
              "| Batch | Contract | Rival | Comparable views | Shortcut wins / losses / ties | Minimum rival/shortcut | Maximum |",
              "| ---: | --- | --- | ---: | --- | ---: | ---: |"]
    for item in counts:
        lo = f"{item['minimum_ratio']:.4f}" if item["minimum_ratio"] is not None else "—"
        hi = f"{item['maximum_ratio']:.4f}" if item["maximum_ratio"] is not None else "—"
        lines.append(f"| {item['batch']} | {item['metric']} | {item['rival']} | {item['comparable_views']} | {item['independent32_faster']}/{item['rival_faster']}/{item['exact_ties']} | {lo} | {hi} |")
    lines += ["", "Strict0.01%/cap32 views (all tested eligible allocations compete):", "",
              "| Keys | Batch | Contract | Shortcut ns | External | External ns | External/shortcut |",
              "| ---: | ---: | --- | ---: | --- | ---: | ---: |"]
    for item in ranked:
        if item["memory_cap_bpk"] != 32 or item["fpr_ceiling"] != .0001:
            continue
        cand, rival = item["independent32"], item["external"]
        c = f"{cand['median_ns']:.4f}" if cand else "No qualifier"
        r = f"{rival['median_ns']:.4f}" if rival else "No qualifier"
        name = rival["filter"] if rival else "None"
        ratio = item["external_over_independent32"]
        value = f"{ratio:.4f}" if ratio is not None else "—"
        lines.append(f"| {item['keys']} | {item['batch']} | {item['metric']} | {c} | {name} | {r} | {value} |")
    lines += ["", "rankings.json retains192 cap/FPR/batch/mode views, separating original native, experimental native, external, shortcut and ByteLeaf choices. individual-native.csv retains3456 individual eligible/ineligible native-allocation comparisons. controlled-ratios.csv retains256 exact control pairs (64 shortcut/before plus192 leaf/original). api-ratios.csv retains384 generic/visible ratios. quality.csv retains32 family/size/seed records, deduplicating known clone and batch/mode reuse without pooling across families; distinct public families can implement the same mapping. The calibration denominator is2^20 here and is never pooled with earlier seed42 screens that used different intervals or denominators.", "",
              "The external scope is the three frozen Rust public API families in this binary. Only actual16/32bpk allocations were tested; finer capacities and other implementations are outside this screen. Trial min/max are observed ranges, not speed confidence intervals.", ""]
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
    require((len(ranked), len(individual), len(pairs), len(api)) == (192, 3456, 256, 384), "Unexpected output counts")
    counts = aggregates(ranked, protocol)
    controlled = controlled_groups(pairs)
    summary = dict(scope="Seed42 CPU2 Rust192 singleton training screen; no held-out or global leadership claim", source_commit=meta["source_commit"],
                   binary_sha256=meta["binary_sha256"], results_sha256=meta["results_sha256"], analysis_sha256=sha(Path(__file__)),
                   rows=192, workloads=16, configurations=12, metrics=protocol["ranking"]["metrics"],
                   rankings=192, individual_native_comparisons=3456, controlled_pairs=256, api_ratios=384,
                   family_size_seed_calibration_records=32, aggregates=counts,
                   quality_rule="Per-family/size/seed pointwise Wilson95 upper; known leaf aliases and batch/mode duplicates deduplicated; separate public families are not pooled even when mappings coincide",
                   allocation_rule="All tested allocations satisfying the cap compete, including actual16 under cap32",
                   exact_shortcut_pairs=[r for r in pairs if r["candidate"] == CANDIDATE],
                   all_controlled_losses=[r for r in pairs if r["original_over_candidate"] < 1],
                   controlled_aggregates=controlled,
                   order_oracle_sha256=sha(HERE / "order_oracle.py"),
                   metadata_sha256=sha(EXPERIMENT / "screen/metadata.json"),
                   freeze_sha256=sha(EXPERIMENT / "validation/freeze.json"),
                   protocol_sha256=sha(EXPERIMENT / "protocol.json"),
                   registry_sha256=sha(EXPERIMENT / "registry.json"),
                   row_orders=meta["verified_row_orders"])
    args.output.mkdir(parents=True, exist_ok=False)
    (args.output / "row-orders.json").write_text(json.dumps(meta["verified_row_orders"], indent=2) + "\n")
    for filename, table in (("quality.csv", quality), ("individual-native.csv", individual), ("controlled-ratios.csv", pairs), ("controlled-groups.csv", controlled), ("api-ratios.csv", api)):
        csvout(args.output / filename, table)
    for name, data in (("rankings.json", ranked), ("summary.json", summary)):
        (args.output / name).write_text(json.dumps(data, indent=2, allow_nan=False) + "\n")
    (args.output / "RESULTS.md").write_text(report(ranked, counts, summary, pairs, controlled))
    print("PASS:16 exact source-derived row orders;192 rankings,3456 individual native rows,256 controlled pairs,384 API ratios,32 family/size/seed quality records")


if __name__ == "__main__":
    main()
