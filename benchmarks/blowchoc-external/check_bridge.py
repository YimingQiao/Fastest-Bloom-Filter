"""Correctness/lifetime checks only; this file does not benchmark throughput."""
import argparse
import ctypes as ct
import hashlib
import json
from pathlib import Path
import random
import weakref
import gc

import numpy as np

from bridge import (BlowChocFactory, MODES, NATIVE_NAMES, NativeLibrary,
                    backing_array, hash_array)
import oracle
from workload import generate


def hashed(raw):
    result = np.empty(len(raw), dtype=np.uint64)
    hash_array(raw, result)
    assert result.tolist() == [oracle.common_hash(x) for x in raw]
    return result


def query_checked(filter_, mode, keys, batch):
    guard = np.full(len(keys) + 10, 0x5a5a5a5a, dtype=np.uint32)
    output = guard[5:-5]
    scratch = np.zeros(min(batch, len(keys)), dtype=np.uint64)
    filter_.prepare(True, mode, keys, output, batch, scratch).execute()
    assert np.all(guard[:5] == 0x5a5a5a5a) and np.all(guard[-5:] == 0x5a5a5a5a)
    assert np.all(output <= 1)
    return output.copy()


def insert(filter_, mode, keys, batch):
    filter_.prepare(False, mode, keys, np.empty(0, dtype=np.uint32), batch,
                    np.empty(min(batch, len(keys)), dtype=np.uint64)).execute()


def rejected(fn):
    try:
        fn()
    except (ValueError, RuntimeError):
        return
    raise AssertionError("invalid operation was accepted")


def check_closed(filter_):
    keys = np.array([1], dtype=np.uint64)
    out = np.empty(1, dtype=np.uint32)
    scratch = np.empty(1, dtype=np.uint64)
    operation = filter_.prepare(True, "prehashed", keys, out, 1, scratch)
    references = []
    if hasattr(filter_, "bitmap"):
        references = [weakref.ref(filter_.bitmap), weakref.ref(backing_array(filter_.bitmap))]
    filter_.close()
    assert operation.args == ()
    rejected(operation.execute)
    rejected(lambda: operation.call(*operation.args))
    rejected(lambda: filter_.prepare(True, "prehashed", keys, out, 1, scratch))
    gc.collect()
    assert all(ref() is None for ref in references), "stale operation retained closed bitmap"


def verify_sources():
    root = Path(__file__).resolve().parent
    manifest = json.loads((root / "upstream.json").read_text())
    for name, record in manifest["files"].items():
        expected = record["sha256"] if isinstance(record, dict) else record
        assert hashlib.sha256((root / "vendor" / name).read_bytes()).hexdigest() == expected, name
    native = json.loads((root / "native-snapshot.json").read_text())
    for name, expected in native["files"].items():
        assert hashlib.sha256((root / "snapshot" / "include" / name).read_bytes()).hexdigest() == expected, name


def check_workload():
    # Python integer oracle, including exact RNG consumption by mixed hits.
    def reference(n, q, hit, seed):
        state = seed
        def next_random():
            nonlocal state
            state = (state + 0x9e3779b97f4a7c15) & oracle.MASK
            value = state
            value = ((value ^ (value >> 30)) * 0xbf58476d1ce4e5b9) & oracle.MASK
            value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & oracle.MASK
            return value ^ (value >> 31)
        base = next_random() % ((1 << 32) - n - q)
        inserted = list(range(base, base + n))
        for i in range(n, 1, -1):
            j = next_random() % i
            inserted[i - 1], inserted[j] = inserted[j], inserted[i - 1]
        query = [base + (next_random() % n if i % 100 < hit else n + i) for i in range(q)]
        for i in range(q, 1, -1):
            j = next_random() % i
            query[i - 1], query[j] = query[j], query[i - 1]
        return inserted, query, base
    for seed in (0, 42, 731, oracle.MASK):
        for hit in (0, 50, 100):
            expected = reference(131, 517, hit, seed)
            actual = generate(131, 517, hit, np.uint64(seed))
            assert actual[0].tolist() == expected[0]
            assert actual[1].tolist() == expected[1]
            assert int(actual[2]) == expected[2]


