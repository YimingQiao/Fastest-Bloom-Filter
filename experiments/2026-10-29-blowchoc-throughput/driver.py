"""Query-only whole-array comparison; unchanged frozen native/Numba adapters."""
import gc
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import statistics
import sys
import weakref

ROOT = Path(__file__).resolve().parents[2]
BRIDGE = ROOT / "benchmarks/blowchoc-external"
sys.path.insert(0, str(BRIDGE))
import numpy as np
import bridge
import run as frozen_bridge_runner
from workload import checksum, generate

spec = importlib.util.spec_from_file_location(
    "heldout_oracle_helpers", ROOT / "experiments/2026-10-29-blowchoc-heldout-accuracy/run_matrix.py")
oracle_helpers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(oracle_helpers)


def make_factories(case, configs):
    factories, expected = {}, {}
    sample_insert, sample_query = oracle_helpers.preflight_inputs()
    for config in configs:
        if config["family"] != "blowchoc":
            continue
        name = config["filter"]
        factory = bridge.BlowChocFactory(case["keys"], case["requested_bpk"], config["choices"],
                                         config["probes"], config["version"], 113)
        if json.loads(json.dumps(factory.spec)) != case["constructions"][name]:
            raise RuntimeError("construction hashes differ from prespecified values")
        expected[name] = oracle_helpers.oracle_preflight(factory, sample_insert, sample_query)
        factories[name] = factory
    records = []
    for name, factory in factories.items():
        answer, bitmap_hash = expected[name]
        oracle_helpers.repeat_after_factory_overwrites(factory, sample_insert, sample_query, answer, bitmap_hash)
        records.append(dict(filter=name, bitmap_sha256=bitmap_hash, query_checksum=int(checksum(answer)),
                            keys=len(sample_insert), queries=len(sample_query)))
    return factories, records


def workload(case, protocol):
    raw_insert, raw_query, base = generate(case["keys"], case["queries"], protocol["hit_percent"], np.uint64(case["seed"]))
    if int(base) != case["key_base"]:
        raise RuntimeError("wrong raw input interval")
    return raw_insert, raw_query, frozen_bridge_runner.hashes(raw_insert), frozen_bridge_runner.hashes(raw_query), int(base)


def run_one(name, allocate, factory, case, protocol, inputs, measure):
    raw_insert, raw_query, inserted, query, base = inputs
    n, q, batch = len(inserted), len(query), protocol["batch"]
    guard = np.full(q + 16, 0x5a5a5a5a, dtype=np.uint32)
    output = guard[8:-8]
    scratch = np.empty(batch, dtype=np.uint64)
    validation_output = np.empty(batch, dtype=np.uint32)
    empty = np.empty(0, dtype=np.uint32)
    orders = list(itertools.permutations(bridge.MODES))
    if protocol["repeats"] != len(orders):
        raise RuntimeError("query phases require all six permutations exactly once")
    owner_refs, operations = [], {}
    filter_ = allocate()
    if factory:
        owner_refs = [weakref.ref(filter_.bitmap), weakref.ref(bridge.backing_array(filter_.bitmap))]
    try:
        # Exactly one canonical construction, not measured. No old build metric
        # is fabricated from this operation or combined with allocation time.
        operation = filter_.prepare(False, "prehashed", inserted, empty, batch, scratch)
        operation.execute()
        del operation
        frozen_bridge_runner.validate_inserted(filter_, inserted, batch, validation_output, scratch)
        filter_.prepare(True, "prehashed", query, output, batch, scratch).execute()
        reference = output.copy()
        present = (raw_query >= base) & (raw_query < base + n)
        if not np.all(reference[present] == 1) or not np.all(reference <= 1):
            raise RuntimeError("invalid canonical query result")
        operations = {mode: filter_.prepare(True, mode, query if mode == "prehashed" else raw_query,
                                            output, batch, scratch) for mode in bridge.MODES}
        for operation in operations.values():
            operation.execute()
            frozen_bridge_runner.consume(output, reference, guard)
        trials = []
        for trial, order in enumerate(orders):
            for position, mode in enumerate(order):
                if measure:
                    elapsed = frozen_bridge_runner.call_timed(operations[mode])
                else:
                    operations[mode].execute()
                    elapsed = None
                observed = frozen_bridge_runner.consume(output, reference, guard)
                trials.append(dict(trial=trial, position=position, mode=mode,
                                   elapsed_ns=elapsed, result_checksum=observed))
        # Independent disjoint stream only after all query phases, using the
        # same prehashed public API; no full calibration array is retained.
        cal_base, cal_end = case["calibration_raw_interval"]
        cal_count, cal_fp = cal_end - cal_base, 0
        for begin in range(0, cal_count, batch):
            length = min(batch, cal_count - begin)
            raw = np.arange(cal_base + begin, cal_base + begin + length, dtype=np.uint64)
            prepared = frozen_bridge_runner.hashes(raw)
            answer = validation_output[:length]
            filter_.prepare(True, "prehashed", prepared, answer, batch, scratch).execute()
            if not np.all(answer <= 1):
                raise RuntimeError("invalid calibration output")
            cal_fp += int(answer.sum())
        row = dict(filter=name, language="numba" if factory else "cpp", keys=n, queries=q,
                   requested_bpk=case["requested_bpk"], actual_bpk=8 * filter_.bytes / n,
                   filter_bytes=filter_.bytes, logical_bitmap_bytes=factory.logical_bytes if factory else filter_.bytes,
                   positions_scratch_bytes=factory.spec["nbits"] * 2 if factory else 0,
                   harness_hash_scratch_bytes=scratch.nbytes, batch=batch, seed=case["seed"],
                   construction_seed=113 if factory else None, construction_seed_used=factory is not None,
                   hit_percent=protocol["hit_percent"], repeats=protocol["repeats"],
                   query_repeats=protocol["repeats"], build_repeats=0,
                   present_queries=int(present.sum()), absent_queries=int((~present).sum()),
                   false_positives=int(reference[~present].sum()), result_checksum=int(checksum(reference)),
                   calibration_absent_queries=cal_count, calibration_false_positives=cal_fp,
                   calibration_raw_interval=case["calibration_raw_interval"],
                   query_trials=trials, phase_orders=orders, throughput_enabled=measure,
                   build_mode="query_only_one_unmeasured_prehashed_build",
                   insert_ns=None, allocate_insert_ns=None, hash_insert_ns=None, allocate_hash_insert_ns=None,
                   input_mode="common64", api_track="compiled-visible-scalar-whole-array")
        if factory:
            row.update(spec=factory.spec, cold_compile_ns=factory.cold_compile_ns,
                       warmup_bitmap_released=factory.warmup_released, jit_signatures=factory.signatures)
        row["query_ns_per_key"] = {mode: (statistics.median(
            sample["elapsed_ns"] for sample in trials if sample["mode"] == mode) / q if measure else None)
            for mode in bridge.MODES}
        if row["filter_bytes"] != case["payload_bytes"]:
            raise RuntimeError("actual backing allocation differs from budget")
    finally:
        # close() invalidates every prepared operation, releases argument arrays
        # symmetrically and prevents any later call from dereferencing a handle.
        filter_.close()
        operations.clear()
        del filter_
        gc.collect()
        if any(reference() is not None for reference in owner_refs):
            raise RuntimeError("query bitmap remains live before the next configuration")
    return row
