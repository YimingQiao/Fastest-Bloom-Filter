#!/usr/bin/env python3
"""Audit and summarize the full frozen112-row accuracy matrix; no timings."""
import argparse
import csv
import hashlib
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
STAGE = ROOT / "experiments/2026-10-29-rust-fastbloom-fixed-probes"
RESULTS = STAGE / "calibration-results"
SOURCE = "1c66796121e515392cc576fb3a945bbdea286e77"
sys.path.insert(0, str(STAGE / "calibration"))
sys.path.insert(0, str(STAGE / "accuracy"))
from contract import need, validate
from quality import quality_records
spec = importlib.util.spec_from_file_location("frozen_fixed_k_calibration", STAGE / "calibration/run.py")
producer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(producer)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_csv(path, rows):
    need(rows, "Cannot write an empty evidence table")
    with path.open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader(); writer.writerows(rows)


def load():
    metadata = json.loads((RESULTS / "metadata.json").read_text())
    need(metadata["complete"] and not metadata["performance_run"] and metadata["source_commit"] == SOURCE,
         "Full committed accuracy matrix must be complete before analysis")
    need(metadata["rows"] == 112 and metadata["known_mapping_records"] == 110 and metadata["retained_semantic_reproductions"] == 40,
         "Unexpected completed matrix counts")
    for name, info in json.loads((RESULTS / "archive-manifest.json").read_text())["files"].items():
        need(sha(RESULTS / name) == info["sha256"], "Raw artifact drift")
    for name, digest in metadata["input_sha256"].items():
        path = ROOT / name
        need(sha(path) == digest, "Changed measured input " + name)
        original = subprocess.check_output(["git", "show", SOURCE + ":" + name], cwd=ROOT)
        need(hashlib.sha256(original).hexdigest() == digest, "Measured input differs from committed source")
    freeze = json.loads((STAGE / "ACCURACY_COMPILED_FREEZE.json").read_text())
    for name, digest in freeze["preserved_source_sha256"].items(): need(sha(ROOT / name) == digest, "Compiled source drift")
    for dep in freeze["external_dependencies"]:
        for name, digest in dep["sha256"].items(): need(sha(Path(dep["directory"]) / name) == digest, "Dependency drift")
    for name, digest in freeze["binaries_sha256"].items(): need(sha(Path(name)) == digest, "Binary drift")
    proposal = json.loads((STAGE / "proposal.json").read_text())
    need(len(metadata["cases"]) == len(proposal["cases"]) == 6, "Wrong raw case cardinality")
    rows = []
    for index, (actual, expected) in enumerate(zip(metadata["cases"], proposal["cases"])):
        command = [freeze["accuracy_executable"], str(expected["key_power"]), str(expected["budget_bpk"]),
                   "22", "42", "24", ",".join(expected["filters"])]
        need(actual["command"] == command and actual["returncode"] == 0 and actual["index"] == index, "Changed exact command/case order")
        need(sha(RESULTS / actual["stdout"]) == actual["stdout_sha256"] and sha(RESULTS / actual["stderr"]) == actual["stderr_sha256"], "Raw command evidence drift")
        values = list(csv.DictReader(io.StringIO((RESULTS / actual["stdout"]).read_text())))
        need(len(values) == actual["rows"], "Wrong completed case row count")
        validate(values, 1 << expected["key_power"], expected["budget_bpk"], 1 << 22, 42, 1 << 24, expected["filters"])
        rows.extend(values)
    aggregate = list(csv.DictReader(io.StringIO((RESULTS / "results.csv").read_text())))
    need(rows == aggregate and sha(RESULTS / "results.csv") == metadata["results_sha256"], "Ordered aggregate differs from exact raw rows")
    need(producer.retained_controls(rows) == 40, "Retained semantic reproduction failed")
    quality = quality_records(rows)
    # The diagnostic selector uses integer K dictionary keys in memory; JSON
    # stores object keys as strings. Compare the exact serialized data model.
    need(json.loads(json.dumps(quality)) == json.loads((RESULTS / "quality.json").read_text()) and
         sha(RESULTS / "quality.json") == metadata["quality_sha256"], "Quality/reproduction changed")
    return metadata, quality


