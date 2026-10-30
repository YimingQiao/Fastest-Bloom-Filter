"""Offline malformed-row and source/order tests; never execute a BF."""
import copy
import csv
import fcntl
import io
import json
import math
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import contract as c
import source_guard as sg


def fixture():
    p = c.protocol()
    reg = c.dimensions(p)
    with (c.PARENT / "screen/results.csv").open(newline="") as stream:
        template = next(csv.DictReader(stream))
    rows = []
    by_name = {r["filter"]: r for r in p["configurations"]}
    for case in p["cases"]:
        part = []
        order = c.expected_order(reg, case["filters"], 65536, 1 << 22, case["seed"], 50)
        for name in order:
            row, g = dict(template), by_name[name]
            for key in ("configuration_id", "calibration_identity"):
                row.pop(key, None)
            for key in c.GEOMETRY:
                row[key] = g[key]
            row.update(filter=name, keys="65536", queries=str(1 << 22), requested_bpk="16",
                       language="cpp", measurement_mode="query_only", budget_mode="exact_backing_bytes",
                       input_mode="prehashed", hash_bits="64", hit_percent="50", batch=str(case["batch"]),
                       repeats="6", query_repeats="6", seed=str(case["seed"]), build_repeats="0",
                       insert_batch="65536", calibration_absent_queries=str(1 << 24),
                       harness_hash_scratch_bytes=str(8 * case["batch"]), filter_build_scratch_bytes="0",
                       actual_bpk=str(8 * int(g["filter_bytes"]) / 65536),
                       present_queries="2097154", absent_queries="2097150", false_positives="5",
                       calibration_false_positives="100", result_checksum="12345", fpr=str(5 / 2097150),
                       query_phase_order=";".join("H>P" if (case["seed"] + r) & 1 else "P>H" for r in range(6)))
            for field in ("insert_ns", "allocate_insert_ns", "hash_insert_ns", "allocate_hash_insert_ns"):
                row[field] = "nan"
            for metric in ("lookup", "hash_lookup"):
                row[metric + "_trials_ns"] = "[1,2,3,4,5,6]"
                row[metric + "_ns"] = "3.5"
                row[metric + "_min_ns"] = "1"
                row[metric + "_max_ns"] = "6"
            part.append(row)
        rows.extend(c.validate_case(part, p, case, reg))
    return p, reg, rows


class RowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.p, cls.reg, cls.rows = fixture()

    def altered(self, change):
        rows = copy.deepcopy(self.rows)
        change(rows)
        with self.assertRaises((AssertionError, ValueError)):
            c.validate_matrix(rows, self.p, self.reg)

    def test_complete_cardinalities_and_diagnostic(self):
        q = c.validate_matrix(self.rows, self.p, self.reg)
        self.assertEqual(len(q["api_seed_records"]), 48)
        self.assertEqual(len(q["mapping_seed_records"]), 36)
        diagnostic = next(r for r in q["across_seed_gate"] if r["filter"] == c.FOUR)
        self.assertTrue(diagnostic["all_fresh_seeds_pass"])
        self.assertTrue(diagnostic["main_competitive_eligible"])
        self.assertFalse(diagnostic["robust_eligible"])
        self.assertTrue(all(r["negatives"] == 1 << 24 for r in q["mapping_seed_records"]))

    def test_missing_late_row(self):
        self.altered(lambda rows: rows.pop())

    def test_wrong_order_even_same_row_set(self):
        self.altered(lambda rows: rows.__setitem__(slice(0, 8), rows[:8][::-1]))

    def test_last_trial_nan(self):
        self.altered(lambda rows: rows[-1].__setitem__("hash_lookup_trials_ns", "[1,2,3,4,5,NaN]"))

    def test_wrong_trial_median(self):
        self.altered(lambda rows: rows[-1].__setitem__("lookup_ns", "2"))

    def test_boolean_trial_is_not_a_duration(self):
        def change(rows):
            row = rows[-1]
            row["lookup_trials_ns"] = "[true,true,true,true,true,true]"
            for suffix in ("_ns", "_min_ns", "_max_ns"):
                row["lookup" + suffix] = "1"
        self.altered(change)

    def test_other_balanced_phase_order(self):
        self.altered(lambda rows: rows[0].__setitem__("query_phase_order", ";".join(reversed(rows[0]["query_phase_order"].split(";")))))

    def test_large_seed_preserves_integer_precision(self):
        self.assertGreater(max(int(r["seed"]) for r in self.rows), 1 << 63)
        self.altered(lambda rows: rows[-1].__setitem__("seed", str(int(rows[-1]["seed"]) + 1)))

    def test_byte_budget_drift(self):
        self.altered(lambda rows: rows[0].__setitem__("filter_bytes", "131073"))

    def test_probe_metadata_drift(self):
        self.altered(lambda rows: rows[0].__setitem__("effective_probes", "9"))

    def test_wrong_calibration_interval(self):
        self.altered(lambda rows: rows[0].__setitem__("calibration_absent_queries", str(1 << 25)))

    def test_dense_checksum_cross_batch_drift(self):
        self.altered(lambda rows: rows[8].__setitem__("result_checksum", "54321"))

    def test_alias_quality_mismatch(self):
        def change(rows):
            next(r for r in rows if r["filter"] == "FastFilterFixed64")["calibration_false_positives"] = "101"
        self.altered(change)

    def test_false_annotation(self):
        self.altered(lambda rows: rows[0].__setitem__("calibration_identity", "wrong"))

    def test_one_failing_fresh_seed_is_not_pooled_away(self):
        rows = copy.deepcopy(self.rows)
        for row in rows:
            if row["filter"] == c.MUL and int(row["seed"]) == self.p["seeds"][0]:
                row["calibration_false_positives"] = "20000"
        q = c.validate_matrix(rows, self.p, self.reg)
        candidate = next(r for r in q["across_seed_gate"] if r["filter"] == c.MUL)
        self.assertFalse(candidate["all_fresh_seeds_pass"])
        self.assertFalse(candidate["main_competitive_eligible"])
        self.assertFalse(candidate["robust_eligible"])
        self.assertEqual(sum(not r["current_pass"] for r in q["api_seed_records"] if r["filter"] == c.MUL), 1)

    def test_diagnostic_rule_cannot_be_removed(self):
        p = copy.deepcopy(self.p)
        p["known_failed_diagnostic"] = []
        with self.assertRaises(ValueError):
            c.dimensions(p)

    def test_case_rotation_is_fixed(self):
        p = copy.deepcopy(self.p)
        p["cases"][0], p["cases"][1] = p["cases"][1], p["cases"][0]
        with self.assertRaises(ValueError):
            c.dimensions(p)

    def test_planner_geometry_identity_is_fixed(self):
        p = copy.deepcopy(self.p)
        p["configurations"][0]["constructor_argument"] = "131008"
        with self.assertRaises(ValueError):
            c.dimensions(p)

    def test_raw_columns_reject_duplicates(self):
        with self.assertRaises(ValueError):
            c.parse_raw(b"filter,filter\na,b\n")

    def test_raw_round_trip(self):
        rows = [{k: v for k, v in r.items() if k not in ("configuration_id", "calibration_identity")} for r in self.rows[:8]]
        out = io.StringIO()
        writer = csv.DictWriter(out, fieldnames=c.raw_fields())
        writer.writeheader()
        writer.writerows(rows)
        self.assertEqual(c.parse_raw(out.getvalue().encode()), rows)

    def test_wilson_exact_endpoints(self):
        self.assertEqual(c.wilson(0, 100)[0], 0)
        self.assertEqual(c.wilson(100, 100)[1], 1)
        self.assertTrue(0 < c.wilson(0, 100)[1] < 1)
        with self.assertRaises(ValueError):
            c.wilson(101, 100)


