#!/usr/bin/env python3
"""Pin completed result and analysis archives without modifying measured inputs."""
import json

from summarize import EXPERIMENT, HERE, load_checked, require, sha


def records(directory):
    return {str(path.relative_to(directory)): sha(path)
            for path in sorted(directory.rglob("*"))
            if path.is_file() and path != directory / "manifest.json"
            and not set(path.relative_to(directory).parts) & {"__pycache__", "target"}}


def main():
    require(__debug__, "Run archive generation without Python -O")
    _, _, _, meta = load_checked()
    screen = EXPERIMENT / "screen"
    summary = json.loads((HERE / "report/summary.json").read_text())
    require(summary["results_sha256"] == meta["results_sha256"], "Analysis uses different results")
    require(summary["analysis_sha256"] == sha(HERE / "summarize.py"), "Analysis source changed")
    input_manifest = dict(scope="Completed132-row seed42 initial throughput screen; no held-out/global leadership claim",
                          source_commit=meta["source_commit"], binary_sha256=meta["binary_sha256"], files=records(screen))
    (screen / "manifest.json").write_text(json.dumps(input_manifest, indent=2) + "\n")
    manifest = dict(scope="Offline analysis of completed Rust132 initial screen", source_commit=meta["source_commit"],
                    result_manifest=str((screen / "manifest.json").relative_to(HERE.parents[1])),
                    result_manifest_sha256=sha(screen / "manifest.json"),
                    measured_input_freeze_sha256=sha(EXPERIMENT / "validation/freeze.json"),
                    files=records(HERE))
    (HERE / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Pinned {len(input_manifest['files'])} result artifacts and {len(manifest['files'])} analysis artifacts")


if __name__ == "__main__":
    main()
