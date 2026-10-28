#!/usr/bin/env python3
"""Check the scalar track schema, raw-key contract and late-answer fault guards."""
import argparse
import csv
import io
import math
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("build", type=Path)
    parser.add_argument("--expected", type=int, required=True)
    args = parser.parse_args()
    exe = args.build.resolve() / "benchmark"
    seen = None
    cases = 0
    for bpk in (8, 16):
        for hit in (0, 50, 100):
            command = [
                str(exe),
                "10",
                str(bpk),
                str(hit),
                "12",
                "1",
                "1",
                "42",
                "",
                "1024",
                "12",
            ]
            run = subprocess.run(command, capture_output=True, text=True, check=True)
            rows = list(csv.DictReader(io.StringIO(run.stdout)))
            names = {r["filter"] for r in rows}
            assert len(rows) == len(names) == args.expected
            if seen is None:
                seen = names
            assert names == seen
            for row in rows:
                assert row["scalar_track"] == "optimizer_visible_count1"
                assert sorted(row["query_phase_order"].split("|")) == ["0", "1", "2", "3"]
                assert (
                    row["batch"] == "1" and row["calibration_absent_queries"] == "4096"
                )
                for prefix in ("inline_lookup", "inline_hash_lookup"):
                    value = float(row[prefix + "_ns"])
                    if row["input_mode"] == "raw_bytes" and prefix == "inline_lookup":
                        assert math.isnan(value) and row[prefix + "_trials"] == "nan"
                    else:
                        low, high = float(row[prefix + "_min_ns"]), float(
                            row[prefix + "_max_ns"]
                        )
                        assert math.isfinite(value) and 0 <= low <= value <= high
                        assert abs(float(row[prefix + "_trials"]) - value) < 1e-4
            cases += 1
            assert len({row["query_phase_order"] for row in rows}) == 1
    base = ["10", "8", "50", "12", "1", "1", "42", "ByteSplitBloomFilter", "1024", "12"]
    for target, expected in (
        ("fault_pure", "timed inline prehashed lookup"),
        ("fault_raw", "timed inline hash+lookup"),
    ):
        run = subprocess.run(
            [str(args.build.resolve() / target), *base], capture_output=True, text=True
        )
        assert run.returncode != 0 and expected in run.stderr, (target, run.stderr)
    for selection in (
        "UnknownFilter",
        "ByteSplitBloomFilter,",
        "ByteSplitBloomFilter,ByteSplitBloomFilter",
    ):
        bad = base.copy()
        bad[7] = selection
        run = subprocess.run([str(exe), *bad], capture_output=True, text=True)
        assert run.returncode != 0 and not run.stdout
    bad = base.copy()
    bad[4] = "31"
    run = subprocess.run([str(exe), *bad], capture_output=True, text=True)
    assert run.returncode != 0 and not run.stdout
    print(
        f"PASS: {cases} workloads/{cases * args.expected} rows; both late-answer faults and strict CLI rejection"
    )


if __name__ == "__main__":
    main()
