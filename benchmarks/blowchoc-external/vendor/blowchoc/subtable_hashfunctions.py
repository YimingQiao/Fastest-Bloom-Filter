"""
Module fastcash.subtable_hashfunctions

This module provides multiple hashfunctions
which are used for hashing with subtables.

"""

from numba import njit, uint64
from math import log, gcd
from random import randrange

from .mathutils import inversemodpow2, bitsfor
from .lowlevel import debug


DEFAULT_HASHFUNCS = ("linear1006721", "linear62591", "linear42953", "linear48271")
# All of these numbers are primes (verified), so they always satisfy the GCD condition.


def check_gcd(values, mod_value):
    if mod_value is None:
        return True
    if isinstance(mod_value, list):
        for i in range(len(mod_value)):
            if gcd(values[i], mod_value[i]) != 1:
                return False
    else:
        for v in values:
            if gcd(v, mod_value) != 1:
                return False
    return True


def get_random_multiplier(maxfactor=(2**23 - 1), mod_value=None):
    while True:
        r = randrange(3, maxfactor, 2)
        if check_gcd([r], mod_value):
            break
    return r


def get_random_multipliers(n, *, maxfactor=(2**23 - 1), mod_value=None, min_value=3):
    while True:
        M = [randrange(min_value, maxfactor, 2) for _ in range(n)]
        if len(set(M)) == n and check_gcd(M, mod_value):
            break
    return M


def hashfunc_tuple_from_str(hashfunc_str, *,
        number=None, maxfactor=2**32 - 1, mod_value=None):
    """
    Parse colon-separated string with hash function name(s),
    or string with a special name ("default", "random").
    Return tuple[str] with hash function names.
    If hashfunc_str == "random", resolve only resolve many entries,
    and return the remaining strings in the tuple as "random" again.
    """
    debugprint0, debugprint1, debugprint2 = debug.debugprint
    if hashfunc_str == "default":
        number = number or len(DEFAULT_HASHFUNCS)
        hf = DEFAULT_HASHFUNCS[:number]
        # should always work if they are 'linear{prime}'
    elif hashfunc_str == "random":
        if number is None:
            raise ValueError(f"{number=} must be given, not None.")
        M = get_random_multipliers(number, maxfactor=maxfactor, mod_value=mod_value)
        hf = tuple(f"linear{x}" for x in M)
    else:
        hf = tuple(hashfunc_str.split(":"))

    # check validity of hf tuple: length and gcd
    failed = 0
    for func in hf:
        if func.startswith("linear"):
            m = int(func[6:])
            if (mod_value is not None) and (not check_gcd([m], mod_value)):
                debugprint0(f"- The provided hash function {func} and the {mod_value=} have a gcd != 1")
                failed += 1
        elif func == "random":
            continue
        else:
            debugprint0(f"- Cannot check function {func}, unknown prefix")
            failed += 1
    if failed:
        exit(1)
    return hf  # tuple[str]; len(hf) == choices


def populate_hashfunc_tuple(hashfunc_tuple, *, functype="linear",
        maxfactor=2**32 - 1, mod_value=None, min_value=3):
    """
    Return a new tuple of hashfunction strings,
    such that 'random' is replaced by a random function of the given type
    """
    if functype not in ("linear", "affine"):
        raise ValueError(f"{functype=} != 'linear' currently not supported")
    todo = sum(s == "random" for s in hashfunc_tuple)
    M = get_random_multipliers(todo, maxfactor=maxfactor, mod_value=mod_value, min_value=min_value)
    if functype == "affine":
        B = [randrange(3, maxfactor) for _ in range(len(hashfunc_tuple))]

    L = []
    m = 0
    for s in hashfunc_tuple:
        if s == "random":
            if functype == "linear":
                L.append(f"linear{M[m]}")
            else:
                L.append(f"affine{M[m]}-{B[m]}")
            m += 1
        else:
            L.append(s)
    return tuple(L)


# ##########################################################################

def compile_get_subtable_subkey_from_key(name, universe, subtables):
    qbits = bitsfor(universe)
    codemask = uint64(2**qbits - 1)
    if 4**(qbits // 2) != universe:
        raise ValueError("Error: hash functions require that universe is a power of 4")
    else:
        q = qbits // 2

    if name.startswith("linear"):
        a = int(name[6:])
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, subkey=uint64, s=uint64, f=uint64, p=uint64))
        def get_sub_subkey(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * swap) & codemask
            subkey = swap // subtables
            s = swap % subtables
            return (s, subkey)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, f=uint64, p=uint64))
        def get_key(sub, subkey):
            swap = subkey * subtables + sub
            swap = (ai * swap) & codemask
            key = ((swap << q) ^ (swap >> q)) & codemask
            return key

    elif name.startswith("affine"):
        a, b = name[6:].split("-")
        a = int(a)
        b = int(b)
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, subkey=uint64, s=uint64))
        def get_sub_subkey(code):
            swap = ((code << q) ^ (code >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            subkey = swap // subtables
            s = swap % subtables
            return (s, subkey)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, sub=uint64, subkey=uint64))
        def get_key(sub, subkey):
            swap = subkey * subtables + sub
            swap = ((ai * swap) ^ b) & codemask
            key = ((swap << q) ^ (swap >> q)) & codemask
            return key

    return get_sub_subkey, get_key


