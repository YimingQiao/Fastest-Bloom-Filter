#!/usr/bin/env python3
"""Analyze the completed Rust120 exact-capacity training screen, never partial data."""
if not __debug__:
    raise RuntimeError("Do not use Python -O")

import argparse
from collections import defaultdict
import csv
import hashlib
import io
import itertools
import json
import math
from pathlib import Path
import statistics
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGE = HERE.parent / "2026-10-29-split64-range-rust-screen"
COMMIT = "2c7b1668880ab5a1e3ea0c73f2034b89da0d8650"
sys.path.insert(0, str(STAGE / "screening"))
import freeze as frozen_source
import guard
from run import command_for
sys.path.pop(0)

require = guard.require
RANGE = guard.RANGE
QUERY = tuple(m + "_ns" for m in guard.METRICS)
BUILD = guard.BUILD
CAPS = (16, 24, 32)
CEILINGS = (.01, .001, .0001)
OWNERS = ("production_native", "external", "native_experimental")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load():
    out = STAGE / "screen"
    meta = json.loads((out / "metadata.json").read_text())
    require(meta["complete"] is True and meta["source_commit"] == COMMIT, "Require the complete committed Rust120 screen")
    protocol = json.loads((STAGE / "screening/protocol.json").read_text())
    registry = json.loads((STAGE / "registry.json").read_text())
    source = (STAGE / "benchmark/src/main.rs").read_text()
    frozen = json.loads(frozen_source.FROZEN.read_text())
    require((len(frozen["source_sha256"]), len(frozen["external_dependencies"]), len(frozen["binaries"])) == (259, 11, 12),
            "Wrong immutable source/dependency/binary closure")
    frozen_source.verify(frozen)
    archive = frozen_source.verify_archive()
    require(len(archive["files"]) == 258, "Wrong committed local archive cardinality")
    frozen_source.verify_commit(COMMIT, frozen)
    require(meta["freeze_sha256"] == sha(frozen_source.FROZEN)
            and meta["archive_sha256"] == sha(frozen_source.ARCHIVE)
            and meta["binary_sha256"] == protocol["binary_sha256"]
            and meta["protocol_sha256"] == sha(STAGE / "screening/protocol.json"), "Measured source pin drift")
    require(meta["affinity"] == [3] and meta["lease"]["cpu"] == 3
            and meta["lease"]["lock_path"] == "/tmp/fastest-bf-socket1.lock"
            and bool(meta["lease"]["inherited_lock_descriptors"])
            and meta["numa_policy"] == "CPU3 affinity only; no explicit NUMA memory binding", "Wrong recorded placement/lease")
    require(meta["compiler_flags"] == protocol["compiler_flags"] and not meta["command_environment"]["LD_PRELOAD"], "Unfrozen compiler/preload")
    guard.validate_protocol(protocol, registry, source)
    require(len(meta["commands"]) == 18 and meta["rows"] == 120 and meta["cases"] == 18
            and meta["family_geometry_size_seed_quality_records"] == 40 and meta["pooled"] is False,
            "Incomplete measured matrix")
    rows, raw_hashes = [], {}
    for case, record in zip(protocol["cases"], meta["commands"]):
        require(record["case"] == case and record["command"] == command_for(case, protocol)
                and record["returncode"] == 0 and record["complete"] is True,
                "Wrong/incomplete raw case command")
        require(record["expected_filter_order"] == guard.expected_order(case, protocol, source)
                and record["filter_order"] == record["expected_filter_order"]
                and record["raw_input_intervals"] == guard.raw_intervals(case, protocol), "Changed source-derived order/interval")
        tag = "k{key_power}-p{budget_bpk}-b{batch}-s{seed}".format(**case)
        raw, stderr = out / (tag + ".csv"), out / (tag + ".stderr.log")
        require(sha(raw) == record["csv_sha256"] and sha(stderr) == record["stderr_sha256"], "Raw evidence drift")
        require(stderr.read_text().strip() == "sbbf-rs 0.2.8 backend: Avx2Filter", "Unexpected external backend")
        part = list(csv.DictReader(io.StringIO(raw.read_text())))
        require(len(part) == record["rows"], "Wrong recorded row count")
        guard.validate_rows(part, case, protocol, source)
        rows.extend(part)
        raw_hashes[raw.name], raw_hashes[stderr.name] = sha(raw), sha(stderr)
    with (out / "results.csv").open(newline="") as stream:
        aggregate = list(csv.DictReader(stream))
    require(rows == aggregate and sha(out / "results.csv") == meta["results_sha256"], "Ordered raw/aggregate mismatch")
    require(meta["final_sources_dependencies_binaries_equal"] is True, "Missing final producer verification")
    guard.validate_all(rows, protocol, registry, source)
    raw_hashes.update({name: sha(out / name) for name in ("results.csv", "metadata.json")})
    return rows, protocol, registry, meta, raw_hashes


