import unittest
from screen_guard import validate_metadata


class GuardTests(unittest.TestCase):
    def row(self):
        return dict(keys="65536", filter_bytes="131072", actual_bpk="16",
                    input_mode="prehashed", lookup_min_ns="1", lookup_ns="2",
                    lookup_max_ns="3", hash_lookup_min_ns="3", hash_lookup_ns="4",
                    hash_lookup_max_ns="5")

    def test_valid_prehashed_and_raw(self):
        row = self.row()
        validate_metadata([row])
        row["input_mode"] = "raw_bytes"
        for suffix in ("_min_ns", "_ns", "_max_ns"):
            row["lookup" + suffix] = "nan"
        validate_metadata([row])

    def test_raw_cannot_enter_either_pure_ranking(self):
        for finite in ("lookup_min_ns", "lookup_ns", "lookup_max_ns"):
            row = self.row()
            row["input_mode"] = "raw_bytes"
            for field in ("lookup_min_ns", "lookup_ns", "lookup_max_ns"):
                row[field] = "1" if field == finite else "nan"
            with self.assertRaises(ValueError):
                validate_metadata([row])

    def test_missing_old_native_path_is_rejected(self):
        for field in ("lookup_ns", "hash_lookup_ns"):
            row = self.row()
            row[field] = "nan"
            with self.assertRaises(ValueError):
                validate_metadata([row])

    def test_impossible_memory_cannot_qualify(self):
        for field, value in (("filter_bytes", "-1"), ("filter_bytes", "0"),
                             ("actual_bpk", "8"), ("actual_bpk", "nan")):
            row = self.row()
            row[field] = value
            with self.assertRaises(ValueError):
                validate_metadata([row])

    def test_invalid_range_and_input_contract(self):
        for field, value in (("lookup_min_ns", "4"), ("hash_lookup_max_ns", "inf"),
                             ("input_mode", "unknown")):
            row = self.row()
            row[field] = value
            with self.assertRaises(ValueError):
                validate_metadata([row])


if __name__ == "__main__":
    unittest.main()
