"""
llvm.py

Module that implements compilation of numba extensions
using llvmlite.

All exported functions have the `compile_` prefix;
so a user has to compile to numba extension with the appropriate type(s).

In the examples below,
- i is of some numba integer type,
- a is a numpy array of some dtype

```
pause = compile_pause()
pause()  # give the CPU a break

popcount = compile_popcount(dtype)
onebits = popcount(i)

ctlz = compile_ctlz(dtype)  # count leading zeros
cttz = compile_cttz(dtype)  # count trailing zeros
lz, tz = ctlz(i), cttz(i)

prefetch = compile_prefetch_array_element()
prefetch(a, i)  # prefetch a[i] from RAM into L1 cache
# more CPU instructions that take some time ...
val = a[i]      # fast retrieval from L1 cache thanks to prefetch

vstore = compile_volatile_store(dtype)
vload = compile_volatile_load(dtype)
vstore(a, i, val)  # store val (of type dtype) at a[i]
val = vload(a, i)  # load a[i] into val

cmpxchg = compile_compare_xchange(typingctx, address, cmp, new):
cmpxchg(a, i, old, new)  # atomically set a[i] = new if a[i] == old
```

TODO:
- Implement functons floating point types as well.
- Add more LLVM intrinsic functions.

"""

from platform import machine
from warnings import warn

import numpy as np
import numba
from numba import njit, uint64
import llvmlite
from llvmlite import ir


# TYPES AND HELPERS #####################################


_MACHINE = machine().lower()  # e.g., 'arm64',  'x86_64', 'amd64'


ir_types_str = {
    "uint8": "i8",
    "int8": "i8",
    "uint16": "i16",
    "int16": "i16",
    "uint32": "i32",
    "int32": "i32",
    "uint64": "i64",
    "int64": "i64",
}

ir_types = {
    "uint8": ir.IntType(8),
    "int8": ir.IntType(8),
    "uint16": ir.IntType(16),
    "int16": ir.IntType(16),
    "uint32": ir.IntType(32),
    "int32": ir.IntType(32),
    "uint64": ir.IntType(64),
    "int64": ir.IntType(64),
}

numba_types = {
    "int8": numba.int8,
    "uint8": numba.uint8,
    "int16": numba.int16,
    "uint16": numba.uint16,
    "int32": numba.int32,
    "uint32": numba.uint32,
    "int64": numba.int64,
    "uint64": numba.uint64,
}


def insert_ir_call(ir_func_text, ir_func_name, context, builder, sig, args):
    # Get the context library to add the IR to.
    active_library = context.active_code_library
    # Test if the IR function was already added; a NameError if raised
    # if it is not found.
    try:
        active_library.get_function(ir_func_name)
    except NameError:
        # Parse and add the IR.
        ll_module = llvmlite.binding.parse_assembly(ir_func_text)
        ll_module.verify()
        active_library.add_llvm_module(ll_module)

    # Insert, or look up, the function in the builder module.
    # Code is similar to numba.cgutils.insert_pure_function, but doesn't
    # set the "readonly" flag since the intrinsic may change
    # pointed-to values.
    function = numba.core.cgutils.get_or_insert_function(
        builder.module,
        fnty=llvmlite.ir.FunctionType(
            return_type=context.get_argument_type(sig.return_type),
            args=[context.get_argument_type(aty) for aty in sig.args]
            ),
        name=ir_func_name)

    # Add 'nounwind' attribute; no exception handling is wanted.
    function.attributes.add('nounwind')

    # Add a Call node to the IR function.
    retval = context.call_external_function(builder, function, sig.args, args)
    return retval


# PRINTF

@numba.extending.intrinsic
def printf(typingctx, format_type, *args):
    """printf that can be called from Numba jit-decorated functions.
    """
    if isinstance(format_type, numba.types.StringLiteral):
        sig = numba.types.void(format_type, numba.types.BaseTuple.from_types(args))
        def codegen(context, builder, signature, args):
            numba.core.cgutils.printf(builder, format_type.literal_value, *args[1:])
        return sig, codegen


# MEMMOVE

