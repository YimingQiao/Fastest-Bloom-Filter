#!/usr/bin/env python3
"""Execute the fixed96 paired cases only after the separate committed freeze."""
if not __debug__:
    raise SystemExit("Python -O is forbidden before execution")
import argparse
import json
from pathlib import Path
import subprocess
import time
from screen_contract import HERE, ROOT, PLAN, need, sha, original, command, parse, tables, csv_text, audit
from freeze import PROOF, placement, verify


def dump(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--execute-frozen", action="store_true")
    args = parser.parse_args()
    need(args.execute_frozen, "Explicit frozen execution flag required")
    placed = placement()
    sources, compiled = verify(args.source_commit)
    binaries = compiled["selected_normal_executables"]
    cases = PLAN.ledger()
    protocol = json.loads((HERE / "protocol.json").read_text())
    need(protocol["cases"] == cases and protocol["proof_commit"] == PROOF, "Frozen protocol differs")
    output = HERE / "results-v1"
    need(not output.exists() and not output.is_symlink(), "Preserve all previous attempts")
    output.mkdir()
    meta = dict(complete=False, source_commit=args.source_commit, proof_commit=PROOF,
                source_sha256=sources, compiled_freeze_sha256=sha(HERE.parent / "provenance-v3/combined-proof.json"),
                protocol_sha256=sha(HERE / "protocol.json"), binaries=binaries, placement=placed,
                started_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), cases=[], counts=None)
    dump(output / "metadata.json", meta)
    records = []
    try:
        for i, case in enumerate(cases):
            argv = command(binaries[case["language"]]["path"], case, placed["lease"])
            saved = dict(case=case, command=argv, stdout=f"case-{i:03d}.stdout", stderr=f"case-{i:03d}.stderr", complete=False)
            meta["cases"].append(saved); dump(output / "metadata.json", meta)
            started = time.monotonic()
            process = subprocess.run(argv, cwd=ROOT, capture_output=True,
                                     pass_fds=tuple(placed["lease"]["inherited_lock_descriptors"]))
            for kind, data in (("stdout", process.stdout), ("stderr", process.stderr)):
                (output / saved[kind]).write_bytes(data)
                saved[kind + "_sha256"] = sha(output / saved[kind])
            saved.update(returncode=process.returncode, diagnostic_process_seconds=time.monotonic() - started)
            dump(output / "metadata.json", meta)
            need(process.returncode == 0 and not process.stderr, "Paired case failed; preserve all evidence")
            record = original.validate(parse(process.stdout.decode()), case, placed["lease"]["child_cpus"][:case["requested"]])
            records.append(record); saved["complete"] = True
            need(placement() == placed, "Placement/environment changed")
            dump(output / "metadata.json", meta)
            print(f"{i+1}/96 paired cases validated; no partial ranking", flush=True)
        counts = original.audit(records, {t: placed["lease"]["child_cpus"][:t] for t in (4, 8)})
        variants, serials = tables(records)
        (output / "variant-results.csv").write_text(csv_text(variants))
        (output / "serial-reference.csv").write_text(csv_text(serials))
        dump(output / "paired-records.json", records)
        final_sources, final_compiled = verify(args.source_commit)
        need(final_sources == sources and final_compiled == compiled and placement() == placed, "Final freeze/placement drift")
        meta.update(complete=True, counts=counts, final_frozen_inputs_equal=True,
                    finished_utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
        dump(output / "metadata.json", meta)
        observed, observed_counts = audit(output, meta, binaries, placed["lease"])
        need(observed == records and observed_counts == counts, "Final raw/aggregate reconstruction failed")
        print("PASS96 paired cases /192 variant rows /96 shared serial records; fixed plan unchanged", flush=True)
    except BaseException as error:
        meta.update(complete=False, failure=repr(error)); dump(output / "metadata.json", meta); raise


if __name__ == "__main__":
    main()
