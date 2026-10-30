"""Explicit opt-in throughput driver; default execution is accuracy-only.

The three API contracts are never merged into one timing/ranking column. Both
languages cross Python once per full operation. Source/JIT work is outside
steady-state measurements and saved in the JSON record.
"""
import argparse
import hashlib
import itertools
import json
import os
from pathlib import Path
import platform
import random
import statistics
import sys
import time
import gc
import weakref

import llvmlite
import llvmlite.binding
import numba
import numpy as np

from bridge import BlowChocFactory, MODES, NATIVE_NAMES, NativeLibrary, backing_array, hash_array
from check_bridge import verify_sources
from oracle import payload_budget
from workload import checksum, generate


def hashes(raw):
    values = np.empty(len(raw), dtype=np.uint64)
    hash_array(raw, values)
    return values


def call_timed(op):
    # Pointer conversion, dtype/shape checks, argument tuple creation, exception
    # validation and output consumption all occur outside this interval.
    start = time.perf_counter_ns()
    status = op.call(*op.args)
    elapsed = time.perf_counter_ns() - start
    op.check(status)
    return elapsed


def consume(output, reference, guard):
    if not np.array_equal(output, reference):
        raise RuntimeError("complete query output mismatch")
    if not np.all(guard[:8] == 0x5a5a5a5a) or not np.all(guard[-8:] == 0x5a5a5a5a):
        raise RuntimeError("dense output guard modified")
    return int(checksum(output))


def validate_inserted(filter_, inserted, batch, output, scratch):
    for begin in range(0, len(inserted), batch):
        keys = inserted[begin:begin + batch]
        result = output[:len(keys)]
        filter_.prepare(True, "prehashed", keys, result, batch, scratch).execute()
        if not np.all(result == 1):
            raise RuntimeError("false negative in complete inserted set")


