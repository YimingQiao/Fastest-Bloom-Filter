#!/usr/bin/env python3
"""Validate and rank the complete, frozen arbitrary-capacity training grid."""
import argparse
import csv
import hashlib
import importlib.util
import io
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_EXPERIMENT = ROOT / "experiments/2026-10-29-exact-budget-range"
ORIGINS = {"production_native", "external", "project_experiment"}
METRICS = ("lookup_ns", "hash_lookup_ns")
Z95 = 1.959963984540054


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wilson_upper(fp, count):
    require(
        isinstance(fp, int) and isinstance(count, int),
        "Integer calibration counts required",
    )
    require(count > 0 and 0 <= fp <= count, "Invalid independent calibration counts")
    if fp == count:
        return 1.0
    p = fp / count
    z2 = Z95 * Z95
    return (
        p
        + z2 / (2 * count)
        + Z95 * math.sqrt(p * (1 - p) / count + z2 / (4 * count * count))
    ) / (1 + z2 / count)


def enrich(rows):
    """Same mapping/API controls share one count record; never pool their probes."""
    unique, configurations, records = {}, set(), []
    for source in rows:
        row = dict(source)
        require(
            row["implementation_origin"] in ORIGINS, "Unknown implementation ownership"
        )
        for field in (
            "keys",
            "filter_bytes",
            "calibration_absent_queries",
            "calibration_false_positives",
            "seed",
        ):
            row[field] = int(row[field])
        require(row["keys"] > 0 and row["filter_bytes"] > 0, "Invalid payload")
        identity = (row["keys"], row["seed"], row["configuration_id"])
        require(identity not in configurations, "Repeated effective configuration")
        configurations.add(identity)
        quality_id = (row["keys"], row["seed"], row["calibration_identity"])
        sample = (
            row["calibration_absent_queries"],
            row["calibration_false_positives"],
            str(row["result_checksum"]),
            str(row["false_positives"]),
            str(row["absent_queries"]),
        )
        if quality_id in unique:
            require(
                unique[quality_id]["sample"] == sample,
                "Equivalent mappings disagree on calibration/output",
            )
        else:
            unique[quality_id] = dict(
                keys=row["keys"],
                seed=row["seed"],
                calibration_identity=row["calibration_identity"],
                sample=sample,
                members=[],
            )
        unique[quality_id]["members"].append(
            dict(
                filter=row["filter"],
                filter_bytes=row["filter_bytes"],
                implementation_origin=row["implementation_origin"],
            )
        )
        row["quality_upper"] = wilson_upper(
            row["calibration_false_positives"], row["calibration_absent_queries"]
        )
        row["observed_fpr"] = (
            row["calibration_false_positives"] / row["calibration_absent_queries"]
        )
        row["actual_bpk"] = 8 * row["filter_bytes"] / row["keys"]
        for metric in METRICS:
            value = float(row[metric])
            if metric == "lookup_ns" and row["input_mode"] == "raw_bytes":
                require(
                    math.isnan(value), "Raw-only API has a fabricated prehashed metric"
                )
                row[metric] = None
            else:
                require(math.isfinite(value) and value > 0, "Invalid query timing")
                row[metric] = value
        records.append(row)
    quality = []
    for item in unique.values():
        count, fp, checksum, mixed_fp, absent = item.pop("sample")
        item.update(
            calibration_absent_queries=count,
            calibration_false_positives=fp,
            result_checksum=checksum,
            false_positives=int(mixed_fp),
            absent_queries=int(absent),
            observed_fpr=fp / count,
            quality_upper=wilson_upper(fp, count),
        )
        quality.append(item)
    return records, quality


def eligible(row, cap, target, metric):
    # Integer backing allocation, with zero slack, governs eligibility.
    return (
        row["filter_bytes"] <= row["keys"] * cap // 8
        and row["quality_upper"] <= target
        and row[metric] is not None
    )


def fastest(rows, origins, metric):
    choices = [row for row in rows if row["implementation_origin"] in origins]
    return (
        min(
            choices,
            key=lambda r: (
                r[metric],
                r["filter_bytes"],
                r["filter"],
                r["configuration_id"],
            ),
        )
        if choices
        else None
    )


