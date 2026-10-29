"""Offline corruption tests only: never execute the benchmark or compiler."""
import copy
import csv
import io
import json
from pathlib import Path
import subprocess
import sys
import unittest
from unittest import mock

from source_guard import require_lease

from guard import (BUILD, METRICS, csv_fields, expected_geometry, expected_order, expected_phases,
                   raw_intervals, validate_all, validate_protocol, validate_rows)
from bindings import PUBLIC, artifact
from derive_guard import generate

HERE = Path(__file__).resolve().parent
STAGE = PUBLIC
PROTOCOL = json.loads((HERE / 'protocol.json').read_text())
REGISTRY = json.loads((STAGE / 'registry.json').read_text())
SOURCE = (STAGE / 'benchmark/src/main.rs').read_text()


def mock_rows():
    """Synthetic non-performance rows, with exact independent protocol metadata."""
    result = []
    for case in PROTOCOL['cases']:
        n, q, hit = 1 << case['key_power'], 1 << PROTOCOL['query_power'], PROTOCOL['hit_percent']
        present = q // 100 * hit + min(q % 100, hit)
        for name in expected_order(case, PROTOCOL, SOURCE):
            row = {field: '' for field in csv_fields(SOURCE)}
            row.update(language='rust', filter=name, keys=n, queries=q, requested_bpk=case['budget_bpk'],
                       hash_bits=64, hit_percent=hit, present_queries=present, absent_queries=q-present,
                       batch=case['batch'], repeats=8, seed=case['seed'], insert_batch=n,
                       calibration_absent_queries=1 << 24, calibration_false_positives=11,
                       false_positives=7, fpr=7/(q-present), result_checksum=987,
                       input_mode='prehashed', scalar_track='optimizer_visible_public_single',
                       query_phase_order=expected_phases(case['seed'], 8))
            row.update(expected_geometry(name, n, case['budget_bpk']))
            for key in BUILD:
                row[key] = 2 if key.startswith('allocate') else 1
            for metric in METRICS:
                row[metric + '_ns'] = 4.5
                row[metric + '_min_ns'] = 1
                row[metric + '_max_ns'] = 8
                row[metric + '_trials'] = '1|2|3|4|5|6|7|8'
            result.append({key: str(value) for key, value in row.items()})
    return result


