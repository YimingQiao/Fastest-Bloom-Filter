import copy,math,unittest
import summarize as a
from test_contract import all_records
class Checks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.data=a.calculate(all_records())
    def test_fixed_counts(self):
        c=self.data['counts'];self.assertEqual((c['rows'],c['quality_records'],c['quality_links']),(486,81,486))
        self.assertEqual((c['query_views'],c['build_views']),(432,432))
        self.assertEqual((c['query_alternatives'],c['build_alternatives']),(13320,13320))
        self.assertEqual((c['query_named_contrasts'],c['round_pairs']),(3888,1944))
    def test_fraction_units_and_no_pooling(self):
        self.assertGreater(a.wilson(6711,1<<26),.0001)
        self.assertLess(a.wilson(6000,1<<26),.0001)
        self.assertTrue(all(x['absent']==1<<26 for x in self.data['quality']))
        self.assertEqual(sum(x['new_calibration']for x in self.data['quality_links']),81)
    def test_smaller_actual_caps(self):
        rows=[x for x in self.data['alternatives']if x['cap_bpk']==32]
        self.assertTrue(any(x['actual_bytes']*8<x['keys']*32 for x in rows))
        self.assertTrue(all(x['actual_bytes']*8<=x['keys']*32 for x in rows))
    def test_exact_ties_and_missing_rival(self):
        points=[dict(owner='retained_external',eligible=True,latency_ns=2.,actual_bytes=24,configuration_id='a'),dict(owner='poppy_external',eligible=True,latency_ns=2.,actual_bytes=16,configuration_id='b')]
        self.assertEqual(len(a.best(points,'all_external_composite')),2)
        self.assertEqual(a.comparison(a.best(points,'poppy_external'),[])['outcome'],'no_comparable')
        bad=copy.deepcopy(points);bad[1]['eligible']=False;bad[1]['latency_ns']=.1
        self.assertEqual(len(a.best(bad,'all_external_composite')),1)
    def test_ratio_direction_and_owners(self):
        left=[dict(latency_ns=2.)];right=[dict(latency_ns=4.)]
        self.assertEqual(a.comparison(left,right)['latency_ratio'],.5)
        self.assertEqual(a.comparison(left,right)['outcome'],'win')
        self.assertFalse(a.includes('production_native','optional_native_k12'))
        self.assertTrue(a.includes('all_native_composite','optional_native_k12'))
        self.assertFalse(a.includes('all_external_composite','production_native'))
    def test_round_positions_and_all_metrics(self):
        self.assertEqual({p['metric']for p in self.data['round_pairs']},set(a.QUERY+a.BUILD))
        self.assertTrue(all(p['round2_over_round1']==1 and p['outcome']=='tie'for p in self.data['round_pairs']))
        self.assertTrue(any(p['round1_position']!=p['round2_position']for p in self.data['round_pairs']))
    def test_incomplete_rows_rejected(self):
        with self.assertRaises(ValueError):a.calculate(all_records()[:-1])
if __name__=='__main__':unittest.main()
