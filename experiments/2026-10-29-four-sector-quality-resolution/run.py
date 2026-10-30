#!/usr/bin/env python3
"""Four fixed public-harness runs; report only the fresh calibration suffix."""
import argparse
import csv
import hashlib
import io
import json
import math
import os
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = HERE.parent / "2026-10-29-multiply-code-split64-screen"
sys.path.insert(0, str(SOURCE))
from run_screen import BINARY, verify
from validate_rows import validate
from source_guard import require_lease


def need(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def interval(fp, n):
    need(n > 0 and 0 <= fp <= n, "Invalid fresh sample")
    p, z = fp / n, 1.959963984540054
    mid = p + z*z/(2*n)
    radius = z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))
    return max(0., (mid-radius)/(1+z*z/n)), min(1., (mid+radius)/(1+z*z/n))


def main():
    need(__debug__, "Run without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    args = parser.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full local source commit required")
    lease = require_lease(3)
    manifest = json.loads((HERE / "PREPARATION.json").read_text())
    own = dict(manifest["files"], **{"PREPARATION.json": sha(HERE / "PREPARATION.json")})
    for name, digest in own.items():
        path = HERE / name
        need(sha(path) == digest, "Changed local protocol: " + name)
        data = subprocess.check_output(["git", "show", args.source_commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)
        need(hashlib.sha256(data).hexdigest() == digest, "Uncommitted local protocol")
    for name, digest in manifest["inputs_sha256"].items():
        need(sha(ROOT / name) == digest, "Changed historical input")
    protocol = json.loads((HERE / "protocol.json").read_text())
    anchor = verify(protocol["binary_source_commit"])
    with (ROOT / protocol["historical_results"]).open() as stream:
        old = [r for r in csv.DictReader(stream) if r["filter"] == "FourSectorBloomFilter"
               and int(r["seed"]) == protocol["seed"] and float(r["actual_bpk"]) == 16]
    need(len(old) == 2 and {int(r["keys"]) for r in old} == {1 << 16, 1 << 25}, "Wrong historical construction pair")
    need(all(int(r["calibration_absent_queries"]) == 1 << 24 for r in old), "Historical prefix must contain exactly2^24 negatives")
    old = {int(r["keys"]): r for r in old}
    out = HERE / "results"
    out.mkdir(exist_ok=False)
    metadata = dict(complete=False, performance_claim=False, source_commit=args.source_commit,
                    binary_anchor=anchor, lease=lease, affinity=sorted(os.sched_getaffinity(0)),
                    numa_policy="CPU3 affinity only; no explicit NUMA memory binding", cases=[])
    def save():
        (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    save()
    compared = ("filter", "keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk",
                "hash_bits", "hit_percent", "present_queries", "batch", "seed", "absent_queries",
                "false_positives", "result_checksum", "input_mode", "budget_bytes", "logical_bytes",
                "geometry_kind", "unit_bytes", "unit_count", "effective_probes", "probe_policy",
                "constructor_argument", "page_level", "native_constructor_bpk", "implementation_origin")
    records = []
    for power in (16, 25):
        prefix = None
        geometry = protocol["configurations"][str(power)]
        for cal in (24, 27):
            need(verify(protocol["binary_source_commit"]) == anchor, "Changed measured binary/source")
            command = [str(BINARY), str(power), "16", "50", "22", "4096", "2", str(protocol["seed"]),
                       "FourSectorBloomFilter", str(1 << power), str(cal), "query-only", "0"]
            proc = subprocess.run(command, cwd=ROOT, capture_output=True)
            stem = f"n{power}-cal{cal}"
            (out / (stem + ".stdout")).write_bytes(proc.stdout)
            (out / (stem + ".stderr")).write_bytes(proc.stderr)
            metadata["cases"].append(dict(command=command, returncode=proc.returncode,
                stdout_sha256=sha(out / (stem + ".stdout")), stderr_sha256=sha(out / (stem + ".stderr"))))
            save()
            need(proc.returncode == 0, "Public harness failed; logs preserved")
            rows = list(csv.DictReader(io.StringIO(proc.stdout.decode())))
            validate(rows, {"FourSectorBloomFilter": geometry}, power=power, budget=16,
                     query_power=22, batch=4096, repeats=2, seed=protocol["seed"], calibration_power=cal)
            need(len(rows) == 1, "Wrong case cardinality")
            r = rows[0]
            for field in compared:
                need(r[field] == old[1 << power][field], "Historical construction/output differs: " + field)
            if cal == 24:
                need(r["calibration_false_positives"] == old[1 << power]["calibration_false_positives"], "Old prefix does not reproduce")
                prefix = r
            else:
                fp = int(r["calibration_false_positives"]) - int(prefix["calibration_false_positives"])
                count = (1 << 27) - (1 << 24)
                lo, hi = interval(fp, count)
                records.append(dict(keys=1 << power, filter_bytes=int(r["filter_bytes"]), seed=protocol["seed"],
                    historical_prefix_count=1 << 24, historical_prefix_fp=int(prefix["calibration_false_positives"]),
                    nested_total_count=1 << 27, nested_total_fp=int(r["calibration_false_positives"]),
                    fresh_suffix_count=count, fresh_suffix_fp=fp, fresh_fpr=fp/count,
                    fresh_wilson_lower=lo, fresh_wilson_upper=hi, fresh_pass_0_1pct=hi <= .001))
            need(verify(protocol["binary_source_commit"]) == anchor, "Source drift after case")
    for name, digest in own.items():
        need(sha(HERE / name) == digest, "Changed local protocol after run")
    for name, digest in manifest["inputs_sha256"].items():
        need(sha(ROOT / name) == digest, "Changed historical input after run")
    metadata.update(complete=True, rows=4, fresh_records=records)
    save()
    print(json.dumps(records, indent=2))


if __name__ == "__main__":
    main()
