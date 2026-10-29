"""Exercise the unchanged producer audit against malformed recovered ledgers."""
import copy
import unittest
import recover
from test_run import Runner as SyntheticFixture

class LedgerAudit(unittest.TestCase):
    def setUp(self):
        self.fixture=SyntheticFixture('test_complete336');self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
    def test_overwritten_original_is_not_accepted_as_ledger(self):
        self.fixture.meta['cases']=18
        with self.assertRaises((TypeError,ValueError)):self.fixture.audit()
    def test_missing_duplicate_or_changed_command_rejected(self):
        before=copy.deepcopy(self.fixture.meta)
        for kind in ['missing','duplicate','command']:
            self.fixture.meta=copy.deepcopy(before)
            if kind=='missing':self.fixture.meta['cases'].pop()
            elif kind=='duplicate':self.fixture.meta['cases'][1]=self.fixture.meta['cases'][0]
            else:self.fixture.meta['cases'][0]['command'][1]='25'
            with self.assertRaises(ValueError):self.fixture.audit()
    def test_exact_synthetic_ledger_passes(self):self.assertEqual(len(self.fixture.audit()[0]),336)

if __name__=='__main__':unittest.main()
