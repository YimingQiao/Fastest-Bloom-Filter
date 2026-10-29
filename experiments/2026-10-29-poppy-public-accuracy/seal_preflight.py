#!/usr/bin/env python3
"""Seal the completed bounded caller check without running a filter."""
import json
from preflight import HERE, frozen, fixtures, validate, need, sha, save

SOURCE = "81e9eb412c9b816984dc4d91b1f135daa10943ea"
output = HERE / "preflight-v1"
meta = json.loads((output / "metadata.json").read_text())
need(meta["complete"] and meta["source_commit"] == SOURCE, "Incomplete attempt")
need(meta["source_manifest"] == frozen(SOURCE), "Source drift")
need(meta["full_accuracy_run"] is False and meta["timing_samples"] == 0, "Wrong scope")
labels = [
    profile + "-" + item
    for profile in ("normal", "asan")
    for item in (
        ["version", "metadata", "build"]
        + ["fixture-" + str(i) for i in range(8)]
        + ["invalid-" + str(i) for i in range(4)]
    )
]
need([c["label"] for c in meta["commands"]] == labels, "Wrong command coverage")
for command in meta["commands"]:
    need(command["complete"], "Incomplete command")
    need((command["returncode"] == 0) == command["expected_success"], "Wrong exit")
    for stream in ("stdout", "stderr"):
        need(sha(output / command[stream]) == command[stream + "_sha256"], "Log drift")
for item in meta["binaries"].values():
    need(sha(item["path"]) == item["sha256"], "Executable drift")
for deps in meta["actual_dep_info_files"].values():
    for source, item in deps.items():
        need(
            sha(source) == sha(output / item["artifact"]) == item["sha256"],
            "Dep-info drift",
        )
rows = {}
for profile in ("normal", "asan"):
    rows[profile] = []
    for i, constructor in enumerate(fixtures()):
        stem = output / (profile + "-fixture-" + str(i))
        need(not stem.with_suffix(".stderr").read_bytes(), "Unexpected diagnostic")
        row = json.loads(stem.with_suffix(".stdout").read_text())
        validate(row, constructor, True)
        rows[profile].append(row)
need(rows["normal"] == rows["asan"], "Backend mismatch")
summary = dict(
    complete=True,
    source_commit=SOURCE,
    commands=30,
    fixture_rows=16,
    invalid_cli_cases=8,
    cpu=meta["cpu"],
    binaries=meta["binaries"],
    actual_dep_info_files={k: len(v) for k, v in meta["actual_dep_info_files"].items()},
    independent_input_oracle=True,
    public_iterator_parity=True,
    full_accuracy_run=False,
    timing_samples=0,
)
need(not (HERE / "PREFLIGHT_PROOF.json").exists(), "Preserve prior proof")
save(HERE / "PREFLIGHT_PROOF.json", summary)
(HERE / "PREFLIGHT_REPORT.md").write_text(
    """# Completed Poppy accuracy-caller checks

The actual public accuracy worker passes all eight bounded fixtures under both
normal Rust and nightly ASan:16 rows, plus eight rejected invalid CLI calls.
All30 commands completed with their expected exit status on the first attempt.
Both profiles agree on every output field. The independent Python oracle checks
the source dataset's base, insertion/query shuffles and input digests; public
iterator comparisons check every mixed and calibration answer. Every inserted
key remains present. All fixture constructors retain their full real capacity.

The complete operation held the socket0 lease on CPU2. Each row used1031 inserts,
8193 mixed queries and4096 separate calibration negatives. These are caller
checks, not full-load quality measurements. No throughput timer ran. Actual
dependency text and structured build metadata are retained, without claiming
a resolved complete compiler-input closure. The two executable hashes are in
PREFLIGHT_PROOF.json; no executable is committed.

The fixed86 full-load accuracy stage may now use the exact checked normal
binary. No public mapping, geometry, hash, seed or error threshold changed.
"""
)
archive = HERE / "PREFLIGHT_ARCHIVE.json"
need(not archive.exists(), "Preserve prior archive")
files = {
    str(p.relative_to(HERE)): dict(sha256=sha(p), bytes=p.stat().st_size)
    for p in sorted(HERE.rglob("*"))
    if p.is_file() and "__pycache__" not in p.parts
}
save(archive, dict(source_commit=SOURCE, files=files, binaries_archived=False))
print(json.dumps(summary))
