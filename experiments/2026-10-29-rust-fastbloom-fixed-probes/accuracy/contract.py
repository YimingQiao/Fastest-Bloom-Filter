"""Untimed row checks; never import or rank any timing column."""
import json
from pathlib import Path

STAGE = Path(__file__).resolve().parent.parent
REGISTRY = json.loads((STAGE / "registry.json").read_text())
NAMES = tuple(REGISTRY)
NATIVE = {"FastPatternBF", "ByteSplitBloomFilter", "FourSectorBloomFilter", "Split64BloomFilter"}
FIELDS = "language,filter,keys,queries,requested_bpk,filter_bytes,actual_bpk,hash_bits,hit_percent,present_queries,batch,seed,absent_queries,false_positives,result_checksum,key_base,input_mode,calibration_absent_queries,calibration_false_positives,inserted_checked,bitmap_builds,budget_bytes,logical_bytes,geometry_kind,unit_bytes,unit_count,effective_probes,probe_policy,constructor_argument,implementation_origin,size_contract".split(",")


def need(ok, message):
    if not ok:
        raise ValueError(message)


def next_value(state):
    mask = (1 << 64) - 1
    state = (state + 0x9e3779b97f4a7c15) & mask
    x = ((state ^ (state >> 30)) * 0xbf58476d1ce4e5b9) & mask
    x = ((x ^ (x >> 27)) * 0x94d049bb133111eb) & mask
    return state, x ^ (x >> 31)


def order(names, n, q, seed):
    names = set(names)
    present = q // 100 * 50 + min(q % 100, 50)
    state = (seed + 0x9e3779b97f4a7c15 * (n + present + q - 1)) & ((1 << 64) - 1)
    selected = [name for name in NAMES if name in names]
    for count in range(len(selected), 1, -1):
        state, value = next_value(state)
        selected[count - 1], selected[value % count] = selected[value % count], selected[count - 1]
    return selected


def validate(rows, n, cap, q, seed, cal, names):
    names = list(names)
    need(len(set(names)) == len(names) and set(names) <= set(NAMES), "Invalid selected registry")
    need(len(rows) == len(names), "Missing or extra accuracy rows")
    need([r["filter"] for r in rows] == order(names, n, q, seed), "Wrong source-derived accuracy order")
    present = q // 100 * 50 + min(q % 100, 50)
    base = next_value(seed)[1] % ((1 << 32) - n - q)
    for r in rows:
        need(list(r) == FIELDS, "Changed untimed schema or added timing fields")
        name = r["filter"]
        actual = 16 if name in NATIVE and cap == 24 else cap
        fixed = int(name.removeprefix("Fastbloom017K")) if name.startswith("Fastbloom017K") else None
        probes = fixed if fixed is not None else -1 if name == "ByteSplitBloomFilter" else {16: 11, 24: 17, 32: 22}[cap] if name == "Fastbloom017" else 8
        unit = 8 if name.startswith("Fastbloom017") else 32 if name in {"BloomsdayPinned", "SbbfSafePinned"} else 64
        kind = "classical_words" if name.startswith("Fastbloom017") else "native_pow2_lines" if name in NATIVE else "public_split32_range" if name == "BloomsdayPinned" else "public_sbbf_range_padded64" if name == "SbbfSafePinned" else "range_lines"
        policy = "public_fixed_hash_count" if fixed is not None else "upstream_expected_items_real_n" if name == "Fastbloom017" else "variable_byte_mask_0_16" if name == "ByteSplitBloomFilter" else "fixed"
        constructor = actual // 2 if name in NATIVE else n * cap if name.startswith("Fastbloom017") else cap if name == "BloomsdayPinned" else n * actual // 8
        expected = dict(keys=n, queries=q, requested_bpk=cap, filter_bytes=n * actual // 8, actual_bpk=actual,
            hash_bits=64, hit_percent=50, present_queries=present, batch=4096, seed=seed,
            absent_queries=q-present, key_base=base, calibration_absent_queries=cal,
            inserted_checked=n, bitmap_builds=1, budget_bytes=n * cap // 8, logical_bytes=n * actual // 8,
            unit_bytes=unit, unit_count=n * actual // 8 // unit, effective_probes=probes, constructor_argument=constructor)
        for field, value in expected.items():
            parsed = float(r[field]) if field == "actual_bpk" else int(r[field])
            need(parsed == value, "Wrong accuracy field " + name + "/" + field)
        need(r["geometry_kind"] == kind and r["probe_policy"] == policy, "Wrong geometry/probe policy")
        need(r["implementation_origin"] == REGISTRY[name]["owner"], "Wrong ownership")
        need(r["language"] == "rust" and r["input_mode"] == "prehashed" and r["size_contract"] == "exact_byte_ceiling_v1", "Wrong public contract")
        need(0 <= int(r["false_positives"]) <= q-present and 0 <= int(r["calibration_false_positives"]) <= cal, "Invalid FP count")
        need(0 <= int(r["result_checksum"]) < 1 << 64, "Invalid full checksum")
    indexed = {r["filter"]: r for r in rows}
    if cap == 16 and {"Fastbloom017", "Fastbloom017K11"} <= set(indexed):
        for field in ["filter_bytes", "effective_probes", "present_queries", "false_positives", "result_checksum", "calibration_absent_queries", "calibration_false_positives"]:
            need(indexed["Fastbloom017"][field] == indexed["Fastbloom017K11"][field], "Default/fixedK11 alias disagrees")


def retained_equal(current, reference):
    a = {r["filter"]: r for r in current}
    need(set(r["filter"] for r in reference) == set(NAMES[:8]) and len(reference) == 8, "Incomplete old public reference")
    fields = ["keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk", "hash_bits", "hit_percent", "present_queries", "batch", "seed", "absent_queries", "false_positives", "result_checksum", "input_mode", "calibration_absent_queries", "calibration_false_positives", "budget_bytes", "logical_bytes", "geometry_kind", "unit_bytes", "unit_count", "effective_probes", "probe_policy", "constructor_argument", "implementation_origin", "size_contract"]
    for old in reference:
        for field in fields:
            need(a[old["filter"]][field] == old[field], "Changed retained semantic " + old["filter"] + "/" + field)
