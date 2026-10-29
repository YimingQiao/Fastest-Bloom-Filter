# Native K12 multithread comparison: complete fixed195

Producer `a46a7afd49094fb1c6748191d1fc448a8cd1f2fb`; complete raw `7c526683db0ad367ac99bbeeeba252a11a27b64e`. All195 rows are retained:147 common-executor query rows and48 actual public native API rows. Two sizes,49 exact API/geometry points, three already-seen construction seeds, eight physical cores on socket0/NUMA0. No new kernel or post-result selection was used.

All latency ratios below use candidate/rival (or T8/T1); **below1 is faster**. Actual allocations are admitted under nested16/24/32-bpk ceilings. Quality uses each construction’s held-out2^26-negative two-sided95% Wilson upper endpoint. Held-out means a separate key range from inserted and timed mixed-query keys, not statistical independence across APIs or mappings sharing the same seed/input;1%,0.1%,0.01% are fractions0.01,0.001,0.0001.147 API records correspond to126 checked mapping identities, with no pooled or additional denominator from aliases or the public track.

The shared executor creates fresh threads for every invocation. Launch/gated/join/end-to-end boundaries remain separate and all four query phases are balanced. Public native APIs use their actual whole-array partitioning and an eight-core allowed mask. These two contexts are reported separately; their medians are not normalized or substituted for one another.

## Shared T8 query leadership

| Quality policy | Candidate group / strongest external | Wins | Losses | Ties | No comparable |
|---|---|---:|---:|---:|---:|
| current seed | production_native | 162 | 6 | 0 | 48 |
| current seed | optional_native_range | 84 | 108 | 0 | 24 |
| current seed | optional_native_k12 | 93 | 75 | 0 | 48 |
| current seed | all_native_composite | 192 | 0 | 0 | 24 |
| all three seeds pass | production_native | 162 | 6 | 0 | 48 |
| all three seeds pass | optional_native_range | 84 | 108 | 0 | 24 |
| all three seeds pass | optional_native_k12 | 93 | 75 | 0 | 48 |
| all three seeds pass | all_native_composite | 192 | 0 | 0 | 24 |

Counts span nested caps, metrics and seen constructions; they are descriptive repeated views, not independent experiments. No-comparable cases are excluded from any win denominator. The all-native composite is not a production-only result. All3636 cap-admitted alternatives, quality failures and every leader remain in the machine-readable output.

## Every all-seed K12 condition against the strongest external

