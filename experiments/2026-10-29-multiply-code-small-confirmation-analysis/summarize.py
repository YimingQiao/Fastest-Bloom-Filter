#!/usr/bin/env python3
"""Analyze the complete fixed144 fresh-seed confirmation without running a BF."""
if not __debug__:
    raise RuntimeError("Do not use Python -O")

import argparse
from collections import defaultdict
import csv
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGE = HERE.parent / "2026-10-29-multiply-code-small-confirmation"
COMMIT = "8a77b5d9190872b3cf06be8946650bd6e4fd8e0d"
sys.path.insert(0, str(STAGE / "driver"))
from audit import audit
from contract import MUL, FOUR, protocol
from source_guard import require, sha
sys.path.pop(0)

METRICS = ("lookup_ns", "hash_lookup_ns")
POLICIES = ("main_all_fresh", "secondary_preregistered_restricted", "descriptive_current_seed")
CLASSES = ("external", "retained_project", "all_rivals")
FILTERS = [c["filter"] for c in protocol()["configurations"]]


def owner(name):
    if name == MUL:
        return "multiply_experiment"
    if name == "Split64RangeExperiment":
        return "range_experiment"
    if name in ("Split64BloomFilter", FOUR):
        return "production_native"
    require(name in FILTERS, "Unknown API")
    return "external"


def outcome(speedup):
    return "win" if speedup > 1 else "loss" if speedup < 1 else "tie"


def summarize_ratios(values):
    require(values and all(math.isfinite(x) and x > 0 for x in values), "Invalid ratio sample")
    return dict(observations=len(values), geometric_mean=math.exp(statistics.mean(math.log(x) for x in values)),
                median=statistics.median(values), minimum=min(values), maximum=max(values),
                wins=sum(x > 1 for x in values), losses=sum(x < 1 for x in values), ties=sum(x == 1 for x in values))


def eligible(name, seed, policy, q):
    across = next(r for r in q["across_seed_gate"] if r["filter"] == name)
    if policy == "main_all_fresh":
        require(across["main_competitive_eligible"] == across["all_fresh_seeds_pass"], "Main policy drift")
        return across["all_fresh_seeds_pass"]
    if policy == "secondary_preregistered_restricted":
        require(across["robust_eligible"] == (across["all_fresh_seeds_pass"] and name != FOUR), "Restricted policy drift")
        return across["robust_eligible"]
    require(policy == "descriptive_current_seed", "Unknown policy")
    return next(r["current_pass"] for r in q["api_seed_records"] if r["filter"] == name and r["seed"] == seed)


def load():
    meta = json.loads((STAGE / "confirmation/metadata.json").read_text())
    require(meta["complete"] is True and meta["source_commit"] == COMMIT, "Require complete committed144 confirmation")
    rows, q = audit()
    require(meta["lease"]["cpu"] == 3 and meta["lease"]["socket"] == 1, "This run is CPU3/socket1 only")
    require(len(rows) == 144 and len(q["api_seed_records"]) == 48 and len(q["mapping_seed_records"]) == 36,
            "Wrong complete sample counts")
    return rows, q, meta


