#!/usr/bin/env python3
"""Fixed accuracy-only suffix audit of all eight APIs and six constructions."""
if not __debug__:
    raise RuntimeError("Do not disable row assertions with Python -O")

import argparse
import csv
import hashlib
import importlib.util
import io
import json
import math
from pathlib import Path
import re
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = HERE.parent / "2026-10-29-multiply-code-split64-screen"
PRIOR = HERE.parent / "2026-10-29-multiply-code-small-confirmation"
sys.path.insert(0, str(PARENT))
from run_screen import BINARY, verify
from validate_rows import validate
from order_oracle import source_registry, validate_order

spec = importlib.util.spec_from_file_location("fixed_confirmation_lease", PRIOR / "driver/source_guard.py")
lease_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lease_module)
require_lease = lease_module.require_lease

SEMANTICS = (
    "filter", "keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk",
    "hash_bits", "hit_percent", "present_queries", "batch", "seed", "absent_queries",
    "false_positives", "result_checksum", "input_mode", "budget_bytes", "logical_bytes",
    "geometry_kind", "unit_bytes", "unit_count", "effective_probes", "probe_policy",
    "constructor_argument", "page_level", "native_constructor_bpk", "implementation_origin",
)


def need(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def interval(fp, n):
    need(n > 0 and 0 <= fp <= n, "Invalid sample")
    p, z = fp / n, 1.959963984540054
    mid = p + z*z/(2*n)
    radius = z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))
    return max(0., (mid-radius)/(1+z*z/n)), min(1., (mid+radius)/(1+z*z/n))


def fresh_record(prefix, total, old, geometry):
    for row in (prefix, total):
        for field in SEMANTICS:
            need(row[field] == old[field], "Historical semantics differ: " + field)
    need(int(old["calibration_absent_queries"]) == int(prefix["calibration_absent_queries"]) == 1 << 24,
         "Wrong original sample size")
    need(prefix["calibration_false_positives"] == old["calibration_false_positives"], "Prefix did not reproduce")
    need(int(total["calibration_absent_queries"]) == 1 << 27, "Wrong fixed total sample size")
    first, entire = int(prefix["calibration_false_positives"]), int(total["calibration_false_positives"])
    count, fp = (1 << 27) - (1 << 24), entire-first
    lo, hi = interval(fp, count)
    old_lo, old_hi = interval(first, 1 << 24)
    return dict(filter=total["filter"], seed=int(total["seed"]), keys=int(total["keys"]),
                filter_bytes=int(total["filter_bytes"]), calibration_identity=geometry["calibration_identity"],
                historical_prefix_count=1 << 24, historical_prefix_fp=first,
                historical_wilson_lower=old_lo, historical_wilson_upper=old_hi,
                historical_pass_0_1pct=old_hi <= .001, nested_total_count=1 << 27, nested_total_fp=entire,
                fresh_suffix_count=count, fresh_suffix_fp=fp, fresh_fpr=fp/count,
                fresh_wilson_lower=lo, fresh_wilson_upper=hi, fresh_pass_0_1pct=hi <= .001)


