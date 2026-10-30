"""Whole-array adapter; upstream code under vendor/ is never modified.

Three separate contracts: prehashed, fused common hash, and batched hash scratch.
Every mode uses the public scalar filter API inside one compiled whole-array loop.
"""
from pathlib import Path
import ctypes as ct
import gc
import math
import random
import sys
import time
import types
import weakref

import numpy as np
from numba import njit, uint64

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "vendor"))
from blowchoc.filter_bb_choices import build_filter, get_mod_values
from blowchoc.lowlevel.aligned_arrays import aligned_zeros
from blowchoc.subtable_hashfunctions import populate_hashfunc_tuple
from oracle import fitting_blocks, payload_budget

MODES = {"prehashed": 0, "common-fused": 1, "common-staged": 2}
NATIVE_NAMES = ("FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter", "ByteSplitBloomFilter")


@njit(nogil=True, inline="always")
def common_hash(value):
    value = uint64(value)
    value ^= value >> uint64(32)
    value *= uint64(0xd6e8feb86659fd93)
    value ^= value >> uint64(32)
    value *= uint64(0xd6e8feb86659fd93)
    value ^= value >> uint64(32)
    return value


@njit(nogil=True)
def hash_array(raw, out):
    for i in range(len(raw)):
        out[i] = common_hash(raw[i])


def backing_array(array):
    """Require a single owning NumPy allocation, rather than guessing RSS."""
    owner = array
    seen = set()
    while owner.base is not None:
        if id(owner) in seen or not isinstance(owner.base, np.ndarray):
            raise ValueError("unknown or cyclic NumPy backing allocation")
        seen.add(id(owner))
        owner = owner.base
    if not owner.flags.owndata:
        raise ValueError("backing array does not own its allocation")
    return owner


def require_array(array, dtype, length=None):
    if not isinstance(array, np.ndarray) or array.dtype != np.dtype(dtype) or array.ndim != 1:
        raise ValueError(f"expected one-dimensional {dtype} ndarray")
    if not array.flags.c_contiguous or not array.flags.aligned or not array.flags.writeable:
        raise ValueError("arrays must be aligned, C-contiguous and writable (one warmed signature)")
    if length is not None and len(array) < length:
        raise ValueError("array is too short")


def validate_operation(keys, output, scratch, batch, query, mode):
    if mode not in MODES or not isinstance(batch, int) or not 0 < batch <= (1 << 32) - 1:
        raise ValueError("invalid mode or batch size")
    require_array(keys, np.uint64)
    require_array(output, np.uint32, len(keys) if query else 0)
    require_array(scratch, np.uint64, min(batch, len(keys)) if mode == "common-staged" else 0)
    if np.shares_memory(keys, output) or np.shares_memory(keys, scratch) or np.shares_memory(output, scratch):
        raise ValueError("input, output and hash scratch must not overlap")


class Lifetime:
    def __init__(self):
        self.alive = True
        self.operations = weakref.WeakSet()

    def close(self):
        self.alive = False
        for operation in self.operations:
            operation.args = ()
            operation.keepalive = None


class Operation:
    def __init__(self, call, args, check, lifetime):
        self._call, self.args, self.check, self.lifetime = call, args, check, lifetime
        lifetime.operations.add(self)

    def call(self, *args):
        # Same one-per-array Python guard for both languages; never per key.
        if not self.lifetime.alive:
            raise RuntimeError("prepared operation's filter is closed")
        return self._call(*args)

    def execute(self):
        self.check(self.call(*self.args))


def _jit_status(status):
    if status != 0:
        raise RuntimeError("Numba whole-array operation failed")


def _make_loop(insert, lookup, query, mode):
    # Public scalar methods are closed over, never a descriptor/bitmap. No
    # fastmath, parallel transformation, or replacement probe algorithm.
    @njit(nogil=True)
    def loop(bitmap, keys, output, batch, scratch, positions):
        for begin in range(0, len(keys), batch):
            length = min(batch, len(keys) - begin)
            if mode == 2:
                for j in range(length):
                    scratch[j] = common_hash(keys[begin + j])
            for j in range(length):
                if mode == 2:
                    h = scratch[j]
                elif mode == 1:
                    h = common_hash(keys[begin + j])
                else:
                    h = keys[begin + j]
                if query:
                    output[begin + j] = lookup(bitmap, h, positions)
                else:
                    insert(bitmap, h, positions)
        return 0
    return loop


