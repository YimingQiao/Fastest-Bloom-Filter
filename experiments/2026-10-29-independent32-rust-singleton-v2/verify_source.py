#!/usr/bin/env python3
"""Verify three isolated source modules and one annotation delta; no compilation."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    require(__debug__, "Run source verification without Python -O")
    provenance = json.loads((HERE / "provenance.json").read_text())
    for path, digest in provenance["inputs_sha256"].items():
        require(sha(ROOT / path) == digest, "Changed referenced artifact: " + path)
    for path, digest in provenance["local_sources"].items():
        require(sha(HERE / path) == digest, "Changed local source: " + path)
    original = (HERE / "original.rs").read_text()
    v1 = (HERE / "shortcut-v1.rs").read_text()
    v2 = (HERE / "candidate-v2.rs").read_text()
    shortcut = "        if hashes.len() == 1 {\n            out[0] = self.contains_hash(hashes[0]) as u32;\n            return;\n        }\n"
    require(v1.count(shortcut) == 1 and v1.replace(shortcut, "") == original, "V1 differs beyond the four-line shortcut")
    before = "    #[inline]\n    fn contains_scalar(&self, hash: u64) -> bool {"
    after = before.replace("#[inline]", "#[inline(always)]")
    require(v1.count(before) == 1 and v2.count(after) == 1, "Wrong scalar helper annotation")
    require(v2.replace(after, before) == v1, "V2 differs beyond the one annotation")
    plan = json.loads((HERE / "plan.json").read_text())
    require(plan["eventual_registry"] == ["Independent32BloomFilter", "Independent32SingletonV1", "Independent32ScalarInlineV2"], "Missing separate before/V1/V2 controls")
    require(plan["eventual_training_grid"]["rows"] == 13 * 16, "Wrong proposed cardinality")
    print("PASS: unchanged original, exact V1 shortcut, exactly one private scalar-inline annotation for V2; no build or timing")


if __name__ == "__main__":
    main()
