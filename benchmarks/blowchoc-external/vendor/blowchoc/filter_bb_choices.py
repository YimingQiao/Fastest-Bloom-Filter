"""
filter_bb_choices:
a blocked bloom filter with
- block size 512 (cache line size)
- k bit address hash functions (addressing bits in the same block)
- c block address hash functions (choices for blocks)
The decision in which block a new key is inserted into is based on a cost function.
"""


from collections import namedtuple
from math import ceil

import numpy as np
from numba import njit, uint16, int64, uint64, float64


from .lowlevel import debug  # the global debugging functions
from .lowlevel.bitarray import bitarray
from .hashfunctions import compile_get_bucket
from .subtable_hashfunctions import populate_hashfunc_tuple


BLOCKSIZE = 512  # DO NOT CHANGE

BBChoicesFilter = namedtuple("BBChoicesFilter", [
    # attributes
    "universe",  # save
    "nsubfilters",  # save
    "subfilter_hashfuncs_str",  # save
    "bucket_hashfuncs_str",  # save
    "bit_hashfuncs_str",  # save
    "filtertype",  # save
    "nbits",  # save
    "sigma",  # save
    "theta",  # save
    "beta",  # save
    "mu",  # save
    "slope",  # save
    "bitversion",  # save
    "nchoices",  # save
    "nblocks",  # save
    "nblocks_per_subfilter",  # not saved?
    "bits_per_subfilter",  # not saved?
    "filterbits",  # saved
    "mem_bytes",  # saved
    "array",  # saved separately

    # public API methods; example: f.get_value(f.array, canonical code)
    "insert",  # (fltr:uint64[:], key:uint64, bit_positions:uint64[:])
    "lookup",  # (fltr:uint64[:], key:uint64, bit_positions:uint64[:]) -> boolean
    "get_fpr",  # (fltr:uint64[:]) -> float
    "get_fill",  # (fltr:uint64[:]) -> float
    "get_fill_histogram",  # (fltr:uint64[:]) -> uint64[:BLOCKSIZE+1]; histogram of bucket loads

    # private API methods (see below)
    "private",
])

BBChoicesFilter_private = namedtuple("BBChoicesFilter_private", [
    # private API methods, may change !
    "popcount",
    "get_value_at",
    "set_value_at",
    "get_subfilter",  # (key:uint64) -> uint64
    "get_block",  # (choice:int, key:uint64) -> uint64
    "get_bit_positions",  # (key:uint64, out:uint64[:]) -> None
    "lookup_in_subfilter",  # (fltr:uint64[:], subfilter:uint64, key:uint64, bit_positions:uint64[:]) -> uint64
    "insert_in_subfilter",  # (fltr:uint64[:], subfilter:uint64, key:uint64, bit_positions:uint64[:])
    "lookup_and_insert_in_subfilter",  # (fltr:uint64[:], subfilter:uint64, key:uint64, bit_positions:uint64[:])
    "insert_in_block",
    "lookup_in_block",
    "count_positions_per_lookup",  # (fltr:uint64[:], key:uint64, bit_positions:uint64[:]) -> uint64[:]
    "shm",  # shared memory object
])


def create_BBChoicesFilter(d):
    """
    Return BBChoicesFilter initialized from values in dictionary d
    The given d does not need to provide mem_bytes; it is computed here.
    The given d is copied and reduced to the required fields.
    The hashfuncs tuple is reduced to a single ASCII bytestring.
    """
    d0 = dict(d)
    mem_bytes = 0
    array = d0['array']
    mem_bytes += array.nbytes if array is not None else 0
    d0['mem_bytes'] = mem_bytes
    private = {name: d0[name] for name in BBChoicesFilter_private._fields}
    d0['private'] = BBChoicesFilter_private(**private)
    d1 = {name: d0[name] for name in BBChoicesFilter._fields}
    return BBChoicesFilter(**d1)


def generate_function(function_name, h_name, function_tuple):
    """Generates compiled hash functions"""
    k = len(function_tuple)
    strings = []
    gstring = "global {h_name}_{s}"
    hfstring = "{h_name}_{s} = function_tuple[{s}]"
    for i in range(k):
        strings.append(gstring.format(h_name=h_name, s=i))
        strings.append(hfstring.format(h_name=h_name, s=i))
    strings.append("")
    strings.append("@njit(nogil=True)")
    strings.append(f"def {function_name}(level, key):")
    strings.append("    if level == 0:")
    strings.append(f"        return {h_name}_0(key)")
    s1 = "    elif level == {s}:"
    s2 = "        return {h_name}_{s}(key)"
    for i in range(1, len(function_tuple)):
        strings.append(s1.format(s=i))
        strings.append(s2.format(h_name=h_name, s=i))
    strings.append("    else:")
    strings.append("        raise RuntimeError('Wrong level')")
    f_string = "\n".join(strings)
    my_local_namespace = locals()
    my_global_namespace = globals()
    exec(f_string, my_global_namespace, my_local_namespace)
    return my_local_namespace[function_name]