def closure_arrays(objects):
    """Inspect the Python closure graph; globals are deliberately not traversed."""
    arrays, seen = [], set()
    def visit(obj):
        if id(obj) in seen:
            return
        seen.add(id(obj))
        if isinstance(obj, np.ndarray):
            arrays.append(obj)
        elif hasattr(obj, "py_func"):
            visit(obj.py_func)
        elif isinstance(obj, types.FunctionType):
            for cell in obj.__closure__ or ():
                visit(cell.cell_contents)
            visit(obj.__defaults__)
        elif isinstance(obj, (list, tuple)):
            for value in obj:
                visit(value)
        elif isinstance(obj, dict):
            for value in obj.values():
                visit(value)
    visit(objects)
    return arrays


class BlowChocFactory:
    def __init__(self, keys, bpk, choices=2, probes=8, version="random", construction_seed=113):
        if choices not in (1, 2) or not 1 <= probes <= 64 or version not in ("random", "distinct"):
            raise ValueError("unsupported initial BlowChoc configuration")
        self.keys, self.bpk = keys, bpk
        self.budget = payload_budget(keys, bpk)
        block_count = fitting_blocks(self.budget)
        # Preserve caller RNG state. This seed is never derived from timing or
        # calibration data; hash strings are recorded before seeing any answers.
        state = random.getstate()
        try:
            random.seed(construction_seed)
            sub = populate_hashfunc_tuple(("random",), mod_value=1)
            block = populate_hashfunc_tuple(("random",) * choices, mod_value=block_count)
            bit = populate_hashfunc_tuple(("random",) * probes,
                                          mod_value=list(get_mod_values(version, probes)))
        finally:
            random.setstate(state)
        self.spec = dict(universe=4**32, nsubfilters=1, nblocks=block_count,
                         nblocks_per_subfilter=block_count, nchoices=choices, nbits=probes,
                         bitversion=version, beta=(1 + math.sqrt(5)) / 2, mu=1.0,
                         subfilter_hashfuncs_str=sub, bucket_hashfuncs_str=block,
                         bit_hashfuncs_str=bit, construction_seed=construction_seed)
        started = time.perf_counter_ns()
        descriptor = build_filter(4**32, 1, block_count, choices, probes, bitversion=version,
                                  beta=self.spec["beta"], mu=1.0,
                                  subfilter_hashfuncs_str=sub, bucket_hashfuncs_str=block,
                                  bit_hashfuncs_str=bit)
        self.name = f"BlowChocC{choices}K{probes}{version.title()}"
        self.logical_bytes = descriptor.array.nbytes
        self.backing_bytes = backing_array(descriptor.array).nbytes
        if self.backing_bytes != self.budget or self.backing_bytes != self.logical_bytes + 448:
            raise RuntimeError("unexpected upstream backing allocation")
        self.loops = {(query, mode): _make_loop(descriptor.insert, descriptor.lookup, query, mode)
                      for query in (False, True) for mode in MODES.values()}
        warm = descriptor.array
        warm_ref, owner_ref = weakref.ref(warm), weakref.ref(backing_array(warm))
        one = np.array([0x123456789abcdef0], dtype=np.uint64)
        output = np.zeros(1, dtype=np.uint32)
        scratch = np.zeros(1, dtype=np.uint64)
        positions = np.zeros(probes, dtype=np.uint16)
        # Finish every signature before another factory can overwrite upstream
        # module globals such as block_hf_0 and bit_hf_0.
        for fn in self.loops.values():
            _jit_status(fn(warm, one, output, 1, scratch, positions))
        # Oracle accessors also need their exact scalar signatures frozen now.
        scalar = np.uint64(one[0])
        descriptor.private.get_subfilter(scalar)
        for choice in range(choices):
            descriptor.private.get_block(choice, scalar)
        descriptor.private.get_bit_positions(scalar, positions)
        descriptor.insert(warm, scalar, positions)
        descriptor.lookup(warm, scalar, positions)
        self.descriptor = descriptor._replace(array=None, mem_bytes=0)
        if closure_arrays((self.loops, self.descriptor)):
            raise RuntimeError("compiled filter closure retains an ndarray")
        del descriptor, warm
        gc.collect()
        self.warmup_released = warm_ref() is None and owner_ref() is None
        if not self.warmup_released:
            raise RuntimeError("warm-up bitmap remains live")
        self.cold_compile_ns = time.perf_counter_ns() - started
        self.signatures = {str(key): tuple(map(str, fn.signatures)) for key, fn in self.loops.items()}

    def allocate(self):
        return BlowChocFilter(self)


