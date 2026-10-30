import copy
import math
import unittest
import summarize as s


def row(name,owner='external',bpk=16,fp=0,metric=1.0,sample=None):
    n=65536
    r=dict(filter=name,implementation_origin=owner,configuration_id=name,calibration_identity=sample or name,
           keys=str(n),requested_bpk=str(bpk),filter_bytes=str(n*bpk//8),actual_bpk=str(bpk),
           calibration_false_positives=str(fp),calibration_absent_queries=str(1<<24),result_checksum='1',false_positives='0')
    r.update({key:str(metric) for key in s.QUERY+s.BUILD+('lookup_ns','hash_lookup_ns')})
    return r


class Summary(unittest.TestCase):
    def test_smaller_actual_capacity_competes_under_larger_cap(self):
        small=row('small',bpk=16,metric=1);large=row('large',bpk=32,metric=2)
        q=s.quality_records([small,large])
        self.assertEqual(s.best([small,large],'external',32,0.01,s.QUERY[0],q)['filter'],'small')
    def test_quality_failure_cannot_win_on_speed(self):
        fast=row('fast',fp=10000,metric=1);slow=row('slow',fp=0,metric=2)
        q=s.quality_records([fast,slow])
        self.assertEqual(s.best([fast,slow],'external',32,0.0001,s.QUERY[0],q)['filter'],'slow')
    def test_metrics_choose_independently(self):
        a=row('a',metric=1);b=row('b',metric=2);a[s.QUERY[1]]='3';a[s.QUERY[2]]='4';a[s.QUERY[3]]='5'
        q=s.quality_records([a,b])
        self.assertEqual([s.best([a,b],'external',16,.01,m,q)['filter'] for m in s.QUERY],['a','b','b','b'])
    def test_aliases_reuse_denominator_without_pooling(self):
        a=row('a',fp=12,sample='shared');b=row('b',fp=12,sample='shared')
        q=s.quality_records([a,b]);self.assertEqual(len(q),1)
        self.assertEqual(q['shared']['calibration_absent_queries'],1<<24)
        self.assertFalse(q['shared']['pooled']);self.assertEqual(q['shared']['filters'],['a','b'])
    def test_alias_disagreement_rejected(self):
        a=row('a',fp=12,sample='shared');b=row('b',fp=13,sample='shared')
        with self.assertRaises(ValueError):s.quality_records([a,b])
    def test_missing_pure_raw_api_does_not_hide_hash(self):
        raw=row('PageBloom6Compact');raw[s.QUERY[0]]=raw[s.QUERY[1]]='nan'
        q=s.quality_records([raw]);self.assertIsNone(s.best([raw],'external',32,.01,s.QUERY[0],q))
        self.assertIs(s.best([raw],'external',32,.01,s.QUERY[2],q),raw)
    def test_owner_split_preserves_range_experiment(self):
        prod=row('prod','production_native',metric=3);candidate=row(s.RANGE,'project_experiment',metric=1)
        q=s.quality_records([prod,candidate])
        self.assertIs(s.best([prod,candidate],'production_native',32,.01,s.QUERY[0],q),prod)
        self.assertIs(s.best([prod,candidate],'project_experiment',32,.01,s.QUERY[0],q),candidate)
    def test_all_alternatives_and_null_leaders_retained(self):
        r=row('over',bpk=32,fp=1000000)
        views,alts=s.views([r],s.quality_records([r]),s.QUERY)
        self.assertEqual(len(views),36);self.assertEqual(len(alts),36)
        self.assertTrue(all(v['external_filter'] is None for v in views))
        self.assertTrue(any(not a['fits_cap'] for a in alts));self.assertTrue(all(not a['quality_pass'] for a in alts))
    def test_serial_scaling_uses_corresponding_same_row(self):
        r=row('r',metric=2);r['lookup_ns']='8';r['hash_lookup_ns']='10'
        scales=s.scaling([r],s.quality_records([r]))
        self.assertEqual([a['serial_over_parallel'] for a in scales],[4,4,5,5])
    def test_equal_byte_pair_uses_actual_bytes(self):
        r=row(s.RANGE,'project_experiment',bpk=24);same=row('same',bpk=24);same['requested_bpk']='32';different=row('different',bpk=32)
        pairs=s.equal_capacity([r,same,different],s.quality_records([r,same,different]))
        self.assertEqual(len(pairs),8);self.assertTrue(all(p['peer']=='same' for p in pairs))
    def test_wilson_endpoints_and_invalid(self):
        self.assertEqual(s.wilson(0,100)[0],0);self.assertEqual(s.wilson(100,100)[1],1)
        for fp,count in [(-1,100),(101,100),(0,0)]:
            with self.assertRaises(ValueError):s.wilson(fp,count)
    def test_ties_are_not_wins(self):
        result=s.outcomes([{'r':2},{'r':1},{'r':0.5},{'r':None}],'r')
        self.assertEqual((result['wins'],result['ties'],result['losses']),(1,1,1))

if __name__=='__main__':unittest.main()
