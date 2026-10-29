import copy,unittest
import summarize as s
from test_screen import fixture
def rows():return [r for item in s.contract.plan()for r in fixture(item)]
class Tests(unittest.TestCase):
    def test_cardinalities(self):
        d=s.compute(rows());self.assertEqual(d['counts']['pairs'],288);self.assertEqual(len(d['vectors']),288);self.assertEqual(len(d['ranges']),96)
    def test_alias_and_repeated_chunk_denominator(self):
        d=s.compute(rows());self.assertEqual(len(d['quality_mapping']),24);self.assertTrue(all(v['absent']==1<<26 for v in d['quality_mapping']))
    def test_one_seed_failure_remains_all_seed_failure(self):
        r=rows()
        for row in r:
            if row['filter']in s.TYPES[:2]and int(row['keys'])==65536 and int(row['seed'])==s.SEEDS[0]:row['calibration_false_positives']='10000'
        d=s.compute(r);pair=[p for p in d['paired']if p['keys']==65536 and p['numerator']==s.TYPES[1]and p['denominator']==s.TYPES[2]]
        self.assertTrue(all(not p['all_three_both_qualified']for p in pair))
        self.assertTrue(any(p['current_both_qualified']for p in pair));self.assertTrue(any(not p['current_both_qualified']for p in pair))
    def test_slower_direction_and_all_losses(self):
        r=rows()
        for row in r:
            if row['filter']!=s.TYPES[1]:continue
            for metric,vector in zip(s.METRICS,s.VECTORS):
                values=[v*2 for v in s.json.loads(row[vector])];row[vector]=s.json.dumps(values);row[metric]=str(s.statistics.median(values))
        d=s.compute(r);pairs=[p for p in d['paired']if p['numerator']==s.TYPES[1]and p['denominator']==s.TYPES[0]]
        self.assertEqual(len(pairs),96);self.assertTrue(all(p['latency_ratio']==2 and p['outcome']=='slower'for p in pairs))
    def test_missing_seed_or_type_rejected(self):
        r=rows();r[0]=copy.deepcopy(r[1])
        with self.assertRaises(RuntimeError):s.compute(r)
    def test_trial_summary_corruption(self):
        r=rows();r[0]['insert_ns']='999'
        with self.assertRaises(RuntimeError):s.compute(r)
    def test_wilson_endpoints(self):
        n=1<<26;self.assertEqual(s.wilson(n,n),1);self.assertAlmostEqual(s.wilson(0,n),1.959963984540054**2/(n+1.959963984540054**2),places=18)
if __name__=='__main__':unittest.main()
