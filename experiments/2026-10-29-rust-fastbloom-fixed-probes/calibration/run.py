#!/usr/bin/env python3
"""Execute the committed112-row untimed public-K matrix once, under its lease."""
if not __debug__:
    raise RuntimeError("Use Python without -O before any filter execution")

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
sys.path.insert(0, str(STAGE / "accuracy"))
from contract import FIELDS, need, validate
from source_guard import require_lease
from quality import quality_records

COMPILED = "391b775c5c6e092230ef0954d59e802005dbcfce"
PARENT_ACCURACY = "b2c885db6f53fa0bccd84039e39bed1ce3f2a210"
PARENT_CSV = ROOT / "experiments/2026-10-29-split64-range-rust-screen/screen/results.csv"
RETAINED_FIELDS = ("language", "keys", "queries", "requested_bpk", "filter_bytes", "actual_bpk", "hash_bits",
    "hit_percent", "present_queries", "batch", "seed", "absent_queries", "false_positives", "result_checksum",
    "input_mode", "calibration_absent_queries", "calibration_false_positives", "budget_bytes", "logical_bytes",
    "geometry_kind", "unit_bytes", "unit_count", "effective_probes", "probe_policy", "constructor_argument",
    "implementation_origin", "size_contract")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def exact_blob(commit, path):
    return subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)