def wilson(fp, n):
    require(type(fp) is int and type(n) is int and n > 0 and 0 <= fp <= n, "Invalid sample")
    z = 1.959963984540054
    z2, p = z * z, fp / n
    denominator = 1 + z2 / n
    center = (p + z2 / (2 * n)) / denominator
    half = z * math.sqrt(p * (1 - p) / n + z2 / (4 * n * n)) / denominator
    return (0.0 if fp == 0 else max(0, center - half), 1.0 if fp == n else min(1, center + half))


def prior_quality():
    context = json.loads((HERE / "prior-quality.json").read_text())
    derived = []
    for item in context["inputs"]:
        path = ROOT / item["path"]
        blob = subprocess.check_output(["git", "show", item["commit"] + ":" + item["path"]], cwd=ROOT)
        require(sha(path) == item["sha256"] == hashlib.sha256(blob).hexdigest(), "Prior quality context drift")
        source = json.loads(blob)
        if path.name == "prior-four-sector-quality.json":
            for row in source["records"]:
                derived.append(dict(source="historical", filter=row["filter"], keys=row["keys"],
                                    filter_bytes=row["filter_bytes"], seed=row["seed"], negatives=row["count"],
                                    false_positives=row["false_positives"], wilson95_low=row["wilson_lower"],
                                    wilson95_high=row["wilson_upper"]))
        elif "2026-10-29-four-sector-quality-resolution" in path.parts:
            for row in source["fresh_records"]:
                derived.append(dict(source="precision_resolution", filter="FourSectorBloomFilter", keys=row["keys"],
                                    filter_bytes=row["filter_bytes"], seed=row["seed"], negatives=row["fresh_suffix_count"],
                                    false_positives=row["fresh_suffix_fp"], wilson95_low=row["fresh_wilson_lower"],
                                    wilson95_high=row["fresh_wilson_upper"]))
        else:
            require(path == ROOT / "experiments/2026-10-29-multiply-code-small-confirmation/confirmation/quality.json", "Unknown context source")
            for row in source["api_seed_records"]:
                if row["filter"] == "FourSectorBloomFilter":
                    derived.append(dict(source="fresh_six_seed", filter=row["filter"], keys=65536,
                                        filter_bytes=131072, seed=row["seed"], negatives=row["negatives"],
                                        false_positives=row["false_positives"], wilson95_low=row["wilson95_low"],
                                        wilson95_high=row["wilson95_high"]))
    require(context["records"] == derived, "Context tuples differ from immutable source records")
    require(len(context["records"]) == 14 and len(context["inputs"]) == 3, "Wrong unpooled context cardinality")
    for row in context["records"]:
        low, high = wilson(row["false_positives"], row["negatives"])
        require(math.isclose(low, row["wilson95_low"], rel_tol=1e-12)
                and math.isclose(high, row["wilson95_high"], rel_tol=1e-12), "Prior Wilson endpoint mismatch")
    return context


def identity(row):
    return (row["filter"], int(row["keys"]), int(row["filter_bytes"]), int(row["seed"]))


