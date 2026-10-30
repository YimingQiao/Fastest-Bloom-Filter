"""Offline order-oracle regressions, including a literal independent simulation."""
import unittest
from order_oracle import expected_order, next_value, registration, validate_order


def literal(seed, n, q, hit, names):
    state = seed

    def draw():
        nonlocal state
        state, value = next_value(state)
        return value

    def shuffle(values):
        for i in range(len(values), 1, -1):
            pos = draw() % i
            values[i - 1], values[pos] = values[pos], values[i - 1]

    base = draw() % ((1 << 32) - n - q)
    inserted = list(range(base, base + n))
    shuffle(inserted)
    query = [base + (draw() % n if i % 100 < hit else n + i) for i in range(q)]
    shuffle(query)
    result = list(names)
    shuffle(result)
    return result


class OrderTests(unittest.TestCase):
    def test_skip_ahead_matches_literal_draws(self):
        names = [str(i) for i in range(12)]
        for seed in (0, 42, 1009, (1 << 64) - 1):
            for n, q in ((1, 1), (17, 111), (128, 256)):
                for hit in (0, 1, 50, 99, 100):
                    self.assertEqual(expected_order(seed, n, q, hit, names), literal(seed, n, q, hit, names))

    def test_permutation_and_source_registration_enforced(self):
        names = ["Filter" + str(i) for i in range(12)]
        source = 'const FILTER_NAMES: &[&str] = &[\n' + ','.join('"' + n + '"' for n in names) + '];'
        protocol = dict(filters=list(reversed(names)), query_power=10, hit_percent=50)
        expected = expected_order(42, 128, 1024, 50, names)
        rows = [dict(filter=n) for n in expected]
        self.assertEqual(validate_order(rows, protocol, (7, 8, 1, 42), source), expected)
        rows[0], rows[1] = rows[1], rows[0]
        with self.assertRaisesRegex(ValueError, "permutation"):
            validate_order(rows, protocol, (7, 8, 1, 42), source)
        with self.assertRaises(ValueError):
            registration(source.replace('"Filter11"', '"Filter10"'))

    def test_invalid_dimensions_rejected(self):
        for n, q, hit in ((0, 1, 50), (1, 0, 50), (1, 1, -1), (1, 1, 101)):
            with self.assertRaises(ValueError):
                expected_order(42, n, q, hit, ["A", "B"])


if __name__ == "__main__":
    unittest.main()