def compact(row, metric):
    if row is None:
        return None
    return {
        key: row[key]
        for key in (
            "filter",
            "implementation_origin",
            "configuration_id",
            "calibration_identity",
            "requested_bpk",
            "filter_bytes",
            "actual_bpk",
            "observed_fpr",
            "quality_upper",
        )
    } | {
        "ns_per_key": row[metric],
        "calibration_probes": row["calibration_absent_queries"],
        "calibration_false_positives": row["calibration_false_positives"],
        "trial_min_ns": float(row[metric.replace("_ns", "_min_ns")]),
        "trial_max_ns": float(row[metric.replace("_ns", "_max_ns")]),
    }


def analyze(rows, protocol):
    records, quality = enrich(rows)
    ranks, comparisons = [], []
    for keys in sorted({row["keys"] for row in records}):
        workload = [row for row in records if row["keys"] == keys]
        require(
            len({row["seed"] for row in workload}) == 1,
            "Training report cannot silently combine seeds",
        )
        for metric in METRICS:
            for cap in protocol["memory_cap_bpk"]:
                for target in protocol["quality_caps"]:
                    candidates = [
                        row for row in workload if eligible(row, cap, target, metric)
                    ]
                    external = fastest(candidates, {"external"}, metric)
                    native = fastest(candidates, {"production_native"}, metric)
                    experiment = fastest(candidates, {"project_experiment"}, metric)
                    project = fastest(
                        candidates, {"production_native", "project_experiment"}, metric
                    )
                    setting = dict(
                        keys=keys, metric=metric, memory_cap_bpk=cap, fpr_ceiling=target
                    )
                    rank = setting | {
                        "external": compact(external, metric),
                        "production_native": compact(native, metric),
                        "project_experiment": compact(experiment, metric),
                        "project_including_experiments": compact(project, metric),
                    }
                    for label, candidate in (
                        ("production", native),
                        ("experiment", experiment),
                        ("project", project),
                    ):
                        rank["external_over_" + label] = (
                            external[metric] / candidate[metric]
                            if external and candidate
                            else None
                        )
                    ranks.append(rank)
                    for row in candidates:
                        if row["implementation_origin"] == "external":
                            continue
                        ratio = external[metric] / row[metric] if external else None
                        comparisons.append(
                            setting
                            | {
                                "candidate": compact(row, metric),
                                "external": compact(external, metric),
                                "external_over_candidate": ratio,
                                "outcome": (
                                    None
                                    if ratio is None
                                    else (
                                        "win"
                                        if ratio > 1
                                        else "loss" if ratio < 1 else "tie"
                                    )
                                ),
                            }
                        )
    return dict(
        scope="One-seed training grid; no held-out or global-fastest claim",
        measured_rows=len(records),
        calibration_records=len(quality),
        quality=quality,
        rankings=ranks,
        individual_comparisons=comparisons,
        quality_rule="Pointwise upper endpoint of two-sided95 Wilson, z=1.959963984540054; no simultaneous selection guarantee",
        sample_rule="Each equivalent mapping/geometry/seed uses its existing calibration count once; distinct mappings share inputs and are not statistically independent",
        memory_rule="All measured actual backing allocations under each cap, including smaller native power-of-two allocations; zero allocation slack",
        candidate_rule="Four production native layouts and two project experiments remain separate; experiments never enter the external rival pool",
        speed_rule="Descriptive median throughput ratios; min/max are trial ranges, not confidence intervals; no construction timing in this track",
    )


def verify_runtime_record(metadata, protocol):
    lease = metadata.get("lease", {})
    require(
        lease.get("cpu") == protocol["cpu"] == 2
        and lease.get("lease") == "socket0"
        and lease.get("lock_path") == protocol["socket_lock"],
        "Recorded CPU/socket lease differs",
    )
    descriptors = lease.get("inherited_lock_descriptors")
    require(
        isinstance(descriptors, list)
        and descriptors
        and all(type(fd) is int and fd >= 0 for fd in descriptors),
        "Missing recorded inherited lock descriptor",
    )
    binary = None
    for measured in metadata["cases"]:
        command, case = measured["command"], measured["case"]
        require(isinstance(command, list) and len(command) == 16, "Malformed command")
        path = Path(command[3])
        suffix = Path(protocol["binary"]).parts
        require(
            path.is_absolute() and path.parts[-len(suffix) :] == suffix,
            "Recorded binary path differs",
        )
        if binary is None:
            binary = command[3]
        power = case["key_power"]
        expected = [
            "taskset",
            "-c",
            str(protocol["cpu"]),
            binary,
            str(power),
            str(case["budget_bpk"]),
            str(protocol["hit_percent"]),
            str(protocol["query_power"]),
            str(protocol["batch"]),
            str(protocol["query_repeats"]),
            str(protocol["seed"]),
            ",".join(case["filters"]),
            str(1 << power),
            str(protocol["calibration_power"]),
            "query-only",
            "0",
        ]
        require(command == expected, "Recorded command differs from frozen protocol")


