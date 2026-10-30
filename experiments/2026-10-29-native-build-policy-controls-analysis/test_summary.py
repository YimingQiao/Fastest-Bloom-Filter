"""Synthetic estimator/classification checks only; no measured values loaded."""
import copy,math,unittest
import summarize as s


def interval(low=1,point=1,high=1):return dict(interval_low=low,latency_ratio=point,interval_high=high)
def family():return {seed:{a+'/'+b:interval()for a,b in s.CONTRASTS}for seed in s.PLAN.SEEDS}


class SummaryTests(unittest.TestCase):
    def test_cycle_estimator_and_ratio_direction(self):
        a=[x for x in range(1,9)for _ in range(4)];b=[1]*32
        result,blocks,logs=s.estimate(a,b,[(0,)*8,(7,)*8])
        self.assertAlmostEqual(result['latency_ratio'],math.prod(range(1,9))**(1/8))
        self.assertAlmostEqual(result['interval_low'],1.175)
        self.assertAlmostEqual(result['interval_high'],7.825)
        self.assertEqual(len(blocks),8);self.assertEqual(len(logs),32)
        reciprocal=s.estimate(b,a,[(0,)*8,(7,)*8])[0]
        self.assertAlmostEqual(result['latency_ratio']*reciprocal['latency_ratio'],1)

    def test_whole_cycle_shared_resampling(self):
        draws=s.resampling();self.assertEqual(len(draws),10000)
        self.assertTrue(all(len(row)==8 and all(0<=i<8 for i in row)for row in draws))
        self.assertEqual(draws,s.resampling())
        result,_,_=s.estimate([2]*32,[2]*32,draws)
        self.assertEqual(result,dict(latency_ratio=1,interval_low=1,interval_high=1))

    def test_controls_need_entire_intervals_at_both_seeds(self):
        data=family()
        for seed in s.PLAN.SEEDS:
            for name in s.POLICY:data[seed][name]=interval(.5,.51,.52)
        self.assertEqual(s.classify(data)['classification'],'consistently_faster')
        data[s.PLAN.SEEDS[1]]['Clone/A1']=interval(.96,1,1.02)
        result=s.classify(data)
        self.assertEqual(result['classification'],'unresolved_negative_controls')
        self.assertEqual(result['policy_interval_pattern'],'all_policy_intervals_faster')

    def test_policy_both_references_and_both_seeds(self):
        data=family()
        for seed in s.PLAN.SEEDS:
            for name in s.POLICY:data[seed][name]=interval(1.04,1.05,1.06)
        self.assertEqual(s.classify(data)['classification'],'consistently_slower')
        data[s.PLAN.SEEDS[1]]['Policy/A1']=interval(1.02,1.03,1.04)
        self.assertEqual(s.classify(data)['classification'],'unresolved_policy_intervals')
        with self.assertRaises(ValueError):s.classify({s.PLAN.SEEDS[0]:data[s.PLAN.SEEDS[0]]})

    def test_engineering_band_is_inclusive_not_no_effect(self):
        data=family()
        for rows in data.values():
            for name in rows:rows[name]=interval(.97,1,1.03)
        self.assertEqual(s.classify(data)['classification'],'practically_within_band')
        self.assertEqual(s.interval_label(interval(.96,.97,.98)),'crosses_band_boundary')
        self.assertEqual(s.interval_label(interval(.95,.96,.969)),'wholly_faster_than_band')

    def test_invalid_samples_and_empty_loss_csv(self):
        with self.assertRaises(ValueError):s.estimate([1]*31,[1]*32,[(0,)*8])
        with self.assertRaises(ValueError):s.estimate([0]*32,[1]*32,[(0,)*8])
        self.assertEqual(s.csv_text([],['contrast','latency_ratio']),'contrast,latency_ratio\n')


if __name__=='__main__':unittest.main()
