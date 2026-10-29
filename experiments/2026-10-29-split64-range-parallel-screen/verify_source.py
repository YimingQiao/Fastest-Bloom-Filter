#!/usr/bin/env python3
"""Non-compiling verification of exact reviewed transformations and source pins."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    require(__debug__, "Run guards without Python -O")
    recipes = json.loads((HERE / "derivations.json").read_text())
    for path, record in recipes.items():
        blob = subprocess.check_output(
            ["git", "show", record["revision"] + ":" + record["source"]], cwd=ROOT)
        require(sha(blob) == record["source_sha256"], "Changed original source: " + path)
        text = blob.decode()
        for change in record["replacements"]:
            require(text.count(change["old"]) == change["count"], "Ambiguous transformation: " + path)
            text = text.replace(change["old"], change["new"])
        require((HERE / path).read_bytes() == text.encode(), "Undeclared source change: " + path)

    registry = json.loads((HERE / "registry.json").read_text())
    adapter = (HERE / "adapters.hpp").read_text()
    actual = ["FastPatternBF"] + re.findall(r"ADD\((\w+), uint64_t\)", adapter)
    require(actual == registry and len(set(actual)) == 25, "Wrong registry/order")
    proposal = json.loads((HERE / "selection-proposal.json").read_text())
    expected = set(proposal["base_shortlist"]) | {"Split64RangeNative", "Boost192ClassicK11"}
    require(set(actual) == expected, "Changed fixed shortlist union")

    benchmark = (HERE / "benchmark.cpp").read_text()
    entry = recipes["benchmark.cpp"]
    original = subprocess.check_output(
        ["git", "show", entry["revision"] + ":" + entry["source"]], cwd=ROOT, text=True)
    def region(text):
        return text.split("// Warm every selected core", 1)[1].split("// Independent negative calibration", 1)[0]
    require(region(benchmark) == region(original), "Changed timed query body")
    require(recipes["executor.hpp"]["replacements"] == [], "Changed executor")
    require(recipes["placement.hpp"]["replacements"] == [], "Changed placement checks")

    for path, expected in json.loads((HERE / "dependencies.json").read_text()).items():
        require(sha((ROOT / path).read_bytes()) == expected, "Changed dependency input: " + path)
    manifest = HERE / "PREPARATION.json"
    if manifest.exists():
        for path, expected in json.loads(manifest.read_text())["files"].items():
            require(sha((HERE / path).read_bytes()) == expected, "Changed prepared artifact: " + path)
    print("PASS source-only:42 derivations,25 fixed registrations, exact executor/timed loops, dependency pins; no compiled validation")


if __name__ == "__main__":
    main()
