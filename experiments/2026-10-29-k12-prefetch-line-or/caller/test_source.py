"""Offline source/CLI-shape guards; no compiler or BF execution."""
import unittest
from pathlib import Path
from derive import outputs
from contract import CASES,TYPES,command,ordered_rows
HERE=Path(__file__).resolve().parent
class SourceTests(unittest.TestCase):
 def test_exact_source_derivation(self):
  files,_=outputs()
  for name,text in files.items():self.assertEqual((HERE/name).read_text(),text)
 def test_latin_positions(self):
  orders=[list(TYPES[i:]+TYPES[:i])for i in range(3)]
  for col in range(3):self.assertEqual(set(row[col]for row in orders),set(TYPES))
 def test_fixed_old_seed_and_true_branch(self):
  self.assertEqual({c['seed']for c in CASES},{74381});self.assertEqual([3*(1<<c['power'])>2097152 for c in CASES],[False,True])
 def test_selection_index(self):
  for c in CASES:self.assertEqual(command('/fixed',c)[8],','.join(TYPES))
 def test_only18checker_cases(self):
  source=(HERE/'check.cpp').read_text();self.assertIn('Need(cases == 18',source);self.assertNotIn('cases == 1642',source)
 def test_flags_reject_before_workload(self):
  source=(HERE/'compare_benchmark.cpp').read_text();self.assertLess(source.index('filter order must be latin0'),source.index('size_t n = size_t {1} << power'));self.assertIn('const auto registration_order = jobs;',source)
if __name__=='__main__':unittest.main()