class LeaseTests(unittest.TestCase):
    def test_wrong_environment(self):
        with patch.dict(os.environ, {"BF_SOCKET_LEASE": "wrong"}), self.assertRaises(ValueError):
            sg.require_lease(3)

    def test_wrong_affinity(self):
        with patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(os, "sched_getaffinity", return_value={3, 5}), self.assertRaises(ValueError):
            sg.require_lease(3)

    def test_actual_exclusive_description_required(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "lease.lock"
            with path.open("w") as stream, patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(os, "sched_getaffinity", return_value={3}):
                with self.assertRaises(ValueError):
                    sg.require_lease(3, path)
                fcntl.flock(stream.fileno(), fcntl.LOCK_EX)
                self.assertIn(stream.fileno(), sg.require_lease(3, path)["inherited_lock_descriptors"])
                fcntl.flock(stream.fileno(), fcntl.LOCK_UN)
                fcntl.flock(stream.fileno(), fcntl.LOCK_SH)
                with self.assertRaises(ValueError):
                    sg.require_lease(3, path)

    def test_unrelated_held_lock_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            held, expected = Path(directory) / "held.lock", Path(directory) / "expected.lock"
            expected.touch()
            with held.open("w") as stream, patch.dict(os.environ, {"BF_SOCKET_LEASE": "socket1-cpu3"}), patch.object(os, "sched_getaffinity", return_value={3}):
                fcntl.flock(stream.fileno(), fcntl.LOCK_EX)
                with self.assertRaises(ValueError):
                    sg.require_lease(3, expected)

    def test_exclusive_flock_is_inherited_by_child(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "inherited.lock"
            with path.open("w") as stream:
                fcntl.flock(stream.fileno(), fcntl.LOCK_EX)
                script = "import sys,os;sys.path.insert(0,sys.argv[1]);import source_guard as g;os.sched_getaffinity=lambda _: {3};print(g.require_lease(3,sys.argv[2]))"
                env = dict(os.environ, BF_SOCKET_LEASE="socket1-cpu3")
                command = [sys.executable, "-c", script, str(sg.HERE), str(path)]
                accepted = subprocess.run(command, env=env, pass_fds=(stream.fileno(),), capture_output=True, text=True)
                self.assertEqual(accepted.returncode, 0, accepted.stderr)
                # A lock held elsewhere without its inherited description does
                # not authorize this child, even with matching environment.
                rejected = subprocess.run(command, env=env, capture_output=True, text=True)
                self.assertNotEqual(rejected.returncode, 0)
                self.assertIn("Actual inherited exclusive flock", rejected.stderr)

    def test_optimized_python_fails_before_parsing(self):
        for name in ("run.py", "audit.py"):
            result = subprocess.run([sys.executable, "-O", str(sg.HERE / name), "--help"], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Do not use Python -O", result.stderr)
            self.assertNotIn("usage:", result.stdout)


if __name__ == "__main__":
    unittest.main()
