#!/usr/bin/env python3
"""Run every fixed full-load accuracy constructor once; never time queries."""
import argparse
import datetime
import json
import os
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
ROOT = PARENT.parents[1]
sys.path.insert(0, str(PARENT))
from contract import constructors, validate, check_coverage, need
from preflight import frozen, lease, sha, save

SOURCE = "81e9eb412c9b816984dc4d91b1f135daa10943ea"
PROOF = "74fa0c87bc6a644beba6131a101f1137829ef799"
PROOF_SHA = "2b664ec38ee42891aef815b9e05d5ba2237266eb12a035eed7e2bd65ac9b5cd9"


def frozen_runner(commit):
    need(re.fullmatch("[0-9a-f]{40}", commit), "Full immutable runner commit required")
    frozen(SOURCE)
    manifest = json.loads((HERE / "PREPARATION.json").read_text())
    for name, digest in {
        **manifest["files"],
        "PREPARATION.json": sha(HERE / "PREPARATION.json"),
    }.items():
        path = HERE / name
        need(sha(path) == digest, "Runner source drift")
        need(
            path.read_bytes()
            == subprocess.check_output(
                ["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT
            ),
            "Uncommitted runner",
        )
    archive = PARENT / "PREFLIGHT_ARCHIVE.json"
    need(sha(archive) == PROOF_SHA, "Proof manifest drift")
    need(
        archive.read_bytes()
        == subprocess.check_output(
            ["git", "show", PROOF + ":" + str(archive.relative_to(ROOT))], cwd=ROOT
        ),
        "Unbound proof",
    )
    for name, item in json.loads(archive.read_text())["files"].items():
        path = PARENT / name
        need(
            sha(path) == item["sha256"] and path.stat().st_size == item["bytes"],
            "Proof artifact drift",
        )
    proof = json.loads((PARENT / "PREFLIGHT_PROOF.json").read_text())
    need(proof["complete"] and proof["source_commit"] == SOURCE, "Wrong proof")
    binary = proof["binaries"]["normal"]
    need(sha(binary["path"]) == binary["sha256"], "Checked binary changed")
    ledger = json.loads((HERE / "ledger.json").read_text())
    need(ledger == constructors(), "Fixed constructor ledger changed")
    return binary, ledger


def main():
    need(__debug__, "Python -O forbidden")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = parser.parse_args()
    fds = lease(args.cpu)
    binary, ledger = frozen_runner(args.source_commit)
    overrides = (
        "LD_PRELOAD",
        "LD_LIBRARY_PATH",
        "MALLOC_CONF",
        "MALLOC_ARENA_MAX",
        "GLIBC_TUNABLES",
        "ASAN_OPTIONS",
        "UBSAN_OPTIONS",
        "RUSTFLAGS",
        "CARGO_ENCODED_RUSTFLAGS",
        "RUSTC_WRAPPER",
        "RUSTC_WORKSPACE_WRAPPER",
    )
    inherited = {name: os.environ.get(name) for name in overrides}
    need(not any(inherited.values()), "Unfrozen runtime override")
    output = PARENT / "results-v1"
    need(not output.exists() and not output.is_symlink(), "Preserve prior attempt")
    output.mkdir()
    meta = dict(
        complete=False,
        source_commit=args.source_commit,
        worker_source=SOURCE,
        proof_commit=PROOF,
        proof_sha256=PROOF_SHA,
        binary=binary,
        cpu=args.cpu,
        inherited_write_descriptors=fds,
        inherited_environment=inherited,
        started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        ledger=ledger,
        commands=[],
        throughput_timing=False,
    )

    def persist():
        save(output / "metadata.json", meta)

    persist()
    try:
        observed = []
        inputs_by_n = {}
        for index, constructor in enumerate(ledger):
            need(lease(args.cpu) == fds, "Whole-operation lease drift")
            command = [binary["path"], "--accuracy", constructor["id"]]
            record = dict(
                index=index, id=constructor["id"], command=command, complete=False
            )
            meta["commands"].append(record)
            persist()
            result = subprocess.run(
                command, cwd=ROOT, pass_fds=tuple(fds), capture_output=True
            )
            for stream, data in (("stdout", result.stdout), ("stderr", result.stderr)):
                path = output / (f"case-{index:02d}." + stream)
                path.write_bytes(data)
                record[stream] = path.name
                record[stream + "_sha256"] = sha(path)
            record["returncode"] = result.returncode
            persist()
            need(
                result.returncode == 0 and not result.stderr,
                "Preserved failed/diagnostic row",
            )
            row = json.loads(result.stdout)
            validate(row, constructor, False)
            inputs = (row["key_base"], row["inserted_checksum"], row["query_checksum"])
            need(
                inputs_by_n.setdefault(row["real_n"], inputs) == inputs,
                "Input construction drift",
            )
            observed.append(row)
            record["complete"] = True
            persist()
            print(f"{index + 1}/86 {constructor['id']} PASS", flush=True)
        check_coverage(observed)
        need(
            frozen_runner(args.source_commit) == (binary, ledger),
            "Final frozen-input drift",
        )
        need(lease(args.cpu) == fds, "Final lease drift")
        save(output / "rows.json", observed)
        meta.update(
            complete=True,
            rows=86,
            finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        )
        persist()
        files = {
            p.name: dict(sha256=sha(p), bytes=p.stat().st_size)
            for p in sorted(output.iterdir())
            if p.is_file()
        }
        save(
            output / "RAW_ARCHIVE.json",
            dict(source_commit=args.source_commit, files=files, analyzed=False),
        )
    except BaseException as error:
        meta.update(complete=False, failure=repr(error))
        persist()
        raise


if __name__ == "__main__":
    main()
