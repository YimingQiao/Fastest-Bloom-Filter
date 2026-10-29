#!/usr/bin/env python3
"""New C++ layouts are opt-in and agree across serial/partitioned APIs."""
import sys
from test_optional_benchmark_selection import exact, invoke

compare, parallel = sys.argv[1:]
families = ("Split16", "Word64")
classes = [f + "BloomFilter" for f in families]
prefix = [10, 8, 50, 12, 31, 1, 731]
defaults = invoke(compare, prefix)
assert not set(classes) & {r["filter"] for r in defaults}
exact(invoke(compare, [*prefix, ",".join(classes)]), classes)
for selection in ("Word64BloomFilter,Unknown", "Split16BloomFilter,Split16BloomFilter"):
    invoke(compare, [*prefix, selection], accepted=False)

prefix = [10, 8, 12, 3, 1, 731, 50]
rows = invoke(parallel, [*prefix, ",".join(families)])
exact(rows, [f + mode for f in families for mode in ("Serial", "Partitioned")])
for family in families:
    pair = [r for r in rows if r["filter"] in (family + "Serial", family + "Partitioned")]
    for field in ("filter_bytes", "false_positives", "result_checksum"):
        assert len({r[field] for r in pair}) == 1, (family, field)
for selection in ("Word64,Unknown", "Split16,Split16", "Word64,"):
    invoke(parallel, [*prefix, selection], accepted=False)
print("Mac layout opt-in selection and serial/parallel parity passed")
