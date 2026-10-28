"""Synthetic/offline analysis checks; no benchmark runs or measured inputs generated."""
import math
import unittest
import summarize as s
class Analysis(unittest.TestCase):
    def test_wilson_endpoints_and_invalid_counts(self):
        self.assertEqual(s.wilson(0,1000)[0],0)
        self.assertEqual(s.wilson(1000,1000)[1],1)
        z2=1.959963984540054**2
        self.assertAlmostEqual(s.wilson(0,1000)[1],z2/(1000+z2),places=15)
        for fp,n in [(0,0),(-1,1000),(1001,1000)]:
            with self.assertRaises(ValueError):s.wilson(fp,n)
    def test_quality_deduplicates_known_reuse_without_pooling_seeds(self):
        rows=[]
        for seed in range(1,7):
            for family in [s.ORIGINAL,s.CANDIDATE,s.EXTERNAL]:
                for batch in [1,31]:
                    rows.append(dict(filter=family,batch=str(batch),keys='65536',requested_bpk='8',actual_bpk='16',filter_bytes='131072',seed=str(seed),calibration_false_positives=str(seed),calibration_absent_queries='1000'))
        records,worst=s.quality(rows)
        self.assertEqual((len(records),len(worst)),(12,2))
        self.assertTrue(all(x['negatives']==1000 for x in records))
        self.assertTrue(all(x['worst_wilson_upper']==s.wilson(6,1000)[1] for x in worst))
        self.assertGreater(worst[0]['worst_wilson_upper'],s.wilson(21,6000)[1])
    def test_order_strata_and_unbalanced_rejection(self):
        rows=[dict(keys=65536,requested_bpk=8,batch=3,metric='lookup_ns',candidate_first=i<3,original_over_candidate=value) for i,value in enumerate([1,2,4,.5,1,2])]
        allgroups,strata=s.pair_aggregates(rows)
        self.assertAlmostEqual(allgroups[0]['geomean_original_over_candidate'],math.sqrt(2))
        by_order={r['candidate_first']:r for r in strata}
        self.assertAlmostEqual(by_order[True]['geomean_original_over_candidate'],2)
        self.assertAlmostEqual(by_order[False]['geomean_original_over_candidate'],1)
        self.assertEqual(by_order[True]['exact_ties'],1)
        rows[3]['candidate_first']=True
        with self.assertRaises(ValueError):s.pair_aggregates(rows)
    def test_smaller_external_allocation_competes_under_larger_cap(self):
        rows=[];worst=[]
        for family in [s.ORIGINAL,s.EXTERNAL]:
            for bpk in [8,16]:
                worst.append(dict(family=family,keys=65536,requested_bpk=bpk,filter_bytes=65536*bpk//4,worst_wilson_upper=.005 if bpk==8 else .00001))
        for name in [s.ORIGINAL,s.CANDIDATE,s.EXTERNAL]:
            for bpk in [8,16]:
                speed=(1 if bpk==8 else 5) if name==s.EXTERNAL else(3 if bpk==8 else 2)
                for seed in range(6):
                    row=dict(filter=name,keys='65536',batch='1',requested_bpk=str(bpk),seed=str(seed))
                    row.update({metric:str(speed) for metric in s.METRICS});rows.append(row)
        p=dict(key_powers=[16],requested_bpk=[8,16],seeds=list(range(6)),ranking=dict(memory_caps_bpk=[16,32],fpr_ceilings=[.01,.001,.0001]))
        details,rankings=s.comparisons(rows,worst,p)
        loose=next(r for r in rankings if r['metric']=='lookup_ns' and r['cap_bpk']==32 and r['fpr_ceiling']==.01)
        self.assertEqual(loose['external']['requested_bpk'],8)
        self.assertEqual(loose['candidate']['requested_bpk'],16)
        self.assertEqual(loose['external_over_candidate_per_seed'],[.5]*6)
        strict=next(r for r in rankings if r['metric']=='lookup_ns' and r['cap_bpk']==16 and r['fpr_ceiling']==.0001)
        self.assertIsNone(strict['candidate']);self.assertIsNone(strict['external'])
        self.assertTrue(any(not r['candidate_qualifies_all_seeds'] for r in details))
if __name__=='__main__':unittest.main()
