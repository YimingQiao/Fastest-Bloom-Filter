#!/usr/bin/env python3
import copy
import math
import unittest
from summarize import METRICS,calibrations,rank,wilson_upper

def row(name,bpk=8,threads=1,time=2.0,cal_fp=1000,batch=4096,queries=4194304):
    r={'language':'cpp','filter':name,'keys':'65536','requested_bpk':str(bpk),
       'filter_bytes':str(65536*bpk//4),'hash_bits':'64','input_mode':'prehashed',
       'seed':'42','queries':str(queries),'insert_batch':'65536','threads':str(threads),
       'spawned_threads':str(threads-1),'executor':'caller_worker0','batch':str(batch),
       'hit_percent':'50','repeats':'3','calibration_absent_queries':'16777216',
       'calibration_false_positives':str(cal_fp),'result_checksum':'1234','absent_queries':'2097152',
       'false_positives':'42','present_queries':'2097152'}
    for metric in METRICS:
        r[metric]=str(time);r[metric[:-3]+'_min_ns']=str(time*.99);r[metric[:-3]+'_max_ns']=str(time*1.01)
    return r

class SummaryTests(unittest.TestCase):
    def test_dedup_T_and_batch(self):
        rows=[row('FastPatternBF',threads=t,batch=b) for t in (1,4,8) for b in (31,4096)]
        streams=calibrations(rows)
        self.assertEqual(len(streams),1)
        stream=next(iter(streams.values()))
        self.assertEqual(stream['queries'],16777216)
        self.assertEqual(stream['repeated_rows'],6)
        self.assertEqual(stream['wilson95_upper'],wilson_upper(1000,16777216))
    def test_calibration_mismatch_rejected(self):
        for field,value in [('calibration_false_positives','1001'),('calibration_absent_queries','33554432')]:
            rows=[row('FastPatternBF'),row('FastPatternBF',threads=4)]
            rows[1][field]=value
            with self.assertRaisesRegex(ValueError,'inconsistent'):calibrations(rows)
    def test_different_query_working_sets_not_pooled(self):
        streams=calibrations([row('FastPatternBF'),row('FastPatternBF',queries=8388608)])
        self.assertEqual(len(streams),2)
        self.assertTrue(all(s['queries']==16777216 for s in streams.values()))
    def test_duplicate_timing_and_changed_answers_rejected(self):
        r=row('FastPatternBF')
        with self.assertRaisesRegex(ValueError,'duplicate'):calibrations([r,copy.deepcopy(r)])
        other=row('FastPatternBF',threads=4);other['result_checksum']='5'
        with self.assertRaisesRegex(ValueError,'answers changed'):calibrations([r,other])
    def test_same_configuration_allocation_drift_rejected(self):
        rows=[row('FastPatternBF'),row('FastPatternBF',threads=4)]
        rows[1]['filter_bytes']='131008'
        with self.assertRaisesRegex(ValueError,'changed allocation'):calibrations(rows)
    def test_under_cap_compares_smaller_external_allocation(self):
        rows=[row('ByteSplitBloomFilter',bpk=16,time=1),row('ByteSplitBloomFilter',bpk=8,time=1.5),
              row('FastFilterFixed16',bpk=8,time=.8),row('FastFilterFixed16',bpk=16,time=1.2)]
        result=rank(rows,caps=[32],targets=[.001],metrics=[METRICS[1]])['comparisons'][0]
        self.assertEqual(result['native']['actual_bpk'],32)
        self.assertEqual(result['external']['actual_bpk'],16)
        self.assertEqual(result['median_winner'],'external')
        self.assertAlmostEqual(result['native_speedup_vs_best_external'],.8)
    def test_upper_bound_not_point_estimate_gate(self):
        # 16/16384 is below 0.1%, but its Wilson upper is above it.
        rows=[row('FastPatternBF',time=1),row('FastFilterFixed16',time=2)]
        rows[0]['calibration_absent_queries']='16384';rows[0]['calibration_false_positives']='16'
        result=rank(rows,caps=[16],targets=[.001],metrics=[METRICS[0]])['comparisons'][0]
        self.assertEqual(result['median_winner'],'unqualified_native')
    def test_thread_and_timing_mode_separate(self):
        rows=[]
        for t in (1,4):
            own=row('FastPatternBF',threads=t,time=2 if t==1 else .5)
            external=row('FastFilterFixed16',threads=t,time=1.5 if t==1 else .75)
            own[METRICS[3]]='9';external[METRICS[3]]='8'
            rows.extend((own,external))
        results=rank(rows,caps=[16],targets=[.001],metrics=[METRICS[1],METRICS[3]])
        comparison={(r['case']['threads'],r['metric']):r for r in results['comparisons']}
        self.assertEqual(comparison['1',METRICS[1]]['median_winner'],'external')
        self.assertEqual(comparison['4',METRICS[1]]['median_winner'],'native')
        self.assertEqual(comparison['4',METRICS[3]]['median_winner'],'external')
        scaling=next(r for r in results['native_scaling'] if r['threads']=='4' and r['metric']==METRICS[1])
        self.assertEqual(scaling['speedup_vs_same_filter_t1'],4)
    def test_raw_api_not_eligible_for_pure_ranking(self):
        own=row('FastPatternBF');raw=row('PageBloom6Compact',time=.5);raw['input_mode']='raw_bytes'
        for metric in (METRICS[0],METRICS[2]):raw[metric]='nan'
        result=rank([own,raw],caps=[16],targets=[.001],metrics=METRICS)
        for r in result['comparisons']:
            self.assertEqual(r['median_winner'],'unqualified_external' if r['metric'].startswith('parallel_lookup_') else 'external')
    def test_raw_api_cannot_sneak_into_pure_comparison(self):
        raw=row('PageBloom6Compact',time=.1);raw['input_mode']='raw_bytes'
        with self.assertRaisesRegex(ValueError,'raw-only'):
            rank([row('FastPatternBF'),raw],caps=[16],targets=[.001],metrics=[METRICS[0]])

if __name__=='__main__':unittest.main()