def generate_function_bit_positions(function_name, h_name, function_tuple):
    """Generates compiled function to compute bit positions"""
    k = len(function_tuple)
    strings = []
    gstring = "global {h_name}_{s}"
    hfstring = "{h_name}_{s} = function_tuple[{s}]"
    for i in range(k):
        strings.append(gstring.format(h_name=h_name, s=i))
        strings.append(hfstring.format(h_name=h_name, s=i))
    strings.append("")
    strings.append("@njit(nogil=True)")
    strings.append(f"def {function_name}(key, bit_positions):")
    setstring = "    bit_positions[{b}] = {h_name}_{b}(key)"
    for i in range(0, k):
        strings.append(setstring.format(h_name=h_name, b=i))
    f_string = "\n".join(strings)
    my_local_namespace = locals()
    my_global_namespace = globals()
    exec(f_string, my_global_namespace, my_local_namespace)
    return my_local_namespace[function_name]


def get_mod_values(bitversion, k):
    """Computes the modulo and offset values to correctly compute the bit positions using different strategies"""
    # use 512, 511, 510, ..., 512-k+1 as mod values to compute k distinct bit positions
    if bitversion == 'distinct':
        mod_values = tuple(BLOCKSIZE - i for i in range(k))
        return mod_values
    # compute k random positions using a mod value of 512
    if bitversion == 'random':
        mod_values = (BLOCKSIZE,) * k
        return mod_values
    if bitversion == 'double':
        mod_values = (BLOCKSIZE, BLOCKSIZE // 2)
        return mod_values
    raise ValueError(f"ERROR: get_mod_values: {bitversion=} is not supported.")


def build_from_info(filterinfo, init=True, shm=None):
    subfilter_hashfuncs_str = filterinfo['subfilter_hashfuncs_str']
    bucket_hashfuncs_str = filterinfo['bucket_hashfuncs_str']
    bit_hashfuncs_str = filterinfo['bit_hashfuncs_str']
    universe = filterinfo['universe']
    nsubfilters = filterinfo['nsubfilters']
    nblocks = filterinfo['nblocks']
    nchoices = filterinfo['nchoices']
    nbits = filterinfo['nbits']
    sigma = filterinfo['sigma']
    theta = filterinfo['theta']
    beta = filterinfo['beta']
    mu = filterinfo['mu']
    slope = filterinfo['slope']
    bitversion = filterinfo['bitversion']
    fltr = build_filter(
        universe, nsubfilters, nblocks, nchoices, nbits,
        bitversion=bitversion,
        sigma=sigma, theta=theta,
        beta=beta, mu=mu, slope=slope,
        subfilter_hashfuncs_str=subfilter_hashfuncs_str,
        bucket_hashfuncs_str=bucket_hashfuncs_str,
        bit_hashfuncs_str=bit_hashfuncs_str,
        init=init, shm=shm,
    )
    return fltr


def build_filter(
    universe,  # size of key universe (int)
    nsubfilters,  # number of subfilters
    nblocks,  # total number of blocks
    nchoices,  # number of choices (alternative block locations)
    nbits,  # number of set bits per key
    *,  # NEW: all cost function parameters are keyword-only now!
    bitversion='random',  # str in {'random', 'distinct'} or other useless methods
    sigma=-1.0,  # float: weight in cost function to select the block with lowest cost
    theta=-1,  # 0 or 1: weight in cost function to select the block with lowest cost
    beta=-1.0,  # parameter for alternative cost function
    mu=-1.0,  # parameter for alternative cost function
    slope=-1.0,  # parameter for linear cost function
    subfilter_hashfuncs_str=None,  # hashfunction string to select subfilter
    bucket_hashfuncs_str=None,  # hashfunction string to select block
    bit_hashfuncs_str=None,  # hashfunction string to select bits
    mockup=False,  # only create a stub (no memory allocation; omit some functions)
    init=True, shm=None  # shared memory support
):
    """
    Allocate an array and compile access methods for a blocked bloom filter with choices.
    For each element, nbits bits are set in a 512 cache-aligned block (or bucket)
    using different bitversions to select the bits (random, distinct or blocks).
    From nchoices possible blocks, the block with lowest cost is selected.
    The cost function to select a block has parameters sigma, theta and mu.
    The filter is parallelized into nsubfilters independent subfilters.
    Return a BBChoicesFilter object.
    """

    # Get debug printing functions and set basic properties
    debugprint0, debugprint1, debugprint2 = debug.debugprint
    filtertype = "bb_choices"  # blocked bloom filter with choices
    blocksize = BLOCKSIZE

    debugprint1(f"- Using {nsubfilters} subfilters.")
    debugprint1(f"- Expected number of blocks: {nblocks:_}")
    nblocks_per_subfilter = int(ceil(nblocks / nsubfilters))
    nblocks_per_subfilter += (nblocks_per_subfilter % 2 == 0)
    nblocks = nblocks_per_subfilter * nsubfilters
    debugprint1(f"- Number of blocks per subfilter: {nblocks_per_subfilter:_}")
    debugprint1(f"- Number of blocks: {nblocks:_}")
    assert nblocks_per_subfilter % 2 == 1

    bits_per_subfilter = blocksize * nblocks_per_subfilter
    assert bits_per_subfilter % blocksize == 0

    filterbits = nsubfilters * bits_per_subfilter

    if not mockup:
        if init is True:
            flt = bitarray(filterbits, alignment=64)
            debugprint2(f"- allocated {flt.array.dtype} filter of shape {flt.array.shape}.")
        elif init is False:
            flt = bitarray(0)
            debugprint2("- allocated NOTHING, because init=False")
        elif isinstance(init, np.ndarray):
            flt = bitarray(init)
            debugprint2("- used existing numpy array")
        else:
            raise ValueError(f"{init=} is not a supported option.")

        get_value_at = flt.getquick  # (array, startbit)
        set_value_at = flt.setquick  # (array, startbit[, value])
        popcount = flt.popcount
        prefetch = flt.prefetch
    else:
        # for mock-ups, essentially to only compile hash functions
        flt = get_value_at = set_value_at = popcount = prefetch = None

    # Get all hash functions for the filters
    # Get the hash function which determines the subfilter
    if subfilter_hashfuncs_str is None:
        subfilter_hashfuncs_str = populate_hashfunc_tuple(("random",), mod_value=nsubfilters)
    debugprint2(f"- using {subfilter_hashfuncs_str=}")
    get_subfilter = compile_get_bucket(subfilter_hashfuncs_str[0], universe, nsubfilters)

    # Get hash function which determines the bucket in the subfilters
    if bucket_hashfuncs_str is None:
        bucket_hashfunc_tup = tuple("random" for _ in range(nchoices))
        bucket_hashfuncs_str = populate_hashfunc_tuple(bucket_hashfunc_tup, mod_value=nblocks_per_subfilter)
    debugprint2(f"- using {bucket_hashfuncs_str=}")
    bucket_hashfuncs = [compile_get_bucket(hfi, universe, nblocks_per_subfilter) for hfi in bucket_hashfuncs_str]
    get_block = generate_function("get_block", "block_hf", bucket_hashfuncs)

    # Compute the offset for the sub-blocks and mod values (sub-block sizes) for the different bit versions
    mod_values = get_mod_values(bitversion, nbits)
    assert (len(mod_values) == nbits) or (len(mod_values) == 2 and bitversion == 'double')

    # Get the hash functions which determine the bits which are set inside a block
    if bit_hashfuncs_str is None:
        bit_hashfunc_tup = tuple("random" for _ in range(len(mod_values)))
        bit_hashfuncs_str = populate_hashfunc_tuple(bit_hashfunc_tup, mod_value=list(mod_values))
    debugprint2(f"- using {bit_hashfuncs_str=}")
    bit_hashfuncs = [compile_get_bucket(bit_hashfuncs_str[i], universe, mod_values[i]) for i in range(len(mod_values))]

    if bitversion in ('random', 'distinct'):
        get_bits = generate_function_bit_positions("get_bit_positions", "bit_hf", bit_hashfuncs)
    elif bitversion == 'double':
        get_bits = generate_function("get_bit_positions", "bit_hf", bit_hashfuncs)
    else:
        raise RuntimeError(f'ERROR: bitversion {bitversion} not supported!')

    maxfloat64 = float64(np.finfo(np.float64).max)

    @njit(nogil=True, locals=dict(pos=uint16))
    def _get_bit_positions_distinct(key, bit_positions):
        # compute bit positions for key
        get_bits(key, bit_positions)
        for b in range(nbits):
            pos = bit_positions[b]  # new position to insert
            i = 0
            while i < b and pos >= bit_positions[i]:
                pos += 1
                i += 1
            # assert 0 <= pos < BLOCKSIZE
            # move bit_positions[i:b] to the right -> [i+1:b+1]
            # [b-1] -> [b], [b-2] -> [b-1] ... [i] -> [i + 1]; [i] now free
            # insert pos at bit_positions[i]; new last used index is then b.
            for j in range(b - 1, i - 1, -1):
                bit_positions[j + 1] = bit_positions[j]
            bit_positions[i] = pos

    @njit(nogil=True, locals=dict(pos=uint16, offset=uint64))
    def _get_bit_positions_double(key, bit_positions):
        pos = get_bits(0, key)
        offset = get_bits(1, key) * 2 + 1  # mod value is 256, max value is 255, 255 * 2 + 1 = 511, all values are odd and between 1 and 511
        for b in range(nbits):
            bit_positions[b] = (pos + offset * b) % 512

    # get_bit_positions = get_bits if bitversion == 'random' else _get_bit_positions_distinct
    if bitversion == 'random':
        get_bit_positions = get_bits
    elif bitversion == 'distinct':
        get_bit_positions = _get_bit_positions_distinct
    elif bitversion == 'double':
        get_bit_positions = _get_bit_positions_double

    @njit(nogil=True)
    def cost_function_scaled(nbits_set, nnew_bits):
        """
        Computes cost function with parameters sigma and theta considering local FPR and number of newly set bits
        """
        q = nnew_bits + nbits_set  # how many set bits after setting
        return sigma * nbits * ((2 * q / blocksize) ** nbits) + theta * nnew_bits  # sigma > 0, theta in {0, 1}

    @njit(nogil=True)
    def cost_function_lookahead(nbits_set, nnew_bits):
        """
        Computes cost function with parameter mu and local FPR (after inserting mu * k additional bits) and number of newly set bits
        """
        q = nnew_bits + nbits_set + mu * nbits  # how many set bits after setting and additional mu * k bits
        return nbits * ((2 * q / blocksize) ** nbits) + nnew_bits

    blocksize4 = blocksize // 4

    @njit(nogil=True)
    def cost_function_exp(nbits_set, nnew_bits):
        """
        Computes cost function with parameter beta
        """
        q = nnew_bits + nbits_set  # how many set bits after setting
        return beta**(q / blocksize4) + mu * (nnew_bits / nbits)

    @njit(nogil=True)
    def cost_function_linear(nbits_set, nnew_bits):
        """
        Computes cost function with parameter beta
        """
        q = nnew_bits + nbits_set  # how many set bits after setting
        return slope * q + nnew_bits

    if beta > 0.0:
        cost_function = cost_function_exp
    elif mu > 0.0:
        cost_function = cost_function_lookahead
    elif theta > 0.0 or sigma > 0.0:
        cost_function = cost_function_scaled
    elif slope > 0.0:
        cost_function = cost_function_linear
    elif mockup:
        pass  # don't care about nonsense cost functions
    else:
        raise ValueError(f"Illegal parameter combination for cost function: {beta=}, {mu=}, {theta=}, {sigma=}, {slope=}")

    @njit(nogil=True, locals=dict(
        block=uint64, best_block=uint64,
        error=float64, best_error=float64, next_block=uint64,
        start=uint64, end=uint64, nbits_set=uint64, already_set_bits=uint64,
        nnew_bits=uint64, pos=uint64, inner_cost=float64,
        w=uint64))
    def find_block(fltr, sf_start_block, key, bit_positions):
        # return block number where to insert
        # after evaluating cost functions
        if nchoices == 1:
            block = get_block(0, key)
            prefetch(fltr, (sf_start_block + block) * blocksize)
            get_bit_positions(key, bit_positions)
            return sf_start_block + block

        for c in range(nchoices):
            block = sf_start_block + get_block(c, key)
            prefetch(fltr, block * blocksize)

        get_bit_positions(key, bit_positions)
        best_error = maxfloat64
        best_block = 0
        for c in range(nchoices):
            # get block
            block = sf_start_block + get_block(c, key)

            # get number of bits set
            start = block * blocksize
            end = start + blocksize
            nbits_set = popcount(fltr, start, end)
            # check how many new bits will be set
            already_set_bits = 0
            for b in range(nbits):
                pos = start + bit_positions[b]
                already_set_bits += get_value_at(fltr, pos)
            nnew_bits = nbits - already_set_bits
            if nnew_bits == 0:
                return block

            error = cost_function(nbits_set, nnew_bits)
            if error < best_error:
                best_error = error
                best_block = block
        return best_block

    if mockup:
        find_block = None  # noqa: F811

    @njit(nogil=True, locals=dict(
        block=uint64, pos=uint64, offset=uint64))
    def insert_in_block(fltr, block, bit_positions, value):
        offset = block * blocksize
        for b in range(nbits):
            pos = offset + bit_positions[b]
            set_value_at(fltr, pos, value)

    @njit(nogil=True, locals=dict(
        offset=uint64, block=uint64, pos=uint64, bf=uint64))
    def lookup_in_block(fltr, block, bit_positions):
        offset = block * blocksize
        for b in range(nbits):
            bf = bit_positions[b]
            pos = offset + bf
            if not get_value_at(fltr, pos):
                return uint64(0)
        return uint64(1)

    @njit(nogil=True, locals=dict(
        block=uint64, sf_start_block=uint64))
    def insert_in_subfilter(fltr, subfilter, key, bit_positions):
        # compute bit positions for key
        sf_start_block = subfilter * nblocks_per_subfilter

        block = find_block(fltr, sf_start_block, key, bit_positions)
        insert_in_block(fltr, block, bit_positions, 1)

    @njit(nogil=True)
    def insert(fltr, key, bit_positions):
        subfilter = get_subfilter(key)
        insert_in_subfilter(fltr, subfilter, key, bit_positions)

    @njit(nogil=True, locals=dict(start_block=uint64, next_block=uint64, block=uint64, v=uint64))
    def lookup_in_subfilter(fltr, subfilter, key, bit_positions):
        # find bit positions
        start_block = subfilter * nblocks_per_subfilter
        for c in range(nchoices):
            block = start_block + get_block(c, key)
            prefetch(fltr, block * blocksize)

        get_bit_positions(key, bit_positions)

        for c in range(nchoices):
            block = start_block + get_block(c, key)
            if lookup_in_block(fltr, block, bit_positions):
                return uint64(1)
        return uint64(0)

    @njit(nogil=True)
    def lookup_and_insert_in_subfilter(fltr, subfilter, key, bit_positions):
        if not lookup_in_subfilter(fltr, subfilter, key, bit_positions):
            insert_in_subfilter(fltr, subfilter, key, bit_positions)

    @njit(nogil=True)
    def lookup(fltr, key, bit_positions):
        subfilter = get_subfilter(key)
        return lookup_in_subfilter(fltr, subfilter, key, bit_positions)

    @njit(nogil=True)
    def get_fill(fltr):
        set_bits = popcount(fltr, 0, filterbits)
        return set_bits / filterbits

    @njit(nogil=True)
    def get_fill_histogram(fltr):
        count = np.zeros(BLOCKSIZE + 1, dtype=np.int64)
        for subtable in range(nsubfilters):
            sf_start = subtable * bits_per_subfilter
            for block in range(nblocks_per_subfilter):
                start = sf_start + block * 512
                load = popcount(fltr, start, start + 512)
                count[load] += 1
        return count

    @njit(nogil=True)
    def get_fpr(fltr):
        overall_fpr = 0.0
        for i in range(nblocks):
            n_bits_set = popcount(fltr, i * BLOCKSIZE, i * BLOCKSIZE + BLOCKSIZE)
            block_fpr = float64(n_bits_set / BLOCKSIZE) ** nbits
            overall_fpr += block_fpr
        overall_fpr /= nblocks
        overall_fpr *= nchoices
        return overall_fpr

    @njit(nogil=True)
    def count_positions_per_lookup(fltr, key, bit_positions):
        subfilter = get_subfilter(key)
        get_bit_positions(key, bit_positions)
        start_block = subfilter * nblocks_per_subfilter

        lookups = np.zeros(nchoices, dtype=np.uint64)
        for c in range(nchoices):
            block = start_block + get_block(c, key)
            offset = block * blocksize
            for b in range(nbits):
                pos = offset + bit_positions[b]
                lookups[c] += 1
                if get_value_at(fltr, pos) == 0:
                    break
        return lookups

    array = flt.array if not mockup else None
    return create_BBChoicesFilter(locals())


def calc_bit_usage(my_filter):
    """
    Compute histogram over all blocks.
    For good hash function, the histogram should have
    a uniform distribution.
    """
    get_value_at = my_filter.private.get_value_at
    nblocks = my_filter.nblocks

    @njit(locals=dict(
        start=int64, bit=int64))
    def _count_bits(fltr, counts):
        for b in range(nblocks):
            start = b * BLOCKSIZE
            for bit in range(BLOCKSIZE):
                counts[bit] += get_value_at(fltr, start + bit)

    counts = np.zeros(BLOCKSIZE, dtype=np.int64)
    _count_bits(my_filter.array, counts)
    return counts
