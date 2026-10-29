# Additive complete-data loader, frozen before CPP616 execution

This loader leaves producer `4beef70009394a839a17d01b22ad9700363f23dc` and pure analysis `0acf6e4307fb1ca19a431b5e7fd4eff9634df4de` unchanged. `binding.json` fixes their preparation hashes, proposal `61f0689` and completed caller proof `ae6ab194`. There is no raw anchor or formal data at preparation time. No filter, compiler, calibration, disassembler or timer is invoked by this package.

Before importing either package, the loader checks its own full-commit preparation, all 19 producer source artifacts, all eight analysis source artifacts and all four committed proposal input descriptors. Every local Python file must be inventoried. It isolates the producer's module names, checks actual module paths and rejects newly imported repository modules outside the verified import closure. Producer, analysis and loader commits must be full lowercase 40-hex hashes. SHA256 values and byte counts are checked against exact committed blobs as well as current files.

Only after all 48 processes/616 rows complete and the existing execution handle returns exit0 may the complete raw evidence be committed separately. That commit must contain:

- All 99 exact `screening/results-v1` members (96 stdout/stderr streams plus metadata, ordered records and quality links), and their immutable `RAW_ARCHIVE.json`.
- The entire combined `screening/screen-run.log`, exactly lines `1/48 processes complete` through `48/48 processes complete`, followed by `Complete48 processes/616 rows; all final source/raw/semantic guards passed.` and a final newline. Missing, extra, reordered or failure text rejects the archive.
- `screening/execution-outcome.json`, recorded from the actual terminal tool result for that same launched session. A completion message in the log is not evidence of exit0 by itself.

The outcome object has exactly `complete`, `producer_commit`, `session_id`, `exit_code`, `screen_log_sha256`, and `terminal_tool_result`. `complete` must be true, `producer_commit` must be the fixed producer, and `session_id` must be the positive actual launched handle. `exit_code` must be integer0. `terminal_tool_result` retains the actual complete terminal result object: its `exit_code` must be integer0, its `output` must be empty because output was redirected, and it must not report a still-running `session_id`. Record this existing-handle result; never infer or synthesize success from partial files or a log line.

After that complete raw commit, add and commit `../completed-raw-anchor.json` with exactly:

```json
{
  "complete": true,
  "producer_commit": "4beef70009394a839a17d01b22ad9700363f23dc",
  "raw_commit": "FULL_COMPLETE_RAW_COMMIT",
  "raw_manifest_sha256": "SHA256_OF_RAW_ARCHIVE_JSON",
  "screen_log_sha256": "SHA256_OF_ENTIRE_LAUNCHER_LOG",
  "execution_outcome_sha256": "SHA256_OF_EXECUTION_OUTCOME_JSON",
  "session_id": "ACTUAL_POSITIVE_INTEGER_HANDLE"
}
```

The placeholders above are documentation, not accepted input. The loader requires the anchor's own exact commit through `--anchor-commit`; it never trusts an uncommitted or floating current anchor. All 99 members, manifest, full log and outcome must match that anchor's separately committed raw tree. The exact99 inventory rejects additional/missing members. Duplicate JSON fields reject at every loader JSON boundary.

Only then does the loader call the unchanged producer's `audit.load_complete(raw_commit, raw_manifest_sha256)`. This replays all commands, exact source-shuffled row order, row schema/geometry, inherited exclusive lease and NUMA placement, 616 outputs and 2032 vectors, source/proof/tool/three-binary closure, and 128 calibration sources with 488 strict reuse rows. Complete returned metadata and producer identity are rechecked. The pure calculation independently reconstructs the quality links; the loader requires exact agreement with the producer's source-row/case indices, mapping IDs, counts, construction identities and reuse indices before writing any report. No shared calibration denominator is pooled.

After source review/commit, completed raw/anchor commits, and coordination of offline compute, the entry is:

```sh
python3 experiments/2026-10-29-k12-singleton-external-analysis/loader/run.py \
  --loader-commit FULL_FROZEN_LOADER_COMMIT \
  --anchor-commit FULL_COMPLETED_ANCHOR_COMMIT \
  --output NEW_REPORT_DIRECTORY
```

An existing output path or dangling symlink is rejected. The frozen pure report products are accompanied by `provenance.json`, recording every selected commit, raw manifest/log/outcome hash, actual session result, placement and producer counts. The previously approved fixed-rival/envelope/all-loss analysis rules are unchanged. Synthetic loader guards test missing/extra raw inventory, incomplete terminal evidence, malformed references, duplicate fields and inconsistent independent quality links without opening experimental rows or invoking the producer audit.
