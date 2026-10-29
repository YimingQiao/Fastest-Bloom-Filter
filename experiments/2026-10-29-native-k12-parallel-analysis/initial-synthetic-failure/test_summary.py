import copy,sys,unittest
from pathlib import Path
import summarize as s
sys.path.insert(0,str(s.SCREEN))
from test_contract import fixture,vector
class Analysis(unittest.TestCase):
 def setUp(self):self.rows=[fixture(c)for c in s.contract.plan()]
 def test_complete_rules_coverage(self):
  d=s.calculate(self.rows);self.assertEqual(d['counts']['alternatives'],3636);self.assertEqual(d['counts']['public_named_pairs'],252);self.assertEqual(d['counts']['quality_mapping_records'],126)
 def test_wilson_fraction_units(self):
  n=1<<26;self.assertAlmostEqual(s.wilson(0,n),1.959963984540054**2/(n+1.959963984540054**2),places=18)
  self.assertLess(s.wilson(1000,n),.0001);self.assertGreater(s.wilson(8000,n),.0001);self.assertEqual(s.wilson(n,n),1.)
 def test_nested_actual_cap(self):
  d=s.calculate(self.rows);v=[r for r in d['query_alternatives']if r['keys']==65536 and r['cap_bpk']==16]
  self.assertTrue(any(r['actual_bytes']<65536*16//8 for r in v));self.assertTrue(all(r['actual_bytes']*8<=65536*16 for r in v))
 def test_one_seed_failure_stays_failed_all_seed(self):
  for entry in self.rows:
   c=entry['case'];p=c['point']
   if c['track']=='shared_query'and p['filter']==s.FAMILIES['k12']and p['keys']==65536:
    bits=int(p['geometry']['filter_bytes'])*8//65536
    if bits==16 or(bits==24 and c['seed']==s.SEEDS[0]):entry['row']['calibration_false_positives']='8000'
  d=s.calculate(self.rows);condition=next(v for v in d['all_seed_conditions']if v['keys']==65536 and v['cap_bpk']==24 and v['target_fpr']==.0001)
  self.assertTrue(all(v['leaders']['optional_native_k12']is None for v in condition['seed_results']))
  views=[v for v in d['query_views']if v['keys']==65536 and v['cap_bpk']==24 and v['target_fpr']==.0001 and v['seed']==s.SEEDS[1]]
  self.assertTrue(all(v['leaders']['optional_native_k12']is not None for v in views))
 def test_missing_rival_not_a_win(self):
  for entry in self.rows:
   if entry['case']['track']=='shared_query'and entry['case']['point']['owner']=='external':entry['row']['calibration_false_positives']=str(1<<26)
  d=s.calculate(self.rows);self.assertTrue(all(v['comparisons']['all_native_composite']['outcome']=='no_comparable'for v in d['query_views']))
 def test_ratio_direction_and_public_separation(self):
  for entry in self.rows:
   if entry['case']['track']=='native_public'and entry['case']['point']['filter']==s.FAMILIES['k12']:
    vector(entry['row'],'lookup_t8_ns','lookup_t8_min_ns','lookup_t8_max_ns','lookup_t8_trials_ns',[.5]*6)
  d=s.calculate(self.rows);pairs=[v for v in d['public_pairs']if v['candidate']==s.FAMILIES['k12']and v['metric']=='lookup_t8_ns'];self.assertTrue(all(v['candidate_over_rival']<1 and v['outcome']=='win'for v in pairs))
  self.assertEqual(len(d['query_views']),216);self.assertEqual(len(d['quality_API']),147)
if __name__=='__main__':unittest.main()
