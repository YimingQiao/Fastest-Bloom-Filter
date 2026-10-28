"""
Module fastcash.hashfunctions

This module provides
several hash functions for different purposes.
"""

from math import ceil, log2
from random import randrange

from numba import njit, uint64

from .mathutils import bitsfor


DEFAULT_HASHFUNCS = ("linear62591", "linear42953", "linear48271")


def parse_names(hashfuncs, choices, maxfactor=2**32 - 1):
    """
    Parse colon-separated string with hash function name(s),
    or string with a special name ("default", "random").
    Return tuple with hash function names.
    """
    if hashfuncs == "default":
        return DEFAULT_HASHFUNCS[:choices]
    elif hashfuncs == "random":
        while True:
            r = [randrange(3, maxfactor, 2) for _ in range(choices)]
            if len(set(r)) == choices:
                break
        hf = tuple(["linear" + str(x) for x in r])
        return hf
    hf = tuple(hashfuncs.split(":"))
    if len(hf) != choices:
        raise ValueError(f"Error: '{hashfuncs}' does not contain {choices} functions.")
    return hf


def compile_get_bucket_fpr(name, universe, nbuckets, *,
        nfingerprints=-1):
    """
    Build hash function 'name' for keys in {0..'universe'-1} that
    hashes injectively to 'nbuckets' buckets and 'nfingerprints' fingerprints.
    
    Return a pair of functions: (get_bucket_fingerprint, get_key), where
    * get_bucket_fingerprint(key) returns the pair (bucket, fingerprint),
    * get_key(bucket, fpr)        returns the key for given bucket and fingerprint,
    where bucket is in {0..nbuckets-1}, fingerprint is in {0..nfingerprints-1}.
    
    Invariants:
    - get_key(*get_bucket_fingerprint(key)) == key for all keys in {0..universe-1}.
    
    The following hash function 'name's are implemented:
    1. linear{ODD}, e.g. linear123, with a positive odd number.
    ...
    
    Restrictions:
    Currently, universe must be a power of 4 (corresponding to a DNA k-mer).
    """
    if nfingerprints < 0:
        nfingerprints = int(ceil(universe / nbuckets))
    elif nfingerprints == 0:
        nfingerprints = 1
    qbits = bitsfor(universe)
    bucketbits = int(ceil(log2(nbuckets)))
    bucketmask = uint64(2**bucketbits - 1)
    fprbits = int(ceil(log2(nfingerprints)))
    fprmask = uint64(2**fprbits - 1)
    codemask = uint64(2**qbits - 1)
    shift = qbits - bucketbits

    if 4**(qbits // 2) != universe:
        raise ValueError("hash functions require that universe is a power of 4")
    else:
        q = qbits // 2
     
    # define a default get_key function
    get_key = None  # will raise an error if called from numba as a function.
    if name.startswith("linear"):  # e.g. "linear12345"
        a = int(name[6:])
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, f=uint64, p=uint64))
        def get_bucket_fpr(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * swap) & codemask
            p = swap % nbuckets
            f = swap // nbuckets
            return (p, f)

        @njit(nogil=True, locals=dict(
            key=uint64, bucket=uint64, fpr=uint64))
        def get_key(bucket, fpr):
            key = fpr * nbuckets + bucket
            key = (ai * key) & codemask
            key = ((key << q) ^ (key >> q)) & codemask
            return key
    
    elif name.startswith("affine"):  # e.g. "affine12345+66666"
        raise ValueError(f"unknown hash function '{name}'")
    else:
        raise ValueError(f"unknown hash function '{name}'")
    return (get_bucket_fpr, get_key)


def extend_func_tuple(funcs, n):
    """Extend a tuple of functions to n functions by appending dummies"""
    n0 = len(funcs)
    if n0 < 1 or n0 > 4:
        raise ValueError("Only 1 to 4 hash functions are supported.")
    if n0 == n:
        return funcs
    if n0 > n:
        raise ValueError(f"Function tuple {funcs} already has {n0}>{n} elements.")
    return funcs + (funcs[0],) * (n - n0)


