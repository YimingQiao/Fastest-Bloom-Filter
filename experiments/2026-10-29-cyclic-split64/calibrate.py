#!/usr/bin/env python3
"""Execute the committed fixed accuracy pilot; report no performance metric."""
import argparse
import csv
import fcntl
import hashlib
import io
import json
import math
import os
from pathlib import Path
import re
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BINARY = Path("/tmp/fastest-bf-cyclic-split64/native/calibrate")


def require(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(commit):
    require(bool(re.fullmatch(r"[0-9a-f]{40}", commit)), "Exact source commit required")
    manifest = json.loads((HERE / "manifest.json").read_text())
    files = {**manifest["files"], "manifest.json": sha(HERE / "manifest.json")}
    for name, expected in files.items():
        path = (HERE / name).resolve()
        require(path.is_relative_to(HERE), "Manifest path escape")
        require(sha(path) == expected, "Archive drift: " + name)
        blob = subprocess.check_output(["git", "show", commit+":"+str(path.relative_to(ROOT))], cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest() == expected, "Uncommitted archive: " + name)
    freeze = json.loads((HERE / "FREEZE.json").read_text())
    for name, expected in freeze["source_sha256"].items():
        require(sha(ROOT / name) == expected, "Compiled input drift: " + name)
    for name, expected in freeze["binary_sha256"].items():
        require(sha(Path(name)) == expected, "Binary drift: " + name)
    require(str(BINARY) in freeze["binary_sha256"], "Missing pilot executable")
    return dict(manifest_sha256=sha(HERE / "manifest.json"), freeze_sha256=sha(HERE / "FREEZE.json"),
                binary_sha256=sha(BINARY), archive_files=len(files))


def wilson(fp, n):
    z = 1.959963984540054
    p, zz = fp/n, z*z
    return (p+zz/(2*n)+z*math.sqrt((p*(1-p)+zz/(4*n))/n))/(1+zz/n)


def validate(rows):
    expected = [(name, 1 << power, bpk) for power in (16, 25) for bpk in (16, 24, 28, 32)
                for name in ("Split64Range", "CyclicSplit64Range")]
    require(len(rows) == len(expected), "Incomplete accuracy matrix")
    for row, (name, keys, bpk) in zip(rows, expected):
        require(row["filter"] == name and int(row["keys"]) == keys and int(row["actual_bpk"]) == bpk, "Wrong geometry/order")
        require(int(row["filter_bytes"]) == keys*bpk//8, "Wrong actual allocation")
        require(int(row["seed"]) == 42 and int(row["calibration_negatives"]) == 1 << 24, "Wrong accuracy stream")
        require(0 <= int(row["false_positives"]) <= 1 << 24, "Invalid FP count")
        require(0 <= int(row["checksum"]) < 1 << 64, "Invalid dense checksum")


def main():
    require(__debug__, "Normal Python required")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    args = parser.parse_args()
    require(os.sched_getaffinity(0) == {2}, "Expected CPU2-only accuracy process")
    descriptors = []
    for p in Path("/proc/self/fd").iterdir():
        if p.exists() and p.resolve() == Path("/tmp/fastest-bf-socket0.lock"):
            fd = int(p.name)
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            descriptors.append(fd)
    require(descriptors, "Expected inherited socket0 lease")
    anchor = verify(args.source_commit)
    out = HERE / "accuracy"
    out.mkdir(exist_ok=False)
    metadata = dict(scope="Accuracy only, no speed measurement or selection", source_commit=args.source_commit,
                    anchor=anchor, command=[str(BINARY)], affinity=[2], lease="/tmp/fastest-bf-socket0.lock",
                    inherited_lock_descriptors=descriptors, start_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), complete=False)
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2)+"\n")
    result = subprocess.run([str(BINARY)], cwd=ROOT, capture_output=True, text=True)
    (out / "results.csv").write_text(result.stdout)
    (out / "stderr.log").write_text(result.stderr)
    require(result.returncode == 0, "Calibration failed; logs retained")
    rows = list(csv.DictReader(io.StringIO(result.stdout)))
    validate(rows)
    require(verify(args.source_commit) == anchor, "Archive changed during accuracy pilot")
    quality = []
    for row in rows:
        n, fp = int(row["calibration_negatives"]), int(row["false_positives"])
        high = wilson(fp, n)
        quality.append(dict(**row, observed_fpr=fp/n, wilson_upper=high,
                            qualifies_1_percent=high <= .01, qualifies_point1_percent=high <= .001,
                            qualifies_point01_percent=high <= .0001))
    (out / "quality.json").write_text(json.dumps(quality, indent=2)+"\n")
    metadata.update(complete=True, rows=len(rows), results_sha256=sha(out/"results.csv"),
                    end_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2)+"\n")
    print("Validated16 accuracy-only rows; every full inserted-key check passed; all sources/binaries unchanged")


if __name__ == "__main__":
    main()