def run_one(name, allocate, factory, args, raw_insert, raw_query, inserted, query, base):
    n, q = len(inserted), len(query)
    guard = np.full(q + 16, 0x5a5a5a5a, dtype=np.uint32)
    # Same dense output and hash scratch allocations in both languages. The
    # staged path writes/reads scratch within each original batch boundary.
    output = guard[8:8 + q]
    validation_output = np.empty(args.batch, dtype=np.uint32)
    scratch = np.empty(args.batch, dtype=np.uint64)
    empty_output = np.empty(0, dtype=np.uint32)
    orders = tuple(itertools.permutations(MODES))
    build_trials, query_trials = [], []
    reference = None
    trial_count = args.repeats if args.measure else 1
    for trial in range(trial_count):
        for position, mode in enumerate(orders[trial % len(orders)]):
            started = time.perf_counter_ns()
            fresh = allocate()
            allocation_ns = time.perf_counter_ns() - started
            old_refs = ([weakref.ref(fresh.bitmap), weakref.ref(backing_array(fresh.bitmap))]
                        if factory else [])
            operation = None
            try:
                keys = inserted if mode == "prehashed" else raw_insert
                operation = fresh.prepare(False, mode, keys, empty_output, args.batch, scratch)
                if args.measure:
                    duration = call_timed(operation)
                else:
                    operation.execute()
                    duration = None
                # All keys in every build, including hash+build, outside timing.
                validate_inserted(fresh, inserted, args.batch, validation_output, scratch)
                fresh.prepare(True, "prehashed", query, output, args.batch, scratch).execute()
                if reference is None:
                    reference = output.copy()
                else:
                    consume(output, reference, guard)
                if args.measure:
                    build_trials.append(dict(trial=trial, position=position, mode=mode,
                                             allocation_ns=allocation_ns, insert_ns=duration))
            finally:
                # Operations retain arguments, so release before the next build.
                del operation
                fresh.close()
                del fresh
                gc.collect()
                if any(ref() is not None for ref in old_refs):
                    raise RuntimeError("previous build bitmap remains live before next allocation")
    with allocate() as filter_:
        filter_.prepare(False, "prehashed", inserted, empty_output, args.batch, scratch).execute()
        validate_inserted(filter_, inserted, args.batch, validation_output, scratch)
        prepared = {mode: filter_.prepare(True, mode, query if mode == "prehashed" else raw_query,
                                          output, args.batch, scratch) for mode in MODES}
        for operation in prepared.values():
            operation.execute()
            consume(output, reference, guard)
        if args.measure:
            for trial in range(args.repeats):
                for position, mode in enumerate(orders[trial % len(orders)]):
                    duration = call_timed(prepared[mode])
                    result_checksum = consume(output, reference, guard)
                    query_trials.append(dict(trial=trial, position=position, mode=mode,
                                             query_ns=duration, result_checksum=result_checksum))
        present = (raw_query >= base) & (raw_query < base + n)
        if not np.all(reference[present] == 1) or not np.all(reference <= 1):
            raise RuntimeError("invalid mixed-workload output")
        calibration_count = (1 << args.calibration_power) if args.calibration_power else 0
        calibration_fp = 0
        calibration_base = int(base) + n + q
        for begin in range(0, calibration_count, args.batch):
            length = min(args.batch, calibration_count - begin)
            raw = np.arange(calibration_base + begin, calibration_base + begin + length, dtype=np.uint64)
            prepared_hash = hashes(raw)
            answer = validation_output[:length]
            filter_.prepare(True, "prehashed", prepared_hash, answer, args.batch, scratch).execute()
            if not np.all(answer <= 1):
                raise RuntimeError("invalid calibration output")
            calibration_fp += int(answer.sum())
        record = dict(filter=name, language="numba" if factory else "cpp", keys=n, queries=q,
                      requested_bpk=args.requested_bpk, filter_bytes=filter_.bytes,
                      actual_bpk=8 * filter_.bytes / n, batch=args.batch, seed=args.seed,
                      input_mode="common64", api_track="compiled-visible-scalar",
                      present_queries=int(present.sum()), absent_queries=int((~present).sum()),
                      false_positives=int(reference[~present].sum()),
                      result_checksum=int(checksum(reference)),
                      calibration_absent_queries=calibration_count,
                      calibration_false_positives=calibration_fp,
                      calibration_raw_interval=[calibration_base, calibration_base + calibration_count],
                      build_trials=build_trials, query_trials=query_trials,
                      filter_positions_scratch_bytes=0 if not factory else factory.spec["nbits"] * 2,
                      harness_hash_scratch_bytes=scratch.nbytes,
                      logical_bitmap_bytes=filter_.bytes if not factory else factory.logical_bytes)
        if factory:
            record.update(spec=factory.spec, cold_compile_ns=factory.cold_compile_ns,
                          warmup_bitmap_released=factory.warmup_released,
                          jit_signatures=factory.signatures)
        if args.measure:
            record["medians_ns_per_key"] = {mode: {
                "insert": statistics.median(row["insert_ns"] for row in build_trials if row["mode"] == mode) / n,
                "query": statistics.median(row["query_ns"] for row in query_trials if row["mode"] == mode) / q,
            } for mode in MODES}
        return record


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--key-power", type=int, default=10)
    parser.add_argument("--query-power", type=int, default=14)
    parser.add_argument("--requested-bpk", type=int, default=8)
    parser.add_argument("--batch", type=int, default=4096)
    parser.add_argument("--hit", type=int, default=50)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--construction-seed", type=int, default=113)
    parser.add_argument("--probes", type=int, default=8)
    parser.add_argument("--repeats", type=int, default=6)
    parser.add_argument("--calibration-power", type=int, default=16)
    parser.add_argument("--filters", default=None)
    parser.add_argument("--measure", action="store_true", help="explicitly enable throughput trials")
    args = parser.parse_args()
    if not 0 <= args.key_power <= 27 or not 0 <= args.query_power <= 27 or not 0 <= args.hit <= 100:
        parser.error("invalid workload range")
    if not 1 <= args.batch <= (1 << 27) or not 1 <= args.repeats <= 120 or not 1 <= args.probes <= 64:
        parser.error("invalid batch, repeat or probe count")
    if args.calibration_power != 0 and not 12 <= args.calibration_power <= 27:
        parser.error("calibration power must be zero or 12..27")
    if not 0 <= args.seed < 1 << 64 or not 0 <= args.construction_seed < 1 << 64:
        parser.error("seeds must fit unsigned 64 bits")
    if args.measure and args.repeats % 6:
        parser.error("timing repeats must be a multiple of six for all phase-order permutations")
    try:
        payload_budget(1 << args.key_power, args.requested_bpk)
    except ValueError as error:
        parser.error(str(error))
    configs = {f"BlowChocC{c}K{args.probes}{v.title()}": (c, v) for c in (1, 2) for v in ("random", "distinct")}
    if args.filters is None:
        args.filters = ",".join((*NATIVE_NAMES, *configs))
    selected = args.filters.split(",")
    if len(set(selected)) != len(selected) or any(name not in (*NATIVE_NAMES, *configs) for name in selected):
        parser.error("unknown, empty or duplicate exact filter name")
    return args, configs, selected


