#!/usr/bin/env python3
"""Six correctness builds, run under the explicitly assigned socket1 lease."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "validation"


def main():
    if os.sched_getaffinity(0) != {3}:
        raise RuntimeError("Pin the leased preflight to CPU3")
    OUT.mkdir(exist_ok=False)
    records, checksums, parity = [], {}, {}
    for isa in ("native", "avx2", "scalar"):
        for sanitize in (False, True):
            mode = isa + ("-asan" if sanitize else "")
            build = ROOT / ("build/independent32-native-cpp-" + mode)
            commands = [
                [
                    "cmake",
                    "-S",
                    str(HERE),
                    "-B",
                    str(build),
                    "-DCMAKE_CXX_COMPILER=clang++",
                    "-DINDEPENDENT_ISA=" + isa,
                    "-DINDEPENDENT_SANITIZERS=" + ("ON" if sanitize else "OFF"),
                ],
                ["cmake", "--build", str(build), "-j1"],
                [str(build / "check")],
                [str(build / "check"), "--parity"],
            ]
            for phase, command in zip(
                ("configure", "build", "check", "parity"), commands
            ):
                start = time.monotonic()
                result = subprocess.run(
                    command, cwd=ROOT, capture_output=True, text=True
                )
                (OUT / (mode + "-" + phase + ".stdout")).write_text(result.stdout)
                (OUT / (mode + "-" + phase + ".stderr")).write_text(result.stderr)
                records.append(
                    dict(
                        mode=mode,
                        phase=phase,
                        command=command,
                        returncode=result.returncode,
                        elapsed_seconds=time.monotonic() - start,
                    )
                )
                (OUT / "commands.json").write_text(json.dumps(records, indent=2) + "\n")
                if result.returncode:
                    raise RuntimeError(mode + " " + phase + " failed; logs retained")
                if phase == "check":
                    checksums[mode] = result.stdout.strip()
                if phase == "parity":
                    fixtures = [json.loads(line) for line in result.stdout.splitlines()]
                    if len(fixtures) != 9:
                        raise RuntimeError("incomplete parity fixtures")
                    parity[mode] = hashlib.sha256(result.stdout.encode()).hexdigest()
            print("Passed " + mode, flush=True)
    if len(set(checksums.values())) != 1 or len(set(parity.values())) != 1:
        raise RuntimeError("backend/sanitizer parity differs")
    summary = dict(
        scope="correctness only; no performance result",
        cpu=3,
        socket_lock="/tmp/fastest-bf-socket1.lock",
        checksums=checksums,
        parity_sha256=parity,
        all_six_modes_passed=True,
    )
    (OUT / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")


if __name__ == "__main__":
    main()
