import importlib.util,json,subprocess,sys,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parent;CALLER=HERE.parent;STAGE=CALLER.parent;ROOT=STAGE.parents[1]
sys.path.insert(0,str(HERE));sys.path.insert(0,str(CALLER))
import derive
from derive_guard import generate
from guard import source_registry,expected_order
from contract import cases
class Source(unittest.TestCase):
    def test_actual_caller_exact_old_body(self):self.assertEqual(derive.derive()['registry_size'],22)
    def test_original_hint_one_body_delta(self):
        spec=importlib.util.spec_from_file_location('native_derivation',STAGE/'derive.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);r=m.derive();self.assertEqual(r['production_body_changes'],1);self.assertTrue(r['original_ordinary_inline_hints']);self.assertFalse(r['new_unsafe'])
    def test_exact_guard_and_tiny_counts(self):
        self.assertEqual((HERE/'guard.py').read_text(),generate());s=(CALLER/'benchmark/src/main.rs').read_text();self.assertEqual(sum(len(c['filters'])for c in cases(s)),34)
    def test_seen_finite_order_shape(self):
        p=json.loads((STAGE/'protocol.json').read_text());s=(CALLER/'benchmark/src/main.rs').read_text();names=[n for n in source_registry(s)if n in ['Split64RangeBloomFilter','FourSectorRange12BloomFilter','FourSectorRange12SingleLineV1']]
        self.assertEqual(p['calibration_power'],0);self.assertEqual(p['expected_rows'],72)
        for n in p['key_powers']:
            orders=[expected_order(dict(key_power=n,seed=seed,filters=names),p,s)for seed in p['seeds']]
            self.assertEqual(sorted(x.index('FourSectorRange12SingleLineV1')for x in orders),[0,1,2])
            for a in names:
                for b in names:
                    if a!=b:self.assertIn(sum(x.index(a)<x.index(b)for x in orders),[1,2])
if __name__=='__main__':unittest.main()
