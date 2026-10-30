import csv,importlib.util,io,json,sys,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
sys.path.insert(0,str(HERE));sys.path.insert(0,str(STAGE))
from derive import derive,blob,CALLER_COMMIT,OLD_CALLER
from derive_guard import generate
import guard
from contract import TINY,cases,K12,NEW,RANGE
class SourceTests(unittest.TestCase):
    def test_exact_two_hints_and_old_timer(self):
        report=derive();self.assertEqual(report['registry_size'],22)
        patch=(STAGE/'source.patch').read_text()
        self.assertEqual(patch.count('+    #[inline(always)]'),2)
        self.assertEqual(patch.count('-    #[inline]'),2)
    def test_validator_derivation(self):self.assertEqual((HERE/'guard.py').read_text(),generate())
    def test_fixed_coverage_and_seen_protocol(self):
        source=(STAGE/'benchmark/src/main.rs').read_text();tiny=cases(source)
        self.assertEqual((len(tiny),sum(len(x['filters'])for x in tiny)),(5,34))
        p=json.loads((STAGE/'protocol.json').read_text());self.assertEqual(p['calibration_power'],0)
        self.assertEqual((len(p['seeds'])*len(p['key_powers'])*len(p['batches']),p['expected_rows']),(24,72))
    def test_zero_calibration_and_reject_fabricated_sample(self):
        source=(STAGE/'benchmark/src/main.rs').read_text();case=cases(source)[0]
        parent=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/caller/validation-v1/normal-case-0.stdout'
        old=list(csv.DictReader(io.StringIO(parent.read_text())));selected={r['filter']:r for r in old if r['filter']in[K12,RANGE]}
        candidate=selected[K12].copy();candidate['filter']=NEW;candidate['implementation_origin']='K12_inline_experiment';selected[NEW]=candidate
        rows=[selected[n]for n in guard.expected_order(case,TINY,source)]
        for r in rows:r['calibration_absent_queries']='0';r['calibration_false_positives']='0'
        guard.validate_rows(rows,case,TINY,source)
        rows[0]['calibration_false_positives']='1'
        with self.assertRaises(ValueError):guard.validate_rows(rows,case,TINY,source)
if __name__=='__main__':unittest.main()
