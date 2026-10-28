"""Exact registry, four-mode trials, actual-byte and independent-quality guards."""
import itertools
import math

from check_preflight import CONTROLS, METRICS, NAMES, validate_row

NATIVE = {"FastPatternBF", "ByteSplitBloomFilter", "FourSectorBloomFilter", "Split64BloomFilter"}
EXTERNAL = {"Fastbloom017", "BloomsdayPinned", "SbbfSafePinned"}
BUILD = ("insert_ns", "allocate_insert_ns", "hash_insert_ns", "allocate_hash_insert_ns")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def workloads(protocol):
    return list(itertools.product(protocol["key_powers"], protocol["requested_bpk"], protocol["batches"], protocol["seeds"]))


def expected_names(batch):
    return NAMES


def validate_registry(registry):
    require(set(registry) == NAMES, "Missing or unexpected family/control")
    for name, info in registry.items():
        expected = "native_experimental" if name in CONTROLS or name == "Independent32BloomFilter" else "native" if name in NATIVE else "external"
        require(info["owner"] == expected, "Wrong ownership")
        require(info["original"] == CONTROLS.get(name, name), "Wrong original/control pair")
        api = "independent32_native_v1" if name == "Independent32BloomFilter" else "leaf_inline_always_v1" if name in CONTROLS else "original"
        require(info["api"] == api, "Wrong API label")


def validate_rows(rows, registry, protocol, workload):
    require(__debug__, "Run guards without Python -O")
    validate_registry(registry)
    power, bpk, batch, seed = workload
    names = [row["filter"] for row in rows]
    expected_filters = expected_names(batch)
    require(len(names) == len(expected_filters) and len(set(names)) == len(names) and set(names) == expected_filters, "Wrong exact workload registry")
    n, q = 1 << power, 1 << protocol["query_power"]
    present = q // 100 * protocol["hit_percent"] + min(q % 100, protocol["hit_percent"])
    expected = dict(keys=n, queries=q, requested_bpk=bpk, seed=seed, batch=batch,
                    repeats=protocol["repeats"], filter_bytes=n * bpk // 4,
                    hash_bits=64, hit_percent=protocol["hit_percent"], present_queries=present,
                    absent_queries=q - present, insert_batch=n,
                    calibration_absent_queries=1 << protocol["calibration_power"])
    for row in rows:
        require(row["language"] == "rust" and row["input_mode"] == "prehashed", "Wrong input contract")
        for key, value in expected.items():
            require(int(row[key]) == value, f"Unexpected {key}: {row['filter']}")
        require(float(row["actual_bpk"]) == bpk * 2, "Actual allocation differs")
        require(0 <= int(row["result_checksum"]) < 1 << 64, "Invalid checksum")
        fp, absent = int(row["false_positives"]), int(row["absent_queries"])
        require(0 <= fp <= absent, "Invalid mixed false positives")
        require(math.isclose(float(row["fpr"]), fp / absent if absent else 0, rel_tol=1e-12, abs_tol=1e-15), "Mixed FPR differs")
        count, fp = int(row["calibration_absent_queries"]), int(row["calibration_false_positives"])
        require(0 <= fp <= count, "Invalid calibration count")
        for metric in BUILD:
            require(math.isfinite(float(row[metric])) and float(row[metric]) > 0, "Invalid build timing")
        require(float(row["allocate_insert_ns"]) >= float(row["insert_ns"]), "Allocation-inclusive build smaller")
        require(float(row["allocate_hash_insert_ns"]) >= float(row["hash_insert_ns"]), "Allocation-inclusive hashed build smaller")
        validate_row(row)  # Full four-mode vectors, median/ranges, positions and predecessors.
    by_name = {row["filter"]: row for row in rows}
    semantic = ("filter_bytes", "actual_bpk", "result_checksum", "false_positives", "absent_queries", "present_queries", "calibration_false_positives", "calibration_absent_queries", "input_mode")
    for candidate, original in CONTROLS.items():
        require(all(by_name[candidate][field] == by_name[original][field] for field in semantic), "Original/candidate semantic mismatch")


def validate_all(rows, registry, protocol):
    require(len(rows) == protocol["rows"], "Incomplete matrix")
    groups = {}
    for row in rows:
        n = int(row["keys"])
        require(n > 0 and n & (n - 1) == 0, "Non-power-of-two keys")
        key = (n.bit_length() - 1, int(row["requested_bpk"]), int(row["batch"]), int(row["seed"]))
        groups.setdefault(key, []).append(row)
    require(set(groups) == set(workloads(protocol)), "Unexpected/missing workload")
    seen = {}
    fields = ("filter_bytes", "actual_bpk", "result_checksum", "false_positives", "absent_queries", "present_queries", "calibration_false_positives", "calibration_absent_queries")
    for key, group in groups.items():
        validate_rows(group, registry, protocol, key)
        for row in group:
            identity = tuple(row[field] for field in ("filter", "keys", "requested_bpk", "seed"))
            values = tuple(row[field] for field in fields)
            require(identity not in seen or seen[identity] == values, "Batch changed original/candidate semantics")
            seen[identity] = values
