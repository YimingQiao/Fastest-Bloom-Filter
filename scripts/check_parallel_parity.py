#!/usr/bin/env python3
"""Check identical native Rust/C++ answers through all parallel construction modes."""
import csv
import io
import subprocess
import argparse
from parallel_selection import selected_families, mode_names, family_rows

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--cpp", default="build/native/parallel_benchmark")
parser.add_argument("--rust", default="rust/target/release/parallel_benchmark")
parser.add_argument("--families", default="all")
args = parser.parse_args()
try:
    families = selected_families(args.families)
except ValueError as error:
    parser.error(str(error))
expected = {
    name
    for family in families
    for name in mode_names(family)
}

for threads in [1, 3, 8]:
    for bpk in [4, 16]:
        for hit in [0, 50, 100]:
            params = ["16", str(bpk), "16", str(threads), "1", "42", str(hit)]
            if args.families != "FastPattern":
                params.append(args.families)

            def run(exe):
                result = subprocess.run(
                    [exe] + params, text=True, capture_output=True, check=True
                )
                rows = list(csv.DictReader(io.StringIO(result.stdout)))
                assert (
                    len(rows) == len(expected)
                    and {r["filter"] for r in rows} == expected
                )
                return rows

            rows = run(args.cpp) + run(args.rust)
            for family in families:
                rr = family_rows(rows, family)
                for field in [
                    "result_checksum",
                    "false_positives",
                    "absent_queries",
                    "filter_bytes",
                ]:
                    assert len({r[field] for r in rr}) == 1, (params, family, field, rr)
            for name in expected:
                rr = [r for r in rows if r["filter"] == name]
                for field in ["build_workers", "query_workers"]:
                    assert len({r[field] for r in rr}) == 1, (params, name, field, rr)
print(
    f"{len(expected)} modes agree within and across C++/Rust for 18 parallel workloads; scratch is reported separately."
)
