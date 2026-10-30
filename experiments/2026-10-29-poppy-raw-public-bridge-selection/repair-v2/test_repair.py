import copy
import json
import unittest
from pathlib import Path
import run
from selector import construction


def cached_point():
    return dict(keys=65536, actual_bytes=73728, source_mapping=[65536, 16, 8192, 4], source_alias_ids=['cache'],
                canonical_constructor=dict(n=65536, buckets=16, cache_bits=65536, cache_bytes=8192, probes=4,
                                           backing_bytes=73728, fpp_bits='3f847ae147ae147b', id='cache'))


class RepairTests(unittest.TestCase):
    def test_nonzero_cache_bytes_not_bits(self):
        point = cached_point()
        result = construction(point)
        self.assertEqual((result['bucket_bytes'], result['cache_bytes'], result['total_backing_bytes']), (65536, 8192, 73728))
        wrong = copy.deepcopy(point)
        wrong['source_mapping'][2] = wrong['canonical_constructor']['cache_bits']
        with self.assertRaises(ValueError): construction(wrong)

    def test_all_47_committed_source_constructors_without_observations(self):
        path = run.ROOT/'experiments/2026-10-29-poppy-public-speed-plan/selection.json'
        catalog = json.loads(run.exact('4d2b7f69d941991f3a9f4cebeb2c7c87514cd8f0', path))
        points = [p for p in catalog['configurations'] if p['owner'] == 'poppy_external']
        self.assertEqual(len(points), 47)
        self.assertEqual(sum(p['canonical_constructor']['cache_bytes'] > 0 for p in points), 30)
        for point in points:
            with self.subTest(configuration=point['configuration_id']):
                value = construction(point)
                self.assertEqual(value['total_backing_bytes'], point['actual_bytes'])
                self.assertEqual(value['cache_bytes']*8, point['canonical_constructor']['cache_bits'])

    def test_exact_single_field_delta(self):
        old = (run.PARENT/'selector.py').read_text()
        new = (run.HERE/'selector.py').read_text()
        patch = (run.HERE/'SELECTOR.patch').read_text()
        run.derived(old, new, patch)
        with self.assertRaises(ValueError): run.derived(old, new+'\n', patch)


if __name__ == '__main__':
    unittest.main()
