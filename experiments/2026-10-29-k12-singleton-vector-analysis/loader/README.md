# Additive complete-raw loader

This entry point leaves the pre-data calculation/report sources at
`1b49388c97bb1fcfe537aa3e5bf9373ce9e9059b` unchanged. Its `binding.json` must be
completed with the final formal producer commit and preparation hash, then
reviewed and committed before any formal launch. Only the later
`../completed-raw-anchor.json` is added after all 96 processes complete and the
raw archive and whole launcher log are committed.

The anchor has exactly `complete`, `producer_commit`, `raw_commit`,
`raw_manifest_sha256`, and `screen_log_sha256`. Commits must be full immutable
hashes. The loader verifies the exact committed analysis and producer source
inventories before importing any producer audit code, requires every local
producer Python file to be inventoried, and rejects any additional repository
module imported by that audit. It binds the committed raw manifest and complete
launcher log, then invokes the producer's
`audit.load_complete(raw_commit, raw_manifest_sha256)`. That audit checks all
194 raw artifacts, exact commands and rows, placement, final source/proof/tool
and binary closure before returning `(metadata, records)`. The loader checks
the returned producer identity again and calls the frozen calculation.

`summarize.py`'s original disabled `load()` remains disabled. Use this entry
point only after the complete anchor is available:

```sh
python3 experiments/2026-10-29-k12-singleton-vector-analysis/loader/run.py --output NEW_REPORT_PATH
```

Coordinate the offline compute lease first. This command performs no filter,
compiler or timing invocation. It refuses an existing output directory.
