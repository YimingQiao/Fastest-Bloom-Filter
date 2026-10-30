"""Analysis-only synthetic guards; no current incomplete output is opened."""
import copy
import importlib.util
import json
import unittest
import summarize as s
spec=importlib.util.spec_from_file_location('frozen_k12_fixture',s.SCREEN/'test_run.py');fixture=importlib.util.module_from_spec(spec);spec.loader.exec_module(fixture)
class Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows=fixture.fake_rows();cls.q=s.quality(cls.rows);cls.rules=json.loads((s.SCREEN/'ANALYSIS_RULES.json').read_text())
    def test_immutable_raw_commit_required(self):
        for name in ["HEAD","fd50847","main","F"*40]:
            with self.assertRaises(ValueError):s.load(name)
    def test_declared_complete_counts(self):
        views,rows,candidate=s.calculate(self.rows,self.q,self.rules);self.assertEqual((len(views),len(rows),len(candidate)),(72,5328,216))
    def test_nested_caps_and_public_contract(self):
        _,rows,_=s.calculate(self.rows,self.q,self.rules)
        self.assertTrue(any(r['cap_bpk']==32 and r['actual_bpk']<=16 and r['eligible']for r in rows))
        self.assertTrue(all(not r['contract_valid']for r in rows if r['filter'].startswith('Page')and r['metric']=='lookup_ns'))
        self.assertTrue(any(r['contract_valid']for r in rows if r['filter'].startswith('Page')and r['metric']=='hash_lookup_ns'))
    def test_ownership_range_not_external(self):
        self.assertEqual(s.owner('Split64RangeNative',self.rules),'optional_native_range');self.assertEqual(s.owner(s.CANDIDATE,self.rules),'K12_experiment');self.assertEqual(s.owner('FastFilterFixed64',self.rules),'external')
    def test_candidate_failures_stay_in_all_alternatives(self):
        q=copy.deepcopy(self.q)
        for row in q['mapping_records']:
            if row['candidate']:row['wilson95_high']=1
        views,rows,candidates=s.calculate(self.rows,q,self.rules)
        self.assertEqual(len(candidates),216);self.assertTrue(all(r['K12_vs_external']['outcome']=='candidate_ineligible'for r in views));self.assertEqual(len(rows),5328)
    def test_no_comparable_and_losses(self):
        q=copy.deepcopy(self.q)
        for row in q['mapping_records']:
            if any(s.owner(name,self.rules)=='external'for name in row['apis']):row['wilson95_high']=1
        views,_,_=s.calculate(self.rows,q,self.rules);self.assertTrue(any(r['K12_vs_external']['outcome']=='no_comparable'for r in views))
        rows=copy.deepcopy(self.rows)
        for row in rows:
            if row['filter']==s.CANDIDATE:row['lookup_ns']='999';row['hash_lookup_ns']='999'
        views,_,_=s.calculate(rows,self.q,self.rules);self.assertTrue(any(r['K12_vs_external']['outcome']=='loss'for r in views));self.assertFalse(any(r['K12_vs_external']['outcome']=='win'for r in views))
if __name__=='__main__':unittest.main()
