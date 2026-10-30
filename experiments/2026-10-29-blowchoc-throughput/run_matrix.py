"""Execute only a committed, frozen and explicitly leased query-speed matrix."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import random
import re
import subprocess
import time

import driver
import guard

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(freeze, protocol, commit):
    if not re.fullmatch("[0-9a-f]{40}", commit):
        raise ValueError("full committed source revision required")
    for name, expected in freeze["files"].items():
        path = HERE / name
        if sha(path) != expected["sha256"]:
            raise RuntimeError("speed source changed: " + name)
        committed = subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(driver.ROOT))], cwd=driver.ROOT)
        if hashlib.sha256(committed).hexdigest() != expected["sha256"]:
            raise RuntimeError("committed speed source differs: " + name)
    if sha(driver.ROOT / protocol["native_library"]) != protocol["native_library_sha256"]:
        raise RuntimeError("native library changed")
    if sha(driver.oracle_helpers.HERE / "FREEZE.json") != protocol["heldout_accuracy_freeze_sha256"]:
        raise RuntimeError("held-out accuracy freeze changed")
    # The reused oracle helpers are executable dependencies, so check their
    # contents as well as the frozen manifest containing their hashes.
    held_freeze = json.loads((driver.oracle_helpers.HERE / "FREEZE.json").read_text())
    for name, expected in held_freeze["files"].items():
        if sha(driver.oracle_helpers.HERE / name) != expected["sha256"]:
            raise RuntimeError("held-out oracle dependency changed: " + name)
    driver.oracle_helpers.verify_freeze(json.loads((driver.oracle_helpers.HERE / "protocol.json").read_text()))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--execute-frozen", action="store_true", required=True)
    args = parser.parse_args()
    protocol = json.loads((HERE / "protocol.json").read_text())
    freeze_path = HERE / "SOURCE_FREEZE.json"
    freeze = json.loads(freeze_path.read_text())
    if os.environ.get("BF_SOCKET_LEASE") != "socket1-cpu3" or sorted(os.sched_getaffinity(0)) != [3]:
        raise RuntimeError("explicit socket1-cpu3 lease and CPU3 affinity required")
    verify(freeze, protocol, args.source_commit)
    freeze_sha = sha(freeze_path)
    committed_freeze = subprocess.check_output(["git", "show", args.source_commit + ":" + str(freeze_path.relative_to(driver.ROOT))], cwd=driver.ROOT)
    if hashlib.sha256(committed_freeze).hexdigest() != freeze_sha:
        raise RuntimeError("source freeze is not the committed artifact")
    observed_runtime = driver.oracle_helpers.runtime()
    if observed_runtime != protocol["expected_runtime"]:
        raise RuntimeError("JIT/compiler runtime settings differ from protocol")
    output = HERE / "results"
    output.mkdir(exist_ok=False)
    metadata = dict(started_utc=datetime.now(timezone.utc).isoformat(), source_commit=args.source_commit,
                    source_freeze_sha256=freeze_sha, protocol_sha256=sha(HERE / "protocol.json"),
                    native_library_sha256=protocol["native_library_sha256"], runtime=observed_runtime,
                    cpu=3, socket=1, socket_lock=protocol["lock"], complete=False, throughput_enabled=True)
    (output / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    library = driver.bridge.NativeLibrary(driver.ROOT / protocol["native_library"])
    rows, preflights = [], []
    started = time.monotonic()
    for case_index, case in enumerate(protocol["cases"]):
        inputs = driver.workload(case, protocol)
        factories, checks = driver.make_factories(case, protocol["configs"])
        preflights.extend(dict(case=case["id"], **check) for check in checks)
        ordered = list(protocol["configs"])
        random.Random(42 ^ (case_index + 1) * 0x6942a15).shuffle(ordered)
        case_rows = []
        for config in ordered:
            name = config["filter"]
            factory = factories.get(name)
            allocate = factory.allocate if factory else lambda name=name: library.allocate(name, case["keys"], case["requested_bpk"])
            row = driver.run_one(name, allocate, factory, case, protocol, inputs, measure=True)
            row = json.loads(json.dumps(row, allow_nan=False))
            guard.validate(row, config, case, protocol, True)
            row["case"] = case["id"]
            case_rows.append(row)
            print("validated", case["id"], name, flush=True)
        rows.extend(case_rows)
        (output / f"{case['id']}.json").write_text(json.dumps(dict(case=case, rows=case_rows,
            input_sha256={"raw_insert": hashlib.sha256(inputs[0].tobytes()).hexdigest(),
                          "raw_query": hashlib.sha256(inputs[1].tobytes()).hexdigest()}), indent=2, allow_nan=False) + "\n")
        del allocate, factory, factories, inputs
        driver.gc.collect()
    if len(rows) != 48 or len(preflights) != 32:
        raise RuntimeError("incomplete speed matrix")
    verify(freeze, protocol, args.source_commit)
    if sha(freeze_path) != freeze_sha:
        raise RuntimeError("source freeze changed during execution")
    metadata.update(complete=True, finished_utc=datetime.now(timezone.utc).isoformat(),
                    elapsed_seconds=time.monotonic() - started, rows=len(rows), preflights=len(preflights))
    (output / "results.json").write_text(json.dumps(dict(metadata=metadata, rows=rows, preflights=preflights), indent=2, allow_nan=False) + "\n")
    (output / "metadata.json").write_text(json.dumps(metadata, indent=2, allow_nan=False) + "\n")


if __name__ == "__main__":
    main()
