# External and native shared-bitmap parallel queries

This isolated harness adds a common concurrent read-only query executor to the
frozen external benchmark. No production filter, upstream algorithm, adapter or
shared benchmark was changed. It currently has correctness evidence, not a
performance ranking. See `DESIGN.md` for the protocol and `benchmark.patch` for
the complete difference from the frozen serial harness.

The caller is worker zero, pinned to the first selected physical CPU. Only T-1
additional threads are created. All T threads query one serially built immutable
bitmap; each worker owns its hash scratch and disjoint output slice. There is no
extra execution core or coordinator thread. Queries preserve the original global
batch boundaries, including exactly one final partial batch, regardless of T.

## Timing and output contract

The original `lookup_ns` / `hash_lookup_ns` columns remain direct serial-loop
controls. Construction columns retain serial insertion and allocation-plus-build
semantics. They do not describe parallel construction. The canonical query
bitmap is allocated after construction trials; only one bitmap is live in each
phase. All workers are warmed before the timed trials.

New `parallel_lookup_*` and `parallel_hash_lookup_*` columns report:

- `end_to_end_ns`: before scratch for thread management and thread creation,
  through joining and destroying all thread handles and synchronization objects.
- `launch_ns`: creation, worker pinning and waiting for every worker to be ready.
- `gated_ns`: releasing all workers, caller participation, and waiting for all
  query work to complete. This includes the common synchronization overhead.
- `join_ns`: final joins and cleanup after all query work completes.

All four are aggregate elapsed nanoseconds divided by the total query count.
They are throughput measurements, not dependent per-query latency. Raw samples
for these four intervals are retained as pipe-separated `*_trials` fields;
end-to-end and gated min/max are also retained. Each trial decomposes exactly;
separately computed medians need not sum. T=1 uses the same executor without
spawning any extra threads, while the direct serial-loop columns still provide
an independent control. A reduction in launch time is not a query-kernel win.

`threads` is total execution threads/cores; `spawned_threads` equals T-1.
`parallel_hash_scratch_bytes` reports T*B*sizeof(hash) requested heap bytes for
private query hashing buffers. The original serial hash scratch remains live
and is reported separately. Filter bytes retain the existing actual-allocation
contract. Shared output ranges may share a boundary cache line; they contain no
overlapping elements. Output guards and every output element are checked after
every trial. Thread handles, OS stacks and allocator metadata are not filter-byte
budget, and their creation/cleanup time is inside end-to-end timing.

PageBloom retains its raw-byte hash contract: its pure/prehashed columns,
including all parallel pure columns, are NaN. All other rows use the common hash
in the hashing-plus-query phase. Both phases call one const, noinline query
kernel per adapter. Fixed and bulk upstream call shapes remain unchanged.

Independent streamed negative calibration follows all timed phases and uses the
serial harness's disjoint key interval. Repeated T rows reuse the same logical
calibration sample; they must not be pooled as independent evidence. The existing
serial ranker omits T and must not consume these CSVs. A future MT ranking must
group by thread count, timing mode, query count, batch, hit rate and other workload
parameters, and enforce the same allocation/FPR eligibility rules.

## Correctness and placement

`check_executor` verifies exact global-batch coverage, output guards, large range
arithmetic, timing decomposition, and deterministic pin/spawn/query failures.
On a spawn or affinity failure, waiting threads are released and joined before
the error is rethrown. Query failures from worker zero or another worker are
captured and rethrown only after all workers finish and join.

`check_adapters` checks complete concurrent outputs against serial output for 14
representative types spanning all four native layouts, FastFilter fixed/generic
and bulk insertion, Boost multiblock/classic, RocksDB direct/bulk, and raw-key
PageBloom. It includes T=1/3/8, batches 1/7/31/4096, odd query lengths, all inserted
keys and output guards. `check_benchmark.py` covers six CLI cases (84 rows),
all-absent/mixed/all-present queries, T=1/3 equality, calibration independence,
raw-only labels, interval arithmetic and strict selection/CPU rejection.

CLI CPU IDs must be available, distinct physical cores on one socket and NUMA
node, and their count must equal T. T must not exceed the number of global query
batches. The runner binds all allocation to the selected NUMA node. The caller
pins itself before workload allocation and serial construction/control timing;
each spawned worker pins itself before the start gate.

## Reproduction

All socket 1 heavy commands must hold the shared lock for the complete operation.
The representative registration compiles 14 types. Disable
`BF_MT_REPRESENTATIVE` for the full frozen external/native registration.

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 cmake \
  -S experiments/2026-10-29-external-parallel-query \
  -B build/external-parallel-query -DCMAKE_CXX_COMPILER=clang++ \
  -DBF_MT_REPRESENTATIVE=ON
flock /tmp/fastest-bf-socket1.lock taskset -c 3 cmake \
  --build build/external-parallel-query --parallel 1
flock /tmp/fastest-bf-socket1.lock taskset -c 3 ctest \
  --test-dir build/external-parallel-query --output-on-failure
flock /tmp/fastest-bf-socket1.lock numactl --physcpubind=3,5,7 --membind=1 \
  python3 experiments/2026-10-29-external-parallel-query/check_benchmark.py \
  build/external-parallel-query/benchmark
```

Separate builds support `BF_SANITIZERS=ON` (Clang ASan/UBSan) and `BF_TSAN=ON`
(GCC ThreadSanitizer). The final two CLI arguments append total workers and an
explicit CPU list to the shared harness's existing ten arguments. `run.py`
requires an explicit filter list, refuses to overwrite output, randomizes case
order, records CPU topology/compiler commands/source and executable hashes, and
rejects source drift. No large timing matrix has been run.

## Validation status and frozen executable

Native Clang, Clang ASan/UBSan and GCC 12.2 ThreadSanitizer each pass both CTest
checks and six representative CLI cases (84 rows). SimdBlockSingleV1 and
Fixed16SingleV1 are both included. Cancellation checks include simultaneous
worker-affinity errors, a late spawn failure, and query exceptions from worker
zero and another worker. `check_full.py` separately validates all 56 registered
configurations at T=1/3 (112 correctness-only rows).

The full executable is `build/external-parallel-query-full/benchmark`; its
registration is listed in `available_filters.txt`. `validation.json` records the
build commands and hashes for the full executable and all sanitizer/test
executables. `runner-smoke/` contains only ten tiny correctness rows and the
runner's source/topology metadata; it is not performance evidence. A future
measurement must use a fresh output directory and preserve this executable and
source freeze.
