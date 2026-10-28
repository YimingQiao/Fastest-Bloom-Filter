#!/usr/bin/env python3
"""Semantic/CLI preflight only; all generated timing values are unclaimed."""
import argparse
import collections
import csv
import hashlib
import io
import itertools
import json
import math
from pathlib import Path
import subprocess

NAMES = {"FastPatternBF", "ByteSplitBloomFilter", "FourSectorBloomFilter", "Split64BloomFilter", "Fastbloom017", "BloomsdayPinned", "SbbfSafePinned"}
SEMANTICS = ("keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk", "hash_bits",
             "hit_percent", "present_queries", "batch", "repeats", "seed", "absent_queries",
             "false_positives", "result_checksum", "input_mode", "insert_batch",
             "calibration_absent_queries", "calibration_false_positives")
METRICS = ("lookup", "hash_lookup", "inline_lookup", "inline_hash_lookup")


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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--cpu", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    hashes = {str(p.resolve()): hashlib.sha256(p.read_bytes()).hexdigest() for p in (args.binary, args.reference)}
    records = []
    for bpk, hit in itertools.product((8, 16), (0, 50, 100)):
        rest = ["10", str(bpk), str(hit), "12", "1", "4", "42", ",".join(sorted(NAMES)), "37", "12"]
        results = []
        for binary in (args.binary, args.reference):
            command = ["taskset", "-c", str(args.cpu), str(binary.resolve()), *rest]
            result = subprocess.run(command, capture_output=True, text=True, check=True)
            rows = list(csv.DictReader(io.StringIO(result.stdout)))
            assert len(rows) == 7 and {row["filter"] for row in rows} == NAMES
            results.append({row["filter"]: row for row in rows})
            records.append(dict(command=command, stdout=result.stdout, stderr=result.stderr))
        for name in NAMES:
            current, reference = results[0][name], results[1][name]
            for field in SEMANTICS:
                assert current[field] == reference[field], (name, field)
            validate_row(current)
    invalid = [
        ("31", "4", "FastPatternBF"), ("1", "5", "FastPatternBF"),
        ("1", "4", "FastPatternBloomFilter"), ("1", "4", "FastPatternBF,SbbfSafe"),
        ("1", "4", "SbbfSafePinned,"), ("1", "4", "SbbfSafePinned,SbbfSafePinned"),
    ]
    for batch, repeats, names in invalid:
        command = ["taskset", "-c", str(args.cpu), str(args.binary.resolve()), "10", "8", "50", "12", batch, repeats, "42", names]
        result = subprocess.run(command, capture_output=True, text=True)
        assert result.returncode != 0 and not result.stdout and result.stderr.strip()
        records.append(dict(command=command, returncode=result.returncode, stdout=result.stdout, stderr=result.stderr))
    for name, expected in hashes.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(dict(binary_sha256=hashes, timings_claimed=False,
                                         workloads=6, rows=42, invalid_cli_cases=6, records=records), indent=2) + "\n")
    print("PASS: 6 workloads / 42 rows exact frozen-baseline parity, all phase/trial checks, 6 invalid CLI cases")


if __name__ == "__main__":
    main()
