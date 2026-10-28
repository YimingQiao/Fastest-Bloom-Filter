#!/usr/bin/env python3
"""Correctness and assembly only; does not launch calibration or timing."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "validation-v1"
BUILD = Path("/tmp/fastest-bf-cyclic-split64")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__ or os.sched_getaffinity(0) != {2}:
        raise RuntimeError("Expected normal Python and CPU2-only affinity")
    descriptors = [p for p in Path("/proc/self/fd").iterdir()
                   if p.exists() and p.resolve() == Path("/tmp/fastest-bf-socket0.lock")]
    if not descriptors or subprocess.run(["flock", "-xn", "/tmp/fastest-bf-socket0.lock", "true"]).returncode != 1:
        raise RuntimeError("Require inherited whole-operation socket0 lease")
    OUT.mkdir(exist_ok=False)
    inputs = {str(p.relative_to(ROOT)): sha(p) for p in HERE.rglob("*") if p.is_file()
              and not any(part.startswith("validation-") or part == "__pycache__" for part in p.relative_to(HERE).parts)}
    provenance = json.loads((HERE / "provenance.json").read_text())
    for name, expected in provenance["parents_sha256"].items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Parent source drift: " + name)
        inputs[name] = expected
    (OUT / "inputs.json").write_text(json.dumps(inputs, indent=2) + "\n")
    records, binaries, reference = [], {}, None

    def run(name, command):
        start = time.monotonic()
        with (OUT / (name + ".stdout")).open("wb") as stdout, (OUT / (name + ".stderr")).open("wb") as stderr:
            proc = subprocess.run([str(x) for x in command], cwd=ROOT, stdout=stdout, stderr=stderr)
        records.append(dict(name=name, command=[str(x) for x in command], returncode=proc.returncode, seconds=time.monotonic()-start))
        (OUT / "commands.json").write_text(json.dumps(records, indent=2) + "\n")
        print(name, proc.returncode, flush=True)
        if proc.returncode:
            raise RuntimeError(name + " failed; logs retained")

    for mode in ("native", "avx2", "scalar"):
        for sanitizer in (False, True):
            tag = mode + ("-asan" if sanitizer else "")
            build = BUILD / tag
            run(tag + "-configure", ["cmake", "-S", HERE, "-B", build, "-DCMAKE_CXX_COMPILER=clang++",
                                     "-DCYCLIC_ISA="+mode, "-DCYCLIC_SANITIZERS="+("ON" if sanitizer else "OFF")])
            run(tag + "-build", ["cmake", "--build", build, "-j1"])
            run(tag + "-check", [build / "check"])
            output = (OUT / (tag + "-check.stdout")).read_bytes()
            if reference is None:
                reference = output
            if output != reference:
                raise RuntimeError("Backend checksum disagreement")
            for name in ("check", "calibrate"):
                binaries[str(build / name)] = sha(build / name)
            shutil.copy2(build / "compile_commands.json", OUT / (tag + "-compile_commands.json"))
    run("native-assembly", ["objdump", "-Cd", BUILD / "native/calibrate"])
    run("compiler", ["clang++", "--version"])
    for name, expected in inputs.items():
        if sha(ROOT / name) != expected:
            raise RuntimeError("Source drift during preflight: " + name)
    (OUT / "summary.json").write_text(json.dumps(dict(scope="Correctness only, no calibration or timing",
        inputs_sha256=inputs, binary_sha256=binaries, checksum_output=reference.decode(), affinity=[2],
        lease="/tmp/fastest-bf-socket0.lock"), indent=2) + "\n")


if __name__ == "__main__":
    main()
