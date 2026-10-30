"""Immutable wrapper/native/plan and current additive-source closure."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
INITIAL = "07746e17f82e3fa48adf3bbd1f6fed00daf71514"
PLAN = "3c521886e93707468cb2b827115929831a87ef93"
NATIVE = "5fd487fe3381ce05be2ba823a6137107f4108854"
CORRECTNESS = "88baaf2ccd5c61de863ab3a618b7c4f141c03c86"


def need(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def blob(commit, path):
    return subprocess.check_output(["git", "show", commit + ":" + str(Path(path).relative_to(ROOT))], cwd=ROOT)


def exact(commit, path, want=None):
    path = Path(path)
    need(path.resolve().is_relative_to(ROOT), "Repository path escape")
    current = path.read_bytes()
    need(blob(commit, path) == current, "Committed source drift: " + str(path))
    result = hashlib.sha256(current).hexdigest()
    need(want is None or result == want, "Source hash mismatch: " + str(path))
    return result


def manifest(directory, name, commit):
    path = directory / name
    result = {str(path.relative_to(ROOT)): exact(commit, path)}
    for file, entry in json.loads(path.read_text())["files"].items():
        target = directory / file
        need(target.stat().st_size == entry["bytes"], "Recorded size mismatch")
        result[str(target.relative_to(ROOT))] = exact(commit, target, entry["sha256"])
    return result


def verify(commit=None):
    need(__debug__, "Python -O is unsupported")
    result = manifest(STAGE, "PREPARATION.json", INITIAL)
    result.update(manifest(STAGE / "confirmation-plan", "PREPARATION.json", PLAN))
    pins = json.loads((STAGE / "source-pins.json").read_text())
    need(pins["commit"] == NATIVE and len(pins["files_sha256"]) == 36, "Wrong native snapshot")
    for name, want in pins["files_sha256"].items():
        result[name] = exact(NATIVE, ROOT / name, want)
    placement = ROOT / "experiments/2026-10-29-split64-range-native-scaling/cpp/placement.hpp"
    result[str(placement.relative_to(ROOT))] = exact(NATIVE, placement)
    # Reused kernel/forwarding evidence stays committed, including all logs.
    result.update(manifest(STAGE, "PREFLIGHT_ARCHIVE.json", CORRECTNESS))
    own = HERE / "PREPARATION.json"
    if commit:
        need(re.fullmatch("[0-9a-f]{40}", commit) is not None, "Full source commit required")
        result.update(manifest(HERE, "PREPARATION.json", commit))
    else:
        for name, entry in json.loads(own.read_text())["files"].items():
            path = HERE / name
            need(sha(path) == entry["sha256"] and path.stat().st_size == entry["bytes"], "Additive source drift")
            result[str(path.relative_to(ROOT))] = entry["sha256"]
        result[str(own.relative_to(ROOT))] = sha(own)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("--source-commit")
    args = parser.parse_args()
    print("PASS", len(verify(args.source_commit)), "exact inputs; source verification only")
