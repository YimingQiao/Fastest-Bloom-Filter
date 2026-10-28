#!/usr/bin/env python3
"""CLI and semantic smoke only: every timing value is incidental and unclaimed."""
import argparse
import csv
import hashlib
import io
import itertools
import json
from pathlib import Path
import subprocess

FAMILIES = (
    ("FastPatternBF", "FastPatternSingleApiV1"),
    ("ByteSplitBloomFilter", "ByteNativeSingleApiV1"),
    ("FourSectorBloomFilter", "FourSectorNativeSingleApiV1"),
    ("Split64BloomFilter", "SplitNativeSingleApiV1"),
    ("Fastbloom017", "FastbloomSingleApiV1"),
    ("BloomsdayPinned", "BloomsdaySingleApiV1"),
    ("SbbfSafePinned", "SbbfSafeSingleApiV1"),
)
NAMES = {name for family in FAMILIES for name in family}
SEMANTICS = (
    "keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk", "hash_bits",
    "hit_percent", "present_queries", "batch", "repeats", "seed", "absent_queries",
    "false_positives", "result_checksum", "input_mode", "insert_batch",
    "calibration_absent_queries", "calibration_false_positives",
)


def validate_rows(rows, expected):
    assert len(rows) == len(expected) and {r["filter"] for r in rows} == expected
    by_name = {row["filter"]: row for row in rows}
    for base, single in FAMILIES:
        if base in by_name and single in by_name:
            for field in SEMANTICS:
                assert by_name[base][field] == by_name[single][field], (base, single, field)
    assert len({r["filter_bytes"] for r in rows}) == 1
    assert all(r["calibration_absent_queries"] == "4096" for r in rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--cpu", type=int, default=3)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    binary = args.binary.resolve()
    before = hashlib.sha256(binary.read_bytes()).hexdigest()
    records = []
    prefix = ["taskset", "-c", str(args.cpu), str(binary)]
    for selector in [
        "FastPatternBloomFilter", "SbbfSafe", "SbbfSafePinned,Missing",
        "Missing,SbbfSafePinned", "SbbfSafePinned,", ",SbbfSafePinned",
        "SbbfSafePinned,,FastPatternBF", ",", ",,",
        "SbbfSafePinned,SbbfSafePinned", "FastPatternBF,SbbfSafePinned,FastPatternBF",
        " SbbfSafePinned", "SbbfSafePinned ", "sbbfsafepinned",
    ]:
        cmd = prefix + ["10", "8", "50", "12", "31", "1", "42", selector]
        result = subprocess.run(cmd, capture_output=True, text=True)
        assert result.returncode != 0 and result.stdout == "" and result.stderr.strip(), cmd
        records.append(dict(command=cmd, returncode=result.returncode, stderr=result.stderr))
    # Missing and empty selectors mean all. Individual rows and a reordered
    # complete selector prove exact-name selection rather than substring matches.
    for selector in [None, "", *sorted(NAMES), ",".join(sorted(NAMES, reverse=True))]:
        cmd = prefix + ["10", "8", "50", "12", "31", "1", "42"]
        if selector is not None:
            cmd += [selector, "17", "12"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        expected = NAMES if not selector else set(selector.split(","))
        assert len(rows) == len(expected) and {r["filter"] for r in rows} == expected
        if selector is not None:
            validate_rows(rows, expected)
            assert all(r["insert_batch"] == "17" for r in rows)
        records.append(dict(command=cmd, rows=rows, stderr=result.stderr))
    # A separate 12-workload/168-row full-registry semantic smoke exercises
    # calibration, short/tail/bulk batches and both common byte budgets.
    smoke = []
    for bpk, batch in itertools.product((8, 16), (1, 3, 4, 8, 31, 4096)):
        cmd = prefix + ["12", str(bpk), "50", "12", str(batch), "1", "42", "", "17", "12"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        validate_rows(rows, NAMES)
        smoke.append(dict(command=cmd, rows=rows, stderr=result.stderr))
    assert hashlib.sha256(binary.read_bytes()).hexdigest() == before
    report = dict(binary=str(binary), binary_sha256=before, cpu=args.cpu,
                  cli_cases=len(records), smoke_workloads=len(smoke),
                  smoke_rows=sum(len(item["rows"]) for item in smoke),
                  timings_claimed=False, records=records, smoke=smoke)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(f"PASS: {len(records)} CLI cases; 12 semantic workloads / 168 rows; no timing claims")


if __name__ == "__main__":
    main()