def compile_memmove():
    """
    Compile the memmove llvm function.
    This moves memory in an array and the area can overlap.
    array: the numpy array in which we want to move the memory
    src: start index in the array from which we take the data
    dest: destination index in the array to which we write the data
    items: number of elements we want to move
    """
    @numba.extending.intrinsic
    def _memmove(typingctx, src, dest, items, volatile):
        sig = numba.types.void(numba.uint64, numba.uint64, numba.uint64, numba.uint8)
        def codegen(context, builder, sig, args):
            fty = ir.FunctionType(ir.VoidType(), (ir.IntType(8).as_pointer(), ir.IntType(8).as_pointer(), ir.IntType(64), ir.IntType(1)))
            _memmove = builder.module.declare_intrinsic(
                f"llvm.memmove.p0.p0.i64", fnty=fty)
            volatile = ir.Constant(ir.IntType(1), 1)
            return builder.call(_memmove, (builder.inttoptr(args[0], ir.IntType(8).as_pointer()), builder.inttoptr(args[1], ir.IntType(8).as_pointer()), args[2], volatile,))
        return sig, codegen

    @njit(nogil=True, locals=dict(src_ptr=uint64, dest_ptr=uint64, items_u8=uint64))
    def memmove(array, src, dest, items, volatile=1):
        array_ptr = array.ctypes.data
        src_ptr = array_ptr + src * array.itemsize
        dest_ptr = array_ptr + dest * array.itemsize
        items_u8 = items * array.itemsize
        _memmove(src_ptr, dest_ptr, items_u8, volatile)

    return memmove




# POPCOUNT #############################################

def compile_popcount(dtype):
    """
    Compile and return the ctpop function.
    """
    assert isinstance(dtype, str)
    assert dtype in ir_types

    @numba.extending.intrinsic
    def popcount(typingctx, value):
        def codegen(context, builder, sig, args):
            fty = ir.FunctionType(ir_types[dtype], (ir_types[dtype],))
            _popcount = builder.module.declare_intrinsic(
                f"llvm.ctpop.{ir_types_str[dtype]}", fnty=fty)
            return builder.call(_popcount, (args[0],))
        sig = numba_types[dtype](numba_types[dtype])
        return sig, codegen

    return popcount


def test_popcount():
    popct = compile_popcount("uint64")

    @numba.njit(nogil=True)
    def ctpop(a):
        return popct(a)

    t = numba.uint64(12297829382473034410)
    assert ctpop(t) == 32


# PAUSE #############################################

def compile_pause():
    """
    Compile and return the pause function.
    This may fail badly wtih an LLVM error
    if we don't check the machine's capabilities correctly.
    """
    if _MACHINE in ('x86_64', 'amd64'):
        # print(f"compiling for {MACHINE}")
        @numba.extending.intrinsic
        def pause(typingctx):
            """do nothing for a while (pause)"""
            def codegen(context, builder, sig, args):
                void_t = ir.VoidType()
                fty = ir.FunctionType(void_t, [])
                _pause = builder.module.declare_intrinsic(
                    "llvm.x86.sse2.pause", fnty=fty)
                builder.call(_pause, [])

            sig = numba.void()
            return sig, codegen

    elif _MACHINE == 'arm64':
        # print(f"compiling for {MACHINE}")
        @numba.extending.intrinsic
        def pause(typingctx):
            """do nothing for a while (pause)"""
            def codegen(context, builder, sig, args):
                void_t = ir.VoidType()
                int32_t = ir.IntType(32)
                const1 = ir.Constant(int32_t, 1)
                fty = ir.FunctionType(void_t, (int32_t,))
                _hint = builder.module.declare_intrinsic(
                    "llvm.aarch64.hint", fnty=fty)
                builder.call(_hint, (const1,))

            sig = numba.void()
            return sig, codegen

    else:  # unknown MACHINE
        warn(f"Unsupported Machine '{_MACHINE}' for pause(); using busy waiting")

        @numba.njit(nogil=True)
        def pause():
            return None

    return pause