def quality(rows):
    groups = {}
    semantic_fields = ("result_checksum", "false_positives", "absent_queries", "present_queries",
                       "calibration_false_positives", "calibration_absent_queries", "effective_probes",
                       "probe_policy", "logical_bytes", "unit_count", "constructor_argument")
    for row in rows:
        key, semantic = identity(row), tuple(row[k] for k in semantic_fields)
        entry = groups.setdefault(key, dict(semantic=semantic, batches=set(), row=row))
        require(entry["semantic"] == semantic and int(row["batch"]) not in entry["batches"], "Cross-batch drift or repeated sample")
        entry["batches"].add(int(row["batch"]))
    require(len(groups) == 40 and all(v["batches"] == {1, 31, 4096} for v in groups.values()), "Wrong40 family records")
    records = []
    for (name, n, size, seed), entry in sorted(groups.items()):
        row = entry["row"]
        fp, probes = int(row["calibration_false_positives"]), int(row["calibration_absent_queries"])
        low, high = wilson(fp, probes)
        records.append(dict(filter=name, keys=n, filter_bytes=size, actual_bpk=8 * size / n, seed=seed,
                            false_positives=fp, negatives=probes, point_fpr=fp / probes,
                            wilson95_low=low, wilson95_high=high, family_record=True,
                            cross_family_alias_assumed=False))
    return records


def owner(row):
    name, origin = row["filter"], row["implementation_origin"]
    expected = "production_native" if name in guard.NATIVE else "external" if name in guard.EXTERNAL else "native_experimental"
    require(name in guard.NAMES and origin == expected, "Wrong ownership")
    return expected


def outcome(ratio):
    return "win" if ratio > 1 else "loss" if ratio < 1 else "tie"


def leaders(rows, metric):
    if not rows:
        return [], None
    best = min(float(r[metric]) for r in rows)
    return [dict(filter=r["filter"], filter_bytes=int(r["filter_bytes"]), actual_bpk=float(r["actual_bpk"]))
            for r in rows if float(r[metric]) == best], best


def rank(rows, q, metrics):
    quality_map = {(r["filter"], r["keys"], r["filter_bytes"], r["seed"]): r for r in q}
    by_case = defaultdict(list)
    for row in rows:
        by_case[(int(row["keys"]), int(row["batch"]))].append(row)
    require(len(by_case) == 6 and all(len(v) == 20 for v in by_case.values()), "Wrong allocation choice set")
    views, alternatives, range_alternatives = [], [], []
    for (n, batch), options in sorted(by_case.items()):
        for cap, ceiling, metric in itertools.product(CAPS, CEILINGS, metrics):
            base = dict(keys=n, batch=batch, cap_bpk=cap, fpr_ceiling=ceiling, metric=metric,
                        policy="current_seed42_two_sided_wilson95_upper")
            def admitted(row):
                return int(row["filter_bytes"]) * 8 <= cap * n and quality_map[identity(row)]["wilson95_high"] <= ceiling
            feasible = [r for r in options if admitted(r)]
            selections = {kind: leaders([r for r in feasible if owner(r) == kind], metric) for kind in OWNERS}
            selections["overall"] = leaders(feasible, metric)
            view = dict(base, feasible_allocations=len(feasible))
            for kind, (chosen, ns) in selections.items():
                view[kind + "_leaders"], view[kind + "_ns"] = chosen, ns
            candidate_ns = selections["native_experimental"][1]
            for kind in ("external", "production_native"):
                rival_ns = selections[kind][1]
                ratio = rival_ns / candidate_ns if rival_ns is not None and candidate_ns is not None else None
                view["range_vs_" + kind] = ratio
                view["range_vs_" + kind + "_outcome"] = outcome(ratio) if ratio is not None else "ineligible_or_missing"
            views.append(view)
            for row in options:
                qr = quality_map[identity(row)]
                ns = float(row[metric])
                require(math.isfinite(ns) and ns > 0, "Invalid latency")
                record = dict(base, filter=row["filter"], owner=owner(row), requested_bpk=int(row["requested_bpk"]),
                              filter_bytes=int(row["filter_bytes"]), actual_bpk=float(row["actual_bpk"]),
                              budget_pass=int(row["filter_bytes"]) * 8 <= cap * n,
                              quality_pass=qr["wilson95_high"] <= ceiling, eligible=admitted(row),
                              wilson95_high=qr["wilson95_high"], latency_ns=ns)
                if metric in QUERY:
                    prefix = metric.removesuffix("_ns")
                    record.update(trials=[float(x) for x in row[prefix + "_trials"].split("|")],
                                  minimum_ns=float(row[prefix + "_min_ns"]), maximum_ns=float(row[prefix + "_max_ns"]),
                                  phase_order=row["query_phase_order"])
                else:
                    record["build_trial_vectors_recorded"] = False
                for kind in ("external", "production_native", "overall"):
                    rival_ns = selections[kind][1]
                    record["ratio_vs_" + kind + "_leader"] = rival_ns / ns if rival_ns is not None else None
                alternatives.append(record)
                if row["filter"] == RANGE:
                    range_alternatives.append(dict(record))
    require((len(views), len(alternatives), len(range_alternatives)) == (216, 4320, 648), "Wrong complete nested ranking counts")
    return dict(views=views, alternatives=alternatives, range_alternatives=range_alternatives)


