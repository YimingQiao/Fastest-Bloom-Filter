"""Freeze complete raw208 results and offline report artifacts without timing."""
import hashlib
import json
from pathlib import Path
from summarize import EXPERIMENT, HERE, load_checked


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__:
        raise ValueError("Run without Python -O")
    rows, registry, protocol, meta = load_checked()
    screen = EXPERIMENT / "screen"
    raw = {str(path.relative_to(screen)): sha(path) for path in sorted(screen.rglob("*")) if path.is_file() and path.name != "manifest.json"}
    (screen / "manifest.json").write_text(json.dumps(dict(scope="Completed208-row same-process training screen", source_commit=meta["source_commit"], files=raw), indent=2) + "\n")
    local = {str(path.relative_to(HERE)): sha(path) for path in sorted(HERE.rglob("*")) if path.is_file() and path.name != "manifest.json" and "__pycache__" not in path.parts}
    record = dict(scope="Complete208-row sidecar; all regressions retained; no promotion", source_commit=meta["source_commit"], raw_manifest_sha256=sha(screen / "manifest.json"), files=local)
    (HERE / "manifest.json").write_text(json.dumps(record, indent=2) + "\n")
    print("Frozen", len(raw), "raw files and", len(local), "analysis artifacts")


if __name__ == "__main__":
    main()
