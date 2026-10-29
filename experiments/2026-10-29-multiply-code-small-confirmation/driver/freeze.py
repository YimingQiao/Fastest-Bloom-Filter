#!/usr/bin/env python3
"""Seal additive runner inputs without executing, compiling or calibrating a BF."""
import json

from contract import dimensions, protocol
from source_guard import COMPILED, EVIDENCE, HERE, INITIAL, STAGE, ancestry, initial, require, sha


def main():
    require(__debug__, "Run without Python -O")
    destination = HERE / "FREEZE.json"
    require(not destination.exists(), "Refuse to replace a source freeze")
    source, binaries = ancestry()
    dimensions(protocol())
    local = initial()
    for path in sorted(HERE.rglob("*")):
        if path.is_file() and "__pycache__" not in path.parts and path.name not in ("FREEZE.json", "manifest.json"):
            local[str(path.relative_to(STAGE))] = sha(path)
    destination.write_text(json.dumps(dict(scope="Additive pre-data runner; no new filter execution or compiler inputs",
                                          initial_commit=INITIAL, compiled_commit=COMPILED, evidence_commit=EVIDENCE,
                                          local_sha256=local, source_sha256=source,
                                          binary_sha256=binaries), indent=2) + "\n")
    files = dict(local, **{"driver/FREEZE.json": sha(destination)})
    (HERE / "manifest.json").write_text(json.dumps(dict(scope="Exact local pre-data archive; paths relative to confirmation directory",
                                                       files=files), indent=2) + "\n")
    print("Frozen", len(local), "local inputs,", len(source), "retained source/dependency inputs,", len(binaries), "unchanged executables")


if __name__ == "__main__":
    main()