def summarize(quality):
    records = quality["api_records"]
    fixed = [r for r in records if r["filter"].startswith("Fastbloom017K")]
    need(len(fixed) == 72, "Lost a fixed-K accuracy observation")
    result = []
    for n in [1 << 16, 1 << 25]:
        for cap in [16, 24, 32]:
            group = [r for r in fixed if r["keys"] == n and r["budget_bpk"] == cap]
            default = next(r for r in records if r["keys"] == n and r["budget_bpk"] == cap and r["filter"] == "Fastbloom017")
            native_range = next(r for r in records if r["keys"] == n and r["budget_bpk"] == cap and r["filter"] == "Split64RangeBloomFilter")
            row = dict(keys=n, actual_bpk=cap, default_K={16: 11, 24: 17, 32: 22}[cap],
                default_wilson_upper=default["wilson_upper"], range_wilson_upper=native_range["wilson_upper"])
            for label in ["1pct", "0_1pct", "0_01pct"]:
                ks = sorted(int(r["filter"].removeprefix("Fastbloom017K")) for r in group if r["pass_" + label])
                row["minimum_qualifying_K_" + label] = ks[0] if ks else "none"
                row["all_qualifying_K_" + label] = "|".join(str(k) for k in ks) or "none"
            result.append(row)
    return fixed, result


def main():
    need(__debug__, "Use Python without -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=HERE / "report")
    args = parser.parse_args()
    metadata, quality = load()
    fixed, summary = summarize(quality)
    args.output.mkdir(parents=True, exist_ok=False)
    write_csv(args.output / "all-api-quality.csv", quality["api_records"])
    write_csv(args.output / "all-fixed-K-quality.csv", fixed)
    write_csv(args.output / "quality-thresholds.csv", summary)
    mappings = [dict(r, api_labels="|".join(r["api_labels"])) for r in quality["mapping_records"]]
    write_csv(args.output / "unpooled-mapping-quality.csv", mappings)
    (args.output / "diagnostic-K-neighborhoods.json").write_text(json.dumps(quality["diagnostic_K_neighborhoods"], indent=2) + "\n")
    lines = ["# Public Fastbloom K1..12 accuracy", "",
        "All112 prespecified API/geometry rows completed. The40 retained constructions exactly reproduce the prior Rust120 counts, checksums and geometry; every one of72 fixed-K rows remains in the tables. No timing was measured.", "",
        "These are seed42 training results at both64K and32M inserted keys. Eligibility uses each row's two-sided95% Wilson upper endpoint on2^24 disjoint negative queries. Bounds are per row, not simultaneous or held-out guarantees. No samples are pooled; only the proven default16/K11 duplicate is collapsed to110 mapping records.", "",
        "The following are the smallest qualifying public K values in the complete1..12 grid. They are quality observations, not measured latency winners.", "",
        "| Keys | Actual bpk | K for1% | K for0.1% | K for0.01% | Default K | Default upper FPR | Range upper FPR |",
        "|---:|---:|---:|---:|---:|---:|---:|---:|"]
    for r in summary:
        lines.append(f'| {r["keys"]} | {r["actual_bpk"]} | {r["minimum_qualifying_K_1pct"]} | {r["minimum_qualifying_K_0_1pct"]} | {r["minimum_qualifying_K_0_01pct"]} | {r["default_K"]} | {100*r["default_wilson_upper"]:.8f}% | {100*r["range_wilson_upper"]:.8f}% |')
    lines += ["", "The old comparison used only automatic Fastbloom K11/17/22. Public fixed counts that pass the same ceiling must join the next performance comparison; the old Range/default-Fastbloom latency ratios do not establish a lead over these eligible public configurations. The original results remain unchanged.", "",
        "The minimum-K±1 function is retained as a quality-only diagnostic. The proposed next timing protocol includes all12 public K values, automatic defaults and all existing native/external controls at batches1/31/4096. That full bounded sweep avoids assuming monotonic latency and will retain failures as well as wins. No production change or speed claim follows from this accuracy matrix.", "",
        f'Raw results SHA256: `{metadata["results_sha256"]}`. Measured source: `{SOURCE}`. Compiled preflight anchor: `391b775c5c6e092230ef0954d59e802005dbcfce`. The separate audit checked every raw command, source-derived row order, committed input, dependency set and retained executable before producing this report.']
    (args.output / "REPORT.md").write_text("\n".join(lines) + "\n")
    (args.output / "audit.json").write_text(json.dumps(dict(source_commit=SOURCE, raw_results_sha256=metadata["results_sha256"],
        rows=112, retained_reproductions=40, fixed_K_rows=72, unpooled_mapping_records=110,
        threshold_summary_rows=6, diagnostic_groups=6, performance_run=False), indent=2) + "\n")
    print("PASS full112 source/raw/quality audit; preserved72 fixed-K rows and110 unpooled mappings")


if __name__ == "__main__": main()
