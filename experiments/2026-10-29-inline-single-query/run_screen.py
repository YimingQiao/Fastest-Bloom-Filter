#!/usr/bin/env python3
"""Run the prespecified full-registry screen; caller holds the socket0 lock."""
import argparse
from collections import Counter
import csv
import hashlib
import json
import math
from pathlib import Path
import statistics
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def verify_freeze():
    frozen = json.loads((HERE / "freeze-v2-direct.json").read_text())
    for group in ("source_sha256", "binary_sha256"):
        for name, digest in frozen[group].items():
            if hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest:
                raise ValueError(f"Frozen {group} changed: {name}")
    return frozen


def validate(rows, names):
    if len(rows) != 240:
        raise ValueError("Expected four full-registry cases / 240 rows")
    cases = {}
    for row in rows:
        case = (int(row["keys"]), int(row["requested_bpk"]))
        cases.setdefault(case, []).append(row)
        if row["scalar_track"] != "optimizer_visible_count1":
            raise ValueError("Wrong scalar timing contract")
        if any(
            int(row[k]) != v
            for k, v in {
                "queries": 1 << 22,
                "repeats": 8,
                "seed": 42,
                "batch": 1,
                "hit_percent": 50,
                "calibration_absent_queries": 1 << 24,
                "insert_batch": int(row["keys"]),
            }.items()
        ):
            raise ValueError("Workload differs from the screen protocol")
        schedule = [
            [int(v) for v in t.split("|")] for t in row["query_phase_order"].split(";")
        ]
        if len(schedule) != 8:
            raise ValueError("Incomplete phase schedule")
        for start in (0, 4):
            block = schedule[start : start + 4]
            if any(sorted(t) != [0, 1, 2, 3] for t in block):
                raise ValueError("Missing query phase")
            if any(sorted(t[p] for t in block) != [0, 1, 2, 3] for p in range(4)):
                raise ValueError("Unbalanced phase positions")
            pairs = Counter((t[p], t[p + 1]) for t in block for p in range(3))
            if pairs != Counter(
                {(a, b): 1 for a in range(4) for b in range(4) if a != b}
            ):
                raise ValueError("Unbalanced within-trial predecessors")
        for prefix in ("inline_lookup", "inline_hash_lookup"):
            samples = [float(v) for v in row[prefix + "_trials"].split("|")]
            if row["input_mode"] == "raw_bytes" and prefix == "inline_lookup":
                if len(samples) != 1 or not math.isnan(samples[0]):
                    raise ValueError("Raw-only filter has prehashed samples")
                if any(
                    not math.isnan(float(row[prefix + suffix]))
                    for suffix in ("_ns", "_min_ns", "_max_ns")
                ):
                    raise ValueError("Raw-only filter has prehashed timing fields")
                continue
            if len(samples) != 8 or any(
                not math.isfinite(v) or v <= 0 for v in samples
            ):
                raise ValueError("Invalid timing samples")
            for suffix, fn in (
                ("_ns", statistics.median),
                ("_min_ns", min),
                ("_max_ns", max),
            ):
                if not math.isclose(
                    float(row[prefix + suffix]), fn(samples), rel_tol=2e-5, abs_tol=1e-5
                ):
                    raise ValueError("Timing summary disagrees with samples")
    if set(cases) != {(n, b) for n in (1 << 16, 1 << 25) for b in (8, 16)}:
        raise ValueError("Missing or unexpected scenario")
    for case_rows in cases.values():
        if len(case_rows) != 60 or {r["filter"] for r in case_rows} != set(names):
            raise ValueError("Incomplete filter registry")
        if len({r["query_phase_order"] for r in case_rows}) != 1:
            raise ValueError("Candidates used different query phase schedules")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, default=HERE / "screen")
    args = parser.parse_args()
    frozen = verify_freeze()
    names = json.loads((HERE / "registry.json").read_text())["filters"]
    protocol = json.loads((HERE / "screen-protocol.json").read_text())
    if names != protocol["filters"]:
        raise ValueError("Registry changed since protocol declaration")
    command = [
        sys.executable,
        str(ROOT / "scripts/run_comparison.py"),
        "--executable",
        str(ROOT / protocol["binary"]),
        "--output-dir",
        str(args.output),
        "--key-powers",
        "16,25",
        "--bits-per-key",
        "8,16",
        "--hits",
        "50",
        "--batches",
        "1",
        "--seeds",
        "42",
        "--query-power",
        "22",
        "--repeats",
        "8",
        "--cpu",
        "2",
        "--filters",
        ",".join(names),
        "--insert-batch",
        "0",
        "--calibration-power",
        "24",
        "--binary-source-revision",
        args.source_commit,
    ]
    subprocess.run(command, cwd=ROOT, check=True)
    verify_freeze()
    with (args.output / "results.csv").open() as stream:
        rows = list(csv.DictReader(stream))
    validate(rows, names)
    result = {
        "cases": 4,
        "rows": len(rows),
        "source_and_binary_unchanged": True,
        "compiled_source_commit": args.source_commit,
        "freeze_sha256": hashlib.sha256(
            (HERE / "freeze-v2-direct.json").read_bytes()
        ).hexdigest(),
        "protocol_sha256": hashlib.sha256(
            (HERE / "screen-protocol.json").read_bytes()
        ).hexdigest(),
        "binary_sha256": frozen["binary_sha256"][protocol["binary"]],
        "query_contract": "Generic batch-count-one and optimizer-visible count-one loops remain separate metrics",
        "status": "Exploratory seed42 screen; no held-out performance claim",
    }
    (args.output / "validation.json").write_text(json.dumps(result, indent=2) + "\n")
    print("PASS: full 60-filter screen, complete phase balance, samples and freeze")


if __name__ == "__main__":
    main()
