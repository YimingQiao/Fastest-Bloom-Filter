import copy,math,sys,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent;SCREEN=HERE.parent/'2026-10-29-fastbloom-rs-raw8-screen-plan/screening'
sys.path.insert(0,str(SCREEN))
import fixtures,contract
from summarize import analyze,comparison,wilson,leaders
class Rules(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.rows=fixtures.rows();cls.quality=contract.quality(cls.rows);cls.result=analyze(cls.rows,cls.quality)
 def test_all_counts_and_failures_retained(self):
  self.assertEqual(self.result['counts']['alternatives'],28296);self.assertEqual(len(self.result['fixed_default_ratios']),864)
  self.assertTrue(any(not r['fits_cap']for r in self.result['alternatives']));self.assertTrue(any(not r['quality_pass']for r in self.result['alternatives']))
 def test_nested_smaller_allocations(self):
  rows=[r for r in self.result['alternatives']if r['cap_bpk']==32 and r['requested_bpk']==16];self.assertTrue(rows);self.assertTrue(all(r['fits_cap']for r in rows))
 def test_distinct_owners_and_exact_ties(self):
  view=self.result['views'][0];self.assertEqual(len(view['leaders']['all_registered']['configuration_ids']),sum(x['eligible']for x in self.result['alternatives'][:131]))
  self.assertIn('retained_external',view['leaders']);self.assertIn('new_raw8_external',view['leaders'])
 def test_no_comparable_not_win(self):
  self.assertEqual(comparison(None,1)['outcome'],'no_comparable');self.assertEqual(comparison(1,None)['outcome'],'no_comparable');self.assertEqual(comparison(1,0)['outcome'],'no_comparable')
  self.assertEqual(leaders([],{'retained_external'})['configuration_ids'],[])
 def test_ratio_direction(self):
  self.assertEqual(comparison(2,1),{'ratio':2.0,'outcome':'win'});self.assertEqual(comparison(1,2)['outcome'],'loss');self.assertEqual(comparison(1,1)['outcome'],'tie')
 def test_wilson_fraction_endpoints(self):
  self.assertEqual(wilson(0,100)[0],0);self.assertEqual(wilson(100,100)[1],1);self.assertTrue(0<wilson(10,100)[0]<0.1<wilson(10,100)[1]<1)
  with self.assertRaises(ValueError):wilson(0,0)
 def test_no_pooling_or_wrong_alias_count(self):
  q=copy.deepcopy(self.quality);q['api_records'][0]['calibration_absent_queries']*=3
  with self.assertRaises(ValueError):analyze(self.rows,q)
  q=copy.deepcopy(self.quality);q['api_records'][1]['mapping_identity']=q['api_records'][0]['mapping_identity']
  with self.assertRaises(ValueError):analyze(self.rows,q)
 def test_query_and_build_remain_separate(self):
  for metric in ['raw_batched_public','raw_visible_public','raw_insert','allocate_filter_and_scratch_raw_insert']:self.assertEqual(sum(v['metric']==metric for v in self.result['views']),54)
  self.assertEqual(len({tuple(a['trials'])for a in self.result['alternatives'][:524]}),4)
if __name__=='__main__':unittest.main()
