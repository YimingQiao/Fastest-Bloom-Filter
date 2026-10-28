import copy
import json
from pathlib import Path
import unittest

from guard import quality_rows, select, track_names, validate_all, validate_registry, validate_rows, wilson, workloads

HERE = Path(__file__).resolve().parent
PROTOCOL = json.loads((HERE / "protocol.json").read_text())
REGISTRY = json.loads((HERE / "registry.json").read_text())


def synthetic_rows():
    rows = []
    for power, bpk, batch, seed in workloads(PROTOCOL):
        n, q = 1 << power, 1 << PROTOCOL["query_power"]
        present = q // 100 * 50 + min(q % 100, 50)
        for name in REGISTRY:
            row = dict(language="rust", filter=name, keys=n, queries=q, requested_bpk=bpk,
                       filter_bytes=n * bpk // 4, actual_bpk=2 * bpk, hash_bits=64,
                       hit_percent=50, present_queries=present, batch=batch, repeats=5, seed=seed,
                       insert_batch=n, absent_queries=q - present, false_positives=10,
                       fpr=10 / (q - present), result_checksum=123, input_mode="prehashed",
                       calibration_absent_queries=1 << 24, calibration_false_positives=1000,
                       lookup_min_ns=0.9, lookup_ns=1.0, lookup_max_ns=1.1,
                       hash_lookup_min_ns=1.9, hash_lookup_ns=2.0, hash_lookup_max_ns=2.1,
                       insert_ns=3.0, allocate_insert_ns=4.0,
                       hash_insert_ns=5.0, allocate_hash_insert_ns=6.0)
            rows.append({key: str(value) for key, value in row.items()})
    return rows


class GuardTests(unittest.TestCase):
    def test_complete_matrix_and_calibration_deduplication(self):
        rows = synthetic_rows()
        validate_all(rows, REGISTRY, PROTOCOL)
        quality = quality_rows(rows, REGISTRY)
        self.assertEqual(len(rows), 168)
        self.assertEqual(len(quality), 28)
        self.assertTrue(all(row["calibration_negatives"] == 1 << 24 for row in quality))

    def test_native_singletons_never_become_external(self):
        external = track_names(REGISTRY, "best_public_paths", "external")
        self.assertEqual(len(external), 6)
        self.assertNotIn("ByteNativeSingleApiV1", external)
        self.assertNotIn("SplitNativeSingleApiV1", external)
        registry = copy.deepcopy(REGISTRY)
        registry["ByteNativeSingleApiV1"]["owner"] = "external"
        with self.assertRaises(ValueError):
            validate_registry(registry)

    def test_exact_memory_cap_has_no_padding_slack(self):
        row = next(r for r in synthetic_rows() if r["filter"] == "SbbfSafePinned")
        selected = select([row], REGISTRY, {"SbbfSafePinned"}, "lookup_ns", 1 << 16, 1, 16, 0.0001)
        self.assertIsNotNone(selected)
        row["filter_bytes"] = str(int(row["filter_bytes"]) + 1)
        self.assertIsNone(select([row], REGISTRY, {"SbbfSafePinned"}, "lookup_ns", 1 << 16, 1, 16, 0.0001))

    def test_two_sided_wilson_and_nonzero_zero_event_bound(self):
        low, high = wilson(0, 100)
        self.assertEqual(low, 0)
        self.assertAlmostEqual(high, 0.03699349820698568, places=12)
        self.assertGreater(wilson(1000, 1 << 24)[1], 1000 / (1 << 24))
        for fp, count in [(0, 0), (-1, 100), (101, 100)]:
            with self.assertRaises(ValueError):
                wilson(fp, count)

    def test_missing_duplicate_unknown_and_wrong_workload_rows_rejected(self):
        rows = synthetic_rows()[:14]
        validate_rows(rows, REGISTRY, PROTOCOL, (16, 8, 1, 42))
        for malformed in (rows[:-1], rows + [rows[0]], rows[:-1] + [rows[0]]):
            with self.assertRaises(ValueError):
                validate_rows(malformed, REGISTRY, PROTOCOL, (16, 8, 1, 42))
        for key, value in [("filter", "Unknown"), ("keys", "32"), ("seed", "43"),
                           ("insert_batch", "4096"), ("calibration_absent_queries", "4096"),
                           ("actual_bpk", "15.9"), ("input_mode", "raw_bytes")]:
            malformed = copy.deepcopy(rows)
            malformed[0][key] = value
            with self.assertRaises(ValueError):
                validate_rows(malformed, REGISTRY, PROTOCOL, (16, 8, 1, 42))

    def test_timing_ranges_and_family_semantics_rejected(self):
        rows = synthetic_rows()[:14]
        for key, value in [("lookup_ns", "nan"), ("hash_lookup_ns", "0"),
                           ("lookup_min_ns", "2"), ("hash_lookup_max_ns", "1"),
                           ("allocate_insert_ns", "1"), ("result_checksum", "124"),
                           ("calibration_false_positives", str((1 << 24) + 1))]:
            malformed = copy.deepcopy(rows)
            malformed[0][key] = value
            with self.assertRaises(ValueError):
                validate_rows(malformed, REGISTRY, PROTOCOL, (16, 8, 1, 42))

    def test_repeated_batches_do_not_create_new_quality_samples(self):
        rows = synthetic_rows()
        for row in rows:
            if row["keys"] == str(1 << 16) and row["requested_bpk"] == "8" and row["batch"] == "31" and REGISTRY[row["filter"]]["family"] == "SBBF":
                row["calibration_false_positives"] = "1001"
        with self.assertRaises(ValueError):
            validate_all(rows, REGISTRY, PROTOCOL)
        with self.assertRaises(ValueError):
            quality_rows(rows, REGISTRY)


if __name__ == "__main__":
    unittest.main()