| Keys | Cap bpk | FPR ceiling | Metric | Minimum ratio | Maximum ratio | W / L / T / unavailable |
|---:|---:|---:|---|---:|---:|---|
| 65536 | 16 | 0.01% | parallel_hash_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.01% | parallel_hash_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.01% | parallel_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.01% | parallel_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.1% | parallel_hash_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.1% | parallel_hash_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.1% | parallel_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 0.1% | parallel_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 65536 | 16 | 1% | parallel_hash_lookup_end_to_end_ns | 0.969382 | 0.996299 | 3 / 0 / 0 / 0 |
| 65536 | 16 | 1% | parallel_hash_lookup_gated_ns | 0.961915 | 1.000169 | 2 / 1 / 0 / 0 |
| 65536 | 16 | 1% | parallel_lookup_end_to_end_ns | 1.018039 | 1.041795 | 0 / 3 / 0 / 0 |
| 65536 | 16 | 1% | parallel_lookup_gated_ns | 1.025095 | 1.064438 | 0 / 3 / 0 / 0 |
| 65536 | 24 | 0.01% | parallel_hash_lookup_end_to_end_ns | 0.687296 | 0.696170 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.01% | parallel_hash_lookup_gated_ns | 0.642915 | 0.650791 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.01% | parallel_lookup_end_to_end_ns | 0.617820 | 0.624046 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.01% | parallel_lookup_gated_ns | 0.548956 | 0.563081 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.1% | parallel_hash_lookup_end_to_end_ns | 0.949501 | 0.961780 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.1% | parallel_hash_lookup_gated_ns | 0.937504 | 0.957141 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.1% | parallel_lookup_end_to_end_ns | 0.907181 | 0.913642 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 0.1% | parallel_lookup_gated_ns | 0.874687 | 0.905689 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 1% | parallel_hash_lookup_end_to_end_ns | 0.969382 | 0.996299 | 3 / 0 / 0 / 0 |
| 65536 | 24 | 1% | parallel_hash_lookup_gated_ns | 0.961915 | 1.000169 | 2 / 1 / 0 / 0 |
| 65536 | 24 | 1% | parallel_lookup_end_to_end_ns | 1.018039 | 1.041795 | 0 / 3 / 0 / 0 |
| 65536 | 24 | 1% | parallel_lookup_gated_ns | 1.025095 | 1.064438 | 0 / 3 / 0 / 0 |
| 65536 | 32 | 0.01% | parallel_hash_lookup_end_to_end_ns | 0.986205 | 1.002734 | 2 / 1 / 0 / 0 |
| 65536 | 32 | 0.01% | parallel_hash_lookup_gated_ns | 0.981500 | 0.995788 | 3 / 0 / 0 / 0 |
| 65536 | 32 | 0.01% | parallel_lookup_end_to_end_ns | 0.957580 | 0.960467 | 3 / 0 / 0 / 0 |
| 65536 | 32 | 0.01% | parallel_lookup_gated_ns | 0.946985 | 0.961969 | 3 / 0 / 0 / 0 |
| 65536 | 32 | 0.1% | parallel_hash_lookup_end_to_end_ns | 0.986205 | 1.002734 | 2 / 1 / 0 / 0 |
| 65536 | 32 | 0.1% | parallel_hash_lookup_gated_ns | 0.981500 | 0.995788 | 3 / 0 / 0 / 0 |
| 65536 | 32 | 0.1% | parallel_lookup_end_to_end_ns | 0.997708 | 1.040846 | 1 / 2 / 0 / 0 |
| 65536 | 32 | 0.1% | parallel_lookup_gated_ns | 0.994327 | 1.054938 | 1 / 2 / 0 / 0 |
| 65536 | 32 | 1% | parallel_hash_lookup_end_to_end_ns | 0.974953 | 0.996299 | 3 / 0 / 0 / 0 |
| 65536 | 32 | 1% | parallel_hash_lookup_gated_ns | 0.973522 | 1.000169 | 2 / 1 / 0 / 0 |
| 65536 | 32 | 1% | parallel_lookup_end_to_end_ns | 1.018039 | 1.041795 | 0 / 3 / 0 / 0 |
| 65536 | 32 | 1% | parallel_lookup_gated_ns | 1.025095 | 1.064438 | 0 / 3 / 0 / 0 |
| 33554432 | 16 | 0.01% | parallel_hash_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.01% | parallel_hash_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.01% | parallel_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.01% | parallel_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.1% | parallel_hash_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.1% | parallel_hash_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.1% | parallel_lookup_end_to_end_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 0.1% | parallel_lookup_gated_ns | — | — | 0 / 0 / 0 / 3 |
| 33554432 | 16 | 1% | parallel_hash_lookup_end_to_end_ns | 0.992193 | 1.025466 | 2 / 1 / 0 / 0 |
| 33554432 | 16 | 1% | parallel_hash_lookup_gated_ns | 0.980802 | 1.030647 | 2 / 1 / 0 / 0 |
| 33554432 | 16 | 1% | parallel_lookup_end_to_end_ns | 1.030461 | 1.049025 | 0 / 3 / 0 / 0 |
| 33554432 | 16 | 1% | parallel_lookup_gated_ns | 1.032958 | 1.050346 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 0.01% | parallel_hash_lookup_end_to_end_ns | 0.905664 | 0.933817 | 3 / 0 / 0 / 0 |
| 33554432 | 24 | 0.01% | parallel_hash_lookup_gated_ns | 0.899089 | 0.931704 | 3 / 0 / 0 / 0 |
| 33554432 | 24 | 0.01% | parallel_lookup_end_to_end_ns | 0.877122 | 0.893729 | 3 / 0 / 0 / 0 |
| 33554432 | 24 | 0.01% | parallel_lookup_gated_ns | 0.867313 | 0.888571 | 3 / 0 / 0 / 0 |
| 33554432 | 24 | 0.1% | parallel_hash_lookup_end_to_end_ns | 1.056426 | 1.075211 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 0.1% | parallel_hash_lookup_gated_ns | 1.063326 | 1.083291 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 0.1% | parallel_lookup_end_to_end_ns | 1.029513 | 1.049094 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 0.1% | parallel_lookup_gated_ns | 1.033506 | 1.060244 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 1% | parallel_hash_lookup_end_to_end_ns | 0.992193 | 1.025466 | 2 / 1 / 0 / 0 |
| 33554432 | 24 | 1% | parallel_hash_lookup_gated_ns | 0.980802 | 1.030647 | 2 / 1 / 0 / 0 |
| 33554432 | 24 | 1% | parallel_lookup_end_to_end_ns | 1.030461 | 1.049025 | 0 / 3 / 0 / 0 |
| 33554432 | 24 | 1% | parallel_lookup_gated_ns | 1.032958 | 1.050346 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 0.01% | parallel_hash_lookup_end_to_end_ns | 0.905664 | 0.933817 | 3 / 0 / 0 / 0 |
| 33554432 | 32 | 0.01% | parallel_hash_lookup_gated_ns | 0.899089 | 0.931704 | 3 / 0 / 0 / 0 |
| 33554432 | 32 | 0.01% | parallel_lookup_end_to_end_ns | 0.911137 | 0.914485 | 3 / 0 / 0 / 0 |
| 33554432 | 32 | 0.01% | parallel_lookup_gated_ns | 0.904349 | 0.909855 | 3 / 0 / 0 / 0 |
| 33554432 | 32 | 0.1% | parallel_hash_lookup_end_to_end_ns | 1.056426 | 1.075211 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 0.1% | parallel_hash_lookup_gated_ns | 1.063326 | 1.083291 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 0.1% | parallel_lookup_end_to_end_ns | 1.029513 | 1.049094 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 0.1% | parallel_lookup_gated_ns | 1.033506 | 1.060244 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 1% | parallel_hash_lookup_end_to_end_ns | 0.992193 | 1.025466 | 2 / 1 / 0 / 0 |
| 33554432 | 32 | 1% | parallel_hash_lookup_gated_ns | 0.980802 | 1.030647 | 2 / 1 / 0 / 0 |
| 33554432 | 32 | 1% | parallel_lookup_end_to_end_ns | 1.030461 | 1.049025 | 0 / 3 / 0 / 0 |
| 33554432 | 32 | 1% | parallel_lookup_gated_ns | 1.032958 | 1.050346 | 0 / 3 / 0 / 0 |

