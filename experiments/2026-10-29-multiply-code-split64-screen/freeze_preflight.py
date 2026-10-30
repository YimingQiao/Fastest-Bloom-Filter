#!/usr/bin/env python3
"""Freeze a successful versioned preflight without changing the initial proposal."""
import argparse
import json
from pathlib import Path

from preflight_guard import HERE, ROOT, require, sha, initial_snapshot, check_bytes, check_binaries


def main():
    require(__debug__, "Run without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--validation", type=Path, default=HERE / "validation-v1")
    args = parser.parse_args()
    initial_snapshot()
    value = json.loads((args.validation / "summary.json").read_text())
    require(value["complete"] and not value["timing_matrix_executed"], "No completed correctness preflight")
    require(value["retained_semantic_comparisons"] == 450 and value["planned_rows"] == 70 and value["cases"] == 13, "Wrong preflight contract")
    check_bytes(value["inputs_sha256"])
    binaries = {**value["anchor"]["parent_binary_sha256"], **value["binary_sha256"]}
    check_binaries(binaries)
    plan = json.loads((args.validation / "selection.json").read_text())
    require(len(plan["configurations"]) == plan["rows"] == 70 and len(plan["cases"]) == 13, "Wrong selected geometry matrix")
    paths = sorted(p for p in HERE.rglob("*") if p.is_file() and "__pycache__" not in p.parts
                   and "screen" not in p.relative_to(HERE).parts and p.name not in ("FREEZE.json", "manifest.json"))
    sources = dict(value["inputs_sha256"])
    sources.update({str(p.relative_to(ROOT)): sha(p) for p in paths})
    frozen = dict(scope="Multiply76 preflight complete; fixed70 training screen not run",
                  preflight_source_commit=value["anchor"]["source_commit"], source_sha256=sources, binary_sha256=binaries,
                  selected_plan_sha256=sha(args.validation / "selection.json"), inherited_lease=value["lease"])
    check_bytes(sources)
    (HERE / "FREEZE.json").write_text(json.dumps(frozen, indent=2) + "\n")
    paths.append(HERE / "FREEZE.json")
    manifest = {str(p.relative_to(HERE)): sha(p) for p in sorted(paths)}
    (HERE / "manifest.json").write_text(json.dumps(dict(scope="Completed preflight; initial27 proposal preserved; no performance screen", files=manifest), indent=2) + "\n")
    print(f"Frozen{len(sources)} source/dependency/evidence entries,{len(binaries)} binaries,{len(manifest)} local entries; no timing screen")


if __name__ == "__main__":
    main()
