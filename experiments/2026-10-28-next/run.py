#!/usr/bin/env python3
"""Run the confirmed exact-layout tail comparison (compile build/probe6 first)."""
import argparse
import csv
import io
import subprocess
from pathlib import Path

p = argparse.ArgumentParser(description=__doc__)
p.add_argument("--executable", default="build/probe6")
p.add_argument("--cpu", type=int, default=3)
p.add_argument("--output", required=True)
args = p.parse_args()
with Path(args.output).open("x", newline="") as out:
    writer = csv.writer(out, lineterminator="\n")
    writer.writerow(
        [
            "candidate",
            "keys",
            "requested_bpk",
            "hit_percent",
            "batch",
            "seed",
            "reference_ns",
            "candidate_ns",
            "speedup",
        ]
    )
    for seed in [42, 43, 44]:
        for power in [12, 20, 24]:
            for hit in [0, 50, 100]:
                for batch in [8, 15, 31, 4096]:
                    command = [
                        "taskset",
                        "-c",
                        str(args.cpu),
                        args.executable,
                        str(power),
                        "8",
                        str(hit),
                        str(batch),
                        str(seed),
                    ]
                    result = subprocess.run(
                        command, check=True, capture_output=True, text=True
                    )
                    writer.writerows(csv.reader(io.StringIO(result.stdout)))
                    out.flush()
