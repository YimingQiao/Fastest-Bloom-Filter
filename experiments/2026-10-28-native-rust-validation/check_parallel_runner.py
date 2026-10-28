#!/usr/bin/env python3
"""Offline checks of run_parallel grouping; no benchmark executable is run."""
import contextlib
import csv
import importlib.util
import io
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'scripts'))
spec = importlib.util.spec_from_file_location('parallel_runner', ROOT / 'scripts/run_parallel.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


def rows_for(families):
    result = []
    for family in families:
        # Different layouts legitimately have different checksums and FP counts.
        code = {'FastPattern': '7', 'FourSector': '11', 'Split64': '13'}[family]
        modes = ['Serial', 'Partitioned', 'Atomic'] if family == 'FastPattern' else ['Serial', 'Partitioned']
        for mode in modes:
            result.append({'filter': family + mode, 'result_checksum': code,
                           'filter_bytes': '128', 'absent_queries': '4096',
                           'false_positives': code})
    return result


class Grouping(unittest.TestCase):
    def invoke(self, families, rows, expected_error=None, cpus="5", threads="1"):
        with tempfile.TemporaryDirectory(prefix='bf-runner-mock-') as directory:
            path = Path(directory)
            executable = path / 'fixture-only'
            executable.write_bytes(b'offline test fixture; never executed')
            buffer = io.StringIO()
            writer = csv.DictWriter(buffer, fieldnames=['filter', 'result_checksum', 'filter_bytes', 'absent_queries', 'false_positives'])
            writer.writeheader()
            writer.writerows(rows)
            argv = ['run_parallel.py', '--executable', str(executable), '--output-dir', str(path / 'output'),
                    '--cpus', cpus, '--threads', threads, '--key-powers', '5', '--query-power', '12',
                    '--repeats', '1', '--seeds', '731', '--filters', families]
            completed = subprocess.CompletedProcess([], 0, buffer.getvalue(), '')
            with patch.object(sys, 'argv', argv), patch.object(runner, 'capture', return_value='offline-fixture'), \
                 patch.object(runner.os, 'sched_getaffinity', return_value={5}), \
                 patch.object(runner.subprocess, 'run', return_value=completed) as execute, \
                 contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
                if expected_error:
                    with self.assertRaises(expected_error):
                        runner.main()
                else:
                    runner.main()
                    self.assertEqual(execute.call_count, 1)
                    actual = execute.call_args.args[0]
                    if families == 'FastPattern':
                        self.assertEqual(actual[-1], '50')  # Legacy seven-argument binary invocation.
                    else:
                        self.assertEqual(actual[-1], families)
                    saved = list(csv.DictReader((path / 'output/results.csv').open()))
                    self.assertEqual(len(saved), len(rows))

    def test_valid_family_selections(self):
        for selection, families in [
            ('FastPattern', ['FastPattern']), ('FourSector', ['FourSector']), ('Split64', ['Split64']),
            ('FourSector,Split64', ['FourSector', 'Split64']),
            ('all', ['FastPattern', 'FourSector', 'Split64']),
            ('Split64,FastPattern', ['Split64', 'FastPattern']),
        ]:
            with self.subTest(selection=selection):
                self.invoke(selection, list(reversed(rows_for(families))))

    def test_invalid_family_arguments(self):
        for selection in ['', 'unknown', 'FastPattern,FastPattern', 'all,Split64']:
            with self.subTest(selection=selection):
                self.invoke(selection, [], SystemExit)

    def test_missing_duplicate_and_unexpected_modes(self):
        original = rows_for(['FastPattern'])
        cases = [original[:-1], original + [original[0]], [original[0], original[0], original[2]],
                 original[:-1] + [dict(original[-1], filter='UnknownAtomic')]]
        for index, rows in enumerate(cases):
            with self.subTest(case=index):
                self.invoke('FastPattern', rows, RuntimeError)

    def test_duplicate_cpu_ids_rejected(self):
        self.invoke('FastPattern', rows_for(['FastPattern']), SystemExit, cpus='5,5', threads='2')

    def test_family_answer_and_size_disagreement(self):
        for family in ['FastPattern', 'FourSector', 'Split64']:
            for field in ['result_checksum', 'filter_bytes', 'absent_queries', 'false_positives']:
                with self.subTest(family=family, field=field):
                    rows = rows_for([family])
                    rows[-1][field] = '999'
                    self.invoke(family, rows, RuntimeError)


if __name__ == '__main__':
    unittest.main(verbosity=2)
