import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
import run


class LoaderTests(unittest.TestCase):
    def test_full_commit_required_before_git(self):
        for commit in ('main', '50e08fbb', 'A'*40):
            with self.subTest(commit=commit), patch.object(run.subprocess, 'check_output') as git:
                with self.assertRaises(ValueError): run.exact(commit, run.HERE/'run.py')
                git.assert_not_called()

    def test_inventory_exact_names_digest_and_length(self):
        with tempfile.TemporaryDirectory() as name:
            directory = Path(name)
            (directory/'x').write_bytes(b'fixture')
            item = dict(sha256=hashlib.sha256(b'fixture').hexdigest(), bytes=7)
            manifest = directory/'manifest.json'
            manifest.write_text(json.dumps({'files': {'x': item}}))
            with patch.object(run, 'exact', side_effect=lambda c, p: p.read_bytes()):
                run.inventory('a'*40, directory, 'manifest.json', 1, {'x'})
                with self.assertRaises(ValueError): run.inventory('a'*40, directory, 'manifest.json', 2)
                with self.assertRaises(ValueError): run.inventory('a'*40, directory, 'manifest.json', 1, {'y'})
                item['bytes'] = 8
                manifest.write_text(json.dumps({'files': {'x': item}}))
                with self.assertRaises(ValueError): run.inventory('a'*40, directory, 'manifest.json', 1)
                item['bytes'] = 7
                item['sha256'] = '0'*64
                manifest.write_text(json.dumps({'files': {'x': item}}))
                with self.assertRaises(ValueError): run.inventory('a'*40, directory, 'manifest.json', 1)

    def test_manifest_escape_and_symlink_rejected(self):
        with tempfile.TemporaryDirectory() as name:
            directory = Path(name)/'local'
            directory.mkdir()
            outside = Path(name)/'outside'
            outside.write_bytes(b'x')
            (directory/'link').symlink_to(outside)
            for relative in ('../outside', 'link'):
                (directory/'manifest.json').write_text(json.dumps({'files': {relative: run.sha(outside)}}))
                with patch.object(run, 'exact', side_effect=lambda c, p: p.read_bytes()):
                    with self.assertRaises(ValueError): run.inventory('a'*40, directory, 'manifest.json', 1)

    def test_no_partial_input_or_dynamic_revision_switch(self):
        self.assertEqual(set(run.COMMITS), {'raw_commit', 'analysis_commit', 'scope_commit', 'producer_commit', 'catalog_commit', 'bridge_rule_commit'})
        self.assertTrue(all(len(v) == 40 for v in run.COMMITS.values()))
        self.assertNotIn('raw8', str(run.PRODUCER))
        self.assertEqual(len(run.SOURCE_FILES), 11)


if __name__ == '__main__':
    unittest.main()