## Actual public native APIs

| Matched pair | Metric | Wins | Losses | Ties | Minimum ratio | Maximum ratio |
|---|---|---:|---:|---:|---:|---:|
| FourSectorRange12BloomFilter / Split64BloomFilter | allocate_insert_t1_ns | 0 | 12 | 0 | 1.345884 | 2.091054 |
| FourSectorRange12BloomFilter / Split64BloomFilter | allocate_insert_t8_ns | 1 | 11 | 0 | 0.665801 | 1.764328 |
| FourSectorRange12BloomFilter / Split64BloomFilter | insert_t1_ns | 0 | 12 | 0 | 1.379987 | 2.219155 |
| FourSectorRange12BloomFilter / Split64BloomFilter | insert_t8_ns | 1 | 11 | 0 | 0.635005 | 1.758389 |
| FourSectorRange12BloomFilter / Split64BloomFilter | lookup_t1_ns | 11 | 1 | 0 | 0.728961 | 1.005706 |
| FourSectorRange12BloomFilter / Split64BloomFilter | lookup_t8_ns | 10 | 2 | 0 | 0.708602 | 1.008597 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | allocate_insert_t1_ns | 0 | 18 | 0 | 1.257343 | 1.959228 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | allocate_insert_t8_ns | 0 | 18 | 0 | 1.040570 | 1.730347 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | insert_t1_ns | 0 | 18 | 0 | 1.278582 | 2.063005 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | insert_t8_ns | 0 | 18 | 0 | 1.033433 | 1.751448 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | lookup_t1_ns | 18 | 0 | 0 | 0.719348 | 0.949788 |
| FourSectorRange12BloomFilter / Split64RangeBloomFilter | lookup_t8_ns | 18 | 0 | 0 | 0.719014 | 0.970976 |
| Split64RangeBloomFilter / Split64BloomFilter | allocate_insert_t1_ns | 0 | 12 | 0 | 1.026420 | 1.101606 |
| Split64RangeBloomFilter / Split64BloomFilter | allocate_insert_t8_ns | 6 | 6 | 0 | 0.637680 | 1.019639 |
| Split64RangeBloomFilter / Split64BloomFilter | insert_t1_ns | 0 | 12 | 0 | 1.042795 | 1.105546 |
| Split64RangeBloomFilter / Split64BloomFilter | insert_t8_ns | 7 | 5 | 0 | 0.608828 | 1.020545 |
| Split64RangeBloomFilter / Split64BloomFilter | lookup_t1_ns | 1 | 11 | 0 | 0.995570 | 1.069510 |
| Split64RangeBloomFilter / Split64BloomFilter | lookup_t8_ns | 2 | 10 | 0 | 0.931761 | 1.063438 |

