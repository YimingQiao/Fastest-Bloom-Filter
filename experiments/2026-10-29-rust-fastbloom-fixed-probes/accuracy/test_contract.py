import copy
import unittest
from contract import FIELDS, NAMES, next_value, order, validate


def fixture():
    n, cap, q, seed, cal = 1024, 16, 4096, 42, 4096
    base = next_value(seed)[1] % ((1 << 32) - n - q)
    row = dict.fromkeys(FIELDS, "0")
    row.update(language="rust", filter="Fastbloom017K11", keys=str(n), queries=str(q),
        requested_bpk="16", filter_bytes="2048", actual_bpk="16", hash_bits="64", hit_percent="50",
        present_queries="2050", batch="4096", seed="42", absent_queries="2046", false_positives="1",
        result_checksum="18333333333333333331", key_base=str(base), input_mode="prehashed",
        calibration_absent_queries="4096", calibration_false_positives="2", inserted_checked="1024",
        bitmap_builds="1", budget_bytes="2048", logical_bytes="2048", geometry_kind="classical_words",
        unit_bytes="8", unit_count="256", effective_probes="11", probe_policy="public_fixed_hash_count",
        constructor_argument="16384", implementation_origin="external", size_contract="exact_byte_ceiling_v1")
    return [row], (n, cap, q, seed, cal, ["Fastbloom017K11"])


class Contract(unittest.TestCase):
    def test_valid_synthetic_row(self):
        rows, args = fixture()
        validate(rows, *args)

    def test_invalid_row_fields_fail(self):
        rows, args = fixture()
        for field, value in [("filter_bytes", "2049"), ("effective_probes", "10"), ("inserted_checked", "1023"),
            ("bitmap_builds", "2"), ("key_base", str(int(rows[0]["key_base"]) + 1)),
            ("seed", "43"), ("probe_policy", "upstream_expected_items_real_n"),
            ("implementation_origin", "production_native"), ("calibration_false_positives", "4097")]:
            changed = copy.deepcopy(rows); changed[0][field] = value
            with self.assertRaises(ValueError, msg=field):
                validate(changed, *args)

    def test_extra_timing_field_rejected(self):
        rows, args = fixture(); rows[0]["lookup_ns"] = "1.0"
        with self.assertRaises(ValueError): validate(rows, *args)

    def test_missing_duplicate_rows_rejected(self):
        rows, args = fixture()
        for changed in [[], rows + rows]:
            with self.assertRaises(ValueError): validate(changed, *args)

    def test_default_alias_count_mismatch_rejected(self):
        rows, args = fixture()
        default = dict(rows[0], filter="Fastbloom017", probe_policy="upstream_expected_items_real_n")
        selected = ["Fastbloom017", "Fastbloom017K11"]
        mapping = {r["filter"]: r for r in [default, rows[0]]}
        rows = [mapping[name] for name in order(selected, args[0], args[2], args[3])]
        args = args[:-1] + (selected,)
        validate(rows, *args)
        default["calibration_false_positives"] = "3"
        with self.assertRaises(ValueError): validate(rows, *args)

    def test_exact_source_order_rejected_if_reversed(self):
        rows, args = fixture()
        default = dict(rows[0], filter="Fastbloom017", probe_policy="upstream_expected_items_real_n")
        selected = ["Fastbloom017", "Fastbloom017K11"]
        mapping = {r["filter"]: r for r in [default, rows[0]]}
        rows = [mapping[name] for name in order(selected, args[0], args[2], args[3])]
        with self.assertRaises(ValueError): validate(list(reversed(rows)), *(args[:-1] + (selected,)))

    def test_selection_argument_order_does_not_change_registry_order(self):
        self.assertEqual(order(NAMES, 1024, 4096, 42), order(reversed(NAMES), 1024, 4096, 42))


if __name__ == "__main__": unittest.main()
