"""CLI contract checks without throughput or large allocations."""
import contextlib
import io
import sys
import unittest
from unittest.mock import patch

import run


class CliTests(unittest.TestCase):
    def parse(self, *extra):
        argv = ["run.py", "--native", "unused.so", "--output", "unused.json", *extra]
        with patch.object(sys, "argv", argv), contextlib.redirect_stderr(io.StringIO()):
            return run.parse_args()

    def test_defaults_are_accuracy_only(self):
        args, configs, selected = self.parse()
        self.assertFalse(args.measure)
        self.assertEqual(len(selected), 8)
        self.assertEqual(len(configs), 4)

    def test_probe_defaults_change_exact_names(self):
        args, configs, selected = self.parse("--probes", "11")
        self.assertTrue(all("K11" in name for name in configs))
        self.assertTrue(set(configs) <= set(selected))

    def test_invalid_exact_selections(self):
        for selected in ("", "FastPatternBF,Typo", "FastPatternBF,FastPatternBF", "FastPatternBF,"):
            with self.subTest(selected=selected), self.assertRaises(SystemExit):
                self.parse("--filters", selected)

    def test_invalid_ranges(self):
        for key, value in (("--seed", "-1"), ("--construction-seed", str(1 << 64)),
                           ("--requested-bpk", "0"), ("--batch", "0"), ("--hit", "101"),
                           ("--probes", "0"), ("--calibration-power", "11")):
            with self.subTest(key=key), self.assertRaises(SystemExit):
                self.parse(key, value)

    def test_balanced_measurement_requires_six(self):
        with self.assertRaises(SystemExit):
            self.parse("--measure", "--repeats", "5")
        args, _, _ = self.parse("--measure", "--repeats", "12")
        self.assertTrue(args.measure)


if __name__ == "__main__":
    unittest.main()
