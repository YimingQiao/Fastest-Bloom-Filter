"""Exact API ownership, phase balance, allocation and quality guard."""
import itertools
import math
import statistics

MODES = ("prehashed", "common-fused", "common-staged")
BUILD_FIELDS = ("insert_ns", "allocate_insert_ns", "hash_insert_ns", "allocate_hash_insert_ns")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def validate(row, config, case, protocol, measure):
    require(row["filter"] == config["filter"], "wrong filter ownership")
    require(row["keys"] == case["keys"] and row["queries"] == case["queries"] and row["seed"] == 42, "wrong workload")
    require(row["requested_bpk"] == case["requested_bpk"] and row["filter_bytes"] == case["payload_bytes"]
            and row["actual_bpk"] == case["actual_bpk"], "wrong actual allocation")
    require(row["batch"] == protocol["batch"] and row["repeats"] == 6
            and row["query_repeats"] == 6 and row["build_repeats"] == 0
            and row["hit_percent"] == 50, "wrong query/build repeat protocol")
    require(row["input_mode"] == "common64" and row["api_track"] == "compiled-visible-scalar-whole-array", "wrong API contract")
    require(row["build_mode"] == "query_only_one_unmeasured_prehashed_build"
            and all(row[key] is None for key in BUILD_FIELDS), "unmeasured build metrics fabricated")
    require(row["throughput_enabled"] is measure, "preflight/timing confusion")
    require(row["calibration_raw_interval"] == case["calibration_raw_interval"], "wrong calibration stream")
    cal = case["calibration_raw_interval"][1] - case["calibration_raw_interval"][0]
    require(row["calibration_absent_queries"] == cal and 0 <= row["calibration_false_positives"] <= cal, "wrong calibration count")
    q = case["queries"]
    present = q // 100 * 50 + min(q % 100, 50)
    require(row["present_queries"] == present and row["absent_queries"] == q - present
            and 0 <= row["false_positives"] <= q - present, "wrong mixed-query count")
    require(0 <= row["result_checksum"] < 1 << 64, "invalid result checksum")
    logical, scratch = case["payload_bytes"], 0
    if config["family"] == "blowchoc":
        logical -= 448
        scratch = 2 * config["probes"]
        require(row["spec"] == case["constructions"][config["filter"]]
                and row["construction_seed"] == 113 and row["construction_seed_used"]
                and row["warmup_bitmap_released"], "wrong construction or retained warmup")
    else:
        require(row["construction_seed"] is None and not row["construction_seed_used"], "native construction seed used")
    require(row["logical_bitmap_bytes"] == logical and row["positions_scratch_bytes"] == scratch
            and row["harness_hash_scratch_bytes"] == 8 * protocol["batch"], "unaccounted payload/scratch")
    orders = [list(order) for order in itertools.permutations(MODES)]
    require(row["phase_orders"] == orders and len(row["query_trials"]) == 18, "wrong six-permutation schedule")
    seen = set()
    samples = {mode: [] for mode in MODES}
    for trial in row["query_trials"]:
        key = trial["trial"], trial["position"]
        require(key not in seen and 0 <= key[0] < 6 and 0 <= key[1] < 3, "duplicate or invalid trial ownership")
        seen.add(key)
        require(trial["mode"] == orders[key[0]][key[1]], "phase label belongs to another position")
        require(trial["result_checksum"] == row["result_checksum"], "timed full output differs")
        elapsed = trial["elapsed_ns"]
        if measure:
            require(isinstance(elapsed, int) and elapsed > 0, "invalid timing sample")
            samples[trial["mode"]].append(elapsed)
        else:
            require(elapsed is None, "timing data in correctness-only preflight")
    for mode in MODES:
        value = row["query_ns_per_key"][mode]
        if measure:
            require(math.isclose(value, statistics.median(samples[mode]) / q, rel_tol=1e-14), "wrong mode median")
        else:
            require(value is None, "timing median in preflight")
