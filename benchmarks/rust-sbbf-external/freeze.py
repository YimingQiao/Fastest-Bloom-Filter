#!/usr/bin/env python3
"""Freeze inputs to a future approved run; never runs or changes a benchmark."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    local = list((ROOT / "src").rglob("*.rs"))
    local += [ROOT / name for name in ("Cargo.toml", "Cargo.lock", "protocol.json", "check_cli.py", "freeze.py")]
    local += list((REPO / "rust/src").rglob("*.rs"))
    local += [REPO / "rust/Cargo.toml"]
    metadata = json.loads(subprocess.check_output(
        ["cargo", "metadata", "--locked", "--offline", "--filter-platform", "x86_64-unknown-linux-gnu", "--format-version", "1", "--manifest-path", str(ROOT / "Cargo.toml")],
        cwd=REPO, text=True))
    dependencies = []
    for package in metadata["packages"]:
        if package["source"] is None:
            continue
        directory = Path(package["manifest_path"]).parent
        files = [directory / "Cargo.toml"]
        files += sorted((directory / "src").rglob("*.rs"))
        dependencies.append(dict(name=package["name"], version=package["version"],
                                 source=package["source"], directory=str(directory),
                                 sha256={str(p.relative_to(directory)): sha(p) for p in files}))
    result = dict(binary=str(args.binary.resolve()), binary_sha256=sha(args.binary),
                  source_git_commit=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(),
                  rustc=subprocess.check_output(["rustc", "-Vv"], text=True),
                  source_sha256={str(p.relative_to(REPO)): sha(p) for p in sorted(set(local))},
                  external_dependencies=dependencies, performance_run=False)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(f"Frozen {len(result['source_sha256'])} repository inputs and {len(dependencies)} external packages")


if __name__ == "__main__":
    main()