def test_pause():
    pause = compile_pause()

    @numba.njit(nogil=True)
    def use_pause():
        pause()

    result = use_pause()  # run it once to auto-compile
    # use_pause.inspect_types()  # DEBUG
    asm = use_pause.inspect_asm()
    for sig, code in asm.items():
        print(sig, '\n=========\n', code, '\n')
    assert result is None


# PREFETCHING  ##########################################

def compile_prefetch_array_element():
    """Compile and return the prefetch_array_element function"""
    @numba.extending.intrinsic
    def prefetch_address(typingctx, address):
        """prefetch given memory address (uint64 or int64)"""

        if isinstance(address, numba.types.Integer):

            def codegen(context, builder, sig, args):
                int32_t = ir.IntType(32)
                int8_p = ir.IntType(8).as_pointer()
                const0 = ir.Constant(int32_t, 0)
                const1 = ir.Constant(int32_t, 1)
                prefetch = builder.module.declare_intrinsic(
                    "llvm.prefetch",
                    fnty=ir.FunctionType(
                        ir.VoidType(), (int8_p, int32_t, int32_t, int32_t)
                    ),
                )
                ptr = builder.inttoptr(args[0], int8_p)
                builder.call(prefetch, (ptr, const0, const0, const1))

            sig = numba.void(numba.types.uintp)
            return sig, codegen

    @numba.njit(nogil=True)
    def prefetch_array_element(a, i):
        """prefetch array element a[i]"""
        return prefetch_address(a.ctypes.data + a.itemsize * i)

    return prefetch_array_element

    # TODO: What was this for? Can it be deleted?
    # @numba.extending.overload_method(numba.types.Array, 'prefetch')
    # def array_prefetch(arr, index):
    #    if isinstance(index, numba.types.Integer):
    #        def prefetch_impl(arr, index):
    #            return prefetch_array_element(arr, index)
    #        return prefetch_impl


# VOLATILE LOAD AND STORE #############################

def compile_volatile_load(dtype):

    assert isinstance(dtype, str)
    assert dtype in ir_types

    load_volatile_ir = f"define {ir_types[dtype]} @load_volatile_{ir_types[dtype]}({ir_types[dtype]}* %address) {{\n" \
        f"    %res = load volatile {ir_types[dtype]}, {ir_types[dtype]}* %address\n" \
        f"    ret {ir_types[dtype]} %res\n" \
        f"}}"

    @numba.extending.intrinsic
    def volatile_load(typingctx, address):
        if isinstance(address, numba.types.Integer):
            def codegen(context, builder, sig, args):
                return insert_ir_call(
                    load_volatile_ir,
                    f'load_volatile_{ir_types[dtype]}',
                    context, builder, sig, args)
            signature = numba_types[dtype](numba.types.intp)
            return signature, codegen

    @numba.njit(nogil=True)
    def volatile_load_array_pos(a, i):
        return volatile_load(a.ctypes.data + a.itemsize * i)

    return volatile_load_array_pos


def compile_volatile_store(dtype):

    assert isinstance(dtype, str)
    assert dtype in ir_types

    store_volatile_ir = f"define void @store_volatile_{ir_types[dtype]}({ir_types[dtype]}* %address, {ir_types[dtype]} %value) {{\n"\
        f"    store volatile {ir_types[dtype]} %value, {ir_types[dtype]}* %address\n"\
        f"    ret void"\
        f"}}"

    @numba.extending.intrinsic
    def volatile_store(typingctx, address, value):
        if isinstance(address, numba.types.Integer) and isinstance(value, numba.types.Integer):
            def codegen(context, builder, sig, args):
                return insert_ir_call(
                    store_volatile_ir,
                    f'store_volatile_{ir_types[dtype]}',
                    context, builder, sig, args)
            signature = numba.void(numba.types.intp, numba_types[dtype])  # (int64, intx) -> none
            return signature, codegen

    @numba.njit(nogil=True)
    def volatile_store_array_pos(a, i, v):
        assert a.dtype is np.dtype(dtype)
        return volatile_store(a.ctypes.data + a.itemsize * i, v)

    return volatile_store_array_pos


# Compare and Exchange (CMPXCHG) ##########################

