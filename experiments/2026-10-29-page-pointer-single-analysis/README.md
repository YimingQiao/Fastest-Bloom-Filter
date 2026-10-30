# Page caller analysis preparation

Prepared source-only during the fixed240 matrix, without reading partial
latencies, quality counts or choosing a subset. The eight synthetic tests have
not been executed during that timing lease. Ranking rules and the full output
grid are fixed before complete results are available.

The loader requires an exact committed complete raw archive, all482 artifacts
(240 stdout/stderr pairs, metadata and screen-run.log), and the unchanged timed
source `82fe0322fb2a761ece241fc89635e126bc80a590`. It reuses the frozen producer
audit for all240 commands/rows/phases/guards, original semantic parity and proof
of the2ed675 executable. No older modern23 latency is returned to the ranking
functions or used in a correction.

Fixed output scope:

| Output | Records | Meaning |
|---|---:|---|
| Paired callers | 288 | Six same-mapping Page pairs ×two n ×four allocations ×two rounds ×three modes |
| Nested-cap views | 144 | Two rounds ×two n ×four actual byte caps ×three FPR gates ×three modes |
| All alternatives | 8640 | Every60 measured allocations in every relevant view, including failures/losses |
| Native controls | 144 | Four native layouts ×three allocations ×two n ×two rounds ×three modes |
| Quality identities | 72 | Verified caller/round aliases reuse one2^24-negative observation, never pooled |

Every view uses actual bitmap bytes≤cap and the pointwise two-sidedWilson95 upper
endpoint at1%/0.1%/0.01%. Smaller allocations remain eligible under larger caps.
Production, Page value and Page pointer leaders remain separate, with an
additional fastest-any-Page leader. Quality failure or missing qualifiers cannot
be counted as a timing win. Every pair retains both times, trial vectors, phase
orders and bounds; unchanged dense/native paths may still regress through code
layout and those outcomes stay visible.

The pair ratio is **pointer/value latency**: below1 means lower observed pointer
latency; above1 means higher. View candidate ratios are likewise
candidate/rival latency. Both launch rounds stay separate; no averaging hides
round changes. Nested caps, caller aliases and rounds are not independent
statistical victories. This is a seed42 caller-contract screen using one binary
but a fresh process per row, not a dependent-single-key or same-process paired
latency experiment, held-out confirmation, or a complete modern-library ranking.

After all raw output is complete, seal `SCREEN_ARCHIVE.json` under the Page stage
with `producer_commit` and a stage-relative path→SHA-string `files` mapping.
Commit it and all482 artifacts before running:

```sh
python3 experiments/2026-10-29-page-pointer-single-analysis/summarize.py \
  --raw-commit FULL_COMPLETE_RAW_COMMIT \
  --output experiments/2026-10-29-page-pointer-single-analysis/report
```

A descriptive prose report will be written from the guarded complete outputs
only. Source or test corrections after freezing must be additive and retain the
original attempt; no measurement is rerun by this analyzer.
