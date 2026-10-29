import copy
import csv
import json
import io
import unittest
import summarize as s
class Guard(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows=list(csv.DictReader(io.StringIO((s.SCREEN/'results-v1/results.csv').read_text())));cls.q=json.loads((s.SCREEN/'results-v1/quality.json').read_text())
    def test_exact_grid_and_all_outcomes(self):
        pairs,conditions=s.calculate(self.rows,self.q);self.assertEqual(len(pairs),96);self.assertEqual(len(conditions),48);self.assertEqual(sum(x['candidate_row_position']==0 for x in pairs),48)
    def test_missing_duplicate_and_bytes(self):
        for label in['missing','duplicate','bytes']:
            rows=copy.deepcopy(self.rows)
            if label=='missing':rows.pop()
            elif label=='duplicate':rows[1]=rows[0]
            else:rows[0]['filter_bytes']='42'
            with self.assertRaises(ValueError,msg=label):s.calculate(rows,self.q)
    def test_failed_quality_does_not_remove_speed_rows(self):
        q=copy.deepcopy(self.q);q['api_size_seed_records'][0]['current_seed_pass']=False;q['family_size_all_seed_gates'][0]['all_fresh_seeds_pass']=False
        pairs,_=s.calculate(self.rows,q);self.assertEqual(len(pairs),96);self.assertTrue(any(not r['external_all_fresh_seeds_pass']for r in pairs))
    def test_exact_tie_retained(self):
        rows=copy.deepcopy(self.rows)
        for r in rows:r['lookup_ns']='1.0'
        pairs,_=s.calculate(rows,self.q);self.assertEqual(sum(r['metric']=='lookup_ns'and r['outcome']=='tie'for r in pairs),12)
if __name__=='__main__':unittest.main()