def same_allocation_controls(rows):
    by_case = {(r["filter"], int(r["keys"]), int(r["filter_bytes"]), int(r["batch"])): r for r in rows}
    pairs = []
    for row in rows:
        if row["filter"] != RANGE or float(row["actual_bpk"]) not in (16, 32):
            continue
        control = by_case[("Split64BloomFilter", int(row["keys"]), int(row["filter_bytes"]), int(row["batch"]))]
        for metric in QUERY + BUILD:
            ratio = float(control[metric]) / float(row[metric])
            pairs.append(dict(keys=int(row["keys"]), actual_bpk=float(row["actual_bpk"]), batch=int(row["batch"]),
                              metric=metric, range_ns=float(row[metric]), production_split64_ns=float(control[metric]),
                              speedup=ratio, outcome=outcome(ratio), same_byte_budget=True,
                              identical_hash_mapping_assumed=False))
    require(len(pairs) == 96, "Wrong same-allocation controls")
    return pairs


def api_ratios(rows):
    result = []
    for row in rows:
        for staged, visible in (("lookup_ns", "inline_lookup_ns"), ("hash_lookup_ns", "inline_hash_lookup_ns")):
            ratio = float(row[staged]) / float(row[visible])
            result.append(dict(filter=row["filter"], owner=owner(row), keys=int(row["keys"]),
                               actual_bpk=float(row["actual_bpk"]), batch_tag=int(row["batch"]),
                               original_contract=staged, visible_contract=visible,
                               original_ns=float(row[staged]), visible_ns=float(row[visible]),
                               visible_speedup=ratio, outcome=outcome(ratio),
                               visible_loop_scope="whole-array public singleton loop; batch tag does not change this API contract"))
    require(len(result) == 240, "Wrong four-mode API pair count")
    return result


def write_csv(path, records):
    with path.open("w", newline="") as stream:
        fields = list(dict.fromkeys(k for row in records for k in row))
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows({k: json.dumps(v, separators=(",", ":")) if isinstance(v, (list, dict)) else v
                          for k, v in row.items()} for row in records)


def save_json(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + "\n")


