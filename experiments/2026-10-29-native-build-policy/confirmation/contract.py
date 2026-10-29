"""Offline paired-record contract; no compiler or Bloom execution."""
import functools
import math
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "confirmation-plan"))
import plan

MASK = (1 << 64) - 1
QUERY_N = 32771
ARMS = ("serial", "control", "candidate")
SEMANTICS = ("family", "scenario", "bytes", "batch_n", "history_n", "hotspot", "seed",
             "input_base", "query_n", "checksum", "positives", "batch_checksum", "query_checksum")


def need(ok, text):
    if not ok:
        raise ValueError(text)


def hash64(index):
    z = (0x243f6a8885a308d3 + (index + 1) * 0x9e3779b97f4a7c15) & MASK
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & MASK
    return z ^ (z >> 31)


def digest(values):
    result = 14695981039346656037
    for value in values:
        result = ((result ^ value) * 1099511628211) & MASK
    return result


@functools.lru_cache(maxsize=24)
def input_checksums(seed, n, history, hotspot):
    base = seed << 42
    batch = [hash64(base + (1 << 40) + i) & (0xffffffff if hotspot else MASK) for i in range(n)]
    query = [hash64(base + (2 << 40) + i) for i in range(QUERY_N)]
    for i in range(0, QUERY_N, 3):
        query[i] = batch[i % n]
    for i in range(1, QUERY_N, 3):
        query[i] = hash64(base + i % history) if history else batch[(i * 17) % n]
    return digest(batch), digest(query)


def executed_order(case):
    result = []
    for repeat, arms in enumerate(plan.SCHEDULE):
        contracts = ["insert"] if case["history_n"] else (
            ["allocate_insert", "insert"] if repeat in (1, 2) else ["insert", "allocate_insert"])
        result.extend(f"{repeat}:{contract}:{arm}" for contract in contracts for arm in arms)
    return result


def scratch(language, n, w):
    if w == 1:
        return 0
    value = n * 8 + w * ((w + 7) // 8) * 64 + (w + 1) * 8
    return value if language == "cpp" else value + w * w * 24 + w * 48


def stats(case, arm):
    inside = case["batch_n"] <= 65536 and case["bytes"] <= 262144
    w = 1 if arm == "serial" or (arm == "candidate" and inside) else case["requested"]
    spawn = (w - 1) if case["language"] == "cpp" else (0 if w == 1 else w)
    return dict(effective=w, workers=w, scratch_bytes=scratch(case["language"], case["batch_n"], w),
                spawned_per_pass=spawn)


def validate(row, case, cpus):
    for key in ("language", "family", "scenario", "bytes", "batch_n", "requested", "history_n", "hotspot", "seed", "input_base"):
        need(row[key] == case[key], "Changed workload field: " + key)
    need(row["query_n"] == QUERY_N and row["repeats"] == 4, "Wrong query/repeat count")
    need(row["time_unit"] == "absolute_ns", "Wrong timing unit")
    need(row["phase_order"] == "serial_pair_abba4" and row["executed_order"] == executed_order(case), "Changed phase order")
    need(row["cpus"] == cpus and len(cpus) == case["requested"] and cpus[0] in (2, 3), "Wrong core budget")
    need(len(set(cpus)) == len(cpus), "Duplicate CPU")
    scheduler = "caller_worker0" if case["language"] == "cpp" else "scoped_workers_plus_caller_or_serial_fallback"
    need(row["scheduler"] == scheduler, "Wrong native scheduler")
    need(type(row["checksum"]) is int and 0 <= row["checksum"] <= MASK, "Invalid result checksum")
    present = QUERY_N - QUERY_N // 3
    need(type(row["positives"]) is int and present <= row["positives"] <= QUERY_N, "Inserted mixed false negative")
    batch_sum, query_sum = input_checksums(case["seed"], case["batch_n"], case["history_n"], case["hotspot"])
    need(row["batch_checksum"] == batch_sum and row["query_checksum"] == query_sum, "Generated input stream changed")
    need(set(row["arms"]) == set(ARMS), "Missing/extra public arm")
    for arm in ARMS:
        entry = row["arms"][arm]
        expected = stats(case, arm)
        need(set(entry) == set(expected) | {"insert_ns", "allocate_insert_ns", "insert_prefill_setup_ns"}, "Wrong arm fields")
        need(all(entry[k] == v for k, v in expected.items()), "Worker/scratch metadata mismatch")
        for metric in ("insert", "allocate_insert"):
            values = entry[metric + "_ns"]
            available = metric == "insert" or not case["history_n"]
            need(isinstance(values, list) and len(values) == (4 if available else 0), "Wrong primary trial count")
            need(all(type(x) in (int, float) and math.isfinite(x) and x > 0 for x in values), "Invalid primary duration")
        setup = entry["insert_prefill_setup_ns"]
        need(isinstance(setup, list) and len(setup) == 4, "Wrong setup trial count")
        need(all(type(x) in (int, float) and math.isfinite(x) and (x > 0 if case["history_n"] else x == 0) for x in setup), "Wrong setup accounting")
    return row


def audit(rows, cpus_by_requested):
    cases = plan.ledger()
    need(len(rows) == len(cases), "Incomplete paired matrix")
    semantic = {}
    for row, case in zip(rows, cases, strict=True):
        validate(row, case, cpus_by_requested[case["requested"]])
        key = (case["family"], case["scenario"], case["seed"])
        value = tuple(row[k] for k in SEMANTICS)
        need(key not in semantic or semantic[key] == value, "Cross-language/request semantic mismatch")
        semantic[key] = value
    need(len(semantic) == 24, "Wrong semantic geometry count")
    return dict(paired_cases=96, variant_rows=192, serial_reference_records=96,
                semantic_geometries=24, variant_metric_records=320, serial_metric_records=160)
