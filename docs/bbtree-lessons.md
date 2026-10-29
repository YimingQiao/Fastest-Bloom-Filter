# What we borrow from bbtree

Xiangpeng Hao's [bbtree explanation](https://blog.xiangpeng.systems/posts/bbtree/)
orders the main costs as dependent cache-line accesses, instructions, then cache
coherence traffic. Compact inline keys reduce pointer chasing; SIMD searches
compact nodes without a chain of unpredictable branches. Batched operations
interleave independent searches to hide memory latency. Optimistic reads avoid
writing shared reader counters. These are mechanisms to measure, rather than a
promise that applying one technique makes another data structure faster.

Our Bloom filters have different work: a query tests bit positions rather than
following an ordered search path. All four layouts keep a key's probes in one
64-byte line. The remaining decisions depend on whether that line is already
cached, how many independent keys are available, and whether writers share it.

| Cost | Implementation here | Evidence and limits |
| --- | --- | --- |
| Cache-line accesses | FastPattern, FourSector and Split64 cluster probes; ByteSplit packs four 16-byte buckets into each aligned line. | Fewer lines is useful only with acceptable FPR at the measured space budget. [Layouts and constrained rankings](modern-confirmation-2026-10-28.md). |
| Independent memory work | Large batches use prefetching and SIMD gathers; FourSector prepares short groups to expose independent accesses. | [Native C++ short-query confirmation](../experiments/2026-10-28-four-sector-probe/integration.md) and [Rust control](../experiments/2026-10-28-rust-four-sector-short/README.md). Small and large batches have separate kernels and results. |
| Hot-path instructions | Tiny queries bypass unused batch setup. ByteSplit directly addresses a power-of-two bucket array. | [Short-query controls](../experiments/2026-10-28-small-batch-kernels/README.md). The ByteSplit port needed a flat byte offset: the compiler did not collapse its line/slot expression automatically. [Assembly and port check](../experiments/2026-10-29-native-byte-split/integration-report.md). |
| Cache coherence | Exclusive parallel builders assign complete lines to workers and align histogram rows. Immutable queries do not update shared counters. | [Native layout scaling](layout-parallel-2026-10-28.md). Partitioning scratch and thread launch remain real costs; atomic overlapping writers/readers have separate semantics. |

We also use the cost model to reject appealing changes. A design that accelerates
the insertion loop can still lose if distributing hashes costs more. A masked
query can accelerate prehashed reads but stall on freshly written hash scratch.
Therefore the benchmark retains full construction cost, pure-query and hash+query
columns, actual payload bytes, FPR evidence and failed experiments.

Correctness gates are independent of speed: scalar bitmap oracles, all inserted
keys, dense output checksums, boundary/offset tests, sanitizers, thread checks and
cross-language parity. These are practical checks, not a claim that this Bloom
filter project has bbtree's formal-verification coverage. The shared benchmark
also checks that the requested implementations actually ran and that first-timed
outputs match the verified warm-up outside the timers.

## What the later experiments showed

The instruction-count lesson is useful only alongside the space/quality gate.
A cyclic probe mask needed fewer vector instructions but increased false
positives; compensating with a larger bitmap lost15 of16 eligible external
comparison views. It was [rejected](../experiments/2026-10-29-cyclic-split64-analysis/FINDINGS.md).
A fixed multiply-code mask keeps a short dependency chain while passing the
first16/24-bpk quality gates. Its [70-row screen](../experiments/2026-10-29-multiply-code-split64-performance-analysis/report/RESULTS.md)
improves small equal-space Split64Range throughput by about8–10%, yet loses on
large tables. Quality estimates need sufficient precision too: a
[new disjoint sample](../experiments/2026-10-29-four-sector-quality-resolution/RESULTS.md)
qualifies both FourSector16 constructions whose earlier confidence upper
endpoints narrowly failed0.1%. The stronger rival remains visible in the
[fresh-seed comparison](../experiments/2026-10-29-multiply-code-small-confirmation/README.md).
The mask remains experimental; fewer instructions alone do not establish a win.

The next [uniform precision audit](../experiments/2026-10-29-eight-api-quality-resolution/RESULTS.md)
applies the same117-million fresh negatives to all eight APIs and all six
constructions. FourSector passes every new gate. Under that separate new gate,
Multiply loses all36 comparisons against the fastest rival in the original
timings. Keeping a fast rival in view can change the engineering decision;
an inconclusive accuracy interval should not become a permanent exclusion.

The [native Rust range screen](../experiments/2026-10-29-split64-range-rust-analysis/report-final/REPORT.md)
shows why address arithmetic needs the same scrutiny. Arbitrary cache-line
budgets make24 bpk usable, but range addressing loses47/48 equal-allocation
query comparisons to the power-of-two Split64 layout. The useful result is
finer capacity control, with an explicitly measured cost in that workload.

The [eight-core comparison](../experiments/2026-10-29-split64-range-parallel-analysis/report-final/REPORT.md)
retains that capacity benefit: Range24 leads the eligible external controls
at the strict24-bpk ceiling, while losing most wider comparisons against
production layouts. A separate [FourSector range pilot](../experiments/2026-10-29-four-sector-range24/accuracy/RESULTS.md)
keeps the fast gather kernels but fails the same24-bpk quality gate. Fitting
the desired memory budget and preserving a fast kernel are both insufficient
without testing the resulting probe distribution.

Baseline configuration needs the same care. The [complete Fastbloom probe
calibration](../experiments/2026-10-29-rust-fastbloom-fixed-probes-analysis/report/REPORT.md)
finds that K7 at 24 bpk passes the 0.01% gate at both tested sizes, while its
automatic default uses K17 for greater accuracy. Counting a win over that
default alone can overstate our advantage. The next timing comparison keeps
every tested K; the fewest qualifying probes need not give the lowest latency.

Compiler boundaries also matter. Exposing Rust ByteSplit's public singleton
body removed a hot per-key call and improved fused throughput16–38% in the
isolated comparison, with2–3% losses in some short batches. The
[minimal hint](../experiments/2026-10-29-rust-byte-inline-integration/EVIDENCE.md)
is integrated with that tradeoff documented. Conversely, a four-line
Independent32 shortcut made the compiler save six registers instead of one
and was rejected after batch regressions. Its next isolated revision restores
the smaller prologue. The [208-row comparison](../experiments/2026-10-29-independent32-rust-scalar-inline-analysis/FINDINGS.md)
improves batch-one throughput10–20% but still loses16.6% on small batch-two
queries, despite matching the original's bulk-loop instructions. It remains
isolated. Source brevity and instruction counts alone are insufficient evidence.