def main():
    args, configs, selected = parse_args()
    verify_sources()
    native_sha256 = hashlib.sha256(args.native.read_bytes()).hexdigest()
    root = Path(__file__).resolve().parent
    # Results and documentation are not compiler inputs. Explicit roots avoid
    # self-referential hashes when validation reports live beside the sources.
    source_files = [path for path in root.iterdir() if path.is_file() and
                    (path.suffix in (".py", ".cpp") or path.name in
                     ("CMakeLists.txt", "requirements.txt", "upstream.json", "native-snapshot.json"))]
    for subtree in ("vendor", "snapshot"):
        source_files.extend(path for path in (root / subtree).rglob("*") if path.is_file()
                            and "__pycache__" not in path.parts and path.suffix not in (".nbc", ".nbi"))
    source_hashes = {str(path.relative_to(root)): hashlib.sha256(path.read_bytes()).hexdigest()
                     for path in sorted(source_files)}
    raw_insert, raw_query, base = generate(1 << args.key_power, 1 << args.query_power, args.hit, np.uint64(args.seed))
    inserted, query = hashes(raw_insert), hashes(raw_query)
    checksum(np.zeros(1, dtype=np.uint32))  # compile consumption outside any timer
    library = NativeLibrary(args.native)
    random.Random(args.seed ^ 0x6942a15).shuffle(selected)
    records = []
    for name in selected:
        if name in NATIVE_NAMES:
            factory = None
            allocate = lambda name=name: library.allocate(name, len(inserted), args.requested_bpk)
        else:
            choices, version = configs[name]
            factory = BlowChocFactory(len(inserted), args.requested_bpk, choices, args.probes,
                                      version, args.construction_seed)
            allocate = factory.allocate
        records.append(run_one(name, allocate, factory, args, raw_insert, raw_query, inserted, query, int(base)))
        print(f"validated {name}", file=sys.stderr, flush=True)
    for name, expected in source_hashes.items():
        if hashlib.sha256((root / name).read_bytes()).hexdigest() != expected:
            raise RuntimeError("source changed during run: " + name)
    if hashlib.sha256(args.native.read_bytes()).hexdigest() != native_sha256:
        raise RuntimeError("native library changed during run")
    metadata = dict(arguments={key: str(value) if isinstance(value, Path) else value for key, value in vars(args).items()},
                    python=sys.version, numpy=np.__version__, numba=numba.__version__, llvmlite=llvmlite.__version__,
                    platform=platform.platform(), affinity=sorted(os.sched_getaffinity(0)),
                    jit_host_cpu=str(llvmlite.binding.get_host_cpu_name()),
                    jit_host_features=llvmlite.binding.get_host_cpu_features().flatten(),
                    llvm_version=list(llvmlite.binding.llvm_version_info),
                    numba_cpu_name=os.environ.get("NUMBA_CPU_NAME"),
                    numba_cpu_features=os.environ.get("NUMBA_CPU_FEATURES"),
                    native_library_sha256=native_sha256,
                    source_sha256=source_hashes,
                    input_sha256={"raw_insert": hashlib.sha256(raw_insert.tobytes()).hexdigest(),
                                  "raw_query": hashlib.sha256(raw_query.tobytes()).hexdigest()},
                    key_base=int(base), throughput_enabled=args.measure,
                    phase_orders=list(itertools.permutations(MODES)))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(dict(metadata=metadata, records=records), indent=2) + "\n")


if __name__ == "__main__":
    main()
