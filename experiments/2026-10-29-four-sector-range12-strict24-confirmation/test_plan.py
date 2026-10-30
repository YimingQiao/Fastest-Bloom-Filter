"""Source-only selected union, deterministic order and disjoint counter domains."""
import json
import unittest
import plan
class Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.data=plan.derive()
    def test_exact_frozen_selection(self):self.assertEqual(json.loads((plan.HERE/'selection.json').read_text()),self.data)
    def test_full_counts_and_uniform_calibration(self):
        cases=self.data['cases'];self.assertEqual(len(cases),24);self.assertEqual(sum(len(x['filters'])for x in cases),78)
        self.assertEqual(sum(len(x['filters'])for x in cases if x['track']=='primary24'),60)
        self.assertTrue(all(x['command'][-3:]==['26','query-only','0']and x['command'][6]=='6'for x in cases))
        self.assertEqual((self.data['api_geometry_seed_quality_records'],self.data['known_mapping_seed_quality_records']),(39,33))
    def test_first_middle_last_and_rejection_ledger(self):
        accepted=[r for r in self.data['seed_ledger']if r['accepted']];self.assertEqual([r['seed']for r in accepted],self.data['seeds'])
        self.assertEqual([r['target_position']for r in accepted],[0,2,4]);self.assertTrue(all(set(r['observed_positions'].values())=={r['target_position']}and r['raw_domain_disjoint']for r in accepted))
        for row in self.data['seed_ledger']:self.assertEqual(row['accepted'],row['order_qualifies']and row['raw_domain_disjoint'])
    def test_disjoint_envelopes_and_within_workload_domains(self):
        domains=[plan.domain(power,seed)for seed in self.data['seeds']for power in(16,25)]
        for row in domains:
            a,b,c=row['inserted'],row['timed_negative_envelope'],row['independent_calibration'];self.assertEqual(a[1],b[0]);self.assertEqual(b[1],c[0]);self.assertEqual(c[1]-c[0],1<<26)
            for old in self.data['training_counter_envelopes_excluded']:self.assertFalse(plan.overlaps(row['full_counter_envelope'],old))
        for i,a in enumerate(domains):
            for b in domains[:i]:self.assertFalse(plan.overlaps(a['full_counter_envelope'],b['full_counter_envelope']))
if __name__=='__main__':unittest.main()
