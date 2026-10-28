"""Report all three measured contracts and per-cap training comparisons."""
import csv
import hashlib
import json
import math
from pathlib import Path
import statistics

import guard

HERE = Path(__file__).resolve().parent
TIERS = (("1%", .01), ("0.1%", .001), ("0.01%", .0001))


def upper95(positive, count):
    z = 1.959963984540054
    rate = positive / count
    return min(1., (rate + z*z/(2*count) + z*math.sqrt(rate*(1-rate)/count + z*z/(4*count*count))) / (1+z*z/count))


def validate_matrix(protocol, result):
    metadata = result["metadata"]
    if not metadata["complete"] or not metadata["throughput_enabled"]:
        raise ValueError("incomplete or unmeasured matrix")
    expected = {(case["id"], config["filter"]): (case, config)
                for case in protocol["cases"] for config in protocol["configs"]}
    expected_preflight = {key for key, (_, config) in expected.items() if config["family"] == "blowchoc"}
    seen_preflight = [(item["case"], item["filter"]) for item in result["preflights"]]
    if len(seen_preflight) != len(set(seen_preflight)) or set(seen_preflight) != expected_preflight:
        raise ValueError("missing, duplicate or unexpected bitmap preflight")
    if metadata["rows"] != len(expected) or metadata["preflights"] != len(expected_preflight):
        raise ValueError("incorrect matrix count metadata")
    rows, seen = [], set()
    for row in result["rows"]:
        key = row["case"], row["filter"]
        if key not in expected or key in seen:
            raise ValueError("unexpected or duplicate timed row")
        seen.add(key)
        case, config = expected[key]
        guard.validate(row, config, case, protocol, True)
        if row["language"] != ("numba" if config["family"] == "blowchoc" else "cpp"):
            raise ValueError("wrong native/external ownership")
        count, positive = row["calibration_absent_queries"], row["calibration_false_positives"]
        if type(count) is not int or type(positive) is not int:
            raise ValueError("noninteger calibration counts")
        lower, upper = case["inserted_raw_interval"]
        if not lower < upper <= case["query_negative_raw_bounds"][0] < case["query_negative_raw_bounds"][1] <= row["calibration_raw_interval"][0]:
            raise ValueError("insert/query/calibration overlap")
        rows.append(dict(row, family=config["family"], calibration_fpr=positive/count,
                         calibration_wilson95_upper=upper95(positive, count)))
    if seen != set(expected):
        raise ValueError("missing timed row")
    return sorted(rows, key=lambda row: (row["keys"], row["actual_bpk"], row["filter"]))


def comparisons(rows):
    result = []
    for n in sorted({row["keys"] for row in rows}):
        for cap in (16, 32):
            for label, limit in TIERS:
                eligible = [row for row in rows if row["keys"] == n and row["filter_bytes"] <= n*cap//8
                            and row["calibration_wilson95_upper"] <= limit]
                for mode in guard.MODES:
                    choices = {}
                    for family in ("native", "blowchoc"):
                        candidates = [row for row in eligible if row["family"] == family]
                        choices[family] = min(candidates, key=lambda row: (row["query_ns_per_key"][mode],
                                                                          row["filter_bytes"], row["filter"]), default=None)
                    native, external = choices["native"], choices["blowchoc"]
                    item = dict(keys=n, cap_bpk=cap, fpr_target=label, mode=mode,
                                native_filter=native["filter"] if native else "",
                                native_actual_bpk=native["actual_bpk"] if native else "",
                                native_ns=native["query_ns_per_key"][mode] if native else "",
                                external_filter=external["filter"] if external else "",
                                external_actual_bpk=external["actual_bpk"] if external else "",
                                external_ns=external["query_ns_per_key"][mode] if external else "",
                                external_over_native=(external["query_ns_per_key"][mode] / native["query_ns_per_key"][mode]
                                                      if native and external else ""))
                    result.append(item)
    return result


