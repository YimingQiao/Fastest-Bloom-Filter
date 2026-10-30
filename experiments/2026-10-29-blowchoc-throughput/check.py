"""Correctness-only query driver preflight; never enters a timing call."""
import copy
import hashlib
import json
from pathlib import Path
from types import SimpleNamespace

import driver
import guard
from prepare import cases

HERE = Path(__file__).resolve().parent


def main():
    protocol = json.loads((HERE / "protocol.json").read_text())
    driver.oracle_helpers.verify_freeze(json.loads((driver.oracle_helpers.HERE / "protocol.json").read_text()))
    library = driver.bridge.NativeLibrary(driver.ROOT / protocol["native_library"])
    rows, preflights = [], []
    for case in cases((10,), (8, 16), 12, 12):
        inputs = driver.workload(case, protocol)
        factories, checks = driver.make_factories(case, protocol["configs"])
        preflights.extend(checks)
        for config in protocol["configs"]:
            name = config["filter"]
            factory = factories.get(name)
            allocate = factory.allocate if factory else lambda name=name: library.allocate(name, case["keys"], case["requested_bpk"])
            row = driver.run_one(name, allocate, factory, case, protocol, inputs, measure=False)
            # JSON normalizes tuples exactly as persisted result artifacts do.
            row = json.loads(json.dumps(row, allow_nan=False))
            guard.validate(row, config, case, protocol, False)
            args = SimpleNamespace(batch=protocol["batch"], repeats=1, measure=False,
                                   requested_bpk=case["requested_bpk"], seed=42, calibration_power=12)
            raw_insert, raw_query, inserted, query, base = inputs
            old = driver.frozen_bridge_runner.run_one(name, allocate, factory, args, raw_insert, raw_query, inserted, query, base)
            for field in ("filter_bytes", "actual_bpk", "logical_bitmap_bytes", "result_checksum", "present_queries",
                          "absent_queries", "false_positives", "calibration_absent_queries", "calibration_false_positives",
                          "calibration_raw_interval"):
                if row[field] != old[field]:
                    raise RuntimeError("new query-only driver changed frozen behavior: " + field)
            rows.append(row)
            print("validated", case["id"], name, flush=True)
    mutations = []
    original = rows[0]
    sample_case = cases((10,), (8, 16), 12, 12)[0]
    config = protocol["configs"][0]
    bad = copy.deepcopy(original); bad["query_trials"][0]["mode"] = "common-fused"; mutations.append(bad)
    bad = copy.deepcopy(original); bad["query_trials"][1] = copy.deepcopy(bad["query_trials"][0]); mutations.append(bad)
    bad = copy.deepcopy(original); bad["query_trials"][0]["elapsed_ns"] = 1; mutations.append(bad)
    bad = copy.deepcopy(original); bad["query_trials"][-1]["result_checksum"] ^= 1; mutations.append(bad)
    bad = copy.deepcopy(original); bad["insert_ns"] = 1; mutations.append(bad)
    bad = copy.deepcopy(original); bad["calibration_absent_queries"] *= 2; mutations.append(bad)
    bad = copy.deepcopy(original); bad["calibration_raw_interval"][0] += 1; mutations.append(bad)
    bad = copy.deepcopy(original); bad["filter_bytes"] -= 448; mutations.append(bad)
    bad = copy.deepcopy(original); bad["query_repeats"] = 5; mutations.append(bad)
    bad = copy.deepcopy(original); bad["build_repeats"] = 1; mutations.append(bad)
    for bad in mutations:
        try:
            guard.validate(bad, config, sample_case, protocol, False)
        except ValueError:
            pass
        else:
            raise RuntimeError("malformed row was accepted")
    output = HERE / "validation"
    output.mkdir(exist_ok=True)
    (output / "preflight.json").write_text(json.dumps(dict(throughput_enabled=False, rows=rows,
        full_bitmap_preflights=preflights, rejected_mutations=len(mutations), frozen_reference_equal=True,
        native_library_sha256=hashlib.sha256((driver.ROOT / protocol["native_library"]).read_bytes()).hexdigest()), indent=2, allow_nan=False) + "\n")
    print("PASS:24 exact frozen-driver parity rows,16 full-bitmap/overwrite oracles,10 malformed-row rejections; no throughput trials")


if __name__ == "__main__":
    main()
