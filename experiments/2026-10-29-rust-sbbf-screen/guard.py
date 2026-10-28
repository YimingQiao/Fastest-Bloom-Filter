"""Strict workload, ownership, allocation and calibration guards before ranking."""
import itertools
import math

Z = 1.959963984540054
SEMANTIC_FIELDS = (
    "filter_bytes", "actual_bpk", "hash_bits", "result_checksum",
    "false_positives", "absent_queries", "present_queries",
    "calibration_false_positives", "calibration_absent_queries", "input_mode",
)
BUILD_METRICS = ("insert_ns", "allocate_insert_ns", "hash_insert_ns", "allocate_hash_insert_ns")
NATIVE_FAMILIES = {"FastPattern", "ByteSplit", "FourSector", "Split64"}
EXTERNAL_FAMILIES = {"Fastbloom", "Bloomsday", "SBBF"}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def validate_registry(registry):
    require(len(registry) == 14, "Expected full 14-row registry")
    family_paths = {}
    for name, info in registry.items():
        family = info["family"]
        owner = "native" if family in NATIVE_FAMILIES else "external" if family in EXTERNAL_FAMILIES else None
        require(owner is not None and info["owner"] == owner, f"Wrong ownership for {name}")
        require(info["api"] in ("original", "singleton_control"), "Unknown API contract")
        require(info["api"] not in family_paths.setdefault(family, {}), "Duplicate family/API")
        family_paths[family][info["api"]] = name
    require(set(family_paths) == NATIVE_FAMILIES | EXTERNAL_FAMILIES, "Missing family")
    for family, paths in family_paths.items():
        require(set(paths) == {"original", "singleton_control"}, f"Incomplete controls: {family}")
        require(all(registry[name]["original"] == paths["original"] for name in paths.values()), "Original mapping mismatch")


def workloads(protocol):
    return list(itertools.product(protocol["key_powers"], protocol["requested_bpk"],
                                  protocol["batches"], protocol["seeds"]))


def validate_rows(rows, registry, protocol, workload):
    validate_registry(registry)
    power, bpk, batch, seed = workload
    require(len(rows) == len(registry), "Wrong row count")
    names = [r["filter"] for r in rows]
    require(len(set(names)) == len(names) and set(names) == set(registry), "Missing/duplicate/unknown row")
    n, q = 1 << power, 1 << protocol["query_power"]
    present = q // 100 * protocol["hit_percent"] + min(q % 100, protocol["hit_percent"])
    expected_bytes = n * bpk // 4  # Strict-next-power-of-two for this fixed grid.
    expected = dict(keys=n, queries=q, requested_bpk=bpk, batch=batch, repeats=protocol["repeats"],
                    seed=seed, insert_batch=n, hash_bits=64, hit_percent=protocol["hit_percent"],
                    present_queries=present, absent_queries=q - present,
                    filter_bytes=expected_bytes, calibration_absent_queries=1 << protocol["calibration_power"])
    by_name = {r["filter"]: r for r in rows}
    for row in rows:
        require(row["language"] == "rust" and row["input_mode"] == "prehashed", "Wrong hash/language contract")
        for key, value in expected.items():
            require(int(row[key]) == value, f"Unexpected {key} for {row['filter']}")
        require(float(row["actual_bpk"]) == expected_bytes * 8 / n, "Wrong actual allocation")
        require(0 <= int(row["result_checksum"]) < 1 << 64, "Invalid checksum")
        fp, absent = int(row["false_positives"]), int(row["absent_queries"])
        require(0 <= fp <= absent, "Invalid mixed false-positive count")
        require(math.isclose(float(row["fpr"]), fp / absent, rel_tol=1e-12, abs_tol=1e-15), "Wrong mixed FPR")
        cal, cal_fp = int(row["calibration_absent_queries"]), int(row["calibration_false_positives"])
        require(0 <= cal_fp <= cal, "Invalid calibration false-positive count")
        for prefix in ("lookup", "hash_lookup"):
            values = [float(row[prefix + suffix]) for suffix in ("_min_ns", "_ns", "_max_ns")]
            require(all(math.isfinite(x) and x > 0 for x in values) and values == sorted(values), "Invalid query timing/range")
        for metric in BUILD_METRICS:
            require(math.isfinite(float(row[metric])) and float(row[metric]) > 0, "Invalid build timing")
        require(float(row["allocate_insert_ns"]) >= float(row["insert_ns"]), "Allocation-inclusive insert is smaller")
        require(float(row["allocate_hash_insert_ns"]) >= float(row["hash_insert_ns"]), "Allocation-inclusive hash insert is smaller")
        original = by_name[registry[row["filter"]]["original"]]
        require(all(row[key] == original[key] for key in SEMANTIC_FIELDS), "Original/control semantic mismatch")


