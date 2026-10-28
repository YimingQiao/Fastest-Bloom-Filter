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
