#!/usr/bin/env python3
"""Regression coverage for comparable timing and independent FPR evidence."""
import csv
import math
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/rank_external.py'
FIELDS = [
    'language', 'filter', 'keys', 'requested_bpk', 'filter_bytes', 'input_mode',
    'queries', 'repeats', 'hit_percent', 'batch', 'insert_batch', 'seed',
    'false_positives', 'absent_queries', 'hash_lookup_ns', 'lookup_ns',
    'calibration_absent_queries', 'calibration_false_positives',
]
BASE = dict(zip(FIELDS, [
    'cpp', 'A', '1024', '8', '2048', 'prehashed', '1048576', '3', '0',
    '4096', '1024', '42', '0', '1048576', '1', '0.5', '0', '0',
]))


def row(**changes):
    return dict(BASE, **{key: str(value) for key, value in changes.items()})


def calibrated(**changes):
    return row(**dict({
        'hit_percent': 100, 'false_positives': 0, 'absent_queries': 0,
        'calibration_absent_queries': 1048576,
        'calibration_false_positives': 10,
    }, **changes))


class RankingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.input = Path(self.temp.name) / 'rows.csv'
        self.output = Path(self.temp.name) / 'ranking.csv'

    def run_ranking(self, rows, *options, legacy=False):
        fields = FIELDS[:-2] if legacy else FIELDS
        with self.input.open('w', newline='') as stream:
            writer = csv.DictWriter(stream, fields, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(rows)
        return subprocess.run(
            [sys.executable, str(SCRIPT), str(self.input),
             '--output', str(self.output), *options],
            capture_output=True, text=True,
        )

    def ranked(self, rows, *options, legacy=False):
        result = self.run_ranking(rows, *options, legacy=legacy)
        self.assertEqual(result.returncode, 0, result.stderr)
        with self.output.open() as stream:
            return list(csv.DictReader(stream))

    def rejected(self, rows, message):
        result = self.run_ranking(rows)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(message, result.stderr)

    def test_legacy_zero_fp_retains_nonzero_one_sided_bound(self):
        ranked = self.ranked([row(), row(filter='B', hash_lookup_ns=2)], legacy=True)
        self.assertEqual(len(ranked), 6)
        z_squared = 1.6448536269514722 ** 2
        expected = z_squared / (1048576 + z_squared)
        for result in ranked:
            self.assertTrue(math.isclose(float(result['fpr_upper95']), expected))
            self.assertEqual(int(result['negative_samples']), 1048576)

    def test_duplicate_timing_rows_are_rejected(self):
        self.rejected([row(), row()], 'Duplicate timing case')

    def test_distinct_input_directories_cannot_share_a_series_basename(self):
        paths = []
        for parent, seed in (('first', 42), ('second', 43)):
            path = Path(self.temp.name) / parent / 'same-series' / 'rows.csv'
            path.parent.mkdir(parents=True)
            with path.open('w', newline='') as stream:
                writer = csv.DictWriter(stream, FIELDS)
                writer.writeheader()
                writer.writerow(row(seed=seed))
            paths.append(str(path))
        result = subprocess.run(
            [sys.executable, str(SCRIPT), *paths, '--output', str(self.output)],
            capture_output=True, text=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Distinct input directories share series basename', result.stderr)

    def test_contenders_must_use_matching_timing_seeds(self):
        self.rejected([row(), row(filter='B', seed=43)], 'Incomparable timing seed sets')

    def test_timing_seeds_must_have_calibration_evidence(self):
        self.rejected(
            [row(), row(hit_percent=50, seed=43)],
            'Calibration and timing seed sets differ',
        )

    def test_all_hit_without_any_negative_evidence_is_rejected(self):
        self.rejected(
            [row(hit_percent=100, absent_queries=0)],
            'Calibration and timing seed sets differ',
        )

    def test_all_hit_can_use_independent_negative_calibration(self):
        ranked = self.ranked([calibrated()], '--fpr-targets', '0.001')
        self.assertEqual(len(ranked), 1)
        self.assertEqual(ranked[0]['hit_percent'], '100')
        self.assertEqual(int(ranked[0]['negative_samples']), 1048576)
        self.assertEqual(float(ranked[0]['fpr_observed']), 10 / 1048576)

    def test_batch_and_insert_batch_repeats_do_not_add_negatives(self):
        ranked = self.ranked([
            row(), row(batch=31), row(insert_batch=31), row(batch=31, insert_batch=31),
        ])
        self.assertEqual(len(ranked), 12)
        self.assertTrue(all(int(result['negative_samples']) == 1048576 for result in ranked))

    def test_repeated_calibration_at_different_hit_rates_is_not_pooled(self):
        ranked = self.ranked([
            calibrated(hit_percent=0, absent_queries=1048576),
            calibrated(hit_percent=50, absent_queries=524288),
            calibrated(hit_percent=100),
            calibrated(hit_percent=100, batch=31),
        ], '--fpr-targets', '0.001')
        self.assertEqual(len(ranked), 4)
        self.assertTrue(all(int(result['negative_samples']) == 1048576 for result in ranked))

    def test_mismatched_independent_counts_for_identical_keys_are_rejected(self):
        self.rejected([
            calibrated(), calibrated(hit_percent=50, calibration_false_positives=11),
        ], 'same independent input stream')

    def test_mismatched_timed_counts_for_identical_keys_are_rejected(self):
        self.rejected([row(), row(batch=31, false_positives=1)], 'same timed input stream')

    def test_independent_evidence_wins_over_disjoint_timed_evidence(self):
        # Equal-sized streams have different keys; differing FP counts are valid.
        # A smaller independent stream must also not be replaced by timed misses.
        for independent_n in (1048576, 65536):
            with self.subTest(independent_n=independent_n):
                ranked = self.ranked([
                    row(false_positives=80),
                    calibrated(calibration_absent_queries=independent_n),
                ], '--fpr-targets', '0.001')
                self.assertEqual(len(ranked), 2)
                for result in ranked:
                    self.assertEqual(int(result['negative_samples']), independent_n)
                    self.assertEqual(float(result['fpr_observed']), 10 / independent_n)

    def test_prefix_extensions_count_only_the_longest_sample(self):
        ranked = self.ranked([
            calibrated(calibration_absent_queries=65536, calibration_false_positives=5),
            calibrated(batch=31, calibration_false_positives=10),
        ], '--fpr-targets', '0.001')
        self.assertEqual(len(ranked), 2)
        for result in ranked:
            self.assertEqual(int(result['negative_samples']), 1048576)
            self.assertEqual(float(result['fpr_observed']), 10 / 1048576)

    def test_prefix_extensions_cannot_lose_observed_false_positives(self):
        self.rejected([
            calibrated(calibration_absent_queries=65536, calibration_false_positives=11),
            calibrated(batch=31, calibration_false_positives=10),
        ], 'same independent input stream')

    def test_invalid_independent_sample_counts_are_rejected(self):
        for count, fp in ((-1, 0), (4096, -1), (4096, 4097)):
            with self.subTest(count=count, fp=fp):
                self.rejected([
                    calibrated(calibration_absent_queries=count, calibration_false_positives=fp),
                ], 'Invalid negative sample counts')

    def test_statistical_bound_excludes_fast_but_undermeasured_candidate(self):
        ranked = self.ranked([
            calibrated(filter='FastUncertain', hash_lookup_ns=0.1,
                       calibration_absent_queries=4096, calibration_false_positives=0),
            calibrated(filter='Measured', hash_lookup_ns=2, calibration_false_positives=50),
        ], '--fpr-targets', '0.0001')
        self.assertEqual([result['filter'] for result in ranked], ['Measured'])
        self.assertEqual(ranked[0]['rank'], '1')

    def test_ranking_uses_seed_median_instead_of_best_run(self):
        rows = []
        for seed, fast_outlier in zip((42, 43, 44), (0.1, 3, 3)):
            rows.extend([
                calibrated(filter='Outlier', seed=seed, hash_lookup_ns=fast_outlier),
                calibrated(filter='Consistent', seed=seed, hash_lookup_ns=2),
            ])
        ranked = self.ranked(rows, '--fpr-targets', '0.001')
        self.assertEqual([result['filter'] for result in ranked], ['Consistent', 'Outlier'])
        self.assertEqual([float(result['ns_per_key']) for result in ranked], [2, 3])
        self.assertTrue(all(int(result['negative_samples']) == 3 * 1048576 for result in ranked))
        self.assertTrue(all(int(result['timing_cases']) == 3 for result in ranked))

    def test_memory_screen_uses_actual_allocation_and_explicit_slack(self):
        rows = [
            calibrated(filter='Within', filter_bytes=2048, hash_lookup_ns=2),
            calibrated(filter='Slack', filter_bytes=2112, hash_lookup_ns=1),
            calibrated(filter='TooLarge', filter_bytes=2113, hash_lookup_ns=0.1),
        ]
        ranked = self.ranked(rows, '--max-bpk', '16', '--fpr-targets', '0.001')
        self.assertEqual([result['filter'] for result in ranked], ['Slack', 'Within'])
        self.assertTrue(all(result['memory_ceiling_bytes'] == '2112' for result in ranked))
        ranked = self.ranked(rows, '--max-bpk', '16', '--allocation-slack', '0',
                             '--fpr-targets', '0.001')
        self.assertEqual([result['filter'] for result in ranked], ['Within'])

    def test_different_query_working_sets_keep_separate_calibration_and_ranks(self):
        ranked = self.ranked([
            calibrated(calibration_absent_queries=65536),
            calibrated(queries=2097152, hash_lookup_ns=2),
        ], '--fpr-targets', '0.001')
        self.assertEqual(len(ranked), 2)
        self.assertTrue(all(result['rank'] == '1' for result in ranked))
        self.assertEqual(
            {result['queries']: int(result['negative_samples']) for result in ranked},
            {'1048576': 65536, '2097152': 1048576},
        )

    def test_raw_api_has_no_pure_lookup_ranking(self):
        rows = [calibrated(), calibrated(filter='Raw', input_mode='raw_bytes',
                                         lookup_ns='nan', hash_lookup_ns=0.1)]
        ranked = self.ranked(rows, '--metric', 'lookup_ns', '--fpr-targets', '0.001')
        self.assertEqual([result['filter'] for result in ranked], ['A'])
        ranked = self.ranked(rows, '--metric', 'hash_lookup_ns', '--fpr-targets', '0.001')
        self.assertEqual([result['filter'] for result in ranked], ['Raw', 'A'])


if __name__ == '__main__':
    unittest.main()
