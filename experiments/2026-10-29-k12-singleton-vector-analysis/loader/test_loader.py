"""Synthetic anchor/manifest checks only; no actual raw or producer import."""
import copy
import unittest
from unittest import mock
from pathlib import Path

import run


class LoaderTests(unittest.TestCase):
    def setUp(self):
        self.binding = dict(complete=True, producer_commit='a' * 40)
        self.anchor = dict(complete=True, producer_commit='a' * 40, raw_commit='b' * 40,
                           raw_manifest_sha256='c' * 64, screen_log_sha256='d' * 64)

    def test_exact_anchor(self):
        run.validate_anchor(self.anchor, self.binding)

    def test_partial_source_and_movable_commit_reject(self):
        for key, value in (('complete', False), ('producer_commit', 'e' * 40),
                           ('raw_commit', 'HEAD'), ('raw_manifest_sha256', 'abc'),
                           ('screen_log_sha256', None)):
            anchor = copy.deepcopy(self.anchor)
            anchor[key] = value
            with self.assertRaises(ValueError):
                run.validate_anchor(anchor, self.binding)
        with self.assertRaises(ValueError):
            run.validate_anchor(dict(self.anchor, extra=0), self.binding)
        with self.assertRaises(ValueError):
            run.validate_anchor(self.anchor, dict(self.binding, complete=False))

    def test_absent_anchor_never_imports_producer(self):
        with mock.patch.object(run, 'read', return_value=self.binding), \
                mock.patch.object(Path, 'is_file', return_value=False), \
                mock.patch.object(run.importlib, 'import_module') as imported:
            with self.assertRaisesRegex(ValueError, 'unavailable'):
                run.load()
            imported.assert_not_called()

    def test_uncommitted_bytes_reject(self):
        path = run.HERE / 'run.py'
        with mock.patch.object(run.subprocess, 'check_output', return_value=b'wrong'):
            with self.assertRaisesRegex(ValueError, 'committed artifact bytes'):
                run.committed('a' * 40, path)

    def test_escaped_manifest_rejects_before_source_read(self):
        with mock.patch.object(run, 'committed') as checked, \
                mock.patch.object(run, 'read', return_value={'files': {'../escape.py': 'a' * 64}}):
            with self.assertRaisesRegex(ValueError, 'escaped'):
                run.manifest_files(run.HERE, 'a' * 40, 'b' * 64, False)
            self.assertEqual(checked.call_count, 1)


if __name__ == '__main__':
    unittest.main()