def compile_compare_xchange(dtype):

    if not (isinstance(dtype, str) and dtype in ir_types):
        raise TypeError(f"compile_compare_xchange: dtype must be in {set(ir_types.keys())}")

    cmpxchg_ir = f"define i1 @compare_xchange{ir_types[dtype]}({ir_types[dtype]}* %address, {ir_types[dtype]} %cmp, {ir_types[dtype]} %new) {{\n" \
        f"    %val_success = cmpxchg volatile {ir_types[dtype]}* %address, {ir_types[dtype]} %cmp, {ir_types[dtype]} %new acq_rel monotonic\n" \
        f"    %value_loaded = extractvalue {{ {ir_types[dtype]}, i1 }} %val_success, 0\n"\
        f"    %success = extractvalue {{ {ir_types[dtype]}, i1 }} %val_success, 1\n"\
        f"    ret i1 %success\n" \
        f"}}"

    @numba.extending.intrinsic
    def build_compare_xchange(typingctx, address, cmp, new):
        if isinstance(address, numba.types.Integer):
            def codegen(context, builder, sig, args):
                return insert_ir_call(
                    cmpxchg_ir,
                    f'compare_xchange{ir_types[dtype]}',
                    context, builder, sig, args)
            signature = numba.uint8(numba.types.intp, numba_types[dtype], numba_types[dtype])
            return signature, codegen

    @numba.njit(nogil=True)
    def compare_xchange_array_pos(a, i, comp, new):
        return build_compare_xchange(a.ctypes.data + a.itemsize * i, comp, new)

    return compare_xchange_array_pos


def test_cmpxchg():
    cmpxchg = compile_compare_xchange("uint64")

    @numba.njit(nogil=True)
    def _test(a):
        first = cmpxchg(a, 0, 0, 115)
        second = cmpxchg(a, 0, 0, 115)
        return first, second

    array = np.zeros(1, dtype=np.uint64)
    first, second = _test(array)
    assert first and not second


# COUNT LEADING AND TRAILING ZEROS  ##########################

def compile_ctlz(dtype):
    """
    Compile and return the ctlz function.
    """
    assert isinstance(dtype, str)
    assert dtype in ir_types

    @numba.extending.intrinsic
    def ctlz(typingctx, value):
        def codegen(context, builder, sig, args):
            fty = ir.FunctionType(ir_types[dtype], (ir_types[dtype],))
            _ctlz = builder.module.declare_intrinsic(
                f"llvm.ctlz.{ir_types_str[dtype]}", fnty=fty)
            return builder.call(_ctlz, (args[0],))
        sig = numba_types[dtype](numba_types[dtype])
        return sig, codegen

    return ctlz


def compile_cttz(dtype):
    """
    Compile and return the cttz function.
    """
    assert isinstance(dtype, str)
    assert dtype in ir_types

    @numba.extending.intrinsic
    def cttz(typingctx, value):
        def codegen(context, builder, sig, args):
            fty = ir.FunctionType(ir_types[dtype], (ir_types[dtype],))
            _cttz = builder.module.declare_intrinsic(
                f"llvm.cttz.{ir_types_str[dtype]}", fnty=fty)
            return builder.call(_cttz, (args[0],))
        sig = numba_types[dtype](numba_types[dtype])
        return sig, codegen

    return cttz


def test_ctlz():
    ctlz = compile_ctlz("uint64")

    @numba.njit(nogil=True)
    def numba_ctlz(a):
        return ctlz(a)

    for i in range(64):
        t = numba.uint64(1 << i)
        assert numba_ctlz(t) == 63 - i


def test_cttz():
    cttz = compile_cttz("uint64")

    @numba.njit(nogil=True)
    def numba_cttz(a):
        return cttz(a)

    for i in range(64):
        t = numba.uint64(1 << i)
        assert numba_cttz(t) == i


# MAIN / RUN TESTS ####################################

if __name__ == "__main__":
    test_popcount()
    test_pause()
    test_ctlz()
    test_cttz()
    test_cmpxchg()
    # TODO: tests for vload, vstore
