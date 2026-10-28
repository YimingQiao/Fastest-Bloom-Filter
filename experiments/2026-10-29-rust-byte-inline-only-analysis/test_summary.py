"""Synthetic offline assertions; no benchmark or timing inputs are executed."""
import copy
import unittest
from summarize import (ORIGINAL,TRIPLE,CANDIDATE,METRICS,aggregate,paired,quality,wilson)


def fixture():
    rows=[];orders={}
    for seed,order in [(10,[ORIGINAL,TRIPLE,CANDIDATE]),(11,[CANDIDATE,TRIPLE,ORIGINAL])]:
        orders[(1024,8,1,seed)]=order
        for name in order:
            r=dict(filter=name,keys='1024',requested_bpk='8',actual_bpk='16',filter_bytes='2048',batch='1',seed=str(seed),calibration_absent_queries='1000',calibration_false_positives='1')
            for metric in METRICS:
                r[metric]='2' if name==ORIGINAL else '1'
                r[metric[:-3]+'_min_ns']=r[metric]
                r[metric[:-3]+'_max_ns']=r[metric]
            rows.append(r)
    return rows,orders


class Summary(unittest.TestCase):
    def test_wilson_endpoints_and_invalid_counts(self):
        self.assertEqual(wilson(0,100)[0],0)
        self.assertEqual(wilson(100,100)[1],1)
        for fp,n in [(0,0),(-1,10),(11,10)]:
            with self.assertRaises(ValueError):wilson(fp,n)

    def test_quality_deduplicates_known_alias_and_batch_reuse(self):
        rows,_=fixture();extra=copy.deepcopy(rows)
        for r in extra:r['batch']='31'
        values,worst=quality(rows+extra)
        self.assertEqual((len(values),len(worst)),(2,1))
        self.assertTrue(all(r['negatives']==1000 for r in values))
        self.assertEqual(worst[0]['distinct_seeds'],2)
        self.assertEqual(worst[0]['worst_wilson_upper'],max(r['wilson_upper'] for r in values))

    def test_all_three_pairs_and_exact_ties_retained(self):
        rows,orders=fixture();pairs,api=paired(rows,orders);groups,strata=aggregate(pairs)
        self.assertEqual((len(pairs),len(api),len(groups),len(strata)),(24,12,12,24))
        self.assertEqual(sum(r['outcome']=='exact_tie' for r in pairs),8)
        self.assertTrue(all(r['seeds']==2 for r in groups))
        self.assertTrue(all(r['seeds']==1 for r in strata))

    def test_unbalanced_pair_order_rejected(self):
        rows,orders=fixture();orders[(1024,8,1,11)]=orders[(1024,8,1,10)]
        pairs,_=paired(rows,orders)
        with self.assertRaises(ValueError):aggregate(pairs)

    def test_loss_is_never_discarded(self):
        rows,orders=fixture()
        row=next(r for r in rows if r['filter']==CANDIDATE and r['seed']=='10')
        row['lookup_ns']='3';row['lookup_min_ns']='3';row['lookup_max_ns']='3'
        pairs,_=paired(rows,orders)
        losses=[r for r in pairs if r['after']==CANDIDATE and r['metric']=='lookup_ns' and r['seed']==10]
        self.assertEqual(len(losses),2)
        self.assertTrue(all(r['outcome']=='before_faster' and r['before_over_after']<1 for r in losses))

    def test_duplicate_quality_seed_rejected(self):
        rows,_=fixture();rows.append(copy.deepcopy(rows[0]))
        with self.assertRaises(ValueError):quality(rows)

if __name__=='__main__':unittest.main()