def describe(query, build, q, meta, controls):
    lines = ["# Native Rust Split64Range exact-capacity training screen", "",
             "This seed42 screen compares current production4, three public external families and the unchanged Range candidate. It is a training allocation/API comparison, not held-out confirmation or a global fastest claim.", "",
             "All120 rows are retained. Each of the216 query views fixes size, batch tag, actual byte ceiling16/24/32, FPR ceiling1%/0.1%/0.01% and one of four query contracts. Every view sees all20 measured allocations for that size/batch; smaller allocations remain eligible under larger ceilings. The4320 alternatives and648 Range alternatives include every loss and ineligible allocation.", "",
             "## Query comparisons", "",
             "Wins/losses below compare the fastest eligible Range allocation with the fastest eligible allocation in each rival ownership class. Exact ties are retained, and ineligible/missing views are reported separately. These descriptive counts do not measure independent repeated evidence.", "",
             "| Query contract | Versus external W/L/T | Versus production W/L/T | Ineligible/missing external / production |",
             "|---|---:|---:|---:|"]
    for metric in QUERY:
        records = [r for r in query["views"] if r["metric"] == metric]
        scores = []
        missing = []
        for kind in ("external", "production_native"):
            values = [r["range_vs_" + kind + "_outcome"] for r in records]
            scores.append("/".join(str(values.count(x)) for x in ("win", "loss", "tie")))
            missing.append(values.count("ineligible_or_missing"))
        lines.append(f"| {metric} | {scores[0]} | {scores[1]} | {missing[0]} / {missing[1]} |")
    lines += ["", "### The exact24-bpk/0.01% capacity gap", "",
              "At this ceiling, the current power-of-two production types can use only the smaller16-bpk geometry, which does not qualify for0.01%. Range24 passes at both sizes. Fastbloom qualifies among these three external families; the two public32-byte split-block families do not. This is a current-seed capacity/quality advantage, not evidence that Range beats every query API at a32-bpk ceiling.", "",
              "**Fastbloom configuration scope:** this frozen screen calls `.expected_items(real_n)`, which selects17 probes at24 bpk and achieves about0.001% FPR, substantially below the0.01% ceiling. The pinned0.17.0 public builder also exposes `.hashes(k)` in `src/builder.rs`. Those cheaper fixed-probe configurations have not been measured here. The large ratios below therefore compare the current default-optimal-probe configuration, not the strongest possible Fastbloom configuration at the chosen ceiling. A separate public fixed-K accuracy/performance comparison is needed before making that broader claim.", "",
              "| Family at actual24 bpk | Keys | FP /2^24 | Wilson95 upper (%) |",
              "|---|---:|---:|---:|"]
    for row in q:
        if row["actual_bpk"] == 24:
            lines.append(f"| {row['filter']} | {row['keys']} | {row['false_positives']} | {row['wilson95_high'] * 100:.8f} |")
    lines += ["", "| Keys | Query contract | Batch tag | Range24 ns/key | Best eligible external ns/key | External / Range |",
              "|---:|---|---:|---:|---:|---:|"]
    for n in (1 << 16, 1 << 25):
        for metric, batch in (("lookup_ns", 1), ("lookup_ns", 4096), ("inline_hash_lookup_ns", 1)):
            view = next(r for r in query["views"] if (r["keys"], r["cap_bpk"], r["fpr_ceiling"], r["metric"], r["batch"]) ==
                        (n, 24, .0001, metric, batch))
            if view["native_experimental_ns"] is not None and view["external_ns"] is not None:
                lines.append(f"| {n} | {metric} | {batch} | {view['native_experimental_ns']:.4f} | {view['external_ns']:.4f} | {view['range_vs_external']:.4f}× |")
    lines += ["", "The visible prehashed and fused-hash measurements each call the library's actual public singleton API in a whole-array loop. Their batch tag labels the separately run case; it does not change that query loop. Generic staged batch, generic common-hash batch, visible singleton prehashed and visible fused hash are ranked independently. SBBF's public dispatch remains intact; no private external kernel is substituted.", "",
              "## Quality and historical context", "",
              "The40 family/actual-geometry/size/seed calibration records each use2^24 independent negatives. Reuse across three batch tags and four modes is counted once. Distinct families are not assumed to share a hash mapping or combined into a larger binomial sample. quality.json preserves every point estimate and two-sided95% Wilson endpoint.", "",
              "Historical FourSector actual16 upper-endpoint gate failures and the separate higher-resolution resolutions are contextual evidence only. The current training ranking uses the current seed42 endpoint; it does not exclude the row because of a prior failure or import old timings. A pass on one seed does not erase historical uncertainty, and an upper endpoint crossing the target does not prove that the true rate exceeds it.", "",
              "In this current Rust screen, FourSector16's upper endpoint is0.09710818% at65,536 keys and0.10023738% at33,554,432 keys. The larger row therefore misses the0.1% gate on its current sample; the smaller row remains eligible. This differs from importing a historical exclusion. All14 immutable contextual records are separately retained in prior-quality.json with source commits, including the two larger disjoint-suffix resolutions and six fresh-seed observations.", "",
              "## Serial construction and equal-allocation controls", "",
              "build-views.csv, build-alternatives.csv and build-range-alternatives.csv retain all four serial build metrics: prehashed insertion, allocation-inclusive prehashed build, common-hash insertion and allocation-inclusive common-hash build. They use the same nested capacity/quality eligibility. Eight construction trials ran, but the frozen CSV retains only their medians: no build trial dispersion is invented. This is not a parallel-build comparison.", "",
              "same-allocation-controls.csv retains96 query/build pairs between Range16/32 and production Split64 at the same bytes, across both sizes and all three batch tags. Equal bytes do not imply identical hash-to-block mapping. api-ratios.csv retains240 within-row generic/visible API comparisons, including losses.", "",
              "| Same-allocation metric | Range W/L/T | Split64 / Range minimum–maximum |",
              "|---|---:|---:|"]
    for metric in QUERY + BUILD:
        records = [r for r in controls if r["metric"] == metric]
        values = [r["speedup"] for r in records]
        score = "/".join(str(sum(r["outcome"] == name for r in records)) for name in ("win", "loss", "tie"))
        lines.append(f"| {metric} | {score} | {min(values):.6f}–{max(values):.6f}× |")
    lines += ["", "Range loses47 of48 same-allocation query comparisons; its lone staged-hash win is only0.015%. It loses all48 corresponding build comparisons. The especially larger small-table allocation-inclusive cost is retained; this screen alone does not identify whether allocator/code-generation/placement effects cause it. The exact24-bpk capacity is the useful difference, rather than a demonstrated universal speed improvement at an equal allocation.", "",
              "The frozen build harness runs prehashed and common-hash construction phases separately; unlike the four query modes, those build phases do not have the same balanced Williams ordering. Construction results remain descriptive and separate from query conclusions.", "",
              "## Provenance and limits", "",
              f"Source commit `{COMMIT}`; binary SHA `{meta['binary_sha256']}`. All18 commands, source-derived filtered registry orders, four balanced phase schedules and trial vectors, geometry/probe fields, dense checksums and independent counts match raw outputs and the ordered aggregate. The audit checks259 frozen source/evidence files,11 dependency sets,12 executables and258 committed archive entries.", "",
              "CPU3/socket1 held one exclusive inherited flock. Affinity only was applied; no explicit NUMA memory binding is claimed. Case order was fixed by size, ceiling and batch with one seed42, so allocation placement and execution order remain limitations. No production source or measured binary changed for this analysis; no timing or accuracy workload was rerun.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    rows, protocol, registry, meta, raw_hashes = load()
    q = quality(rows)
    context = prior_quality()
    query, build = rank(rows, q, QUERY), rank(rows, q, BUILD)
    controls, apis = same_allocation_controls(rows), api_ratios(rows)
    args.output.mkdir(exist_ok=False)
    for kind, result in (("query", query), ("build", build)):
        for key, filename in (("views", "views"), ("alternatives", "alternatives"), ("range_alternatives", "range-alternatives")):
            write_csv(args.output / (kind + "-" + filename + ".csv"), result[key])
    write_csv(args.output / "same-allocation-controls.csv", controls)
    write_csv(args.output / "api-ratios.csv", apis)
    save_json(args.output / "quality.json", q)
    save_json(args.output / "prior-quality.json", context)
    save_json(args.output / "verified.json", dict(source_commit=COMMIT, rows=120, cases=18, quality_records=40,
                                                  source_files=259, dependency_sets=11, binaries=12, archive_entries=258,
                                                  raw_sha256=raw_hashes,
                                                  query_counts={k: len(v) for k, v in query.items()},
                                                  build_counts={k: len(v) for k, v in build.items()},
                                                  same_allocation_pairs=len(controls), api_pairs=len(apis),
                                                  quality_pooling=False, performance_rerun=False))
    (args.output / "REPORT.md").write_text(describe(query, build, q, meta, controls))
    print("PASS120 rows/40 family quality records; query216 views/4320 alternatives/648Range alternatives; build216/4320/648;96 controls/240API pairs")


if __name__ == "__main__":
    main()
