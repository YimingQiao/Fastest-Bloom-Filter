#!/usr/bin/env python3
"""Compare native Rust/C++ answers over identical deterministic workloads."""
import argparse
import csv
import io
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--cpp", default="build/native/compare_benchmark")
parser.add_argument("--rust", default="rust/target/release/compare_benchmark")
parser.add_argument("--filters", default="CacheSectorizedBF32Bit,FastPatternBF",
                    help="Exact shared filter names; use native types on ARM")
args = parser.parse_args()
fields = [
    "keys",
    "queries",
    "filter_bytes",
    "actual_bpk",
    "hash_bits",
    "present_queries",
    "absent_queries",
    "false_positives",
    "result_checksum",
]
for bpk in [4, 8, 16, 32]:
    for hit in [0, 50, 100]:
        for seed in [42, 731]:
            params = [
                "10",
                str(bpk),
                str(hit),
                "14",
                "31",
                "1",
                str(seed),
                args.filters,
            ]

            def run(executable):
                result = subprocess.run(
                    [executable] + params, text=True, capture_output=True, check=True
                )
                return {
                    row["filter"]: row
                    for row in csv.DictReader(io.StringIO(result.stdout))
                }

            cpp, rust = run(args.cpp), run(args.rust)
            assert cpp.keys() == rust.keys()
            for name in cpp:
                for field in fields:
                    assert cpp[name][field] == rust[name][field], (
                        params,
                        name,
                        field,
                        cpp[name][field],
                        rust[name][field],
                    )
print(
    "C++/Rust agree on complete output checksums, FPR counts, and space across 24 workloads."
)
