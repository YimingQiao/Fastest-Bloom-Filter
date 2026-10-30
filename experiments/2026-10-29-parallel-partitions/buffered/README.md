# Ordinary 64-byte buffered scatter

This is a separate follow-up to the frozen unbuffered partition experiment. Native
Bloom filters, hash/partition mapping, worker policy and bitmap ownership are
unchanged. The original archive and executable remain intact. No non-temporal
stores, explicit prefetch policy changes or host performance settings are used.

Each input worker keeps a 64-byte buffer and a pending-count byte per partition.
Eight hashes are copied to a cache-line-aligned destination at once. The count pass
rounds each nonempty worker/partition segment up to eight hashes. A final partial
buffer repeats its last actual hash to fill the segment; empty segments write
nothing. The repeated hash already belongs to the same partition, so idempotent OR
insertion preserves the exact bitmap and output. One worker still owns every
complete bitmap line during insertion. Large padded partitions are submitted in
bounded chunks of at most 2^30 hashes, safely below the u32 API limit.

The staging vector uses aligned typed storage and a custom trivial default
constructor to begin object lifetimes without an added zero-fill pass. Every byte
is written before it is read. All buffers/staging are released inside the build
timer, and all padded hashes are processed inside the insertion phase.

For segment counts C[w,p], the exact padded input size is
`Npad = sum(round_up(C[w,p], 8))`, with empty segments contributing zero. The
reported actual scratch includes 8*Npad plus histogram rows, partition starts,
64*W*P buffer bytes, and cache-line-padded pending-byte rows. The conservative
pre-build bound uses `N + 7*min(N,W*P)` hashes; both actual and bound are reported.
Allocator metadata, OS thread stacks and the original thread-helper handle
vectors remain excluded consistently with the frozen baseline.

`build_scratch_bytes` reports the actual peak allocated capacity for buffered
rows, while `scratch_upper_bytes` gives the pre-build bound. `padded_hashes` and
`padding_hashes` disclose duplicate work. Existing unbuffered rows retain exact
original accounting. Empty insertion allocates no scratch. All size rounding,
metadata multiplication and prefix accumulation use checked arithmetic.

The common benchmark still times the complete build. Its allocation phase now
includes both initial metadata/buffer allocation and staging allocation after the
prefix scan. Count/prefix/scatter/insert/release phases are separately recorded;
no scratch preparation or cleanup is moved outside the outer timer. All 27 rows
(native serial/original/instrumented, three unbuffered targets and three buffered
targets per layout) validate against a canonical serial output vector, with every
inserted key checked outside timing.

Correctness includes exact independent padded-segment counts, actual allocation
and upper bounds, one-line skew, duplicates, empty segments/batches, full outputs,
output guards and metadata overflow. Native, sanitizer and thread-sanitizer status
is recorded in `validation.json` after completion.

All socket 1 heavy commands hold the shared lock for the complete command/matrix:

```sh
flock /tmp/fastest-bf-socket1.lock cmake -S experiments/2026-10-29-parallel-partitions/buffered -B build/parallel-partitions-buffered -DCMAKE_CXX_COMPILER=clang++
flock /tmp/fastest-bf-socket1.lock taskset -c 3 cmake --build build/parallel-partitions-buffered --parallel 1
flock /tmp/fastest-bf-socket1.lock taskset -c 3 ctest --test-dir build/parallel-partitions-buffered --output-on-failure
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-parallel-partitions/buffered/run.py --output /tmp/buffered-screen --key-powers 25 --requested-bpk 16 --threads 4,8 --repeats 3 --seeds 731 --query-power 20
```

No production promotion is implied. Whole-build performance against the actual
original and same-partition unbuffered controls decides whether buffering helps.

## Screen result: reject buffering

The single-seed screen uses 2^25 inserted keys, a 128 MiB bitmap (actual 32
bits/key), 2^20 queries with 50% hits, three repeats, and seed 731. Each case
contains all 27 rows in one executable with randomized filter order. The complete
matrix held the socket 1 lock; W=4 uses CPUs 3,5,7,9 and W=8 adds 11,13,15,17,
with memory bound to NUMA node 1. The host is Intel Xeon Platinum 8474C, 2 MiB L2
per core and 97.5 MiB L3 per socket. Clang 23.0.0 builds with
`-O3 -DNDEBUG -march=native -std=gnu++17`; exact version, commands, source/binary
SHA-256, topology and affinity are in `screen/metadata.json`. There was no source
drift. All 54 rows passed full-output, all-inserted, checksum, FPR and bitmap-size
checks against the canonical family reference.

The fastest buffered target in each row is 256 KiB (P=512). Even selecting the
best measured buffered target, the complete build is materially slower:

| Layout | Workers | Original ns/key | Buffered ns/key | Same-P plain ns/key | Buffered speedup vs original |
|---|---:|---:|---:|---:|---:|
| FastPattern | 4 | 2.845 | 4.360 | 2.672 | 0.652x |
| FourSector | 4 | 3.010 | 4.687 | 3.043 | 0.642x |
| Split64 | 4 | 2.770 | 4.474 | 2.658 | 0.619x |
| FastPattern | 8 | 1.746 | 3.136 | 2.120 | 0.557x |
| FourSector | 8 | 1.809 | 3.293 | 2.310 | 0.549x |
| Split64 | 8 | 1.722 | 3.148 | 2.128 | 0.547x |

The phase measurements locate the loss in scatter: buffered scatter spans
2.59–5.74 ns/key versus 1.49–1.67 for plain scatter with the same partition count.
Insertion remains approximately unchanged. Padding adds 1,760–14,392 hashes
(0.0052%–0.0429%); explicit extra scratch relative to the same-P plain variant
is below 0.4 MiB. This is evidence that this buffering implementation is slower,
not proof of a particular cache or branch mechanism. No hardware counters were
collected. No non-temporal-store variant was mixed into this experiment.

The earlier limited W=4 gain from plain cache partitioning is reproduced in the
controls; buffering does not improve it. This is a rejection screen, with no
held-out performance or production-promotion claim. `screen/timing.csv` retains
all raw trial timings and `screen/summary.json` reports each target separately.
