#!/usr/bin/env python3
"""Non-compiling verification of additive validation sources and immutable inputs."""
import ast
import hashlib
import json
from pathlib import Path
import tomllib

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    require(__debug__, "Run preparation guards without Python -O")
    manifest = json.loads((STAGE / "manifest.json").read_text())
    for name, expected in manifest["files"].items():
        require(sha(STAGE / name) == expected, "Changed initial source: " + name)
    provenance = json.loads((HERE / "provenance.json").read_text())
    require(sha(STAGE / "manifest.json") == provenance["initial_manifest_sha256"], "Changed initial manifest")
    require(provenance["initial_source_commit"] == "d93d45c6cf09e8da687981fa77bb01b5fecbda70", "Wrong initial anchor")
    for name, record in provenance["copied"].items():
        require(sha(STAGE / name) == record["sha256"], "Changed audit copy: " + name)
        require(sha(ROOT / record["source"]) == record["sha256"], "Changed frozen copy source: " + name)
    for name, record in provenance["derived"].items():
        source = ROOT / record["source"]
        require(sha(source) == record["source_sha256"], "Changed adapter-prefix source")
        require((STAGE / name).read_text() == source.read_text().split("// Benchmark buffers", 1)[0], "Changed public adapter prefix")
    original_lock = tomllib.loads((STAGE / "benchmark/Cargo.lock").read_text())
    external = lambda lock: {(p["name"], p["version"]): p for p in lock["package"] if "source" in p}
    for kind, native in (("current", "../../native"), ("reference", "../reference-native")):
        directory = HERE / ("audit-" + kind)
        lock = tomllib.loads((directory / "Cargo.lock").read_text())
        require(external(lock) == external(original_lock), "Audit dependency drift")
        cargo = tomllib.loads((directory / "Cargo.toml").read_text())
        require(cargo["dependencies"]["fastest-bloom-filter"]["path"] == native, "Wrong immutable native dependency")
        body = (directory / "src/main.rs").read_text()
        require('include!("prefix.rs");' in body and 'include!("../../dense_dump.inc.rs");' in body, "Audit does not use the pinned shared sources")
    for path in HERE.glob("*.py"):
        ast.parse(path.read_text(), filename=str(path))
    print("PASS additive source-only: original36 artifacts unchanged, exact old/current public adapter prefixes, frozen reference crate/dependencies, shared full-output fixture, Python syntax")


if __name__ == "__main__":
    main()
