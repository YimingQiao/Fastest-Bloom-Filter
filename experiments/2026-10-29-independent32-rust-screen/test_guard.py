"""Offline malformed-row checks using explicitly synthetic Independent32 rows."""
import copy
import csv
import io
import json
from pathlib import Path
import unittest

import guard

HERE = Path(__file__).resolve().parent


def fixture():
    preflight = HERE.parent / "2026-10-29-rust-leaf-inline/validation/preflight-results.json"
    data = json.loads(preflight.read_text())
    candidates = []
    for record in data["records"]:
        rows = list(csv.DictReader(io.StringIO(record.get("stdout", ""))))
        if len(rows) == 10 and rows[0]["requested_bpk"] == "8" and rows[0]["hit_percent"] == "50":
            candidates = rows
            break
    if not candidates:
        raise ValueError("frozen ten-config correctness fixture missing")
    new = copy.deepcopy(next(row for row in candidates if row["filter"] == "Split64BloomFilter"))
    new["filter"] = "Independent32BloomFilter"  # Metadata guard fixture only, never performance evidence.
    candidates.append(new)
    protocol = json.loads((HERE / "protocol.json").read_text())
    protocol.update(key_powers=[10], requested_bpk=[8], query_power=12, calibration_power=12,
                    repeats=4, rows=33, workloads=3, batches=[1, 31, 4096])
    rows = []
    for batch in protocol["batches"]:
        for source in candidates:
            row = dict(source, batch=str(batch), insert_batch="1024")
            rows.append(row)
    registry = json.loads((HERE / "registry.json").read_text())
    return rows, registry, protocol


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.rows, self.registry, self.protocol = fixture()

    def test_all_eleven_every_batch(self):
        guard.validate_all(self.rows, self.registry, self.protocol)

    def test_new_mapping_need_not_equal_split64(self):
        for row in self.rows:
            if row["filter"] == "Independent32BloomFilter":
                row["calibration_false_positives"] = "1"
        guard.validate_all(self.rows, self.registry, self.protocol)

    def test_missing_external_in_bulk(self):
        self.rows = [row for row in self.rows if not (row["batch"] == "31" and row["filter"] == "BloomsdayPinned")]
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_duplicate_candidate(self):
        self.rows[-1] = self.rows[-2]
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_candidate_cannot_be_external(self):
        self.registry["Independent32BloomFilter"]["owner"] = "external"
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_batch_cannot_change_calibration(self):
        self.rows[-1]["calibration_false_positives"] = str(int(self.rows[-1]["calibration_false_positives"]) + 1)
        with self.assertRaises(ValueError):
            guard.validate_all(self.rows, self.registry, self.protocol)

    def test_balanced_wrong_phase_labels(self):
        row = self.rows[-1]
        row["query_phase_order"] = ";".join("|".join(str((int(x)+1) % 4) for x in order.split("|"))
                                             for order in row["query_phase_order"].split(";"))
        with self.assertRaises(AssertionError):
            guard.validate_all(self.rows, self.registry, self.protocol)


if __name__ == "__main__":
    unittest.main()
