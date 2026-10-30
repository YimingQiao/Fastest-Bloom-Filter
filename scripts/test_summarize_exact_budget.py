import copy
import math
import unittest

from summarize_exact_budget import analyze, enrich, wilson_upper, verify_runtime_record


def row(name, origin, bpk, latency, identity=None, fp=100):
    return dict(
        filter=name,
        implementation_origin=origin,
        keys=65536,
        filter_bytes=8192 * bpk,
        requested_bpk=str(bpk),
        seed=42,
        configuration_id=name + str(bpk),
        calibration_identity=identity or name + str(bpk),
        calibration_absent_queries=1 << 24,
        calibration_false_positives=fp,
        result_checksum="123",
        false_positives="2",
        absent_queries="2000",
        input_mode="prehashed",
        lookup_ns=str(latency),
        hash_lookup_ns=str(latency + 1),
        lookup_min_ns=str(latency),
        lookup_max_ns=str(latency),
        hash_lookup_min_ns=str(latency + 1),
        hash_lookup_max_ns=str(latency + 1),
    )


class RankingGuards(unittest.TestCase):
    def setUp(self):
        self.protocol = dict(memory_cap_bpk=[16, 32], quality_caps=[0.001])
        self.rows = [
            row("Native", "production_native", 16, 2),
            row("External12", "external", 12, 1.5),
            row("External32", "external", 32, 3),
            row("Range", "project_experiment", 14, 1),
        ]

    def test_smaller_capacity_can_be_best_under_both_caps(self):
        report = analyze(self.rows, self.protocol)
        for item in report["rankings"]:
            self.assertEqual(item["external"]["filter"], "External12")
            self.assertEqual(item["production_native"]["filter"], "Native")
            self.assertEqual(item["project_experiment"]["filter"], "Range")
            self.assertLess(item["external_over_production"], 1)
            self.assertGreater(item["external_over_experiment"], 1)

    def test_overbudget_candidate_does_not_enter_smaller_cap(self):
        self.rows[2].update(lookup_ns="0.5", lookup_min_ns="0.5", lookup_max_ns="0.5")
        reports = analyze(self.rows, self.protocol)["rankings"]
        self.assertEqual(reports[0]["external"]["filter"], "External12")
        self.assertEqual(reports[1]["external"]["filter"], "External32")

    def test_upper_bound_controls_eligibility(self):
        self.rows[1][
            "calibration_false_positives"
        ] = 16770  # Point estimate below0.1%, upper above it.
        self.assertLess(16770 / (1 << 24), 0.001)
        self.assertGreater(wilson_upper(16770, 1 << 24), 0.001)
        self.assertIsNone(analyze(self.rows, self.protocol)["rankings"][0]["external"])

    def test_identical_mapping_is_counted_once(self):
        control = copy.deepcopy(self.rows[1])
        control.update(filter="ExternalControl", configuration_id="control")
        _, quality = enrich(self.rows + [control])
        record = next(q for q in quality if q["calibration_identity"] == "External1212")
        self.assertEqual(record["calibration_absent_queries"], 1 << 24)
        self.assertEqual(len(record["members"]), 2)
        control["calibration_false_positives"] += 1
        with self.assertRaisesRegex(ValueError, "Equivalent mappings"):
            enrich(self.rows + [control])

    def test_duplicate_configuration_rejected(self):
        with self.assertRaisesRegex(ValueError, "Repeated effective"):
            enrich(self.rows + [self.rows[0]])

    def test_page_only_enters_raw_metric(self):
        page = row("Page", "external", 12, 0.5)
        page.update(input_mode="raw_bytes", lookup_ns="nan")
        reports = analyze(self.rows + [page], self.protocol)["rankings"]
        self.assertEqual(reports[0]["external"]["filter"], "External12")
        self.assertEqual(reports[2]["external"]["filter"], "Page")
        page["lookup_ns"] = "0.5"
        with self.assertRaisesRegex(ValueError, "fabricated prehashed"):
            enrich([page])

    def test_invalid_timing_and_quality_rejected(self):
        for value in ("nan", "inf", "0", "-1"):
            broken = copy.deepcopy(self.rows)
            broken[0]["lookup_ns"] = value
            with self.assertRaisesRegex(ValueError, "Invalid query"):
                enrich(broken)
        self.assertTrue(math.isfinite(wilson_upper(0, 1 << 24)))
        self.assertEqual(wilson_upper(100, 100), 1)
        with self.assertRaises(ValueError):
            wilson_upper(101, 100)

    def test_recorded_lease_and_commands(self):
        protocol = dict(
            cpu=2,
            socket_lock="/tmp/fastest-bf-socket0.lock",
            binary="build/exact-budget-range-native/benchmark",
            hit_percent=50,
            query_power=22,
            batch=4096,
            query_repeats=6,
            seed=42,
            calibration_power=24,
        )
        case = dict(key_power=16, budget_bpk=14, filters=["Native", "External"])
        command = [
            "taskset",
            "-c",
            "2",
            "/original/checkout/" + protocol["binary"],
            "16",
            "14",
            "50",
            "22",
            "4096",
            "6",
            "42",
            "Native,External",
            "65536",
            "24",
            "query-only",
            "0",
        ]
        metadata = dict(
            lease=dict(
                cpu=2,
                lease="socket0",
                lock_path=protocol["socket_lock"],
                inherited_lock_descriptors=[3],
            ),
            cases=[dict(case=case, command=command)],
        )
        verify_runtime_record(metadata, protocol)
        for index, value in (
            (2, "3"),
            (3, "/wrong/binary"),
            (6, "0"),
            (9, "1"),
            (11, "Native"),
            (12, "0"),
            (15, "1"),
        ):
            broken = copy.deepcopy(metadata)
            broken["cases"][0]["command"][index] = value
            with self.assertRaises(ValueError):
                verify_runtime_record(broken, protocol)
        for field, value in (
            ("cpu", 3),
            ("lease", "socket1"),
            ("lock_path", "/tmp/another.lock"),
            ("inherited_lock_descriptors", []),
        ):
            broken = copy.deepcopy(metadata)
            broken["lease"][field] = value
            with self.assertRaises(ValueError):
                verify_runtime_record(broken, protocol)


if __name__ == "__main__":
    unittest.main()
