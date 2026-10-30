#!/usr/bin/env python3
"""Run the complete preregistered 14-row screen under its explicit socket lease."""
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

from guard import require, validate_all, validate_registry, validate_rows, workloads

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_freeze(full=True):
    frozen = json.loads((HERE / "freeze.json").read_text())
    for name, expected in frozen["screen_source_sha256"].items():
        require(sha(HERE / name) == expected, f"Changed screen input: {name}")
    protocol = json.loads((HERE / "protocol.json").read_text())
    adapter = json.loads((HERE / "adapter-freeze.json").read_text())
    require(sha(HERE / "adapter-freeze.json") == protocol["adapter_freeze_sha256"], "Adapter freeze changed")
    require(adapter["binary"] == protocol["binary"] and adapter["binary_sha256"] == protocol["binary_sha256"], "Binary contract changed")
    require(sha(Path(protocol["binary"])) == protocol["binary_sha256"], "Binary changed")
    for name, expected in adapter["source_sha256"].items():
        require(sha(REPO / name) == expected, f"Adapter/native source changed: {name}")
    if full:
        for dependency in adapter["external_dependencies"]:
            for name, expected in dependency["sha256"].items():
                require(sha(Path(dependency["directory"]) / name) == expected, f"Dependency changed: {dependency['name']}/{name}")
        manifest = REPO / "benchmarks/rust-sbbf-external/manifest.json"
        require(sha(manifest) == protocol["adapter_archive_manifest_sha256"], "Adapter archive changed")
        for name, expected in json.loads(manifest.read_text())["files"].items():
            path = "benchmarks/rust-sbbf-external/" + name
            blob = subprocess.check_output(["git", "show", protocol["adapter_commit"] + ":" + path], cwd=REPO)
            require(hashlib.sha256(blob).hexdigest() == expected, f"Adapter commit differs: {path}")
    return protocol


def save_json(path, data):
    path.write_text(json.dumps(data, indent=2, allow_nan=False) + "\n")


def verify_screen_commit(commit):
    require(re.fullmatch(r"[0-9a-f]{40}", commit) is not None, "An explicit full source commit is required")
    frozen = json.loads((HERE / "freeze.json").read_text())
    for name, expected in {**frozen["screen_source_sha256"], "freeze.json": sha(HERE / "freeze.json")}.items():
        path = str(HERE.relative_to(REPO) / name)
        blob = subprocess.check_output(["git", "show", commit + ":" + path], cwd=REPO)
        require(hashlib.sha256(blob).hexdigest() == expected, f"Screen commit differs: {path}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "screen")
    parser.add_argument("--source-commit", required=True, help="full committed screen/protocol revision")
    args = parser.parse_args()
    protocol = verify_freeze()
    verify_screen_commit(args.source_commit)
    registry = json.loads((HERE / "registry.json").read_text())
    validate_registry(registry)
    require(set(registry) == set(protocol["filters"]), "Protocol registry differs")
    require(os.environ.get("BF_SOCKET_LEASE") == "socket1-cpu3", "Explicit CPU3/socket1 lease required")
    require(os.sched_getaffinity(0) == {protocol["cpu"]}, "Runner must be pinned to protocol CPU3")
    args.output.mkdir(parents=True, exist_ok=False)
    source_freeze = sha(HERE / "freeze.json")
    metadata = dict(started_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                    cpu=protocol["cpu"], affinity=sorted(os.sched_getaffinity(0)),
                    socket_lock=protocol["socket_lock"], host=platform.uname()._asdict(),
                    adapter_commit=protocol["adapter_commit"], screen_commit=args.source_commit, freeze_sha256=source_freeze,
                    protocol_sha256=sha(HERE / "protocol.json"),
                    binary_sha256=protocol["binary_sha256"], commands=[], complete=False)
    save_json(args.output / "metadata.json", metadata)
    rows_all = []
    for power, bpk, batch, seed in workloads(protocol):
        verify_freeze(full=False)
        name = f"k{power}-p{bpk}-b{batch}-s{seed}"
        command = ["taskset", "-c", str(protocol["cpu"]), protocol["binary"], str(power), str(bpk),
                   str(protocol["hit_percent"]), str(protocol["query_power"]), str(batch),
                   str(protocol["repeats"]), str(seed), ",".join(protocol["filters"]),
                   str(1 << power), str(protocol["calibration_power"])]
        entry = dict(command=command, workload=[power, bpk, batch, seed], complete=False)
        metadata["commands"].append(entry)
        save_json(args.output / "metadata.json", metadata)
        started = time.monotonic()
        result = subprocess.run(command, capture_output=True, text=True)
        (args.output / (name + ".csv")).write_text(result.stdout)
        (args.output / (name + ".stderr.log")).write_text(result.stderr)
        entry.update(returncode=result.returncode, elapsed_seconds=time.monotonic() - started)
        save_json(args.output / "metadata.json", metadata)
        require(result.returncode == 0, f"Benchmark failed; preserved {name} output")
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        validate_rows(rows, registry, protocol, (power, bpk, batch, seed))
        require("sbbf-rs 0.2.8 backend: Avx2Filter" in result.stderr, "Unexpected upstream backend")
        rows_all.extend(rows)
        with (args.output / "results.csv").open("w", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows_all)
        entry.update(complete=True, rows=len(rows), csv_sha256=sha(args.output / (name + ".csv")))
        save_json(args.output / "metadata.json", metadata)
        print(f"{name}: {len(rows)} exact rows; original/control bytes, outputs and calibration match", flush=True)
    validate_all(rows_all, registry, protocol)
    verify_freeze()
    require(sha(HERE / "freeze.json") == source_freeze, "Freeze file changed during run")
    metadata.update(complete=True, workloads=len(metadata["commands"]), rows=len(rows_all),
                    results_sha256=sha(args.output / "results.csv"),
                    finished_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    save_json(args.output / "metadata.json", metadata)
    print(f"PASS: {len(metadata['commands'])} workloads / {len(rows_all)} rows; all frozen inputs unchanged", flush=True)


if __name__ == "__main__":
    main()
