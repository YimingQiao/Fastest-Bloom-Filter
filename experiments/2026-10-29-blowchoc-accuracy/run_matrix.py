"""Run the frozen accuracy protocol; never invokes throughput timing."""
import gc
from datetime import datetime, timezone
import hashlib
import json
import math
import os
from pathlib import Path
import platform
import random
import sys
import time
from types import SimpleNamespace

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BRIDGE = ROOT / "benchmarks/blowchoc-external"
sys.path.insert(0, str(BRIDGE))
import llvmlite
import llvmlite.binding
import numba
import numpy as np
import bridge
import oracle
import run as frozen_runner
from workload import generate, checksum


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_freeze(protocol):
    if not protocol["bridge_commit"]:
        raise RuntimeError("bridge source commit must be recorded before execution")
    if digest(BRIDGE / "FREEZE.json") != protocol["bridge_freeze_sha256"]:
        raise RuntimeError("bridge freeze changed")
    freeze = json.loads((BRIDGE / "FREEZE.json").read_text())
    for name, record in freeze["files"].items():
        if digest(BRIDGE / name) != record["sha256"]:
            raise RuntimeError("frozen bridge file changed: " + name)
    if digest(ROOT / protocol["native_library"]) != protocol["native_library_sha256"]:
        raise RuntimeError("frozen native library changed")


def runtime():
    return dict(python=sys.version, numpy=np.__version__, numba=numba.__version__,
                llvmlite=llvmlite.__version__, jit_host_cpu=str(llvmlite.binding.get_host_cpu_name()),
                jit_host_features=llvmlite.binding.get_host_cpu_features().flatten(),
                llvm_version=list(llvmlite.binding.llvm_version_info),
                numba_cpu_name=os.environ.get("NUMBA_CPU_NAME"),
                numba_cpu_features=os.environ.get("NUMBA_CPU_FEATURES"))


def preflight_inputs():
    raw = np.concatenate((np.arange(256, dtype=np.uint64),
                          np.array([0, 1, 1 << 63, (1 << 64) - 1, (1 << 32) - 1, 1 << 32], dtype=np.uint64)))
    hashed = frozen_runner.hashes(raw)
    inserted = np.concatenate((hashed, hashed[:31]))
    queries = np.concatenate((inserted, frozen_runner.hashes(np.arange(100000, 101024, dtype=np.uint64))))
    return inserted, queries


