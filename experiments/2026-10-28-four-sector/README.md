# Four-sector prototype

This optional prototype probes four distinct words in a single 64-byte cache line.
It includes a scalar accuracy oracle and an AVX-512 implementation, and makes no
changes to the native core. Its address/mask independence assumes at most 2^26
32-bit words (256 MiB of bitmap storage).

For `hi = hash >> 32`, the word indices are:

```cpp
a = hi & word_mask;
b = (a ^ 4) ^ ((hi >> 26) & 3);
c = (a ^ 8) ^ ((hi >> 28) & 3);
d = (a ^ 12) ^ ((hi >> 30) & 3);
```

Every index lies in a different four-word quarter of the same line. The first
index uses at most 26 high-hash bits; the six offset bits are disjoint. Four bytes
of the low hash select masks independently: each byte supplies a 3-bit dictionary
index and a 5-bit rotation. The masks use eight canonical cyclic patterns with
two or three bits. `generate.cpp` extends the exact orbit-compressed generator
from the preceding experiment to two-bit masks and selects eight entries.

The alternatives are four two-bit masks (K=8), two two-bit plus two three-bit
masks (K=10), and four three-bit masks (K=12). All hash fields and bitmap sizes
are identical across alternatives. Active dictionary storage is 32 bytes for
K=8/K=12 or 64 bytes for K=10, outside the bitmap payload metric.

## Eight-entry dictionary screen

2^20 inserted unique keys, 2^24 disjoint negative keys per seed, seeds 42/43/44.
Every inserted key and output buffer boundaries are checked before accepting a
row. **All runs passed with zero false negatives.** Each pooled table entry has
50,331,648 negative queries; raw counts and per-case Wilson 95% upper bounds are
in [screen.csv](screen.csv), commands and source hashes in [metadata.json](metadata.json).

| Total bits set | 8 actual bits/key | 16 actual bits/key | 32 actual bits/key |
| --- | --- | --- | --- |
| 8 | 3.107967% (1,564,291/50,331,648) | 0.109086% (54,905/50,331,648) | 0.002422% (1,219/50,331,648) |
| 10 | 4.284712% (2,156,566/50,331,648) | 0.109822% (55,275/50,331,648) | 0.001526% (768/50,331,648) |
| 12 | 6.173537% (3,107,243/50,331,648) | 0.135656% (68,278/50,331,648) | 0.001538% (774/50,331,648) |

At 16 actual bits/key, K=8/K=10 nearly halve the two-sector design's FPR, but
remain slightly **above** the 0.1% target. At 32 actual bits/key the observed
FPR drops substantially. At 8 bits/key these variants lose accuracy. More probes
can cost query/insertion throughput, so an accuracy gain alone is not grounds
for selecting this design. The following sections record the larger dictionary, held-out confirmation,
and optional SIMD implementation. None of these results promote a native default.

```sh
python3 experiments/2026-10-28-four-sector/run.py \
  --output-dir build/four-sector-reproduction --cpu 3
```

The runner verifies generated masks against the saved files, compiles the scalar
oracle, and records a new accuracy sweep. Use a new output directory for each run.


## Sixteen-entry dictionaries

The larger dictionary uses `code = ror32(lo, 8 * sector)`, a four-bit index
`code & 15`, and a five-bit rotation `(code >> 4) & 31`. Each adjacent pair of
nine-bit codes shares one hash bit, including the wrap from the last sector to
the first. **These four masks are correlated.** All address bits remain disjoint
from the mask bits. K=9 sets two bits in the first three sectors and three bits
in the last; K=8/K=10/K=12 retain their original sector allocations.

[extended-screen.csv](extended-screen.csv) records 2^20 inserted keys and 2^24
negative queries for each seed 42/43/44, with 50,331,648 negatives per pooled cell.
[extended-metadata.json](extended-metadata.json) records commands and source hashes.
All inserted-key and output checks passed.

| Total bits set | 8 actual bits/key | 16 actual bits/key | 32 actual bits/key |
| --- | --- | --- | --- |
| 8 | 2.997480% | 0.097775% | 0.001977% |
| 9 | 3.529876% | 0.097752% | 0.001468% |
| 10 | 4.228489% | 0.103819% | 0.001423% |
| 12 | 6.104084% | 0.128067% | 0.001220% |

The eight-entry K=9 control measured 0.104578% at 16 actual bits/key. The 16-entry
K=8/K=9 pooled estimates fell below 0.1%, but seed 43's individual Wilson 95%
upper endpoints were **0.100514% and 0.100189%**, respectively. Those cases did
not qualify under a confidence-bound threshold. They remain in the data.

K=8/K=9 were then selected for a separate accuracy confirmation with seeds 731,
20261028, and 8675309, at both 2^16 and 2^20 inserted keys, using 2^26 negatives
per seed. Every one of the 12 cases passed the 0.1% upper-bound threshold;
[heldout.csv](heldout.csv) contains their exact counts. All inserted keys passed.
The pooled denominator for each row below is 201,326,592 negative queries.

| Keys | Bits set | Pooled FPR | Largest per-seed Wilson 95% upper endpoint |
| --- | --- | --- | --- |
| 65,536 | 8 | 0.096751% | 0.097968% |
| 65,536 | 9 | 0.096495% | 0.097397% |
| 1,048,576 | 8 | 0.097683% | 0.098788% |
| 1,048,576 | 9 | 0.098018% | 0.099269% |

