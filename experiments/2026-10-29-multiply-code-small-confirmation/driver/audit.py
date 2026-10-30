#!/usr/bin/env python3
"""Recheck every committed source, command, raw byte, row, trial and quality record."""
if not __debug__:
    raise RuntimeError("Do not use Python -O")

import argparse
import csv
import json

from contract import command, dimensions, parse_raw, protocol, validate_case, validate_matrix
from source_guard import STAGE, require, sha, verify


def audit():
    out = STAGE / "confirmation"
    meta = json.loads((out / "metadata.json").read_text())
    require(meta["complete"] is True and meta["rows"] == 144, "Incomplete confirmation")
    require(verify(meta["source_commit"]) == meta["anchor"], "Confirmation source pin mismatch")
    p, raw_rows = protocol(), []
    reg = dimensions(p)
    require(meta["compiled_source_commit"] == p["source_commit"] and meta["binary"] == p["binary"]
            and meta["binary_sha256"] == p["binary_sha256"], "Wrong measured binary identity")
    require(meta["protocol_sha256"] == sha(STAGE / "protocol.json"), "Wrong measured protocol")
    lease = meta["lease"]
    require(lease["cpu"] in (2, 3) and lease["socket"] == lease["cpu"] - 2
            and lease["affinity"] == [lease["cpu"]]
            and lease["lock_path"] == f"/tmp/fastest-bf-socket{lease['socket']}.lock"
            and bool(lease["inherited_lock_descriptors"]), "Invalid recorded whole-matrix lease")
    require(lease["numa_policy"] == "CPU affinity only; no explicit NUMA memory binding", "Unexpected placement claim")
    require(len(meta["cases"]) == 18, "Missing case attempts")
    expected_files = {"metadata.json", "results.csv", "quality.json"}
    for i, (case, record) in enumerate(zip(p["cases"], meta["cases"])):
        require(record["case"] == case and record["command"] == command(p, case)
                and record["returncode"] == 0 and record["validated"] is True and record["rows"] == 8,
                "Wrong/incomplete case command")
        stem = f"case-{i:02d}-s{case['seed']}-q{case['batch']}"
        for kind in ("stdout", "stderr"):
            name = stem + "." + kind
            require(record[kind + "_file"] == name and sha(out / name) == record[kind + "_sha256"],
                    "Changed raw case output")
            expected_files.add(name)
        raw_rows.extend(validate_case(parse_raw((out / (stem + ".stdout")).read_bytes()), p, case, reg))
    with (out / "results.csv").open(newline="") as stream:
        reader = csv.DictReader(stream)
        require(reader.fieldnames == list(raw_rows[0]), "Aggregate column drift")
        aggregate = list(reader)
    require(raw_rows == aggregate and sha(out / "results.csv") == meta["results_sha256"],
            "Raw/aggregate ordered rows differ")
    q = validate_matrix(aggregate, p, reg)
    require(q == json.loads((out / "quality.json").read_text())
            and sha(out / "quality.json") == meta["quality_sha256"], "Changed quality/sample reuse")
    manifest = json.loads((out / "archive-manifest.json").read_text())["files"]
    require(set(manifest) == expected_files, "Incomplete raw archive manifest")
    for name, digest in manifest.items():
        require(sha(out / name) == digest, "Raw archive byte changed: " + name)
    return aggregate, q


if __name__ == "__main__":
    argparse.ArgumentParser(description=__doc__).parse_args()
    rows, quality = audit()
    print("PASS18 ordered cases/144 rows, every trial/raw hash,48 API-seed/36 mapping-seed quality records")
