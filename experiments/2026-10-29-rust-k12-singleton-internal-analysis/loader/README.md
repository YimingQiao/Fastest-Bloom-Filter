# Additive complete-only Rust192 loader

This small entry binds the already frozen pure calculation `55571389d14fe178bdc3f9f00fd630c9c11ac98c` to formal producer `5c679ae126854586f52cea6bd17a385ae0bd29c6`. `binding.json.complete` describes the finalized **source interface**, not completed measurements. No raw archive is available or selected during this source stage. The calculation, workload and caller are unchanged.

Before importing any producer code, `run.py` verifies its own complete committed source inventory, the exact calculation and producer manifests/all listed Git bytes, and every local Python module. The future full-40-hex raw commit must contain `results-v1/RAW_ARCHIVE.json`, the complete exclusively created `screen-run.log`, and `execution-outcome.json`, each matching its supplied SHA256. The log must be exactly the96 progress lines plus the producer's successful terminal line. Missing or partial outputs cannot enter the analysis. There is no fallback to a live partially filled directory.

The outer launcher is the parent-approved simple whole-flock/taskset/environment command with `bash set -Ce` and direct exclusive redirection; no tee or stream-monitor wrapper is added. `execution-outcome.json` records the **actual existing session handle's terminal tool result**, after it finishes: exact keys `complete`, `producer_commit`, `session_id`, `exit_code`, `screen_log_sha256`, `terminal_tool_result`. Both exit codes must be integer0, the recorded session must match the explicit positive session argument, and the terminal result must no longer contain a live session ID. Its output must be empty because the full stream was redirected. This evidence is committed alongside the raw archive and log; it is not synthesized from the producer's final printed line. Raw194 inventory remains unchanged.

It then calls the immutable producer `audit.load_complete(raw_commit, raw_manifest_sha256)`, which replays all194 raw artifacts,96 commands/192 ordered rows, both binary profiles, source/proof/tool/placement closure and all semantic/trial guards. The returned metadata must identify the fixed producer and `complete=true`. Repository import closure is checked, then the unchanged pure calculation independently verifies the proposal ledger and seven committed schema/source inputs before producing all288 pairs/576 vectors/4608 samples/144 round sensitivities/72 ranges.

Only after the full formal producer has exited successfully and its raw archive/log are committed may the entry be called:

```sh
python3 experiments/2026-10-29-rust-k12-singleton-internal-analysis/loader/run.py \
  --loader-commit FULL_LOADER_COMMIT --raw-commit FULL_COMPLETED_RAW_COMMIT \
  --raw-manifest-sha256 COMPLETE_RAW_MANIFEST_SHA256 --screen-log-sha256 COMPLETE_LOG_SHA256 \
  --execution-outcome-sha256 ACTUAL_TERMINAL_EVIDENCE_SHA256 --session-id ACTUAL_SESSION_ID \
  --output NEW_REPORT_DIRECTORY
```

The report records those immutable arguments and the source binding. Existing report paths are rejected. Synthetic tests exercise fail-closed anchors, partial logs, false/running terminal outcomes, source escape and committed-byte mismatch; they import no actual producer and read no measured rows. No compiler, BF, calibration, performance rerun, new selection or additional metric is introduced.