The margin is narrow, particularly for K=9. These samples cover one uniform-hash
workload at two sizes, not every key distribution or size. Increasing query
counts reduces sampling uncertainty; it does not prove a universal FPR bound.
K=8 uses a single active 64-byte dictionary; mixed K=9/K=10 use two (128 bytes),
and K=12 uses one (64 bytes). This static storage is outside the bitmap metric.

To reproduce a new 16-entry screen or one held-out size:

```sh
python3 experiments/2026-10-28-four-sector/run.py \
  --output-dir build/four-sector16-reproduction --cpu 3 --entries 16 --modes 8,9,10,12
python3 experiments/2026-10-28-four-sector/run.py \
  --output-dir build/four-sector16-heldout-20 --cpu 3 --entries 16 --modes 8,9 \
  --key-power 20 --query-power 26 --requested-bpk 8 --seeds 731,20261028,8675309
```

## SIMD and correctness

The optional AVX-512 query processes 16 hashes with four gathers. Dictionary
selection uses register permutations and variable rotations. Partial blocks use
masked hash loads, gathers, and output stores; batches below four use the scalar
oracle. For bitmaps above 2 MiB it prefetches the future cache line 64 keys ahead.

Insertion prepares four keys as 16 vector lanes, one lane per sector, then writes
16 sequential scalar ORs. **It never scatters competing read-modify-write results**:
keys sharing a word retain every bit. The scalar-build alias uses the same query
kernel and bitmap for a direct insertion comparison. There is no heap scratch;
the prepared index/mask arrays use 128 bytes of stack per preparation group.

`check.cpp` compares complete outputs and no-false-negative behavior against a
separately scalar-built bitmap across K=8/9/10/12; sizes below and above the
prefetch threshold; batches 1/3/4/7/8/9/15/16/17/31/64/4096; and overlapping
same-word masks, repeated keys, and incomplete four-key groups. Input tails and
output guards are checked under ASan/UBSan. Both optimized and sanitizer runs pass.

```sh
cmake -S experiments/2026-10-28-four-sector -B build/four-sector \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build/four-sector -j2
build/four-sector/check
python3 experiments/2026-10-28-four-sector/run_speed.py \
  --output-dir build/four-sector-speed-reproduction --cpu 3
```

This executable uses the repository's shared comparison harness and registers
native FastPatternBF, FourSector16K8/K9/K10/K12, Split64P32, and pinned Boost
Multi64K8. The initial SIMD implementation and two preceding scalar sources are
retained as `four_sector_*_snapshot.h` to match the historical source hashes.
The initial `speed-screen` and `speed-confirmation` data include scalar insertion
and scalar residual query tails; later data must be interpreted separately.

## Preliminary same-process timing

[screen](speed-screen/timing.csv) and [confirmation](speed-confirmation/timing.csv)
retain the first implementation, including its slow scalar tails.
[prepared](speed-prepared/timing.csv) and [tail](speed-tail/timing.csv) use prepared
insertion and masked tails. Every corresponding row has exactly the same output
checksum, false-positive count, and allocation before and after optimization.
Each directory includes compiler flags, binary/source hashes, CPU details, and
exact commands. Timings use Clang `-O3 -march=native`, CPU3, randomized filter
order, 2^22 queries, five repetitions, and full-size construction batches.
The measured bitmaps are allocated under the shared memory-ceiling contract;
Boost may allocate up to one word less due to its internal layout.

For actual 16 bits/key, seed 42, 50% hits, query batch 4096, the median lookup
nanoseconds per key were:

| Keys | FourSector16K8 | Split64P32 | Boost Multi64K8 | Native FastPatternBF |
| --- | --- | --- | --- | --- |
| 65,536 | 1.047 | 1.650 | 2.238 | 0.651 |
| 1,048,576 | 1.969 | 1.857 | 2.994 | 1.527 |
| 16,777,216 | 3.722 | 4.006 | 4.618 | 3.540 |

The native filter has a different FPR at this budget (about 0.2%); this table is a
speed comparison, not an equal-FPR ranking. FourSector16K8 wins strongly against
the selected accuracy competitors at 65K keys, is near Split64 at 1M, and wins
pure lookup modestly at 16M. At actual 32 bits/key it also improves accuracy over
the native filter but remains slower than native lookup.

Prepared insertion reduces raw-key hashing+insertion at actual 16 bits/key from
4.583/8.168/12.275ns to 3.712/5.351/5.748ns at those three sizes. Split64 remains
faster at 1.968/2.382/5.154ns. At actual 32 bits/key and 1M keys, enabling the
above 2 MiB prefetch path reduces scalar-build 11.036 ns to prepared 3.851 ns; this
comparison changes both preparation and prefetch behavior, so it does not
isolate either contribution.

The seed 731 confirmation covers 0% and 100% hits, query batches 31 and 4096, and
all three sizes. Masked tails cut batch 31 lookup at 65K from about 2.58 ns to 1.24 ns,
versus Split64's 1.58ns; at 1M they reach 2.06–2.09ns versus 2.34–2.43ns. At16M,
batch 31 **still loses**: 5.10–5.17ns versus 4.92ns for Split64. End-to-end
hashing+lookup loses more there: 6.53–6.54ns versus 4.75–4.79ns. Full 4096 batches
converge to nearly equal end-to-end throughput at 16M despite the pure-lookup win.
These are preliminary single-host screens. Construction speed, small batches,
raw-key hashing, and FPR confidence must remain separate selection criteria.
