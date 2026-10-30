import json,tempfile,unittest
from pathlib import Path
from nightly_dependencies import cargo_roots,owner_for

class Nightly(unittest.TestCase):
    def setup(self,root):
        release=root/'release';release.mkdir();final=release/'caller';final.write_bytes(b'actual binary')
        dep=release/'build/pkg/0123456789abcdef/out/caller.d';dep.parent.mkdir(parents=True)
        dep.with_suffix('').write_bytes(final.read_bytes())
        row={'reason':'compiler-artifact','manifest_path':'/repo/pkg/Cargo.toml','package_id':'path+file:///repo/pkg#pkg@0.1.0',
             'target':{'src_path':'/repo/pkg/src/main.rs','name':'caller','kind':['bin']},'filenames':[str(final)]}
        return dep,final,cargo_roots([json.dumps(row)],root)
    def test_exact_package_target_path_and_equal_binary(self):
        with tempfile.TemporaryDirectory()as d:
            dep,final,owners=self.setup(Path(d));o=owner_for(dep,owners)
            self.assertEqual(o['manifest'],'/repo/pkg/Cargo.toml')
            self.assertEqual(o['nightly_artifact_alias']['reported_executable'],str(final))
    def test_no_other_package_or_nonhex_path(self):
        with tempfile.TemporaryDirectory()as d:
            dep,_,owners=self.setup(Path(d))
            self.assertIsNone(owner_for(Path(str(dep).replace('/pkg/','/another/')),owners))
            self.assertIsNone(owner_for(Path(str(dep).replace('0123456789abcdef','not-a-hash')),owners))
    def test_changed_or_missing_actual_executable_rejected(self):
        with tempfile.TemporaryDirectory()as d:
            dep,_,owners=self.setup(Path(d));dep.with_suffix('').write_bytes(b'other')
            with self.assertRaises(ValueError):owner_for(dep,owners)
            dep.with_suffix('').unlink()
            with self.assertRaises(ValueError):owner_for(dep,owners)
if __name__=='__main__':unittest.main()