def compile_get_subtable_bucket_fpr_from_key(tablename, name, universe, nbuckets, subtables):
    """
    TODO
    """
    get_subtable_subkey, get_key_from_subtable_subkey = compile_get_subtable_subkey_from_key(tablename, universe, subtables)

    universe = universe // (4**(int(log(subtables, 4))))
    qbits = bitsfor(universe)
    codemask = uint64(2**qbits - 1)
    q = qbits // 2
    if 4**q != universe:
        raise ValueError(f"Error: hash functions require that {universe=} is 4**k for some k, but 4**{q} = {4**q}.")

    if name.startswith("linear"):
        a = int(name[6:])
        ai = uint64(inversemodpow2(a, int(4**28)))
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, subkey=uint64, st=uint64, b=uint64, f=uint64))
        def get_sub_bucket_fpr(code):
            st, subkey = get_subtable_subkey(code)
            swap = ((subkey << q) ^ (subkey >> q)) & codemask
            swap = (a * swap) & codemask
            f = swap // nbuckets
            b = swap % nbuckets
            return (st, b, f)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, fpr=uint64, bucket=uint64, st=uint64))
        def get_key(st, bucket, fpr):
            subkey = fpr * nbuckets + bucket
            subkey = (ai * subkey) & codemask
            subkey = ((subkey << q) ^ (subkey >> q)) & codemask
            return get_key_from_subtable_subkey(st, subkey)

    elif name.startswith("affine"):
        a, b = name[6:].split("-")
        a = int(a)
        b = uint64(b)
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, subkey=uint64, s=uint64, f=uint64, bucket=uint64))
        def get_sub_bucket_fpr(code):
            st, subkey = get_subtable_subkey(code)
            swap = ((subkey << q) ^ (subkey >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            f = swap // nbuckets
            bucket = swap % nbuckets
            return (st, bucket, f)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, fpr=uint64, bucket=uint64, st=uint64))
        def get_key(st, bucket, fpr):
            subkey = fpr * nbuckets + bucket
            subkey = ((ai * subkey) ^ b) & codemask
            subkey = ((subkey << q) ^ (subkey >> q)) & codemask
            return get_key_from_subtable_subkey(st, subkey)
    else:
        raise ValueError(f"unkown hash function {name}")
    return get_sub_bucket_fpr, get_key


def compile_get_bucket_fpr_from_subkey(name, universe, nbuckets, subtables):
    universe = universe // (4**(int(log(subtables, 4))))
    qbits = bitsfor(universe)
    codemask = uint64(2**qbits - 1)
    q = qbits // 2
    if 4**q != universe:
        raise ValueError(f"Error: hash functions require that {universe=} is 4**k for some k, but 4**{q} = {4**q}.")

    if name.startswith("linear"):
        a = int(name[6:])
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, subkey=uint64, s=uint64, f=uint64, bucket=uint64))
        def get_bucket_fpr(subkey):
            swap = ((subkey << q) ^ (subkey >> q)) & codemask
            swap = (a * swap) & codemask
            f = swap // nbuckets
            bucket = swap % nbuckets
            return (bucket, f)

        @njit(nogil=True, locals=dict(
            code=uint64, swap=uint64, fpr=uint64, bucket=uint64))
        def get_subkey(bucket, fpr):
            subkey = fpr * nbuckets + bucket
            subkey = (ai * subkey) & codemask
            subkey = ((subkey << q) ^ (subkey >> q)) & codemask
            return subkey

    elif name.startswith("affine"):
        a, b = name[6:].split("-")
        a = int(a)
        b = uint64(b)
        ai = uint64(inversemodpow2(a, universe))
        a = uint64(a)

        @njit(nogil=True, locals=dict(
            swap=uint64, subkey=uint64, s=uint64, f=uint64, bucket=uint64))
        def get_bucket_fpr(subkey):
            swap = ((subkey << q) ^ (subkey >> q)) & codemask
            swap = (a * (swap ^ b)) & codemask
            f = swap // nbuckets
            bucket = swap % nbuckets
            return (bucket, f)

        @njit(nogil=True, locals=dict(
            subkey=uint64, swap=uint64, fpr=uint64, bucket=uint64))
        def get_subkey(bucket, fpr):
            subkey = fpr * nbuckets + bucket
            subkey = ((ai * subkey) ^ b) & codemask
            subkey = ((subkey << q) ^ (subkey >> q)) & codemask
            return subkey
    else:
        raise ValueError(f"Unknown or unsupported hash function name: {name}.")

    return get_bucket_fpr, get_subkey


