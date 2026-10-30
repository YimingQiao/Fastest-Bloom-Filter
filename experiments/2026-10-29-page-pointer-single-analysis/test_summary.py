"""Synthetic tests only; no worker or compiler invocation."""
import copy,unittest
import summarize as s

def rows():
    result=[]
    for item in s.producer.plan():
        r={k:str(v)for k,v in item['geometry'].items()};r['round']=item['round']
        r.update(seed='42',queries=str(1<<22),hit_percent='50',calibration_absent_queries=str(1<<24),
          false_positives='0',calibration_false_positives='0',result_checksum='1',inserted_checksum='2',query_checksum='3',calibration_checksum='4',
          query_phase_order=s.producer.original.schedule(42,6))
        for mode in s.MODES:
            r.update({mode+suffix:'1'for suffix in ('_ns','_min_ns','_max_ns')});r[mode+'_trials_ns']='1|1|1|1|1|1'
        result.append(r)
    return result

class Analysis(unittest.TestCase):
    def setUp(self):self.rows=rows();self.q,self.qmap=s.quality(self.rows)
    def test_counts(self):
        views,alts=s.rankings(self.rows,self.qmap)
        self.assertEqual((len(self.q),len(s.paired(self.rows,self.qmap)),len(views),len(alts),len(s.native_controls(self.rows,self.qmap))),(72,288,144,8640,144))
    def test_actual_caps_include_smaller_allocations(self):
        views,_=s.rankings(self.rows,self.qmap)
        for v in views:
            count=sum(int(r['round'])==v['round']and int(r['keys'])==v['keys']and int(r['filter_bytes'])*8<=v['cap_bpk']*v['keys']for r in self.rows)
            self.assertEqual(v['eligible_configurations'],count)
    def test_pair_direction_and_dense_losses(self):
        for r in self.rows:
            if r['filter']in s.POINTERS:r['raw_single_ns']='0.5';r['raw_batch4096_ns']='2'
        pairs=s.paired(self.rows,self.qmap)
        for p in pairs:
            expected='lower_latency'if p['mode']=='raw_single'else'higher_latency'if p['mode']=='raw_batch4096'else'tie'
            self.assertEqual(p['pointer_outcome'],expected)
    def test_rounds_not_averaged(self):
        for r in self.rows:
            if r['filter']in s.POINTERS:r['raw_single_ns']='0.5'if r['round']==0 else'2'
        for p in s.paired(self.rows,self.qmap):
            if p['mode']=='raw_single':self.assertEqual(p['pointer_over_value_latency'],.5 if p['round']==0 else 2)
    def test_no_quality_pooling(self):
        self.assertTrue(all(q['negatives']==1<<24 and q['pooled']is False for q in self.q))
        r=next(r for r in self.rows if r['filter']in s.POINTERS);r['calibration_false_positives']='1'
        with self.assertRaises(ValueError):s.quality(self.rows)
    def test_failed_quality_retains_alternatives(self):
        for key,q in self.qmap.items():
            if key[0]in s.NATIVE:q['wilson95_high']=.5
        views,alts=s.rankings(self.rows,self.qmap)
        self.assertTrue(all(v['native_outcome']=='ineligible_or_missing'for v in views))
        native=[r for r in alts if r['owner']=='production_native']
        self.assertTrue(native and all(not r['eligible']and r['candidate_vs_overall']=='ineligible_or_missing'for r in native))
    def test_missing_row_and_ownership(self):
        with self.assertRaises(ValueError):s.rankings(self.rows[:-1],self.qmap)
        self.rows[0]['implementation_origin']='external'
        with self.assertRaises(ValueError):s.rankings(self.rows,self.qmap)
    def test_wilson_endpoints(self):
        self.assertEqual(s.wilson(0,100)[0],0);self.assertEqual(s.wilson(100,100)[1],1)
        with self.assertRaises(ValueError):s.wilson(101,100)

if __name__=='__main__':unittest.main()
