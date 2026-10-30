"""Synthetic archive guards only; these tests do not execute a Bloom filter."""
import copy,csv,unittest
from pathlib import Path
from driver import quality,wilson
class Guards(unittest.TestCase):
 def setUp(self):
  p=Path(__file__).resolve().parent.parent/'2026-10-29-four-sector-range24/accuracy/results/results.stdout'
  with p.open()as f:self.old=list(csv.DictReader(f))
  self.rows=[dict(r,filter=f'FourSectorRangeK{k}')for r in self.old if r['filter']=='FourSectorRange24'for k in (8,9,10,12)]
 def test_complete_fixture(self):self.assertEqual(len(quality(self.rows,self.old)),24)
 def test_missing(self):
  with self.assertRaises(ValueError):quality(self.rows[:-1],self.old)
 def test_duplicate(self):
  self.rows[-1]=self.rows[-2]
  with self.assertRaises(ValueError):quality(self.rows,self.old)
 def test_wrong_contract(self):
  for field,value in [('filter_bytes','1'),('seed','43'),('calibration_negatives','8388608'),('checksum','-1'),('false_positives','-1')]:
   with self.subTest(field=field):
    rows=copy.deepcopy(self.rows);rows[1][field]=value
    with self.assertRaises(ValueError):quality(rows,self.old)
 def test_k8_replay(self):
  for field in ('false_positives','checksum'):
   rows=copy.deepcopy(self.rows);rows[0][field]=str(int(rows[0][field])+1)
   with self.assertRaises(ValueError):quality(rows,self.old)
 def test_old_control_missing(self):
  with self.assertRaises(ValueError):quality(self.rows,self.old[:-1])
 def test_extra_field(self):
  self.rows[0]['time']='1'
  with self.assertRaises(ValueError):quality(self.rows,self.old)
 def test_bounds(self):
  self.assertAlmostEqual(wilson(0,100)[0],0);self.assertGreater(wilson(0,100)[1],0)
  with self.assertRaises(ValueError):wilson(101,100)
if __name__=='__main__':unittest.main()
