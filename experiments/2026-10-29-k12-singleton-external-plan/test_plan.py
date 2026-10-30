import copy
import json
from pathlib import Path
import unittest

import derive


class PlanGuards(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = {name: json.loads(derive.blob(*ref)) for name, ref in derive.ANCHORS.items()}
        cls.selection, cls.ledger, cls.domains = derive.derive(cls.data)

    def test_full_reverse_and_exact_calibration_reuse(self):
        first, second = self.ledger[:24], self.ledger[24:]
        for a, b in zip(first, reversed(second)):
            for key in ("phase", "key_power", "seed", "hit", "batch", "point_ids"):
                self.assertEqual(a[key], b[key])
            self.assertFalse(a["reverse_jobs"])
            self.assertTrue(b["reverse_jobs"])
            self.assertEqual(b["calibration_power"], 0)
        records = [(c["seed"], p) for c in self.ledger if c["calibration_power"] for p in c["point_ids"]]
        self.assertEqual(len(records), 128)
        self.assertEqual(len(set(records)), 128)

    def test_diagnostic_scope_and_primary_owners(self):
        points = {p["id"]: p for p in self.selection["points"]}
        for c in self.ledger:
            owners = {points[p]["owner"] for p in c["point_ids"]}
            self.assertEqual(owners, {"candidate", "old_k12", "native_range"} if c["phase"] == "native_diagnostic" else
                             {"candidate", "old_k12", "native_range", "production_native", "external"})
        self.assertEqual(self.selection["counts"]["rows"], 616)
        self.assertEqual(self.selection["counts"]["query_samples"], 16256)

    def test_ambiguous_or_budget_only_geometry_rejected(self):
        grid = self.data["exact_grid"]["configurations"]
        p = next(p for p in self.selection["points"] if p["geometry"]["filter"] == "Boost192Multi32K8")
        g = p["geometry"]
        self.assertNotEqual(int(g["budget_bytes"]), int(g["filter_bytes"]))
        with self.assertRaisesRegex(ValueError, "ambiguous/missing"):
            derive.exact_geometry(grid + [g], g["filter"], int(g["keys"]), int(g["filter_bytes"]))
        with self.assertRaisesRegex(ValueError, "ambiguous/missing"):
            derive.exact_geometry(grid, g["filter"], int(g["keys"]), int(g["budget_bytes"]))

    def test_historical_failure_does_not_prune(self):
        changed = copy.deepcopy(self.data)
        found = False
        for section in ("main_comparisons", "frontier_comparisons"):
            for r in changed["confirmation_summary"][section]:
                if r["fixed_leader_quality"]["external"]:
                    r["fixed_leader_quality"]["external"]["qualified_all_seeds"] = False
                    found = True
        self.assertTrue(found)
        selection, ledger, _ = derive.derive(changed)
        self.assertEqual([p["id"] for p in selection["points"]], [p["id"] for p in self.selection["points"]])
        self.assertEqual(ledger, self.ledger)

    def test_own_negative_intervals_disjoint(self):
        for d in self.domains:
            a, b, c = d["insert_interval"], d["mixed_negative_envelope"], d["calibration_interval"]
            self.assertEqual(a[1], b[0])
            self.assertEqual(b[1], c[0])
            self.assertEqual(c[1]-c[0], 1 << 26)
            self.assertLess(c[1], 1 << 64)

    def test_mutable_source_reference_rejected(self):
        for bad in ("HEAD", "556c05b", "F"*40, "a"*39):
            with self.assertRaisesRegex(ValueError, "full immutable"):
                derive.blob(bad, "README.md")


if __name__ == "__main__":
    unittest.main()
