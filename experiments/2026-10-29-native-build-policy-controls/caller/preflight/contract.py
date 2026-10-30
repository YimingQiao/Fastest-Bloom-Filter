"""Four-arm row validation; no compiler or Bloom execution."""
import functools
import importlib.util
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
PLAN = HERE.parent.parent
spec = importlib.util.spec_from_file_location("four_arm_plan", PLAN / "plan.py")
plan = importlib.util.module_from_spec(spec)
spec.loader.exec_module(plan)
MASK = (1 << 64) - 1
QUERY_N = 32771
CHECK_SEED = 74381
SEMANTICS = ("family", "scenario", "bytes", "batch_n", "history_n", "hotspot", "seed",
             "input_base", "query_n", "checksum", "positives", "batch_checksum", "query_checksum")


def need(ok, text):
    if not ok:
        raise ValueError(text)


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        need(key not in result, "Duplicate JSON field: " + key)
        result[key] = value
    return result


def parse(text):
    return json.loads(text, object_pairs_hook=unique_object,
                      parse_constant=lambda value: need(False, "Nonfinite JSON constant " + value))


def fixtures(language):
    result = []
    for family in plan.FAMILIES:
        for index in (0, 1, 2):
            row = plan.scenario(family, index)
            row.update(language=language, family=family, scenario=index,
                       requested=plan.REQUESTS[language], seed=CHECK_SEED,
                       input_base=CHECK_SEED << 42, repeats=4, cycles=1)
            result.append(row)
    return result


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


@functools.lru_cache(maxsize=32)
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
    return [f"{repeat}:{contract}:{arm}" for repeat in range(case["repeats"])
            for contract in plan.contract_order(case, repeat) for arm in plan.arm_order(repeat)]


def stats(case, arm):
    active = case["batch_n"] <= 65536 and case["bytes"] <= 262144
    workers = 1 if arm == "Policy" and active else case["requested"]
    scratch = 0 if workers == 1 else case["batch_n"] * 8 + workers * ((workers + 7) // 8) * 64 + (workers + 1) * 8
    if workers > 1 and case["language"] == "rust":
        scratch += workers * workers * 24 + workers * 48
    spawn = workers - 1 if case["language"] == "cpp" else (0 if workers == 1 else workers)
    return dict(effective=workers, workers=workers, scratch_bytes=scratch, spawned_per_pass=spawn)


def validate(row, case, cpus):
    for key in ("language", "family", "scenario", "bytes", "batch_n", "requested", "history_n", "hotspot", "seed", "input_base"):
        need(type(row[key]) is type(case[key]) and row[key] == case[key], "Changed workload: " + key)
    need(row["query_n"] == QUERY_N and row["repeats"] == case["repeats"] and row["cycles"] == case["cycles"], "Wrong counts")
    need(row["time_unit"] == "absolute_ns" and row["phase_order"] == "four_arm_williams", "Wrong measurement contract")
    need(row["executed_order"] == executed_order(case), "Changed exact chronological order")
    need(row["cpus"] == cpus and len(cpus) == case["requested"] and cpus[0] in (2, 3), "Wrong CPU budget")
    need(len(set(cpus)) == len(cpus), "Duplicate CPU")
    scheduler = "caller_worker0" if case["language"] == "cpp" else "scoped_workers_plus_caller_or_serial_fallback"
    need(row["scheduler"] == scheduler, "Changed scheduler")
    need(type(row["checksum"]) is int and 0 <= row["checksum"] <= MASK, "Invalid checksum")
    need(type(row["positives"]) is int and QUERY_N - QUERY_N // 3 <= row["positives"] <= QUERY_N, "Mixed false negative")
    need((row["batch_checksum"], row["query_checksum"]) == input_checksums(case["seed"], case["batch_n"], case["history_n"], case["hotspot"]), "Input stream mismatch")
    need(set(row["arms"]) == set(plan.ARMS), "Wrong four-arm set")
    for arm, entry in row["arms"].items():
        expected = stats(case, arm)
        need(set(entry) == set(expected) | {"insert_ns", "allocate_insert_ns", "insert_prefill_setup_ns"}, "Wrong arm fields")
        need(all(type(entry[k]) is int and entry[k] == value for k, value in expected.items()), "Worker/scratch mismatch")
        for metric in ("insert", "allocate_insert"):
            values = entry[metric + "_ns"]
            available = metric == "insert" or not case["history_n"]
            need(isinstance(values, list) and len(values) == (case["repeats"] if available else 0), "Wrong trial count")
            need(all(type(x) in (int, float) and math.isfinite(x) and x > 0 for x in values), "Invalid duration")
        setup = entry["insert_prefill_setup_ns"]
        need(isinstance(setup, list) and len(setup) == case["repeats"], "Wrong setup count")
        need(all(type(x) in (int, float) and math.isfinite(x) and (x > 0 if case["history_n"] else x == 0) for x in setup), "Wrong setup separation")
    return row


def reference_check(row):
    reference = parse((HERE / "references.json").read_text())
    selected = [r for r in reference["records"] if all(r[k] == row[k] for k in ("language", "family", "scenario", "requested", "seed"))]
    need(len(selected) == 1, "Missing unique old-seed semantic reference")
    need({key: row[key] for key in reference["fields"]} == selected[0], "Old actual-native full-output/checksum semantics changed")
