import json,unittest
from pathlib import Path
from dependencies import cargo_roots,owner_for

class CargoIdentity(unittest.TestCase):
    def record(self,root='/repo/after',stem='after-hash'):
        return {'reason':'compiler-artifact','manifest_path':root+'/Cargo.toml','package_id':'path+file://'+root+'#package@0.1.0',
                'target':{'src_path':root+'/src/lib.rs'},'filenames':['/target/deps/'+stem]}
    def test_exact_test_executable_owner(self):
        roots=cargo_roots([json.dumps(self.record())],Path('/target'))
        self.assertEqual(roots['/target/deps/after-hash.d']['manifest'],'/repo/after/Cargo.toml')
    def test_duplicate_source_names_remain_distinct(self):
        roots=cargo_roots([json.dumps(self.record('/repo/before','before-hash')),json.dumps(self.record())],Path('/target'))
        self.assertEqual(len(roots),2)
        self.assertNotEqual(roots['/target/deps/before-hash.d'],roots['/target/deps/after-hash.d'])
    def test_ambiguous_artifact_rejected(self):
        with self.assertRaises(ValueError):cargo_roots([json.dumps(self.record('/repo/before')),json.dumps(self.record())],Path('/target'))
    def test_wrong_package_and_escape_rejected(self):
        a=self.record();a['package_id']='path+file:///repo/before#package@0.1.0'
        with self.assertRaises(ValueError):cargo_roots([json.dumps(a)],Path('/target'))
        a=self.record();a['filenames']=['/another/after-hash']
        with self.assertRaises(ValueError):cargo_roots([json.dumps(a)],Path('/target'))
    def test_hashed_bin_depinfo_has_unique_structured_owner(self):
        a=self.record();a['target'].update(kind=['bin'],name='caller');a['filenames']=['/target/caller']
        roots=cargo_roots([json.dumps(a)],Path('/target'))
        self.assertEqual(owner_for(Path('/target/deps/caller-0123456789abcdef.d'),roots)['manifest'],'/repo/after/Cargo.toml')
        self.assertIsNone(owner_for(Path('/target/deps/caller-g123456789abcdef.d'),roots))
        b=self.record('/repo/before');b['target'].update(kind=['bin'],name='caller');b['filenames']=['/target/caller']
        with self.assertRaises(ValueError):cargo_roots([json.dumps(a),json.dumps(b)],Path('/target'))
    def test_library_hash_stem(self):
        a=self.record();a['filenames']=['/target/deps/libafter-hash.rlib','/target/deps/libafter-hash.rmeta']
        self.assertEqual(cargo_roots([json.dumps(a)],Path('/target'))['/target/deps/after-hash.d']['manifest'],'/repo/after/Cargo.toml')
if __name__=='__main__':unittest.main()
