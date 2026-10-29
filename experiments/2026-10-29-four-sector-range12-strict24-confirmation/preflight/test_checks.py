import csv
import io
import json
from pathlib import Path
import subprocess
import sys
import unittest
from subset_checks import CASES,SEED,expected,order,command,validate_case,check_fixture_domain
from bindings import HERE,PUBLIC,plan

class GuardTests(unittest.TestCase):
    def mock(self,case):
        templates=[]
        for f in sorted((PUBLIC/'caller-validation-v2').glob('*.stdout')):
            text=f.read_text()
            if text.startswith('language,filter,keys'):
                templates=list(csv.DictReader(io.StringIO(text)));break
        self.assertTrue(templates)
        template=templates[0];out=[]
        for name in order(case):
            r=dict(template);r.update(expected(case['cap'])[name]);r.pop('calibration_identity',None)
            r.update(filter=name,keys='1024',queries='4096',requested_bpk=str(case['cap']),hit_percent='50',batch=str(case['batch']),repeats='2',query_repeats='2',seed=str(SEED),build_repeats='0',insert_batch='1024',calibration_absent_queries='4096',harness_hash_scratch_bytes=str(8*case['batch']),hash_bits='64',language='cpp',measurement_mode='query_only',budget_mode='exact_backing_bytes',input_mode='prehashed',present_queries='2050',absent_queries='2046',false_positives='0',fpr='0',result_checksum='1',calibration_false_positives='0',query_phase_order='H>P;P>H')
            r['actual_bpk']=str(8*int(r['filter_bytes'])/1024)
            for metric in ('insert','allocate_insert','hash_insert','allocate_hash_insert'):r[metric+'_ns']='nan'
            for metric in ('lookup','hash_lookup'):r.update({metric+'_trials_ns':'[1.0, 3.0]',metric+'_ns':'2.0',metric+'_min_ns':'1.0',metric+'_max_ns':'3.0'})
            out.append(r)
        return out
    def encoded(self,rows):
        s=io.StringIO();w=csv.DictWriter(s,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows);return s.getvalue()
    def test_full_union_rows(self):
        for case in CASES:self.assertEqual(len(validate_case(self.encoded(self.mock(case)),case)),len(case['names']))
    def test_geometry_formula_and_endpoints(self):
        r=expected(28)['Boost192Multi32K8'];self.assertEqual((r['filter_bytes'],r['logical_bytes'],r['unit_count'],r['constructor_argument']),('3583','3520','110','28160'))
    def test_seed_domain_and_cli(self):
        self.assertEqual(check_fixture_domain()['full_counter_envelope'],[430443552,430452768]);self.assertEqual(command(Path('/bin/frozen'),CASES[0])[7],str((1<<64)-1))
        for case in CASES:
            self.assertEqual(sorted(order(case)),sorted(case['names']))
            self.assertEqual(order(case),plan.order(1024,SEED,case['names'],json.loads((PUBLIC/'registry.json').read_text()),q=4096))
    def test_corrupted_order_and_quality(self):
        case=CASES[0];rows=self.mock(case);rows[0],rows[1]=rows[1],rows[0]
        with self.assertRaises(ValueError):validate_case(self.encoded(rows),case)
        rows=self.mock(case);rows[0]['calibration_false_positives']='4097'
        with self.assertRaises(AssertionError):validate_case(self.encoded(rows),case)
    def test_corrupted_geometry_and_phase(self):
        case=CASES[1];rows=self.mock(case);rows[0]['filter_bytes']='3584'
        with self.assertRaises(AssertionError):validate_case(self.encoded(rows),case)
        rows=self.mock(case);rows[0]['query_phase_order']='P>H;H>P'
        with self.assertRaises(AssertionError):validate_case(self.encoded(rows),case)
    def test_optimized_python_rejects_before_help(self):
        result=subprocess.run([sys.executable,'-O',str(HERE/'validate.py'),'--help'],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0);self.assertFalse(result.stdout);self.assertIn('Use Python without -O',result.stderr)
if __name__=='__main__':unittest.main()
