#!/usr/bin/env python3
"""Serial execution of physical-core scaling experiments, including launch/scratch costs."""
import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import time
from run_comparison import capture, numbers


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--executable", default="build/native/parallel_benchmark")
    p.add_argument("--output-dir", required=True)
    p.add_argument(
        "--cpus",
        type=numbers,
        required=True,
        help="Ordered physical cores on one socket; first T used for T workers",
    )
    p.add_argument("--threads", type=numbers, default=[1, 2, 4, 8, 16, 32])
    p.add_argument("--key-powers", type=numbers, default=[20, 24, 25])
    p.add_argument("--bits-per-key", type=int, default=16)
    p.add_argument("--hits", type=numbers, default=[50])
    p.add_argument("--seeds", type=numbers, default=[42, 43, 44])
    p.add_argument("--query-power", type=int, default=22)
    p.add_argument("--repeats", type=int, default=3)
    args = p.parse_args()
    if (
        min(args.threads) < 1
        or max(args.threads) > len(args.cpus)
        or not set(args.cpus) <= os.sched_getaffinity(0)
    ):
        p.error("provide enough allowed CPUs for the requested threads")
    exe = Path(args.executable).resolve()
    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=False)
    repo = Path(__file__).resolve().parents[1]
    metadata = {
        "arguments": vars(args),
        "revision": capture(["git", "-C", str(repo), "rev-parse", "HEAD"]),
        "status": capture(["git", "-C", str(repo), "status", "--short"]),
        "cpu": capture(["lscpu"]),
        "topology": capture(["lscpu", "-p=CPU,CORE,SOCKET,NODE"]),
        "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "executable_sha256": hashlib.sha256(exe.read_bytes()).hexdigest(),
        "rustc": capture(["rustc", "-Vv"]),
        "clang": capture(["clang++", "--version"]),
        "rust_build_fingerprints": {
            str(f): json.loads(f.read_text())
            for f in exe.parent.glob(
                ".fingerprint/fastest-bloom-filter-*/bin-parallel_benchmark.json"
            )
        },
        "runs": [],
    }
    (out / "source.patch").write_text(capture(["git", "-C", str(repo), "diff", "HEAD"]))
    flags = exe.parent / "compile_commands.json"
    if flags.exists():
        (out / "compile_commands.json").write_bytes(flags.read_bytes())
    with (out / "results.csv").open("w", newline="") as f:
        writer = None
        for kp in args.key_powers:
            for hit in args.hits:
                for threads in args.threads:
                    for seed in args.seeds:
                        cmd = [
                            "taskset",
                            "-c",
                            ",".join(map(str, args.cpus[:threads])),
                            str(exe),
                            str(kp),
                            str(args.bits_per_key),
                            str(args.query_power),
                            str(threads),
                            str(args.repeats),
                            str(seed),
                            str(hit),
                        ]
                        print(
                            f"keys=2^{kp} threads={threads} hit={hit}% seed={seed}",
                            flush=True,
                        )
                        started = time.monotonic()
                        run = subprocess.run(cmd, capture_output=True, text=True)
                        tag = f"k{kp}-t{threads}-h{hit}-s{seed}"
                        (out / (tag + ".csv")).write_text(run.stdout)
                        if run.stderr:
                            (out / (tag + ".stderr")).write_text(run.stderr)
                        metadata["runs"].append(
                            {
                                "command": cmd,
                                "seconds": time.monotonic() - started,
                                "returncode": run.returncode,
                            }
                        )
                        (out / "metadata.json").write_text(
                            json.dumps(metadata, indent=2) + "\n"
                        )
                        run.check_returncode()
                        reader = csv.DictReader(io.StringIO(run.stdout))
                        rows = list(reader)
                        if (
                            len(rows) != 3
                            or len({r["result_checksum"] for r in rows}) != 1
                        ):
                            raise RuntimeError("parallel modes disagree")
                        if writer is None:
                            writer = csv.DictWriter(f, fieldnames=reader.fieldnames)
                            writer.writeheader()
                        writer.writerows(rows)
                        f.flush()


if __name__ == "__main__":
    main()