These252 same-byte comparisons are unconditional performance observations. Their per-seed and worst-of-three quality endpoints are retained alongside each row; a fast but quality-ineligible construction does not become a qualified win.144 separate T8/T1 ratios preserve every actual-native scaling loss. Allocation-plus-insertion contains the insertion interval from the same build; those measurements are dependent. External serial construction is not included in a parallel-build victory panel.

Range/K12 retain a copied serial bitmap during validation/timing; Split64 has no public bitmap copy. Requested auxiliary buffers and actual partition scratch remain in every public row. This is a cross-family working-set difference, not a bitmap-cap charge; within a family T1/T8 uses the same auxiliary storage.

## Quality failures and limits

| Keys | API | Actual bytes | Seed | False positives / held-out negatives | Wilson upper % | Failed ceiling(s) |
|---:|---|---:|---:|---|---:|---|
| 65536 | ByteSplitBloomFilter | 131072 | 5357122369631638320 | 369090 / 67108864 | 0.551759235 | 0.1%, 0.01% |
| 65536 | FourSectorRange12BloomFilter | 131072 | 5357122369631638320 | 86979 / 67108864 | 0.130472453 | 0.1%, 0.01% |
| 65536 | FastFilterFixed32 | 196608 | 5357122369631638320 | 10289 / 67108864 | 0.015630905 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 114688 | 5357122369631638320 | 578867 / 67108864 | 0.864794327 | 0.1%, 0.01% |
| 65536 | FastFilterSimdBlock | 131072 | 5357122369631638320 | 87491 / 67108864 | 0.131237918 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16 | 262144 | 5357122369631638320 | 37139 / 67108864 | 0.055906971 | 0.01% |
| 33554432 | Boost192Multi64K8 | 67108863 | 5357122369631638320 | 61169 / 67108864 | 0.091873773 | 0.01% |
| 33554432 | FourSectorRange12BloomFilter | 67108864 | 5357122369631638320 | 86256 / 67108864 | 0.129391518 | 0.1%, 0.01% |
| 33554432 | Boost192Multi32K8 | 67108863 | 5357122369631638320 | 88476 / 67108864 | 0.132710522 | 0.1%, 0.01% |
| 65536 | FastFilterFixed64 | 131072 | 5357122369631638320 | 60521 / 67108864 | 0.090904347 | 0.01% |
| 33554432 | Split64RangeBloomFilter | 67108864 | 5357122369631638320 | 61483 / 67108864 | 0.092343519 | 0.01% |
| 33554432 | Boost192Multi32K8 | 50331647 | 5357122369631638320 | 364323 / 67108864 | 0.544644451 | 0.1%, 0.01% |
| 33554432 | FourSectorBloomFilter | 67108864 | 5357122369631638320 | 65444 / 67108864 | 0.098268799 | 0.01% |
| 65536 | FourSectorBloomFilter | 131072 | 5357122369631638320 | 64771 / 67108864 | 0.097262105 | 0.01% |
| 65536 | FastFilterFixed32 | 163840 | 5357122369631638320 | 27119 / 67108864 | 0.040894186 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 262144 | 5357122369631638320 | 37139 / 67108864 | 0.055906971 | 0.01% |
| 65536 | Split64BloomFilter | 131072 | 5357122369631638320 | 62545 / 67108864 | 0.093932241 | 0.01% |
| 65536 | ByteSplitBloomFilter | 262144 | 5357122369631638320 | 37780 / 67108864 | 0.056866967 | 0.01% |
| 33554432 | FastPatternBF | 67108864 | 5357122369631638320 | 136479 / 67108864 | 0.204450264 | 0.1%, 0.01% |
| 65536 | Split64RangeBloomFilter | 131072 | 5357122369631638320 | 60521 / 67108864 | 0.090904347 | 0.01% |
| 33554432 | Boost192Multi32K8 | 83886079 | 5357122369631638320 | 28340 / 67108864 | 0.042724319 | 0.01% |
| 65536 | FastFilterSimdBlockSingleV1 | 131072 | 5357122369631638320 | 87491 / 67108864 | 0.131237918 | 0.1%, 0.01% |
| 33554432 | Split64BloomFilter | 67108864 | 5357122369631638320 | 60853 / 67108864 | 0.091401031 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 131072 | 5357122369631638320 | 366633 / 67108864 | 0.548092153 | 0.1%, 0.01% |
| 65536 | FastPatternBF | 131072 | 5357122369631638320 | 136273 / 67108864 | 0.204142488 | 0.1%, 0.01% |
| 33554432 | ByteSplitBloomFilter | 67108864 | 5357122369631638320 | 368542 / 67108864 | 0.550941345 | 0.1%, 0.01% |
| 65536 | FastFilterFixed32Bulk | 196608 | 5357122369631638320 | 10289 / 67108864 | 0.015630905 | 0.01% |
| 65536 | FastFilterFixed16 | 131072 | 5357122369631638320 | 366633 / 67108864 | 0.548092153 | 0.1%, 0.01% |
| 33554432 | ByteSplitBloomFilter | 134217728 | 5357122369631638320 | 37805 / 67108864 | 0.056904408 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 131072 | 10870879273875959492 | 367642 / 67108864 | 0.549598092 | 0.1%, 0.01% |
| 33554432 | FourSectorBloomFilter | 67108864 | 10870879273875959492 | 65715 / 67108864 | 0.098674163 | 0.01% |
| 65536 | FastFilterFixed32 | 163840 | 10870879273875959492 | 28761 / 67108864 | 0.043355294 | 0.01% |
| 33554432 | Split64RangeBloomFilter | 67108864 | 10870879273875959492 | 60861 / 67108864 | 0.091412999 | 0.01% |
| 33554432 | Boost192Multi32K8 | 50331647 | 10870879273875959492 | 364094 / 67108864 | 0.544302665 | 0.1%, 0.01% |
| 65536 | Split64RangeBloomFilter | 131072 | 10870879273875959492 | 59684 / 67108864 | 0.089652141 | 0.01% |
| 65536 | FastFilterSimdBlockSingleV1 | 131072 | 10870879273875959492 | 87913 / 67108864 | 0.131868824 | 0.1%, 0.01% |
| 65536 | ByteSplitBloomFilter | 262144 | 10870879273875959492 | 37045 / 67108864 | 0.055766188 | 0.01% |
| 33554432 | ByteSplitBloomFilter | 134217728 | 10870879273875959492 | 37638 / 67108864 | 0.056654304 | 0.01% |
| 65536 | FourSectorBloomFilter | 131072 | 10870879273875959492 | 64972 / 67108864 | 0.097562769 | 0.01% |
| 65536 | FastFilterFixed16 | 262144 | 10870879273875959492 | 38430 / 67108864 | 0.057840401 | 0.01% |
| 65536 | FastFilterFixed64 | 131072 | 10870879273875959492 | 59684 / 67108864 | 0.089652141 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 262144 | 10870879273875959492 | 38430 / 67108864 | 0.057840401 | 0.01% |
| 33554432 | FourSectorRange12BloomFilter | 67108864 | 10870879273875959492 | 85917 / 67108864 | 0.128884685 | 0.1%, 0.01% |
| 33554432 | Boost192Multi64K8 | 67108863 | 10870879273875959492 | 60945 / 67108864 | 0.091538665 | 0.01% |
| 65536 | FastFilterSimdBlock | 131072 | 10870879273875959492 | 87913 / 67108864 | 0.131868824 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 114688 | 10870879273875959492 | 577389 / 67108864 | 0.862589134 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16 | 131072 | 10870879273875959492 | 367642 / 67108864 | 0.549598092 | 0.1%, 0.01% |
| 65536 | Split64BloomFilter | 131072 | 10870879273875959492 | 60829 / 67108864 | 0.091365126 | 0.01% |
| 65536 | ByteSplitBloomFilter | 131072 | 10870879273875959492 | 367136 / 67108864 | 0.548842884 | 0.1%, 0.01% |
| 65536 | FastFilterFixed32Bulk | 196608 | 10870879273875959492 | 10522 / 67108864 | 0.015981436 | 0.01% |
| 33554432 | FastPatternBF | 67108864 | 10870879273875959492 | 135624 / 67108864 | 0.203172840 | 0.1%, 0.01% |
| 65536 | FourSectorRange12BloomFilter | 131072 | 10870879273875959492 | 85493 / 67108864 | 0.128250765 | 0.1%, 0.01% |
| 33554432 | Split64BloomFilter | 67108864 | 10870879273875959492 | 61282 / 67108864 | 0.092042822 | 0.01% |
| 33554432 | ByteSplitBloomFilter | 67108864 | 10870879273875959492 | 369184 / 67108864 | 0.551899530 | 0.1%, 0.01% |
| 33554432 | Boost192Multi32K8 | 83886079 | 10870879273875959492 | 28275 / 67108864 | 0.042626897 | 0.01% |
| 65536 | FastFilterFixed32 | 196608 | 10870879273875959492 | 10522 / 67108864 | 0.015981436 | 0.01% |
| 33554432 | Boost192Multi32K8 | 67108863 | 10870879273875959492 | 88464 / 67108864 | 0.132692582 | 0.1%, 0.01% |
| 65536 | FastPatternBF | 131072 | 10870879273875959492 | 134810 / 67108864 | 0.201956663 | 0.1%, 0.01% |
| 65536 | FourSectorBloomFilter | 131072 | 2465277812845611592 | 65257 / 67108864 | 0.097989081 | 0.01% |
| 33554432 | FastPatternBF | 67108864 | 2465277812845611592 | 136050 / 67108864 | 0.203809312 | 0.1%, 0.01% |
| 33554432 | Boost192Multi32K8 | 67108863 | 2465277812845611592 | 88201 / 67108864 | 0.132299392 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 262144 | 2465277812845611592 | 38630 / 67108864 | 0.058139911 | 0.01% |
| 33554432 | Split64RangeBloomFilter | 67108864 | 2465277812845611592 | 60867 / 67108864 | 0.091421975 | 0.01% |
| 33554432 | Boost192Multi32K8 | 50331647 | 2465277812845611592 | 363773 / 67108864 | 0.543823567 | 0.1%, 0.01% |
| 65536 | FastPatternBF | 131072 | 2465277812845611592 | 136835 / 67108864 | 0.204982147 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16 | 131072 | 2465277812845611592 | 365995 / 67108864 | 0.547139932 | 0.1%, 0.01% |
| 33554432 | FourSectorRange12BloomFilter | 67108864 | 2465277812845611592 | 85920 / 67108864 | 0.128889170 | 0.1%, 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 131072 | 2465277812845611592 | 365995 / 67108864 | 0.547139932 | 0.1%, 0.01% |
| 65536 | ByteSplitBloomFilter | 262144 | 2465277812845611592 | 38048 / 67108864 | 0.057268327 | 0.01% |
| 33554432 | Boost192Multi64K8 | 67108863 | 2465277812845611592 | 60994 / 67108864 | 0.091611970 | 0.01% |
| 65536 | Split64RangeBloomFilter | 131072 | 2465277812845611592 | 60624 / 67108864 | 0.091058439 | 0.01% |
| 33554432 | ByteSplitBloomFilter | 134217728 | 2465277812845611592 | 37989 / 67108864 | 0.057179968 | 0.01% |
| 65536 | FastFilterSimdBlockSingleV1 | 131072 | 2465277812845611592 | 88242 / 67108864 | 0.132360688 | 0.1%, 0.01% |
| 33554432 | ByteSplitBloomFilter | 67108864 | 2465277812845611592 | 369409 / 67108864 | 0.552235342 | 0.1%, 0.01% |
| 65536 | FourSectorRange12BloomFilter | 131072 | 2465277812845611592 | 87570 / 67108864 | 0.131356027 | 0.1%, 0.01% |
| 33554432 | Split64BloomFilter | 67108864 | 2465277812845611592 | 61293 / 67108864 | 0.092059278 | 0.01% |
| 65536 | FastFilterFixed16 | 262144 | 2465277812845611592 | 38630 / 67108864 | 0.058139911 | 0.01% |
| 65536 | FastFilterFixed16SingleV1 | 114688 | 2465277812845611592 | 587989 / 67108864 | 0.878404377 | 0.1%, 0.01% |
| 65536 | FastFilterFixed64 | 131072 | 2465277812845611592 | 60624 / 67108864 | 0.091058439 | 0.01% |
| 65536 | FastFilterFixed32 | 196608 | 2465277812845611592 | 11025 / 67108864 | 0.016738040 | 0.01% |
| 65536 | Split64BloomFilter | 131072 | 2465277812845611592 | 61478 / 67108864 | 0.092336039 | 0.01% |
| 33554432 | FourSectorBloomFilter | 67108864 | 2465277812845611592 | 65749 / 67108864 | 0.098725021 | 0.01% |
| 65536 | FastFilterSimdBlock | 131072 | 2465277812845611592 | 88242 / 67108864 | 0.132360688 | 0.1%, 0.01% |
| 33554432 | Boost192Multi32K8 | 83886079 | 2465277812845611592 | 28153 / 67108864 | 0.042444043 | 0.01% |
| 65536 | FastFilterFixed32Bulk | 196608 | 2465277812845611592 | 11025 / 67108864 | 0.016738040 | 0.01% |
| 65536 | FastFilterFixed32 | 163840 | 2465277812845611592 | 28658 / 67108864 | 0.043200925 | 0.01% |
| 65536 | ByteSplitBloomFilter | 131072 | 2465277812845611592 | 372373 / 67108864 | 0.556659094 | 0.1%, 0.01% |

Every query/build trial vector remains in the committed raw data; all optional, production and external outcomes remain separate. Three already-seen constructions, repeated metric/cap views and within-process repetitions do not support an independent significance or fresh-quality claim. Wilson endpoints are pointwise, not simultaneous guarantees. The external union is the fixed strongest union from the two committed prior panels, not every library/configuration. These observations do not establish universal fastest performance or automatically promote a new kernel.