def retained_controls(rows):
    raw = list(csv.DictReader(io.StringIO(PARENT_CSV.read_text())))
    need(len(raw) == 120, "Wrong preserved Rust120 row count")
    controls, repeated = {}, {}
    for row in raw:
        key = (row["filter"], row["keys"], row["requested_bpk"])
        if key in repeated:
            for field in RETAINED_FIELDS:
                if field != "batch": need(row[field] == repeated[key][0][field], "Changed repeated old quality semantics")
        repeated.setdefault(key, []).append(row)
        if int(row["batch"]) == 4096: controls[key] = row
    need(len(controls) == 40 and all(int(r["batch"]) == 4096 for r in controls.values()), "Incomplete40 retained constructions")
    need(len(repeated) == 40 and all(len(values) == 3 and {int(r["batch"]) for r in values} == {1, 31, 4096}
                                   for values in repeated.values()), "Incomplete/repeated parent batch coverage")
    current = {(r["filter"], r["keys"], r["requested_bpk"]): r for r in rows}
    for key, old in controls.items():
        need(key in current, "Omitted retained public geometry")
        for field in RETAINED_FIELDS:
            need(current[key][field] == old[field], "Retained count/checksum/geometry differs: " + "/".join(key) + "/" + field)
    return 40


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, default=STAGE / "calibration-results")
    args = parser.parse_args()
    need(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full committed source required")
    lease = require_lease(3)
    prep = HERE / "PREPARATION.json"
    need(prep.read_bytes() == exact_blob(args.source_commit, prep), "Uncommitted calibration preparation")
    descriptor = json.loads(prep.read_text())
    inputs = dict(descriptor["inputs_sha256"])
    inputs.update({str((HERE / name).relative_to(ROOT)): info["sha256"] for name, info in descriptor["files"].items()})
    inputs[str(prep.relative_to(ROOT))] = sha(prep)
    for name, digest in inputs.items():
        path = ROOT / name
        need(sha(path) == digest and hashlib.sha256(exact_blob(args.source_commit, path)).hexdigest() == digest,
             "Changed/uncommitted input " + name)
    freeze_path = STAGE / "ACCURACY_COMPILED_FREEZE.json"
    need(freeze_path.read_bytes() == exact_blob(COMPILED, freeze_path), "Changed compiled freeze anchor")
    need(PARENT_CSV.read_bytes() == exact_blob(PARENT_ACCURACY, PARENT_CSV), "Changed retained accuracy data")
    freeze = json.loads(freeze_path.read_text())
    protocol = json.loads((HERE / "protocol.json").read_text())
    need(protocol["compiled_freeze_commit"] == COMPILED and protocol["retained_accuracy_commit"] == PARENT_ACCURACY,
         "Wrong immutable ancestors")
    proposal = json.loads((STAGE / "proposal.json").read_text())
    cases = proposal["cases"]
    need([(c["key_power"], c["budget_bpk"]) for c in cases] == [(n, cap) for n in [16, 25] for cap in [16, 24, 32]], "Changed fixed case grid")
    need(sum(len(c["filters"]) for c in cases) == 112, "Changed full K coverage")
    binary = Path(freeze["accuracy_executable"])

    def unchanged():
        for name, digest in inputs.items(): need(sha(ROOT / name) == digest, "Runtime source/evidence drift")
        for name, digest in freeze["preserved_source_sha256"].items(): need(sha(ROOT / name) == digest, "Compiled source drift")
        for dependency in freeze["external_dependencies"]:
            for name, digest in dependency["sha256"].items(): need(sha(Path(dependency["directory"]) / name) == digest, "Compiler dependency drift")
        for name, digest in freeze["binaries_sha256"].items(): need(sha(Path(name)) == digest, "Compiled executable drift")
        need(sha(binary) == freeze["accuracy_executable_sha256"], "Wrong selected accuracy executable")
        need(require_lease(3) == lease, "Actual inherited lease changed")

    unchanged()
    args.output.mkdir(parents=True, exist_ok=False)
    metadata = dict(complete=False, performance_run=False, source_commit=args.source_commit,
        compiled_freeze_commit=COMPILED, compiled_source_commit=freeze["compiled_source_commit"],
        retained_accuracy_commit=PARENT_ACCURACY, lease=lease, protocol=protocol,
        executable=str(binary), executable_sha256=sha(binary), input_sha256=inputs, cases=[])
    save(args.output / "metadata.json", metadata)
    rows = []
    for i, case in enumerate(cases):
        unchanged()
        command = [str(binary), str(case["key_power"]), str(case["budget_bpk"]), "22", "42", "24", ",".join(case["filters"])]
        result = subprocess.run(command, cwd=ROOT, capture_output=True)
        stdout, stderr = args.output / f"case-{i:02d}.stdout", args.output / f"case-{i:02d}.stderr"
        stdout.write_bytes(result.stdout); stderr.write_bytes(result.stderr)
        record = dict(index=i, command=command, returncode=result.returncode,
            stdout=stdout.name, stderr=stderr.name, stdout_sha256=sha(stdout), stderr_sha256=sha(stderr))
        metadata["cases"].append(record); save(args.output / "metadata.json", metadata)
        need(result.returncode == 0, "Failed accuracy case; partial evidence preserved")
        current = list(csv.DictReader(io.StringIO(result.stdout.decode())))
        validate(current, 1 << case["key_power"], case["budget_bpk"], 1 << 22, 42, 1 << 24, case["filters"])
        rows.extend(current)
        record["rows"] = len(current)
        save(args.output / "metadata.json", metadata)
        print(f"validated case{i + 1}/6: {len(current)} rows", flush=True)
    need(len(rows) == 112, "Incomplete full matrix")
    reproduced = retained_controls(rows)
    quality = quality_records(rows)
    output = args.output / "results.csv"
    with output.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=FIELDS, lineterminator="\n")
        writer.writeheader(); writer.writerows(rows)
    need(list(csv.DictReader(io.StringIO(output.read_text()))) == rows, "Aggregate changed exact raw order/values")
    rebuilt = []
    for case in metadata["cases"]:
        need(sha(args.output / case["stdout"]) == case["stdout_sha256"] and sha(args.output / case["stderr"]) == case["stderr_sha256"], "Raw archive drift")
        rebuilt.extend(csv.DictReader(io.StringIO((args.output / case["stdout"]).read_text())))
    need(rebuilt == rows, "Raw cases do not reconstruct aggregate")
    save(args.output / "quality.json", quality)
    unchanged()
    metadata.update(complete=True, rows=112, retained_semantic_reproductions=reproduced,
        known_mapping_records=110, diagnostic_groups=6, results_sha256=sha(output), quality_sha256=sha(args.output / "quality.json"))
    save(args.output / "metadata.json", metadata)
    save(args.output / "archive-manifest.json", dict(files={f.name: dict(sha256=sha(f), bytes=f.stat().st_size)
        for f in sorted(args.output.iterdir()) if f.is_file()}))
    print("Complete112 untimed API rows/110 known mapping records,40 retained reproductions; no performance claim", flush=True)


if __name__ == "__main__": main()
