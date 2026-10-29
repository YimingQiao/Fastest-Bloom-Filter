#!/usr/bin/env python3
"""Additional allocation-only correctness audit; no insertion/query timing."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
sys.path.insert(0, str(STAGE / "preflight"))
from checks import NAMES, NATIVE, require
from source_guard import require_lease


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    require(__debug__, "Run audit without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    args = parser.parse_args()
    require(re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Full committed source revision required")
    lease = require_lease(3)
    frozen = json.loads((HERE / "PREPARATION.json").read_text())
    inputs = dict(frozen["inputs_sha256"])
    inputs[str((HERE / "PREPARATION.json").relative_to(ROOT))] = sha(HERE / "PREPARATION.json")
    def verify_dependencies():
        for dependency in frozen["external_dependencies"]:
            for name, digest in dependency["sha256"].items():
                require(sha(Path(dependency["directory"]) / name) == digest, "Changed dependency: " + name)
    verify_dependencies()
    for name, digest in inputs.items():
        require(sha(ROOT / name) == digest, "Changed source: " + name)
        data = subprocess.check_output(["git", "show", args.source_commit + ":" + name], cwd=ROOT)
        require(hashlib.sha256(data).hexdigest() == digest, "Uncommitted source: " + name)
    out = HERE / "validation"
    out.mkdir(exist_ok=False)
    metadata = dict(complete=False, performance_run=False, scope="Allocation-only correctness; no inserts or queries", source_commit=args.source_commit, lease=lease, inputs_sha256=inputs,
                    external_dependencies=frozen["external_dependencies"], rustc=subprocess.check_output(["rustc", "-Vv"], text=True))
    target = Path("/tmp/fastest-bf-range-allocation-large")
    command = ["cargo", "run", "--quiet", "--locked", "--offline", "--release", "--manifest-path", str(HERE / "Cargo.toml")]
    env = os.environ.copy()
    env.update(CARGO_TARGET_DIR=str(target), CARGO_BUILD_JOBS="1", RUSTFLAGS="-C target-cpu=native", RUSTDOCFLAGS="")
    metadata.update(command=command, rustflags=env["RUSTFLAGS"], cargo_target_dir=str(target))
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True)
    (out / "stdout.jsonl").write_bytes(result.stdout)
    (out / "stderr.log").write_bytes(result.stderr)
    metadata["returncode"] = result.returncode
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    require(result.returncode == 0, "Additional allocation audit failed; logs retained")
    rows = [json.loads(line) for line in result.stdout.splitlines()]
    expected = {(name, n, cap) for name in NAMES for n in (1 << 16, 1 << 25) for cap in (16, 24, 32)}
    keys = [(r["filter"], r["keys"], r["budget_bpk"]) for r in rows]
    require(len(keys) == len(set(keys)) == 48 and set(keys) == expected, "Wrong allocation grid")
    for r in rows:
        actual = 16 if r["filter"] in NATIVE and r["budget_bpk"] == 24 else r["budget_bpk"]
        require(r["budget_bytes"] == r["keys"] * r["budget_bpk"] // 8, "Wrong budget")
        require(r["filter_bytes"] == r["allocated_bytes"] == r["freed_bytes"] == r["logical_bytes"] == r["keys"] * actual // 8, "Wrong actual backing")
        require(r["allocations"] == r["deallocations"] == 1 and r["constructor_deallocations"] == 0, "Wrong allocation lifetime")
        probes = -1 if r["filter"] == "ByteSplitBloomFilter" else {16: 11, 24: 17, 32: 22}[actual] if r["filter"] == "Fastbloom017" else 8
        require(r["effective_probes"] == probes, "Wrong observed constructor probe policy")
    for name, digest in inputs.items():
        require(sha(ROOT / name) == digest, "Source changed during allocation audit")
    verify_dependencies()
    binary = target / "release/allocation_dump"
    metadata.update(complete=True, rows=48, binary=str(binary), binary_sha256=sha(binary), stdout_sha256=sha(out / "stdout.jsonl"), source_after_equal=True)
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print("PASS48 actual small/large allocation observations; no throughput", flush=True)


if __name__ == "__main__":
    main()
