#!/usr/bin/env python3
"""Derive a finite proposal from committed leader/constructor records; no BF."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CAPS = (16, 24, 32)
SEEDS = (982451653, 961748941)
NATIVE = ("FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter", "ByteSplitBloomFilter")
ANCHORS = {
    "exact_summary": ("758499c63c5397cd64c9d67cdecab7e0388e774a", "experiments/2026-10-29-exact-budget-range/screen/summary.json"),
    "exact_grid": ("d70077b28fb3cd5821ae471f185e98393423ec64", "experiments/2026-10-29-exact-budget-range/planned-grid.json"),
    "confirmation_selection": ("842c45de956928960dde8787eeaff45928aa65dd", "experiments/2026-10-29-exact-budget-confirmation/selection.json"),
    "confirmation_summary": ("842c45de956928960dde8787eeaff45928aa65dd", "experiments/2026-10-29-exact-budget-confirmation/screen/summary.json"),
    "visible_summary": ("5ce9e8267a95dc42df76679e033c494a174c9aac", "experiments/2026-10-29-inline-single-query/screen/summary.json"),
    "k12_bulk_leaders": ("cf8642c5e0d0f5800a1cd316f89c312b333c772a", "experiments/2026-10-29-four-sector-range12-analysis/report/leaders.json"),
}
SOURCE_REFS = {
    "exact_geometry": (ANCHORS["exact_grid"][0], "experiments/2026-10-29-exact-budget-range/geometry.hpp"),
    "budget": (ANCHORS["exact_grid"][0], "experiments/2026-10-29-exact-budget/budget.hpp"),
    "cpp_adapters": (ANCHORS["exact_grid"][0], "experiments/2026-10-29-exact-budget/cpp-adapters.hpp"),
    "boost_adapters": (ANCHORS["exact_grid"][0], "experiments/2026-10-29-exact-budget/boost-adapters.hpp"),
    "rocks_adapters": (ANCHORS["exact_grid"][0], "experiments/2026-10-29-exact-budget/rocks-adapters.hpp"),
    "boost_visible_shim": (ANCHORS["visible_summary"][0], "experiments/2026-10-29-inline-single-query/boost-direct.hpp"),
    "old_visible_helper": (ANCHORS["visible_summary"][0], "experiments/2026-10-29-inline-single-query/inline_query.hpp"),
    "candidate": ("42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5", "experiments/2026-10-29-k12-singleton-vector-plan/candidate.h"),
    "old_k12": ("42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5", "experiments/2026-10-29-k12-singleton-vector-plan/control.h"),
    "candidate_change": ("42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5", "experiments/2026-10-29-k12-singleton-vector-plan/CHANGE.patch"),
    "actual_caller": ("2c85beb3d5c945a1e62465687eb547ccfa5098fb", "experiments/2026-10-29-k12-singleton-vector-plan/caller/main.cpp"),
    "actual_query_helpers": ("2c85beb3d5c945a1e62465687eb547ccfa5098fb", "experiments/2026-10-29-k12-singleton-vector-plan/caller/query_helpers.hpp"),
}
CURRENT_NATIVE = "556c05bb3fcd2f8a9686ba436890c1fa9f86872c"
for filename in ("base.h", "layout_detail.h", "fast_pattern_BF.h", "four_sector_bloom.h", "split64_bloom.h", "byte_split_bloom.h", "split64_range_bloom.h", "split64_range_size.h"):
    SOURCE_REFS["native_" + filename] = (CURRENT_NATIVE, "include/" + filename)


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def blob(commit, path):
    if not re.fullmatch("[0-9a-f]{40}", commit):
        raise ValueError("full immutable commit required")
    return subprocess.check_output(["git", "show", f"{commit}:{path}"], cwd=ROOT)


def identity(row):
    return row["filter"], int(row["keys"]), int(row["filter_bytes"])


def exact_geometry(grid, name, n, backing):
    matches = [r for r in grid if identity(r) == (name, n, backing)]
    if len(matches) != 1:
        raise ValueError(f"ambiguous/missing exact geometry: {name}, {n}, {backing}")
    return dict(matches[0])


def splitmix_first(seed):
    mask = (1 << 64) - 1
    z = (seed + 0x9e3779b97f4a7c15) & mask
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & mask
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & mask
    return z ^ (z >> 31)


def derive(data):
    grid = data["exact_grid"]["configurations"]
    selected = {}
    nulls = []

    def add(name, n, backing, reason):
        key = name, n, backing
        if key not in selected:
            geometry = exact_geometry(grid, *key)
            if geometry["implementation_origin"] != "external":
                raise ValueError("external leader has wrong owner")
            selected[key] = {"owner": "external", "geometry": geometry, "selection_reasons": []}
        selected[key]["selection_reasons"].append(reason)

    # Take the source-defined leader union, never compare times across screens.
    for i, r in enumerate(data["exact_summary"]["rankings"]):
        leader = r["external"]
        reason = {"anchor": "exact_summary", "record": i, "metric": r["metric"], "cap": r["memory_cap_bpk"], "fpr": r["fpr_ceiling"]}
        if leader:
            add(leader["filter"], r["keys"], leader["filter_bytes"], reason)
        else:
            nulls.append(reason)
    old_selection = data["confirmation_selection"]
    configs = {r["configuration_id"]: r for r in old_selection["configurations"]}
    for section in ("main_comparisons", "frontier_comparisons"):
        for i, r in enumerate(old_selection[section]):
            if r["memory_cap_bpk"] not in CAPS:
                continue
            ref = r["leaders"]["external"]
            historical = data["confirmation_summary"][section][i]["fixed_leader_quality"]["external"]
            reason = {"anchor": "confirmation_selection", "section": section, "record": i,
                      "metric": r["metric"], "cap": r["memory_cap_bpk"], "fpr": r["fpr_ceiling"],
                      "historical_all_seed_quality_pass": None if historical is None else historical["qualified_all_seeds"]}
            if ref is None:
                nulls.append(reason)
            else:
                c = configs[ref]
                add(c["filter"], int(c["keys"]), int(c["filter_bytes"]), reason)
    for i, r in enumerate(data["visible_summary"]["comparisons"]):
        c = r["external"]
        reason = {"anchor": "visible_summary", "record": i, "metric": r["metric"], "cap": r["memory_cap_bpk"], "fpr": r["fpr_target"]}
        if c is None:
            nulls.append(reason)
        else:
            add(c["filter"], r["keys"], c["filter_bytes"], reason)
    for i, r in enumerate(data["k12_bulk_leaders"]):
        if r["batch"] not in (31, 4096):
            raise ValueError("unexpected historical bulk contract")
        for c in r["winners"]["external"]:
            add(c["filter"], r["keys"], c["filter_bytes"], {"anchor": "k12_bulk_leaders", "record": i,
                "metric": r["metric"], "batch": r["batch"], "cap": r["cap_bpk"], "fpr": r["fpr_ceiling"]})
    points = []
    for _, point in sorted(selected.items(), key=lambda item: (item[0][1], item[0][0], item[0][2])):
        g = point["geometry"]
        point["id"] = "external-" + g["configuration_id"]
        point["mapping_id"] = "exact-" + g["calibration_identity"]
        points.append(point)
    if len(points) != 30:
        raise ValueError("external shortlist changed")
    for n in (1 << 16, 1 << 25):
        for name in NATIVE:
            for bpk in (16, 32):
                g = exact_geometry(grid, name, n, n * bpk // 8)
                if g["implementation_origin"] != "production_native":
                    raise ValueError("native owner mismatch")
                points.append({"id": "production-" + g["configuration_id"], "owner": "production_native",
                               "mapping_id": "exact-" + g["calibration_identity"], "geometry": g,
                               "selection_reasons": [{"rule": "all four current production layouts at actual16/32; no leader pruning"}]})
        for name, owner in (("K12Control", "old_k12"), ("K12SingletonVector", "candidate"), ("Split64Range", "native_range")):
            for bpk in CAPS:
                backing = n * bpk // 8
                mapping = "range" if owner == "native_range" else "k12"
                g = {"filter": name, "keys": n, "requested_bpk": bpk, "filter_bytes": backing,
                     "budget_bytes": backing, "logical_bytes": backing, "geometry_kind": "native_range_lines",
                     "unit_bytes": 64, "unit_count": backing // 64,
                     "effective_probes": 8 if mapping == "range" else 12, "probe_policy": "fixed",
                     "constructor_argument": bpk, "constructor_api": "BF(real_n, requested_bpk)",
                     "key_power": n.bit_length() - 1}
                points.append({"id": f"{owner}-{n}-{bpk}", "owner": owner,
                               "mapping_id": f"{mapping}-{n}-{backing}", "geometry": g,
                               "selection_reasons": [{"rule": "fixed16/24/32 native geometry; every quality failure retained"}]})
    if len(points) != 64:
        raise ValueError("full panel changed")
    first = []
    for phase, cases in (("primary_singleton", ((50, 1),)),
                         ("native_diagnostic", ((0, 1), (100, 1), (50, 3), (50, 31), (50, 4096)))):
        for n in (1 << 16, 1 << 25):
            for seed in SEEDS:
                for hit, batch in cases:
                    ids = [p["id"] for p in points if int(p["geometry"]["keys"]) == n and
                           (phase == "primary_singleton" or p["owner"] in ("old_k12", "candidate", "native_range"))]
                    first.append({"phase": phase, "key_power": n.bit_length()-1, "seed": seed,
                                  "hit": hit, "batch": batch, "point_ids": ids,
                                  "calibration_power": 26 if phase == "primary_singleton" else 0})
    ledger = []
    for rnd, cases in ((1, first), (2, list(reversed(first)))):
        for case in cases:
            value = dict(case, round=rnd, index=len(ledger), reverse_jobs=(rnd == 2))
            if rnd == 2:
                value["calibration_power"] = 0
            ledger.append(value)
    rows = sum(len(c["point_ids"]) for c in ledger)
    vectors = sum(len(c["point_ids"]) * (4 if c["batch"] == 1 else 2) for c in ledger)
    if (len(ledger), rows, vectors) != (48, 616, 2032):
        raise ValueError("finite ledger counts changed")
    domains = []
    for n in (1 << 16, 1 << 25):
        for seed in SEEDS:
            base = splitmix_first(seed) % ((1 << 32) - n - (1 << 22))
            domains.append({"keys": n, "seed": seed, "key_base": base,
                            "insert_interval": [base, base+n],
                            "mixed_negative_envelope": [base+n, base+n+(1 << 22)],
                            "calibration_interval": [base+n+(1 << 22), base+n+(1 << 22)+(1 << 26)]})
    for n in (1 << 16, 1 << 25):
        a, b = [d["calibration_interval"] for d in domains if d["keys"] == n]
        if not (a[1] <= b[0] or b[1] <= a[0]):
            raise ValueError("prespecified calibration intervals overlap at same n")
    counts = {"external_geometry_points": 30, "production_geometry_points": 16,
              "candidate_old_range_points": 18, "all_geometry_points": 64,
              "processes": 48, "rows": rows, "primary_rows": 256, "diagnostic_rows": 360,
              "query_vectors": vectors, "query_samples": vectors*8,
              "api_geometry_seed_quality_records": 128,
              "known_mapping_geometry_seed_records": 2*len({p["mapping_id"] for p in points}),
              "primary_summary_views": 72, "primary_seed_round_views": 288,
              "named_same_byte_candidate_contrasts": 864}
    return {"counts": counts, "points": points, "null_historical_leaders": nulls,
            "historical_latency_policy": "Never imported. Historical sources only select identities and constructor records."}, ledger, domains


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    pins, data = {}, {}
    for name, (commit, path) in {**ANCHORS, **SOURCE_REFS}.items():
        raw = blob(commit, path)
        pins[name] = {"commit": commit, "path": path, "bytes": len(raw), "sha256": hashlib.sha256(raw).hexdigest()}
        if name in ANCHORS:
            data[name] = json.loads(raw)
    selection, ledger, domains = derive(data)
    values = {"sources.json": pins, "selection.json": selection, "ledger.json": ledger, "input-domains.json": domains}
    for name, value in values.items():
        target = HERE / name
        content = encoded(value)
        if args.write:
            target.write_bytes(content)
        elif target.read_bytes() != content:
            raise ValueError("derived bytes differ: " + name)
    print(json.dumps(selection["counts"], sort_keys=True))


if __name__ == "__main__":
    main()
