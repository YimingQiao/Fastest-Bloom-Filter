from math import prod
import numpy as np


def aligned_zeros(shape, *, dtype=np.uint64, byte_alignment=64, autogrow=False):
    """
    Allocate and return a buffer of zeros of the given `shape` (int or tuple) and `dtype`.
    Ensure that the byte-address of the buffer is divisible by `byte_alignment` bytes.
    A cache line typically has 512 bits = 64 bytes,
    so byte_alignment=64 ensures that the buffer starts at a chache line boundary.
    This may waste a few bytes
    (with dtype=np.uint64 and byte_alignment=64 up to 56 = 64 - 8).
    """

    if byte_alignment % 8 != 0:
        raise ValueError("aligned_zeros: byte_alignment must be a multiple of 8 bytes")
    one_dimensional = isinstance(shape, int) or len(shape) == 1
    items = shape if isinstance(shape, int) else prod(shape)
    itemsize = np.dtype(dtype).itemsize
    items_per_cacheline = 64 // itemsize  # 64 bytes per cache line
    if not one_dimensional:
        # check that buffer uses a multiple of 64 bytes in lowest dimension
        if (hanging := (shape[-1] % items_per_cacheline)) != 0:
            if autogrow:
                shape = tuple(shape[:-1]) + (shape[-1] + items_per_cacheline - hanging, )
                items = prod(shape)
            else:
                raise ValueError(f"aligned_zeros: last dimension has {hanging} overhanging items (not aligned)")
    slack = byte_alignment - itemsize
    buf = np.empty(items + slack, dtype=dtype)
    buf[:] = 0
    # buf = np.zeros(items + slack, dtype=dtype)
    address = buf.ctypes.data  # buf.__array_interface__['data'][0]
    al = address % byte_alignment
    shift = ((byte_alignment - al) // itemsize) if al != 0 else 0
    # shift start of buffer by 'shift' items to achieve the requested alignment
    assert (0 <= shift < slack) or (shift == 0), f"{byte_alignment=}, {slack=}, {shift=} !!!"
    b = buf[shift:(shift + items)]
    baddress = b.ctypes.data  # b.__array_interface__['data'][0]
    if items > 0:
        assert baddress % byte_alignment == 0, f"{byte_alignment=}, {items=}, {itemsize=}, {slack=}, {al=}, {shift=}, {address=}, {baddress=}"
    return b if one_dimensional else b.reshape(*shape)
