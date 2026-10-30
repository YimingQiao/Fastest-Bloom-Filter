# Shared-bitmap external multithreaded queries

Status: implementation and correctness validation in progress. No performance claims yet.

The current external comparison measures one caller, while the native parallel
benchmark measures only native scaling. This experiment will compare the native
and pinned external adapters with one immutable bitmap per implementation and a
common query executor. Serial construction remains separately reported; it does
not assume an external concurrent-insertion API.

## Reuse and scope

Freeze `src/compare_benchmark.cpp`, the native headers, and the FastFilter,
Boost, RocksDB and combined adapter headers in this directory before implementing
the experiment. Preserve the existing dependency pins, upstream source, common
hash function, workload generation, insertion batching, byte accounting,
independent calibration and strict filter selection. Record a reviewable delta
from the shared harness. Do not modify the production harness or adapters.

The isolated implementation needs `executor.hpp`, `benchmark.cpp`,
`check.cpp`, CLI/accounting checks, `CMakeLists.txt`, `run.py` and a README.
The CMake target can reuse the existing pinned dependency definitions and the
same compiler/ISA options. Native and external rows share one executable.

## Read-only contract

The inspected native and external adapter `Lookup` methods are const. The
FastFilter `Find`/`Contain` methods and PageBloom `test` are const reads. Boost's
bulk-query callback owns its output cursor locally; the counting allocator is
used during construction/destruction, not queries. RocksDB's bulk-query arrays
are local stack storage. No query method needs shared mutable scratch.

Expose the built object as `const BF&` to every worker. Compile-time checks must
reject any adapter without a const query API. Freeze the bitmap before publishing
it to workers and destroy it only after all workers have joined. Do not invoke
native `LookupParallel`, make per-worker filter copies, or add insertion races.
Confirm these assumptions with concurrent output checks and ThreadSanitizer on
representative native and external families before measuring.

## Work and placement

For Q queries and batch size B, let M=ceil(Q/B). Worker t of T receives batch
indices `[floor(M*t/T), floor(M*(t+1)/T))`. Thus each adapter receives the exact
same B-sized calls as the serial harness, with only the original final tail.
Splitting arbitrary key ranges instead would introduce T independent tails and
change SIMD/bulk work. Require `1 <= T <= M` explicitly.

Pin each worker to one explicitly supplied physical CPU. Validate that CPU IDs
are available and use distinct physical cores on one selected NUMA node. Bind
allocation to that node and record CPU topology, complete affinity, NUMA policy,
compiler flags, source hashes and executable hash. The caller is pinned to the first selected CPU and is worker zero. Only T-1
additional threads are spawned; exactly T execution cores and T threads take part.
There is no extra coordinator thread. The original direct serial loop remains a
separate control on the caller core.

Each worker receives private aligned hash scratch of B elements and a disjoint
output range. If output buffers are padded to avoid sharing boundary cache lines,
report the padding and allocation and compare them with the serial reference
outside timing. No work stealing or per-batch atomic scheduling is needed.

Use one noinline const query kernel for both pure and hash-plus-query modes.
Hash each batch with the same common hash function in the latter mode. PageBloom
retains its raw-bytes contract and reports pure-prehashed fields as NaN. Never
label a rehashing raw-key adapter as a pure Bloom query.

## Timing boundaries

Preallocate hash/output storage outside query timing, matching the shared
harness. Warm the query workload on the built filter before trials. For each
phase/trial, spawn T-1 fresh threads with a ready/start/completed gate and record:

1. End-to-end query time: before thread construction through complete join.
2. Launch time: construction, affinity and waiting until all workers are ready.
3. Query execution time: release of the start gate through completion of all
   workers, including the common gate synchronization cost.
4. Join time: completion through complete thread cleanup.

The intervals must form an exact whole-run decomposition, not a subtraction of
unrelated measurements. Preserve individual samples, median and min/max. Also
record worker start/end timestamps if needed to explain scheduling spread; do
not silently replace the main timing with the best worker or sum worker times.
Run the same executor at T=1, so scaling uses the same timing contract. These are
aggregate throughput measurements, not dependent single-query latency.

Time serial insertion and allocation-plus-insertion independently using the
shared harness semantics. Never present parallel-query speed as parallel-build
speed. Construction trials and the final query bitmap must have disjoint
lifetimes as in the current harness.

## Validation and statistics

Validate all inserted hashes, construct a serial full-output reference, and
compare every output element after every parallel trial in both query modes.
Check Boolean outputs, output guards, checksums, bytes and false-positive counts.
Verify the complete global batch schedule, including B=1, B=31 and odd tails;
test T=1, T=3 and T=8, mixed/all-present/all-absent workloads, and invalid CPU or
filter selection. Thread creation failures must release waiting workers and
join them; query exceptions must be captured and rethrown after joins.

Run independent streamed negative calibration after all timed query phases,
using the same disjoint key interval as the serial harness. Calibration belongs
to the immutable filter and dataset, not the worker count: repeated T rows must
not multiply the statistical sample size. Keep actual allocation and measured
FPR eligibility when selecting rivals across memory caps.

The existing external ranker has no thread-count or timing-mode dimension.
Keep experimental CSVs out of its input until an explicit MT-aware summary
groups by these dimensions. Initial work stops at correctness and a small
accounting smoke; schedule a bounded performance matrix only after review.

All socket 1 compilation, tests and measurement commands hold
`flock /tmp/fastest-bf-socket1.lock` for the entire operation.
