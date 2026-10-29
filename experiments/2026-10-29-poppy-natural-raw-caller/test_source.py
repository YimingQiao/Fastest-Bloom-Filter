import re
import unittest
from pathlib import Path
import derive


class SourceTests(unittest.TestCase):
    def test_exact_parent_derivation_and_timed_helpers(self):
        expected=derive.expected()
        for name,data in expected.items():
            self.assertEqual((derive.HERE/name).read_bytes(),data,name)
        for name in ('reporter.rs','raw_contract.rs','tests.rs','reporter_tests.rs'):
            path='benchmark/src/'+name
            self.assertEqual(expected[path],derive.blob(derive.SOURCE,derive.PARENT+'/'+path))

    def test_original_registry_prefix_and_exact28_public_forms(self):
        parent=derive.blob(derive.SOURCE,derive.PARENT+'/benchmark/src/main.rs').decode()
        current=(derive.HERE/'benchmark/src/main.rs').read_text()
        def registry(text):
            block=re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];',text,re.S).group(1)
            return re.findall(r'"([A-Za-z0-9_]+)"',block)
        before,after=registry(parent),registry(current)
        self.assertEqual(len(before),45)
        self.assertEqual(after[:45],before)
        self.assertEqual(len(after),len(set(after)))
        expected=[f'PoppyRaw{form}{int(p["filter"].removeprefix("PoppyPublic")):03d}' for p in derive.points() for form in ('Byte','Typed')]
        self.assertEqual(after[45:],expected)
        for p in derive.points():
            ident=int(p['filter'].removeprefix('PoppyPublic'))
            for form,typed in [('Byte','false'),('Typed','true')]:
                self.assertIn(f'"PoppyRaw{form}{ident:03d}" => report::<PoppyRaw<{ident}, {typed}>>',current)
        self.assertIn('if selection.is_empty() { &FILTER_NAMES[..45] }',current)

    def test_all_constructor_test_ids_and_public_only_operations(self):
        tests=(derive.HERE/'benchmark/src/poppy_tests.rs').read_text()
        ids=list(map(int,re.search(r'both!\((\d+(?:,\d+)*)\)',tests).group(1).split(',')))
        self.assertEqual(ids,[int(p['filter'].removeprefix('PoppyPublic')) for p in derive.points()])
        raw=(derive.HERE/'benchmark/src/poppy_raw.rs').read_text()
        for call in ('self.0.contains(&raw)','self.0.contains_bytes(raw.to_le_bytes())','self.0.insert(&value)','self.0.insert_bytes(value.to_le_bytes())'):
            self.assertIn(call,raw)
        self.assertNotIn('hash64',raw)
        self.assertNotIn('CommonHash',raw)
        self.assertIn('fn scratch_words(_input_len: usize) -> usize { 0 }',raw)
        self.assertNotIn('poppy_filters::hash::',tests)

    def test_explicit_mapping_and_constructor_metadata(self):
        report=(derive.HERE/'benchmark/src/report.rs').read_text()
        for field in ('public_poppy_natural_byte8','public_poppy_natural_typed_u64','poppy_policy','poppy_fpp_bits','poppy_bucket_bytes','poppy_cache_bytes','poppy_source_configuration'):
            self.assertIn(field,report)
        manifest=(derive.HERE/'benchmark/Cargo.toml').read_text()
        self.assertIn('poppy-filters = { path = "../../../build/poppy-source/poppy" }',manifest)


if __name__=='__main__': unittest.main()
