#!/usr/bin/env python3
import unittest
from summarize import METRICS,comparisons,pooled_quality,serial_ratios,metric_time,validate_trial_metadata

SEEDS=(19867,45631,93187)
def row(name,seed,bpk=8,threads=8,time=2.,fp=1000,batch=4096,queries=4194304):
    r={'language':'cpp','filter':name,'keys':'65536','requested_bpk':str(bpk),'filter_bytes':str(65536*bpk//4),
       'hash_bits':'64','input_mode':'prehashed','seed':str(seed),'queries':str(queries),'insert_batch':'65536',
       'threads':str(threads),'spawned_threads':str(threads-1),'executor':'caller_worker0','batch':str(batch),
       'hit_percent':'50','repeats':'5','calibration_absent_queries':'16777216','calibration_false_positives':str(fp),
       'result_checksum':str(seed),'absent_queries':'2097152','false_positives':'42','present_queries':'2097152',
       'lookup_ns':'16','hash_lookup_ns':'24'}
    for metric in METRICS:
        r[metric]=str(time);r[metric[:-3]+'_min_ns']=str(time*.99);r[metric[:-3]+'_max_ns']=str(time*1.01)
    return r

class ConfirmationTests(unittest.TestCase):
    def test_dedup_before_three_seed_pool(self):
        rows=[row('FastPatternBF',seed,threads=t,batch=b,fp=i+1) for i,seed in enumerate(SEEDS) for t in (4,8) for b in (31,4096)]
        quality=pooled_quality(rows,SEEDS);self.assertEqual(len(quality),1)
        pooled=next(iter(quality.values()))
        self.assertEqual(pooled['queries'],50331648);self.assertEqual(pooled['false_positives'],6)
        self.assertEqual([s['repeated_rows'] for s in pooled['seed_streams']],[4,4,4])
    def test_missing_or_old_seed_rejected(self):
        rows=[row('FastPatternBF',seed) for seed in SEEDS[:2]]
        with self.assertRaisesRegex(ValueError,'seed set'):pooled_quality(rows,SEEDS)
        rows.append(row('FastPatternBF',42))
        with self.assertRaisesRegex(ValueError,'seed set'):pooled_quality(rows,SEEDS)
    def test_overlapping_new_seed_intervals_rejected(self):
        seeds=(16,22,93187)
        with self.assertRaisesRegex(ValueError,'overlapping'):
            pooled_quality([row('FastPatternBF',seed) for seed in seeds],seeds)
    def test_all_raw_seeds_are_validated(self):
        rows={str(seed):row('PageBloom6Compact',seed) for seed in SEEDS}
        for r in rows.values():r['input_mode']='raw_bytes';r[METRICS[0]]='nan'
        rows[str(SEEDS[1])][METRICS[0]]='1.0'
        with self.assertRaisesRegex(ValueError,'raw-only'):metric_time(rows,METRICS[0])
    def test_raw_scalar_fields_are_also_missing(self):
        r=row('PageBloom6Compact',SEEDS[0]);r['input_mode']='raw_bytes'
        for phase in ('parallel_lookup','parallel_hash_lookup'):
            values={'end_to_end':2.75,'launch':.5,'gated':2.,'join':.25}
            for field,value in values.items():
                r[phase+'_'+field+'_ns']='nan' if phase=='parallel_lookup' else str(value)
                r[phase+'_'+field+'_trials']='nan' if phase=='parallel_lookup' else '|'.join([str(value)]*5)
            for field in ('end_to_end','gated'):
                for bound in ('min','max'):
                    r[phase+'_'+field+'_'+bound+'_ns']='nan' if phase=='parallel_lookup' else str(values[field])
        validate_trial_metadata(r)
        r[METRICS[0]]='1'
        with self.assertRaisesRegex(ValueError,'scalar pure timing'):validate_trial_metadata(r)
    def test_query_sources_kept_separate(self):
        rows=[row('FastPatternBF',seed,queries=q) for seed in SEEDS for q in (4194304,8388608)]
        quality=pooled_quality(rows,SEEDS);self.assertEqual(len(quality),2)
        self.assertTrue(all(q['queries']==50331648 for q in quality.values()))
    def test_pooled_gate_reports_seed_instability(self):
        rows=[]
        for i,seed in enumerate(SEEDS):
            own=row('FastPatternBF',seed,fp=16 if i==0 else 0);own['calibration_absent_queries']='16384'
            rows.extend((own,row('FastFilterFixed16',seed,time=3)))
        comparison=comparisons(rows,SEEDS,[16],[.001],[METRICS[1]])[0]
        self.assertEqual(comparison['aggregate_median_winner'],'native')
        self.assertFalse(comparison['native_all_seed_quality_uppers_pass'])
        self.assertLess(comparison['native']['wilson95_upper'],.001)
    def test_fixed_aggregate_rival_and_conservative_seed_rival(self):
        rows=[]
        for i,seed in enumerate(SEEDS):
            rows.extend((row('FastPatternBF',seed,bpk=16,time=2),row('FastPatternBF',seed,bpk=8,time=3),
                         row('FastFilterFixed16',seed,bpk=8,time=[1.9,3,3][i]),
                         row('FastFilterSimdBlock',seed,bpk=16,time=[4,2.1,2.1][i])))
        c=comparisons(rows,SEEDS,[32],[.001],[METRICS[1]])[0]
        self.assertEqual(c['native']['actual_bpk'],32)
        self.assertEqual(c['external']['filter'],'FastFilterSimdBlock')
        self.assertGreater(c['paired_speedup_min'],1)
        self.assertAlmostEqual(c['conservative_speedup_min'],.95)
        self.assertEqual(c['conservative_seeds'][0]['external_filter'],'FastFilterFixed16')
        self.assertEqual(c['conservative_seeds'][0]['external_requested_bpk'],8)
    def test_same_row_serial_control_is_used(self):
        rows=[row('FastPatternBF',seed,time=2+i) for i,seed in enumerate(SEEDS)]
        ratios=serial_ratios(rows,SEEDS,[METRICS[0],METRICS[1]])
        pure,hashed=ratios
        self.assertEqual(pure['serial_control'],'lookup_ns');self.assertEqual(hashed['serial_control'],'hash_lookup_ns')
        self.assertEqual(pure['min_serial_ratio'],4);self.assertEqual(pure['max_serial_ratio'],8)
        self.assertEqual(hashed['min_serial_ratio'],6);self.assertEqual(hashed['max_serial_ratio'],12)
    def test_individual_losses_remain_visible(self):
        rows=[]
        for seed in SEEDS:
            rows.extend((row('FastPatternBF',seed,time=1),row('Split64BloomFilter',seed,time=3),row('FastFilterFixed16',seed,time=2)))
        portfolio=comparisons(rows,SEEDS,[16],[.01],[METRICS[1]])[0]
        single=comparisons(rows,SEEDS,[16],[.01],[METRICS[1]],'Split64BloomFilter')[0]
        self.assertEqual(portfolio['aggregate_median_winner'],'native');self.assertEqual(single['aggregate_median_winner'],'external')
    def test_metric_modes_do_not_mix(self):
        rows=[]
        for seed in SEEDS:
            own=row('FastPatternBF',seed,time=1);own[METRICS[3]]='4'
            rows.extend((own,row('FastFilterFixed16',seed,time=2)))
        result=comparisons(rows,SEEDS,[16],[.01],[METRICS[1],METRICS[3]])
        self.assertEqual(result[0]['aggregate_median_winner'],'native');self.assertEqual(result[1]['aggregate_median_winner'],'external')

if __name__=='__main__':unittest.main()
