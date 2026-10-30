"""Independent frozen four-mode row oracle; copied unchanged from leaf preflight."""
import collections,math
METRICS=("lookup","hash_lookup","inline_lookup","inline_hash_lookup")

def expected_phase_order(seed, repeats):
    """Independent unsigned-integer implementation of the frozen label shuffle."""
    mask = (1 << 64) - 1
    state = seed ^ 0x6a09e667f3bcc909
    labels = [0, 1, 2, 3]
    for width in (4, 3, 2):
        state = (state + 0x9e3779b97f4a7c15) & mask
        value = ((state ^ (state >> 30)) * 0xbf58476d1ce4e5b9) & mask
        value = ((value ^ (value >> 27)) * 0x94d049bb133111eb) & mask
        value ^= value >> 31
        index = value % width
        labels[width - 1], labels[index] = labels[index], labels[width - 1]
    schedule = ((0, 1, 3, 2), (1, 2, 0, 3), (2, 3, 1, 0), (3, 0, 2, 1))
    return ";".join("|".join(str(labels[mode]) for mode in schedule[trial % 4]) for trial in range(repeats))


def validate_row(row):
    assert row["scalar_track"] == "optimizer_visible_public_single"
    repeats = int(row["repeats"])
    assert row["query_phase_order"] == expected_phase_order(int(row["seed"]), repeats)
    orders = [[int(value) for value in order.split("|")] for order in row["query_phase_order"].split(";")]
    assert len(orders) == repeats
    positions = collections.Counter()
    pairs = collections.Counter()
    for order in orders:
        assert sorted(order) == [0, 1, 2, 3]
        positions.update(enumerate(order))
        pairs.update(zip(order, order[1:]))
    assert len(positions) == 16 and set(positions.values()) == {repeats // 4}
    assert len(pairs) == 12 and set(pairs.values()) == {repeats // 4}
    for metric in METRICS:
        samples = [float(value) for value in row[metric + "_trials"].split("|")]
        assert len(samples) == repeats and all(math.isfinite(value) and value > 0 for value in samples)
        observed = sorted(samples)
        expected_median = (observed[repeats // 2 - 1] + observed[repeats // 2]) / 2
        assert math.isclose(float(row[metric + "_ns"]), expected_median, rel_tol=1e-12)
        assert float(row[metric + "_min_ns"]) == min(samples)
        assert float(row[metric + "_max_ns"]) == max(samples)