class BlowChocFilter:
    def __init__(self, factory):
        self.factory = factory
        self.lifetime = Lifetime()
        self.bitmap = aligned_zeros(factory.logical_bytes // 8, dtype=np.uint64, byte_alignment=64)
        self.positions = np.empty(factory.spec["nbits"], dtype=np.uint16)
        self.bytes = backing_array(self.bitmap).nbytes
        if self.bytes != factory.backing_bytes or self.bitmap.ctypes.data % 64:
            raise RuntimeError("fresh upstream allocation differs from warm-up")

    def prepare(self, query, mode, keys, output, batch, scratch):
        if not self.lifetime.alive:
            raise RuntimeError("BlowChoc filter is closed")
        validate_operation(keys, output, scratch, batch, query, mode)
        if any(np.shares_memory(self.bitmap, x) or np.shares_memory(self.positions, x)
               for x in (keys, output, scratch)):
            raise ValueError("filter and harness arrays overlap")
        fn = self.factory.loops[(bool(query), MODES[mode])]
        return Operation(fn, (self.bitmap, keys, output, batch, scratch, self.positions), _jit_status, self.lifetime)

    def close(self):
        self.lifetime.close()
        self.bitmap = self.positions = None

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.close()


class NativeLibrary:
    def __init__(self, path):
        self.dll = ct.CDLL(str(Path(path).resolve()))
        self.dll.bc_native_error.restype = ct.c_char_p
        self.dll.bc_native_create.argtypes = [ct.c_uint, ct.c_size_t, ct.c_uint32, ct.POINTER(ct.c_void_p)]
        self.dll.bc_native_create.restype = ct.c_int
        self.dll.bc_native_destroy.argtypes = [ct.c_void_p]
        self.dll.bc_native_destroy.restype = None
        self.dll.bc_native_bytes.argtypes = [ct.c_void_p]
        self.dll.bc_native_bytes.restype = ct.c_size_t
        self.dll.bc_native_operation.argtypes = [ct.c_void_p, ct.c_uint, ct.c_uint, ct.c_size_t,
                                                ct.c_void_p, ct.c_void_p, ct.c_size_t, ct.c_void_p]
        self.dll.bc_native_operation.restype = ct.c_int

    def check(self, status):
        if status:
            raise RuntimeError(self.dll.bc_native_error().decode())

    def allocate(self, name, keys, bpk):
        if name not in NATIVE_NAMES:
            raise ValueError("unknown native filter")
        return NativeFilter(self, NATIVE_NAMES.index(name), keys, bpk)


class NativeFilter:
    def __init__(self, library, kind, keys, bpk):
        expected = payload_budget(keys, bpk)
        self.library = library
        self.lifetime = Lifetime()
        self.handle = ct.c_void_p()
        library.check(library.dll.bc_native_create(kind, keys, bpk, ct.byref(self.handle)))
        self.bytes = library.dll.bc_native_bytes(self.handle)
        if self.bytes != expected:
            self.close()
            raise RuntimeError("native size differs from budget contract")

    def prepare(self, query, mode, keys, output, batch, scratch):
        validate_operation(keys, output, scratch, batch, query, mode)
        if not self.handle.value:
            raise RuntimeError("native filter is closed")
        # Convert pointers and scalar arguments outside the measured call.
        args = (self.handle, ct.c_uint(bool(query)), ct.c_uint(MODES[mode]), ct.c_size_t(len(keys)),
                ct.c_void_p(keys.ctypes.data), ct.c_void_p(output.ctypes.data), ct.c_size_t(batch),
                ct.c_void_p(scratch.ctypes.data))
        operation = Operation(self.library.dll.bc_native_operation, args, self.library.check, self.lifetime)
        operation.keepalive = (self, keys, output, scratch)
        return operation

    def close(self):
        self.lifetime.close()
        if self.handle.value:
            self.library.dll.bc_native_destroy(self.handle)
            self.handle = ct.c_void_p()

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.close()
