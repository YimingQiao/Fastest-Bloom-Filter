# Modern baseline screening — 2026-10-28

This is exploratory screening, not a final fastest-filter claim. One process
compared 43 configurations (42 external plus FastPattern), using the same compiler,
inputs, validation, and shuffled implementation order. It covers two key counts,
three requested budgets, and hit rates 0/50/100%: 18 cases and 774 timing rows.

Hardware: Xeon Platinum 8474C, CPU 2, Clang 23 with native instructions. Seed 42,
2^20 timed queries, batch 4096, whole-input build calls, three timing repetitions.
Actual allocations range from 64 KiB to 64 MiB. This screen does not establish
performance beyond the last-level cache or with single-key queries.

Ranking below caps resident filter allocation at 32 bits/key, with zero padding
allowance. It requires the pointwise one-sided 95% Wilson upper bound on observed
FPR to meet the target. Different candidates may use different bytes below the
same ceiling: this is not an equal-space or equal-FPR dominance claim. Construction
scratch is recorded separately and is not covered by that resident-memory ceiling.

Only 50%-hit rows are displayed here; the CSV leaderboard retains all hit rates.
Speed is median **hash+query ns/key**, including PageBloom's own raw-key hash.

| Keys | FPR ceiling | Screening leader | Actual allocation | Hash+query ns/key |
| --- | --- | --- | --- | --- |
| 16,777,216 | 1% | FastPatternBF | 33,554,432 B | 3.391 |
| 16,777,216 | 0.1% | FastPatternBF | 67,108,864 B | 3.567 |
| 16,777,216 | 0.01% | Boost192Multi32K8 | 67,108,863 B | 3.909 |
| 65,536 | 1% | FastPatternBF | 131,072 B | 1.073 |
| 65,536 | 0.1% | FastPatternBF | 262,144 B | 1.133 |
| 65,536 | 0.01% | FastFilterSimdBlock | 262,144 B | 1.664 |
FastPattern leads the 1% and 0.1% ceilings in this screen. The 0.01% ceiling is
led by FastFilter SIMD blocked at 65,536 keys and Boost Multi32K8 at 16,777,216 keys.
FastPattern's 2^20-negative samples do not establish a sufficiently low upper bound
for the strictest ceiling. A failure of this confidence test is not proof that its
true FPR exceeds the target. Subsequent confirmation uses separate, larger negative
calibration samples without expanding the timed-query working set.

Next: freeze shortlisted candidates, test new insertion seeds and 2^24 or more
calibration negatives, add single-key/short batches and >LLC footprints, and test
PageBloom's optional AES hash and the native Rust Bloomsday baseline. Wider mask
and additional sector layouts remain experimental until measured in the same
unified harness. No final claim is based on selecting and timing with seed 42 alone.

[Raw cases and provenance](../results/2026-10-28-modern-screen/),
[complete constrained ranking](../results/2026-10-28-modern-screen/ranking.csv),
[baseline contracts](../benchmarks/all-external/README.md).
