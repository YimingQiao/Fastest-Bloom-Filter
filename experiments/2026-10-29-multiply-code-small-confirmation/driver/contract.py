"""Fixed144 geometry, exact order/trials, and unpooled quality contract."""
import csv
import importlib.util
import io
import json
import math
from pathlib import Path

from source_guard import PARENT, ROOT, STAGE, require

def frozen_module(name):
    spec = importlib.util.spec_from_file_location("multiply144_frozen_" + name, PARENT / (name + ".py"))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


# Load only these two immutable helpers. Altering sys.path would also expose
# unrelated parent test scripts that have top-level benchmark side effects.
_order = frozen_module("order_oracle")
_rows = frozen_module("validate_rows")
expected_order, source_registry = _order.expected_order, _order.source_registry
validate, GEOMETRY = _rows.validate, _rows.GEOMETRY

MUL = "MultiplyCodeSplit64RangeExperiment"
FOUR = "FourSectorBloomFilter"
SEMANTICS = ("result_checksum", "false_positives", "absent_queries", "present_queries",
             "calibration_false_positives", "calibration_absent_queries")


def protocol():
    return json.loads((STAGE / "protocol.json").read_text())


def registry():
    exact = ROOT / "experiments/2026-10-29-exact-budget-range"
    return source_registry((PARENT / "adapters.hpp").read_text(),
                           (exact / "cpp-adapters.hpp").read_text(),
                           (exact / "boost-adapters.hpp").read_text(),
                           (exact / "rocks-adapters.hpp").read_text())


def dimensions(p):
    require((p["query_power"], p["hit_percent"], p["repeats"], p["calibration_power"],
             p["build_repeats"], p["mode"], p["expected_cases"], p["expected_rows"], p["target_fpr"])
            == (22, 50, 6, 24, 0, "query-only", 18, 144, .001), "Changed fixed confirmation dimensions")
    require(p["known_failed_diagnostic"] == [FOUR], "Historical Four16 diagnostic must remain")
    names = [c["filter"] for c in p["configurations"]]
    require(len(names) == len(set(names)) == 8 and names[0] == MUL, "Wrong fixed8 APIs")
    grid = json.loads((PARENT / "validation-v1/planned-grid.json").read_text())
    by_id = {r["configuration_id"]: r for r in grid["configurations"]}
    for config in p["configurations"]:
        require(by_id.get(config["configuration_id"]) == config, "Configuration differs from compiled planner")
        require(int(config["filter_bytes"]) <= 131072 and int(config["keys"]) == 65536,
                "Fixed geometry exceeds actual16-bpk budget")
    reg = registry()
    require(grid["registry"] == reg and len(grid["configurations"]) == 1016, "Wrong retained76 planner")
    ledger = json.loads((STAGE / "seed-ledger.json").read_text())
    require(ledger["registry"] == reg and ledger["filters"] == names, "Ledger registry drift")
    require(ledger["source_commit"] == p["source_commit"], "Ledger source commit mismatch")
    chosen, seen = {0: [], 7: []}, set()
    require(len(ledger["candidates"]) == 31, "Incomplete31-candidate order ledger")
    for row in ledger["candidates"]:
        seed = row["seed"]
        require(type(seed) is int and 0 <= seed < 1 << 64 and seed not in seen and seed != 42,
                "Invalid/repeated fresh seed candidate")
        seen.add(seed)
        order = expected_order(reg, names, 65536, 1 << 22, seed, 50)
        position = order.index(MUL)
        take = position in chosen and len(chosen[position]) < 3
        require(row["order"] == order and row["multiply_position"] == position and row["selected"] is take,
                "Ledger is not the first3 per source-derived order stratum")
        if take:
            chosen[position].append(seed)
    seeds = [chosen[position][i] for i in range(3) for position in (0, 7)]
    require(p["seeds"] == ledger["selected_seeds"] == seeds and len(set(seeds)) == 6,
            "Wrong fixed six fresh seeds")
    cases = []
    batches = [1, 31, 4096]
    for i, seed in enumerate(seeds):
        rotated = batches[i % 3:] + batches[:i % 3]
        for batch in rotated:
            cases.append(dict(key_power=16, budget_bpk=16, batch=batch, seed=seed,
                              multiply_position=0 if i % 2 == 0 else 7, filters=names))
    require(p["cases"] == cases, "Changed case order/batch rotations")
    return reg


def command(p, case):
    return [p["binary"], "16", "16", "50", "22", str(case["batch"]), "6",
            str(case["seed"]), ",".join(case["filters"]), "65536", "24", "query-only", "0"]


def raw_fields():
    with (PARENT / "screen/results.csv").open(newline="") as stream:
        columns = next(csv.reader(stream))
    require(columns[-2:] == ["configuration_id", "calibration_identity"], "Wrong retained CSV schema")
    return columns[:-2]


def parse_raw(data):
    reader = csv.DictReader(io.StringIO(data.decode()))
    require(reader.fieldnames == raw_fields(), "Raw CSV columns differ from frozen producer")
    return list(reader)


