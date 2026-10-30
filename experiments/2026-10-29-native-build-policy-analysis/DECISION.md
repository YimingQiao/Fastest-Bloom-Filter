# Bounded build policy: measured gains and unresolved regressions

The fixed policy is promising for a native port, but this wrapper comparison does **not** justify a regression-free default. All 48 active-gate contract/seed records improve (24 exact-geometry groups, each winning on both fresh seeds); 66 of the 112 outside-gate paired contracts are slower. Every loss remains in `report/all-losses.csv` and every four-trial vector remains in `report/primary-metrics.csv`.

The gate is exactly current insertion length <= 65,536 and actual bitmap bytes <= 262,144. Only Split64 and Split64Range were tested, in C++ and Rust, requested T=4/8, seeds 74381/164321, and six fixed empty/prefilled/uniform/hotspot scenarios. This is incremental batch length, not constructor size. No threshold was selected from these fresh results.

| Active scenario and contract | C++ control/candidate | Rust control/candidate |
|---|---:|---:|
| Small empty, insert only | 2.80–8.47× | 3.09–5.03× |
| Small empty, allocation plus build | 2.62–6.92× | 2.25–5.06× |
| Small prefilled hotspot, incremental insertion | 2.67–5.73× | 2.89–4.05× |

These are minima/maxima of individual measured cells, not pooled estimates or confidence intervals. The generated report retains the two seeds separately for each family/T/contract.

Repeated regressions outside the gate are material. Rust Split64 at 256 KiB, batch 65,537, T=8 has allocation-plus-build speedups 0.87774× and 0.82442×: candidate latency is about 13.9% and 21.3% higher. Rust Range at that same boundary has 0.91659× and 0.93774×. Rust Split64 at the next larger bitmap also loses allocation-plus-build on both seeds at T=4 and T=8. C++ Split64 above the batch boundary loses insert-only at T=4 on both seeds. All large-bitmap controls remain, including their smaller repeated losses.

The worker request is unchanged outside the gate. These observations therefore do not show a new partition algorithm; they can reflect caller/code-generation or measurement effects. They cannot be discarded as noise without further evidence. The next experiment must compare the actual native public before/after entrypoints in one harness and preserve the entire 96-case ledger, especially the failing 65,537/256 KiB/T=8 case.

Direct serial also remains relevant. The Rust Range small empty/T=4 allocation-plus-build candidate is 1.3930× and 1.4425× the direct-serial latency despite beating the old parallel call. Across the archive, 306 of 320 arm/serial comparisons are slower than their shared serial reference. Those references are not independent duplicate samples; serial occupies first/last, never middle, and has the documented affinity/first-touch contract. No query performance, cross-language leadership or external-baseline win is inferred.

The native candidate must apply only to Split64/Range, keep public original T inside the timed call, use the same effective request in worker/scratch getters and insertion, preserve query T and outside-gate automatic scheduling, and leave Four/Byte unchanged. Default integration remains pending actual-native confirmation and investigation of the repeated outside-gate regressions. No threshold sweep or broader fallback is proposed.

Raw archive commit: `5677deaed887db9066f773526388e56d48f3b4de`. Analysis source commit: `4a8e6eb3be7579d7beb2d51658933e138391d715`. Source-only independent peer review was clean before values were analyzed. No filter/compiler execution occurred during analysis.
