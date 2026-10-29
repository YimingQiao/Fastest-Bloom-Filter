"""Finite row/input checks for the untimed 16-construction pilot."""
import json
import math
from functools import lru_cache

MASK = (1 << 64) - 1
INC = 0x9e3779b97f4a7c15
CANDIDATE = 'Independent32RangeBloomFilter'
CONTROL = 'Independent32BloomFilter'
GATES = {'1pct': .01, '0.1pct': .001, '0.01pct': .0001}
DIGESTS = ('inserted_digest', 'inserted_hash_digest', 'query_digest', 'query_hash_digest',
           'bitmap_digest', 'mixed_digest', 'calibration_digest', 'physical_owner_digest')
FIELDS = set(('filter mapping backend key_power keys seed actual_bpk constructor_bpk budget_bytes '
 'actual_bytes logical_bytes physical_line_bytes physical_lines bucket_bytes buckets probes parallel_api '
 'inserted_checked physical_owner_digest key_base inserted_digest inserted_hash_digest query_digest '
 'query_hash_digest bitmap_digest mixed_digest queries requested_hit_percent present absent mixed_fp '
 'calibration_power calibration_negatives calibration_begin calibration_end calibration_fp calibration_digest '
 'wilson_upper qualifies query_repeats build_repeats timing_available').split())


def need(ok, why):
    if not ok:
        raise ValueError(why)


def unique(pairs):
    d = {}
    for k, v in pairs:
        need(k not in d, 'duplicate JSON field')
        d[k] = v
    return d


def read(text):
    def bad(value):
        raise ValueError('nonfinite JSON: ' + value)
    return json.loads(text, object_pairs_hook=unique, parse_constant=bad)


def mix(state):
    x = state & MASK
    x = ((x ^ (x >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    x = ((x ^ (x >> 27)) * 0x94d049bb133111eb) & MASK
    return x ^ (x >> 31)


def common_hash(x):
    x = ((x ^ (x >> 32)) * 0xd6e8feb86659fd93) & MASK
    x = ((x ^ (x >> 32)) * 0xd6e8feb86659fd93) & MASK
    return x ^ (x >> 32)


def digest(values):
    d = 14695981039346656037
    for x in values:
        d = ((d ^ x) * 1099511628211) & MASK
    return d


@lru_cache(None)
def query_input(n):
    # One draw chooses base, n-1 inserted-shuffle draws; no large Python array.
    base = mix(42 + INC) % ((1 << 32) - n - 4096)
    state = (42 + n * INC) & MASK
    query = []
    for i in range(4096):
        if i % 100 < 50:
            state = (state + INC) & MASK
            query.append(base + mix(state) % n)
        else:
            query.append(base + n + i)
    for i in range(4096, 1, -1):
        state = (state + INC) & MASK
        j = mix(state) % i
        query[i - 1], query[j] = query[j], query[i - 1]
    return base, tuple(query)


def upper(fp, count):
    z = 1.959963984540054
    p = fp / count
    return min(1.0, (p + z*z/(2*count) + z*math.sqrt((p*(1-p)+z*z/(4*count))/count)) /
                    (1+z*z/count))


def validate(row, power, bpk, candidate, cal):
    need(type(row) is dict and set(row) == FIELDS, 'row schema')
    n, count, budget = 1 << power, 1 << cal, (1 << power) * bpk // 8
    base, query = query_input(n)
    expected = dict(filter=CANDIDATE if candidate else CONTROL,
        mapping='high24-range/low40-independent8-v1' if candidate else 'high23-mask/low40-independent8-v1',
        backend='avx512vbmi-vl', key_power=power, keys=n, seed=42, actual_bpk=bpk,
        constructor_bpk=bpk if candidate else bpk//2, budget_bytes=budget, actual_bytes=budget,
        logical_bytes=budget, physical_line_bytes=64, physical_lines=budget//64,
        bucket_bytes=32, buckets=budget//32, probes=8, parallel_api=False,
        inserted_checked=n, key_base=base, queries=4096, requested_hit_percent=50,
        present=2050, absent=2046, calibration_power=cal, calibration_negatives=count,
        calibration_begin=base+n+4096, calibration_end=base+n+4096+count,
        query_digest=digest(query), query_hash_digest=digest(map(common_hash, query)),
        query_repeats=0, build_repeats=0, timing_available=False)
    for k, v in expected.items():
        need(type(row[k]) is type(v) and row[k] == v, 'field mismatch: ' + k)
    for k in DIGESTS:
        need(type(row[k]) is int and 0 <= row[k] <= MASK, 'invalid digest: ' + k)
    need(type(row['mixed_fp']) is int and 0 <= row['mixed_fp'] <= 2046, 'mixed count')
    need(type(row['calibration_fp']) is int and 0 <= row['calibration_fp'] <= count, 'calibration count')
    u = upper(row['calibration_fp'], count)
    need(type(row['wilson_upper']) in (float, int) and math.isfinite(row['wilson_upper']) and
         math.isclose(row['wilson_upper'], u, rel_tol=1e-13, abs_tol=1e-15), 'Wilson endpoint')
    need(type(row['qualifies']) is dict and row['qualifies'] == {k: u <= v for k, v in GATES.items()} and
         all(type(v) is bool for v in row['qualifies'].values()), 'quality gates')


def parse(stdout, power, formal):
    rows = [read(line) for line in stdout.decode().splitlines()]
    points = [(True, b) for b in (12,16,20,24,28,32)] + [(False,b) for b in (16,32)] if formal else [(True,12),(False,16)]
    need(len(rows) == len(points), 'exact row count required')
    for row, (candidate, bpk) in zip(rows, points):
        validate(row, power, bpk, candidate, 26 if formal else 10)
    shared = ('key_base','inserted_digest','inserted_hash_digest','query_digest','query_hash_digest',
              'calibration_begin','calibration_end','calibration_negatives')
    need(all(tuple(r[k] for k in shared) == tuple(rows[0][k] for k in shared) for r in rows),
         'construction/input identity changed across geometries')
    return rows


def decision(rows):
    need(len(rows) == 16, 'retain all 16 rows before decision')
    expected = [(p, c, b) for p in (16,25) for c,b in
                ([(True,b) for b in (12,16,20,24,28,32)] + [(False,b) for b in (16,32)])]
    for row,(power,candidate,bpk) in zip(rows,expected): validate(row,power,bpk,candidate,26)
    primary = [r for r in rows if r['filter'] == CANDIDATE and r['actual_bpk'] == 12]
    passed = all(r['qualifies']['1pct'] for r in primary)
    return {'primary_12bpk_both_sizes_pass': passed,
            'next_stage': 'separate_timing_source_review_required' if passed else 'stop_before_timing',
            'secondary': {str(b): all(r['qualifies'][gate] for r in rows
                 if r['filter'] == CANDIDATE and r['actual_bpk'] == b)
                 for b,gate in ((20,'0.1pct'),(28,'0.01pct'))},
            'rows_retained': 16, 'separate_mapping_geometry_records': 16,
            'pooled_negatives': False, 'timing_authorized': False}
