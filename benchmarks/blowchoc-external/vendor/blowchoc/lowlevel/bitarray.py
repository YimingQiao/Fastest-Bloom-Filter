from math import ceil
from collections import namedtuple

import numpy as np
from numba import njit, int64, uint64

from .llvm import (
    compile_prefetch_array_element,
    compile_popcount,
    )
from .aligned_arrays import aligned_zeros


BitArray = namedtuple("BitArray", [
    "size",
    "quickaccess",
    "capacity",
    "capacity_bytes",
    "capacity_ints",
    "alignment",
    "array",       # !
    "popcount",    # !
    "get",         # !
    "set",         # !
    "getquick",
    "setquick",
    "prefetch",
    ])


def bitarray(size, *, alignment=64, quickaccess=1):
    """
    Initialize and return a bitarray of 'size' bits.
    Ensure that the first element is aligned to an 'alignment'-byte address,
    e.g. use alignment=64 (bytes) for 512-bit alignment (cache line size).

    Alternatively, pass an existing uint64[:] arary as the 'size' parameter
    in order to interpret it as bit array.

    If bits are always read/written in blocks of 'quickaccess' bits
    (which must divide 64), the optimized methods getquick and setquick
    may be used (CAUTION: no range or error checking is performed!).
    """
    U64_MINUSONE = uint64(np.iinfo(np.uint64).max)
    if quickaccess not in (1, 2, 4, 8, 16, 32, 64):
        raise ValueError(f"bitarray: {quickaccess=} must be a power of 2.")
    if isinstance(size, np.ndarray):
        array = size
        if array.dtype != np.uint64:
            raise TypeError(f"bitarray: dtype of given array is {array.dtype}, but must be uint64")
        size = int(array.size * 64)  # size in bits of existing array
    else:
        array = None
        size = int(size)
    ints = int(ceil(size / 64))
    btes = ints * 8
    capacity = ints * 64
    quickmask = uint64(2**quickaccess - 1)
    prefetch_index = compile_prefetch_array_element()
    popcount_value = compile_popcount("uint64")

    @njit(nogil=True, locals=dict(
          start=int64, x=uint64, mask=uint64, mask1=uint64, bits=int64))
    def get(a, start, bits=1):
        """return 'bits' bits from a[start:start+bits], where bits <= 64"""
        if bits <= 0:
            return uint64(0)
        startint = start // 64  # item starts in a[startint]
        startbit = start & 63   # at bit number startbit
        if startbit + bits <= 64:
            # bits are contained in a single uint64
            x = a[startint]
            if startbit > 0:
                x >>= startbit
        else:
            # bits are distributed over two uint64s,
            # less significant bits are the leftmost b1=(64-startbit) bits in a[startint]
            # more significant bits are the rightmost (bits-64+startbit) bits in a[startint+1]
            b1 = 64 - startbit
            mask1 = uint64(uint64(1 << b1) - uint64(1))
            x = uint64(a[startint] >> startbit) & mask1 
            x |= uint64(a[startint + 1] << b1)
        # due to a bug in numba, do not use x = y if cond else z !!
        if bits >= 64:
            return x
        mask = uint64(2**bits - 1)
        x &= mask
        return x

    @njit(nogil=True, locals=dict(startint=uint64))
    def prefetch(a, start):
        startint = start // 64  # item starts in a[startint]
        prefetch_index(a, startint)

    @njit(nogil=True, locals=dict(
          start=int64, startint=uint64, startbit=uint64, x=uint64))
    def getquick(a, start):
        startint = start // 64  # item starts in a[startint]
        startbit = start & 63   # at bit number startbit
        x = a[startint]
        x = (x >> startbit) & quickmask
        return x

    @njit(nogil=True, locals=dict(
          start=int64, value=uint64, quicksetmask=uint64))
    def setquick(a, start, value=1):
        startint = start // 64  # item starts in a[startint]
        startbit = start & 63   # at bit number startbit
        quicksetmask = uint64(~(quickmask << startbit))
        a[startint] = uint64(a[startint] & quicksetmask) | uint64(value << startbit)

    @njit(nogil=True, locals=dict(
          start=int64, value=uint64, v1=uint64,
          mask=uint64, mask1=uint64, mask2=uint64))
    def set(a, start, value, bits=1):
        """set a[start:start+bits] to value, where bits <= 64"""
        if bits <= 0:
            return
        startint = start // 64  # item starts in a[startint]
        startbit = start & 63   # at bit number startbit
        if bits >= 64:
            mask = U64_MINUSONE
        else:
            mask = uint64(2**bits - 1)
        if startbit + bits <= 64:
            # bits are contained in a single uint64
            mask1 = ~(mask << startbit)
            a[startint] = (a[startint] & mask1) | (value << startbit)
        else:
            # b1 leftmost bits in a[startint] == b1 rightmost bits of v, 
            b1 = 64 - startbit
            v1 = (value & uint64(2**b1 - 1))  # v1 = b1 rightmost bits of v
            mask1 = uint64(2**startbit - 1)  # only keep startbit rightmost bits
            a[startint] = (a[startint] & mask1) | (v1 << startbit)
            # b2 rightmost bits in a[startint+1] = b2 leftmost bits of v
            b2 = bits - b1
            mask2 = uint64(~(2**b2 - 1))
            a[startint + 1] = (a[startint + 1] & mask2) | (value >> b1)

    @njit(nogil=True, locals=dict(
          s=int64, startint=int64, endint=int64, i=int64, value=uint64,
          leftbits=int64, rightbits=int64, leftmask=uint64, rightmask=uint64))
    def popcount(a, start=0, end=size):
        """Return popcount (number of 1-bits) in a[start:end]"""
        s = 0
        startint = int64(start // 64)  # item starts in a[startint]
        endint = int64((end - 1) // 64)
        if endint == startint:  # single integer
            leftbits = end - start + 1
            startbit = start - startint * 64
            leftmask = uint64((1 << leftbits) - 1) if leftbits < 64 else U64_MINUSONE
            if startbit > 0:
                leftmask <<= startbit
            s = popcount_value(uint64(a[startint] & leftmask))
            return s
        leftbits = (startint + 1) * 64 - start  # highest `leftbits` in a[startint]
        leftmask = uint64(((1 << leftbits) - 1) << (64 - leftbits)) if leftbits < 64 else U64_MINUSONE
        s = popcount_value(uint64(a[startint] & leftmask))
        rightbits = end - endint * 64  # lowest `rightbits` in a[endint]
        rightmask = uint64((1 << rightbits) - 1) if rightbits < 64 else U64_MINUSONE
        s += popcount_value(uint64(a[endint] & rightmask))
        for i in range(startint + 1, endint):
            value = a[i]
            s += popcount_value(value)
        return s

    # use given array or initialize a new aligned array
    if array is None:
        array = aligned_zeros(ints, byte_alignment=alignment)

    b = BitArray(size=size, quickaccess=quickaccess,
        capacity=capacity, capacity_bytes=btes, capacity_ints=ints,
        alignment=alignment, array=array,
        popcount=popcount, get=get, set=set,
        getquick=getquick, setquick=setquick, prefetch=prefetch)
    return b
