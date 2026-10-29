"""Synthetic offline analysis tests; no measured partial results are read."""
import copy
import unittest
import summarize as s
from test_guard import mock_rows

class Analysis(unittest.TestCase):
    def setUp(self):self.rows=mock_rows();self.q=s.quality(self.rows)
    def test_complete_nested_counts(self):
        for metrics in (s.QUERY,s.BUILD):
            r=s.rank(self.rows,self.q,metrics)
            self.assertEqual([len(r[k])for k in ('views','alternatives','range_alternatives')],[216,12096,648])
    def test_smaller_allocations_compete_under_larger_caps(self):
        r=s.rank(self.rows,self.q,s.QUERY)
        for cap,count in [(16,20),(24,36),(32,56)]:
            view=next(x for x in r['views']if x['cap_bpk']==cap)
            self.assertEqual(view['feasible_allocations'],count)
    def test_all_public_K_retained_even_when_ineligible(self):
        q=copy.deepcopy(self.q)
        for row in q:
            if row['filter']=='Fastbloom017K1':row['wilson95_high']=.5
        r=s.rank(self.rows,q,s.QUERY)
        rows=[x for x in r['alternatives']if x['filter']=='Fastbloom017K1']
        self.assertEqual(len(rows),648);self.assertTrue(all(not x['quality_pass']for x in rows))
    def test_no_lowest_K_latency_pruning(self):
        for row in self.rows:
            if row['filter']=='Fastbloom017K12':row['lookup_ns']='.5'
        views=s.rank(self.rows,self.q,s.QUERY)['views']
        for row in views:
            if row['metric']=='lookup_ns':self.assertEqual({x['filter']for x in row['external_leaders']},{'Fastbloom017K12'})
    def test_all_pair_counts_and_ties(self):
        self.assertEqual(len(s.same_allocation_controls(self.rows)),96)
        self.assertEqual(len(s.api_ratios(self.rows)),672)
        pairs=s.fixed_default_pairs(self.rows,self.q)
        self.assertEqual(len(pairs),1728);self.assertTrue(all(x['outcome']=='tie'for x in pairs))
    def test_quality_never_pools_batch_denominators(self):
        self.assertEqual(len(self.q),112)
        self.assertEqual(len({(x['proven_mapping'],x['keys'],x['filter_bytes'],x['seed'])for x in self.q}),110)
        self.assertTrue(all(x['negatives']==1<<24 for x in self.q))
        changed=copy.deepcopy(self.rows);changed[20]['calibration_false_positives']='99'
        with self.assertRaises(ValueError):s.quality(changed)
    def test_ownership_mismatch_rejected(self):
        r=next(x for x in self.rows if x['filter']=='Fastbloom017K3');r['implementation_origin']='production_native'
        with self.assertRaises(ValueError):s.rank(self.rows,self.q,s.QUERY)
    def test_nested_baseline_expansion_does_not_claim_one_process(self):
        q=s.rank(self.rows,self.q,s.QUERY)
        records=s.baseline_expansion(self.rows,self.q,q)
        self.assertEqual(len(records),216)
        self.assertTrue(all(x['same_screen'] and not x['all_allocations_same_process'] and not x['older_screen_timings_imported'] for x in records))
    def test_fixed_default_payload_mismatch_is_rejected(self):
        row=next(x for x in self.rows if x['filter']=='Fastbloom017K3')
        row['filter_bytes']=str(int(row['filter_bytes'])+8)
        with self.assertRaises(ValueError):s.fixed_default_pairs(self.rows,self.q)
    def test_wilson_endpoints_and_ties(self):
        self.assertEqual(s.wilson(0,100)[0],0);self.assertEqual(s.wilson(100,100)[1],1)
        self.assertEqual(s.outcome(1),'tie')
        with self.assertRaises(ValueError):s.wilson(101,100)

if __name__=='__main__':unittest.main()
