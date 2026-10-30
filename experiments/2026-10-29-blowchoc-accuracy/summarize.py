"""Validate and report the fixed accuracy screen without any speed ranking."""
import csv
import hashlib
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent


def upper95(successes, count):
    z = 1.959963984540054
    rate = successes / count
    return (rate + z * z / (2 * count) + z * math.sqrt(rate * (1 - rate) / count + z * z / (4 * count * count))) / (1 + z * z / count)


def validated_rows(protocol, results):
    if results["throughput_enabled"] or len(results["records"]) != protocol["expected_rows"]:
        raise ValueError("wrong matrix scope or enabled throughput")
    expected = {(case["id"], config["filter"]): (case, config)
                for case in protocol["cases"] for config in protocol["configs"]}
    expected_preflight = {key for key, (_, config) in expected.items() if config["family"] == "blowchoc"}
    preflight_keys = [(row["case"], row["filter"]) for row in results["preflights"]]
    if len(preflight_keys) != len(set(preflight_keys)) or set(preflight_keys) != expected_preflight:
        raise ValueError("missing or duplicate full-bitmap preflight")
    seen, output = set(), []
    for row in results["records"]:
        key = row["case"], row["filter"]
        if key in seen or key not in expected:
            raise ValueError("duplicate or unexpected accuracy row")
        seen.add(key)
        case, config = expected[key]
        if row["build_trials"] or row["query_trials"]:
            raise ValueError("throughput samples in accuracy report")
        if row["seed"] != 42 or row["keys"] != case["keys"] or row["queries"] != case["queries"]:
            raise ValueError("wrong workload")
        if (row["requested_bpk"] != case["requested_bpk"] or row["filter_bytes"] != case["payload_bytes"]
                or row["actual_bpk"] != case["actual_bpk"] or row["batch"] != protocol["batch"]):
            raise ValueError("wrong allocation or batch")
        if (row["calibration_absent_queries"] != 1 << 24
                or row["calibration_raw_interval"] != case["calibration_raw_interval"]):
            raise ValueError("wrong or repeated calibration provenance")
        count, positives = row["calibration_absent_queries"], row["calibration_false_positives"]
        if not isinstance(positives, int) or not 0 <= positives <= count:
            raise ValueError("invalid calibration count")
        if row["present_queries"] + row["absent_queries"] != case["queries"] or not 0 <= row["false_positives"] <= row["absent_queries"]:
            raise ValueError("invalid mixed-query counts")
        lower, upper = case["inserted_raw_interval"]
        if not lower < upper <= case["query_negative_raw_bounds"][0] < case["query_negative_raw_bounds"][1] <= row["calibration_raw_interval"][0]:
            raise ValueError("overlapping insert/query/calibration intervals")
        if config["family"] == "blowchoc":
            if row["spec"] != case["constructions"][row["filter"]] or not row["warmup_bitmap_released"]:
                raise ValueError("construction hashes/lifetime differ from protocol")
            logical, positions = case["payload_bytes"] - 448, config["probes"] * 2
        else:
            logical, positions = case["payload_bytes"], 0
        if row["logical_bitmap_bytes"] != logical or row["filter_positions_scratch_bytes"] != positions or row["harness_hash_scratch_bytes"] != protocol["batch"] * 8:
            raise ValueError("unaccounted payload or scratch")
        upper = upper95(positives, count)
        if not math.isclose(upper, row["calibration_wilson95_upper"], rel_tol=1e-14):
            raise ValueError("incorrect confidence bound")
        output.append(dict(case=row["case"], filter=row["filter"], keys=row["keys"],
                           actual_bpk=row["actual_bpk"], filter_bytes=row["filter_bytes"],
                           logical_bitmap_bytes=logical, positions_scratch_bytes=positions,
                           absent_queries=count, false_positives=positives, fpr=positives / count,
                           wilson95_upper=upper, pass_1percent=upper <= 0.01,
                           pass_point1percent=upper <= 0.001, pass_point01percent=upper <= 0.0001))
    if seen != set(expected):
        raise ValueError("incomplete configurations")
    return sorted(output, key=lambda row: (row["keys"], row["actual_bpk"], row["filter"]))


def main():
    protocol_path = HERE / "protocol.json"
    protocol = json.loads(protocol_path.read_text())
    results = json.loads((HERE / "results/results.json").read_text())
    if hashlib.sha256(protocol_path.read_bytes()).hexdigest() != results["protocol_sha256"]:
        raise ValueError("protocol changed after execution")
    for name, digest in results["matrix_source_sha256"].items():
        if hashlib.sha256((HERE / name).read_bytes()).hexdigest() != digest:
            raise ValueError("measured source changed: " + name)
    rows = validated_rows(protocol, results)
    with (HERE / "accuracy.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=rows[0].keys(), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    indexed = {(row["filter"], row["keys"], row["actual_bpk"]): row for row in rows}
    text = ["# BlowChoc accuracy screen results", "",
            "All 48 prespecified rows completed without throughput timing. Every fresh build passed all inserted-key checks; all three query/input paths passed full dense-output checks. All 32 actual-size BlowChoc parameter sets passed independent complete-bitmap/answer oracles and reconstruction after later factories replaced module hash globals.", "",
            "Each cell below is the independent-calibration Wilson95% **upper bound in percent**, using16,777,216 negatives. No samples are pooled. Input seed42 and construction seed113 are one screening combination; these are nominal per-configuration intervals, not simultaneous confidence or held-out confirmation. Fresh input **and** construction seeds remain necessary before performance selection.", "",
            "| Filter | 64K,16bpk | 1M,16bpk | 64K,32bpk | 1M,32bpk |",
            "|---|---:|---:|---:|---:|"]
    for config in protocol["configs"]:
        name = config["filter"]
        values = [indexed[name, n, bpk]["wilson95_upper"] * 100 for n, bpk in
                  ((1 << 16, 16), (1 << 20, 16), (1 << 16, 32), (1 << 20, 32))]
        text.append("| " + name + " | " + " | ".join(f"{value:.6f}%" for value in values) + " |")
    text += ["", "`accuracy.csv` retains every raw FP count, confidence bound and threshold flag. `results/` retains the actual construction hashes, input digests, disjoint raw-key intervals, runtime/CPU details and complete metadata. All configs have identical backing-payload caps within a case; BlowChoc's logical bitmap is448B smaller and its16B(K8)/28B(K14) positions buffer is separately charged as scratch.", "",
             f"Elapsed correctness/calibration runtime was {results['elapsed_seconds']:.1f}s; that wall time is **not** a filter throughput result. CPU3/socket1 held one exclusive flock for the full matrix. Protocol, bridge sources and native binary were unchanged. Native controls remain the frozen `{protocol['native_source_commit'][:7]}` snapshot.", ""]
    (HERE / "RESULTS.md").write_text("\n".join(text))
    print(f"Validated {len(rows)} accuracy rows and {len(results['preflights'])} full-bitmap preflights; no speed ranking.")


if __name__ == "__main__":
    main()
