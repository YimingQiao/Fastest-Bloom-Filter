# Public Fastbloom K1..12 accuracy

All112 prespecified API/geometry rows completed. The40 retained constructions exactly reproduce the prior Rust120 counts, checksums and geometry; every one of72 fixed-K rows remains in the tables. No timing was measured.

These are seed42 training results at both64K and32M inserted keys. Eligibility uses each row's two-sided95% Wilson upper endpoint on2^24 disjoint negative queries. Bounds are per row, not simultaneous or held-out guarantees. No samples are pooled; only the proven default16/K11 duplicate is collapsed to110 mapping records.

The following are the smallest qualifying public K values in the complete1..12 grid. They are quality observations, not measured latency winners.

| Keys | Actual bpk | K for1% | K for0.1% | K for0.01% | Default K | Default upper FPR | Range upper FPR |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 65536 | 16 | 3 | 6 | none | 11 | 0.04735384% | 0.09196606% |
| 65536 | 24 | 2 | 4 | 7 | 17 | 0.00118388% | 0.00950860% |
| 65536 | 32 | 2 | 3 | 5 | 22 | 0.00004347% | 0.00186357% |
| 33554432 | 16 | 3 | 6 | none | 11 | 0.04672101% | 0.09229048% |
| 33554432 | 24 | 2 | 4 | 7 | 17 | 0.00117107% | 0.00920914% |
| 33554432 | 32 | 2 | 3 | 5 | 22 | 0.00006977% | 0.00176253% |

The old comparison used only automatic Fastbloom K11/17/22. Public fixed counts that pass the same ceiling must join the next performance comparison; the old Range/default-Fastbloom latency ratios do not establish a lead over these eligible public configurations. The original results remain unchanged.

The minimum-K±1 function is retained as a quality-only diagnostic. The proposed next timing protocol includes all12 public K values, automatic defaults and all existing native/external controls at batches1/31/4096. That full bounded sweep avoids assuming monotonic latency and will retain failures as well as wins. No production change or speed claim follows from this accuracy matrix.

Raw results SHA256: `89064610ead62798591de0e5cc094654022f487b61e4917eee4761405e038215`. Measured source: `1c66796121e515392cc576fb3a945bbdea286e77`. Compiled preflight anchor: `391b775c5c6e092230ef0954d59e802005dbcfce`. The separate audit checked every raw command, source-derived row order, committed input, dependency set and retained executable before producing this report.