def validate_case(rows, p, case, reg):
    expected = {r["filter"]: r for r in p["configurations"]}
    validate(rows, expected, power=16, budget=16, query_power=22, batch=case["batch"],
             repeats=6, seed=case["seed"], calibration_power=24)
    names = expected_order(reg, case["filters"], 65536, 1 << 22, case["seed"], 50)
    require([r["filter"] for r in rows] == names and names[case["multiply_position"]] == MUL,
            "Wrong source-derived raw order/candidate position")
    annotated = []
    for row in rows:
        for metric in ("lookup", "hash_lookup"):
            require(all(type(value) in (int, float) for value in json.loads(row[metric + "_trials_ns"])),
                    "Boolean or nonnumeric timing trial")
        c = expected[row["filter"]]
        annotated.append(dict(row, configuration_id=c["configuration_id"],
                              calibration_identity=c["calibration_identity"]))
    return annotated


def wilson(fp, n):
    require(type(fp) is int and type(n) is int and n > 0 and 0 <= fp <= n, "Invalid quality sample")
    z = 1.959963984540054
    phat, z2 = fp / n, z * z
    denominator = 1 + z2 / n
    center = (phat + z2 / (2 * n)) / denominator
    half = z * math.sqrt(phat * (1 - phat) / n + z2 / (4 * n * n)) / denominator
    return (0.0 if fp == 0 else max(0.0, center - half),
            1.0 if fp == n else min(1.0, center + half))


def quality(rows, p):
    """Each mapping/seed sample once; three batches and public aliases never pool."""
    require(len(rows) == 144, "Quality requires the complete144 rows")
    by_api, by_mapping = {}, {}
    configs = {c["filter"]: c for c in p["configurations"]}
    for row in rows:
        seed, batch = int(row["seed"]), int(row["batch"])
        require(seed in p["seeds"] and batch in (1, 31, 4096) and row["filter"] in configs,
                "Unexpected sample identity")
        c = configs[row["filter"]]
        require(row["configuration_id"] == c["configuration_id"] and row["calibration_identity"] == c["calibration_identity"],
                "Mislabelled quality identity")
        sample = tuple(row[field] for field in SEMANTICS)
        api_key = (row["filter"], seed)
        entry = by_api.setdefault(api_key, dict(sample=sample, batches=set()))
        require(entry["sample"] == sample and batch not in entry["batches"], "Duplicate batch or cross-batch semantic drift")
        entry["batches"].add(batch)
        key = (c["calibration_identity"], seed)
        group = by_mapping.setdefault(key, dict(sample=sample, apis=set()))
        require(group["sample"] == sample, "Equivalent public APIs disagree on full checksum/calibration")
        group["apis"].add(row["filter"])
    require(len(by_api) == 48 and all(v["batches"] == {1, 31, 4096} for v in by_api.values()), "Incomplete48 API/seed records")
    require(len(by_mapping) == 36, "Expected36 unique mapping/seed records")
    api_records, mapping_records = [], []
    for (name, seed), entry in sorted(by_api.items()):
        values = dict(zip(SEMANTICS, entry["sample"]))
        fp, n = int(values["calibration_false_positives"]), int(values["calibration_absent_queries"])
        low, high = wilson(fp, n)
        api_records.append(dict(filter=name, seed=seed, calibration_identity=configs[name]["calibration_identity"],
                                false_positives=fp, negatives=n, wilson95_low=low, wilson95_high=high,
                                current_pass=high <= p["target_fpr"], historically_failed_diagnostic=name == FOUR))
    for (identity, seed), entry in sorted(by_mapping.items()):
        values = dict(zip(SEMANTICS, entry["sample"]))
        fp, n = int(values["calibration_false_positives"]), int(values["calibration_absent_queries"])
        low, high = wilson(fp, n)
        mapping_records.append(dict(calibration_identity=identity, seed=seed, apis=sorted(entry["apis"]),
                                    false_positives=fp, negatives=n, wilson95_low=low, wilson95_high=high))
    robust = []
    for name in configs:
        records = [r for r in api_records if r["filter"] == name]
        require(len(records) == 6, "Robust gate needs every fixed seed")
        all_pass = all(r["current_pass"] for r in records)
        robust.append(dict(filter=name, all_fresh_seeds_pass=all_pass,
                           main_competitive_eligible=all_pass,
                           historically_failed_diagnostic=name == FOUR,
                           robust_eligible=all_pass and name != FOUR,
                           worst_wilson95_high=max(r["wilson95_high"] for r in records)))
    return dict(scope="Unpooled two-sided95% Wilson calibration; passing these six conditioned seeds is not a universal guarantee",
                ranking_policy="Main competitive ranking must include every API with all_fresh_seeds_pass=true, including FourSector; report per-seed current eligibility and the original restricted subset separately",
                restricted_gate_scope="robust_eligible is only the preregistered restricted set, not an overall competitive eligibility claim; the passing FourSector precision audit is separate pre-confirmation context",
                api_seed_records=api_records, mapping_seed_records=mapping_records, across_seed_gate=robust)


def validate_matrix(rows, p, reg):
    require(len(rows) == p["expected_rows"], "Incomplete144-row matrix")
    for i, case in enumerate(p["cases"]):
        part = rows[i * 8:(i + 1) * 8]
        require(validate_case(part, p, case, reg) == part, "Aggregate annotations/identity differ")
    return quality(rows, p)
