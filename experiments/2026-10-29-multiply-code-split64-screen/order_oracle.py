"""Read the frozen C++ registration macros and reconstruct its seeded job order."""
import re

MASK = (1 << 64) - 1
STEP = 0x9e3779b97f4a7c15


def require(value, message):
    if not value:
        raise ValueError(message)


def macro(source, name):
    lines = source.splitlines()
    matches = [i for i, line in enumerate(lines) if re.match(r"#define\s+" + re.escape(name) + r"\(ADD\)(?:\s|$)", line)]
    require(len(matches) == 1, "Missing/ambiguous registration macro: " + name)
    i = matches[0]
    parts = [re.sub(r"^#define\s+" + re.escape(name) + r"\(ADD\)", "", lines[i])]
    while parts[-1].rstrip().endswith("\\"):
        parts[-1] = parts[-1].rstrip()[:-1]
        i += 1
        require(i < len(lines), "Incomplete macro")
        parts.append(lines[i])
    return " ".join(parts)


def source_registry(adapter, cpp, boost, rocks):
    definitions = {
        "BF_REGISTER_EXTERNAL_FILTERS": macro(adapter, "BF_REGISTER_EXTERNAL_FILTERS"),
        "BF_REGISTER_FASTFILTER_FILTERS": macro(cpp, "BF_REGISTER_FASTFILTER_FILTERS"),
        "BF_REGISTER_BOOST_FILTERS": macro(boost, "BF_REGISTER_BOOST_FILTERS"),
        "BF_REGISTER_ROCKSDB_FILTERS": macro(rocks, "BF_REGISTER_ROCKSDB_FILTERS"),
    }
    def expand(name, stack=()):
        require(name not in stack and name in definitions, "Recursive/unknown registration")
        body = definitions[name]
        token = re.compile(r"ADD\(\s*([A-Za-z0-9_:]+)\s*,\s*uint64_t\s*\)|([A-Za-z0-9_]+)\(ADD\)")
        result, end = [], 0
        for match in token.finditer(body):
            require(not body[end:match.start()].strip(" ;\t\n"), "Unrecognized registration fragment")
            result.extend([match.group(1)] if match.group(1) else expand(match.group(2), stack + (name,)))
            end = match.end()
        require(not body[end:].strip(" ;\t\n"), "Unrecognized trailing registration")
        return result
    names = ["FastPatternBF"] + expand("BF_REGISTER_EXTERNAL_FILTERS")
    require(len(names) == 76 and len(set(names)) == 76, "Expected frozen76 registry")
    return names


def draw(state):
    state = (state + STEP) & MASK
    z = state
    z = ((z ^ (z >> 30)) * 0xbf58476d1ce4e5b9) & MASK
    z = ((z ^ (z >> 27)) * 0x94d049bb133111eb) & MASK
    return state, z ^ (z >> 31)


def expected_order(registry, selected, n, q, seed, hit):
    require(n > 0 and q > 0 and 0 <= hit <= 100, "Invalid workload")
    require(len(selected) == len(set(selected)) and set(selected) <= set(registry), "Invalid selected names")
    names = [name for name in registry if name in selected]
    present = q // 100 * hit + min(q % 100, hit)
    state = (seed + STEP * (1 + n - 1 + present + q - 1)) & MASK
    for size in range(len(names), 1, -1):
        state, value = draw(state)
        index = value % size
        names[size - 1], names[index] = names[index], names[size - 1]
    return names


def validate_order(rows, registry, selected, n, q, seed, hit):
    expected = expected_order(registry, selected, n, q, seed, hit)
    require([r["filter"] for r in rows] == expected, "Raw filter order differs from frozen C++ source")
    return expected