def verify_archive(experiment, archive, verify_live=False):
    require(__debug__, "Archive guards require Python without -O")
    protocol = json.loads((experiment / "protocol.json").read_text())
    plan = json.loads((experiment / "planned-grid.json").read_text())
    freeze = json.loads((experiment / "freeze.json").read_text())
    metadata = json.loads((archive / "metadata.json").read_text())
    require(
        metadata.get("complete") is True
        and metadata.get("all_frozen_sources_and_binaries_unchanged") is True,
        "Only a complete validated matrix can be ranked",
    )
    require(
        metadata["protocol"] == protocol
        and metadata["freeze_sha256"] == sha(experiment / "freeze.json"),
        "Protocol/source freeze differs from measured run",
    )
    require(
        len(metadata["cases"]) == len(plan["cases"]) == protocol["planned_cases"],
        "Incomplete case list",
    )
    verify_runtime_record(metadata, protocol)
    if verify_live:
        for section in ("source_sha256", "binary_sha256"):
            for path, digest in freeze[section].items():
                require(
                    sha(ROOT / path) == digest, "Frozen live input differs: " + path
                )
    spec = importlib.util.spec_from_file_location(
        "exact_grid_validation", experiment / "validate_rows.py"
    )
    validation = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(validation)
    source_spec = importlib.util.spec_from_file_location(
        "exact_grid_source_guard", experiment / "source_guard.py"
    )
    source_guard = importlib.util.module_from_spec(source_spec)
    source_spec.loader.exec_module(source_guard)
    committed = source_guard.verify_commit_inputs(
        ROOT, experiment, metadata["source_commit"], freeze
    )
    require(
        committed == metadata["committed_archive"],
        "Committed archive provenance differs",
    )
    expected_records = {row["configuration_id"]: row for row in plan["configurations"]}
    require(
        len(expected_records) == len(plan["configurations"]) == protocol["unique_rows"],
        "Repeated planned configuration",
    )
    require(
        len(plan["registry"]) == protocol["registered_configurations"]
        and not plan["unsupported"],
        "Registry differs",
    )
    rows = list(csv.DictReader((archive / "results.csv").open()))
    require(len(rows) == protocol["unique_rows"], "Incomplete result rows")
    require(
        len({row["configuration_id"] for row in rows}) == len(rows),
        "Repeated result configuration",
    )
    require(
        {row["configuration_id"] for row in rows} == set(expected_records),
        "Missing/unplanned configuration",
    )
    for index, (case, measured) in enumerate(zip(plan["cases"], metadata["cases"])):
        require(case == measured["case"], "Case order differs")
        power, budget = case["key_power"], case["budget_bpk"]
        stdout = archive / f"case-{index:02d}-n{power}-b{budget}.stdout"
        require(sha(stdout) == measured["stdout_sha256"], "Case output digest differs")
        raw = list(csv.DictReader(io.StringIO(stdout.read_text())))
        selected = [
            row
            for row in rows
            if int(row["keys"]) == 1 << power and int(row["requested_bpk"]) == budget
        ]
        expected = {
            row["filter"]: row
            for row in plan["configurations"]
            if row["key_power"] == power and int(row["requested_bpk"]) == budget
        }
        require(set(expected) == set(case["filters"]), "Case plan differs")
        require(
            len(raw) == len(selected) == measured["rows"], "Case cardinality differs"
        )
        validation.validate(
            selected,
            expected,
            power=power,
            budget=budget,
            query_power=protocol["query_power"],
            batch=protocol["batch"],
            repeats=protocol["query_repeats"],
            seed=protocol["seed"],
            calibration_power=protocol["calibration_power"],
        )
        raw_by_name = {row["filter"]: row for row in raw}
        require(len(raw_by_name) == len(raw), "Duplicate raw output")
        for row in selected:
            require(
                all(
                    row[key] == value
                    for key, value in raw_by_name[row["filter"]].items()
                ),
                "Merged row differs from case output",
            )
            geometry = expected[row["filter"]]
            for field in ("configuration_id", "calibration_identity"):
                require(
                    row[field] == geometry[field], "Result geometry identity differs"
                )
    return rows, protocol, metadata


