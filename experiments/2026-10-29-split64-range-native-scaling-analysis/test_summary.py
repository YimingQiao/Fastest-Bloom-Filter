import copy
import importlib.util
import math
from pathlib import Path
import unittest
from summarize import analyze,quality_records,wilson,PRODUCER

spec=importlib.util.spec_from_file_location('native60_fixture',PRODUCER/'screening/test_contract.py')
fixture=importlib.util.module_from_spec(spec);spec.loader.exec_module(fixture)

def rows():return [row for case in fixture.cases(fixture.PROTOCOL)for row in fixture.fixture(case)]

class AnalysisGuards(unittest.TestCase):
    def test_all_cardinalities_and_languages(self):
        data=analyze(rows())
        self.assertEqual({k:len(data[k])for k in ('quality','same_row','T1','equal_bytes','timings')},dict(quality=20,same_row=180,T1=120,equal_bytes=144,timings=360))
        self.assertFalse(data['losses']);self.assertTrue(all(g['wins']==g['losses']==0 for g in data['groups']))
        self.assertEqual(sum(g['ties']for g in data['groups']),444)
    def test_own_language_and_same_row_serial_control(self):
        source=rows()
        for row in source:
            if row['language']=='rust':row['serial_insert_ns']='8';row['parallel_insert_ns']='4'
        data=analyze(source)
        for r in data['same_row']:
            expected=2 if r['language']=='rust'and r['target_metric']=='parallel_insert'else 1
            self.assertEqual(r['speedup'],expected)
    def test_inclusive_and_query_never_borrow_insert_control(self):
        source=rows();source[0]['serial_insert_ns']='100';source[0]['parallel_allocate_insert_ns']='5';source[0]['parallel_lookup_ns']='10'
        first=analyze(source)['same_row'][:3]
        self.assertEqual([r['speedup']for r in first],[40,.5,.25])
    def test_T1_is_same_public_api_and_keeps_regression(self):
        source=rows()
        for row in source:
            if row['core_budget']=='4':row['parallel_lookup_ns']='5'
        data=analyze(source);selected=[r for r in data['T1']if r['core_budget']==4 and r['target_metric']=='parallel_lookup']
        self.assertEqual(len(selected),20);self.assertTrue(all(r['speedup']==.5 for r in selected))
        self.assertTrue(any(r['source']=='T1'and r['speedup']==.5 for r in data['losses']))
    def test_equal_bytes_excludes_Range24(self):
        pairs=analyze(rows())['equal_bytes']
        self.assertEqual({r['requested_bpk']for r in pairs},{'16','32'})
        self.assertTrue(all(r['baseline_filter']=='Split64'and r['target_filter']=='Split64Range'for r in pairs))
    def test_equal_byte_losses_keep_explicit_family_labels(self):
        source=rows()
        for row in source:
            if row['filter']=='Split64Range':row['parallel_lookup_ns']='5'
        losses=[r for r in analyze(source)['losses']if r['source']=='equal_bytes']
        self.assertEqual(len(losses),24);self.assertTrue(all(r['baseline_filter']=='Split64'and r['target_filter']=='Split64Range'and r['speedup']==.5 for r in losses))
    def test_quality_deduplicates_T_without_pooling_languages(self):
        records=quality_records(rows());self.assertEqual(len(records),20)
        self.assertTrue(all(r['calibration_count']==1<<24 and r['reused_T_rows']==3 and not r['pooled']for r in records))
        changed=rows();changed[4]['calibration_false_positives']='2'
        with self.assertRaises(ValueError):quality_records(changed)
    def test_quality_failure_retained_not_used_as_latency_filter(self):
        source=rows()
        for row in source:row['calibration_false_positives']='1000000'
        data=analyze(source);self.assertEqual(len(data['same_row']),180)
        self.assertTrue(all(not r['passes_1pct']for r in data['quality']))
    def test_partial_and_duplicate_rejected(self):
        source=rows()
        for value in (source[:-1],source[:-1]+source[:1]):
            with self.assertRaises(ValueError):analyze(value)
    def test_wilson_endpoints(self):
        self.assertEqual(wilson(0,100)[0],0);self.assertEqual(wilson(100,100)[1],1)
        low,high=wilson(50,100);self.assertTrue(low<.5<high)
        for fp,n in ((-1,100),(101,100),(0,0)):
            with self.assertRaises(ValueError):wilson(fp,n)
    def test_plot_limits_include_all_languages_and_large_curves(self):
        from plot import limits
        data=analyze(rows())['same_row']
        selected=[r for r in data if r['language']=='rust'and int(r['keys'])==1<<25 and r['target_metric']=='parallel_lookup']
        selected[-1]['speedup']=7.81
        bounds=limits(data);self.assertGreater(bounds['parallel_lookup'],7.81)
        self.assertLess(bounds['parallel_allocate_insert'],bounds['parallel_lookup'])

if __name__=='__main__':unittest.main()
