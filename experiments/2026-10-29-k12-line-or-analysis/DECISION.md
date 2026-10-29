# Decision from the fixed balanced screen

Keep the unconditional whole-line OR variant experimental. It has a useful large-table signal, but the measured small-table full-build regression rules out a blanket improvement claim or immediate default promotion. No threshold, prefetch, mask or additional candidate was selected after these results.

The two fixed seeds run opposite relative filter orders. At n=33,554,432, the bitmap is96MiB. Every large-table construction metric is faster for both insertion chunks and both seeds. Complete allocation-plus-build latency falls:

- Four-key chunks:21.4–22.4% for prehashed insertion,22.7–23.1% with common hashing.
- Whole-input insertion:15.1–15.6% prehashed,13.7–14.5% with common hashing.

At n=65,536, the bitmap is192KiB. Whole-input insertion loses all four construction boundaries for both seeds. Complete prehashed construction is4.4–9.1% slower, and complete common-hash construction is4.8–9.5% slower. Four-key chunks have nearly unchanged prehashed total construction (−0.86% to+0.74%), while common-hash total construction is18.3–18.9% faster. The raw-hash improvement is an actual caller result and should not be generalized to every insertion API or attributed solely to store count.

Across the complete fixed grid,23 of32 construction comparisons improve and9 regress. Of the16 complete allocation-plus-build comparisons,11 improve and5 regress. These counts are descriptive, not independent trials: insertion is a nested subinterval of complete construction, and the five repetitions share a process and code placement. No outcome was pruned.

The mechanism is consistent with the source hypothesis: four scalar-word updates per key become one sequential full-line vector RMW, with extra mask construction/expand instructions. The experiment does not include hardware-counter evidence, so memory-system causality remains an inference. Full bitmap/oracle, duplicate/shared-line, minimal AVX512F and ASan checks passed, but this screen is single-threaded and makes no native parallel speed claim. Whole-line writes require the established exclusive-line ownership contract.

A separately fixed confirmation could justify a scoped large-table use; this screen does not authorize a new dispatch threshold or production change. The existing native insertion path remains the default. There is no reason to broaden this into an unrestricted search: preserve this single candidate and its complete counterexamples.

Source c922861c75d193b9dbfc2c2399eea6b454d1f9eb; committed raw ceee2396ce0606d700091f5872aab908a893dd4e. Full32 comparisons,64 vectors/320 samples and all16 two-seed ranges are in report/.
