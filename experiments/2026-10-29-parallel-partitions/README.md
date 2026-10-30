# More cache partitions than build workers

This isolated experiment tests the cache-miss-cost idea behind the earlier bbtree
analysis: reduce each insertion worker's active bitmap range without adding more
threads. It is a hypothesis, not a speed claim. The native filters are unchanged;
byte-identical source/header snapshots and hashes are in `snapshot.json`.

For each FastPattern, FourSector and Split64 layout, the matrix includes serial
insertion, the actual original native parallel wrapper, an instrumented P=W control,
and targets 256/512/1024 KiB. For positive targets:

`P = min(line_count, pow2ceil(max(W, ceil(bitmap_bytes / target_bytes))))`.

W uses the original effective-worker policy. W=1 may still use multiple cache
partitions; its count/scatter/allocation overhead is fully charged. Targets are
screening parameters, not claims that the machine has those L2 sizes. CPU 3 has
2 MiB L2. Query algorithms and bitmap/probe mappings are unchanged.

## Ownership and memory

FastPattern and FourSector select line `(hash >> 36) & (line_count - 1)`; Split64
selects `(hash >> 32) & (line_count - 1)`. These are algebraically identical to the
frozen native line mappings. All other probe-index changes stay within that line.
The histogram/scatter shard is `floor(line * P / line_count)`, so one complete
64-byte line always has one partition. Worker `part % W` alone inserts that
partition. Histogram rows are padded and aligned to 64 bytes. Scatter positions
are disjoint prefix ranges for each input-worker/partition pair. The staging
array can share boundary cache lines between different writers, but no array
location or bitmap line has two writers. Every thread is joined before the next
phase; concurrent mutation/read APIs are not introduced.

Explicit staging scratch is exactly

`8*N + sizeof(size_t) * (W * padded_counter_stride(P) + P + 1)`

when P>1, and zero for the serial P=1 shortcut. Thus it remains 8N+O(WP), not hidden
or amortized outside the timer. As in the original accounting, this excludes
allocator bookkeeping, temporary thread-handle vectors and OS thread stacks.
The thread helper creates at most W-1 handles per phase; the same helper is used
by the original and experimental wrappers. All metadata multiplication/addition,
stride rounding and input-buffer byte accounting are checked before allocation.

## Timing and correctness

`benchmark.cpp` derives from the archived common `parallel_benchmark.cpp`; the
reviewable delta is `benchmark.patch`. The original contract is retained: prehashed
input and zeroed bitmap construction occur before the build timer; **all** scratch
allocation, counting, prefix calculation, scattering, insertion, thread creation/
join and scratch release remain inside it. Original native wrappers are timed
without phase instrumentation. The P=W control reveals instrumentation/codegen
cost before attributing any gain to cache partitioning.

For experimental rows, allocate/count/prefix/scatter/insert/release/total phase
values are nanoseconds per key, with individual trial values retained in pipe-
separated columns. Each phase includes its thread-launch/join cost. Phase medians
need not sum to the median total; every individual trial sums exactly apart from
CSV rounding. The outer `insert_ns` is the comparison metric and covers every
phase, including scratch destruction. No insert-only speedup may be presented as
a whole-build speedup.

A canonical serial bitmap is created and destroyed before any measured build;
its answer vector remains for full-output validation. Every timed trial checks
all inserted keys and every mixed query answer outside timing. All six rows of
each family must have identical bytes, checksums and false-positive counts.
Queries use the original warmed parallel-query timing contract.

Native, ASan+UBSan and GCC ThreadSanitizer correctness suites pass. They cover
uniform and one-line-skewed inputs, duplicates/extreme hashes, all inserted keys,
complete output guards/parity, non-power-of-two workers, P>W, empty batches,
monotonic whole-line ownership, and checked scratch overflow. Six harness scenarios
also verify 18 rows, complete phase sums, exact scratch accounting and strict
family-name handling. `validation.json` records the checks.

