# FastPattern small-batch dispatch — frozen result

An early scalar path for `num <= 3` improves the measured single-query cost while
preserving the bitmap, masks, allocation, and larger-batch kernels. The candidate
is [fast_pattern_early.h](fast_pattern_early.h), SHA-256
`222ca117c0528f2335ffac22763118480a8008993b455cc29c59de1d742835ab`.
Its before snapshot is [fast_pattern_before.h](fast_pattern_before.h).
Both copies rename the class to coexist in one benchmark executable.

Only the public `Lookup` changes: before reading `SizeInBytes` or entering the
SIMD dispatcher, queries of length 0–3 run the existing scalar index/mask formula
and return. Sparse/dense table selection, constructor, insertion, prefetch policy,
and every larger-batch kernel remain unchanged. Zero-length input touches no
hash or output element. This is independent of the Split64 experiments.

## Correctness and feature boundaries

[check_fast_small.cpp](check_fast_small.cpp) exposes bitmap words only in its
private test translation unit. It checks **exact equality of all bitmap words**
after construction and verifies that all queries leave both bitmaps unchanged.
It covers empty filters and capacities 1024/65539/1048576; requested 4/8/16 bits/key;
uniform and same-line hashes; query lengths 0–145; exact input tails; and output
guards. The existing broader `check.cpp` also verifies every inserted key and
complete positive/negative answers at batches 1/2/3/4/7/8/15/16/31/4096.

[fast-small-validation.json](fast-small-validation.json) records successful:

- GCC baseline x86-64 with AVX/AVX2/AVX-512 disabled.
- GCC AVX2 with AVX-512 disabled.
- Clang AVX-512F+AVX2 with ASan and UBSan.

All three builds produce `12129348150252803241`. No production source was
modified by these tests. Performance was measured only on the native AVX-512
host; correctness on another backend is not a speed result for that backend.

## Held-out timing

The training screen used seed 42. Confirmation uses previously unselected
seeds 2053 and 4099, 50% hits, 2^22 queries, and randomized same-process filter
order. Small filters use seven repetitions; large filters use five. Columns
below are the median candidate/before time ratios across the two seeds; lower
is faster.

| Keys | Actual bits/key | Query batch | Prehashed lookup | Hashing + lookup |
| --- | --- | --- | --- | --- |
| 65,536 | 16 | 1 | 0.858 | 0.864 |
| 65,536 | 32 | 1 | 0.859 | 0.867 |
| 65,536 | 16 | 3 | 0.924 | 0.967 |
| 65,536 | 32 | 3 | 0.925 | 0.970 |
| 16,777,216 | 16 | 1 | 0.832 | 0.880 |

Batches 8/31/4096 stay near parity: median ratios approximately 0.992–1.011 for
prehashed lookup and 0.990–1.003 for hashing+lookup in these confirmation cases.
Every before/after row matches checksum, false-positive count, and allocation.
The FPR is unchanged; this patch does not make FastPattern qualify for a stricter
FPR target than the existing layout. FastFilter still wins some single-query
comparisons at compatible loose targets.

Raw data and exact commands/source hashes:
[heldout-small](heldout-small/timing.csv),
[heldout-large](heldout-large/timing.csv), and
[focused summary](fast-small-heldout-summary.json).