def get_hashfunctions(hashfuncs, choices, universe, nbuckets, nfingerprints):
    # Define functions get_bf{1,2,3,4}(key) to obtain buckets and fingerprints.
    # Define functions get_key{1,2,3,4}(bucket, fpr) to obtain keys back.
    # Example: hashfuncs = 'linear123:linear457:linear999'
    # Example new: 'linear:123,456,999' or 'affine:123+222,456+222,999+222'
    hashfuncs = parse_names(hashfuncs, choices)  # ('linear123', 'linear457', ...)

    if choices >= 1:
        (get_bf1, get_key1) = compile_get_bucket_fpr(
            hashfuncs[0], universe, nbuckets, nfingerprints=nfingerprints)
    if choices >= 2:
        (get_bf2, get_key2) = compile_get_bucket_fpr(
            hashfuncs[1], universe, nbuckets, nfingerprints=nfingerprints)
    if choices >= 3:
        (get_bf3, get_key3) = compile_get_bucket_fpr(
            hashfuncs[2], universe, nbuckets, nfingerprints=nfingerprints)
    if choices >= 4:
        (get_bf4, get_key4) = compile_get_bucket_fpr(
            hashfuncs[3], universe, nbuckets, nfingerprints=nfingerprints)

    if choices == 1:
        get_bf = (get_bf1,)
        get_key = (get_key1,)
    elif choices == 2:
        get_bf = (get_bf1, get_bf2)
        get_key = (get_key1, get_key2)
    elif choices == 3:
        get_bf = (get_bf1, get_bf2, get_bf3)
        get_key = (get_key1, get_key2, get_key3)
    elif choices == 4:
        get_bf = (get_bf1, get_bf2, get_bf3, get_bf4)
        get_key = (get_key1, get_key2, get_key3, get_key4)
    else:
        raise ValueError("Only 1 to 4 hash functions are supported.")

    return (hashfuncs, get_bf, get_key)


def compile_get_bucket(name, universe, nbuckets):
    """
    Build hash function 'name' for keys in {0 .. universe-1} that
    hashes to 'nbuckets' buckets.

    Return a function:
    get_bucket(key) returns the bucket in {0 .. nbuckets-1}.

    The following hash function 'name's are implemented:
    1. linear{ODD}, e.g. linear123, with a positive odd number
    2. affine{ODD}-{COST}, e.g. affine123-456

    Restrictions:
    Currently, universe must be a power of 4 (corresponding to a DNA k-mer).
    """
    qbits = bitsfor(universe)
    if 4**(qbits // 2) != universe:
        raise ValueError("hash functions require that universe is a power of 4")
    q = qbits // 2
    codemask = uint64(2**qbits - 1)
    if log2(nbuckets).is_integer():
        bits = int(log2(nbuckets))
        assert bits <= qbits
        bitmask = uint64(2**bits - 1)
    else:
        bits = -1
        bitmask = uint64(0)

    if name.startswith("linear"):  # e.g. "linear12345"
        a = uint64(int(name[6:]))
        b = uint64(0)
    elif name.startswith("affine"):
        a, b = map(uint64, name[6:].split("-"))
    else:
        raise ValueError(f"unknown hash function '{name}'")

    if bits >= 0:
        @njit(nogil=True, locals=dict(
              code=uint64, swap=uint64, bucket=uint64))
        def get_bucket(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            bucket = (swap >> (qbits - bits)) & bitmask
            return bucket
    elif not nbuckets % 2:
        @njit(nogil=True, locals=dict(
              code=uint64, swap=uint64, bucket=uint64))
        def get_bucket(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            swap ^= (swap >> q)
            bucket = swap % nbuckets
            return bucket
    else:
        @njit(nogil=True, locals=dict(
              code=uint64, swap=uint64, bucket=uint64))
        def get_bucket(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            bucket = swap % nbuckets
            return bucket

    return get_bucket