## Reproduction

```sh
cmake -S experiments/2026-10-29-parallel-partitions -B build/parallel-partitions -DCMAKE_CXX_COMPILER=clang++
taskset -c 3 cmake --build build/parallel-partitions --parallel 1
taskset -c 3 ctest --test-dir build/parallel-partitions --output-on-failure
python3 experiments/2026-10-29-parallel-partitions/check_benchmark.py build/parallel-partitions/benchmark
python3 experiments/2026-10-29-parallel-partitions/run.py --output /tmp/partition-screen --key-powers 20,24 --requested-bpk 8 --threads 1,4,8 --repeats 3 --seeds 42
```

Use separate build directories with `BF_SANITIZERS=ON` or `BF_TSAN=ON` for the
correctness target. Performance uses numactl to restrict each process to W physical
cores from 3,5,7,9,11,13,15,17 on socket 1 and bind all memory to NUMA node 1. Threads
inherit that CPU mask, with no per-thread fixed placement. A single timing lease
covers the whole socket; concurrent work on the other socket is recorded as
permitted context. The runner records exact commands, topology, compiler flags,
source/binary hashes, and source drift. No production files are modified.

## Initial findings (frozen before buffered scatter)

The screen has 108 rows at 2/32 MiB bitmaps (n=2^20/2^24, requested 8, W=1/4/8,
seed 42, repeats 3). The follow-up has 36 rows at 128 MiB (n=2^25, requested 16,
W=4/8, seed 731, repeats 3), above this socket's 97.5 MiB L3. Full family outputs,
false-positive counts and bytes agree; no source changed during either matrix.
The original P=W implementation is preserved alongside the instrumented control.

At 2 MiB, fine partitioning has no convincing multithreaded gain and severely
slows the single-worker case. At 32 MiB, all targets regress in complete build cost.
For example Split64/W8 insert-only cost drops 0.393 to 0.226 ns/key at 256 KiB, but
scatter increases 0.935 to 1.396 and count 0.259 to 0.305; complete build 1.605 to 1.942.
This is an explicit rejected case: an insertion-only speedup is not a build win.

At 128 MiB, the single-screen best target gives:

| Layout | Workers | Best target | Whole-build speedup vs original |
|---|---:|---:|---:|
| FastPattern | 4 | 1024 KiB | 1.081x |
| FourSector | 4 | 1024 KiB | 1.011x |
| Split64 | 4 | 1024 KiB | 1.058x |
| FastPattern | 8 | 1024 KiB | 0.822x |
| FourSector | 8 | 1024 KiB | 0.796x |
| Split64 | 8 | 512 KiB | 0.808x |

The four-worker result is promising screening evidence, not a heldout or universal
win. The eight-worker regression still comes from the count/scatter stages. In the
128 MiB Split64/W8 case, the original instrumented scatter/insert costs are
0.711/0.734 ns/key; 1 MiB partitions change those to 1.513/0.286. The reduced insert
cost is consistent with better locality, but no cache-miss counters were collected,
so the cache explanation remains an inference. Hardware settings were not changed.

The next independently named variant will buffer 8 hashes per worker/partition,
flush 64 bytes at once, and explicitly account for padded duplicate tails and all
extra scratch. This frozen baseline is not modified by that follow-up. No production
promotion is justified by the current complete-build results.

The 128 MiB matrix was launched under the shared exclusive lock:

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-parallel-partitions/run.py --output experiments/2026-10-29-parallel-partitions/large-screen --key-powers 25 --requested-bpk 16 --threads 4,8 --repeats 3 --seeds 731 --query-power 20
```

All subsequent socket 1 compilation, tests, profiling and complete timing matrices
must hold that same flock path; the first screen used the earlier explicit agent
lease protocol with no overlap. `FREEZE.json` pins the original source, validation,
data and executable before the new buffered implementation is written.
