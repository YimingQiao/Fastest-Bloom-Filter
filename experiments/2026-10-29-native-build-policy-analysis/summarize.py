#!/usr/bin/env python3
"""Per-scenario analysis of one complete, immutable paired-policy matrix."""
import argparse
from collections import defaultdict
import csv
import hashlib
import json
from pathlib import Path
import re
import statistics
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SCREEN = ROOT / "experiments/2026-10-29-native-build-policy/confirmation/screening"
SOURCE = "22617d4ea12e93b8f4fd1c3501bf82a25a12e9de"
RAW = "5677deaed887db9066f773526388e56d48f3b4de"
ARCHIVE_SHA = "1e305eebcaece5f984e873a2875125ac2fca879866b2c65181e982cb13aa9ed6"
sys.path.insert(0, str(SCREEN))
import audit as producer_audit
from screen_contract import PLAN, need


def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def exact(commit, path):
    path = Path(path)
    need(path.read_bytes() == subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT), "Committed artifact changed")


def load(commit):
    need(commit == RAW, "Only the fixed complete raw commit is accepted")
    archive = SCREEN / "SCREEN_ARCHIVE.json"
    exact(commit, archive); need(sha(archive) == ARCHIVE_SHA, "Different raw inventory")
    descriptor = json.loads(archive.read_text())
    expected = {"results-v1/" + name for name in ("metadata.json", "variant-results.csv", "serial-reference.csv", "paired-records.json")}
    expected |= {f"results-v1/case-{i:03d}.{kind}" for i in range(96) for kind in ("stdout", "stderr")}
    need(set(descriptor["files"]) == expected and descriptor["producer_commit"] == SOURCE, "Incomplete/changed raw scope")
    need(descriptor["observed_exit_code"] == 0 and descriptor["tool_session_id"] == 64502, "Different execution attempt")
    for name, entry in descriptor["files"].items():
        path = SCREEN / name
        need(sha(path) == entry["sha256"] and path.stat().st_size == entry["bytes"], "Raw file changed")
        exact(commit, path)
    rows, counts = producer_audit.load(SOURCE, live=False)
    need(counts == descriptor["counts"], "Raw/producer counts differ")
    return rows, dict(raw_commit=commit, producer_commit=SOURCE, raw_archive_sha256=ARCHIVE_SHA,
                     raw_files=196, started_utc=descriptor["started_utc"], finished_utc=descriptor["finished_utc"])


def verify_source(commit):
    need(re.fullmatch("[0-9a-f]{40}", commit) is not None, "Full analysis source commit required")
    descriptor = HERE / "PREPARATION.json"
    exact(commit, descriptor)
    for name, entry in json.loads(descriptor.read_text())["files"].items():
        path = HERE / name
        need(path.resolve().is_relative_to(HERE) and sha(path) == entry["sha256"] and path.stat().st_size == entry["bytes"], "Analysis source changed")
        exact(commit, path)


def outcome(speedup):
    return "candidate_faster" if speedup > 1 else "candidate_slower" if speedup < 1 else "tie"


def base(case):
    keys = ("case_index", "language", "family", "scenario", "name", "bytes", "batch_n", "history_n", "hotspot", "requested", "seed")
    return dict({k: case[k] for k in keys}, policy_active=case["batch_n"] <= 65536 and case["bytes"] <= 262144)


