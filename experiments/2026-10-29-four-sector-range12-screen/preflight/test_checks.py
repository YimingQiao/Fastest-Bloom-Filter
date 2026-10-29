"""Synthetic caller-contract corruption tests; no compiler/Bloom execution."""
import copy
import json
import subprocess
import sys
import unittest
from checks import *
import source_guard

def fixture():
    names=json.loads((STAGE/'registry.json').read_text());plans=[]
    for name in names:
        plans.append(dict(filter=name,filter_bytes='2048',budget_bytes='2048',logical_bytes='2048',geometry_kind='project_four_range24_mapping'if name=='FourSectorRange12Experiment'else'native_pow2_lines',unit_bytes='64',unit_count='32',effective_probes='12'if name=='FourSectorRange12Experiment'else'8',probe_policy='fixed',constructor_argument='2048',page_level='0',native_constructor_bpk='0',implementation_origin='project_experiment'if name=='FourSectorRange12Experiment'else'production_native'))
    selected=['FastPatternBF','FourSectorRange12Experiment'];rows=[]
    for name in ordered(selected):
        row={k:''for k in schema()};row.update(next(p for p in plans if p['filter']==name));row.update(language='cpp',keys='1024',queries='4096',requested_bpk='16',actual_bpk='16.0',hash_bits='64',hit_percent='50',present_queries='2050',batch='31',repeats='2',query_repeats='2',seed='731',insert_ns='nan',allocate_insert_ns='nan',hash_insert_ns='nan',allocate_hash_insert_ns='nan',lookup_ns='2.0',hash_lookup_ns='3.0',absent_queries='2046',false_positives='0',fpr='0.0',lookup_min_ns='1.0',lookup_max_ns='3.0',hash_lookup_min_ns='2.0',hash_lookup_max_ns='4.0',result_checksum='42',input_mode='prehashed',insert_batch='1024',filter_build_scratch_bytes='0',harness_hash_scratch_bytes='248',calibration_absent_queries='4096',calibration_false_positives='0',budget_mode='exact_backing_bytes',measurement_mode='query_only',build_repeats='0',lookup_trials_ns='[1,3]',hash_lookup_trials_ns='[2,4]',query_phase_order='H>P;P>H')
        rows.append(row)
    return rows,plans,selected
class Tests(unittest.TestCase):
    def test_source_identity_and_exact296(self):self.assertGreater(len(source_guard.verify()),500)
    def test_full_row_schema_and_phase(self):
        rows,plans,names=fixture();self.assertEqual(len(validate_case(rows,plans,16,names)),2);self.assertEqual(len(schema()),51)
    def test_corrupt_geometry_trial_phase_raw_timing(self):
        for key,value in[('filter_bytes','2049'),('lookup_ns','2.5'),('lookup_trials_ns','[2,2]'),('query_phase_order','H>P;H>P'),('input_mode','raw_bytes'),('effective_probes','9'),('build_repeats','1')]:
            rows,plans,names=fixture();rows[0][key]=value
            with self.assertRaises((ValueError,AssertionError),msg=key):validate_case(rows,plans,16,names)
    def test_wrong_order_schema_and_semantic(self):
        rows,plans,names=fixture();rows.reverse()
        with self.assertRaises(ValueError):validate_case(rows,plans,16,names)
        rows,plans,names=fixture();rows[0]['unexpected']='1'
        with self.assertRaises(ValueError):validate_case(rows,plans,16,names)
        rows,_,_=fixture();other=copy.deepcopy(rows[0]);other['result_checksum']='43'
        with self.assertRaises(ValueError):same(rows[0],other)
    def test_optimized_python_rejected_before_cli(self):
        p=subprocess.run([sys.executable,'-O',str(source_guard.HERE/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(p.returncode,0);self.assertFalse(p.stdout);self.assertIn('without -O',p.stderr)
if __name__=='__main__':unittest.main()
