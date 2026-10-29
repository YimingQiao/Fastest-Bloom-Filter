"""Narrow source closure repair checks; no compiler/filter execution."""
import copy,json,subprocess,unittest
from pathlib import Path
from unittest import mock
import bindings as b
class Repair(unittest.TestCase):
    def test_four_members_match_frozen_archive_and_lock(self):
        tree=json.loads((b.CALLER/'resolution-v1/prepared-package-trees.json').read_text())
        before=copy.deepcopy(tree);extra=b.add_cc_source_members(tree)
        self.assertEqual(len(tree['file_sha256']),4487);self.assertEqual(len(extra),1)
        self.assertEqual(len(set(tree['file_sha256'])-set(before['file_sha256'])),4)
        for key,value in before['file_sha256'].items():self.assertEqual(tree['file_sha256'][key],value)
    def test_wrong_archive_is_rejected(self):
        tree=json.loads((b.CALLER/'resolution-v1/prepared-package-trees.json').read_text())
        with mock.patch.object(b,'sha',return_value='0'*64):
            with self.assertRaises(ValueError):b.add_cc_source_members(tree)
    def test_exact_parent_driver_helpers_and_binding_delta(self):
        derived=json.loads((b.HERE/'DERIVED.json').read_text())
        for name,digest in derived['byte_identical_files'].items():
            self.assertEqual(b.sha(b.HERE/name),digest)
            self.assertEqual((b.HERE/name).read_bytes(),subprocess.check_output(['git','show',derived['parent_commit']+':'+derived['parent_directory']+'/'+name],cwd=b.ROOT))
        old=subprocess.check_output(['git','show',derived['parent_commit']+':'+derived['parent_directory']+'/bindings.py'],cwd=b.ROOT,text=True)
        import difflib
        self.assertEqual(''.join(difflib.unified_diff(old.splitlines(True),(b.HERE/'bindings.py').read_text().splitlines(True),fromfile='frozen-v1/bindings.py',tofile='repair-v2/bindings.py')),(b.HERE/'bindings.patch').read_text())
if __name__=='__main__':unittest.main()
