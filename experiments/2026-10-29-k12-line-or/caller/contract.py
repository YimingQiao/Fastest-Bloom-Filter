"""Small caller smoke contract; no performance interpretation."""
import csv
import io
import json
import math
import statistics

TYPES = ('K12ScalarOrControl', 'K12LineOrCandidate')
CASES = (
    dict(power=6, bpk=24, hit=50, qp=12, batch=31, insert_batch=4, repeats=2, build_repeats=2, seed=74381),
    dict(power=8, bpk=24, hit=50, qp=12, batch=4096, insert_batch=256, repeats=2, build_repeats=2, seed=74381),
)
METRICS = {
    'lookup_trials_ns': 'lookup_ns',
    'hash_lookup_trials_ns': 'hash_lookup_ns',
    'insert_trials_ns': 'insert_ns',
    'allocate_insert_trials_ns': 'allocate_insert_ns',
    'hash_insert_trials_ns': 'hash_insert_ns',
    'allocate_hash_insert_trials_ns': 'allocate_hash_insert_ns',
}
SEMANTICS = ('keys', 'queries', 'requested_bpk', 'filter_bytes', 'actual_bpk', 'hash_bits', 'hit_percent',
             'present_queries', 'absent_queries', 'false_positives', 'result_checksum', 'input_mode',
             'calibration_absent_queries', 'calibration_false_positives', 'logical_bytes', 'effective_probes')

def need(value, message):
    if not value:
        raise RuntimeError(message)

def command(binary, case):
    return [str(binary), str(case['power']), str(case['bpk']), str(case['hit']), str(case['qp']),
            str(case['batch']), str(case['repeats']), str(case['seed']), ','.join(TYPES),
            str(case['insert_batch']), '0', 'full', str(case['build_repeats'])]

def rows(text, case):
    reader = csv.DictReader(io.StringIO(text))
    need(reader.fieldnames and len(reader.fieldnames) == len(set(reader.fieldnames)), 'Duplicate/missing CSV columns')
    result = list(reader)
    need(len(result) == 2 and {r.get('filter') for r in result} == set(TYPES), 'Wrong two-type rows')
    n, q = 1 << case['power'], 1 << case['qp']
    present = q // 100 * case['hit'] + min(q % 100, case['hit'])
    for row in result:
        need(None not in row and all(v is not None for v in row.values()), 'Malformed CSV width')
        expected = dict(keys=n, queries=q, requested_bpk=case['bpk'], filter_bytes=n * 3,
                        batch=case['batch'], repeats=case['repeats'], seed=case['seed'],
                        present_queries=present, absent_queries=q-present, insert_batch=case['insert_batch'],
                        query_repeats=case['repeats'], build_repeats=case['build_repeats'], effective_probes=12,
                        filter_build_scratch_bytes=0, calibration_absent_queries=0, calibration_false_positives=0,
                        harness_hash_scratch_bytes=8*max(case['batch'],case['insert_batch']))
        for key, value in expected.items(): need(int(row[key]) == value, 'Changed row field ' + key)
        need(row['measurement_mode'] == 'full' and row['input_mode'] == 'prehashed', 'Changed measured contract')
        phase_order = ';'.join('H>P' if (case['seed'] + repeat) & 1 else 'P>H' for repeat in range(case['repeats']))
        need(row['query_phase_order'] == phase_order, 'Changed query phase order')
        need(row['implementation_origin'] == 'project_experiment' and float(row['actual_bpk']) == 24, 'Changed geometry')
        need(0 <= int(row['false_positives']) <= q-present, 'Invalid FP count')
        for vector, metric in METRICS.items():
            values = json.loads(row[vector]); count = case['repeats'] if 'lookup' in vector else case['build_repeats']
            need(len(values) == count and all(type(v) in (int,float) and math.isfinite(v) and v > 0 for v in values), 'Invalid trial vector')
            need(math.isclose(statistics.median(values), float(row[metric]), rel_tol=1e-12, abs_tol=1e-12), 'Trial/median mismatch')
        for prefix in ('', 'hash_'):
            pure = json.loads(row[prefix + 'insert_trials_ns'])
            total = json.loads(row['allocate_' + prefix + 'insert_trials_ns'])
            need(all(a >= b for a,b in zip(total,pure)), 'Allocation interval shorter than insertion')
    baseline = tuple(result[0][k] for k in SEMANTICS)
    need(all(tuple(r[k] for k in SEMANTICS) == baseline for r in result), 'Control/candidate semantic mismatch')
    return result
