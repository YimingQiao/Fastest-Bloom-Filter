"""Verify malformed rows and exact source order using unclaimed preflight data."""
import copy
import csv
import io
import json
from pathlib import Path
import unittest

import guard
from order_oracle import expected_order, registration

HERE = Path(__file__).resolve().parent


def fixture():
    preflight = json.loads((HERE / "validation-v2/preflight-results.json").read_text())
    source = (HERE / "benchmark/src/main.rs").read_text()
    names = registration(source)
    rows = None
    for record in preflight["records"]:
        values = list(csv.DictReader(io.StringIO(record.get("stdout", ""))))
        if len(values) == 13 and values[0]["requested_bpk"] == "8" and values[0]["hit_percent"] == "50" and values[0]["batch"] == "1":
            rows = values
            break
    if rows is None:
        raise ValueError("Missing actual thirteen-way preflight fixture")
    protocol = json.loads((HERE / "protocol.json").read_text())
    protocol.update(key_powers=[10], requested_bpk=[8], query_power=12, calibration_power=12,
                    repeats=4, rows=52, workloads=4, batches=[1, 2, 31, 4096])
    order = expected_order(42, 1024, 4096, 50, names)
    by_name = {row["filter"]: row for row in rows}
    # Repeated batch tags are synthetic guard fixtures, never measured speed.
    values = [dict(by_name[name], batch=str(batch), insert_batch="1024")
              for batch in protocol["batches"] for name in order]
    registry = json.loads((HERE / "registry.json").read_text())
    return values, registry, protocol


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.rows, self.registry, self.protocol = fixture()

    def test_exact_all_thirteen_every_batch(self):
        guard.validate_all(self.rows, self.registry, self.protocol)

    def test_missing_external(self):
        self.rows.pop(next(i for i, row in enumerate(self.rows) if row["filter"] == "BloomsdayPinned"))
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_reordered_complete_rows(self):
        self.rows[0], self.rows[1] = self.rows[1], self.rows[0]
        with self.assertRaisesRegex(ValueError, "permutation"):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_v2_semantic_drift(self):
        row = next(row for row in self.rows if row["filter"] == "Independent32ScalarInlineV2")
        row["result_checksum"] = str(int(row["result_checksum"]) ^ 1)
        with self.assertRaisesRegex(ValueError, "semantic"):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_balanced_wrong_phase_labels(self):
        row = self.rows[-1]
        row["query_phase_order"] = ";".join("|".join(str((int(x) + 1) % 4) for x in order.split("|")) for order in row["query_phase_order"].split(";"))
        with self.assertRaises(AssertionError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_v2_owner(self):
        self.registry["Independent32ScalarInlineV2"]["owner"] = "external"
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_every_actual_preflight_order(self):
        data = json.loads((HERE / "validation-v2/preflight-results.json").read_text())
        names = registration((HERE / "benchmark/src/main.rs").read_text())
        count = 0
        for record in data["records"]:
            rows = list(csv.DictReader(io.StringIO(record.get("stdout", ""))))
            if len(rows) != 13:
                continue
            row = rows[0]
            expected = expected_order(int(row["seed"]), int(row["keys"]), int(row["queries"]), int(row["hit_percent"]), names)
            self.assertEqual([row["filter"] for row in rows], expected)
            count += 1
        self.assertEqual(count, 18)


if __name__ == "__main__":
    unittest.main()
