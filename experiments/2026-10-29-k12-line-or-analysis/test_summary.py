import copy,unittest
from summarize import compute,METRICS,VECTORS

def fixture():
    rows=[]
    for n in (65536,33554432):
        for chunk in (4,n):
            for seed in (5011,6011):
                for name,factor in [('K12ScalarOrControl',1),('K12LineOrCandidate',1.1 if seed==5011 else .8)]:
                    row=dict(keys=str(n),insert_batch=str(chunk),seed=str(seed),filter=name,filter_bytes=str(3*n))
                    for i,(metric,vector) in enumerate(zip(METRICS,VECTORS)):
                        row[metric]=str((i+1)*factor);row[vector]=str([(i+1)*factor]*5)
                    rows.append(row)
    return rows
class Tests(unittest.TestCase):
    def test_all_outcomes_and_counts(self):
        pairs,vectors,ranges=compute(fixture());self.assertEqual((len(pairs),len(vectors),len(ranges)),(32,64,16));self.assertEqual(sum(r['outcome']=='slower' for r in pairs),16);self.assertEqual(sum(r['outcome']=='faster' for r in pairs),16)
    def test_missing_pair_rejects(self):
        rows=fixture();rows[0]=copy.deepcopy(rows[1])
        with self.assertRaises(RuntimeError):compute(rows)
    def test_wrong_summary_rejects(self):
        rows=fixture();rows[0]['insert_ns']='9'
        with self.assertRaises(RuntimeError):compute(rows)
    def test_exact_allocation_rejects(self):
        rows=fixture();rows[0]['filter_bytes']='8'
        with self.assertRaises(RuntimeError):compute(rows)
    def test_changed_seed_rejects(self):
        rows=fixture()
        for row in rows:
            if row['seed']=='6011':row['seed']='6001'
        with self.assertRaises(RuntimeError):compute(rows)
if __name__=='__main__':unittest.main()