def validate_all(rows, registry, protocol):
    require(len(rows) == protocol["rows"], "Incomplete matrix")
    groups = {}
    for row in rows:
        n = int(row["keys"])
        require(n > 0 and n & (n - 1) == 0, "Non-power-of-two key count")
        key = (n.bit_length() - 1, int(row["requested_bpk"]), int(row["batch"]), int(row["seed"]))
        groups.setdefault(key, []).append(row)
    require(set(groups) == set(workloads(protocol)), "Unexpected/missing workload")
    seen = {}
    for workload, group in groups.items():
        validate_rows(group, registry, protocol, workload)
        for row in group:
            identity = (row["filter"], row["keys"], row["requested_bpk"], row["seed"])
            signature = tuple(row[field] for field in SEMANTIC_FIELDS)
            require(identity not in seen or seen[identity] == signature, "Batch changed bitmap/output/calibration")
            seen[identity] = signature


def wilson(fp, count):
    require(count > 0 and 0 <= fp <= count, "Invalid independent calibration")
    p, zz = fp / count, Z * Z
    center = p + zz / (2 * count)
    spread = Z * math.sqrt((p * (1 - p) + zz / (4 * count)) / count)
    divisor = 1 + zz / count
    return max(0.0, (center - spread) / divisor), min(1.0, (center + spread) / divisor)


def quality_rows(rows, registry):
    """One calibration experiment per original family/size/seed, never per batch."""
    result = {}
    for row in rows:
        info = registry[row["filter"]]
        if info["api"] != "original":
            continue
        key = (info["family"], row["keys"], row["requested_bpk"], row["seed"])
        fp, count = int(row["calibration_false_positives"]), int(row["calibration_absent_queries"])
        low, high = wilson(fp, count)
        item = dict(family=info["family"], owner=info["owner"], original=row["filter"],
                    keys=int(row["keys"]), requested_bpk=int(row["requested_bpk"]), seed=int(row["seed"]),
                    filter_bytes=int(row["filter_bytes"]), actual_bpk=float(row["actual_bpk"]),
                    calibration_negatives=count, calibration_fp=fp, fpr=fp / count,
                    wilson_lower=low, wilson_upper=high)
        require(key not in result or result[key] == item, "Calibration differs across batch duplicates")
        result[key] = item
    return list(result.values())


def select(rows, registry, names, metric, n, batch, cap, ceiling):
    eligible = [row for row in rows if row["filter"] in names
                and int(row["keys"]) == n and int(row["batch"]) == batch
                and int(row["filter_bytes"]) * 8 <= n * cap
                and wilson(int(row["calibration_false_positives"]), int(row["calibration_absent_queries"]))[1] <= ceiling]
    if not eligible:
        return None
    row = min(eligible, key=lambda r: (float(r[metric]), int(r["filter_bytes"]), r["filter"]))
    prefix = metric[:-3]
    info = registry[row["filter"]]
    return dict(filter=row["filter"], family=info["family"], owner=info["owner"], api=info["api"],
                requested_bpk=int(row["requested_bpk"]), filter_bytes=int(row["filter_bytes"]),
                actual_bpk=float(row["actual_bpk"]), median_ns=float(row[metric]),
                min_ns=float(row[prefix + "_min_ns"]), max_ns=float(row[prefix + "_max_ns"]),
                calibration_negatives=int(row["calibration_absent_queries"]),
                calibration_fp=int(row["calibration_false_positives"]),
                wilson_upper=wilson(int(row["calibration_false_positives"]), int(row["calibration_absent_queries"]))[1])


def track_names(registry, track, owner):
    require(track in ("original_only", "original_native_vs_best_external", "singleton_controls", "best_public_paths"), "Unknown API track")
    names = set()
    for name, info in registry.items():
        if info["owner"] != owner:
            continue
        if track == "original_only" and info["api"] != "original":
            continue
        if track == "original_native_vs_best_external" and owner == "native" and info["api"] != "original":
            continue
        if track == "singleton_controls" and info["api"] != "singleton_control":
            continue
        names.add(name)
    return names