def calculate(records):
    need(len(records) == 96, "Complete matrix required")
    pairs, serial, metrics, setup = [], [], [], []
    for case, record in zip(PLAN.ledger(), records, strict=True):
        b = base(case)
        for arm in ("serial", "control", "candidate"):
            entry = record["arms"][arm]
            values = entry["insert_prefill_setup_ns"]
            setup.append(dict(b, arm=arm, measured_setup=case["history_n"] > 0,
                              trials_absolute_ns=values, median_absolute_ns=statistics.median(values),
                              median_ns_per_old_hash=statistics.median(values) / case["history_n"] if case["history_n"] else None))
        for contract in case["contracts"]:
            times = {arm: record["arms"][arm][contract + "_ns"] for arm in ("serial", "control", "candidate")}
            medians = {arm: statistics.median(values) for arm, values in times.items()}
            for arm, values in times.items():
                entry = record["arms"][arm]
                metrics.append(dict(b, contract=contract, arm=arm, trials_absolute_ns=values,
                    median_absolute_ns=medians[arm], minimum_absolute_ns=min(values), maximum_absolute_ns=max(values),
                    median_ns_per_new_hash=medians[arm] / case["batch_n"], effective_request=entry["effective"],
                    actual_workers=entry["workers"], public_scratch_bytes=entry["scratch_bytes"], spawned_per_pass=entry["spawned_per_pass"]))
            speedup = medians["control"] / medians["candidate"]
            pairs.append(dict(b, contract=contract, control_absolute_ns=medians["control"], candidate_absolute_ns=medians["candidate"],
                control_ns_per_new_hash=medians["control"] / case["batch_n"], candidate_ns_per_new_hash=medians["candidate"] / case["batch_n"],
                control_over_candidate_speedup=speedup, candidate_over_control_latency=1 / speedup,
                outcome=outcome(speedup), control_trials_absolute_ns=times["control"], candidate_trials_absolute_ns=times["candidate"],
                matched_repeat_speedups=[a / b for a, b in zip(times["control"], times["candidate"], strict=True)],
                control_workers=record["arms"]["control"]["workers"], candidate_workers=record["arms"]["candidate"]["workers"],
                control_scratch_bytes=record["arms"]["control"]["scratch_bytes"], candidate_scratch_bytes=record["arms"]["candidate"]["scratch_bytes"]))
            for arm in ("control", "candidate"):
                ratio = medians[arm] / medians["serial"]
                serial.append(dict(b, contract=contract, arm=arm, serial_reference_case_index=case["case_index"],
                    serial_trials_absolute_ns=times["serial"], arm_trials_absolute_ns=times[arm],
                    serial_ns_per_new_hash=medians["serial"] / case["batch_n"], arm_ns_per_new_hash=medians[arm] / case["batch_n"],
                    arm_over_serial_latency=ratio, serial_over_arm_speedup=1 / ratio,
                    outcome="slower_than_serial" if ratio > 1 else "faster_than_serial" if ratio < 1 else "tie"))
    need((len(pairs), len(serial), len(metrics), len(setup)) == (160, 320, 480, 288), "Analysis scope changed")
    need(sum(p["policy_active"] for p in pairs) == 48, "Active-gate scope changed")
    groups = defaultdict(list)
    for pair in pairs:
        key = tuple(pair[k] for k in ("language", "family", "scenario", "requested", "contract"))
        groups[key].append(pair)
    ranges = []
    for key, values in sorted(groups.items()):
        need(len(values) == 2 and {v["seed"] for v in values} == set(PLAN.SEEDS), "Missing fixed fresh seed")
        values.sort(key=lambda v: v["seed"])
        ranges.append(dict(zip(("language", "family", "scenario", "requested", "contract"), key),
            name=values[0]["name"], policy_active=values[0]["policy_active"],
            seed_results=[dict(seed=v["seed"], speedup=v["control_over_candidate_speedup"], outcome=v["outcome"]) for v in values],
            minimum_seed_speedup=min(v["control_over_candidate_speedup"] for v in values),
            maximum_seed_speedup=max(v["control_over_candidate_speedup"] for v in values),
            all_seeds_faster=all(v["outcome"] == "candidate_faster" for v in values),
            any_seed_slower=any(v["outcome"] == "candidate_slower" for v in values)))
    need(len(ranges) == 80, "Wrong exact-geometry seed range count")
    return dict(pairs=pairs, serial=serial, metrics=metrics, setup=setup, ranges=ranges,
                losses=[dict(kind="candidate_control", **p) for p in pairs if p["outcome"] == "candidate_slower"] +
                       [dict(kind="serial_reference", **p) for p in serial if p["outcome"] == "slower_than_serial"])