def compile_get_subtable_buckets_fprs_from_key(names, universe, nbuckets, subtables):
    tablename, name1, name2, name3 = names.split(":")

    get_subtable_subkey, get_key_from_subtable_subkey = compile_get_subtable_subkey_from_key(tablename, universe, nbuckets, subtables)
    get_bucket_fpr1, get_subkey1 = compile_get_bucket_fpr_from_subkey(name1, universe, nbuckets, subtables)
    get_bucket_fpr2, get_subkey2 = compile_get_bucket_fpr_from_subkey(name2, universe, nbuckets, subtables)
    get_bucket_fpr3, get_subkey3 = compile_get_bucket_fpr_from_subkey(name3, universe, nbuckets, subtables)
    # get_subkeys = (get_subkey1, get_subkey2, get_subkey3)

    @njit(nogil=True, locals=dict(
        code=uint64, subkey=uint64, s=uint64, p1=uint64, f1=uint64,
        p2=uint64, f2=uint64, p3=uint64, f3=uint64))
    def get_sub_buckets_fprs(code):
        s, subkey = get_subtable_subkey(code)
        p1, f1, = get_bucket_fpr1(subkey)
        p2, f2, = get_bucket_fpr2(subkey)
        p3, f3, = get_bucket_fpr3(subkey)

        return s, p1, f1, p2, f2, p3, f3

    @njit(nogil=True, locals=dict(
        sub=uint64, bucket=uint64, fpr=uint64, hf=uint64,
        subkey=uint64, key=uint64))
    def get_key(sub, bucket, fpr, hf):
        if hf == 1:
            subkey = get_subkey1(bucket, fpr)
        elif hf == 2:
            subkey = get_subkey2(bucket, fpr)
        elif hf == 3:
            subkey = get_subkey3(bucket, fpr)
        key = get_key_from_subtable_subkey(sub, subkey)
        return key

    return get_sub_buckets_fprs, get_key


def get_hashfunctions(firsthashfunc, hashfunc_str, choices, universe, nbuckets, subtables):
    # Define function get_sub_subkey(key) to obtain subtable and reduced code.
    # Define function get_key(sub, subkey) to obtaub jkey back from subtable and reduced code.
    # Define functions get_bf{1,2,3,4}(subkey) to obtain buckets and fingerprints from reduced key.
    # Define functions get_subkey{1,2,3,4}(bucket, fpr) to obtain reduced key back.
    # Example: hashfuncs = 'linear123:linear457:linear999'
    # Example new: 'linear:123,457,999' or 'affine:123+222,457+222,999+222'

    # Turn hashfunc_str into a tuple of names
    hashfunc_tuple = hashfunc_tuple_from_str(hashfunc_str,
        number=choices, mod_value=nbuckets)

    if choices >= 1:
        (get_bf1, get_subkey1) = compile_get_bucket_fpr_from_subkey(
            hashfunc_tuple[0], universe, nbuckets, subtables)
        (get_sbf1, get_key1) = compile_get_subtable_bucket_fpr_from_key(
            firsthashfunc, hashfunc_tuple[0], universe, nbuckets, subtables)
    if choices >= 2:
        (get_bf2, get_subkey2) = compile_get_bucket_fpr_from_subkey(
            hashfunc_tuple[1], universe, nbuckets, subtables)
        (get_sbf2, get_key2) = compile_get_subtable_bucket_fpr_from_key(
            firsthashfunc, hashfunc_tuple[1], universe, nbuckets, subtables)
    if choices >= 3:
        (get_bf3, get_subkey3) = compile_get_bucket_fpr_from_subkey(
            hashfunc_tuple[2], universe, nbuckets, subtables)
        (get_sbf3, get_key3) = compile_get_subtable_bucket_fpr_from_key(
            firsthashfunc, hashfunc_tuple[2], universe, nbuckets, subtables)
    if choices >= 4:
        (get_bf4, get_subkey4) = compile_get_bucket_fpr_from_subkey(
            hashfunc_tuple[3], universe, nbuckets, subtables)
        (get_spf4, get_key4) = compile_get_subtable_bucket_fpr_from_key(
            firsthashfunc, hashfunc_tuple[3], universe, nbuckets, subtables)

    if choices == 1:
        get_bf = (get_bf1,)
        get_sbf = (get_sbf1,)
        get_subkey = (get_subkey1,)
        get_key = (get_key1,)
    elif choices == 2:
        get_bf = (get_bf1, get_bf2)
        get_sbf = (get_sbf1, get_sbf2)
        get_subkey = (get_subkey1, get_subkey2)
        get_key = (get_key1, get_key2)
    elif choices == 3:
        get_bf = (get_bf1, get_bf2, get_bf3)
        get_sbf = (get_sbf1, get_sbf2, get_sbf3)
        get_subkey = (get_subkey1, get_subkey2, get_subkey3)
        get_key = (get_key1, get_key2, get_key3)
    elif choices == 4:
        get_bf = (get_bf1, get_bf2, get_bf3, get_bf4)
        get_sbf = (get_sbf1, get_sbf2, get_sbf3, get_spf4)
        get_subkey = (get_subkey, get_subkey2, get_subkey3, get_subkey4)
        get_key = (get_key1, get_key2, get_key3, get_key4)
    else:
        raise ValueError(f"Only 1 to 4 hash functions are supported, {choices=}")

    finaltuple = (firsthashfunc,) + hashfunc_tuple
    return (finaltuple, get_bf, get_subkey, get_sbf, get_key)
