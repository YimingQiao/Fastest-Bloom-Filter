"""Fixed96 pairs; one shared serial record, no duplicated serial samples."""
import csv
import io
import json
from pathlib import Path
import statistics
import sys

HERE = Path(__file__).resolve().parent
PRODUCER = HERE.parent / "proof"
sys.path.insert(0, str(PRODUCER))
import contract as original
import preflight
from source_guard import ROOT, sha

need = original.need
PLAN = original.plan
PAIR_FIELDS = ("case_index", "language", "family", "scenario", "name", "bytes", "batch_n", "history_n", "hotspot", "requested", "seed", "input_base")


def command(binary, case, lease):
    return preflight.command(binary, case, lease, "--measure")


def parse(text):
    def unique(pairs):
        result = {}
        for key, value in pairs:
            need(key not in result, "Duplicate JSON field")
            result[key] = value
        return result
    value = json.loads(text, object_pairs_hook=unique)
    need(isinstance(value, dict), "Expected one paired JSON object")
    return value


def base_fields(case, record):
    result = {key: case[key] for key in PAIR_FIELDS}
    result.update(query_n=record["query_n"], result_checksum=record["checksum"],
                  positives=record["positives"], batch_checksum=record["batch_checksum"], query_checksum=record["query_checksum"],
                  cpus="|".join(map(str, record["cpus"])), scheduler=record["scheduler"],
                  input_mode="prehashed64", repeats=4, phase_order=record["phase_order"],
                  allocation_available=case["history_n"] == 0,
                  constructor_real_n=case["bytes"] // 2 if case["family"] == "Split64" else "",
                  constructor_requested_bpk=8 if case["family"] == "Split64" else "")
    return result


def metrics(entry, case):
    result = {}
    for name in ("insert", "allocate_insert"):
        values = entry[name + "_ns"]
        result[name + "_trials_absolute_ns"] = json.dumps(values, separators=(",", ":"))
        for suffix, function in (("median_absolute_ns", statistics.median), ("min_absolute_ns", min), ("max_absolute_ns", max)):
            result[name + "_" + suffix] = function(values) if values else ""
        result[name + "_median_ns_per_new_hash"] = statistics.median(values) / case["batch_n"] if values else ""
    setup = entry["insert_prefill_setup_ns"]
    result["prefill_setup_trials_absolute_ns"] = json.dumps(setup, separators=(",", ":"))
    result["prefill_setup_median_absolute_ns"] = statistics.median(setup)
    return result


def tables(records):
    cases = PLAN.ledger()
    need(len(records) == len(cases), "Incomplete pair table")
    variants, serials = [], []
    for case, record in zip(cases, records, strict=True):
        base = base_fields(case, record)
        serials.append(dict(base, arm="serial", **record_stats(record["arms"]["serial"]),
                            **metrics(record["arms"]["serial"], case)))
        for arm in ("control", "candidate"):
            entry = record["arms"][arm]
            variants.append(dict(base, arm=arm, serial_reference_case_index=case["case_index"],
                                 **record_stats(entry), **metrics(entry, case)))
    need(len(variants) == 192 and len(serials) == 96, "Duplicated/missing serial or variant samples")
    return variants, serials


def record_stats(entry):
    return {key: entry[key] for key in ("effective", "workers", "scratch_bytes", "spawned_per_pass")}


def csv_text(rows):
    stream = io.StringIO(newline="")
    writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
    writer.writeheader(); writer.writerows(rows)
    return stream.getvalue()


def audit(output, metadata, binaries, lease):
    cases = PLAN.ledger()
    need(metadata["complete"] is True and isinstance(metadata["cases"], list), "Final metadata lacks a complete list ledger")
    need(len(metadata["cases"]) == len(cases), "Wrong complete case count")
    records = []
    inventory = {"metadata.json", "variant-results.csv", "serial-reference.csv", "paired-records.json"}
    for i, (case, saved) in enumerate(zip(cases, metadata["cases"], strict=True)):
        need(saved["case"] == case and saved["complete"] is True and saved["returncode"] == 0, "Changed/failed case ledger")
        need(saved["command"] == command(binaries[case["language"]]["path"], case, lease), "Changed actual command")
        for kind in ("stdout", "stderr"):
            name = f"case-{i:03d}.{kind}"
            need(saved[kind] == name and sha(output / name) == saved[kind + "_sha256"], "Changed raw case")
            inventory.add(name)
        need(not (output / saved["stderr"]).read_bytes(), "Unexpected native diagnostic")
        records.append(parse((output / saved["stdout"]).read_text()))
    counts = original.audit(records, {t: lease["child_cpus"][:t] for t in (4, 8)})
    need(metadata["counts"] == counts, "Wrong final nested counts")
    need(json.loads((output / "paired-records.json").read_text()) == records, "Raw/paired aggregate mismatch")
    variants, serials = tables(records)
    need((output / "variant-results.csv").read_text() == csv_text(variants), "Raw/variant aggregate mismatch")
    need((output / "serial-reference.csv").read_text() == csv_text(serials), "Raw/serial aggregate mismatch")
    need({p.name for p in output.iterdir() if p.is_file()} == inventory, "Unexpected raw inventory")
    return records, counts
