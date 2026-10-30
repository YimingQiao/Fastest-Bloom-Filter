# Full public-K performance analysis

Completed results: [interpretation](report/INTERPRETATION.md), [full report](report/REPORT.md), [all query alternatives](report/query-alternatives.csv), and [all build alternatives](report/build-alternatives.csv). Complete raw evidence is committed at `2624516177e02d9019c582b2e76a6b6ac8fad7ae`. The final independent audit regenerated all16 products byte-for-byte after rechecking the committed sources, dependencies, binaries and two-session raw archive.

This sidecar analyzes only a complete, committed336-row archive. It does not read partial results to select configurations or alter the frozen workload. The first17 cases/316 rows belong to the interrupted original attempt at source `571186b420bf7e5fc08269ed4a65feab42ac8400`; exact original evidence is committed at `ab98c241a1ca71c8a502806c013949276e06d67d`. The remaining case uses the additive driver `504e1a27ccdb9d8ed61ebd5e5d1657b1a1f6e2da` and the same `f499f5da…` native performance executable.

The original process tool returned143; its cause is unknown. The original metadata remains complete=false. A prospective finalizer ledger-overwrite bug was identified but never occurred. The `recovery/` directory preserves the observers, original checkpoints, interrupted audit and historical unexecuted recovery preparation. The current analysis reconstructs a two-session combined archive; it does not claim recovery of a completed original run or regenerate unobserved original output.

To reproduce the completed analysis in a fresh output directory, run:

```
python3 experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/summarize.py \
  --raw-commit 2624516177e02d9019c582b2e76a6b6ac8fad7ae --output /tmp/fixed-k336-report
```

The loader validates committed raw bytes, the original592-input freeze, dependency and binary hashes, all17 original cases, exact copies into the derived archive, the sole new20-row case, all18 commands and all336 semantic/trial/order records. It reconstructs the derived metadata from the preserved original and resumed ledgers. Existing reports are never overwritten.

All K1…12 remain alternatives regardless of calibration. Every query contract and build boundary is ranked separately under actual-byte caps16/24/32 and two-sided95% Wilson upper-bound ceilings1%/0.1%/0.01%; smaller allocations remain eligible. Expected tables contain216 query views and216 build views,12096 alternatives for each,648 Range alternatives for each,1728 same-byte fixed/default pairs,96 Range/Split64 controls and672 staged/visible API pairs. These are descriptive seed42 training comparisons, not independent significance tests or a global fastest claim.

The112 API quality observations reduce only to110 proven mappings via default16/K11 aliases; batch tags and modes do not enlarge the sample. Fixed-K versus automatic-K pairs keep differing quality explicit. The original automatic11/17/22-probe configurations remain measured. Visible singleton loops operate on the full query array regardless of the batch tag. Four build metrics retain their original fixed order; only build medians are available, so no missing trial dispersion is inferred.

All APIs within one size/cap/batch workload run in one process. Nested-cap ranking may compare allocations measured in different processes, and the last large/cap32/batch4096 workload belongs to a separate session after the interruption. The report must retain this scope, all losses and actual allocation sizes. No older timing values enter the ranking.
