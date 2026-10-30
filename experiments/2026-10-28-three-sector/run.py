#!/usr/bin/env python3
"""Reproduce mask FPR screens; never overwrites a previous run directory."""
import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parent
FIELDS = "mode,requested_bpk,keys,negative_queries,seed,key_base,filter_bytes,actual_bpk,false_positives,fpr,wilson95_upper,false_negatives".split(
    ","
)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--output-dir", type=Path, required=True)
    p.add_argument("--cpu", type=int, default=3)
    p.add_argument("--compile-cpu", type=int, default=5)
    p.add_argument("--compiler", default="clang++")
    p.add_argument("--key-power", type=int, default=20)
    p.add_argument("--query-power", type=int, default=24)
    p.add_argument("--seeds", default="104729,130363,155921")
    p.add_argument("--requested-bpk", default="8")
    p.add_argument("--modes", default="0,1,2")
    args = p.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=False)
    metadata = {
        "arguments": {**vars(args), "output_dir": str(out)},
        "commands": [],
        "sources": {
            p.name: hashlib.sha256(p.read_bytes()).hexdigest()
            for p in ROOT.iterdir()
            if p.suffix in [".cpp", ".h", ".txt", ".py"]
        },
        "compiler": subprocess.check_output([args.compiler, "--version"], text=True),
        "cpu": subprocess.check_output(["lscpu"], text=True),
    }

    def run(cmd):
        metadata["commands"].append(cmd)
        return subprocess.check_output(cmd, text=True)

    generator = out / "generate"
    run(
        [
            "taskset",
            "-c",
            str(args.compile_cpu),
            args.compiler,
            "-std=c++17",
            "-O3",
            "-march=native",
            str(ROOT / "generate.cpp"),
            "-o",
            str(generator),
        ]
    )
    for bits, entries in [(2,16),(3,32),(3,64),(4,32)]:
        result = run(
            [
                "taskset",
                "-c",
                str(args.cpu),
                str(generator),
                str(bits),
                str(entries),
            ]
        )
        assert result == (ROOT / f"masks{bits}-count{entries}.txt").read_text()
    for mode in map(int, args.modes.split(",")):
        run(
            [
                "taskset",
                "-c",
                str(args.compile_cpu),
                args.compiler,
                "-std=c++17",
                "-O3",
                "-march=native",
                f"-DTHREE_MODE={mode}",
                str(ROOT / "screen.cpp"),
                "-o",
                str(out / f"screen{mode}"),
            ]
        )
    fields = FIELDS
    with (out / "screen.csv").open("w") as f:
        writer = csv.DictWriter(f, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for bpk in args.requested_bpk.split(","):
            for mode in map(int, args.modes.split(",")):
                for seed in args.seeds.split(","):
                    result = run(
                        [
                            "taskset",
                            "-c",
                            str(args.cpu),
                            str(out / f"screen{mode}"),
                            bpk,
                            seed,
                            str(args.key_power),
                            str(args.query_power),
                        ]
                    )
                    row = next(csv.DictReader(io.StringIO(result), fieldnames=FIELDS))
                    assert row["false_negatives"] == "0"
                    writer.writerow(row)
                    f.flush()
                    print(",".join(str(row[k]) for k in fields), flush=True)
    artifacts = [generator] + [out / f"screen{mode}" for mode in map(int, args.modes.split(","))]
    metadata["binaries"] = {file.name: hashlib.sha256(file.read_bytes()).hexdigest() for file in artifacts}
    for file in artifacts:
        file.unlink()
    metadata["utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")


if __name__ == "__main__":
    main()
