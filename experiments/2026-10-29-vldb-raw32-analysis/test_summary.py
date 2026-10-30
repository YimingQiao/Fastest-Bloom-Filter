"""Synthetic tests only. Do not execute during an exclusive timing lease."""
import copy,unittest
import summarize as s

def rows():
    out=[]
    for round_index in (0,1):
        for worker in ('legacy','modern'):
            for g in s.producer.panel(worker):
                r={k:str(v)for k,v in g.items()};r['round']=round_index
                r.update(seed='42',calibration_absent_queries=str(1<<24),calibration_false_positives='0',
                    result_checksum='1',false_positives='0',query_checksum='2',inserted_checksum='3',calibration_checksum='4',
                    query_phase_order=s.producer.schedule(42,6))
                for m in s.MODES:r.update({m+'_ns':'1',m+'_min_ns':'1',m+'_max_ns':'1',m+'_trials_ns':'1|1|1|1|1|1'})
                out.append(r)
    return out

class Analysis(unittest.TestCase):
    def setUp(self):self.rows=rows();self.q,self.qmap=s.quality(self.rows)
    def test_complete_counts(self):
        v,a=s.rankings(self.rows,self.qmap)
        self.assertEqual((len(v),len(a),len(s.cross_context(v)),len(s.native_context_controls(self.rows,self.qmap))),(288,26208,144,144))
    def test_actual_cap_nested(self):
        v,_=s.rankings(self.rows,self.qmap)
        for worker in ('legacy','modern'):
            for cap in s.CAPS:
                view=next(x for x in v if x['worker']==worker and x['cap_bpk']==cap and x['keys']==65536)
                expected=sum(int(r['filter_bytes'])*8<=cap*65536 for r in self.rows if r['worker']==worker and r['round']==0 and int(r['keys'])==65536)
                self.assertEqual(view['eligible_configurations'],expected)
    def test_quality_not_pooled(self):
        self.assertEqual(len(self.q),166)
        self.assertTrue(all(q['negatives']==1<<24 and q['pooled']is False for q in self.q))
        key=s.identity(self.rows[0]);other=next(r for r in self.rows[1:]if s.identity(r)==key)
        other['calibration_false_positives']='1'
        with self.assertRaises(ValueError):s.quality(self.rows)
    def test_ineligible_rows_retained(self):
        for key,q in self.qmap.items():
            if key[0]=='FastPatternBF':q['wilson95_high']=.5
        _,a=s.rankings(self.rows,self.qmap);bad=[x for x in a if x['filter']=='FastPatternBF']
        self.assertEqual(len(bad),864);self.assertTrue(all(not x['eligible']and x['candidate_vs_external']=='ineligible_or_missing'for x in bad))
    def test_strongest_public_alias_remains(self):
        for r in self.rows:
            if r['filter'].endswith('/public_static'):r['raw_single_ns']='0.5'
        v,_=s.rankings(self.rows,self.qmap)
        for view in v:
            if view['worker']=='legacy'and view['mode']=='raw_single':self.assertTrue(all(x['surface']=='public_static'for x in view['external_leaders']))
    def test_rounds_not_merged(self):
        for r in self.rows:
            if r['worker']=='legacy'and r['round']==1 and r['filter']in s.producer.NATIVES:r['raw_single_ns']='2'
        v,_=s.rankings(self.rows,self.qmap)
        self.assertTrue(all(x['native_ns']==(1 if x['round']==0 else 2)for x in v if x['worker']=='legacy'and x['mode']=='raw_single'))
    def test_no_context_correction(self):
        for r in self.rows:
            if r['worker']=='modern':
                for mode in s.MODES:r[mode+'_ns']='3'if r['filter']in s.producer.NATIVES else '2'
        v,_=s.rankings(self.rows,self.qmap);cross=s.cross_context(v)
        self.assertTrue(all(x['original_public_ns']==1 and x['modern_external_ns']==2 and x['native_legacy_context_ns']==1 and x['native_modern_context_ns']==3 and x['modern_external_over_original_latency']==2 and x['context_shift_correction']is False for x in cross))
        controls=s.native_context_controls(self.rows,self.qmap);self.assertTrue(all(x['modern_over_legacy_latency']==3 for x in controls))
    def test_modes_stay_independent(self):
        for r in self.rows:r['raw_batch4096_ns']='4'
        v,_=s.rankings(self.rows,self.qmap)
        self.assertTrue(all(x['overall_ns']==(4 if x['mode']=='raw_batch4096'else 1)for x in v))
    def test_missing_negative_and_owner(self):
        with self.assertRaises(ValueError):s.rankings(self.rows[:-1],self.qmap)
        self.rows[0]['implementation_origin']='external'
        with self.assertRaises(ValueError):s.rankings(self.rows,self.qmap)
    def test_wilson_and_ties(self):
        self.assertEqual(s.wilson(0,100)[0],0);self.assertEqual(s.wilson(100,100)[1],1)
        self.assertEqual(s.outcome(1),'tie')
        with self.assertRaises(ValueError):s.wilson(101,100)

if __name__=='__main__':unittest.main()
