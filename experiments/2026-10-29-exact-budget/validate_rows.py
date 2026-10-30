"""Strict row contract shared by the preflight and the future timed driver."""
import json
import math
import statistics

GEOMETRY = ('budget_bytes','filter_bytes','logical_bytes','geometry_kind','unit_bytes','unit_count',
            'effective_probes','probe_policy','constructor_argument','page_level','native_constructor_bpk')

def validate(rows, expected, *, power, budget, query_power, batch, repeats, seed, calibration_power):
    assert repeats > 0 and repeats % 2 == 0
    names = [row['filter'] for row in rows]
    assert len(names) == len(expected) and set(names) == set(expected) and len(set(names)) == len(names)
    shared = {}
    for row in rows:
        assert None not in row and None not in row.values()
        geometry = expected[row['filter']]
        fields = dict(keys=1 << power, queries=1 << query_power, requested_bpk=budget,
                      hit_percent=50, batch=batch, repeats=repeats, query_repeats=repeats, seed=seed,
                      build_repeats=0, insert_batch=1 << power,
                      calibration_absent_queries=(1 << calibration_power) if calibration_power else 0,
                      harness_hash_scratch_bytes=8 * batch, hash_bits=64)
        for key, value in fields.items(): assert int(row[key]) == value, (row['filter'],key)
        assert row['language'] == 'cpp' and row['measurement_mode'] == 'query_only'
        assert row['budget_mode'] == 'exact_backing_bytes'
        for key in GEOMETRY: assert row[key] == geometry[key], (row['filter'],key,row[key],geometry[key])
        assert 0 < int(row['filter_bytes']) <= int(row['budget_bytes'])
        assert float(row['actual_bpk']) == 8 * int(row['filter_bytes']) / (1 << power)
        assert row['input_mode'] == ('raw_bytes' if row['filter'].startswith('PageBloom') else 'prehashed')
        assert 0 <= int(row['filter_build_scratch_bytes'])
        assert int(row['present_queries']) + int(row['absent_queries']) == 1 << query_power
        assert 0 <= int(row['false_positives']) <= int(row['absent_queries'])
        assert 0 <= int(row['calibration_false_positives']) <= fields['calibration_absent_queries']
        assert float(row['fpr']) == int(row['false_positives']) / int(row['absent_queries'])
        assert 0 <= int(row['result_checksum']) < 1 << 64
        for key in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns'):
            assert math.isnan(float(row[key])), key
        expected_order = ';'.join('H>P' if (seed+r)&1 else 'P>H' for r in range(repeats))
        assert row['query_phase_order'] == expected_order
        for metric in ('lookup','hash_lookup'):
            trials = json.loads(row[metric + '_trials_ns'])
            assert len(trials) == repeats
            if metric == 'lookup' and row['input_mode'] == 'raw_bytes':
                assert all(x is None for x in trials)
                assert all(math.isnan(float(row[metric+s])) for s in ('_ns','_min_ns','_max_ns'))
            else:
                assert all(isinstance(x,(float,int)) and math.isfinite(x) and x > 0 for x in trials)
                assert float(row[metric+'_ns']) == statistics.median(trials)
                assert float(row[metric+'_min_ns']) == min(trials)
                assert float(row[metric+'_max_ns']) == max(trials)
        identity = geometry['calibration_identity']
        sample = tuple(row[key] for key in ('result_checksum','false_positives','calibration_false_positives',
                                           'absent_queries','calibration_absent_queries'))
        assert identity not in shared or shared[identity] == sample, ('identical bitmap sample mismatch',row['filter'])
        shared[identity] = sample
