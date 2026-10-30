"""Read-only source/selection tests; no compiler or Bloom calls."""
import json
import unittest
import plan as candidate

class Selection(unittest.TestCase):
    def test_complete_selection_is_reproducible(self):
        self.assertEqual(candidate.derive(),json.loads((candidate.HERE/'selection.json').read_text()))
    def test_all48_query_and_build_decisions(self):
        doc=json.loads((candidate.HERE/'selection.json').read_text())
        self.assertEqual(len(doc['decisions']),48)
        self.assertEqual({r['metric']for r in doc['decisions']},set(candidate.METRICS))
        self.assertEqual(doc['external_union'],[dict(filter='Fastbloom017K7',actual_bpk=24.0)])
    def test_external_support_and_pair_order(self):
        doc=json.loads((candidate.HERE/'selection.json').read_text())
        self.assertEqual(len(doc['all_external_capacity_quality_support']),60)
        self.assertEqual({r['filter']for r in doc['all_external_capacity_quality_support']},candidate.guard.EXTERNAL)
        self.assertEqual(len(doc['cases']),12)
        self.assertTrue(all(len(r['case']['filters'])==2 for r in doc['cases']))
        self.assertTrue(all(r['seed_orders'][0]==list(reversed(r['seed_orders'][1]))for r in doc['pair_order_proof']))

if __name__=='__main__':unittest.main()
