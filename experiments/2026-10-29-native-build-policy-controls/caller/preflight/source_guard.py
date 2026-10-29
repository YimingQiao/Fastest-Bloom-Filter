"""Verify committed local closure, unchanged plan, and copied support sources."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess
from contract import need

HERE = Path(__file__).resolve().parent
CALLER = HERE.parent
PLAN = CALLER.parent
ROOT = PLAN.parents[1]
PLAN_COMMIT = "9f0ebb2f5b75c3be493e562024d01bbfc4a4c749"


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def blob(commit, path):
    return subprocess.check_output(["git", "show", commit + ":" + str(path)], cwd=ROOT)


def verify(commit=None):
    need(__debug__, "Python -O is forbidden")
    if commit:
        need(re.fullmatch("[0-9a-f]{40}", commit) is not None, "Full source commit required")
    result = {}
    for directory, anchor in ((PLAN, PLAN_COMMIT), (CALLER, commit)):
        manifest = directory / "PREPARATION.json"
        inventory = json.loads(manifest.read_text())["files"]
        for path in [manifest] + [directory / name for name in inventory]:
            name = str(path.relative_to(ROOT))
            if path != manifest:
                entry = inventory[str(path.relative_to(directory))]
                need(path.is_file() and not path.is_symlink() and path.stat().st_size == entry["bytes"] and sha(path) == entry["sha256"], "Frozen source drift: " + name)
            if anchor:
                need(path.read_bytes() == blob(anchor, name), "Committed source drift: " + name)
            result[name] = sha(path)
    spec = importlib.util.spec_from_file_location("four_arm_derive", CALLER / "derive.py")
    derive = importlib.util.module_from_spec(spec); spec.loader.exec_module(derive)
    expected = derive.sources()
    record = json.loads((CALLER / "DERIVATION.json").read_text())
    need(record["parent_commit"] == derive.PARENT and record["files"] == {n: hashlib.sha256(d).hexdigest() for n, d in expected.items()}, "Changed exact derivation")
    for name, data in expected.items():
        need((CALLER / name).read_bytes() == data, "Native/caller derivation drift: " + name)
    for name, item in json.loads((HERE / "SUPPORT_ORIGINS.json").read_text()).items():
        data = blob(item["commit"], item["path"])
        need(hashlib.sha256(data).hexdigest() == item["sha256"] and (HERE / name).read_bytes() == data, "Copied support drift: " + name)
    reference = json.loads((HERE / "references.json").read_text()); origin = reference["origin"]
    data = blob(origin["commit"], origin["path"])
    need(hashlib.sha256(data).hexdigest() == origin["sha256"], "Old semantic source drift")
    selected = [{k: row[k] for k in reference["fields"]} for row in json.loads(data)
                if row["seed"] == 74381 and row["scenario"] in (0, 1, 2)
                and row["requested"] == {"cpp": 4, "rust": 8}[row["language"]]]
    need(len(selected) == 12 and selected == reference["records"], "Old semantics extraction changed")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("--source-commit"); args = parser.parse_args()
    print("PASS", len(verify(args.source_commit)), "source pins; no compiler/Bloom execution")
