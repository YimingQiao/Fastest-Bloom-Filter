"""Synthetic audit faults: never invokes the public constructor or compiler."""
import copy
import json
import unittest
from plan import HERE
from validate import check_rows


class AuditTests(unittest.TestCase):
    def fixture(self):
        return [dict(id=r['id'], n=r['n'], policy=r['policy'], fpp_bits=r['fpp_bits'],
                     capacity=r['per_bucket_capacity'], buckets=r['buckets'],
                     cache_bytes=r['cache_bytes'], probes=r['probes'], owned_bytes=r['backing_bytes'],
                     constructor_peak_bytes=r['backing_bytes'], inspection_peak_bytes=8192,
                     retained_metadata_bytes=56, serialized_bytes=56 + r['backing_bytes'],
                     filter_inserts=0, timings=False)
                for r in json.loads((HERE / 'selection.json').read_text())['rows']]

    def test_all_rows_and_no_overbudget_control_deletion(self):
        rows = self.fixture()
        check_rows(rows)
        with self.assertRaises(ValueError): check_rows(rows[:-1])
        changed = rows.copy(); changed[0], changed[1] = changed[1], changed[0]
        with self.assertRaises(ValueError): check_rows(changed)

    def test_memory_geometry_and_scope_faults(self):
        rows = self.fixture()
        index = next(i for i, r in enumerate(rows) if r['cache_bytes'])
        for key, value in [('owned_bytes', rows[index]['owned_bytes'] - rows[index]['cache_bytes']),
                           ('cache_bytes', 0), ('probes', 99), ('n', 1024), ('fpp_bits', '0' * 16),
                           ('retained_metadata_bytes', 56 + rows[index]['cache_bytes']),
                           ('serialized_bytes', 56), ('constructor_peak_bytes', 0),
                           ('filter_inserts', 1), ('timings', True)]:
            changed = copy.deepcopy(rows); changed[index][key] = value
            with self.subTest(key=key), self.assertRaises(ValueError): check_rows(changed)


if __name__ == '__main__': unittest.main()
