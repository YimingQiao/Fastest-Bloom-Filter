#!/usr/bin/env python3
"""Check the scalar track schema, raw-key contract and late-answer fault guards."""
import argparse
import csv
import io
import math
from pathlib import Path
import subprocess
import statistics
from collections import Counter


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
    # One complete four-trial block must balance positions and all ordered
    # within-trial adjacent mode pairs, with the same schedule for every row.
    balanced = subprocess.run(
        [str(exe), "10", "8", "50", "12", "1", "4", "42", "", "1024", "12"],
        capture_output=True, text=True, check=True,
    )
    balanced_rows = list(csv.DictReader(io.StringIO(balanced.stdout)))
    assert len(balanced_rows) == args.expected
    assert {r["filter"] for r in balanced_rows} == seen
    assert len({r["query_phase_order"] for r in balanced_rows}) == 1
    schedule = [[int(v) for v in trial.split("|")] for trial in balanced_rows[0]["query_phase_order"].split(";")]
    assert len(schedule) == 4 and all(sorted(trial) == [0, 1, 2, 3] for trial in schedule)
    for position in range(4):
        assert sorted(trial[position] for trial in schedule) == [0, 1, 2, 3]
    adjacent = Counter((trial[i], trial[i + 1]) for trial in schedule for i in range(3))
    assert adjacent == Counter({(a, b): 1 for a in range(4) for b in range(4) if a != b})
    for row in balanced_rows:
        for prefix in ("inline_lookup", "inline_hash_lookup"):
            if row["input_mode"] == "raw_bytes" and prefix == "inline_lookup":
                assert row[prefix + "_trials"] == "nan" and math.isnan(float(row[prefix + "_ns"]))
                continue
            values = [float(v) for v in row[prefix + "_trials"].split("|")]
            assert len(values) == 4 and all(math.isfinite(v) and v > 0 for v in values)
            for field, expected_value in (("_ns", statistics.median(values)), ("_min_ns", min(values)), ("_max_ns", max(values))):
                assert math.isclose(float(row[prefix + field]), expected_value, rel_tol=2e-5, abs_tol=1e-5)
    cases += 1
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
        f"PASS: {cases} workloads/{cases * args.expected} rows; four-trial complete phase balance, both late-answer faults and strict CLI rejection"
    )


if __name__ == "__main__":
    main()
