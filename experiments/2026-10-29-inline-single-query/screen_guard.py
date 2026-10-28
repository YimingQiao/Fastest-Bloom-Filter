"""Additional analysis guards; do not mutate the already-running frozen runner."""
import math


def validate_metadata(rows):
    for row in rows:
        if row["input_mode"] not in ("prehashed", "raw_bytes"):
            raise ValueError("Unknown input contract")
        keys, payload = int(row["keys"]), int(row["filter_bytes"])
        actual = float(row["actual_bpk"])
        if keys <= 0 or payload <= 0 or not math.isfinite(actual) or actual <= 0:
            raise ValueError("Invalid payload accounting")
        if not math.isclose(actual, payload * 8 / keys, rel_tol=2e-5, abs_tol=1e-5):
            raise ValueError("Actual bits/key disagrees with payload bytes")
        for prefix in ("lookup", "hash_lookup"):
            values = [float(row[prefix + suffix]) for suffix in ("_min_ns", "_ns", "_max_ns")]
            if prefix == "lookup" and row["input_mode"] == "raw_bytes":
                if not all(math.isnan(v) for v in values):
                    raise ValueError("Raw-only adapter has old prehashed timing fields")
            elif not all(math.isfinite(v) and v > 0 for v in values) or values != sorted(values):
                raise ValueError("Invalid old API timing median/range")
