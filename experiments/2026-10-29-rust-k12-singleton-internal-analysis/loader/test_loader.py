import copy
from pathlib import Path
import unittest
from unittest import mock
import run


class LoaderTests(unittest.TestCase):
    def setUp(self):
        self.binding = dict(complete=True, analysis_commit=run.ANALYSIS_COMMIT,
                            producer_commit=run.PRODUCER_COMMIT)
        self.anchor = dict(complete=True, producer_commit=run.PRODUCER_COMMIT, raw_commit='b' * 40,
                           raw_manifest_sha256='c' * 64, screen_log_sha256='d' * 64,
                           execution_outcome_sha256='e' * 64, session_id=123)

    def test_exact_anchor(self):
        run.validate_anchor(self.anchor, self.binding)

    def test_partial_wrong_source_and_movable_ref(self):
        for key, value in [('complete', False), ('producer_commit', 'a' * 40), ('raw_commit', 'HEAD'),
                           ('raw_manifest_sha256', 'bad'), ('screen_log_sha256', None),
                           ('execution_outcome_sha256', 'bad'), ('session_id', True), ('session_id', 0)]:
            anchor = dict(self.anchor, **{key: value})
            with self.assertRaises(ValueError): run.validate_anchor(anchor, self.binding)
        with self.assertRaises(ValueError): run.validate_anchor(dict(self.anchor, extra=0), self.binding)
        with self.assertRaises(ValueError): run.validate_anchor(self.anchor, dict(self.binding, complete=False))
        with self.assertRaises(ValueError): run.validate_anchor(self.anchor, dict(self.binding, analysis_commit='a' * 40))

    def test_exact_log_and_partial_rejections(self):
        valid = ''.join(f'{i}/96 processes complete\n' for i in range(1, 97)).encode()
        final = b'Complete96 processes/192 rows; all final source/raw/semantic guards passed.\n'
        run.validate_log(valid + final)
        for invalid in [valid, valid + final + b'warning\n', valid.replace(b'2/96', b'1/96', 1) + final,
                        valid[:-10] + final, final]:
            with self.assertRaises(ValueError): run.validate_log(invalid)

    def test_actual_terminal_outcome(self):
        log = ''.join(f'{i}/96 processes complete\n' for i in range(1, 97)).encode()
        log += b'Complete96 processes/192 rows; all final source/raw/semantic guards passed.\n'
        anchor = dict(self.anchor, screen_log_sha256=run.hashlib.sha256(log).hexdigest())
        original = dict(complete=True, producer_commit=run.PRODUCER_COMMIT, session_id=123, exit_code=0,
                        screen_log_sha256=anchor['screen_log_sha256'],
                        terminal_tool_result={'exit_code': 0, 'output': ''})
        run.validate_terminal(original, anchor, log)
        for key, value in [('complete', False), ('session_id', 124), ('exit_code', 1),
                           ('screen_log_sha256', 'a' * 64),
                           ('terminal_tool_result', {'session_id': 123, 'output': ''}),
                           ('terminal_tool_result', {'exit_code': 0, 'session_id': 123, 'output': ''}),
                           ('terminal_tool_result', {'exit_code': 0, 'output': 'unexpected'}),
                           ('terminal_tool_result', {'exit_code': True, 'output': ''})]:
            with self.subTest(key=key, value=value):
                with self.assertRaises(ValueError):
                    run.validate_terminal(dict(original, **{key: value}), anchor, log)

    def test_no_unverified_import(self):
        with mock.patch.object(run, 'manifest_files', side_effect=ValueError('uncommitted source')), \
                mock.patch.object(run.importlib, 'import_module') as imported:
            with self.assertRaisesRegex(ValueError, 'uncommitted'): run.load('a' * 40, self.anchor)
            imported.assert_not_called()

    def test_absent_archive_never_imports_producer(self):
        files = {p.resolve() for p in run.PRODUCER.glob('*.py')} | {
            (run.HERE / 'run.py').resolve(), (run.HERE / 'binding.json').resolve(),
            (run.ANALYSIS / 'summarize.py').resolve()}
        binding = dict(self.binding, analysis_manifest_sha256='a' * 64, producer_manifest_sha256='b' * 64)
        with mock.patch.object(run, 'manifest_files', return_value=files), \
                mock.patch.object(run, 'read', return_value=binding), \
                mock.patch.object(Path, 'is_file', return_value=False), \
                mock.patch.object(run.importlib, 'import_module') as imported:
            with self.assertRaisesRegex(ValueError, 'unavailable'): run.load('a' * 40, self.anchor)
            imported.assert_not_called()

    def test_committed_bytes_and_path_escape(self):
        with mock.patch.object(run.subprocess, 'check_output', return_value=b'wrong'):
            with self.assertRaisesRegex(ValueError, 'committed artifact'):
                run.committed('a' * 40, run.HERE / 'run.py')
        with mock.patch.object(run, 'committed') as checked, \
                mock.patch.object(run, 'read', return_value={'files': {'../escape.py': 'c' * 64}}):
            with self.assertRaisesRegex(ValueError, 'escaped'):
                run.manifest_files(run.HERE, 'a' * 40, 'b' * 64, False)
            self.assertEqual(checked.call_count, 1)


if __name__ == '__main__':
    unittest.main()
