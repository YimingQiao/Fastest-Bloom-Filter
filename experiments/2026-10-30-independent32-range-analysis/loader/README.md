# Independent32Range216 complete-only loader

This additive loader leaves pure analysis96e3e8a, caller968361db and completed caller proofaa21a91 unchanged. `binding.json` fixes producer796bd636eab59ce130923864c5d3c925189ec8e5 and its preparation SHA54550f7bdb85f05d4aa607a9d56e7c8ef91f9227d1f9b89db954cd1258de928d. There is no completed-raw anchor and no measured data has been read. The loader never invokes a filter, compiler, calibration, disassembler or timer.

Before importing executable source, the loader verifies its own preparation from a full immutable commit, the producer's preparation/import closure, all17 analysis source blobs and all36 caller source blobs. It also verifies the173-artifact actual caller proof from aa21a91 and its manual ASM gate, exact normal executable, two-binary descriptor and570 consumed-input identities. The analysis source guard binds the exact original protocol and selection-to-ledger derivation. Local Python files must be inventoried; producer and analysis module names are isolated, and repository imports outside their checked source inventories are rejected.

Only after all24 processes/216 rows complete and the existing session handle actually exits0 may a separate raw commit contain:

- Exactly51 raw members:48 stdout/stderr streams, metadata, ordered records and quality links, plus `results-v1/RAW_ARCHIVE.json`.
- The complete `screen-run.log`: lines `1/24 processes complete` through `24/24 processes complete`, then `Complete24 processes/216 rows; all final source/raw/semantic guards passed.` and the final newline. Extra, missing, reordered or failure text rejects.
- `execution-outcome.json`, retaining the actual terminal tool result for the launched session. The completion log alone cannot establish a successful exit.

The outcome object has exactly `complete`, `producer_commit`, `session_id`, `exit_code`, `screen_log_sha256`, and `terminal_tool_result`. It must identify the fixed producer and positive actual session ID, with integer exit0. The nested actual tool result must itself have integer exit0 and empty output because the launcher redirected all output. It must not retain a live session ID. Preserve the real result; do not infer or synthesize success.

After committing that complete raw evidence, add and separately commit `../completed-raw-anchor.json` with exactly:

```json
{
  "complete": true,
  "producer_commit": "FULL_FIXED_PRODUCER_COMMIT",
  "raw_commit": "FULL_COMPLETE_RAW_COMMIT",
  "raw_manifest_sha256": "SHA256_OF_RAW_ARCHIVE_JSON",
  "screen_log_sha256": "SHA256_OF_ENTIRE_LOG",
  "execution_outcome_sha256": "SHA256_OF_OUTCOME",
  "session_id": "ACTUAL_POSITIVE_INTEGER"
}
```

These placeholders are documentation, not valid accepted input. The loader requires the anchor's own full commit with `--anchor-commit`, verifies every raw file/manifest/log/outcome as an exact Git blob, and rejects duplicate JSON fields, malformed references, escaped paths and mismatched sizes/hashes. No partial archive is accepted.

The fixed producer's `audit.load_complete(raw_commit, raw_manifest_sha256)` must replay every command and row, actual source-derived order, inherited exclusive lease, CPU3/NUMA1 placement, exact source/proof/tool/binary closure and calibration reuse. Returned metadata must be complete, retain24 cases/216 rows and have equal initial/final closure and placement. Its binaries, consumed inputs, tools and normal executable must equal the committed caller proof. The producer placement validator is invoked on the recorded placement; it does not infer past placement from the current host.

The immutable pure analysis then reconstructs all36 API calibration records and180 reuse links. Before publishing, the loader requires exact agreement with the producer's34 known mapping groups, original denominators, counts/digests, source row/case indices, reuse indices and construction identities including actual bitmap availability. No denominator is pooled. All576 vectors,4608 samples, losses, nulls and the frozen32-comparison decision pass through the original calculation and report writer unchanged.

After complete committed evidence and a scheduled offline slot, the entry will be:

```sh
python3 experiments/2026-10-30-independent32-range-analysis/loader/run.py \
  --loader-commit FULL_FIXED_LOADER_COMMIT \
  --anchor-commit FULL_COMPLETED_ANCHOR_COMMIT \
  --output NEW_REPORT_DIRECTORY
```

An existing output path or dangling symlink rejects. `provenance.json` adds exact commits/hashes, actual session result, normal executable/manual gate, placement and producer counts to the immutable report products. All seven synthetic guards passed on the first execution under a brief CPU3/socket1 lease, retained in `guards-v1.stdout` and `guards-v1.stderr`. They cover exact51 inventory, immutable refs, full25-line log/terminal evidence, duplicate fields, independent quality-link agreement, complete source/binary/placement metadata, and unbound/import-escape rejection. They used no experiment rows or producer audit execution. The lease was explicitly released. Actual loading still requires complete committed raw and terminal evidence plus a separately committed completed anchor.
