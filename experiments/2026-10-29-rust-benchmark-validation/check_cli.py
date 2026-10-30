#!/usr/bin/env python3
"""Reject malformed selections before any CSV; accept only the exact requested rows."""
import argparse
import csv
import hashlib
import io
import json
import subprocess
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--native", type=Path, required=True)
parser.add_argument("--external", type=Path, required=True)
parser.add_argument("--cpu", type=int, default=2)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
records = []
for exe, available in [
    (args.native, {"CacheSectorizedBF32Bit", "FastPatternBF", "FourSectorBloomFilter", "Split64BloomFilter"}),
    (args.external, {"Fastbloom017", "FastPatternBF", "BloomsdayPinned", "Split64Experimental", "FourSector16K8Experimental"}),
]:
    base = ["taskset", "-c", str(args.cpu), str(exe), "10", "8", "50", "12", "31", "1", "42"]
    for selection in [
        "FastPatternBloomFilter", "FastPatternBF,FastPatternBloomFilter", "FastPatternBloomFilter,FastPatternBF",
        "FastPatternBF,", ",FastPatternBF", "FastPatternBF,,FastPatternBF", ",", ",,",
        "FastPatternBF,FastPatternBF", " FastPatternBF", "FastPatternBF ", "fastpatternbf",
    ]:
        cmd = base + [selection]
        result = subprocess.run(cmd, capture_output=True, text=True)
        assert result.returncode != 0, (cmd, "accepted invalid selector")
        assert result.stdout == "", (cmd, "printed CSV before rejecting invalid selector")
        assert result.stderr.strip(), (cmd, "no diagnostic")
        records.append({"command": cmd, "returncode": result.returncode, "stdout": result.stdout, "stderr": result.stderr})
    for selection in [None, "", "FastPatternBF", ",".join(sorted(available, reverse=True))]:
        cmd = base if selection is None else base + [selection, "17", "12"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        expected = available if not selection else set(selection.split(","))
        assert len(rows) == len(expected) and {r["filter"] for r in rows} == expected, (cmd, rows)
        if selection is not None:
            assert all(r["insert_batch"] == "17" and r["calibration_absent_queries"] == "4096" for r in rows)
        records.append({"command": cmd, "returncode": result.returncode, "rows": len(rows), "stdout": result.stdout, "stderr": result.stderr})
args.output.write_text(json.dumps({"cases": len(records), "records": records,
    "binary_sha256": {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in [args.native, args.external]}}, indent=2) + "\n")
print(f"PASS: {len(records)} CLI cases; 24 invalid selections produce no CSV, 8 valid cases have exact row sets")
