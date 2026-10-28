"""Reconstruct the frozen Rust producer's row permutation without allocating input arrays."""
import re

MASK = (1 << 64) - 1
STEP = 0x9e3779b97f4a7c15


def require(condition, message):
    if not condition:
        raise ValueError(message)


def registration(source):
    match = re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];', source, re.S)
    require(match is not None, "Missing frozen registration")
    names = re.findall(r'"([A-Za-z0-9_]+)"', match.group(1))
    require(len(names) == 12 and len(set(names)) == 12, "Wrong frozen registration")
    return names


def next_value(state):
    state = (state + STEP) & MASK
    z = state
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & MASK
    return state, z ^ (z >> 31)


def expected_order(seed, keys, queries, hit_percent, names):
    require(keys > 0 and queries > 0 and 0 <= hit_percent <= 100, "Invalid workload")
    require(len(names) == len(set(names)), "Duplicate registration")
    # Exactly one key-base draw, n-1 insertion-shuffle draws, one draw
    # per present query, and q-1 query-shuffle draws precede job shuffling.
    present = (queries // 100) * hit_percent + min(queries % 100, hit_percent)
    draws = 1 + keys - 1 + present + queries - 1
    state = (seed + STEP * draws) & MASK
    result = list(names)
    for count in range(len(result), 1, -1):
        state, value = next_value(state)
        position = value % count
        result[count - 1], result[position] = result[position], result[count - 1]
    return result


def validate_order(rows, protocol, workload, source):
    power, _, _, seed = workload
    names = registration(source)
    require(set(names) == set(protocol["filters"]), "Protocol differs from source registration")
    expected = expected_order(seed, 1 << power, 1 << protocol["query_power"], protocol["hit_percent"], names)
    actual = [row["filter"] for row in rows]
    require(actual == expected, "Measured row permutation differs from frozen producer")
    return expected
