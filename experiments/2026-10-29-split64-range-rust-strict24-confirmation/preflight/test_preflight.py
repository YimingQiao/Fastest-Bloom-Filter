"""Focused synthetic guards only; no compiler or Bloom process."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch
from subset_guard import *
from bindings import HERE,STAGE,PUBLIC,verify_derivation
from correct_order import derive
from lease import require_lease
PROTOCOL=json.loads((HERE/'runtime-protocol.json').read_text())
REGISTRY=json.loads((PUBLIC/'registry.json').read_text())
SOURCE=(PUBLIC/'benchmark/src/main.rs').read_text()

# Synthetic fixture body reused exactly from frozen336 test_guard.py.
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


class Checks(unittest.TestCase):
    def test_fixed24_and8_unpooled_records(self):
        self.assertEqual(validate_all(mock_rows(),PROTOCOL,REGISTRY,SOURCE),dict(rows=24,cases=12,family_geometry_size_seed_quality_records=8,pooled=False))
    def test_corruption_missing_duplicate_and_old_order(self):
        rows=mock_rows()
        for altered in [rows[:-1],rows+rows[:1],[rows[1],rows[0]]+rows[2:]]:
            with self.assertRaises(ValueError):validate_all(altered,PROTOCOL,REGISTRY,SOURCE)
    def test_all_four_trials_geometry_and_quality_guards_retained(self):
        mutations=[('lookup_trials','1|2'),('hash_lookup_ns','7'),('inline_lookup_max_ns','99'),('inline_hash_lookup_trials','nan|2|3|4|5|6|7|8'),('filter_bytes','1'),('effective_probes','99'),('calibration_absent_queries','33554432')]
        for field,value in mutations:
            rows=mock_rows();rows[0][field]=value
            with self.assertRaises(ValueError,msg=field):validate_all(rows,PROTOCOL,REGISTRY,SOURCE)
        rows=mock_rows();rows[2]['calibration_false_positives']='12'
        with self.assertRaisesRegex(ValueError,'Cross-batch'):validate_all(rows,PROTOCOL,REGISTRY,SOURCE)
    def test_only_declared_guard_functions_change(self):
        self.assertEqual(verify_derivation()['only_functions'],['selected_names','validate_protocol'])
    def test_corrected_order_and_unchanged_inputs(self):
        corrected=derive();self.assertEqual(corrected,json.loads((HERE/'corrected-selection.json').read_text()))
        old=json.loads((STAGE/'selection.json').read_text())
        self.assertEqual(corrected['decisions'],old['decisions'])
        self.assertEqual(corrected['all_external_capacity_quality_support'],old['all_external_capacity_quality_support'])
        self.assertEqual([x['command']for x in corrected['cases']],[x['command']for x in old['cases']])
        for item in corrected['cases']:self.assertEqual(item['expected_filter_order'],expected_order(item['case'],PROTOCOL,SOURCE))
        self.assertEqual(corrected['pre_data_order_correction']['exact_present_queries'],2097154)
    def test_hit_count_matches_direct_source_condition(self):
        for q in [4096,16384,65536]:
            expected=sum(i%100<50 for i in range(q))
            self.assertEqual(expected,q//100*50+min(q%100,50))
        self.assertNotEqual((1<<22)//2,2097154)
    def test_no_lease_and_optimized_python_rejected(self):
        with patch('lease.os.environ.get',return_value='wrong'):
            with self.assertRaises(ValueError):require_lease(3)
        result=subprocess.run([sys.executable,'-O',str(HERE/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertIn('Python -O',result.stderr);self.assertFalse(result.stdout)

if __name__=='__main__':unittest.main()
