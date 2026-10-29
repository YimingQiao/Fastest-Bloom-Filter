import copy
import unittest
import contract as c


CPUS = {4: [2, 4, 6, 8], 8: [2, 4, 6, 8, 10, 12, 14, 16]}


def row(case):
    result = {k: case[k] for k in ("language", "family", "scenario", "bytes", "batch_n", "requested", "history_n", "hotspot", "seed", "input_base")}
    batch, query = c.input_checksums(case["seed"], case["batch_n"], case["history_n"], case["hotspot"])
    result.update(query_n=c.QUERY_N, repeats=4, time_unit="absolute_ns", phase_order="serial_pair_abba4",
                  executed_order=c.executed_order(case), cpus=CPUS[case["requested"]],
                  scheduler="caller_worker0" if case["language"] == "cpp" else "scoped_workers_plus_caller_or_serial_fallback",
                  checksum=123, positives=23000, batch_checksum=batch, query_checksum=query, arms={})
    for arm in c.ARMS:
        result["arms"][arm] = dict(c.stats(case, arm), insert_ns=[101, 102, 103, 104],
             allocate_insert_ns=[] if case["history_n"] else [201, 202, 203, 204],
             insert_prefill_setup_ns=[1000 if case["history_n"] else 0] * 4)
    return result


class Contract(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cases = c.plan.ledger()
        cls.rows = [row(case) for case in cls.cases]

    def test_complete(self):
        self.assertEqual(c.audit(self.rows, CPUS)["variant_rows"], 192)

    def test_missing_duplicate_order(self):
        for mutate in (lambda x: x.pop(), lambda x: x.__setitem__(1, x[0]), lambda x: x.reverse()):
            rows = copy.deepcopy(self.rows); mutate(rows)
            with self.assertRaises(ValueError): c.audit(rows, CPUS)

    def test_duration_and_populated_unavailable(self):
        for value in (float("nan"), float("inf"), -1, 0):
            r = copy.deepcopy(self.rows[0]); r["arms"]["candidate"]["insert_ns"][0] = value
            with self.assertRaises(ValueError): c.validate(r, self.cases[0], CPUS[4])
        i = next(i for i, case in enumerate(self.cases) if case["history_n"])
        r = copy.deepcopy(self.rows[i]); r["arms"]["control"]["allocate_insert_ns"] = [1] * 4
        with self.assertRaises(ValueError): c.validate(r, self.cases[i], CPUS[self.cases[i]["requested"]])

    def test_outside_threshold_and_scratch(self):
        for i in (0, next(i for i, case in enumerate(self.cases) if case["scenario"] == 3)):
            for key in ("effective", "workers", "scratch_bytes", "spawned_per_pass"):
                r = copy.deepcopy(self.rows[i]); r["arms"]["candidate"][key] += 1
                with self.assertRaises(ValueError): c.validate(r, self.cases[i], CPUS[self.cases[i]["requested"]])

    def test_phase_and_input_and_core_budget(self):
        for key, value in (("executed_order", []), ("batch_checksum", 0), ("query_checksum", 0),
                           ("cpus", [2]), ("time_unit", "per_key_ns")):
            r = copy.deepcopy(self.rows[0]); r[key] = value
            with self.assertRaises(ValueError): c.validate(r, self.cases[0], CPUS[4])

    def test_semantics_not_clock_equality(self):
        rows = copy.deepcopy(self.rows); rows[1]["checksum"] += 1
        with self.assertRaises(ValueError): c.audit(rows, CPUS)
        rows = copy.deepcopy(self.rows); rows[1]["arms"]["candidate"]["insert_ns"][0] *= 2
        c.audit(rows, CPUS)


if __name__ == "__main__": unittest.main()
