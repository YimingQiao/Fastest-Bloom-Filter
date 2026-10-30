"""Fail-closed correctness guards; never rank unclaimed preflight timings."""
import math
import re

NATIVE = {"FastPatternBF", "ByteSplitBloomFilter", "FourSectorBloomFilter", "Split64BloomFilter"}
EXTERNAL = {"Fastbloom017", "BloomsdayPinned", "SbbfSafePinned"}
RANGE = "Split64RangeBloomFilter"
NAMES = NATIVE | EXTERNAL | {RANGE}
METRICS = ("lookup", "hash_lookup", "inline_lookup", "inline_hash_lookup")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def next_value(state):
    mask = (1 << 64) - 1
    state = (state + 0x9e3779b97f4a7c15) & mask
    x = ((state ^ (state >> 30)) * 0xbf58476d1ce4e5b9) & mask
    x = ((x ^ (x >> 27)) * 0x94d049bb133111eb) & mask
    return state, x ^ (x >> 31)


def shuffled(names, state):
    values = list(names)
    for count in range(len(values), 1, -1):
        state, value = next_value(state)
        position = value % count
        values[count - 1], values[position] = values[position], values[count - 1]
    return values


def validate_cli(rows, source, power, cap, hit, batch, repeats=4, qp=12, cal=12, seed=42):
    require(__debug__, "Run guards without Python -O")
    match = re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];', source, re.S)
    require(match is not None, "Missing source registry")
    names = re.findall(r'"([A-Za-z0-9_]+)"', match[1])
    require(len(names) == len(set(names)) == 8 and set(names) == NAMES, "Wrong source registry")
    n, q = 1 << power, 1 << qp
    present = q // 100 * hit + min(q % 100, hit)
    draws = 1 + n - 1 + present + q - 1
    state = (seed + 0x9e3779b97f4a7c15 * draws) & ((1 << 64) - 1)
    require([r["filter"] for r in rows] == shuffled(names, state), "Wrong exact measured row order")
    labels = shuffled(range(4), seed ^ 0x6a09e667f3bcc909)
    schedule = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
    phase = ";".join("|".join(str(labels[x]) for x in schedule[i % 4]) for i in range(repeats))
    for r in rows:
        name = r["filter"]
        actual = 16 if name in NATIVE and cap == 24 else cap
        expected = dict(keys=n, queries=q, requested_bpk=cap, filter_bytes=n * actual // 8,
                        budget_bytes=n * cap // 8, actual_bpk=actual, hash_bits=64,
                        hit_percent=hit, present_queries=present, absent_queries=q-present,
                        batch=batch, repeats=repeats, seed=seed, insert_batch=n,
                        calibration_absent_queries=1 << cal, logical_bytes=n * actual // 8)
        for field, value in expected.items():
            require(float(r[field]) == value, "Wrong " + field + ": " + name)
        require(r["language"] == "rust" and r["input_mode"] == "prehashed", "Wrong input contract")
        owner = "production_native" if name in NATIVE else "external" if name in EXTERNAL else "native_experimental"
        require(r["implementation_origin"] == owner and r["size_contract"] == "exact_byte_ceiling_v1", "Wrong geometry ownership")
        require(int(r["unit_bytes"]) * int(r["unit_count"]) == int(r["logical_bytes"]), "Wrong geometry dimensions")
        expected_k = -1 if name == "ByteSplitBloomFilter" else {16: 11, 24: 17, 32: 22}[cap] if name == "Fastbloom017" else 8
        require(int(r["effective_probes"]) == expected_k, "Wrong probe metadata")
        require(0 <= int(r["false_positives"]) <= q-present, "Bad mixed FP count")
        require(0 <= int(r["calibration_false_positives"]) <= 1 << cal, "Bad calibration FP count")
        require(r["query_phase_order"] == phase, "Wrong phase order")
        for metric in METRICS:
            samples = [float(v) for v in r[metric + "_trials"].split("|")]
            require(len(samples) == repeats and all(math.isfinite(v) and v > 0 for v in samples), "Invalid timing vector")
            ordered = sorted(samples)
            median = (ordered[repeats//2-1] + ordered[repeats//2]) / 2
            require(math.isclose(float(r[metric + "_ns"]), median, rel_tol=1e-12), "Wrong median")
            require(float(r[metric + "_min_ns"]) == min(samples) and float(r[metric + "_max_ns"]) == max(samples), "Wrong range")


def validate_old_rows(current, old):
    a, b = {r["filter"]: r for r in current}, {r["filter"]: r for r in old}
    require(len(old) == 7 and set(b) == NATIVE | EXTERNAL, "Wrong retained-reference registry")
    fields = ("keys", "queries", "filter_bytes", "actual_bpk", "hash_bits", "hit_percent",
              "present_queries", "absent_queries", "batch", "repeats", "seed", "insert_batch",
              "false_positives", "result_checksum", "input_mode", "calibration_absent_queries",
              "calibration_false_positives", "query_phase_order")
    for name in b:
        require(int(a[name]["requested_bpk"]) == int(b[name]["requested_bpk"]) * 2, "Wrong intended legacy ceiling inverse")
        for field in fields:
            require(a[name][field] == b[name][field], "Retained-reference semantic mismatch: " + name + "/" + field)


def validate_dense(current, reference):
    expected = {(name, n, cap) for name in NAMES for n in (64, 1024, 65536) for cap in (16, 24, 32)}
    def index(rows):
        out = {}
        for row in rows:
            key = (row["filter"], row["keys"], row["budget_bpk"])
            require(key not in out, "Duplicate full-output fixture")
            out[key] = row
        return out
    a, b = index(current), index(reference)
    require(set(a) == expected and len(a) == 72, "Incomplete current full-output fixtures")
    require(set(b) == {k for k in expected if k[0] != RANGE and k[2] != 24} and len(b) == 42, "Incomplete reference full-output fixtures")
    for key, row in a.items():
        name, n, cap = key
        actual = 16 if name in NATIVE and cap == 24 else cap
        require(row["filter_bytes"] == n * actual // 8 and row["inserted_checked"] == n, "Wrong observed dense geometry")
        require(len(row["outputs"]) == 4097 and len(row["calibration_outputs"]) == 4096, "Incomplete dense arrays")
        require(all(v in (0, 1) for v in row["outputs"] + row["calibration_outputs"]), "Nonboolean full output")
        require(all(row["outputs"][i] == 1 for i in range(0, 4097, 4)), "Dense false negative")
        require(row["mixed_fp"] == sum(v for i, v in enumerate(row["outputs"]) if i % 4), "Wrong dense mixed FP count")
        require(row["calibration_fp"] == sum(row["calibration_outputs"]), "Wrong dense calibration FP count")
        if key in b:
            require(row == b[key], "Complete old/current query output mismatch")
        if cap == 24 and name in NATIVE:
            counterpart = dict(a[(name, n, 16)], budget_bpk=24)
            require(row == counterpart, "Same native geometry changed under cap24 alias")
    return dict(current_cases=72, reference_cases=42, full_compared_answers=42 * (4097 + 4096))
