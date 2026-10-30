#!/usr/bin/env python3
"""Freeze or verify the isolated sources and unchanged native/public dependencies."""
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
            raise ValueError("Changed source: " + name)
    for binary in frozen["binaries"]:
        if sha(Path(binary["path"])) != binary["sha256"]:
            raise ValueError("Changed executable: " + binary["path"])
    if dependencies:
        for dep in frozen["external_dependencies"]:
            for name, expected in dep["sha256"].items():
                if sha(Path(dep["directory"]) / name) != expected:
                    raise ValueError("Changed dependency: " + dep["name"] + "/" + name)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    if args.verify:
        frozen = json.loads(FROZEN.read_text())
        verify(frozen)
        print(f"Verified {len(frozen['source_sha256'])} repository inputs, {len(frozen['external_dependencies'])} dependencies and {len(frozen['binaries'])} binaries")
        return
    base = json.loads((REPO / "benchmarks/rust-sbbf-external/validation/freeze.json").read_text())
    source = {name: expected for name, expected in base["source_sha256"].items() if name.startswith("rust/")}
    local = list((HERE / "benchmark/src").rglob("*.rs")) + list(HERE.glob("*.py"))
    local += [HERE / name for name in ("benchmark/Cargo.toml", "benchmark/Cargo.lock", "protocol.json", "registry.json", "README.md", ".gitattributes", ".gitignore")]
    source.update({str(path.relative_to(REPO)): sha(path) for path in local})
    binaries = [dict(role="final typed-symbol public API", path="/tmp/fastest-bf-rust-visible-single/release/compare_benchmark"),
                dict(role="preserved legacy-symbol preflight", path="/tmp/fastest-bf-rust-visible-single/legacy-preflight/compare_benchmark"),
                dict(role="unchanged SBBF baseline reference", path=base["binary"])]
    for binary in binaries:
        binary["sha256"] = sha(Path(binary["path"]))
    frozen = dict(base_adapter_commit="9c5820f0529efeaa37f896f6f8ce269a2e940afb",
                  native_source_reference_commit="9c5820f0529efeaa37f896f6f8ce269a2e940afb",
                  archive_parent_commit=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(),
                  rustc=subprocess.check_output(["rustc", "-Vv"], text=True),
                  compiler_flags="-C target-cpu=native -C symbol-mangling-version=v0",
                  source_sha256=dict(sorted(source.items())), external_dependencies=base["external_dependencies"],
                  binaries=binaries, performance_run=False)
    verify(frozen)
    FROZEN.write_text(json.dumps(frozen, indent=2) + "\n")
    print(f"Frozen {len(source)} repository inputs, {len(frozen['external_dependencies'])} dependencies and {len(binaries)} binaries")


if __name__ == "__main__":
    main()