def compare(rows, q, p):
    require(len(rows) == 144, "Require all144 rows")
    groups, positions = {}, {}
    for i, case in enumerate(p["cases"]):
        part = rows[i * 8:(i + 1) * 8]
        key = (case["seed"], case["batch"])
        require(len(part) == 8 and set(r["filter"] for r in part) == set(FILTERS), "Incomplete case")
        groups[key] = {r["filter"]: r for r in part}
        positions[key] = {r["filter"]: j for j, r in enumerate(part)}
        require(positions[key][MUL] == case["multiply_position"] in (0, 7), "Order stratum mismatch")
    require(len(groups) == 18, "Repeated case identity")
    pairs, alternatives, views = [], [], []
    for seed, batch in groups:
        group, position = groups[(seed, batch)], positions[(seed, batch)]
        stratum = "multiply_first" if position[MUL] == 0 else "multiply_last"
        candidate = group[MUL]
        for metric in METRICS:
            trial = metric.removesuffix("_ns") + "_trials_ns"
            candidate_ns = float(candidate[metric])
            for name in FILTERS[1:]:
                rival = group[name]
                speedup = float(rival[metric]) / candidate_ns
                pairs.append(dict(seed=seed, batch=batch, metric=metric, order_stratum=stratum,
                                  candidate=MUL, rival=name, rival_owner=owner(name),
                                  candidate_position=position[MUL], rival_position=position[name],
                                  candidate_ns=candidate_ns, rival_ns=float(rival[metric]), speedup=speedup,
                                  outcome=outcome(speedup), candidate_trials=json.loads(candidate[trial]),
                                  rival_trials=json.loads(rival[trial]),
                                  candidate_main_eligible=eligible(MUL, seed, "main_all_fresh", q),
                                  rival_main_eligible=eligible(name, seed, "main_all_fresh", q),
                                  candidate_current_pass=eligible(MUL, seed, "descriptive_current_seed", q),
                                  rival_current_pass=eligible(name, seed, "descriptive_current_seed", q)))
            for policy in POLICIES:
                admitted = {name for name in FILTERS if eligible(name, seed, policy, q)}
                for name in FILTERS:
                    row = group[name]
                    alternatives.append(dict(policy=policy, seed=seed, batch=batch, metric=metric,
                                             order_stratum=stratum, filter=name, owner=owner(name),
                                             filter_bytes=int(row["filter_bytes"]), actual_bpk=float(row["actual_bpk"]),
                                             eligible=name in admitted, row_position=position[name],
                                             latency_ns=float(row[metric]), trials=json.loads(row[trial])))
                for rival_class in CLASSES:
                    def in_class(name):
                        return name != MUL and (rival_class == "all_rivals" or
                              (owner(name) == "external" if rival_class == "external" else owner(name) != "external"))
                    candidates = [name for name in FILTERS if name in admitted and in_class(name)]
                    best = min((float(group[name][metric]) for name in candidates), default=None)
                    leaders = [name for name in candidates if float(group[name][metric]) == best]
                    speedup = best / candidate_ns if best is not None else None
                    views.append(dict(policy=policy, seed=seed, batch=batch, metric=metric,
                                      rival_class=rival_class, order_stratum=stratum,
                                      candidate_eligible=MUL in admitted, candidate_ns=candidate_ns,
                                      rival_leaders=leaders, rival_ns=best, speedup=speedup,
                                      eligible_comparison=MUL in admitted and bool(leaders),
                                      outcome=outcome(speedup) if speedup is not None else "no_eligible_rival"))
    require((len(pairs), len(alternatives), len(views)) == (252, 864, 324), "Wrong comparison cardinalities")
    pair_summaries, order_summaries, view_summaries = [], [], []
    for metric in METRICS:
        for batch in (1, 31, 4096):
            for name in FILTERS[1:]:
                selected = [r for r in pairs if (r["metric"], r["batch"], r["rival"]) == (metric, batch, name)]
                require(len(selected) == 6, "Missing pair seed")
                pair_summaries.append(dict(metric=metric, batch=batch, rival=name, **summarize_ratios([r["speedup"] for r in selected])))
                for stratum in ("multiply_first", "multiply_last"):
                    part = [r for r in selected if r["order_stratum"] == stratum]
                    require(len(part) == 3, "Each pair must preserve3:3 candidate-relative order")
                    order_summaries.append(dict(metric=metric, batch=batch, rival=name, order_stratum=stratum,
                                               **summarize_ratios([r["speedup"] for r in part])))
            for policy in POLICIES:
                for rival_class in CLASSES:
                    selected = [r for r in views if (r["policy"], r["metric"], r["batch"], r["rival_class"]) ==
                                (policy, metric, batch, rival_class)]
                    require(len(selected) == 6, "Missing policy-view seed")
                    usable = [r["speedup"] for r in selected if r["eligible_comparison"]]
                    view_summaries.append(dict(policy=policy, metric=metric, batch=batch, rival_class=rival_class,
                                               total_seed_observations=6, eligible_observations=len(usable),
                                               **(summarize_ratios(usable) if usable else {})))
    require((len(pair_summaries), len(order_summaries), len(view_summaries)) == (42, 84, 54), "Wrong grouped counts")
    return dict(pairs=pairs, alternatives=alternatives, views=views, pair_summaries=pair_summaries,
                order_summaries=order_summaries, view_summaries=view_summaries)


def save_json(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + "\n")


def save_csv(path, records):
    with path.open("w", newline="") as stream:
        fields = list(dict.fromkeys(key for row in records for key in row))
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows({k: json.dumps(v, separators=(",", ":")) if isinstance(v, (list, dict)) else v
                          for k, v in row.items()} for row in records)


