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
FIELDS = "bits_per_sector,requested_bpk,keys,negative_queries,seed,key_base,filter_bytes,actual_bpk,false_positives,fpr,wilson95_upper,false_negatives".split(
    ","
)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--output-dir", type=Path, required=True)
    p.add_argument("--cpu", type=int, default=3)
    p.add_argument("--compiler", default="clang++")
    p.add_argument("--key-power", type=int, default=20)
    p.add_argument("--query-power", type=int, default=24)
    p.add_argument("--seeds", default="42,43,44")
    p.add_argument("--requested-bpk", default="8,16")
    p.add_argument(
        "--entropy",
        action="store_true",
        help="Screen 32/64/128 entries with four bits per sector",
    )
    args = p.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=False)
    metadata = {
        "arguments": {**vars(args), "output_dir": str(out)},
        "commands": [],
        "sources": {
            p.name: hashlib.sha256(p.read_bytes()).hexdigest()
            for p in ROOT.iterdir()
            if p.suffix in [".cpp", ".h", ".txt"]
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
            str(args.cpu),
            args.compiler,
            "-std=c++17",
            "-O3",
            "-march=native",
            str(ROOT / "generate.cpp"),
            "-o",
            str(generator),
        ]
    )
    configs = (
        [(4, count) for count in [32, 64, 128]]
        if args.entropy
        else [(bits, 32) for bits in [4, 5, 6, 7]]
    )
    for bits, count in configs:
        masks = f"masks{bits}.txt" if count == 32 else f"masks{bits}-count{count}.txt"
        result = run(
            ["taskset", "-c", str(args.cpu), str(generator), str(bits), str(count)]
        )
        assert (
            result == (ROOT / masks).read_text()
        ), f"generator mismatch: {bits}/{count}"
        defines = [f"-DMASK_BITS={bits}", f'-DBF_DENSE_DICTIONARY="{masks}"']
        if count != 32:
            defines += ["-DENTROPY_SCREEN", f"-DMASK_COUNT={count}"]
        run(
            [
                "taskset",
                "-c",
                str(args.cpu),
                args.compiler,
                "-std=c++17",
                "-O3",
                "-march=native",
            ]
            + defines
            + [str(ROOT / "screen.cpp"), "-o", str(out / f"screen{bits}-{count}")]
        )
    fields = (["dictionary_entries"] if args.entropy else []) + FIELDS
    with (out / "screen.csv").open("w") as f:
        writer = csv.DictWriter(f, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for bpk in args.requested_bpk.split(","):
            for bits, count in configs:
                for seed in args.seeds.split(","):
                    result = run(
                        [
                            "taskset",
                            "-c",
                            str(args.cpu),
                            str(out / f"screen{bits}-{count}"),
                            bpk,
                            seed,
                            str(args.key_power),
                            str(args.query_power),
                        ]
                    )
                    row = next(csv.DictReader(io.StringIO(result), fieldnames=FIELDS))
                    assert row["false_negatives"] == "0"
                    if args.entropy:
                        row["dictionary_entries"] = count
                    writer.writerow(row)
                    f.flush()
                    print(",".join(str(row[k]) for k in fields), flush=True)
    metadata["utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    (out / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")


if __name__ == "__main__":
    main()