def distinct_records(records):
    groups = {}
    for row in records:
        key = (row["calibration_identity"], row["seed"])
        sample = {k: v for k, v in row.items() if k not in ("filter", "calibration_identity")}
        need(key not in groups or sample == groups[key], "Alias sample mismatch")
        groups[key] = sample
    return len(groups)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = parser.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full source commit required")
    lease = require_lease(args.cpu)
    manifest = json.loads((HERE / "PREPARATION.json").read_text())
    own = dict(manifest["files"], **{"PREPARATION.json": sha(HERE / "PREPARATION.json")})

    def local_verify():
        for name, digest in own.items():
            path = HERE / name
            need(sha(path) == digest, "Local source drift: " + name)
            data = subprocess.check_output(["git", "show", args.source_commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)
            need(hashlib.sha256(data).hexdigest() == digest, "Uncommitted local source")
        for name, digest in manifest["inputs_sha256"].items():
            path = ROOT / name
            need(sha(path) == digest, "Historical input drift: " + name)
            data = subprocess.check_output(["git", "show", manifest["evidence_commit"] + ":" + name], cwd=ROOT)
            need(hashlib.sha256(data).hexdigest() == digest, "Uncommitted historical input")

    local_verify()
    protocol = json.loads((HERE / "protocol.json").read_text())
    prior = json.loads((PRIOR / "protocol.json").read_text())
    need(protocol["seeds"] == prior["seeds"] and protocol["filters"] == [r["filter"] for r in prior["configurations"]],
         "Selected subset differs from all eight APIs/six seeds")
    need(protocol["calibration_powers"] == [24, 27] and protocol["expected_api_rows"] == 96,
         "Changed fixed stopping rule")
    geometry = {r["filter"]: r for r in prior["configurations"]}
    need(len(geometry) == 8 and len(set(protocol["seeds"])) == 6, "Wrong fixed matrix")
    with (PRIOR / "confirmation/results.csv").open() as stream:
        selected = [r for r in csv.DictReader(stream) if int(r["batch"]) == 4096]
    old = {(r["filter"], int(r["seed"])): r for r in selected}
    need(len(old) == len(selected) == 48, "Wrong historical b4096 matrix")
    need(set(old) == {(name, seed) for name in geometry for seed in protocol["seeds"]}, "Historical matrix incomplete")
    anchor = verify(protocol["binary_source_commit"])
    parent_range = HERE.parent / "2026-10-29-exact-budget-range"
    registry = source_registry((PARENT / "adapters.hpp").read_text(),
        (parent_range / "cpp-adapters.hpp").read_text(), (parent_range / "boost-adapters.hpp").read_text(),
        (parent_range / "rocks-adapters.hpp").read_text())
    out = HERE / "results"
    out.mkdir(exist_ok=False)
    meta = dict(complete=False, performance_claim=False, source_commit=args.source_commit,
                binary_anchor=anchor, lease=lease, cases=[], start_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    save(out / "metadata.json", meta)
    records = []
    for seed in protocol["seeds"]:
        prefix = None
        for cal in protocol["calibration_powers"]:
            local_verify()
            need(require_lease(args.cpu) == lease, "Changed whole-operation lease")
            need(verify(protocol["binary_source_commit"]) == anchor, "Changed frozen binary/source")
            command = [str(BINARY), "16", "16", "50", "22", "4096", "2", str(seed),
                       ",".join(protocol["filters"]), "65536", str(cal), "query-only", "0"]
            proc = subprocess.run(command, cwd=ROOT, capture_output=True)
            stem = f"s{seed}-cal{cal}"
            stdout, stderr = out / (stem + ".stdout"), out / (stem + ".stderr")
            stdout.write_bytes(proc.stdout)
            stderr.write_bytes(proc.stderr)
            case = dict(seed=seed, calibration_power=cal, command=command, returncode=proc.returncode,
                        stdout_file=stdout.name, stderr_file=stderr.name, stdout_sha256=sha(stdout),
                        stderr_sha256=sha(stderr), validated=False)
            meta["cases"].append(case)
            save(out / "metadata.json", meta)
            need(proc.returncode == 0, "Public harness failed; raw attempt retained")
            rows = list(csv.DictReader(io.StringIO(proc.stdout.decode())))
            validate(rows, geometry, power=16, budget=16, query_power=22, batch=4096, repeats=2, seed=seed, calibration_power=cal)
            validate_order(rows, registry, protocol["filters"], 65536, 1 << 22, seed, 50)
            by_name = {r["filter"]: r for r in rows}
            for row in rows:
                ref = old[(row["filter"], seed)]
                for field in SEMANTICS:
                    need(row[field] == ref[field], "Historical construction/output differs: " + field)
                if cal == 24:
                    need(row["calibration_false_positives"] == ref["calibration_false_positives"], "Old prefix differs")
            if cal == 24:
                prefix = by_name
            else:
                records.extend(fresh_record(prefix[name], by_name[name], old[(name, seed)], geometry[name]) for name in geometry)
            case.update(validated=True, rows=len(rows))
            save(out / "metadata.json", meta)
            print(f"Validated {len(meta['cases'])}/12 accuracy cases; no timing claim", flush=True)
    local_verify()
    need(verify(protocol["binary_source_commit"]) == anchor, "Final binary/source drift")
    need(require_lease(args.cpu) == lease, "Final lease drift")
    need(len(records) == 48 and distinct_records(records) == 36, "Wrong suffix cardinality")
    save(out / "quality.json", dict(api_seed_records=records, distinct_mapping_seed_records=36, pooling=False))
    meta.update(complete=True, raw_api_rows=96, api_seed_suffix_records=48, distinct_mapping_seed_suffix_records=36,
                quality_sha256=sha(out / "quality.json"), end_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    save(out / "metadata.json", meta)
    save(out / "archive-manifest.json", dict(files={p.name: sha(p) for p in sorted(out.iterdir()) if p.is_file()}))


if __name__ == "__main__":
    main()
