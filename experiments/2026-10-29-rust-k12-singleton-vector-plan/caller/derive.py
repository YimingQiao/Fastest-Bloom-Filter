#!/usr/bin/env python3
"""Copy two exact native crates; generate source only, never invoke Cargo."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
NATIVE = "ba5530a4fc38930a9da4593f2a8af7d1de3c853a"
PROPOSAL = "5ac4b63414d94f63b7f61304c09b7eb8d0459f0e"
PREFIX = HERE.parent.relative_to(ROOT).as_posix()
TEST_APPEND = '\n#[cfg(test)]\n#[path = "simd_singleton_focused.rs"]\nmod simd_singleton_focused;\n'


def blob(commit, path):
    return subprocess.check_output(["git", "show", f"{commit}:{path}"], cwd=ROOT)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def derive():
    paths = subprocess.check_output(["git", "ls-tree", "-r", "--name-only", NATIVE, "rust"], cwd=ROOT).decode().splitlines()
    # Include the complete library module/test closure, not old benchmark bins.
    paths = [p for p in paths if (p.startswith("rust/src/") and "/bin/" not in p)
             or p in ("rust/Cargo.toml", "rust/LICENSE-MIT", "rust/LICENSE-APACHE", "rust/NOTICE")]
    originals = {p: blob(NATIVE, p) for p in paths}
    assert originals["rust/src/four_sector_range12.rs"] == blob(PROPOSAL, PREFIX + "/control.rs")
    outputs, provenance = {}, {}
    tests = (HERE / "focused.rs").read_bytes()
    for arm in ("control", "candidate"):
        for path, data in originals.items():
            local = f"{arm}/" + path.removeprefix("rust/")
            reason = "exact native blob"
            if path == "rust/Cargo.toml":
                data = data.replace(b'name = "fastest-bloom-filter"', f'name = "k12-simd-{arm}"'.encode(), 1)
                data = data.replace(b'name = "fastest_bloom_filter"', f'name = "{arm}_native"'.encode(), 1)
                reason = "package/library name isolation only"
            elif path == "rust/src/four_sector_range12.rs":
                data = blob(PROPOSAL, PREFIX + f"/{arm}.rs") + TEST_APPEND.encode()
                reason = "exact committed arm plus cfg(test)-only focused module"
            outputs[local] = data
            provenance[local] = {"native_path": path, "native_sha256": digest(originals[path]),
                                 "sha256": digest(data), "change": reason}
        local = f"{arm}/src/simd_singleton_focused.rs"
        outputs[local] = tests
        provenance[local] = {"authored_test": "focused.rs", "sha256": digest(tests)}
    manifest = {"native_commit": NATIVE, "proposal_commit": PROPOSAL,
                "status": "source preparation only; no compiler/BF", "files": provenance}
    return outputs, (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    outputs, manifest = derive()
    outputs["DERIVED.json"] = manifest
    for name, data in outputs.items():
        path = HERE / name
        if args.write:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        elif path.read_bytes() != data:
            raise ValueError("derived source differs: " + name)
    print(json.dumps({"derived_files": len(outputs) - 1, "status": "source-only"}))


if __name__ == "__main__":
    main()