def report(result, q, meta):
    main = [r for r in result["views"] if r["policy"] == "main_all_fresh" and r["rival_class"] == "all_rivals"]
    wins = sum(r["eligible_comparison"] and r["outcome"] == "win" for r in main)
    losses = sum(r["eligible_comparison"] and r["outcome"] == "loss" for r in main)
    ties = sum(r["eligible_comparison"] and r["outcome"] == "tie" for r in main)
    lines = ["# Multiply16 fixed fresh-seed confirmation", "",
             f"Main competitive policy: Multiply wins {wins}, loses {losses}, ties {ties} of the36 seed/batch/query-contract comparisons with an eligible candidate and rival. Ineligible comparisons remain in the tables and are not counted as wins.", "",
             "This is a fixed small-table confirmation:65,536 inserted keys, actual allocation≤16 bits/key,0.1% Wilson-upper gate, batches1/31/4096, six fresh order-conditioned seeds,2^22 mixed queries and six balanced query repetitions. It does not establish a global fastest Bloom filter or a new production recommendation.", "",
             "## Accuracy and qualification", "",
             "48 API/seed records reduce to36 distinct mapping/seed samples. Range/Fixed64 and the two RocksDB APIs share bitmap semantics; their negatives and the three batch repeats are never pooled. All48 raw API endpoints and all36 distinct samples are retained in quality.json.", "",
             "| API | Largest fresh Wilson95 upper (%) | Pass all six | Main eligible | Original restricted set |",
             "|---|---:|:---:|:---:|:---:|"]
    for r in q["across_seed_gate"]:
        lines.append(f"| {r['filter']} | {r['worst_wilson95_high'] * 100:.8f} | {r['all_fresh_seeds_pass']} | {r['main_competitive_eligible']} | {r['robust_eligible']} |")
    four = [r for r in q["api_seed_records"] if r["filter"] == FOUR]
    failures = sum(not r["current_pass"] for r in four)
    lines += ["", "The main competitive policy includes every API passing all six fresh endpoints, including FourSector. The originally fixed restricted set excludes FourSector and is reported only as a secondary policy. A historical upper endpoint above0.1% did not prove true FPR above0.1%: a separate pre-confirmation audit measured117,440,512 new disjoint negatives on each of the two old constructions, and both new endpoints passed. That precision evidence is pinned by the runner and is never pooled into this confirmation.", "",
              f"In the NEW six-seed confirmation, FourSector has {failures} failed upper-endpoint gate(s), independently of its old diagnostic label. This makes the main and restricted eligible sets coincide here if all other APIs pass. The new interval does not establish the unknown true FPR is above the target; its lower endpoint must be considered too. Five or six individually passing constructions are not a universal bound.", "",
              "| Fresh FourSector seed | FP /2^24 | Point FPR (%) | Wilson95 low–high (%) | Current gate |",
              "|---:|---:|---:|---:|:---:|"]
    for r in four:
        lines.append(f"| {r['seed']} | {r['false_positives']} | {r['false_positives'] / r['negatives'] * 100:.8f} | {r['wilson95_low'] * 100:.8f}–{r['wilson95_high'] * 100:.8f} | {r['current_pass']} |")
    lines += ["",
              "## Main comparison against the fastest eligible rival", "",
              "Ratios are rival latency divided by Multiply latency, so values above1 favor Multiply. Each cell summarizes six data/order observations; it is not a confidence interval or a pooling of timed queries.", "",
              "| Query contract | Batch | Eligible seeds | Geomean ratio | Min–max | Wins/losses/ties |", "|---|---:|---:|---:|---:|---:|"]
    for r in result["view_summaries"]:
        if r["policy"] == "main_all_fresh" and r["rival_class"] == "all_rivals":
            ratio = f"{r['geometric_mean']:.4f}×" if r["eligible_observations"] else "n/a"
            span = f"{r['minimum']:.4f}–{r['maximum']:.4f}" if r["eligible_observations"] else "n/a"
            score = f"{r['wins']}/{r['losses']}/{r['ties']}" if r["eligible_observations"] else "n/a"
            lines.append(f"| {r['metric']} | {r['batch']} | {r['eligible_observations']}/6 | {ratio} | {span} | {score} |")
    lines += ["", "Separate external-only and retained-project leaders, the original restricted set and per-seed current qualification appear in policy-views.csv and policy-summary.csv. All equal-latency leaders are retained; secondary or current-only winners must not be described as overall eligible winners.", "",
              "### External and native comparisons", "",
              "The external result is limited to these four prespecified APIs. Native Split64 and original Range remain separate competitors; FourSector timings remain visible even when its all-six-seed gate fails.", "",
              "| Query contract | Batch | Versus fastest eligible external | External win/loss/tie | Versus native Split64 | Versus original Range | Versus FourSector (timing only) |",
              "|---|---:|---:|---:|---:|---:|---:|"]
    for metric in METRICS:
        for batch in (1, 31, 4096):
            external = next(r for r in result["view_summaries"] if (r["policy"], r["rival_class"], r["metric"], r["batch"]) ==
                            ("main_all_fresh", "external", metric, batch))
            named = {r["rival"]: r for r in result["pair_summaries"] if (r["metric"], r["batch"]) == (metric, batch)}
            eratio = f"{external['geometric_mean']:.4f}×" if external["eligible_observations"] else "n/a"
            score = f"{external['wins']}/{external['losses']}/{external['ties']}" if external["eligible_observations"] else "n/a"
            ratios = [f"{named[name]['geometric_mean']:.4f}×" for name in ("Split64BloomFilter", "Split64RangeExperiment", FOUR)]
            lines.append(f"| {metric} | {batch} | {eratio} | {score} | " + " | ".join(ratios) + " |")
    current = [r for r in result["views"] if r["policy"] == "descriptive_current_seed" and r["rival_class"] == "all_rivals"]
    current_wins = sum(r["eligible_comparison"] and r["outcome"] == "win" for r in current)
    current_losses = sum(r["eligible_comparison"] and r["outcome"] == "loss" for r in current)
    lines += ["", f"Under the separate per-seed current gate, Multiply wins {current_wins} and loses {current_losses} of the36 comparisons. This difference matters: FourSector can be a faster bulk-query rival on constructions that pass the current gate, even when it is excluded by the stricter all-six-seed rule. Both views are reported; neither the historical precision audit nor the newly failing endpoint is suppressed.", "",
              "## Every named rival and both order strata", "",
              "pair-summary.csv keeps all42 named-rival/batch/contract groups and every per-seed ratio remains in pairs.csv (252 comparisons). order-summary.csv keeps84 groups split into three Multiply-first and three Multiply-last seeds. The design balances candidate-relative order, not all eight absolute positions. Geometric means remain descriptive; inspecting both strata does not remove allocation-placement or sequential-execution effects.", "",
              "| Query contract | Batch | Versus native Split64: Multiply first | Multiply last |",
              "|---|---:|---:|---:|"]
    for metric in METRICS:
        for batch in (1, 31, 4096):
            records = {r["order_stratum"]: r for r in result["order_summaries"] if (r["metric"], r["batch"], r["rival"]) ==
                       (metric, batch, "Split64BloomFilter")}
            lines.append(f"| {metric} | {batch} | {records['multiply_first']['geometric_mean']:.4f}× | {records['multiply_last']['geometric_mean']:.4f}× |")
    lines += ["", "Near-parity results whose sign changes between order strata are fragile and should not support an unconditional speed claim. Every named-rival minimum, maximum and individual loss remains in the CSVs; a favorable mean does not replace those observations.", "",
              "All864 API/policy/seed/batch/contract alternatives, including losses and ineligible APIs, are in alternatives.csv. The raw144 rows preserve every trial and min/max; no candidate mapping, allocation, hash, insertion method or timer changed after the seed42 training screen.", "",
              "## Reproduction and limits", "",
              f"Driver commit `{COMMIT}`; compiled source `{meta['compiled_source_commit']}`; binary SHA `{meta['binary_sha256']}`. CPU3/socket1 was held under one inherited exclusive flock for the matrix. Only CPU affinity was applied; no NUMA memory-binding claim is made.", "",
              "The analysis requires all18 cases complete and rechecks336 source/evidence hashes,39 executables, committed local archive bytes, exact commands, source-derived row/phase order, all trial vectors, raw/aggregate equality, checksums and calibration alias identity. It verifies the raw archive manifest before interpreting results. Separate prior accuracy samples are contextual evidence only; neither old timing nor repeated-stream negative counts enters the current ratios or endpoints.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    rows, q, meta = load()
    result = compare(rows, q, protocol())
    args.output.mkdir(exist_ok=False)
    for key, name in (("pairs", "pairs"), ("alternatives", "alternatives"), ("views", "policy-views"),
                      ("pair_summaries", "pair-summary"), ("order_summaries", "order-summary"),
                      ("view_summaries", "policy-summary")):
        save_csv(args.output / (name + ".csv"), result[key])
    save_json(args.output / "quality.json", q)
    save_json(args.output / "verified.json", dict(source_commit=COMMIT, raw_results_sha256=sha(STAGE / "confirmation/results.csv"),
                                                  raw_manifest_sha256=sha(STAGE / "confirmation/archive-manifest.json"),
                                                  metadata_sha256=sha(STAGE / "confirmation/metadata.json"),
                                                  rows=144, cases=18, api_seed_quality_records=48,
                                                  mapping_seed_quality_records=36,
                                                  counts={key: len(value) for key, value in result.items()},
                                                  quality_pooling=False, performance_rerun=False))
    (args.output / "REPORT.md").write_text(report(result, q, meta))
    print("Verified144 rows;252 pairs;864 alternatives;324 policy views;42 pair/84 order/54 policy summaries")


if __name__ == "__main__":
    main()
