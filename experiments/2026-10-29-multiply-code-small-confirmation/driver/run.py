#!/usr/bin/env python3
"""Run the fixed144 confirmation only after committed guards and an explicit lease."""
if not __debug__:
    raise RuntimeError("Do not use Python -O: full row assertions are mandatory")

import argparse
import csv
import json
from pathlib import Path
import subprocess
import time

from contract import command, dimensions, parse_raw, protocol, validate_case, validate_matrix
from source_guard import ROOT, STAGE, require, require_lease, sha, verify


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True,
                        help="Use only the CPU/socket explicitly leased by the coordinator")
    args = parser.parse_args()
    lease = require_lease(args.cpu)
    anchor = verify(args.source_commit)
    p = protocol()
    reg = dimensions(p)
    require(sha(Path(p["binary"])) == p["binary_sha256"], "Wrong fixed76 benchmark binary")
    out = STAGE / "confirmation"
    out.mkdir(exist_ok=False)
    meta = dict(complete=False, scope="Prespecified six order-conditioned fresh seeds; fixed small16-bpk/.1% query confirmation",
                source_commit=args.source_commit, compiled_source_commit=p["source_commit"],
                binary=p["binary"], binary_sha256=p["binary_sha256"], anchor=anchor,
                protocol_sha256=sha(STAGE / "protocol.json"), lease=lease,
                start_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), cases=[])
    save(out / "metadata.json", meta)
    rows = []
    for i, case in enumerate(p["cases"]):
        require(require_lease(args.cpu) == lease, "Lease changed during the matrix")
        require(verify(args.source_commit) == anchor, "Source/binary changed during the matrix")
        cmd = command(p, case)
        result = subprocess.run(cmd, cwd=ROOT, capture_output=True)
        stem = f"case-{i:02d}-s{case['seed']}-q{case['batch']}"
        stdout, stderr = out / (stem + ".stdout"), out / (stem + ".stderr")
        stdout.write_bytes(result.stdout)
        stderr.write_bytes(result.stderr)
        record = dict(case=case, command=cmd, returncode=result.returncode,
                      stdout_file=stdout.name, stderr_file=stderr.name,
                      stdout_sha256=sha(stdout), stderr_sha256=sha(stderr), validated=False)
        meta["cases"].append(record)
        save(out / "metadata.json", meta)
        require(result.returncode == 0, "Failed case; attempt and raw output retained: " + stem)
        parsed = validate_case(parse_raw(result.stdout), p, case, reg)
        rows.extend(parsed)
        with (out / "results.csv").open("w", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
        record.update(validated=True, rows=len(parsed))
        save(out / "metadata.json", meta)
        print(f"Validated {i + 1}/18 cases, {len(rows)}/144 rows", flush=True)
    q = validate_matrix(rows, p, reg)
    save(out / "quality.json", q)
    require(require_lease(args.cpu) == lease, "Final lease changed")
    require(verify(args.source_commit) == anchor, "Final source/binary changed")
    meta.update(complete=True, rows=len(rows), results_sha256=sha(out / "results.csv"),
                quality_sha256=sha(out / "quality.json"),
                end_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    save(out / "metadata.json", meta)
    # Archive exact raw bytes; no line-ending rewriting of evidence is allowed.
    save(out / "archive-manifest.json", dict(files={path.name: sha(path) for path in sorted(out.iterdir())
                                                  if path.is_file()}))
    print("Complete:144 rows;48 API/seed and36 distinct mapping/seed quality records; no sample pooling", flush=True)


if __name__ == "__main__":
    main()
