#!/usr/bin/env python3
"""Hash source/protocol inputs before the initial screen; never execute filters."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent


def main():
    protocol = json.loads((HERE / "protocol.json").read_text())
    adapter = json.loads((HERE / "adapter-freeze.json").read_text())
    binary = Path(protocol["binary"])
    if hashlib.sha256(binary.read_bytes()).hexdigest() != protocol["binary_sha256"]:
        raise ValueError("Frozen binary differs")
    for name, expected in adapter["source_sha256"].items():
        if hashlib.sha256((REPO / name).read_bytes()).hexdigest() != expected:
            raise ValueError("Changed adapter/native source: " + name)
    names = ["README.md", "protocol.json", "registry.json", "adapter-freeze.json", "run.py", "guard.py", "test_guard.py", "summarize.py", "prepare_freeze.py", ".gitignore", ".gitattributes"]
    result = dict(adapter_commit=protocol["adapter_commit"],
                  repository_head_at_freeze=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(),
                  screen_source_sha256={name: hashlib.sha256((HERE / name).read_bytes()).hexdigest() for name in names},
                  no_performance_data_consumed=True)
    (HERE / "freeze.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"Frozen {len(names)} screen inputs; no filter executed")


if __name__ == "__main__":
    main()
