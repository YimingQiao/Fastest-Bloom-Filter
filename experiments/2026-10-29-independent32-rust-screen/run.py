#!/usr/bin/env python3
"""Run only the committed 132-row protocol under an explicit CPU3 lease."""
import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import platform
import re
import subprocess
import time

from freeze import FROZEN, HERE, REPO, sha, verify
from guard import expected_names, require, validate_all, validate_registry, validate_rows, workloads
from source_guard import require_lease


def save(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + "\n")


def verify_commit(commit, frozen):
    require(re.fullmatch(r"[0-9a-f]{40}", commit) is not None, "Full committed source revision required")
    sources = {**frozen["source_sha256"], str(FROZEN.relative_to(REPO)): sha(FROZEN)}
    for name, expected in sources.items():
        blob = subprocess.check_output(["git", "show", commit + ":" + name], cwd=REPO)
        require(hashlib.sha256(blob).hexdigest() == expected, "Committed source differs: " + name)


def main():
    require(__debug__, "Run the measurement driver without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, default=HERE / "screen")
    args = parser.parse_args()
    frozen = json.loads(FROZEN.read_text())
    verify(frozen)
    verify_commit(args.source_commit, frozen)
    protocol = json.loads((HERE / "protocol.json").read_text())
    registry = json.loads((HERE / "registry.json").read_text())
    validate_registry(registry)
    require(set(protocol["filters"]) == set(registry), "Protocol registry differs")
    require(protocol["binary"] == frozen["binaries"][0]["path"] and protocol["binary_sha256"] == frozen["binaries"][0]["sha256"], "Wrong executable")
    require(os.environ.get("BF_SOCKET_LEASE") == "socket1-cpu3", "Explicit CPU3/socket1 lease required")
    require(os.sched_getaffinity(0) == {protocol["cpu"]}, "Protocol requires CPU3 affinity")
    lease = require_lease(protocol["cpu"], protocol["socket_lock"])
    args.output.mkdir(parents=True, exist_ok=False)
    frozen_sha = sha(FROZEN)
    metadata = dict(started_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), cpu=protocol["cpu"],
                    affinity=sorted(os.sched_getaffinity(0)), socket_lock=protocol["socket_lock"], lease=lease,
                    source_commit=args.source_commit, freeze_sha256=frozen_sha,
                    protocol_sha256=sha(HERE / "protocol.json"), binary_sha256=protocol["binary_sha256"],
                    host=platform.uname()._asdict(), commands=[], complete=False)
    save(args.output / "metadata.json", metadata)
    all_rows = []
    for power, bpk, batch, seed in workloads(protocol):
        verify(frozen, dependencies=False)
        name = f"k{power}-p{bpk}-b{batch}-s{seed}"
        command = ["taskset", "-c", str(protocol["cpu"]), protocol["binary"], str(power), str(bpk),
                   str(protocol["hit_percent"]), str(protocol["query_power"]), str(batch), str(protocol["repeats"]),
                   str(seed), ",".join(name for name in protocol["filters"] if name in expected_names(batch)), str(1 << power), str(protocol["calibration_power"])]
        entry = dict(command=command, workload=[power, bpk, batch, seed], complete=False)
        metadata["commands"].append(entry)
        save(args.output / "metadata.json", metadata)
        started = time.monotonic()
        result = subprocess.run(command, capture_output=True, text=True)
        (args.output / (name + ".csv")).write_text(result.stdout)
        (args.output / (name + ".stderr.log")).write_text(result.stderr)
        entry.update(returncode=result.returncode, elapsed_seconds=time.monotonic() - started)
        save(args.output / "metadata.json", metadata)
        require(result.returncode == 0, "Benchmark failed: " + name)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        validate_rows(rows, registry, protocol, (power, bpk, batch, seed))
        require("sbbf-rs 0.2.8 backend: Avx2Filter" in result.stderr, "Unexpected upstream backend")
        all_rows.extend(rows)
        with (args.output / "results.csv").open("w", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
            writer.writeheader()
            writer.writerows(all_rows)
        entry.update(complete=True, rows=len(rows), csv_sha256=sha(args.output / (name + ".csv")))
        save(args.output / "metadata.json", metadata)
        print(f"{name}: {len(rows)} exact rows; all four trial vectors and phase balance verified", flush=True)
    validate_all(all_rows, registry, protocol)
    verify(frozen)
    require(sha(FROZEN) == frozen_sha, "Freeze changed during execution")
    metadata.update(complete=True, workloads=len(metadata["commands"]), rows=len(all_rows),
                    results_sha256=sha(args.output / "results.csv"),
                    finished_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    save(args.output / "metadata.json", metadata)
    print(f"PASS: {len(all_rows)} rows; frozen sources/binaries unchanged", flush=True)


if __name__ == "__main__":
    main()
