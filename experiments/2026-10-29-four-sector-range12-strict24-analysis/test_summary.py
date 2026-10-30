import copy
import sys
import unittest
from summarize import SCREEN,calculate,load,CANDIDATE
sys.path.insert(0,str(SCREEN))
from test_runtime import mock_case
from runtime import cases,quality,protocol

def fixture():
    rows=[r for c in cases()for r in mock_case(c)]
    for row in rows:
        row['lookup_ns']=row['hash_lookup_ns']='2.0'if row['filter']==CANDIDATE else'4.0'
        for metric in('lookup','hash_lookup'):
            row[metric+'_trials_ns']='[2,2,2,2,2,2]'if row['filter']==CANDIDATE else'[4,4,4,4,4,4]';row[metric+'_min_ns']=row[metric+'_max_ns']=row[metric+'_ns']
    return rows,quality(rows)

class SummaryTests(unittest.TestCase):
    def test_cardinalities_and_all_named_wins(self):
        v,a,p,s=calculate(*fixture());self.assertEqual((len(v),len(a),len(p),len(s)),(108,648,180,60));self.assertTrue(all(r['outcome']=='win'and r['rival_over_K12']==2 for r in p));self.assertTrue(all(r['wins']==3 for r in s))
    def test_secondary_contains_all_smaller_primary_allocations(self):
        _,a,_,_=calculate(*fixture());rows=[x for x in a if x['track']=='secondary_large_cap32'and x['quality_policy']=='all_three_seeds'];self.assertEqual(len(rows),96);self.assertTrue(any(x['requested_bpk']==24 for x in rows));self.assertTrue(any(x['requested_bpk']==28 for x in rows))
    def test_current_vs_allseed_and_no_omission(self):
        rows,q=fixture();name='FastFilterFixed64'
        for r in q['all_seed_gates']:
            if r['filter']==name:r['all_three_seeds_pass']=False
        v,a,p,s=calculate(rows,q);self.assertTrue(all(not x['eligible']for x in a if x['filter']==name and x['quality_policy']=='all_three_seeds'));self.assertTrue(all(x['eligible']for x in a if x['filter']==name and x['quality_policy']=='current_seed'));self.assertTrue(any(x['rival']==name for x in p))
    def test_losses_ties_and_order_strata_remain(self):
        rows,q=fixture()
        for r in rows:
            if r['filter']=='Split64RangeNative':r['lookup_ns']='1.0';r['hash_lookup_ns']='2.0'
        _,_,p,_=calculate(rows,q);self.assertTrue(any(r['outcome']=='loss'for r in p));self.assertTrue(any(r['outcome']=='tie'for r in p));self.assertEqual(set(r['K12_primary_position']for r in p),{'first','middle','last'})
    def test_candidate_ineligible_and_no_rival(self):
        rows,q=fixture()
        for r in q['all_seed_gates']:
            if r['filter']==CANDIDATE:r['all_three_seeds_pass']=False
        v,_,_,_=calculate(rows,q);self.assertTrue(all(r['K12_vs_external']['outcome']=='candidate_ineligible'for r in v if r['quality_policy']=='all_three_seeds'))
        rows,q=fixture()
        for r in q['all_seed_gates']:
            if r['filter']not in(CANDIDATE,'Split64RangeNative','FastPatternBF','FourSectorBloomFilter'):r['all_three_seeds_pass']=False
        v,_,_,_=calculate(rows,q);self.assertTrue(all(r['K12_vs_external']['outcome']=='no_comparable'for r in v if r['quality_policy']=='all_three_seeds'))
    def test_movable_raw_ref_rejected_before_reading(self):
        for ref in('HEAD','main','abc123','A'*40):
            with self.assertRaises(ValueError):load(ref)
if __name__=='__main__':unittest.main()
