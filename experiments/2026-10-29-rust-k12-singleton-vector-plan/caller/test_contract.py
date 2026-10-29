import copy
import unittest
from contract import cases,validate_rows,FOUR,invalid

def fixture():
    row=dict(filter='Control',keys=256,queries=4096,batch=1,hit=50,seed=74381,repeats=4,
             filter_bytes=768,backend='avx512',input_digest=1,insert_digest=2,bitmap_digest=3,
             output_digest=4,scratch_bytes=8,phase_order=FOUR,calibration_queries=0,trials_ns=[[1,2,3,4]for _ in range(4)])
    return [row,dict(copy.deepcopy(row),filter='Candidate')]

class Contract(unittest.TestCase):
    def test_finite_grid(self):
        self.assertEqual(len(cases()),12)
        self.assertEqual(len({(c['hit'],c['batch'])for c in cases()}),12)
    def test_four_mode_balance(self):
        for position in range(4):self.assertEqual({r[position]for r in FOUR},set(range(4)))
        self.assertEqual(len({(r[i],r[i+1])for r in FOUR for i in range(3)}),12)
    def test_rows(self):validate_rows(fixture(),dict(hit=50,batch=1))
    def test_missing_or_wrong_arm(self):
        for rows in [fixture()[:1],list(reversed(fixture()))]:
            with self.assertRaises(ValueError):validate_rows(rows,dict(hit=50,batch=1))
    def test_output_and_geometry_identity(self):
        for key in ['filter_bytes','input_digest','bitmap_digest','output_digest','calibration_queries']:
            rows=fixture();rows[1][key]+=1
            with self.assertRaises(ValueError):validate_rows(rows,dict(hit=50,batch=1))
    def test_trials_and_disable(self):
        rows=fixture();rows[0]['trials_ns'][0][0]=float('nan')
        with self.assertRaises(ValueError):validate_rows(rows,dict(hit=50,batch=1))
        with self.assertRaises(ValueError):validate_rows(fixture(),dict(hit=50,batch=1),disabled=True)
    def test_rejections(self):
        self.assertEqual(len(invalid('/binary')),6)
        self.assertTrue(all(command[0]=='/binary'and diagnostic for command,diagnostic in invalid('/binary')))
    def test_actual_target_path_required(self):
        for backend in ['avx2','scalar']:
            rows=fixture()
            for row in rows:row['backend']=backend
            with self.assertRaises(ValueError):validate_rows(rows,dict(hit=50,batch=1))
        rows=fixture()
        for row in rows:row['backend']='avx2'
        validate_rows(rows,dict(hit=50,batch=1),disabled=True)
        for row in rows:row['backend']='scalar'
        with self.assertRaises(ValueError):validate_rows(rows,dict(hit=50,batch=1),disabled=True)

if __name__=='__main__':unittest.main()
