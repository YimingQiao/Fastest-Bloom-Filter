#!/usr/bin/env python3
"""Freeze this sidecar and reference raw output hashes without changing measured files."""
import json
from summarize import COMMIT, EXPERIMENT, HERE, ROOT, load_checked, require, sha


def main():
    require(__debug__, "Normal Python required")
    _, _, meta, _ = load_checked()
    summary = json.loads((HERE / "report/summary.json").read_text())
    require(summary["analysis_sha256"] == sha(HERE / "summarize.py") and summary["order_oracle_sha256"] == sha(HERE / "order_oracle.py"), "Report source changed")
    require(summary["results_sha256"] == meta["results_sha256"], "Report uses different measurements")
    files = {str(p.relative_to(HERE)): sha(p) for p in sorted(HERE.rglob("*"))
             if p.is_file() and p != HERE / "manifest.json" and "__pycache__" not in p.parts}
    raw = {str(p.relative_to(ROOT)): sha(p) for p in sorted((EXPERIMENT / "screen").glob("*")) if p.is_file()}
    manifest = dict(scope="Completed cyclic62 offline analysis; frozen measured files unchanged", source_commit=COMMIT,
                    measured_anchor=meta["anchor"], input_screen_files_sha256=raw, files=files)
    (HERE / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Pinned {len(files)} local artifacts and {len(raw)} raw input artifacts")


if __name__ == "__main__":
    main()
