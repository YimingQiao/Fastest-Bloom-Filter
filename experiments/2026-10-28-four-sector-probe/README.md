# FourSector short-batch query experiments

These optional experiments retain the exact bitmap, masks, allocation, insertion
order, and false-positive behavior of the preceding `FourSector16K8` prototype.
They modify query scheduling only. Neither the native C++ nor Rust implementation
is changed here. This is a comparison with a frozen version of our own prototype,
not an external-baseline or global-fastest claim.

`baseline_snapshot.h` is the original prepared-insertion/masked-tail FourSector
header. `compare_benchmark_snapshot.cpp` freezes the shared harness, including its
common hash, timing boundaries, batch boundaries, and full-output checksum.
`probe_filter.h` contains the following alternatives:

| Name | Short-batch policy (4–63 queries) |
| --- | --- |
| Group4 | Four keys, four sectors each, in one 16-lane gather |
| Group8 | Eight keys in two 16-lane gathers, two sectors per gather |
| Prefetch | Original 16-key layout; prefetch every input's cache line before querying when bitmap >2 MiB |
| Group4Prefetch / Group8Prefetch | Combine the respective grouping with that batch prefetch |
| Hybrid | Group8 for 4–8 keys; original 16-key layout for 9–63; batch prefetch only above 2 MiB |
| HybridWide | Group8 for 4–8 keys or any short batch above 2 MiB; otherwise original layout; same prefetch |

All candidates retain scalar handling below four queries and the original kernel
for batches of at least 64. Grouped tails use masked input loads, gathers, and
output stores. The strategy table concerns query behavior; all use unchanged
prepared insertion. Prefetch adds no persistent storage or per-call allocation.

## Correctness

`check.cpp` compares every query output with an independently scalar-built frozen
filter, for bitmap sizes below and above the 2 MiB threshold. It covers every
inserted key, mixed inserted/absent probes, query lengths 0–131, input offsets 0–7,
output guards, duplicate inserts, and batch lengths 1/3/4/7/8/9/15/16/17/31/32/33/63/
64/4096. Optimized and ASan/UBSan runs pass. `correctness-metadata.json` records
compiler, commands, CPU5, and source hashes. Correctness runs were not timed.

The timing runner also requires every candidate's full-output checksum,
false-positive count, allocation, and hit/miss counts to equal the frozen filter.
Initial screen rows were checked with the same assertions after collection.

## Initial screen

`screen/timing.csv` contains 54 rows: three key counts (2^16, 2^20, 2^24), actual
16 bits/key, batches 8/31/4096, seed42, 50% hits, three repetitions and 2^20 timed
queries. All filters run in the same process, with randomized implementation
order. Timing was pinned to CPU3, socket1; the CPU2/socket0 production comparison
was separate. Clang23 uses `-O3 -march=native -fno-strict-aliasing`.
`screen/metadata.json` contains commands, binary/source hashes, and CPU details.
The initial source files are retained as `*_screen_snapshot.*`.

At 16M keys (32 MiB bitmap), Group8Prefetch reduced hash+lookup from 9.850 to
5.379ns/key for batch8, and from 5.536 to 3.968ns/key for batch31. Pure lookup
improved by about 1.30× and 1.15×. Prefetch alone improved batch31 hash+lookup by
1.38×. At small/resident sizes, grouped gathers improved batch8 pure lookup but
regressed batch31, which motivated the two hybrid policies.

These are screening results from one seed. Grouping alone did not fix batch8
hash+lookup at resident sizes, and neither grouping nor prefetch affects the
long-batch algorithm. The confirmation below uses additional seeds and retains
both query-only and hash+query measurements.

## Reproduction

```sh
cmake -S experiments/2026-10-28-four-sector-probe -B build/four-sector-probe \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build/four-sector-probe -j1
python3 experiments/2026-10-28-four-sector-probe/run_speed.py \
  --output-dir build/four-sector-probe-new-results --cpu 3 \
  --key-powers 16,20,24 --requested-bpk 8 --hits 50 --seeds 43,731 \
  --batches 8,31,4096 --query-power 20 --repeats 5 \
  --filters FourSectorFrozen,FourSectorPrefetch,FourSectorHybrid,FourSectorHybridWide
```

Use a new output directory and a CPU/socket without competing work. The recorded
speed is specific to this machine, compiler, key distribution and working set.

## Confirmation and recommendation

`confirmation/timing.csv` contains 72 rows from seeds43/731, 50% hits, five
repetitions and otherwise the same workload grid. `extreme-confirmation-clean`
adds 24 rows at seeds8675309, 0%/100% hits, 2^16/2^24 keys and batches8/31. Every
checksum, FP count and allocation matched. A preceding extreme sweep overlapped
a CPU3 build/test window; its **entire** CSV is marked rejected and renamed
`extreme-confirmation/timing.csv.rejected`. No conclusion uses it.

The final variants guard full eight-key input groups with an unmasked load;
partial groups retain masked loads. This was measured explicitly and did not
resolve resident batch8 hash+query overhead. The following ratios are medians
across seeds43/731 for `HybridWideUnmasked`; a value above 1 is faster than frozen:

| Bitmap | Query batch | Query-only speedup | Hash+query speedup |
| --- | --- | --- | --- |
| 128 KiB | 8 | 1.56× | 1.00× |
| 128 KiB | 31 | 1.00× | 0.97× |
| 128 KiB | 4096 | 1.01× | 1.01× |
| 2 MiB | 8 | 1.33× | 1.02× |
| 2 MiB | 31 | 1.01× | 1.00× |
| 2 MiB | 4096 | 0.99× | 1.00× |
| 32 MiB | 8 | 1.19× | 1.87× |
| 32 MiB | 31 | 1.16× | 1.41× |
| 32 MiB | 4096 | 1.00× | 1.00× |

At 32 MiB, the separate all-miss/all-hit confirmation measured 1.858–1.862×
hash+query speedup at batch8 and 1.405–1.406× at batch31. The 128 KiB batch31
hash+query regression remained about 2.5–3.0%. `HybridUnmasked`, which keeps the
original layout for every batch above 8, reduces that resident regression to
about 2% but gives a smaller large batch31 improvement (~1.38×).

The recommended next integration candidate is `HybridWideUnmasked`, with those
tradeoffs explicit. [The native patch and Rust mapping plan](integration.md) are
reviewable and preserve the current production source. This selection is specific
to the measured uniform-hash workloads; neither FPR nor filter memory changed.