class Guards(unittest.TestCase):
    def setUp(self):
        self.rows = mock_rows()

    def check(self, rows=None):
        return validate_all(self.rows if rows is None else rows, PROTOCOL, REGISTRY, SOURCE)

    def test_full_synthetic_matrix(self):
        self.assertEqual(self.check(), dict(rows=336, cases=18, family_geometry_size_seed_quality_records=112, pooled=False))

    def test_empty_partial_duplicate(self):
        for rows in ([], self.rows[:-1], self.rows + self.rows[:1], [self.rows[1]] + self.rows[1:]):
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_exact_job_order(self):
        self.rows[0], self.rows[1] = self.rows[1], self.rows[0]
        with self.assertRaisesRegex(ValueError, 'order'):
            self.check()

    def test_geometry_fields(self):
        for field, value in [('filter_bytes', '1'), ('unit_bytes', '1'), ('constructor_argument', '1'),
                             ('implementation_origin', 'external'), ('size_contract', 'pow2'),
                             ('probe_policy', 'unknown'), ('effective_probes', '22')]:
            rows = mock_rows()
            target = next(row for row in rows if row['filter'] == 'Split64RangeBloomFilter')
            target[field] = value
            with self.assertRaises(ValueError, msg=field):
                self.check(rows)

    def test_phase_and_vector_corruption(self):
        for field, value in [('query_phase_order', '0|1|2|3'), ('lookup_trials', '1|2'),
                             ('inline_lookup_trials', 'nan|2|3|4|5|6|7|8'),
                             ('hash_lookup_ns', '7'), ('inline_hash_lookup_max_ns', '9'),
                             ('hash_insert_ns', 'nan')]:
            rows = mock_rows()
            rows[0][field] = value
            with self.assertRaises(ValueError, msg=field):
                self.check(rows)

    def test_quality_corruption_and_no_batch_pooling(self):
        for field, value in [('calibration_absent_queries', str(2 << 24)),
                             ('calibration_false_positives', str((1 << 24) + 1)),
                             ('false_positives', '-1'), ('fpr', 'nan')]:
            rows = mock_rows()
            rows[0][field] = value
            with self.assertRaises(ValueError, msg=field):
                self.check(rows)
        self.rows[20]['calibration_false_positives'] = '12'
        with self.assertRaisesRegex(ValueError, 'Cross-batch'):
            self.check()

    def test_case_order_and_cap24_alias_selection(self):
        for mutate in ('order', 'alias'):
            protocol = copy.deepcopy(PROTOCOL)
            if mutate == 'order':
                protocol['cases'][0], protocol['cases'][1] = protocol['cases'][1], protocol['cases'][0]
            else:
                protocol['cases'][3]['filters'].append('Split64BloomFilter')
            with self.assertRaises(ValueError):
                validate_protocol(protocol, REGISTRY, SOURCE)

    def test_changed_source_registry_and_ownership(self):
        with self.assertRaises(ValueError):
            validate_protocol(PROTOCOL, REGISTRY, SOURCE.replace('"Split64RangeBloomFilter",', '"Typo",', 1))
        registry = copy.deepcopy(REGISTRY)
        registry['Split64RangeBloomFilter']['owner'] = 'external'
        with self.assertRaises(ValueError):
            validate_protocol(PROTOCOL, registry, SOURCE)

    def test_fixed_public_grid_has_all12(self):
        for case in PROTOCOL['cases']:
            self.assertEqual({f'Fastbloom017K{k}' for k in range(1,13)},
                {x for x in case['filters'] if x.startswith('Fastbloom017K')})
        row=next(x for x in self.rows if x['filter']=='Fastbloom017K6')
        self.assertEqual(row['effective_probes'],'6')
        row['effective_probes']='11'
        with self.assertRaises(ValueError):self.check()

    def test_exact_guard_derivation(self):
        self.assertEqual((HERE/'guard.py').read_text(),generate())

    def test_structured_cargo_artifact(self):
        item=dict(reason='compiler-artifact',target=dict(name='compare_benchmark',kind=['bin']),
            profile=dict(test=False),executable=str(HERE/'preflight.py'))
        self.assertEqual(artifact(json.dumps(item),False),HERE/'preflight.py')
        with self.assertRaises(ValueError):artifact(json.dumps(item),True)
        with self.assertRaises(ValueError):artifact(json.dumps(item)+'\n'+json.dumps(item),False)

    def test_disjoint_intervals(self):
        for case in PROTOCOL['cases']:
            intervals = raw_intervals(case, PROTOCOL)
            self.assertEqual(intervals['inserted'][1], intervals['timed_negative_envelope'][0])
            self.assertEqual(intervals['timed_negative_envelope'][1], intervals['independent_calibration'][0])
            self.assertEqual(intervals['independent_calibration'][1] - intervals['independent_calibration'][0], 1 << 24)

    def test_actual_inherited_exclusive_lock(self):
        with mock.patch('source_guard.os.environ.get', return_value='socket1-cpu3'), \
             mock.patch('source_guard.os.sched_getaffinity', return_value={3}), \
             mock.patch('source_guard.os.listdir', return_value=['8']), \
             mock.patch('source_guard.os.readlink', return_value='/tmp/fastest-bf-socket1.lock'), \
             mock.patch('source_guard.fcntl.flock') as lock:
            for text in ('', 'lock: 1: FLOCK ADVISORY READ 1 00:00:1 0 EOF'):
                with mock.patch('source_guard.Path.read_text', return_value=text):
                    with self.assertRaisesRegex(ValueError, 'already inherit'):
                        require_lease(3)
            lock.assert_not_called()
            with mock.patch('source_guard.Path.read_text', return_value='lock: 1: FLOCK ADVISORY WRITE 1 00:00:1 0 EOF'):
                self.assertEqual(require_lease(3)['inherited_lock_descriptors'], [8])
                lock.assert_called_once()

    def test_reject_python_optimized_before_work(self):
        for name in ('preflight.py',):
            result = subprocess.run([sys.executable, '-O', str(HERE / name), '--help'], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(result.stdout)
            self.assertIn('without -O', result.stderr)


if __name__ == '__main__':
    unittest.main()