def write_csv(path, rows):
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main():
    protocol_bytes = (HERE / "protocol.json").read_bytes()
    protocol = json.loads(protocol_bytes)
    results = json.loads((HERE / "results/results.json").read_text())
    metadata = results["metadata"]
    if (metadata["protocol_sha256"] != hashlib.sha256(protocol_bytes).hexdigest()
            or metadata["native_library_sha256"] != protocol["native_library_sha256"]
            or metadata["source_freeze_sha256"] != hashlib.sha256((HERE / "SOURCE_FREEZE.json").read_bytes()).hexdigest()):
        raise ValueError("protocol/source/native provenance mismatch")
    freeze = json.loads((HERE / "SOURCE_FREEZE.json").read_text())
    for name, expected in freeze["files"].items():
        if hashlib.sha256((HERE / name).read_bytes()).hexdigest() != expected["sha256"]:
            raise ValueError("frozen source changed: " + name)
    rows = validate_matrix(protocol, results)
    quality, timing = [], []
    for row in rows:
        shared = {key: row[key] for key in ("case", "filter", "family", "keys", "queries", "actual_bpk", "filter_bytes",
                                            "logical_bitmap_bytes", "positions_scratch_bytes", "harness_hash_scratch_bytes")}
        quality.append(dict(shared, input_seed=row["seed"], construction_seed=row["construction_seed"],
                            calibration_absent_queries=row["calibration_absent_queries"],
                            calibration_false_positives=row["calibration_false_positives"],
                            calibration_fpr=row["calibration_fpr"], wilson95_upper=row["calibration_wilson95_upper"]))
        for mode in guard.MODES:
            samples = [trial["elapsed_ns"] / row["queries"] for trial in row["query_trials"] if trial["mode"] == mode]
            timing.append(dict(shared, mode=mode, query_repeats=6, build_repeats=0,
                               query_min_ns=min(samples), query_median_ns=statistics.median(samples), query_max_ns=max(samples),
                               insert_ns="NaN", allocate_insert_ns="NaN", hash_insert_ns="NaN", allocate_hash_insert_ns="NaN"))
    paired = comparisons(rows)
    write_csv(HERE / "accuracy.csv", quality)
    write_csv(HERE / "timings.csv", timing)
    write_csv(HERE / "comparisons.csv", paired)
    lines = ["# BlowChoc whole-array query-speed training screen", "",
             "All 48 prespecified rows and 32 actual-size bitmap/factory-overwrite preflights passed. All inserted keys and complete dense query outputs were checked. This is input42/construction113 training data, with six repetitions per mode. It is not a held-out performance claim.", "",
             "The four native controls use the unchanged bridge snapshot `b437791`; the external set contains all eight unmodified BlowChoc parameter choices. This is a comparison within that 12-configuration grid, not all repository baselines or exact intermediate budgets. Build throughput was not measured; CSV build columns are NaN.", "",
             "Each comparison below selects the fastest measured native and external under the actual backing-allocation cap and nominal per-row Wilson95% FPR upper bound. A 32 bits/key cap also admits the 16 bits/key rows. The calibration stream has 16,777,216 negatives per row; repeated streams and different construction functions are never pooled. These are per-case intervals, not simultaneous coverage for the selected winner. Positions scratch of 16/28B and common hash scratch of 32KiB are disclosed separately from the bitmap cap.", "",
             "Ratios are external ns/key divided by native ns/key: above 1 favors native. All three contracts are independent. Trial minima/maxima in `timings.csv` describe within-run spread, not paired-seed uncertainty.", ""]
    for mode in guard.MODES:
        lines += [f"## {mode}", "", "| Keys | Cap | FPR limit | Native (actual bpk) | ns/key | BlowChoc (actual bpk) | ns/key | Ratio |",
                  "|---|---:|---:|---|---:|---|---:|---:|"]
        for row in paired:
            if row["mode"] != mode:
                continue
            n = "64K" if row["keys"] == 1 << 16 else "32M"
            def fmt(family):
                name = row[family + "_filter"]
                return (f"{name} ({row[family + '_actual_bpk']:g})", f"{row[family + '_ns']:.3f}") if name else ("ineligible", "—")
            native_name, native_time = fmt("native")
            external_name, external_time = fmt("external")
            ratio = f"{row['external_over_native']:.3f}×" if row["external_over_native"] != "" else "—"
            lines.append(f"| {n} | {row['cap_bpk']} | {row['fpr_target']} | {native_name} | {native_time} | {external_name} | {external_time} | {ratio} |")
        compared = [row for row in paired if row["mode"] == mode and row["external_over_native"] != ""]
        wins = [row for row in compared if row["external_over_native"] > 1]
        losses = [row for row in compared if row["external_over_native"] < 1]
        ties = len(compared) - len(wins) - len(losses)
        lines += ["", f"Native is faster in {len(wins)}/{len(compared)} comparable tier/cap cases; external is faster in {len(losses)}/{len(compared)}, with {ties} exact ties. These cases share filters/streams and are not independent statistical trials.", ""]
    lines += [f"The full matrix held the socket1 lock on CPU3 for {metadata['elapsed_seconds']:.1f}s including compilation, construction, validation and calibration. That wall time is not filter throughput. CPU affinity was fixed; explicit NUMA memory binding was not imposed. Source commit `{metadata['source_commit']}`, frozen native library and runtime hashes passed before/after checks.", "",
              "`accuracy.csv` retains all 48 quality/allocation rows; `timings.csv` retains 144 mode rows including every configuration's losses; `comparisons.csv` retains the 36 cap/FPR/mode selections. Full raw trial timings, checksums, construction hashes and input digests remain in `results/`.", ""]
    (HERE / "RESULTS.md").write_text("\n".join(lines))
    print(f"Validated {len(rows)} rows; exported {len(timing)} separate-contract timings and {len(paired)} cap/FPR comparisons.")


if __name__ == "__main__":
    main()
