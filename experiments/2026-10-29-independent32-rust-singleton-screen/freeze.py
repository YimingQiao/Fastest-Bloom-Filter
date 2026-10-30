#!/usr/bin/env python3
"""Freeze correctness evidence and executable inputs; never run a speed test."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
FROZEN = HERE / "validation/freeze.json"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(frozen, dependencies=True):
    for name, expected in frozen["source_sha256"].items():
        if sha(REPO / name) != expected:
            raise ValueError("Changed input: " + name)
    for binary in frozen["binaries"]:
        if sha(Path(binary["path"])) != binary["sha256"]:
            raise ValueError("Changed binary: " + binary["path"])
    for dependency in frozen["external_dependencies"] if dependencies else []:
        for name, expected in dependency["sha256"].items():
            if sha(Path(dependency["directory"]) / name) != expected:
                raise ValueError("Changed dependency: " + dependency["name"] + "/" + name)


def main():
    if not __debug__:
        raise ValueError("Run the freeze driver without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    if args.verify:
        frozen = json.loads(FROZEN.read_text())
        verify(frozen)
        print(f"Verified {len(frozen['source_sha256'])} inputs, {len(frozen['external_dependencies'])} external dependency sets and {len(frozen['binaries'])} binaries")
        return
    subprocess.run(["python3", str(HERE / "verify_source.py")], cwd=REPO, check=True)
    leaf_path = HERE.parent / "2026-10-29-independent32-rust-screen/validation/freeze.json"
    leaf = json.loads(leaf_path.read_text())
    native_dir = HERE.parent / "2026-10-29-independent32-native-rust"
    native = json.loads((native_dir / "FREEZE.json").read_text())
    source = {}
    for path in HERE.rglob("*"):
        if (path.is_file() and path != FROZEN
                and not set(path.relative_to(HERE).parts) & {"__pycache__", "target", "screen"}):
            source[str(path.relative_to(REPO))] = sha(path)
    # Pin the complete independent correctness archive as well as its library
    # sources. Its licenses, full-bitmap fixture and backend evidence stay fixed.
    for name, expected in native["files"].items():
        path = native_dir / name
        if sha(path) != expected["sha256"]:
            raise ValueError("Changed Independent32 archive: " + name)
        source[str(path.relative_to(REPO))] = expected["sha256"]
    for path in (native_dir / "FREEZE.json", leaf_path):
        source[str(path.relative_to(REPO))] = sha(path)
    protocol = json.loads((HERE / "protocol.json").read_text())
    binaries = [dict(role="Independent32 singleton shortcut plus eleven unchanged controls", path=protocol["binary"], sha256=protocol["binary_sha256"]),
                dict(role="frozen eleven-control reference", path=protocol["reference_binary"], sha256=protocol["reference_binary_sha256"])]
    frozen = dict(source_parent_commit=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(),
                  source_sha256=dict(sorted(source.items())), external_dependencies=leaf["external_dependencies"], binaries=binaries,
                  rustc=subprocess.check_output(["rustc", "-Vv"], text=True), compiler_flags=protocol["compiler_flags"],
                  performance_run=False, production_changed=False,
                  preparation_scope="Correctness/ASM only; separate reviewed committed-source authorization is required for the192-row screen")
    verify(frozen)
    FROZEN.write_text(json.dumps(frozen, indent=2) + "\n")
    print(f"Frozen {len(source)} inputs, {len(frozen['external_dependencies'])} external dependency sets and {len(binaries)} binaries")


if __name__ == "__main__":
    main()
