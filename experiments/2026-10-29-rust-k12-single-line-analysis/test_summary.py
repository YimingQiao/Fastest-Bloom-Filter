import unittest,sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent/'2026-10-29-rust-k12-single-line/screening'))
import test_contract
from summarize import analyze,OLD,NEW,RANGE
from contract import quality_context
class SummaryTests(unittest.TestCase):
    def fixture(self):
        _,_,groups=test_contract.Guards().fixture();rows=[dict(r)for c,g in groups for r in g];meta=dict(cases=[dict(case=c)for c,g in groups]);return rows,meta,quality_context(rows)
    def test_full_fixed_counts_and_ties(self):
        rows,m,q=self.fixture();r=analyze(rows,m,q);self.assertEqual(len(r['pairs']),576);self.assertEqual(len(r['order_strata']),384)
        self.assertTrue(all(p['outcome']=='tie'for p in r['pairs']if p['rival']==OLD and p['candidate']==NEW))
    def test_slow_candidate_losses_and_no_build_trials(self):
        rows,m,q=self.fixture()
        for row in rows:
            if row['filter']==NEW:
                for metric in ['lookup_ns','hash_lookup_ns','inline_lookup_ns','inline_hash_lookup_ns','insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns']:row[metric]=str(float(row[metric])*100)
        r=analyze(rows,m,q);self.assertTrue(all(p['outcome']=='loss'for p in r['pairs']if p['candidate']==NEW))
        self.assertTrue(all(p['candidate_trials']==''for p in r['pairs']if 'insert' in p['metric']))
    def test_unequal_bytes_rejected(self):
        rows,m,q=self.fixture();rows[0]['filter_bytes']='128'
        with self.assertRaises(ValueError):analyze(rows,m,q)
    def test_incomplete_rejected(self):
        rows,m,q=self.fixture()
        with self.assertRaises(ValueError):analyze(rows[:-1],m,q)
if __name__=='__main__':unittest.main()
