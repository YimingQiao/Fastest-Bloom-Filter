"""Offline corruption checks using retained semantic-preflight rows, no benchmark runs."""
import copy
import csv
import io
import json
from pathlib import Path
import unittest

from guard import validate_rows

HERE = Path(__file__).resolve().parent


class Guards(unittest.TestCase):
    def setUp(self):
        evidence = json.loads((HERE / "validation/preflight-results.json").read_text())
        self.rows = [row for row in csv.DictReader(io.StringIO(evidence["records"][0]["stdout"])) if row["filter"] in {"ByteSplitBloomFilter", "ByteTripleHintControl", "ByteOnlyInlineV1"}]
        from guard import expected_filter_order
        order = expected_filter_order(42, 1024, 4096, 0, {row["filter"] for row in self.rows})
        self.rows.sort(key=lambda row: order.index(row["filter"]))
        self.registry = json.loads((HERE / "registry.json").read_text())
        self.protocol = json.loads((HERE / "protocol.json").read_text())
        self.protocol.update(query_power=12, repeats=4, hit_percent=0, calibration_power=12)
        # The retained tiny fixture used insert_batch37; model the preregistered full-input setting.
        for row in self.rows:
            row["insert_batch"] = row["keys"]

    def check(self, rows):
        validate_rows(rows, self.registry, self.protocol, (10, 8, 1, 42))

    def test_valid(self):
        self.check(self.rows)

    def test_missing_duplicate_unknown(self):
        variants = [self.rows[:-1], self.rows[:-1] + [self.rows[0]], copy.deepcopy(self.rows)]
        variants[-1][0]["filter"] = "Unknown"
        for rows in variants:
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_wrong_owner(self):
        self.registry["ByteOnlyInlineV1"]["owner"] = "external"
        with self.assertRaises(ValueError):
            self.check(self.rows)

    def test_wrong_workload_bytes_or_quality(self):
        for key, value in (("batch", "31"), ("filter_bytes", "1"), ("actual_bpk", "8"),
                           ("seed", "43"), ("calibration_false_positives", "4097"),
                           ("input_mode", "raw"), ("insert_batch", "37")):
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.assertRaises(ValueError):
                self.check(rows)

    def test_nonfinite_or_wrong_median(self):
        for key, value in (("inline_lookup_ns", "nan"), ("inline_hash_lookup_min_ns", "0"),
                           ("lookup_trials", "1|2|3|4")):
            rows = copy.deepcopy(self.rows)
            rows[0][key] = value
            with self.assertRaises(AssertionError):
                self.check(rows)

    def test_unbalanced_phase(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["query_phase_order"] = "0|1|2|3;0|1|2|3;0|1|2|3;0|1|2|3"
        with self.assertRaises(AssertionError):
            self.check(rows)

    def test_balanced_but_wrong_seed_order(self):
        from guard import validate_row
        rows = copy.deepcopy(self.rows)
        original = rows[0]["query_phase_order"]
        # Rotating the four labels preserves every balance count, but violates seed42.
        rows[0]["query_phase_order"] = ";".join(
            "|".join(str((int(value) + 1) % 4) for value in order.split("|"))
            for order in original.split(";")
        )
        self.assertNotEqual(rows[0]["query_phase_order"], original)
        with self.assertRaises(AssertionError):
            self.check(rows)
        # The preserved original producer rows all satisfy the independent seed oracle.
        for row in self.rows:
            validate_row(row)

    def test_candidate_output_mismatch(self):
        rows = copy.deepcopy(self.rows)
        row = next(row for row in rows if row["filter"] == "ByteOnlyInlineV1")
        row["result_checksum"] = str(int(row["result_checksum"]) ^ 1)
        with self.assertRaises(ValueError):
            self.check(rows)

    def test_native_regression_registry_and_count(self):
        from guard import CONTROLS, expected_names, workloads
        self.assertEqual(expected_names(31), set(CONTROLS) | set(CONTROLS.values()))
        protocol = json.loads((HERE / "protocol.json").read_text())
        self.assertEqual(len(workloads(protocol)), 32)
        self.assertEqual(sum(len(expected_names(batch)) for _, _, batch, _ in workloads(protocol)), 96)
        with self.assertRaises(ValueError):
            validate_rows(self.rows, self.registry, self.protocol, (10, 8, 31, 42))

    def test_invalid_build_time(self):
        rows = copy.deepcopy(self.rows)
        rows[0]["allocate_insert_ns"] = "0"
        with self.assertRaises(ValueError):
            self.check(rows)


    def test_filter_row_order_matches_all_preflight_rows(self):
        from guard import expected_filter_order
        evidence=json.loads((HERE/'validation/preflight-results.json').read_text())
        for record in evidence['records']:
            if 'stdout' not in record or not record['stdout'].startswith('language,'):continue
            rows=list(csv.DictReader(io.StringIO(record['stdout'])))
            if set(r['filter'] for r in rows)!=set(self.registry):continue
            r=rows[0]
            self.assertEqual([x['filter'] for x in rows],expected_filter_order(int(r['seed']),int(r['keys']),int(r['queries']),int(r['hit_percent']),set(self.registry)))

    def test_filter_row_order_corruption(self):
        with self.assertRaises(ValueError):self.check(self.rows[::-1])

    def test_prespecified_source_only_seed_selection(self):
        from seed_selection import select
        chosen,orders=select()
        self.assertEqual(chosen,[2000003,2000015])
        for index in (0,1):self.assertEqual(orders[chosen[0]][index],list(reversed(orders[chosen[1]][index])))

    def test_filter_order_balance_every_workload_group(self):
        import itertools
        from guard import expected_filter_order,expected_names,workloads
        protocol=json.loads((HERE/'protocol.json').read_text())
        totals={}
        for power,bpk,batch,seed in workloads(protocol):
            order=expected_filter_order(seed,1<<power,1<<protocol['query_power'],protocol['hit_percent'],expected_names(batch))
            for a,b in itertools.combinations(protocol['filters'],2):
                totals.setdefault((power,bpk,batch,a,b),[]).append(order.index(a)<order.index(b))
        self.assertEqual(len(totals),48)
        self.assertTrue(all(len(v)==2 and sum(v)==1 for v in totals.values()))

if __name__ == "__main__":
    unittest.main()