def describe(value):
    if value is None:
        return "No qualifier"
    return f"{value['filter']} ({value['actual_bpk']:.3f} bpk, {value['ns_per_key']:.3f} ns)"


def ratio_text(value):
    return "—" if value is None else f"{value:.3f}×"


def markdown(report, metadata):
    lines = [
        "# Exact-capacity external training screen",
        "",
        f"All {report['measured_rows']} planned rows completed. CPU2, 65K/32M keys, batch4096, hit50%, seed42, six balanced query repetitions and 2^24 independent negative probes per mapping. The grid adds actual backing-byte ceilings12/14/16/20/24/28/32 bpk; repeated native/Simd power-of-two capacities are measured once. CPU affinity does not impose an explicit NUMA memory policy.",
        "",
        "Four production native layouts,68 external configurations and two range-capacity project experiments remain separate. The experiments are not production releases or external rivals. Disabled construction fields are unavailable; each query measurement follows one complete validated build. All query answers and guards are checked after every timed phase.",
        "",
        "Each memory/FPR cell admits every measured fitting allocation. Eligibility uses a pointwise two-sided95 Wilson upper endpoint. Identical API/mapping counts are not pooled; the intervals do not provide simultaneous coverage after selecting among many candidates. Ratios are descriptive training results, pending fresh-seed confirmation.",
        "",
    ]
    for metric in METRICS:
        lines += [
            f"## {metric}",
            "",
            "| Keys | Cap bpk | FPR ceiling | Production native | Best external | External/native | Range experiment | External/experiment |",
            "| ---: | ---: | ---: | --- | --- | ---: | --- | ---: |",
        ]
        for row in report["rankings"]:
            if row["metric"] != metric:
                continue
            lines.append(
                f"| {row['keys']:,} | {row['memory_cap_bpk']} | {100*row['fpr_ceiling']:.2f}% | {describe(row['production_native'])} | {describe(row['external'])} | {ratio_text(row['external_over_production'])} | {describe(row['project_experiment'])} | {ratio_text(row['external_over_experiment'])} |"
            )
        lines.append("")
    lines += [
        "`summary.json` preserves every qualified individual native/experimental allocation comparison and loss, plus the quality identities and leader trial ranges. PageBloom competes only in the raw-key metric; its prehashed columns remain unavailable. This balanced query-only harness is separate from historical repeated-build, single-call and multithreaded results; elapsed values from different binaries are not merged.",
        "",
        f"Measured source commit: `{metadata['source_commit']}`. Full commands, phase orders, trial vectors, allocation geometry and source hashes remain in the archive.",
        "",
    ]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--experiment", type=Path, default=DEFAULT_EXPERIMENT)
    parser.add_argument("--archive", type=Path)
    parser.add_argument(
        "--verify-live",
        action="store_true",
        help="Also require every original build dependency and executable to remain unchanged",
    )
    args = parser.parse_args()
    experiment = args.experiment.resolve()
    archive = (args.archive or experiment / "screen").resolve()
    rows, protocol, metadata = verify_archive(experiment, archive, args.verify_live)
    report = analyze(rows, protocol)
    report["provenance"] = dict(
        source_commit=metadata["source_commit"],
        results_sha256=sha(archive / "results.csv"),
        analysis_sha256=sha(Path(__file__)),
        protocol_sha256=sha(experiment / "protocol.json"),
        freeze_sha256=sha(experiment / "freeze.json"),
        verification=(
            "committed archive plus live dependencies/binaries"
            if args.verify_live
            else "committed archive and recorded execution provenance"
        ),
    )
    (archive / "summary.json").write_text(
        json.dumps(report, indent=2, allow_nan=False) + "\n"
    )
    (archive / "RESULTS.md").write_text(markdown(report, metadata))
    print(
        f"Validated {len(rows)} rows; {len(report['rankings'])} rankings and {len(report['individual_comparisons'])} individual comparisons"
    )


if __name__ == "__main__":
    main()