def oracle_preflight(factory, inserted, query):
    spec = factory.spec
    reference = np.zeros(factory.logical_bytes // 8, dtype=np.uint64)
    for value in inserted:
        oracle.insert(reference, spec, value)
    expected = np.array([oracle.lookup(reference, spec, value) for value in query], dtype=np.uint32)
    result = np.empty(len(query), dtype=np.uint32)
    scratch = np.empty(31, dtype=np.uint64)
    with factory.allocate() as filter_:
        filter_.prepare(False, "prehashed", inserted, np.empty(0, dtype=np.uint32), 31, scratch).execute()
        if not np.array_equal(filter_.bitmap, reference):
            raise RuntimeError("full bitmap oracle mismatch: " + factory.name)
        filter_.prepare(True, "prehashed", query, result, 31, scratch).execute()
        if not np.array_equal(result, expected) or not np.all(result[:len(inserted)] == 1):
            raise RuntimeError("full query oracle mismatch: " + factory.name)
        bitmap_hash = hashlib.sha256(filter_.bitmap.tobytes()).hexdigest()
    return expected, bitmap_hash


def repeat_after_factory_overwrites(factory, inserted, query, expected, bitmap_hash):
    result = np.empty(len(query), dtype=np.uint32)
    scratch = np.empty(31, dtype=np.uint64)
    with factory.allocate() as filter_:
        filter_.prepare(False, "prehashed", inserted, np.empty(0, dtype=np.uint32), 31, scratch).execute()
        if hashlib.sha256(filter_.bitmap.tobytes()).hexdigest() != bitmap_hash:
            raise RuntimeError("later factory changed earlier insertion mapping")
        filter_.prepare(True, "prehashed", query, result, 31, scratch).execute()
        if not np.array_equal(result, expected):
            raise RuntimeError("later factory changed earlier query mapping")
    signatures = {str(key): tuple(map(str, fn.signatures)) for key, fn in factory.loops.items()}
    if signatures != factory.signatures:
        raise RuntimeError("unexpected JIT signature after factory overwrite")


def upper95(successes, count):
    z = 1.959963984540054
    rate = successes / count
    return (rate + z * z / (2 * count) + z * math.sqrt(rate * (1 - rate) / count + z * z / (4 * count * count))) / (1 + z * z / count)


def main():
    protocol_path = HERE / "protocol.json"
    protocol = json.loads(protocol_path.read_text())
    if protocol["measure"] or protocol["expected_rows"] != 48:
        raise RuntimeError("unexpected protocol scope")
    if sorted(os.sched_getaffinity(0)) != [protocol["cpu"]]:
        raise RuntimeError("run with taskset -c 3 under the socket1 flock")
    verify_freeze(protocol)
    observed_runtime = runtime()
    if observed_runtime != protocol["expected_runtime"]:
        raise RuntimeError("Python/JIT versions or CPU features differ from the frozen protocol")
    source_files = [path for path in HERE.iterdir() if path.is_file() and path.suffix in (".py", ".json") and path.name != "FREEZE.json"]
    source_hashes = {path.name: digest(path) for path in source_files}
    output_dir = HERE / "results"
    if output_dir.exists():
        raise RuntimeError("results directory already exists; preserve previous evidence")
    output_dir.mkdir()
    run_started_utc = datetime.now(timezone.utc).isoformat()
    (output_dir / "run-start.json").write_text(json.dumps(dict(
        started_utc=run_started_utc, protocol_sha256=digest(protocol_path),
        matrix_source_sha256=source_hashes, runtime=observed_runtime,
        affinity=sorted(os.sched_getaffinity(0)), throughput_enabled=False), indent=2) + "\n")
    native = bridge.NativeLibrary(ROOT / protocol["native_library"])
    checksum(np.zeros(1, dtype=np.uint32))
    sample_insert, sample_query = preflight_inputs()
    all_rows, preflight_records = [], []
    started = time.monotonic()
    for case_index, case in enumerate(protocol["cases"]):
        factories, preflight_expected = {}, {}
        # All parameter sets and oracle checks finish before recording this
        # case's accuracy; no FPR result can influence construction parameters.
        for config in protocol["configs"]:
            if config["family"] != "blowchoc":
                continue
            name = config["filter"]
            factory = bridge.BlowChocFactory(case["keys"], case["requested_bpk"], config["choices"],
                                             config["probes"], config["version"], case["construction_seed"])
            if json.loads(json.dumps(factory.spec)) != case["constructions"][name]:
                raise RuntimeError("factory hashes differ from prespecified strings: " + name)
            expected, bitmap_hash = oracle_preflight(factory, sample_insert, sample_query)
            factories[name] = factory
            preflight_expected[name] = expected, bitmap_hash
        for name, factory in factories.items():
            expected, bitmap_hash = preflight_expected[name]
            repeat_after_factory_overwrites(factory, sample_insert, sample_query, expected, bitmap_hash)
            preflight_records.append(dict(case=case["id"], filter=name, bitmap_sha256=bitmap_hash,
                                          full_output_checksum=int(checksum(expected)),
                                          oracle_keys=len(sample_insert), oracle_queries=len(sample_query)))
        raw_insert, raw_query, base = generate(case["keys"], case["queries"], protocol["hit_percent"], np.uint64(case["seed"]))
        if int(base) != case["key_base"]:
            raise RuntimeError("input base differs from prespecified disjoint intervals")
        inserted, query = frozen_runner.hashes(raw_insert), frozen_runner.hashes(raw_query)
        args = SimpleNamespace(batch=protocol["batch"], repeats=1, measure=False,
                               requested_bpk=case["requested_bpk"], seed=case["seed"],
                               calibration_power=protocol["calibration_power"])
        ordered = list(protocol["configs"])
        random.Random(42 ^ (case_index + 1) * 0x6942a15).shuffle(ordered)
        case_rows = []
        for config in ordered:
            name = config["filter"]
            factory = factories.get(name)
            allocate = factory.allocate if factory else lambda name=name: native.allocate(name, case["keys"], case["requested_bpk"])
            row = frozen_runner.run_one(name, allocate, factory, args, raw_insert, raw_query, inserted, query, int(base))
            if row["build_trials"] or row["query_trials"] or row["filter_bytes"] != case["payload_bytes"]:
                raise RuntimeError("timing or allocation contract violation")
            if row["calibration_raw_interval"] != case["calibration_raw_interval"] or row["calibration_absent_queries"] != 1 << 24:
                raise RuntimeError("calibration stream differs from protocol")
            row["case"] = case["id"]
            row["calibration_wilson95_upper"] = upper95(row["calibration_false_positives"], row["calibration_absent_queries"])
            case_rows.append(row)
            print(f"validated {case['id']} {name}", flush=True)
        all_rows.extend(case_rows)
        payload = dict(case=case, records=case_rows,
                       input_sha256={"raw_insert": hashlib.sha256(raw_insert.tobytes()).hexdigest(),
                                     "raw_query": hashlib.sha256(raw_query.tobytes()).hexdigest()})
        (output_dir / f"{case['id']}.json").write_text(json.dumps(payload, indent=2) + "\n")
        del allocate, factory, factories, preflight_expected, inserted, query, raw_insert, raw_query
        gc.collect()
    if len(all_rows) != protocol["expected_rows"]:
        raise RuntimeError("incomplete matrix")
    verify_freeze(protocol)
    for name, expected in source_hashes.items():
        if digest(HERE / name) != expected:
            raise RuntimeError("matrix source/protocol changed: " + name)
    report = dict(protocol_sha256=digest(protocol_path), matrix_source_sha256=source_hashes,
                  started_utc=run_started_utc, completed_utc=datetime.now(timezone.utc).isoformat(),
                  runtime=observed_runtime, affinity=sorted(os.sched_getaffinity(0)), platform=platform.platform(),
                  bridge_freeze_sha256=protocol["bridge_freeze_sha256"], native_library_sha256=protocol["native_library_sha256"],
                  elapsed_seconds=time.monotonic() - started, preflights=preflight_records, records=all_rows,
                  throughput_enabled=False, eligibility_scope="one prespecified input/construction seed; held-out accuracy still required")
    (output_dir / "results.json").write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