def check_blows():
    factories, records, full_answers = [], [], []
    edge = np.array([0, 1, 1 << 63, (1 << 64) - 1, (1 << 32) - 1, 1 << 32], dtype=np.uint64)
    raw = np.concatenate((edge, np.arange(1024, 1536, dtype=np.uint64)))
    input_hashes = hashed(raw)
    query_raw = np.concatenate((raw, np.arange(100000, 102049, dtype=np.uint64)))
    query_hashes = hashed(query_raw)
    # Deliberate duplicates, then enough skewed values to exercise candidate cost
    # selection. Their full bitmaps, not just aggregate positives, are checked.
    inserted = np.concatenate((input_hashes, input_hashes[:127], np.arange(200, dtype=np.uint64)))
    for choices, version in ((1, "random"), (2, "random"), (1, "distinct"), (2, "distinct")):
        before_rng = random.getstate()
        factory = BlowChocFactory(1024, 8, choices=choices, version=version)
        assert random.getstate() == before_rng
        assert factory.warmup_released
        assert factory.logical_bytes + 448 == factory.backing_bytes == 2048
        assert factory.descriptor.array is None and factory.descriptor.mem_bytes == 0
        assert factory.spec["nblocks_per_subfilter"] == 25
        check_closed(factory.allocate())
        factories.append(factory)
        spec = factory.spec
        pos = np.empty(spec["nbits"], dtype=np.uint16)
        for h in np.concatenate((edge, inserted[:64])):
            factory.descriptor.private.get_bit_positions(np.uint64(h), pos)
            assert pos.tolist() == oracle.positions(spec, h)
            assert int(factory.descriptor.private.get_subfilter(np.uint64(h))) == 0
            for c in range(choices):
                actual_block = int(factory.descriptor.private.get_block(c, np.uint64(h)))
                expected_block = oracle.blocks(spec, h)[c]
                assert actual_block == expected_block, (factory.name, spec["bucket_hashfuncs_str"], int(h), c,
                                                        actual_block, expected_block)
        reference = np.zeros(factory.logical_bytes // 8, dtype=np.uint64)
        for h in inserted:
            oracle.insert(reference, spec, h)
        expected = np.array([oracle.lookup(reference, spec, h) for h in query_hashes], dtype=np.uint32)
        full_answers.append(expected.copy())
        with factory.allocate() as f:
            assert f.bitmap.ctypes.data % 64 == 0 and backing_array(f.bitmap).nbytes == 2048
            insert(f, "prehashed", inserted, 31)
            assert np.array_equal(reference, f.bitmap)
            # Repeated insertion is idempotent, including duplicate positions.
            insert(f, "prehashed", inserted, 4096)
            assert np.array_equal(reference, f.bitmap)
            for batch in (1, 7, 31, 4096):
                for mode in MODES:
                    keys = query_hashes if mode == "prehashed" else query_raw
                    assert np.array_equal(expected, query_checked(f, mode, keys, batch))
            assert np.all(query_checked(f, "prehashed", inserted, 31) == 1)
            assert np.array_equal(reference, f.bitmap), "query mutated filter"
            for count in (0, 1, 2, 7, 8, 15, 31, 32, 63, 64, 131, 2049):
                for offset in (0, 1, 7):
                    storage = np.concatenate((np.zeros(offset, dtype=np.uint64), query_hashes[:count]))
                    assert np.array_equal(expected[:count], query_checked(f, "prehashed", storage[offset:], 31))
            out = np.empty(len(query_hashes), dtype=np.uint32)
            scratch = np.empty(31, dtype=np.uint64)
            rejected(lambda: f.prepare(True, "prehashed", query_hashes[::2], out, 31, scratch))
            rejected(lambda: f.prepare(True, "bogus", query_hashes, out, 31, scratch))
            rejected(lambda: f.prepare(True, "prehashed", query_hashes, out, 0, scratch))
            rejected(lambda: f.prepare(True, "common-staged", query_hashes, out, 32, scratch))
            rejected(lambda: f.prepare(True, "prehashed", query_hashes, out[:1], 31, scratch))
            rejected(lambda: f.prepare(True, "common-staged", query_hashes, out, 31, query_hashes[:31]))
        # Raw build bitmaps must exactly equal the prehashed build, including
        # order-dependent two-choice insertion; pure/hash lifetimes are disjoint.
        builds = []
        for mode in MODES:
            with factory.allocate() as f:
                insert(f, mode, input_hashes if mode == "prehashed" else raw, 31)
                builds.append(f.bitmap.copy())
                assert np.all(query_checked(f, "prehashed", input_hashes, 31) == 1)
        assert all(np.array_equal(builds[0], b) for b in builds[1:])
        records.append(dict(name=factory.name, spec=spec, actual_bytes=factory.backing_bytes,
                            logical_bytes=factory.logical_bytes, positions_bytes=spec["nbits"] * 2,
                            cold_compile_ns=factory.cold_compile_ns,
                            bitmap_sha256=hashlib.sha256(reference.tobytes()).hexdigest(),
                            positives=int(expected.sum()), queries=len(expected)))
    # Later factories replaced the upstream module globals. Every earlier
    # warmed signature must still use its own recorded functions for new builds.
    for factory, record, expected in zip(factories, records, full_answers):
        with factory.allocate() as f:
            insert(f, "prehashed", inserted, 31)
            assert hashlib.sha256(f.bitmap.tobytes()).hexdigest() == record["bitmap_sha256"]
            for mode in MODES:
                keys = query_hashes if mode == "prehashed" else query_raw
                assert np.array_equal(query_checked(f, mode, keys, 31), expected)
        assert {str(k): tuple(map(str, fn.signatures)) for k, fn in factory.loops.items()} == factory.signatures
    for keys, bpk in ((1, 1), (0, 8), (1, 0)):
        rejected(lambda: BlowChocFactory(keys, bpk))
    return records


def check_native(path):
    library = NativeLibrary(path)
    raw = np.arange(512, 1536, dtype=np.uint64)
    input_hashes = hashed(raw)
    query_raw = np.concatenate((raw, np.arange(100000, 104097, dtype=np.uint64)))
    query_hashes = hashed(query_raw)
    records = []
    for name in NATIVE_NAMES:
        for requested_bpk in (8, 16):
            check_closed(library.allocate(name, len(raw), requested_bpk))
            references = []
            for build_mode in MODES:
                with library.allocate(name, len(raw), requested_bpk) as f:
                    insert(f, build_mode, input_hashes if build_mode == "prehashed" else raw, 31)
                    expected = query_checked(f, "prehashed", query_hashes, 31)
                    references.append(expected)
                    assert np.all(query_checked(f, "prehashed", input_hashes, 31) == 1)
                    for mode in MODES:
                        keys = query_hashes if mode == "prehashed" else query_raw
                        for batch in (1, 7, 31, 4096):
                            assert np.array_equal(expected, query_checked(f, mode, keys, batch))
                    assert len(query_checked(f, "prehashed", np.empty(0, dtype=np.uint64), 31)) == 0
                    insert(f, "prehashed", np.empty(0, dtype=np.uint64), 31)
                    records.append(dict(name=name, requested_bpk=requested_bpk, build_mode=build_mode,
                                        actual_bytes=f.bytes, positives=int(expected.sum()), queries=len(expected)))
            assert all(np.array_equal(references[0], row) for row in references[1:])
    handle = ct.c_void_p()
    assert library.dll.bc_native_create(99, 1024, 8, ct.byref(handle)) == -1 and not handle.value
    assert library.dll.bc_native_create(0, 1024, 0, ct.byref(handle)) == -1 and not handle.value
    assert library.dll.bc_native_operation(None, 1, 0, 0, None, None, 1, None) == -1
    with library.allocate(NATIVE_NAMES[0], 1024, 8) as f:
        assert library.dll.bc_native_operation(f.handle, 1, 0, 0, None, None, 1 << 32, None) == -1
    return records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native", required=True, type=Path)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--native-only", action="store_true")
    args = parser.parse_args()
    verify_sources()
    check_workload()
    result = {"native": check_native(args.native)}
    if not args.native_only:
        result["blowchoc"] = check_blows()
    if args.report:
        args.report.write_text(json.dumps(result, indent=2) + "\n")
    print(f"whole-array bridge correctness passed: {len(result['native'])} native rows, "
          f"{len(result.get('blowchoc', []))} BlowChoc parameter sets; no throughput measurement")


if __name__ == "__main__":
    main()
