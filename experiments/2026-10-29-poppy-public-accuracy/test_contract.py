import copy
import unittest
from contract import (
    Q,
    CAL,
    constructors,
    fixtures,
    key_base,
    small_input,
    validate,
    check_coverage,
)


def row(case, check):
    n = case["n"]
    q, inserted, cal = (8193, 1031, 4096) if check else (Q, n, CAL)
    present = q // 100 * 50 + min(q % 100, 50)
    result = dict(
        stage="check" if check else "accuracy",
        id=case["id"],
        real_n=n,
        inserted_n=inserted,
        queries=q,
        policy=case["policy"],
        fpp_bits=case["fpp_bits"],
        actual_bytes=case["backing_bytes"],
        seed=42,
        key_base=key_base(n),
        inserted_checksum=1,
        query_checksum=2,
        insertions_returned_new=inserted,
        false_negatives=0,
        present_queries=present,
        absent_queries=q - present,
        mixed_false_positives=0,
        result_checksum=3,
        calibration_begin=key_base(n) + n + Q,
        calibration_end=key_base(n) + n + Q + cal,
        calibration_queries=cal,
        calibration_false_positives=0,
        check_public_iterator_parity=check,
        timings=False,
    )
    if check:
        result.update(small_input(n))
    return result


class ContractTests(unittest.TestCase):
    def test_input_oracle_rejects_changed_base_and_shuffles(self):
        for case in fixtures():
            good = row(case, True)
            validate(good, case, True)
            for field in ("key_base", "inserted_checksum", "query_checksum"):
                bad = dict(good)
                bad[field] ^= 1
                with self.assertRaises(ValueError):
                    validate(bad, case, True)

    def test_rejects_false_negatives_overlap_and_wrong_denominator(self):
        case = constructors()[0]
        good = row(case, False)
        validate(good, case, False)
        for field, value in [
            ("false_negatives", 1),
            ("calibration_begin", key_base(case["n"])),
            ("calibration_queries", 1 << 24),
            ("inserted_n", 1031),
            ("calibration_false_positives", CAL + 1),
            ("timings", True),
        ]:
            bad = dict(good)
            bad[field] = value
            with self.assertRaises(ValueError):
                validate(bad, case, False)

    def test_full_grid_and_proven_aliases_cannot_be_dropped_or_changed(self):
        good = [row(case, False) for case in constructors()]
        check_coverage(good)
        with self.assertRaises(ValueError):
            check_coverage(good[:-1])
        bad = copy.deepcopy(good)
        bad[1] = copy.deepcopy(bad[0])
        with self.assertRaises(ValueError):
            check_coverage(bad)
        bad = copy.deepcopy(good)
        next(r for r in bad if r["policy"] == "space")[
            "calibration_false_positives"
        ] = 1
        with self.assertRaises(ValueError):
            check_coverage(bad)


if __name__ == "__main__":
    unittest.main()
