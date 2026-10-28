#!/usr/bin/env python3
"""Validate allocation, accounting, full construction and adapter API semantics."""
import csv
import io
import math
import subprocess
import sys

exe = sys.argv[1]


def run(bpk, hit, insert_batch):
    output = subprocess.check_output(
        [exe, "10", str(bpk), str(hit), "12", "31", "1", "42", "", str(insert_batch)],
        text=True,
    )
    return {r["filter"]: r for r in csv.DictReader(io.StringIO(output))}


for bpk in [4, 8, 16]:
    for hit in [0, 50, 100]:
        rows = run(bpk, hit, 1024)
        partial = run(bpk, hit, 31)
        assert len(rows) == 24, len(rows)
        present = sum(i % 100 < hit for i in range(4096))
        assert len({r["filter_bytes"] for r in rows.values()}) == 1
        for name, row in rows.items():
            assert row["result_checksum"] == partial[name]["result_checksum"], name
            assert int(row["present_queries"]) == present
            assert int(row["absent_queries"]) == 4096 - present
            if present < 4096:
                assert (
                    abs(
                        float(row["fpr"])
                        - int(row["false_positives"]) / (4096 - present)
                    )
                    < 1e-6
                )
            else:
                assert math.isnan(float(row["fpr"]))
            assert float(row["hash_lookup_ns"]) > 0
            assert float(row["hash_insert_ns"]) > 0
            if name.startswith("PageBloom"):
                assert row["input_mode"] == "raw_bytes"
                assert math.isnan(float(row["insert_ns"]))
                assert math.isnan(float(row["lookup_ns"]))
            else:
                assert float(row["insert_ns"]) > 0
                assert float(row["lookup_ns"]) > 0
        for a, b in [
            ("FastFilterFixed32", "FastFilterFixed32Bulk"),
            ("FastFilterClassic6", "FastFilterClassic6Bulk"),
            ("FastFilterClassic11", "FastFilterClassic11Bulk"),
            ("FastFilterClassic22", "FastFilterClassic22Bulk"),
            ("FastFilterClassic6", "FastFilterClassic6Branchless"),
            ("FastFilterClassic11", "FastFilterClassic11Branchless"),
            ("FastFilterClassic22", "FastFilterClassic22Branchless"),
        ]:
            assert rows[a]["result_checksum"] == rows[b]["result_checksum"], (a, b)
# Exercise upstream AddAll block-buffer flushes, not only the short-buffer path.
large = subprocess.check_output(
    [
        exe,
        "16",
        "16",
        "50",
        "17",
        "4096",
        "1",
        "42",
        "FastFilterFixed32,FastFilterFixed32Bulk,FastFilterClassic22,FastFilterClassic22Bulk",
        "65536",
    ],
    text=True,
)
large = {r["filter"]: r for r in csv.DictReader(io.StringIO(large))}
for a, b in [
    ("FastFilterFixed32", "FastFilterFixed32Bulk"),
    ("FastFilterClassic22", "FastFilterClassic22Bulk"),
]:
    assert large[a]["result_checksum"] == large[b]["result_checksum"]
print(
    "24 adapters: space, no-false-negative validation, raw/prehash accounting, bulk/loop parity passed."
)
