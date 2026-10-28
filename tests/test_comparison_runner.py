"""Prevent silently dropping a requested baseline or accepting the wrong workload."""
import importlib.util
from pathlib import Path
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/run_comparison.py'
SPEC = importlib.util.spec_from_file_location('comparison_runner', SCRIPT)
RUNNER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RUNNER)


class ComparisonContract(unittest.TestCase):
    def rows(self):
        return [dict(language='cpp', filter=name, keys='32', queries='4096')
                for name in ('FastPatternBF', 'FastFilterFixed16')]

    def test_exact_selection(self):
        names = {'FastPatternBF', 'FastFilterFixed16'}
        self.assertEqual(RUNNER.validate_rows(self.rows(), names, {'keys': 32}), names)

    def test_partial_unknown_selection_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'missing=.*FastPatternBloomFilter'):
            RUNNER.validate_rows(self.rows()[1:], {'FastPatternBloomFilter', 'FastFilterFixed16'}, {})

    def test_unexpected_filter_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'unexpected='):
            RUNNER.validate_rows(self.rows(), {'FastPatternBF'}, {})

    def test_duplicate_and_empty_rows_are_rejected(self):
        for rows in ([], self.rows() + self.rows()):
            with self.subTest(rows=rows), self.assertRaises(ValueError):
                RUNNER.validate_rows(rows, None, {})

    def test_wrong_workload_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'keys=32, expected 64'):
            RUNNER.validate_rows(self.rows(), None, {'keys': 64})

    def test_missing_calibration_is_rejected(self):
        with self.assertRaises(KeyError):
            RUNNER.validate_rows(self.rows(), None, {'calibration_absent_queries': 4096})

    def test_one_language_per_executable(self):
        rows = self.rows()
        rows[1]['language'] = 'rust'
        with self.assertRaisesRegex(ValueError, 'one language'):
            RUNNER.validate_rows(rows, None, {})

    def test_all_selection_stays_consistent_between_cases(self):
        expected = RUNNER.validate_rows(self.rows(), None, {})
        with self.assertRaises(ValueError):
            RUNNER.validate_rows(self.rows()[:1], expected, {})

    def test_invalid_selection_syntax(self):
        for value in ('A,A', ',A', 'A,', 'A,,B', ' A', 'A, B'):
            with self.subTest(value=value), self.assertRaises(ValueError):
                RUNNER.selected_filters(value)
        self.assertIsNone(RUNNER.selected_filters(''))
        self.assertEqual(RUNNER.selected_filters('A,B'), {'A', 'B'})


if __name__ == '__main__':
    unittest.main()
