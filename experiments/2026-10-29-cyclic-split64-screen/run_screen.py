#!/usr/bin/env python3
"""Execute only the committed fixed62-row cyclic training protocol."""
if not __debug__:
    raise RuntimeError("Exact-budget validation uses assertions; do not use -O")

import argparse
import csv
import fcntl
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import time

from validate_rows import validate

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BINARY = Path("/tmp/fastest-bf-cyclic-split64-screen/native/benchmark")


def require(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(commit):
    require(bool(re.fullmatch(r"[0-9a-f]{40}", commit)), "Exact source commit required")
    manifest = json.loads((HERE / "manifest.json").read_text())
    paths = {**manifest["files"], "manifest.json": sha(HERE / "manifest.json")}
    for name, expected in paths.items():
        path = (HERE / name).resolve()
        require(path.is_relative_to(HERE), "Manifest path escape")
        require(sha(path) == expected, "Archive drift: " + name)
        blob = subprocess.check_output(["git", "show", commit+":"+str(path.relative_to(ROOT))], cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest() == expected, "Uncommitted archive: " + name)
    freeze = json.loads((HERE / "FREEZE.json").read_text())
    for name, expected in freeze["source_sha256"].items():
        path = ROOT / name
        require(sha(path) == expected, "Consumed source/dependency drift: " + name)
    for name, expected in freeze["binary_sha256"].items():
        require(sha(Path(name)) == expected, "Executable drift: " + name)
    require(str(BINARY) in freeze["binary_sha256"], "Missing screen executable")
    return dict(manifest_sha256=sha(HERE/"manifest.json"), freeze_sha256=sha(HERE/"FREEZE.json"), binary_sha256=sha(BINARY))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    args = parser.parse_args()
    require(os.sched_getaffinity(0) == {3}, "CPU3-only affinity required")
    fds = []
    for path in Path("/proc/self/fd").iterdir():
        if path.exists() and path.resolve() == Path("/tmp/fastest-bf-socket1.lock"):
            fd = int(path.name)
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            fds.append(fd)
    require(fds, "Inherited socket1 exclusive lease required")
    anchor = verify(args.source_commit)
    plan_path = HERE / "validation-v1/selection.json"
    plan = json.loads(plan_path.read_text())
    require(plan["rows"] == 62 and len(plan["configurations"]) == 62, "Wrong fixed configuration count")
    require((plan["seed"],plan["batch"],plan["query_power"],plan["query_repeats"],plan["calibration_power"],plan["hit_percent"],plan["build_repeats"]) == (42,4096,22,6,24,50,0), "Changed fixed measurement dimensions")
    configs = {r["configuration_id"]: r for r in plan["configurations"]}
    require(len(configs) == 62, "Repeated effective geometry")
    out = HERE / "screen"
    out.mkdir(exist_ok=False)
    meta = dict(scope="Fixed training shortlist, not held-out confirmation", source_commit=args.source_commit,
                anchor=anchor, selection_sha256=sha(plan_path), affinity=[3], socket_lock="/tmp/fastest-bf-socket1.lock",
                inherited_lock_descriptors=fds, start_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()),
                cases=[], complete=False)
    def save():
        (out/"metadata.json").write_text(json.dumps(meta,indent=2)+"\n")
    save()
    all_rows, seen = [], set()
    for index, case in enumerate(plan["cases"]):
        require(verify(args.source_commit) == anchor, "Archive changed during matrix")
        power, budget = case["key_power"], case["budget_bpk"]
        command = [str(BINARY),str(power),str(budget),"50","22","4096","6","42",",".join(case["filters"]),str(1<<power),"24","query-only","0"]
        result = subprocess.run(command,cwd=ROOT,text=True,capture_output=True)
        stem = f"case-{index:02d}-n{power}-b{budget}"
        (out/(stem+".stdout")).write_text(result.stdout)
        (out/(stem+".stderr")).write_text(result.stderr)
        require(result.returncode == 0, "Failed case: " + stem)
        rows = list(csv.DictReader(io.StringIO(result.stdout)))
        expected = {configs[c]["filter"]:configs[c] for c in case["configuration_ids"]}
        validate(rows,expected,power=power,budget=budget,query_power=22,batch=4096,repeats=6,seed=42,calibration_power=24)
        for row in rows:
            c = expected[row["filter"]]
            require(c["configuration_id"] not in seen, "Repeated measured geometry")
            seen.add(c["configuration_id"])
            row.update(configuration_id=c["configuration_id"],calibration_identity=c["calibration_identity"])
        all_rows += rows
        with (out/"results.csv").open("w",newline="") as stream:
            writer = csv.DictWriter(stream,fieldnames=list(all_rows[0]),lineterminator="\n")
            writer.writeheader();writer.writerows(all_rows)
        meta["cases"].append(dict(case=case,command=command,rows=len(rows),stdout_sha256=sha(out/(stem+".stdout")),stderr_sha256=sha(out/(stem+".stderr"))))
        save()
        print(f"Validated {index+1}/{len(plan['cases'])} cases, {len(all_rows)}/62 rows",flush=True)
    require(seen == set(configs) and len(all_rows) == 62, "Incomplete selected matrix")
    require(verify(args.source_commit) == anchor, "Final source/binary drift")
    meta.update(complete=True,rows=len(all_rows),results_sha256=sha(out/"results.csv"),end_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()))
    save()


if __name__ == "__main__":
    main()