def write_csv(path, rows):
    with path.open("w", newline="") as stream:
        fields = list(dict.fromkeys(k for row in rows for k in row))
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows({k: json.dumps(v, separators=(",", ":")) if isinstance(v, (list, dict)) else v for k, v in row.items()} for row in rows)


def report(result, provenance):
    text = ["# Fixed bounded-build confirmation", "",
        "The one unchanged policy uses one build worker only when the current batch has at most65,536 hashes and the actual bitmap has at most256KiB. This report retains each family/scenario/request/seed separately. Query code and query performance are outside this comparison.", "",
        "Both languages used fresh seeds74381/164321, requested4/8 and the six fixed scenarios. Each comparison is paired within one process with C/P ABBA positions; serial is first/last only. Serial-reference overhead is in serial-overhead.csv, not silently included twice. Populated allocation+build remains unavailable. Setup costs are separate diagnostics.", "",
        "The following ranges contain the two individual seed ratios for exactly the indicated language/family/scenario/T/contract. They are not confidence intervals, pooled scenarios or independent statistical wins. Ratio is control/candidate: above1 favors the bounded candidate. Every individual loss and all trial vectors remain in the CSV files.", ""]
    for active, heading in ((True, "Inside the fixed policy gate"), (False, "Unchanged-policy controls outside the gate")):
        text += ["## " + heading, "", "| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |", "|---|---|---|---:|---|---:|---:|"]
        for row in result["ranges"]:
            if row["policy_active"] != active:
                continue
            a, b = row["seed_results"]
            text.append(f'| {row["language"]} | {row["family"]} | {row["name"]} | {row["requested"]} | {row["contract"]} | {a["speedup"]:.4f}× | {b["speedup"]:.4f}× |')
        text += [""]
    text += ["## Interpretation boundary", "",
        "This archive does not automatically promote a policy. Inside-gate benefit and all outside-gate regressions must be considered together, including direct-serial overhead. Outside-gate calls have the same native worker request, so any measured differences there are caller/code-generation or measurement effects, not a newly different partition algorithm. No threshold or extra case is chosen from these results.", "",
        "Only Split64 and Split64Range were tested. Integration must leave Four/Byte shared helpers and every query request unchanged, use current insertion length rather than constructor realN, keep build-worker/scratch getters consistent, and preserve each language's automatic0 behavior outside the gate. A production port can change code generation and still requires an appropriately scoped native check.", "",
        f'Raw commit `{provenance["raw_commit"]}`; timed source `{provenance["producer_commit"]}`. Complete196-file raw/source audit precedes analysis. No additional compiler or Bloom run occurred.', ""]
    return "\n".join(text)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--raw-commit", required=True)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    need(not args.output.exists() and not args.output.is_symlink(), "Preserve earlier reports")
    verify_source(args.source_commit)
    records, provenance = load(args.raw_commit)
    provenance.update(analysis_source_commit=args.source_commit, analysis_preparation_sha256=sha(HERE / "PREPARATION.json"))
    result = calculate(records)
    args.output.mkdir(parents=True)
    for key, filename in (("pairs", "paired-ratios.csv"), ("serial", "serial-overhead.csv"),
                          ("metrics", "primary-metrics.csv"), ("setup", "prefill-setup.csv"),
                          ("ranges", "exact-geometry-seed-ranges.csv"), ("losses", "all-losses.csv")):
        write_csv(args.output / filename, result[key])
    (args.output / "summary.json").write_text(json.dumps(dict(provenance=provenance, **result), indent=2, allow_nan=False) + "\n")
    (args.output / "REPORT.md").write_text(report(result, provenance))
    print("PASS160 paired contracts /320 serial comparisons /480 metrics /80 exact-geometry seed ranges; no scenario pooling")


if __name__ == "__main__": main()
