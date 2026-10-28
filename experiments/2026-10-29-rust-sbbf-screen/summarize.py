#!/usr/bin/env python3
"""Keep original and singleton-control tracks, every family loss and every API ratio."""
import argparse
import csv
import itertools
import json
from pathlib import Path

from guard import BUILD_METRICS, EXTERNAL_FAMILIES, quality_rows, require, select, track_names, validate_all
from run import HERE, save_json, sha, verify_freeze, verify_screen_commit


def write_csv(path, rows):
    require(bool(rows), "Empty analysis table")
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def picked_columns(prefix, picked):
    return {prefix + key: None if picked is None else picked[key]
            for key in ("filter", "family", "api", "requested_bpk", "filter_bytes", "actual_bpk", "median_ns", "min_ns", "max_ns", "wilson_upper")}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=HERE / "screen")
    args = parser.parse_args()
    protocol = verify_freeze()
    registry = json.loads((HERE / "registry.json").read_text())
    metadata = json.loads((args.input / "metadata.json").read_text())
    verify_screen_commit(metadata["screen_commit"])
    require(metadata["complete"] is True and metadata["rows"] == 168 and metadata["workloads"] == 12, "Incomplete run metadata")
    require(metadata["freeze_sha256"] == sha(HERE / "freeze.json"), "Run used another freeze")
    require(metadata["protocol_sha256"] == sha(HERE / "protocol.json"), "Run used another protocol")
    require(metadata["results_sha256"] == sha(args.input / "results.csv"), "Aggregate CSV changed")
    require(metadata["cpu"] == protocol["cpu"] and metadata["affinity"] == [protocol["cpu"]], "Different CPU")
    for entry in metadata["commands"]:
        power, bpk, batch, seed = entry["workload"]
        path = args.input / f"k{power}-p{bpk}-b{batch}-s{seed}.csv"
        require(entry["complete"] and entry["returncode"] == 0 and sha(path) == entry["csv_sha256"], "Invalid per-case evidence")
    rows = list(csv.DictReader((args.input / "results.csv").open()))
    validate_all(rows, registry, protocol)
    quality = sorted(quality_rows(rows, registry), key=lambda r: (r["keys"], r["requested_bpk"], r["family"]))
    require(len(quality) == 28, "Control/batch duplicates inflated quality samples")
    write_csv(args.input / "quality.csv", quality)
    comparisons, flat, individual = [], [], []
    setting_grid = itertools.product(protocol["key_powers"], protocol["batches"],
                                     protocol["ranking"]["memory_caps_bpk"],
                                     protocol["ranking"]["fpr_ceilings"], protocol["ranking"]["metrics"])
    for power, batch, cap, ceiling, metric in setting_grid:
        n = 1 << power
        settings = dict(keys=n, batch=batch, memory_cap_bpk=cap, fpr_ceiling=ceiling, metric=metric)
        for track in protocol["ranking"]["tracks"]:
            own = select(rows, registry, track_names(registry, track, "native"), metric, n, batch, cap, ceiling)
            rival = select(rows, registry, track_names(registry, track, "external"), metric, n, batch, cap, ceiling)
            ratio = rival["median_ns"] / own["median_ns"] if own and rival else None
            comparisons.append(dict(**settings, track=track, native=own, external=rival, external_over_native=ratio))
            flat.append(dict(**settings, track=track, **picked_columns("native_", own),
                             **picked_columns("external_", rival), external_over_native=ratio))
        rivals = track_names(registry, "best_public_paths", "external")
        best_external = select(rows, registry, rivals, metric, n, batch, cap, ceiling)
        by_external_family = {family: select(rows, registry, {name for name in rivals if registry[name]["family"] == family}, metric, n, batch, cap, ceiling)
                              for family in sorted(EXTERNAL_FAMILIES)}
        for name in sorted(track_names(registry, "best_public_paths", "native")):
            own = select(rows, registry, {name}, metric, n, batch, cap, ceiling)
            individual.append(dict(**settings, candidate=name, candidate_selected=own, external=best_external,
                                   external_over_candidate=best_external["median_ns"] / own["median_ns"] if own and best_external else None,
                                   external_families={family: dict(selected=rival, external_over_candidate=rival["median_ns"] / own["median_ns"] if own and rival else None)
                                                      for family, rival in by_external_family.items()}))
    write_csv(args.input / "rankings.csv", flat)
    by_workload = {}
    for row in rows:
        key = tuple(row[field] for field in ("keys", "requested_bpk", "batch", "seed"))
        by_workload.setdefault(key, {})[row["filter"]] = row
    api_ratios = []
    for key, group in sorted(by_workload.items(), key=lambda item: tuple(map(int, item[0]))):
        for name, info in registry.items():
            if info["api"] != "singleton_control":
                continue
            original, current = group[info["original"]], group[name]
            for metric in (*protocol["ranking"]["metrics"], *BUILD_METRICS):
                a, b = float(original[metric]), float(current[metric])
                api_ratios.append(dict(zip(("keys", "requested_bpk", "batch", "seed"), map(int, key)),
                                       family=info["family"], owner=info["owner"], original=info["original"],
                                       singleton_control=name, metric=metric, original_ns=a, control_ns=b,
                                       original_over_control=a / b))
    write_csv(args.input / "api-ratios.csv", api_ratios)
    result = dict(scope="Seed42 CPU3 exploratory throughput screen; no held-out or globally fastest claim",
                  rows=len(rows), configurations=len(registry), quality_experiments=len(quality),
                  calibration_note="One original family/size/seed calibration; batch and API duplicates are never pooled. Wilson bounds are pointwise, not simultaneous selection guarantees.",
                  control_note="Native singleton controls remain native experiments; Split/Four public scalar source can change query kernels. Production sources unchanged.",
                  comparisons=comparisons, individual=individual,
                  api_ratio_rows=len(api_ratios), analysis_sha256={name: sha(HERE / name) for name in ("summarize.py", "guard.py", "test_guard.py")})
    save_json(args.input / "summary.json", result)
    lines = ["# Rust SBBF14 initial screen", "",
             "Twelve workloads / 168 rows compare four native layouts and three external implementations, each with an explicit public singleton control. CPU3, seed42, 2^22 queries, five repetitions, full-input insertion and 2^24 independent calibration negatives. This is an exploratory throughput screen; it does not establish global leadership or held-out performance.", "",
             "The table keeps native original APIs and selects the strongest measured public external path. Exact actual-byte caps have zero slack. Eligibility uses the upper endpoint of a pointwise two-sided 95% Wilson interval. Values above 1 in the last column favor the native entry. All other API tracks and individual family wins/losses remain in `rankings.csv` and `summary.json`.", ""]
    for metric in protocol["ranking"]["metrics"]:
        lines += [f"## {metric}", "", "| Keys | Batch | Cap bpk | FPR ceiling | Native original | ns/key | External public path | ns/key | External/native |",
                  "| ---: | ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |"]
        for item in comparisons:
            if item["metric"] != metric or item["track"] != "original_native_vs_best_external":
                continue
            own, rival, ratio = item["native"], item["external"], item["external_over_native"]
            cells = [str(item["keys"]), str(item["batch"]), str(item["memory_cap_bpk"]), f"{item['fpr_ceiling']:.2%}",
                     own["filter"] if own else "No qualifier", f"{own['median_ns']:.3f}" if own else "—",
                     rival["filter"] if rival else "No qualifier", f"{rival['median_ns']:.3f}" if rival else "—",
                     f"{ratio:.3f}×" if ratio is not None else "—"]
            lines.append("| " + " | ".join(cells) + " |")
        lines.append("")
    lines += ["`quality.csv` has 28 unique calibration experiments, not 168 independent samples. `api-ratios.csv` preserves every original/control query and construction ratio, including regressions. Query repetition min/max ranges are descriptive; no confidence interval for speed is asserted. The frozen harness always measures prehashed query before hash-plus-query within a repetition, so this screen does not claim balanced phase ordering.", ""]
    (args.input / "RESULTS.md").write_text("\n".join(lines))
    print(f"Wrote {len(comparisons)} rankings, {len(individual)} individual-native comparisons, {len(api_ratios)} API ratios and 28 deduplicated quality rows")


if __name__ == "__main__":
    main()
