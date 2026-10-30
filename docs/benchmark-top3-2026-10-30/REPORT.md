# Benchmark Top 3 — descriptive snapshot

Each panel is ranked separately. Hardware: Xeon Platinum 8474C. These panels use 50% mixed-query hits. No cross-language, cross-binary or cross-panel timing normalization is applied. This report covers seven complete external-comparison suites, not every historical internal A/B experiment.

Throughput ratio = fastest latency / method latency, so first place is 1.00 and lower is slower. ns/key is also retained. Multi-cell summaries use the geometric mean of the original per-cell medians; a configuration must be eligible in every cell. These are descriptive same-data rankings, not independent confirmation or significance tests. Exact ties use method/bytes only for display order.

Top3 means three public API methods: each may use its fastest eligible measured allocation under the byte ceiling. API variants remain distinct even if they share a bitmap mapping. Every eligible allocation, including alternatives within a method, remains in rankings.json and rankings.csv. Fewer than three qualifiers are shown without padding.

CPP988: one seen seed, broad capacity screen, prehashed/staged query only. Rust786: one seen seed, raw query and build; build uses insertion chunk4096 regardless of the query-batch context label. CPP_singleton616: two seen seeds and opposite rounds, single-key contracts and restricted union of external leaders. CPP_prefetch192: two seen seeds and opposite rounds, fixed16-bpk/1% panel; prototypes remain experimental. CPP_K12: three fresh seeds, fixed strict0.01% shortlist. CPP_MT195: three seen seeds, eight physical cores; gated excludes launch/join while end_to_end includes them. Historical compiled versions remain the ones actually measured.

CPP_build234 retains the original three-seed pooled, one-sided95 quality gate and historical allocation boundaries. Caller-prepared hash workspace is not asserted to be charged; it is not the newer raw8 full-construction contract. NaN metrics (such as a raw-only API lacking a prehashed path) remain listed as unavailable in rankings.json, never as zero latency.

Metrics: lookup/generic_pure = prehashed query; hash_lookup/generic_staged_common_hash = staged hash+query; visible_public_* = public single-key loop; raw_batched_public/raw_visible_public include required public hashing. raw_insert excludes bitmap/scratch allocation; allocate_filter_and_scratch_raw_insert includes both. RPT selection-vector production, SQL joins/materialization and whole SQL latency are not measured by these microbenchmarks.

## CPP988

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 4096 | 12 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 12 | 0.01% | lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 12 | 0.1% | hash_lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 12 | 0.1% | lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 12 | 1% | hash_lookup_ns | 1 | FastFilterFixed32 @12 bpk: 1.8736 ns, **1.000×** | FastFilterFixed32Bulk @12 bpk: 1.8817 ns, **0.996×** | Boost192Multi32K8 @12 bpk: 2.2072 ns, **0.849×** |
| 65536 | 4096 | 12 | 1% | lookup_ns | 1 | FastFilterFixed32 @12 bpk: 1.3346 ns, **1.000×** | FastFilterFixed32Bulk @12 bpk: 1.3387 ns, **0.997×** | Boost192Multi32K8 @12 bpk: 1.6113 ns, **0.828×** |
| 65536 | 4096 | 14 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 14 | 0.01% | lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 14 | 0.1% | hash_lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 14 | 0.1% | lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 14 | 1% | hash_lookup_ns | 1 | ByteSplitRangeExperiment @14 bpk: 1.5830 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.6069 ns, **0.985×** | FastFilterFixed16 @14 bpk: 1.6634 ns, **0.952×** |
| 65536 | 4096 | 14 | 1% | lookup_ns | 1 | ByteSplitRangeExperiment @14 bpk: 1.0784 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.1015 ns, **0.979×** | FastFilterFixed16 @14 bpk: 1.1316 ns, **0.953×** |
| 65536 | 4096 | 16 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | lookup_ns | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.1% | hash_lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.5741 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2517 ns, **0.699×** | Split64RangeExperiment @16 bpk: 2.2748 ns, **0.692×** |
| 65536 | 4096 | 16 | 0.1% | lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.0618 ns, **1.000×** | Split64BloomFilter @16 bpk: 1.6704 ns, **0.636×** | Split64RangeExperiment @16 bpk: 1.6907 ns, **0.628×** |
| 65536 | 4096 | 16 | 1% | hash_lookup_ns | 1 | FastPatternBF @16 bpk: 1.2137 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5348 ns, **0.791×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.771×** |
| 65536 | 4096 | 16 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 0.6780 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0262 ns, **0.661×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.638×** |
| 65536 | 4096 | 20 | 0.01% | hash_lookup_ns | 1 | Boost192ClassicK11 @20 bpk: 11.9797 ns, **1.000×** | FastFilterClassic10Bulk @20 bpk: 12.4241 ns, **0.964×** | FastFilterClassic10Branchless @20 bpk: 12.6500 ns, **0.947×** |
| 65536 | 4096 | 20 | 0.01% | lookup_ns | 1 | Boost192ClassicK11 @20 bpk: 11.4014 ns, **1.000×** | FastFilterClassic10Bulk @20 bpk: 11.8270 ns, **0.964×** | FastFilterClassic10Branchless @20 bpk: 12.0018 ns, **0.950×** |
| 65536 | 4096 | 20 | 0.1% | hash_lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.5741 ns, **1.000×** | FastFilterFixed32 @20 bpk: 1.8694 ns, **0.842×** | FastFilterFixed32Bulk @20 bpk: 1.8725 ns, **0.841×** |
| 65536 | 4096 | 20 | 0.1% | lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.0618 ns, **1.000×** | FastFilterFixed32Bulk @20 bpk: 1.3417 ns, **0.791×** | FastFilterFixed32 @20 bpk: 1.3444 ns, **0.790×** |
| 65536 | 4096 | 20 | 1% | hash_lookup_ns | 1 | FastPatternBF @16 bpk: 1.2137 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5348 ns, **0.791×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.771×** |
| 65536 | 4096 | 20 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 0.6780 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0262 ns, **0.661×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.638×** |
| 65536 | 4096 | 24 | 0.01% | hash_lookup_ns | 1 | Split64RangeExperiment @24 bpk: 2.2528 ns, **1.000×** | FastFilterFixed64 @24 bpk: 2.7216 ns, **0.828×** | RocksDBFastLocalBloom64K8 @24 bpk: 2.9101 ns, **0.774×** |
| 65536 | 4096 | 24 | 0.01% | lookup_ns | 1 | Split64RangeExperiment @24 bpk: 1.6963 ns, **1.000×** | FastFilterFixed64 @24 bpk: 2.1802 ns, **0.778×** | Boost192Multi64K8 @24 bpk: 2.2498 ns, **0.754×** |
| 65536 | 4096 | 24 | 0.1% | hash_lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.5741 ns, **1.000×** | FastFilterFixed32 @20 bpk: 1.8694 ns, **0.842×** | FastFilterFixed32Bulk @20 bpk: 1.8725 ns, **0.841×** |
| 65536 | 4096 | 24 | 0.1% | lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.0618 ns, **1.000×** | FastFilterFixed32Bulk @24 bpk: 1.3410 ns, **0.792×** | FastFilterFixed32 @20 bpk: 1.3444 ns, **0.790×** |
| 65536 | 4096 | 24 | 1% | hash_lookup_ns | 1 | FastPatternBF @16 bpk: 1.2137 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5348 ns, **0.791×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.771×** |
| 65536 | 4096 | 24 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 0.6780 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0262 ns, **0.661×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.638×** |
| 65536 | 4096 | 28 | 0.01% | hash_lookup_ns | 1 | FastFilterFixed32 @28 bpk: 1.8827 ns, **1.000×** | FastFilterFixed32Bulk @28 bpk: 1.8872 ns, **0.998×** | Split64RangeExperiment @24 bpk: 2.2528 ns, **0.836×** |
| 65536 | 4096 | 28 | 0.01% | lookup_ns | 1 | FastFilterFixed32Bulk @28 bpk: 1.3478 ns, **1.000×** | FastFilterFixed32 @28 bpk: 1.3493 ns, **0.999×** | Boost192Multi32K8 @28 bpk: 1.6430 ns, **0.820×** |
| 65536 | 4096 | 28 | 0.1% | hash_lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.5741 ns, **1.000×** | ByteSplitRangeExperiment @28 bpk: 1.6327 ns, **0.964×** | FastFilterFixed16 @28 bpk: 1.6721 ns, **0.941×** |
| 65536 | 4096 | 28 | 0.1% | lookup_ns | 1 | FourSectorBloomFilter @16 bpk: 1.0618 ns, **1.000×** | ByteSplitRangeExperiment @28 bpk: 1.1162 ns, **0.951×** | FastFilterFixed16 @28 bpk: 1.1434 ns, **0.929×** |
| 65536 | 4096 | 28 | 1% | hash_lookup_ns | 1 | FastPatternBF @16 bpk: 1.2137 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5348 ns, **0.791×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.771×** |
| 65536 | 4096 | 28 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 0.6780 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0262 ns, **0.661×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.638×** |
| 65536 | 4096 | 32 | 0.01% | hash_lookup_ns | 1 | FourSectorBloomFilter @32 bpk: 1.6274 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.7797 ns, **0.914×** | FastFilterSimdBlockSingleV1 @32 bpk: 1.7986 ns, **0.905×** |
| 65536 | 4096 | 32 | 0.01% | lookup_ns | 1 | FourSectorBloomFilter @32 bpk: 1.1286 ns, **1.000×** | FastFilterSimdBlockSingleV1 @32 bpk: 1.2458 ns, **0.906×** | FastFilterSimdBlock @32 bpk: 1.2519 ns, **0.902×** |
| 65536 | 4096 | 32 | 0.1% | hash_lookup_ns | 1 | FastPatternBF @32 bpk: 1.2427 ns, **1.000×** | ByteSplitBloomFilter @32 bpk: 1.5567 ns, **0.798×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.789×** |
| 65536 | 4096 | 32 | 0.1% | lookup_ns | 1 | FastPatternBF @32 bpk: 0.7316 ns, **1.000×** | ByteSplitBloomFilter @32 bpk: 1.0557 ns, **0.693×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.689×** |
| 65536 | 4096 | 32 | 1% | hash_lookup_ns | 1 | FastPatternBF @16 bpk: 1.2137 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5348 ns, **0.791×** | FourSectorBloomFilter @16 bpk: 1.5741 ns, **0.771×** |
| 65536 | 4096 | 32 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 0.6780 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0262 ns, **0.661×** | FourSectorBloomFilter @16 bpk: 1.0618 ns, **0.638×** |
| 33554432 | 4096 | 12 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 12 | 0.01% | lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 12 | 0.1% | hash_lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 12 | 0.1% | lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 12 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 4.1937 ns, **0.964×** | Boost192Multi64K8 @12 bpk: 4.3760 ns, **0.923×** |
| 33554432 | 4096 | 12 | 1% | lookup_ns | 1 | Boost192Multi32K8 @12 bpk: 4.7230 ns, **1.000×** | Split64RangeExperiment @12 bpk: 4.8589 ns, **0.972×** | Boost192Multi64K8 @12 bpk: 5.3212 ns, **0.888×** |
| 33554432 | 4096 | 14 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 14 | 0.01% | lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 14 | 0.1% | hash_lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 14 | 0.1% | lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 14 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 4.1937 ns, **0.964×** | Boost192Multi64K8 @12 bpk: 4.3760 ns, **0.923×** |
| 33554432 | 4096 | 14 | 1% | lookup_ns | 1 | Boost192Multi32K8 @12 bpk: 4.7230 ns, **1.000×** | Split64RangeExperiment @12 bpk: 4.8589 ns, **0.972×** | Boost192Multi64K8 @12 bpk: 5.3212 ns, **0.888×** |
| 33554432 | 4096 | 16 | 0.01% | hash_lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | lookup_ns | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.1% | hash_lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.2881 ns, **1.000×** | Split64RangeExperiment @16 bpk: 4.4659 ns, **0.960×** | Boost192Multi64K8 @16 bpk: 4.7205 ns, **0.908×** |
| 33554432 | 4096 | 16 | 0.1% | lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.8496 ns, **1.000×** | Split64RangeExperiment @16 bpk: 5.2612 ns, **0.922×** | Boost192Multi64K8 @16 bpk: 5.6709 ns, **0.855×** |
| 33554432 | 4096 | 16 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | FastPatternBF @16 bpk: 4.1746 ns, **0.968×** | FourSectorBloomFilter @16 bpk: 4.1831 ns, **0.966×** |
| 33554432 | 4096 | 16 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 4.1881 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.4411 ns, **0.943×** | Boost192Multi32K8 @12 bpk: 4.7230 ns, **0.887×** |
| 33554432 | 4096 | 20 | 0.01% | hash_lookup_ns | 1 | Boost192ClassicK11 @20 bpk: 27.4758 ns, **1.000×** | FastFilterClassic10 @20 bpk: 31.7814 ns, **0.865×** | FastFilterClassic10Bulk @20 bpk: 33.0563 ns, **0.831×** |
| 33554432 | 4096 | 20 | 0.01% | lookup_ns | 1 | Boost192ClassicK11 @20 bpk: 27.3595 ns, **1.000×** | FastFilterClassic10 @20 bpk: 35.1935 ns, **0.777×** | FastFilterClassic10Branchless @20 bpk: 35.5893 ns, **0.769×** |
| 33554432 | 4096 | 20 | 0.1% | hash_lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.2881 ns, **1.000×** | Split64RangeExperiment @16 bpk: 4.4659 ns, **0.960×** | Boost192Multi64K8 @16 bpk: 4.7205 ns, **0.908×** |
| 33554432 | 4096 | 20 | 0.1% | lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.8496 ns, **1.000×** | Split64RangeExperiment @16 bpk: 5.2612 ns, **0.922×** | Boost192Multi32K8 @20 bpk: 5.4681 ns, **0.887×** |
| 33554432 | 4096 | 20 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | FastPatternBF @16 bpk: 4.1746 ns, **0.968×** | FourSectorBloomFilter @16 bpk: 4.1831 ns, **0.966×** |
| 33554432 | 4096 | 20 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 4.1881 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.4411 ns, **0.943×** | Boost192Multi32K8 @12 bpk: 4.7230 ns, **0.887×** |
| 33554432 | 4096 | 24 | 0.01% | hash_lookup_ns | 1 | Split64RangeExperiment @24 bpk: 5.5213 ns, **1.000×** | Boost192Multi64K8 @24 bpk: 5.7529 ns, **0.960×** | Boost192Multi32K16 @24 bpk: 5.8028 ns, **0.951×** |
| 33554432 | 4096 | 24 | 0.01% | lookup_ns | 1 | Split64RangeExperiment @24 bpk: 6.0586 ns, **1.000×** | Boost192Multi64K8 @24 bpk: 6.4845 ns, **0.934×** | Boost192Multi32K16 @24 bpk: 6.7665 ns, **0.895×** |
| 33554432 | 4096 | 24 | 0.1% | hash_lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.2881 ns, **1.000×** | Split64RangeExperiment @16 bpk: 4.4659 ns, **0.960×** | Boost192Multi64K8 @16 bpk: 4.7205 ns, **0.908×** |
| 33554432 | 4096 | 24 | 0.1% | lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.8496 ns, **1.000×** | Split64RangeExperiment @16 bpk: 5.2612 ns, **0.922×** | Boost192Multi32K8 @20 bpk: 5.4681 ns, **0.887×** |
| 33554432 | 4096 | 24 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | FastPatternBF @16 bpk: 4.1746 ns, **0.968×** | FourSectorBloomFilter @16 bpk: 4.1831 ns, **0.966×** |
| 33554432 | 4096 | 24 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 4.1881 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.4411 ns, **0.943×** | Boost192Multi32K8 @12 bpk: 4.7230 ns, **0.887×** |
| 33554432 | 4096 | 28 | 0.01% | hash_lookup_ns | 1 | Split64RangeExperiment @24 bpk: 5.5213 ns, **1.000×** | Boost192Multi64K8 @24 bpk: 5.7529 ns, **0.960×** | Boost192Multi32K16 @24 bpk: 5.8028 ns, **0.951×** |
| 33554432 | 4096 | 28 | 0.01% | lookup_ns | 1 | Split64RangeExperiment @24 bpk: 6.0586 ns, **1.000×** | Boost192Multi32K8 @28 bpk: 6.2642 ns, **0.967×** | Boost192Multi64K8 @24 bpk: 6.4845 ns, **0.934×** |
| 33554432 | 4096 | 28 | 0.1% | hash_lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.2881 ns, **1.000×** | Split64RangeExperiment @16 bpk: 4.4659 ns, **0.960×** | Boost192Multi64K8 @16 bpk: 4.7205 ns, **0.908×** |
| 33554432 | 4096 | 28 | 0.1% | lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.8496 ns, **1.000×** | Split64RangeExperiment @16 bpk: 5.2612 ns, **0.922×** | Boost192Multi32K8 @20 bpk: 5.4681 ns, **0.887×** |
| 33554432 | 4096 | 28 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | FastPatternBF @16 bpk: 4.1746 ns, **0.968×** | FourSectorBloomFilter @16 bpk: 4.1831 ns, **0.966×** |
| 33554432 | 4096 | 28 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 4.1881 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.4411 ns, **0.943×** | Boost192Multi32K8 @12 bpk: 4.7230 ns, **0.887×** |
| 33554432 | 4096 | 32 | 0.01% | hash_lookup_ns | 1 | Split64RangeExperiment @24 bpk: 5.5213 ns, **1.000×** | Boost192Multi64K8 @24 bpk: 5.7529 ns, **0.960×** | Boost192Multi32K16 @24 bpk: 5.8028 ns, **0.951×** |
| 33554432 | 4096 | 32 | 0.01% | lookup_ns | 1 | FastPatternBF @32 bpk: 6.0474 ns, **1.000×** | Split64RangeExperiment @24 bpk: 6.0586 ns, **0.998×** | FourSectorBloomFilter @32 bpk: 6.1313 ns, **0.986×** |
| 33554432 | 4096 | 32 | 0.1% | hash_lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.2881 ns, **1.000×** | Split64RangeExperiment @16 bpk: 4.4659 ns, **0.960×** | Boost192Multi64K8 @16 bpk: 4.7205 ns, **0.908×** |
| 33554432 | 4096 | 32 | 0.1% | lookup_ns | 1 | Split64BloomFilter @16 bpk: 4.8496 ns, **1.000×** | Split64RangeExperiment @16 bpk: 5.2612 ns, **0.922×** | Boost192Multi32K8 @20 bpk: 5.4681 ns, **0.887×** |
| 33554432 | 4096 | 32 | 1% | hash_lookup_ns | 1 | Split64RangeExperiment @12 bpk: 4.0411 ns, **1.000×** | FastPatternBF @16 bpk: 4.1746 ns, **0.968×** | FourSectorBloomFilter @16 bpk: 4.1831 ns, **0.966×** |
| 33554432 | 4096 | 32 | 1% | lookup_ns | 1 | FastPatternBF @16 bpk: 4.1881 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.4411 ns, **0.943×** | Boost192Multi32K8 @12 bpk: 4.7230 ns, **0.887×** |
## CPP_K12_primary24

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 31 | 24 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 2.1885 ns, **1.000×** | Split64RangeNative @24 bpk: 2.2459 ns, **0.974×** | FastFilterFixed64 @24 bpk: 2.8867 ns, **0.758×** |
| 65536 | 31 | 24 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 1.4027 ns, **1.000×** | Split64RangeNative @24 bpk: 1.6780 ns, **0.836×** | FastFilterFixed64 @24 bpk: 2.2850 ns, **0.614×** |
| 65536 | 4096 | 24 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 1.7066 ns, **1.000×** | Split64RangeNative @24 bpk: 2.2606 ns, **0.755×** | FastFilterFixed64 @24 bpk: 2.7308 ns, **0.625×** |
| 65536 | 4096 | 24 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 1.1949 ns, **1.000×** | Split64RangeNative @24 bpk: 1.6933 ns, **0.706×** | FastFilterFixed64 @24 bpk: 2.1806 ns, **0.548×** |
| 33554432 | 31 | 24 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 7.4560 ns, **1.000×** | Split64RangeNative @24 bpk: 8.1783 ns, **0.912×** | RocksDBFastLocalBloom64K8Batch32 @24 bpk: 9.0531 ns, **0.824×** |
| 33554432 | 31 | 24 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 6.7530 ns, **1.000×** | RocksDBFastLocalBloom64K8Batch32 @24 bpk: 8.1137 ns, **0.832×** | Split64RangeNative @24 bpk: 8.3309 ns, **0.811×** |
| 33554432 | 4096 | 24 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 5.2459 ns, **1.000×** | Split64RangeNative @24 bpk: 5.4755 ns, **0.958×** | Boost192Multi64K8 @24 bpk: 5.8004 ns, **0.904×** |
| 33554432 | 4096 | 24 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 5.6188 ns, **1.000×** | Split64RangeNative @24 bpk: 6.0818 ns, **0.924×** | Boost192Multi64K8 @24 bpk: 6.5089 ns, **0.863×** |
## CPP_K12_secondary_large_cap32

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 33554432 | 31 | 32 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 7.4560 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 7.6216 ns, **0.978×** | Split64RangeNative @24 bpk: 8.1783 ns, **0.912×** |
| 33554432 | 31 | 32 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 6.7530 ns, **1.000×** | FastPatternBF @32 bpk: 7.0655 ns, **0.956×** | FourSectorBloomFilter @32 bpk: 7.3704 ns, **0.916×** |
| 33554432 | 4096 | 32 | 0.01% | hash_lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 5.2459 ns, **1.000×** | Split64RangeNative @24 bpk: 5.4755 ns, **0.958×** | Boost192Multi64K8 @24 bpk: 5.8004 ns, **0.904×** |
| 33554432 | 4096 | 32 | 0.01% | lookup_ns | 3 | FourSectorRange12Experiment @24 bpk: 5.6188 ns, **1.000×** | FastPatternBF @32 bpk: 5.9660 ns, **0.942×** | Split64RangeNative @24 bpk: 6.0818 ns, **0.924×** |
## CPP_MT195

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 4096 | 16 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | parallel_hash_lookup_gated_ns | 3 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | parallel_lookup_end_to_end_ns | 3 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | parallel_lookup_gated_ns | 3 | — | — | — |
| 65536 | 4096 | 16 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.2524 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.3380 ns, **0.747×** | Split64RangeBloomFilter @16 bpk: 0.3431 ns, **0.736×** |
| 65536 | 4096 | 16 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.2031 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.2874 ns, **0.707×** | Split64RangeBloomFilter @16 bpk: 0.2919 ns, **0.696×** |
| 65536 | 4096 | 16 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.1876 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.2667 ns, **0.703×** | Split64RangeBloomFilter @16 bpk: 0.2711 ns, **0.692×** |
| 65536 | 4096 | 16 | 0.1% | parallel_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.1386 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.2156 ns, **0.643×** | Split64RangeBloomFilter @16 bpk: 0.2199 ns, **0.630×** |
| 65536 | 4096 | 16 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.2076 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2524 ns, **0.823×** | ByteSplitBloomFilter @16 bpk: 0.2728 ns, **0.761×** |
| 65536 | 4096 | 16 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.1582 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2031 ns, **0.779×** | ByteSplitBloomFilter @16 bpk: 0.2245 ns, **0.705×** |
| 65536 | 4096 | 16 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.1389 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1849 ns, **0.751×** | FourSectorBloomFilter @16 bpk: 0.1876 ns, **0.740×** |
| 65536 | 4096 | 16 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.0890 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1352 ns, **0.659×** | FourSectorBloomFilter @16 bpk: 0.1386 ns, **0.642×** |
| 65536 | 4096 | 24 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.2780 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.3392 ns, **0.820×** | FastFilterFixed64 @24 bpk: 0.4025 ns, **0.691×** |
| 65536 | 4096 | 24 | 0.01% | parallel_hash_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.2279 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.2887 ns, **0.790×** | FastFilterFixed64 @24 bpk: 0.3529 ns, **0.646×** |
| 65536 | 4096 | 24 | 0.01% | parallel_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.2048 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.2690 ns, **0.761×** | FastFilterFixed64 @24 bpk: 0.3299 ns, **0.621×** |
| 65536 | 4096 | 24 | 0.01% | parallel_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.1548 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.2180 ns, **0.710×** | FastFilterFixed64 @24 bpk: 0.2790 ns, **0.555×** |
| 65536 | 4096 | 24 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.2524 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 0.2780 ns, **0.908×** | FastFilterFixed32 @20 bpk: 0.2938 ns, **0.859×** |
| 65536 | 4096 | 24 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.2031 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 0.2279 ns, **0.891×** | FastFilterFixed32 @20 bpk: 0.2427 ns, **0.837×** |
| 65536 | 4096 | 24 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.1876 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 0.2048 ns, **0.916×** | FastFilterFixed32Bulk @24 bpk: 0.2252 ns, **0.833×** |
| 65536 | 4096 | 24 | 0.1% | parallel_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.1386 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 0.1548 ns, **0.895×** | FastFilterFixed32 @24 bpk: 0.1747 ns, **0.793×** |
| 65536 | 4096 | 24 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.2076 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2524 ns, **0.823×** | ByteSplitBloomFilter @16 bpk: 0.2728 ns, **0.761×** |
| 65536 | 4096 | 24 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.1582 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2031 ns, **0.779×** | ByteSplitBloomFilter @16 bpk: 0.2245 ns, **0.705×** |
| 65536 | 4096 | 24 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.1389 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1849 ns, **0.751×** | FourSectorBloomFilter @16 bpk: 0.1876 ns, **0.740×** |
| 65536 | 4096 | 24 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.0890 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1352 ns, **0.659×** | FourSectorBloomFilter @16 bpk: 0.1386 ns, **0.642×** |
| 65536 | 4096 | 32 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @32 bpk: 0.2131 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 0.2604 ns, **0.818×** | FourSectorRange12BloomFilter @24 bpk: 0.2780 ns, **0.767×** |
| 65536 | 4096 | 32 | 0.01% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @32 bpk: 0.1625 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 0.2104 ns, **0.772×** | FourSectorRange12BloomFilter @24 bpk: 0.2279 ns, **0.713×** |
| 65536 | 4096 | 32 | 0.01% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @32 bpk: 0.1460 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 0.1968 ns, **0.742×** | FourSectorRange12BloomFilter @24 bpk: 0.2048 ns, **0.713×** |
| 65536 | 4096 | 32 | 0.01% | parallel_lookup_gated_ns | 3 | FastPatternBF @32 bpk: 0.0971 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 0.1470 ns, **0.661×** | FourSectorRange12BloomFilter @24 bpk: 0.1548 ns, **0.627×** |
| 65536 | 4096 | 32 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @32 bpk: 0.2131 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2524 ns, **0.844×** | FourSectorRange12BloomFilter @24 bpk: 0.2780 ns, **0.767×** |
| 65536 | 4096 | 32 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @32 bpk: 0.1625 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2031 ns, **0.800×** | FourSectorRange12BloomFilter @24 bpk: 0.2279 ns, **0.713×** |
| 65536 | 4096 | 32 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @32 bpk: 0.1460 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.1876 ns, **0.778×** | ByteSplitBloomFilter @32 bpk: 0.1880 ns, **0.777×** |
| 65536 | 4096 | 32 | 0.1% | parallel_lookup_gated_ns | 3 | FastPatternBF @32 bpk: 0.0971 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.1386 ns, **0.701×** | ByteSplitBloomFilter @32 bpk: 0.1390 ns, **0.699×** |
| 65536 | 4096 | 32 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.2076 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2524 ns, **0.823×** | ByteSplitBloomFilter @16 bpk: 0.2728 ns, **0.761×** |
| 65536 | 4096 | 32 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.1582 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.2031 ns, **0.779×** | ByteSplitBloomFilter @16 bpk: 0.2245 ns, **0.705×** |
| 65536 | 4096 | 32 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.1389 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1849 ns, **0.751×** | FourSectorBloomFilter @16 bpk: 0.1876 ns, **0.740×** |
| 65536 | 4096 | 32 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.0890 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.1352 ns, **0.659×** | FourSectorBloomFilter @16 bpk: 0.1386 ns, **0.642×** |
| 33554432 | 4096 | 16 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | parallel_hash_lookup_gated_ns | 3 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | parallel_lookup_end_to_end_ns | 3 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | parallel_lookup_gated_ns | 3 | — | — | — |
| 33554432 | 4096 | 16 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6249 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6370 ns, **0.981×** | Split64RangeBloomFilter @16 bpk: 0.6430 ns, **0.972×** |
| 33554432 | 4096 | 16 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5682 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.5809 ns, **0.978×** | Split64RangeBloomFilter @16 bpk: 0.5864 ns, **0.969×** |
| 33554432 | 4096 | 16 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6431 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6837 ns, **0.941×** | Split64RangeBloomFilter @16 bpk: 0.7272 ns, **0.884×** |
| 33554432 | 4096 | 16 | 0.1% | parallel_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5869 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6288 ns, **0.933×** | Split64RangeBloomFilter @16 bpk: 0.6697 ns, **0.876×** |
| 33554432 | 4096 | 16 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6122 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 0.6233 ns, **0.982×** | FourSectorBloomFilter @16 bpk: 0.6249 ns, **0.980×** |
| 33554432 | 4096 | 16 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5567 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5682 ns, **0.980×** | Boost192Multi32K8 @12 bpk: 0.5690 ns, **0.978×** |
| 33554432 | 4096 | 16 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6075 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.6431 ns, **0.945×** | Boost192Multi32K8 @12 bpk: 0.6540 ns, **0.929×** |
| 33554432 | 4096 | 16 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5515 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5869 ns, **0.940×** | Boost192Multi32K8 @12 bpk: 0.5984 ns, **0.922×** |
| 33554432 | 4096 | 24 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7529 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.7792 ns, **0.966×** | Boost192Multi64K8 @24 bpk: 0.8228 ns, **0.915×** |
| 33554432 | 4096 | 24 | 0.01% | parallel_hash_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.6962 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.7224 ns, **0.964×** | Boost192Multi64K8 @24 bpk: 0.7652 ns, **0.910×** |
| 33554432 | 4096 | 24 | 0.01% | parallel_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7953 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.8531 ns, **0.932×** | Boost192Multi64K8 @24 bpk: 0.8969 ns, **0.887×** |
| 33554432 | 4096 | 24 | 0.01% | parallel_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7369 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.7941 ns, **0.928×** | Boost192Multi64K8 @24 bpk: 0.8376 ns, **0.880×** |
| 33554432 | 4096 | 24 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6249 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6370 ns, **0.981×** | Split64RangeBloomFilter @16 bpk: 0.6430 ns, **0.972×** |
| 33554432 | 4096 | 24 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5682 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.5809 ns, **0.978×** | Split64RangeBloomFilter @16 bpk: 0.5864 ns, **0.969×** |
| 33554432 | 4096 | 24 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6431 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6837 ns, **0.941×** | Split64RangeBloomFilter @16 bpk: 0.7272 ns, **0.884×** |
| 33554432 | 4096 | 24 | 0.1% | parallel_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5869 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6288 ns, **0.933×** | Split64RangeBloomFilter @16 bpk: 0.6697 ns, **0.876×** |
| 33554432 | 4096 | 24 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6122 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 0.6233 ns, **0.982×** | FourSectorBloomFilter @16 bpk: 0.6249 ns, **0.980×** |
| 33554432 | 4096 | 24 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5567 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5682 ns, **0.980×** | Boost192Multi32K8 @12 bpk: 0.5690 ns, **0.978×** |
| 33554432 | 4096 | 24 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6075 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.6431 ns, **0.945×** | Boost192Multi32K8 @12 bpk: 0.6540 ns, **0.929×** |
| 33554432 | 4096 | 24 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5515 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5869 ns, **0.940×** | Boost192Multi32K8 @12 bpk: 0.5984 ns, **0.922×** |
| 33554432 | 4096 | 32 | 0.01% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7529 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.7792 ns, **0.966×** | Boost192Multi64K8 @24 bpk: 0.8228 ns, **0.915×** |
| 33554432 | 4096 | 32 | 0.01% | parallel_hash_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.6962 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 0.7224 ns, **0.964×** | Boost192Multi64K8 @24 bpk: 0.7652 ns, **0.910×** |
| 33554432 | 4096 | 32 | 0.01% | parallel_lookup_end_to_end_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7953 ns, **1.000×** | FastPatternBF @32 bpk: 0.8396 ns, **0.947×** | Split64RangeBloomFilter @24 bpk: 0.8531 ns, **0.932×** |
| 33554432 | 4096 | 32 | 0.01% | parallel_lookup_gated_ns | 3 | FourSectorRange12BloomFilter @24 bpk: 0.7369 ns, **1.000×** | FastPatternBF @32 bpk: 0.7805 ns, **0.944×** | Split64RangeBloomFilter @24 bpk: 0.7941 ns, **0.928×** |
| 33554432 | 4096 | 32 | 0.1% | parallel_hash_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6249 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6370 ns, **0.981×** | Split64RangeBloomFilter @16 bpk: 0.6430 ns, **0.972×** |
| 33554432 | 4096 | 32 | 0.1% | parallel_hash_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5682 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.5809 ns, **0.978×** | Split64RangeBloomFilter @16 bpk: 0.5864 ns, **0.969×** |
| 33554432 | 4096 | 32 | 0.1% | parallel_lookup_end_to_end_ns | 3 | FourSectorBloomFilter @16 bpk: 0.6431 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6837 ns, **0.941×** | Split64RangeBloomFilter @16 bpk: 0.7272 ns, **0.884×** |
| 33554432 | 4096 | 32 | 0.1% | parallel_lookup_gated_ns | 3 | FourSectorBloomFilter @16 bpk: 0.5869 ns, **1.000×** | Split64BloomFilter @16 bpk: 0.6288 ns, **0.933×** | Split64RangeBloomFilter @16 bpk: 0.6697 ns, **0.876×** |
| 33554432 | 4096 | 32 | 1% | parallel_hash_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6122 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 0.6233 ns, **0.982×** | FourSectorBloomFilter @16 bpk: 0.6249 ns, **0.980×** |
| 33554432 | 4096 | 32 | 1% | parallel_hash_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5567 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5682 ns, **0.980×** | Boost192Multi32K8 @12 bpk: 0.5690 ns, **0.978×** |
| 33554432 | 4096 | 32 | 1% | parallel_lookup_end_to_end_ns | 3 | FastPatternBF @16 bpk: 0.6075 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.6431 ns, **0.945×** | Boost192Multi32K8 @12 bpk: 0.6540 ns, **0.929×** |
| 33554432 | 4096 | 32 | 1% | parallel_lookup_gated_ns | 3 | FastPatternBF @16 bpk: 0.5515 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 0.5869 ns, **0.940×** | Boost192Multi32K8 @12 bpk: 0.5984 ns, **0.922×** |
## CPP_build234

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 65536 | 16 | 0.01% | allocate_hash_insert_ns | 3 | — | — | — |
| 65536 | 65536 | 16 | 0.01% | allocate_insert_ns | 3 | — | — | — |
| 65536 | 65536 | 16 | 0.01% | hash_insert_ns | 3 | — | — | — |
| 65536 | 65536 | 16 | 0.01% | insert_ns | 3 | — | — | — |
| 65536 | 65536 | 16 | 0.1% | allocate_hash_insert_ns | 3 | Split64P32 @16 bpk: 2.3330 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 2.3959 ns, **0.974×** | FastFilterFixed64 @16 bpk: 2.8715 ns, **0.812×** |
| 65536 | 65536 | 16 | 0.1% | allocate_insert_ns | 3 | Split64P32 @16 bpk: 1.8491 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 1.9371 ns, **0.955×** | FastFilterFixed64 @16 bpk: 2.4918 ns, **0.742×** |
| 65536 | 65536 | 16 | 0.1% | hash_insert_ns | 3 | Split64P32 @16 bpk: 2.0430 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 2.3577 ns, **0.867×** | FastFilterFixed64 @16 bpk: 2.3643 ns, **0.864×** |
| 65536 | 65536 | 16 | 0.1% | insert_ns | 3 | Split64P32 @16 bpk: 1.5851 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 1.8961 ns, **0.836×** | FastFilterFixed64 @16 bpk: 1.9022 ns, **0.833×** |
| 65536 | 65536 | 16 | 1% | allocate_hash_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.4638 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.6684 ns, **0.877×** | FastFilterFixed32 @16 bpk: 1.7914 ns, **0.817×** |
| 65536 | 65536 | 16 | 1% | allocate_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.0484 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.2370 ns, **0.847×** | FastFilterFixed32 @16 bpk: 1.3580 ns, **0.772×** |
| 65536 | 65536 | 16 | 1% | hash_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.4256 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.6258 ns, **0.877×** | FastFilterFixed32 @16 bpk: 1.7498 ns, **0.815×** |
| 65536 | 65536 | 16 | 1% | insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.0113 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.1933 ns, **0.847×** | FastFilterFixed32 @16 bpk: 1.3150 ns, **0.769×** |
| 65536 | 65536 | 32 | 0.01% | allocate_hash_insert_ns | 3 | FastFilterSimdBlock @32 bpk: 1.8653 ns, **1.000×** | Boost192Multi32K8 @32 bpk: 1.8714 ns, **0.997×** | FastFilterFixed32 @32 bpk: 1.9610 ns, **0.951×** |
| 65536 | 65536 | 32 | 0.01% | allocate_insert_ns | 3 | FastFilterSimdBlock @32 bpk: 1.4218 ns, **1.000×** | Boost192Multi32K8 @32 bpk: 1.4636 ns, **0.971×** | FastFilterFixed32 @32 bpk: 1.5377 ns, **0.925×** |
| 65536 | 65536 | 32 | 0.01% | hash_insert_ns | 3 | FastFilterSimdBlock @32 bpk: 1.7571 ns, **1.000×** | Boost192Multi32K8 @32 bpk: 1.7924 ns, **0.980×** | FastFilterFixed32 @32 bpk: 1.8644 ns, **0.942×** |
| 65536 | 65536 | 32 | 0.01% | insert_ns | 3 | FastFilterSimdBlock @32 bpk: 1.3137 ns, **1.000×** | Boost192Multi32K8 @32 bpk: 1.3848 ns, **0.949×** | FastFilterFixed32 @32 bpk: 1.4396 ns, **0.913×** |
| 65536 | 65536 | 32 | 0.1% | allocate_hash_insert_ns | 3 | FastFilterFixed16 @32 bpk: 1.6893 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.8653 ns, **0.906×** | Boost192Multi32K8 @32 bpk: 1.8714 ns, **0.903×** |
| 65536 | 65536 | 32 | 0.1% | allocate_insert_ns | 3 | FastFilterFixed16 @32 bpk: 1.2798 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.4218 ns, **0.900×** | Boost192Multi32K8 @32 bpk: 1.4636 ns, **0.874×** |
| 65536 | 65536 | 32 | 0.1% | hash_insert_ns | 3 | FastFilterFixed16 @32 bpk: 1.6098 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.7571 ns, **0.916×** | Boost192Multi32K8 @32 bpk: 1.7924 ns, **0.898×** |
| 65536 | 65536 | 32 | 0.1% | insert_ns | 3 | FastFilterFixed16 @32 bpk: 1.1985 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.3137 ns, **0.912×** | Boost192Multi32K8 @32 bpk: 1.3848 ns, **0.865×** |
| 65536 | 65536 | 32 | 1% | allocate_hash_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.4638 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.6684 ns, **0.877×** | FastFilterFixed32 @16 bpk: 1.7914 ns, **0.817×** |
| 65536 | 65536 | 32 | 1% | allocate_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.0484 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.2370 ns, **0.847×** | FastFilterFixed32 @16 bpk: 1.3580 ns, **0.772×** |
| 65536 | 65536 | 32 | 1% | hash_insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.4256 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.6258 ns, **0.877×** | FastFilterFixed32 @16 bpk: 1.7498 ns, **0.815×** |
| 65536 | 65536 | 32 | 1% | insert_ns | 3 | FastFilterFixed16 @16 bpk: 1.0113 ns, **1.000×** | FastFilterSimdBlock @16 bpk: 1.1933 ns, **0.847×** | FastFilterFixed32 @16 bpk: 1.3150 ns, **0.769×** |
| 16777216 | 16777216 | 16 | 0.01% | allocate_hash_insert_ns | 3 | — | — | — |
| 16777216 | 16777216 | 16 | 0.01% | allocate_insert_ns | 3 | — | — | — |
| 16777216 | 16777216 | 16 | 0.01% | hash_insert_ns | 3 | — | — | — |
| 16777216 | 16777216 | 16 | 0.01% | insert_ns | 3 | — | — | — |
| 16777216 | 16777216 | 16 | 0.1% | allocate_hash_insert_ns | 3 | Split64P32 @16 bpk: 5.3600 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.6244 ns, **0.953×** | FourSector16K8 @16 bpk: 5.9762 ns, **0.897×** |
| 16777216 | 16777216 | 16 | 0.1% | allocate_insert_ns | 3 | Split64P32 @16 bpk: 4.3773 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.6930 ns, **0.933×** | FourSector16K8 @16 bpk: 5.0320 ns, **0.870×** |
| 16777216 | 16777216 | 16 | 0.1% | hash_insert_ns | 3 | Split64P32 @16 bpk: 5.1593 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.4254 ns, **0.951×** | FourSector16K8 @16 bpk: 5.7763 ns, **0.893×** |
| 16777216 | 16777216 | 16 | 0.1% | insert_ns | 3 | Split64P32 @16 bpk: 4.1758 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.4926 ns, **0.929×** | FourSector16K8 @16 bpk: 4.8317 ns, **0.864×** |
| 16777216 | 16777216 | 16 | 1% | allocate_hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.2962 ns, **1.000×** | Split64P32 @16 bpk: 5.3600 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 5.5138 ns, **0.961×** |
| 16777216 | 16777216 | 16 | 1% | allocate_insert_ns | 3 | FastPatternBF @16 bpk: 4.3282 ns, **1.000×** | Split64P32 @16 bpk: 4.3773 ns, **0.989×** | Boost192Multi32K8 @16 bpk: 4.5600 ns, **0.949×** |
| 16777216 | 16777216 | 16 | 1% | hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.0965 ns, **1.000×** | Split64P32 @16 bpk: 5.1593 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 5.3146 ns, **0.959×** |
| 16777216 | 16777216 | 16 | 1% | insert_ns | 3 | FastPatternBF @16 bpk: 4.1275 ns, **1.000×** | Split64P32 @16 bpk: 4.1758 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 4.3595 ns, **0.947×** |
| 16777216 | 16777216 | 32 | 0.01% | allocate_hash_insert_ns | 3 | FastPatternBF @32 bpk: 5.8499 ns, **1.000×** | Split64P32 @32 bpk: 5.8795 ns, **0.995×** | Boost192Multi32K8 @32 bpk: 6.0656 ns, **0.964×** |
| 16777216 | 16777216 | 32 | 0.01% | allocate_insert_ns | 3 | FastPatternBF @32 bpk: 4.6889 ns, **1.000×** | Split64P32 @32 bpk: 4.7166 ns, **0.994×** | Boost192Multi32K8 @32 bpk: 4.9376 ns, **0.950×** |
| 16777216 | 16777216 | 32 | 0.01% | hash_insert_ns | 3 | FastPatternBF @32 bpk: 5.4509 ns, **1.000×** | Split64P32 @32 bpk: 5.4845 ns, **0.994×** | Boost192Multi32K8 @32 bpk: 5.6741 ns, **0.961×** |
| 16777216 | 16777216 | 32 | 0.01% | insert_ns | 3 | FastPatternBF @32 bpk: 4.2930 ns, **1.000×** | Split64P32 @32 bpk: 4.3273 ns, **0.992×** | Boost192Multi32K8 @32 bpk: 4.5472 ns, **0.944×** |
| 16777216 | 16777216 | 32 | 0.1% | allocate_hash_insert_ns | 3 | Split64P32 @16 bpk: 5.3600 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.6244 ns, **0.953×** | FastPatternBF @32 bpk: 5.8499 ns, **0.916×** |
| 16777216 | 16777216 | 32 | 0.1% | allocate_insert_ns | 3 | Split64P32 @16 bpk: 4.3773 ns, **1.000×** | FastPatternBF @32 bpk: 4.6889 ns, **0.934×** | Boost192Multi64K8 @16 bpk: 4.6930 ns, **0.933×** |
| 16777216 | 16777216 | 32 | 0.1% | hash_insert_ns | 3 | Split64P32 @16 bpk: 5.1593 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.4254 ns, **0.951×** | FastPatternBF @32 bpk: 5.4509 ns, **0.947×** |
| 16777216 | 16777216 | 32 | 0.1% | insert_ns | 3 | Split64P32 @16 bpk: 4.1758 ns, **1.000×** | FastPatternBF @32 bpk: 4.2930 ns, **0.973×** | Boost192Multi64K8 @16 bpk: 4.4926 ns, **0.929×** |
| 16777216 | 16777216 | 32 | 1% | allocate_hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.2962 ns, **1.000×** | Split64P32 @16 bpk: 5.3600 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 5.5138 ns, **0.961×** |
| 16777216 | 16777216 | 32 | 1% | allocate_insert_ns | 3 | FastPatternBF @16 bpk: 4.3282 ns, **1.000×** | Split64P32 @16 bpk: 4.3773 ns, **0.989×** | Boost192Multi32K8 @16 bpk: 4.5600 ns, **0.949×** |
| 16777216 | 16777216 | 32 | 1% | hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.0965 ns, **1.000×** | Split64P32 @16 bpk: 5.1593 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 5.3146 ns, **0.959×** |
| 16777216 | 16777216 | 32 | 1% | insert_ns | 3 | FastPatternBF @16 bpk: 4.1275 ns, **1.000×** | Split64P32 @16 bpk: 4.1758 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 4.3595 ns, **0.947×** |
| 33554432 | 33554432 | 16 | 0.01% | allocate_hash_insert_ns | 3 | — | — | — |
| 33554432 | 33554432 | 16 | 0.01% | allocate_insert_ns | 3 | — | — | — |
| 33554432 | 33554432 | 16 | 0.01% | hash_insert_ns | 3 | — | — | — |
| 33554432 | 33554432 | 16 | 0.01% | insert_ns | 3 | — | — | — |
| 33554432 | 33554432 | 16 | 0.1% | allocate_hash_insert_ns | 3 | Split64P32 @16 bpk: 5.5708 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.8989 ns, **0.944×** | FourSector16K8 @16 bpk: 6.3026 ns, **0.884×** |
| 33554432 | 33554432 | 16 | 0.1% | allocate_insert_ns | 3 | Split64P32 @16 bpk: 4.5473 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.8914 ns, **0.930×** | FourSector16K8 @16 bpk: 5.2758 ns, **0.862×** |
| 33554432 | 33554432 | 16 | 0.1% | hash_insert_ns | 3 | Split64P32 @16 bpk: 5.3752 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.7032 ns, **0.942×** | FourSector16K8 @16 bpk: 6.1057 ns, **0.880×** |
| 33554432 | 33554432 | 16 | 0.1% | insert_ns | 3 | Split64P32 @16 bpk: 4.3481 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.6955 ns, **0.926×** | FourSector16K8 @16 bpk: 5.0787 ns, **0.856×** |
| 33554432 | 33554432 | 16 | 1% | allocate_hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.5193 ns, **1.000×** | Split64P32 @16 bpk: 5.5708 ns, **0.991×** | Boost192Multi32K8 @16 bpk: 5.7970 ns, **0.952×** |
| 33554432 | 33554432 | 16 | 1% | allocate_insert_ns | 3 | FastPatternBF @16 bpk: 4.4992 ns, **1.000×** | Split64P32 @16 bpk: 4.5473 ns, **0.989×** | Boost192Multi32K8 @16 bpk: 4.7589 ns, **0.945×** |
| 33554432 | 33554432 | 16 | 1% | hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.3245 ns, **1.000×** | Split64P32 @16 bpk: 5.3752 ns, **0.991×** | Boost192Multi32K8 @16 bpk: 5.5990 ns, **0.951×** |
| 33554432 | 33554432 | 16 | 1% | insert_ns | 3 | FastPatternBF @16 bpk: 4.2952 ns, **1.000×** | Split64P32 @16 bpk: 4.3481 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 4.5623 ns, **0.941×** |
| 33554432 | 33554432 | 32 | 0.01% | allocate_hash_insert_ns | 3 | Split64P32 @32 bpk: 7.2972 ns, **1.000×** | FastPatternBF @32 bpk: 7.3843 ns, **0.988×** | Boost192Multi32K8 @32 bpk: 7.4929 ns, **0.974×** |
| 33554432 | 33554432 | 32 | 0.01% | allocate_insert_ns | 3 | FastPatternBF @32 bpk: 6.3351 ns, **1.000×** | Split64P32 @32 bpk: 6.3605 ns, **0.996×** | Boost192Multi32K8 @32 bpk: 6.4310 ns, **0.985×** |
| 33554432 | 33554432 | 32 | 0.01% | hash_insert_ns | 3 | Split64P32 @32 bpk: 6.7619 ns, **1.000×** | FastPatternBF @32 bpk: 6.8432 ns, **0.988×** | Boost192Multi32K8 @32 bpk: 6.9580 ns, **0.972×** |
| 33554432 | 33554432 | 32 | 0.01% | insert_ns | 3 | FastPatternBF @32 bpk: 5.7911 ns, **1.000×** | Split64P32 @32 bpk: 5.8115 ns, **0.996×** | Boost192Multi32K8 @32 bpk: 5.8832 ns, **0.984×** |
| 33554432 | 33554432 | 32 | 0.1% | allocate_hash_insert_ns | 3 | Split64P32 @16 bpk: 5.5708 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.8989 ns, **0.944×** | FourSector16K8 @16 bpk: 6.3026 ns, **0.884×** |
| 33554432 | 33554432 | 32 | 0.1% | allocate_insert_ns | 3 | Split64P32 @16 bpk: 4.5473 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.8914 ns, **0.930×** | FourSector16K8 @16 bpk: 5.2758 ns, **0.862×** |
| 33554432 | 33554432 | 32 | 0.1% | hash_insert_ns | 3 | Split64P32 @16 bpk: 5.3752 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 5.7032 ns, **0.942×** | FourSector16K8 @16 bpk: 6.1057 ns, **0.880×** |
| 33554432 | 33554432 | 32 | 0.1% | insert_ns | 3 | Split64P32 @16 bpk: 4.3481 ns, **1.000×** | Boost192Multi64K8 @16 bpk: 4.6955 ns, **0.926×** | FourSector16K8 @16 bpk: 5.0787 ns, **0.856×** |
| 33554432 | 33554432 | 32 | 1% | allocate_hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.5193 ns, **1.000×** | Split64P32 @16 bpk: 5.5708 ns, **0.991×** | Boost192Multi32K8 @16 bpk: 5.7970 ns, **0.952×** |
| 33554432 | 33554432 | 32 | 1% | allocate_insert_ns | 3 | FastPatternBF @16 bpk: 4.4992 ns, **1.000×** | Split64P32 @16 bpk: 4.5473 ns, **0.989×** | Boost192Multi32K8 @16 bpk: 4.7589 ns, **0.945×** |
| 33554432 | 33554432 | 32 | 1% | hash_insert_ns | 3 | FastPatternBF @16 bpk: 5.3245 ns, **1.000×** | Split64P32 @16 bpk: 5.3752 ns, **0.991×** | Boost192Multi32K8 @16 bpk: 5.5990 ns, **0.951×** |
| 33554432 | 33554432 | 32 | 1% | insert_ns | 3 | FastPatternBF @16 bpk: 4.2952 ns, **1.000×** | Split64P32 @16 bpk: 4.3481 ns, **0.988×** | Boost192Multi32K8 @16 bpk: 4.5623 ns, **0.941×** |
## CPP_prefetch192

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 1 | 16 | 1% | generic_pure | 4 | ByteSplitBloomFilter @16 bpk: 2.2684 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 2.4705 ns, **0.918×** | FastFilterFixed16 @16 bpk: 2.5792 ns, **0.880×** |
| 65536 | 1 | 16 | 1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 4.2051 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.4252 ns, **0.950×** | FastFilterFixed16SingleV1 @16 bpk: 4.4901 ns, **0.937×** |
| 65536 | 1 | 16 | 1% | visible_public_fused_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 1.6118 ns, **1.000×** | FastFilterFixed16 @16 bpk: 1.8017 ns, **0.895×** | FastFilterFixed16SingleV1 @16 bpk: 1.8137 ns, **0.889×** |
| 65536 | 1 | 16 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 1.0110 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.1000 ns, **0.919×** | FastFilterFixed16 @16 bpk: 1.1098 ns, **0.911×** |
| 65536 | 31 | 16 | 1% | generic_pure | 4 | FastPatternBF @16 bpk: 0.9977 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.0511 ns, **0.949×** | FourSectorBloomFilter @16 bpk: 1.2688 ns, **0.786×** |
| 65536 | 31 | 16 | 1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 1.5501 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.6952 ns, **0.914×** | FastFilterFixed16 @16 bpk: 1.6999 ns, **0.912×** |
| 65536 | 4096 | 16 | 1% | generic_pure | 4 | FastPatternBF @16 bpk: 0.7016 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 0.9955 ns, **0.705×** | FourSectorBloomFilter @16 bpk: 1.0792 ns, **0.650×** |
| 65536 | 4096 | 16 | 1% | generic_staged_common_hash | 4 | FastPatternBF @16 bpk: 1.1829 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.5011 ns, **0.788×** | FourSectorBloomFilter @16 bpk: 1.5766 ns, **0.750×** |
| 33554432 | 1 | 16 | 1% | generic_pure | 4 | Boost192Multi32K8 @12 bpk: 7.7055 ns, **1.000×** | Independent32RangeBloomFilter @12 bpk: 8.3838 ns, **0.919×** | ByteSplitBloomFilter @16 bpk: 8.4299 ns, **0.914×** |
| 33554432 | 1 | 16 | 1% | generic_staged_common_hash | 4 | Boost192Multi32K8 @12 bpk: 11.6534 ns, **1.000×** | Independent32RangeBloomFilter @12 bpk: 12.4246 ns, **0.938×** | ByteSplitBloomFilter @16 bpk: 12.4283 ns, **0.938×** |
| 33554432 | 1 | 16 | 1% | visible_public_fused_common_hash | 4 | Independent32RangeBloomFilter @12 bpk: 6.0021 ns, **1.000×** | Independent32RangePrefetch64BloomFilter @12 bpk: 6.0492 ns, **0.992×** | Boost192Multi32K8 @12 bpk: 6.0883 ns, **0.986×** |
| 33554432 | 1 | 16 | 1% | visible_public_pure | 4 | Independent32RangeBloomFilter @12 bpk: 5.3900 ns, **1.000×** | Independent32RangePrefetch64BloomFilter @12 bpk: 5.3959 ns, **0.999×** | ByteSplitBloomFilter @16 bpk: 5.4762 ns, **0.984×** |
| 33554432 | 31 | 16 | 1% | generic_pure | 4 | FastPatternBF @16 bpk: 5.1957 ns, **1.000×** | Independent32RangeBloomFilter @12 bpk: 5.3383 ns, **0.973×** | Independent32RangePrefetch64BloomFilter @12 bpk: 5.3584 ns, **0.970×** |
| 33554432 | 31 | 16 | 1% | generic_staged_common_hash | 4 | Independent32RangeBloomFilter @12 bpk: 5.5452 ns, **1.000×** | Independent32RangePrefetch64BloomFilter @12 bpk: 5.5945 ns, **0.991×** | Boost192Multi32K8 @12 bpk: 5.6533 ns, **0.981×** |
| 33554432 | 4096 | 16 | 1% | generic_pure | 4 | FastPatternBF @16 bpk: 4.2143 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.5161 ns, **0.933×** | Boost192Multi32K8 @12 bpk: 4.7478 ns, **0.888×** |
| 33554432 | 4096 | 16 | 1% | generic_staged_common_hash | 4 | Independent32RangePrefetch64BloomFilter @12 bpk: 4.0821 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 4.1164 ns, **0.992×** | FastPatternBF @16 bpk: 4.1491 ns, **0.984×** |
## CPP_singleton616

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 1 | 16 | 0.01% | generic_pure | 4 | — | — | — |
| 65536 | 1 | 16 | 0.01% | generic_staged_common_hash | 4 | — | — | — |
| 65536 | 1 | 16 | 0.01% | visible_public_fused_common_hash | 4 | — | — | — |
| 65536 | 1 | 16 | 0.01% | visible_public_pure | 4 | — | — | — |
| 65536 | 1 | 16 | 0.1% | generic_pure | 4 | Split64BloomFilter @16 bpk: 2.8665 ns, **1.000×** | Split64Range @16 bpk: 2.9405 ns, **0.975×** | Boost192Multi64K8 @16 bpk: 3.6086 ns, **0.794×** |
| 65536 | 1 | 16 | 0.1% | generic_staged_common_hash | 4 | Split64BloomFilter @16 bpk: 4.4003 ns, **1.000×** | Split64Range @16 bpk: 4.7304 ns, **0.930×** | RocksDBFastLocalBloom64K8 @16 bpk: 5.5182 ns, **0.797×** |
| 65536 | 1 | 16 | 0.1% | visible_public_fused_common_hash | 4 | Split64BloomFilter @16 bpk: 2.0135 ns, **1.000×** | Split64Range @16 bpk: 2.0165 ns, **0.999×** | RocksDBFastLocalBloom64K8 @16 bpk: 3.0431 ns, **0.662×** |
| 65536 | 1 | 16 | 0.1% | visible_public_pure | 4 | Split64BloomFilter @16 bpk: 1.5345 ns, **1.000×** | Split64Range @16 bpk: 1.6020 ns, **0.958×** | FastFilterFixed64 @16 bpk: 2.1533 ns, **0.713×** |
| 65536 | 1 | 16 | 1% | generic_pure | 4 | ByteSplitBloomFilter @16 bpk: 2.2653 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 2.4701 ns, **0.917×** | FastFilterFixed16 @16 bpk: 2.5858 ns, **0.876×** |
| 65536 | 1 | 16 | 1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 4.1915 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.4003 ns, **0.953×** | FastFilterFixed16SingleV1 @14 bpk: 4.4846 ns, **0.935×** |
| 65536 | 1 | 16 | 1% | visible_public_fused_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 1.6809 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.8129 ns, **0.927×** | FastFilterFixed16 @16 bpk: 1.8138 ns, **0.927×** |
| 65536 | 1 | 16 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 1.0281 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.1257 ns, **0.913×** | FastFilterFixed16 @16 bpk: 1.1377 ns, **0.904×** |
| 65536 | 1 | 24 | 0.01% | generic_pure | 4 | Split64Range @24 bpk: 2.9937 ns, **1.000×** | FastFilterFixed64 @24 bpk: 3.6349 ns, **0.824×** | K12SingletonVector @24 bpk: 4.4299 ns, **0.676×** |
| 65536 | 1 | 24 | 0.01% | generic_staged_common_hash | 4 | Split64Range @24 bpk: 4.7396 ns, **1.000×** | FastFilterFixed64 @24 bpk: 5.6471 ns, **0.839×** | K12SingletonVector @24 bpk: 5.7892 ns, **0.819×** |
| 65536 | 1 | 24 | 0.01% | visible_public_fused_common_hash | 4 | Split64Range @24 bpk: 2.0277 ns, **1.000×** | K12SingletonVector @24 bpk: 2.9448 ns, **0.689×** | FastFilterFixed64 @24 bpk: 3.0609 ns, **0.662×** |
| 65536 | 1 | 24 | 0.01% | visible_public_pure | 4 | Split64Range @24 bpk: 1.5999 ns, **1.000×** | FastFilterFixed64 @24 bpk: 2.1706 ns, **0.737×** | K12SingletonVector @24 bpk: 2.4934 ns, **0.642×** |
| 65536 | 1 | 24 | 0.1% | generic_pure | 4 | FastFilterFixed32 @20 bpk: 2.7046 ns, **1.000×** | FastFilterFixed32Bulk @24 bpk: 2.7121 ns, **0.997×** | Boost192Multi32K8 @24 bpk: 2.8121 ns, **0.962×** |
| 65536 | 1 | 24 | 0.1% | generic_staged_common_hash | 4 | Split64BloomFilter @16 bpk: 4.4003 ns, **1.000×** | Split64Range @16 bpk: 4.7304 ns, **0.930×** | FastFilterFixed32 @20 bpk: 4.7855 ns, **0.919×** |
| 65536 | 1 | 24 | 0.1% | visible_public_fused_common_hash | 4 | FastFilterFixed32 @20 bpk: 1.8785 ns, **1.000×** | FastFilterFixed32Bulk @24 bpk: 1.8798 ns, **0.999×** | Split64BloomFilter @16 bpk: 2.0135 ns, **0.933×** |
| 65536 | 1 | 24 | 0.1% | visible_public_pure | 4 | Boost192Multi32K8 @24 bpk: 1.3407 ns, **1.000×** | FastFilterFixed32 @20 bpk: 1.3465 ns, **0.996×** | FastFilterFixed32Bulk @24 bpk: 1.3488 ns, **0.994×** |
| 65536 | 1 | 24 | 1% | generic_pure | 4 | ByteSplitBloomFilter @16 bpk: 2.2653 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 2.4701 ns, **0.917×** | FastFilterFixed16 @16 bpk: 2.5858 ns, **0.876×** |
| 65536 | 1 | 24 | 1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 4.1915 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.4003 ns, **0.953×** | FastFilterFixed16SingleV1 @14 bpk: 4.4846 ns, **0.935×** |
| 65536 | 1 | 24 | 1% | visible_public_fused_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 1.6809 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.8129 ns, **0.927×** | FastFilterFixed16 @16 bpk: 1.8138 ns, **0.927×** |
| 65536 | 1 | 24 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 1.0281 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.1257 ns, **0.913×** | FastFilterFixed16 @16 bpk: 1.1377 ns, **0.904×** |
| 65536 | 1 | 32 | 0.01% | generic_pure | 4 | FastFilterSimdBlockSingleV1 @32 bpk: 2.6242 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 2.6642 ns, **0.985×** | FastFilterFixed32 @28 bpk: 2.7175 ns, **0.966×** |
| 65536 | 1 | 32 | 0.01% | generic_staged_common_hash | 4 | Split64BloomFilter @32 bpk: 4.4227 ns, **1.000×** | FastFilterSimdBlockSingleV1 @32 bpk: 4.5213 ns, **0.978×** | FastFilterSimdBlock @32 bpk: 4.5928 ns, **0.963×** |
| 65536 | 1 | 32 | 0.01% | visible_public_fused_common_hash | 4 | FastFilterFixed32 @28 bpk: 1.8805 ns, **1.000×** | FastFilterFixed32Bulk @32 bpk: 1.8812 ns, **1.000×** | FastFilterSimdBlockSingleV1 @32 bpk: 1.9603 ns, **0.959×** |
| 65536 | 1 | 32 | 0.01% | visible_public_pure | 4 | FastFilterSimdBlockSingleV1 @32 bpk: 1.2626 ns, **1.000×** | FastFilterSimdBlock @32 bpk: 1.2649 ns, **0.998×** | FastFilterFixed32 @28 bpk: 1.3512 ns, **0.934×** |
| 65536 | 1 | 32 | 0.1% | generic_pure | 4 | ByteSplitBloomFilter @32 bpk: 2.3079 ns, **1.000×** | FastFilterFixed16SingleV1 @32 bpk: 2.5143 ns, **0.918×** | FastFilterFixed16 @28 bpk: 2.6242 ns, **0.879×** |
| 65536 | 1 | 32 | 0.1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @32 bpk: 4.2338 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.4003 ns, **0.962×** | FastFilterFixed16SingleV1 @32 bpk: 4.5207 ns, **0.937×** |
| 65536 | 1 | 32 | 0.1% | visible_public_fused_common_hash | 4 | ByteSplitBloomFilter @32 bpk: 1.7046 ns, **1.000×** | FastFilterFixed16 @32 bpk: 1.8353 ns, **0.929×** | FastFilterFixed16SingleV1 @32 bpk: 1.8460 ns, **0.923×** |
| 65536 | 1 | 32 | 0.1% | visible_public_pure | 4 | ByteSplitBloomFilter @32 bpk: 1.0586 ns, **1.000×** | FastFilterFixed16 @28 bpk: 1.1566 ns, **0.915×** | FastFilterFixed16SingleV1 @32 bpk: 1.1572 ns, **0.915×** |
| 65536 | 1 | 32 | 1% | generic_pure | 4 | ByteSplitBloomFilter @16 bpk: 2.2653 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 2.4701 ns, **0.917×** | FastFilterFixed16 @16 bpk: 2.5858 ns, **0.876×** |
| 65536 | 1 | 32 | 1% | generic_staged_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 4.1915 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.4003 ns, **0.953×** | FastFilterFixed16SingleV1 @14 bpk: 4.4846 ns, **0.935×** |
| 65536 | 1 | 32 | 1% | visible_public_fused_common_hash | 4 | ByteSplitBloomFilter @16 bpk: 1.6809 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.8129 ns, **0.927×** | FastFilterFixed16 @16 bpk: 1.8138 ns, **0.927×** |
| 65536 | 1 | 32 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 1.0281 ns, **1.000×** | FastFilterFixed16SingleV1 @14 bpk: 1.1257 ns, **0.913×** | FastFilterFixed16 @16 bpk: 1.1377 ns, **0.904×** |
| 33554432 | 1 | 16 | 0.01% | generic_pure | 4 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | generic_staged_common_hash | 4 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | visible_public_fused_common_hash | 4 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | visible_public_pure | 4 | — | — | — |
| 33554432 | 1 | 16 | 0.1% | generic_pure | 4 | Split64BloomFilter @16 bpk: 8.8763 ns, **1.000×** | Split64Range @16 bpk: 9.0812 ns, **0.977×** | Boost192Multi64K8 @16 bpk: 10.6218 ns, **0.836×** |
| 33554432 | 1 | 16 | 0.1% | generic_staged_common_hash | 4 | Split64Range @16 bpk: 13.4001 ns, **1.000×** | Split64BloomFilter @16 bpk: 13.4520 ns, **0.996×** | FastFilterFixed64 @16 bpk: 15.3471 ns, **0.873×** |
| 33554432 | 1 | 16 | 0.1% | visible_public_fused_common_hash | 4 | Split64Range @16 bpk: 7.3289 ns, **1.000×** | Split64BloomFilter @16 bpk: 7.3727 ns, **0.994×** | FastFilterFixed64 @16 bpk: 8.4559 ns, **0.867×** |
| 33554432 | 1 | 16 | 0.1% | visible_public_pure | 4 | Split64BloomFilter @16 bpk: 6.5076 ns, **1.000×** | Split64Range @16 bpk: 6.8312 ns, **0.953×** | Boost192Multi64K8 @16 bpk: 7.1120 ns, **0.915×** |
| 33554432 | 1 | 16 | 1% | generic_pure | 4 | Boost192Multi32K8 @12 bpk: 7.6263 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 8.7407 ns, **0.873×** | Split64BloomFilter @16 bpk: 8.8763 ns, **0.859×** |
| 33554432 | 1 | 16 | 1% | generic_staged_common_hash | 4 | Boost192Multi32K8 @12 bpk: 11.6213 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 12.9326 ns, **0.899×** | Boost192Multi32K4 @16 bpk: 13.3761 ns, **0.869×** |
| 33554432 | 1 | 16 | 1% | visible_public_fused_common_hash | 4 | Boost192Multi32K8 @12 bpk: 6.0978 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 7.0891 ns, **0.860×** | Split64Range @16 bpk: 7.3289 ns, **0.832×** |
| 33554432 | 1 | 16 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 5.5499 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 5.6328 ns, **0.985×** | FastFilterFixed16 @16 bpk: 6.0841 ns, **0.912×** |
| 33554432 | 1 | 24 | 0.01% | generic_pure | 4 | Split64Range @24 bpk: 12.1778 ns, **1.000×** | K12SingletonVector @24 bpk: 14.2215 ns, **0.856×** | Boost192Multi64K8 @24 bpk: 14.4260 ns, **0.844×** |
| 33554432 | 1 | 24 | 0.01% | generic_staged_common_hash | 4 | Split64Range @24 bpk: 18.1290 ns, **1.000×** | K12SingletonVector @24 bpk: 19.1302 ns, **0.948×** | Boost192Multi64K8 @24 bpk: 20.6884 ns, **0.876×** |
| 33554432 | 1 | 24 | 0.01% | visible_public_fused_common_hash | 4 | Split64Range @24 bpk: 9.5579 ns, **1.000×** | K12SingletonVector @24 bpk: 10.6129 ns, **0.901×** | RocksDBFastLocalBloom64K8Batch32 @24 bpk: 11.4673 ns, **0.833×** |
| 33554432 | 1 | 24 | 0.01% | visible_public_pure | 4 | Split64Range @24 bpk: 8.0175 ns, **1.000×** | Boost192Multi64K8 @24 bpk: 8.9504 ns, **0.896×** | K12SingletonVector @24 bpk: 9.4843 ns, **0.845×** |
| 33554432 | 1 | 24 | 0.1% | generic_pure | 4 | Split64BloomFilter @16 bpk: 8.8763 ns, **1.000×** | Split64Range @16 bpk: 9.0812 ns, **0.977×** | Boost192Multi64K8 @16 bpk: 10.6218 ns, **0.836×** |
| 33554432 | 1 | 24 | 0.1% | generic_staged_common_hash | 4 | Split64Range @16 bpk: 13.4001 ns, **1.000×** | Split64BloomFilter @16 bpk: 13.4520 ns, **0.996×** | FastFilterFixed64 @16 bpk: 15.3471 ns, **0.873×** |
| 33554432 | 1 | 24 | 0.1% | visible_public_fused_common_hash | 4 | Split64Range @16 bpk: 7.3289 ns, **1.000×** | Split64BloomFilter @16 bpk: 7.3727 ns, **0.994×** | FastFilterFixed64 @16 bpk: 8.4559 ns, **0.867×** |
| 33554432 | 1 | 24 | 0.1% | visible_public_pure | 4 | Split64BloomFilter @16 bpk: 6.5076 ns, **1.000×** | Split64Range @16 bpk: 6.8312 ns, **0.953×** | Boost192Multi64K8 @16 bpk: 7.1120 ns, **0.915×** |
| 33554432 | 1 | 24 | 1% | generic_pure | 4 | Boost192Multi32K8 @12 bpk: 7.6263 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 8.7407 ns, **0.873×** | Split64BloomFilter @16 bpk: 8.8763 ns, **0.859×** |
| 33554432 | 1 | 24 | 1% | generic_staged_common_hash | 4 | Boost192Multi32K8 @12 bpk: 11.6213 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 12.9326 ns, **0.899×** | Boost192Multi32K4 @16 bpk: 13.3761 ns, **0.869×** |
| 33554432 | 1 | 24 | 1% | visible_public_fused_common_hash | 4 | Boost192Multi32K8 @12 bpk: 6.0978 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 7.0891 ns, **0.860×** | Split64Range @16 bpk: 7.3289 ns, **0.832×** |
| 33554432 | 1 | 24 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 5.5499 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 5.6328 ns, **0.985×** | FastFilterFixed16 @16 bpk: 6.0841 ns, **0.912×** |
| 33554432 | 1 | 32 | 0.01% | generic_pure | 4 | Split64Range @24 bpk: 12.1778 ns, **1.000×** | Split64BloomFilter @32 bpk: 12.6729 ns, **0.961×** | Boost192Multi32K8 @28 bpk: 13.9376 ns, **0.874×** |
| 33554432 | 1 | 32 | 0.01% | generic_staged_common_hash | 4 | Split64Range @24 bpk: 18.1290 ns, **1.000×** | K12SingletonVector @24 bpk: 19.1302 ns, **0.948×** | Boost192Multi32K8 @28 bpk: 20.0545 ns, **0.904×** |
| 33554432 | 1 | 32 | 0.01% | visible_public_fused_common_hash | 4 | Split64Range @24 bpk: 9.5579 ns, **1.000×** | Split64BloomFilter @32 bpk: 9.9458 ns, **0.961×** | FastFilterFixed32Bulk @32 bpk: 10.4504 ns, **0.915×** |
| 33554432 | 1 | 32 | 0.01% | visible_public_pure | 4 | Split64Range @24 bpk: 8.0175 ns, **1.000×** | Boost192Multi32K8 @28 bpk: 8.1746 ns, **0.981×** | Split64BloomFilter @32 bpk: 8.2561 ns, **0.971×** |
| 33554432 | 1 | 32 | 0.1% | generic_pure | 4 | Split64BloomFilter @16 bpk: 8.8763 ns, **1.000×** | Split64Range @16 bpk: 9.0812 ns, **0.977×** | Boost192Multi64K8 @16 bpk: 10.6218 ns, **0.836×** |
| 33554432 | 1 | 32 | 0.1% | generic_staged_common_hash | 4 | Split64Range @16 bpk: 13.4001 ns, **1.000×** | Split64BloomFilter @16 bpk: 13.4520 ns, **0.996×** | FastFilterFixed64 @16 bpk: 15.3471 ns, **0.873×** |
| 33554432 | 1 | 32 | 0.1% | visible_public_fused_common_hash | 4 | Split64Range @16 bpk: 7.3289 ns, **1.000×** | Split64BloomFilter @16 bpk: 7.3727 ns, **0.994×** | FastFilterFixed64 @16 bpk: 8.4559 ns, **0.867×** |
| 33554432 | 1 | 32 | 0.1% | visible_public_pure | 4 | Split64BloomFilter @16 bpk: 6.5076 ns, **1.000×** | Split64Range @16 bpk: 6.8312 ns, **0.953×** | Boost192Multi64K8 @16 bpk: 7.1120 ns, **0.915×** |
| 33554432 | 1 | 32 | 1% | generic_pure | 4 | Boost192Multi32K8 @12 bpk: 7.6263 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 8.7407 ns, **0.873×** | Split64BloomFilter @16 bpk: 8.8763 ns, **0.859×** |
| 33554432 | 1 | 32 | 1% | generic_staged_common_hash | 4 | Boost192Multi32K8 @12 bpk: 11.6213 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 12.9326 ns, **0.899×** | Boost192Multi32K4 @16 bpk: 13.3761 ns, **0.869×** |
| 33554432 | 1 | 32 | 1% | visible_public_fused_common_hash | 4 | Boost192Multi32K8 @12 bpk: 6.0978 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 7.0891 ns, **0.860×** | Split64Range @16 bpk: 7.3289 ns, **0.832×** |
| 33554432 | 1 | 32 | 1% | visible_public_pure | 4 | ByteSplitBloomFilter @16 bpk: 5.5499 ns, **1.000×** | Boost192Multi32K8 @12 bpk: 5.6328 ns, **0.985×** | FastFilterFixed16 @16 bpk: 6.0841 ns, **0.912×** |
## Rust786

| Keys | Batch/context | Cap bpk | FPR ceiling | Metric | Cells | #1 | #2 | #3 |
|---:|---:|---:|---:|---|---:|---|---|---|
| 65536 | 1 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 65536 | 1 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 65536 | 1 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 65536 | 1 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 65536 | 1 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 2.3189 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.3264 ns, **0.997×** | FourSectorBloomFilter @16 bpk: 4.3668 ns, **0.531×** |
| 65536 | 1 | 16 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 5.5383 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 5.8485 ns, **0.947×** | FourSectorBloomFilter @16 bpk: 11.5903 ns, **0.478×** |
| 65536 | 1 | 16 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 2.2487 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.2789 ns, **0.987×** | FourSectorBloomFilter @16 bpk: 3.6069 ns, **0.623×** |
| 65536 | 1 | 16 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 3.0935 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.1382 ns, **0.986×** | FourSectorBloomFilter @16 bpk: 8.1433 ns, **0.380×** |
| 65536 | 1 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3774 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.3189 ns, **0.594×** | Split64RangeBloomFilter @16 bpk: 2.3264 ns, **0.592×** |
| 65536 | 1 | 16 | 1% | raw_batched_public | 1 | BloomsdayPinned @16 bpk: 4.5520 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.5287 ns, **0.823×** | Split64BloomFilter @16 bpk: 5.5383 ns, **0.822×** |
| 65536 | 1 | 16 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3317 ns, **1.000×** | BloomsdayPinned @16 bpk: 1.7020 ns, **0.782×** | FastPatternBF @16 bpk: 2.0199 ns, **0.659×** |
| 65536 | 1 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6361 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1529 ns, **0.760×** | SbbfSafePinned @16 bpk: 2.4274 ns, **0.674×** |
| 65536 | 1 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 3.4277 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.2028 ns, **0.816×** | Fastbloom017K7 @24 bpk: 7.5533 ns, **0.454×** |
| 65536 | 1 | 24 | 0.01% | raw_batched_public | 1 | Split64RangeBloomFilter @24 bpk: 5.8750 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 9.6649 ns, **0.608×** | Fastbloom017K7 @24 bpk: 18.4514 ns, **0.318×** |
| 65536 | 1 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 2.3099 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.0790 ns, **0.566×** | Fastbloom017K7 @24 bpk: 7.4298 ns, **0.311×** |
| 65536 | 1 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 3.1499 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 6.7484 ns, **0.467×** | Fastbloom017K7 @24 bpk: 14.2352 ns, **0.221×** |
| 65536 | 1 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | BloomsdayPinned @24 bpk: 1.7382 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.3189 ns, **0.750×** | Split64RangeBloomFilter @16 bpk: 2.3264 ns, **0.747×** |
| 65536 | 1 | 24 | 0.1% | raw_batched_public | 1 | BloomsdayPinned @24 bpk: 4.5701 ns, **1.000×** | Split64BloomFilter @16 bpk: 5.5383 ns, **0.825×** | Split64RangeBloomFilter @16 bpk: 5.8485 ns, **0.781×** |
| 65536 | 1 | 24 | 0.1% | raw_insert | 1 | BloomsdayPinned @24 bpk: 1.6699 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2487 ns, **0.743×** | Split64RangeBloomFilter @16 bpk: 2.2789 ns, **0.733×** |
| 65536 | 1 | 24 | 0.1% | raw_visible_public | 1 | BloomsdayPinned @24 bpk: 2.1667 ns, **1.000×** | SbbfSafePinned @24 bpk: 2.4328 ns, **0.891×** | Split64BloomFilter @16 bpk: 3.0935 ns, **0.700×** |
| 65536 | 1 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3774 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7382 ns, **0.792×** | Split64BloomFilter @16 bpk: 2.3189 ns, **0.594×** |
| 65536 | 1 | 24 | 1% | raw_batched_public | 1 | BloomsdayPinned @16 bpk: 4.5520 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.5287 ns, **0.823×** | Split64BloomFilter @16 bpk: 5.5383 ns, **0.822×** |
| 65536 | 1 | 24 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3317 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6699 ns, **0.797×** | FastPatternBF @16 bpk: 2.0199 ns, **0.659×** |
| 65536 | 1 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6361 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1529 ns, **0.760×** | SbbfSafePinned @16 bpk: 2.4274 ns, **0.674×** |
| 65536 | 1 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @32 bpk: 2.3769 ns, **1.000×** | Split64RangeBloomFilter @32 bpk: 2.4064 ns, **0.988×** | SbbfSafePinned @32 bpk: 2.5900 ns, **0.918×** |
| 65536 | 1 | 32 | 0.01% | raw_batched_public | 1 | BloomsdayPinned @32 bpk: 4.5570 ns, **1.000×** | Split64BloomFilter @32 bpk: 5.5477 ns, **0.821×** | Split64RangeBloomFilter @32 bpk: 5.8672 ns, **0.777×** |
| 65536 | 1 | 32 | 0.01% | raw_insert | 1 | BloomsdayPinned @32 bpk: 1.7388 ns, **1.000×** | Split64BloomFilter @32 bpk: 2.2650 ns, **0.768×** | Split64RangeBloomFilter @24 bpk: 2.3099 ns, **0.753×** |
| 65536 | 1 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 2.1469 ns, **1.000×** | SbbfSafePinned @32 bpk: 2.4590 ns, **0.873×** | Split64BloomFilter @32 bpk: 3.1178 ns, **0.689×** |
| 65536 | 1 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.6775 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7382 ns, **0.965×** | Split64BloomFilter @16 bpk: 2.3189 ns, **0.723×** |
| 65536 | 1 | 32 | 0.1% | raw_batched_public | 1 | BloomsdayPinned @32 bpk: 4.5570 ns, **1.000×** | Split64BloomFilter @16 bpk: 5.5383 ns, **0.823×** | ByteSplitBloomFilter @32 bpk: 5.5581 ns, **0.820×** |
| 65536 | 1 | 32 | 0.1% | raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.5889 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6699 ns, **0.952×** | FastPatternBF @32 bpk: 2.0130 ns, **0.789×** |
| 65536 | 1 | 32 | 0.1% | raw_visible_public | 1 | ByteSplitBloomFilter @32 bpk: 1.7282 ns, **1.000×** | BloomsdayPinned @32 bpk: 2.1469 ns, **0.805×** | SbbfSafePinned @24 bpk: 2.4328 ns, **0.710×** |
| 65536 | 1 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3774 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7382 ns, **0.792×** | Split64BloomFilter @16 bpk: 2.3189 ns, **0.594×** |
| 65536 | 1 | 32 | 1% | raw_batched_public | 1 | BloomsdayPinned @16 bpk: 4.5520 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.5287 ns, **0.823×** | Split64BloomFilter @16 bpk: 5.5383 ns, **0.822×** |
| 65536 | 1 | 32 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3317 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6699 ns, **0.797×** | FastPatternBF @32 bpk: 2.0130 ns, **0.662×** |
| 65536 | 1 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6361 ns, **1.000×** | BloomsdayPinned @32 bpk: 2.1469 ns, **0.762×** | SbbfSafePinned @16 bpk: 2.4274 ns, **0.674×** |
| 65536 | 31 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 65536 | 31 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 65536 | 31 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 65536 | 31 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 65536 | 31 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 2.2726 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.3730 ns, **0.958×** | FourSectorBloomFilter @16 bpk: 4.2949 ns, **0.529×** |
| 65536 | 31 | 16 | 0.1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 1.9647 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.1232 ns, **0.925×** | Split64BloomFilter @16 bpk: 2.1711 ns, **0.905×** |
| 65536 | 31 | 16 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 2.2059 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.3243 ns, **0.949×** | FourSectorBloomFilter @16 bpk: 3.6058 ns, **0.612×** |
| 65536 | 31 | 16 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 3.0947 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.1356 ns, **0.987×** | FourSectorBloomFilter @16 bpk: 8.1402 ns, **0.380×** |
| 65536 | 31 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4856 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2726 ns, **0.654×** | Split64RangeBloomFilter @16 bpk: 2.3730 ns, **0.626×** |
| 65536 | 31 | 16 | 1% | raw_batched_public | 1 | ByteSplitBloomFilter @16 bpk: 1.4400 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 1.9647 ns, **0.733×** | FourSectorRange12BloomFilter @16 bpk: 2.0111 ns, **0.716×** |
| 65536 | 31 | 16 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4374 ns, **1.000×** | BloomsdayPinned @16 bpk: 1.7026 ns, **0.844×** | FastPatternBF @16 bpk: 2.0215 ns, **0.711×** |
| 65536 | 31 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6382 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1501 ns, **0.762×** | SbbfSafePinned @16 bpk: 2.4240 ns, **0.676×** |
| 65536 | 31 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 2.5478 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.2968 ns, **0.593×** | Fastbloom017K7 @24 bpk: 7.3608 ns, **0.346×** |
| 65536 | 31 | 24 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 2.0556 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 2.1234 ns, **0.968×** | Fastbloom017K7 @24 bpk: 12.2744 ns, **0.167×** |
| 65536 | 31 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 2.2965 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.0695 ns, **0.564×** | Fastbloom017K7 @24 bpk: 7.2945 ns, **0.315×** |
| 65536 | 31 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 3.1353 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 6.7325 ns, **0.466×** | Fastbloom017K7 @24 bpk: 14.1870 ns, **0.221×** |
| 65536 | 31 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | BloomsdayPinned @24 bpk: 1.7905 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2726 ns, **0.788×** | Split64RangeBloomFilter @16 bpk: 2.3730 ns, **0.755×** |
| 65536 | 31 | 24 | 0.1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 1.9647 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 2.0556 ns, **0.956×** | BloomsdayPinned @24 bpk: 2.0816 ns, **0.944×** |
| 65536 | 31 | 24 | 0.1% | raw_insert | 1 | BloomsdayPinned @24 bpk: 1.6768 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2059 ns, **0.760×** | Split64RangeBloomFilter @24 bpk: 2.2965 ns, **0.730×** |
| 65536 | 31 | 24 | 0.1% | raw_visible_public | 1 | BloomsdayPinned @24 bpk: 2.1444 ns, **1.000×** | SbbfSafePinned @24 bpk: 2.4342 ns, **0.881×** | Split64BloomFilter @16 bpk: 3.0947 ns, **0.693×** |
| 65536 | 31 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4856 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7905 ns, **0.830×** | Split64BloomFilter @16 bpk: 2.2726 ns, **0.654×** |
| 65536 | 31 | 24 | 1% | raw_batched_public | 1 | ByteSplitBloomFilter @16 bpk: 1.4400 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 1.9647 ns, **0.733×** | FourSectorRange12BloomFilter @16 bpk: 2.0111 ns, **0.716×** |
| 65536 | 31 | 24 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4374 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6768 ns, **0.857×** | FastPatternBF @16 bpk: 2.0215 ns, **0.711×** |
| 65536 | 31 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6382 ns, **1.000×** | BloomsdayPinned @24 bpk: 2.1444 ns, **0.764×** | SbbfSafePinned @16 bpk: 2.4240 ns, **0.676×** |
| 65536 | 31 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @32 bpk: 2.3417 ns, **1.000×** | Split64RangeBloomFilter @32 bpk: 2.4118 ns, **0.971×** | SbbfSafePinned @32 bpk: 2.5883 ns, **0.905×** |
| 65536 | 31 | 32 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 2.0556 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 2.0681 ns, **0.994×** | BloomsdayPinned @32 bpk: 2.1164 ns, **0.971×** |
| 65536 | 31 | 32 | 0.01% | raw_insert | 1 | BloomsdayPinned @32 bpk: 1.6997 ns, **1.000×** | Split64BloomFilter @32 bpk: 2.2435 ns, **0.758×** | Split64RangeBloomFilter @24 bpk: 2.2965 ns, **0.740×** |
| 65536 | 31 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 2.1605 ns, **1.000×** | SbbfSafePinned @32 bpk: 2.4426 ns, **0.885×** | Split64BloomFilter @32 bpk: 3.1151 ns, **0.694×** |
| 65536 | 31 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.6066 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7905 ns, **0.897×** | Split64BloomFilter @16 bpk: 2.2726 ns, **0.707×** |
| 65536 | 31 | 32 | 0.1% | raw_batched_public | 1 | ByteSplitBloomFilter @32 bpk: 1.4855 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 1.9647 ns, **0.756×** | FourSectorRange12BloomFilter @24 bpk: 2.0556 ns, **0.723×** |
| 65536 | 31 | 32 | 0.1% | raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.5202 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6768 ns, **0.907×** | FastPatternBF @32 bpk: 2.0200 ns, **0.753×** |
| 65536 | 31 | 32 | 0.1% | raw_visible_public | 1 | ByteSplitBloomFilter @32 bpk: 1.6966 ns, **1.000×** | BloomsdayPinned @24 bpk: 2.1444 ns, **0.791×** | SbbfSafePinned @24 bpk: 2.4342 ns, **0.697×** |
| 65536 | 31 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4856 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7905 ns, **0.830×** | Split64BloomFilter @16 bpk: 2.2726 ns, **0.654×** |
| 65536 | 31 | 32 | 1% | raw_batched_public | 1 | ByteSplitBloomFilter @16 bpk: 1.4400 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 1.9647 ns, **0.733×** | FourSectorRange12BloomFilter @16 bpk: 2.0111 ns, **0.716×** |
| 65536 | 31 | 32 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.4374 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6768 ns, **0.857×** | FastPatternBF @32 bpk: 2.0200 ns, **0.712×** |
| 65536 | 31 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6382 ns, **1.000×** | BloomsdayPinned @24 bpk: 2.1444 ns, **0.764×** | SbbfSafePinned @16 bpk: 2.4240 ns, **0.676×** |
| 65536 | 4096 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 65536 | 4096 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.3483 ns, **0.972×** | FourSectorBloomFilter @16 bpk: 4.2687 ns, **0.535×** |
| 65536 | 4096 | 16 | 0.1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 1.5127 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.1064 ns, **0.718×** | Split64RangeBloomFilter @16 bpk: 2.4479 ns, **0.618×** |
| 65536 | 4096 | 16 | 0.1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 2.2348 ns, **1.000×** | Split64BloomFilter @16 bpk: 2.2954 ns, **0.974×** | FourSectorBloomFilter @16 bpk: 3.6040 ns, **0.620×** |
| 65536 | 4096 | 16 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 3.0898 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.1421 ns, **0.983×** | FourSectorBloomFilter @16 bpk: 8.1519 ns, **0.379×** |
| 65536 | 4096 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3527 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **0.593×** | Split64BloomFilter @16 bpk: 2.3483 ns, **0.576×** |
| 65536 | 4096 | 16 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 1.0868 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.4286 ns, **0.761×** | FourSectorBloomFilter @16 bpk: 1.5127 ns, **0.718×** |
| 65536 | 4096 | 16 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3056 ns, **1.000×** | BloomsdayPinned @16 bpk: 1.6701 ns, **0.782×** | FastPatternBF @16 bpk: 2.0177 ns, **0.647×** |
| 65536 | 4096 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6378 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1429 ns, **0.764×** | SbbfSafePinned @16 bpk: 2.4390 ns, **0.672×** |
| 65536 | 4096 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 3.2177 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.1337 ns, **0.778×** | Fastbloom017K7 @24 bpk: 7.2270 ns, **0.445×** |
| 65536 | 4096 | 24 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 1.6447 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 2.1370 ns, **0.770×** | Fastbloom017K7 @24 bpk: 11.7867 ns, **0.140×** |
| 65536 | 4096 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 2.3256 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 4.0670 ns, **0.572×** | Fastbloom017K7 @24 bpk: 7.1604 ns, **0.325×** |
| 65536 | 4096 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 3.1355 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 6.7300 ns, **0.466×** | Fastbloom017K7 @24 bpk: 14.2007 ns, **0.221×** |
| 65536 | 4096 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | BloomsdayPinned @24 bpk: 1.7071 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **0.748×** | Split64BloomFilter @16 bpk: 2.3483 ns, **0.727×** |
| 65536 | 4096 | 24 | 0.1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 1.5127 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 1.6447 ns, **0.920×** | BloomsdayPinned @24 bpk: 1.9346 ns, **0.782×** |
| 65536 | 4096 | 24 | 0.1% | raw_insert | 1 | BloomsdayPinned @24 bpk: 1.6374 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 2.2348 ns, **0.733×** | Split64BloomFilter @16 bpk: 2.2954 ns, **0.713×** |
| 65536 | 4096 | 24 | 0.1% | raw_visible_public | 1 | BloomsdayPinned @24 bpk: 2.1466 ns, **1.000×** | SbbfSafePinned @24 bpk: 2.4284 ns, **0.884×** | Split64BloomFilter @16 bpk: 3.0898 ns, **0.695×** |
| 65536 | 4096 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3527 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7071 ns, **0.792×** | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **0.593×** |
| 65536 | 4096 | 24 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 1.0868 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.4286 ns, **0.761×** | FourSectorBloomFilter @16 bpk: 1.5127 ns, **0.718×** |
| 65536 | 4096 | 24 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3056 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6374 ns, **0.797×** | FastPatternBF @16 bpk: 2.0177 ns, **0.647×** |
| 65536 | 4096 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6378 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1429 ns, **0.764×** | SbbfSafePinned @24 bpk: 2.4284 ns, **0.674×** |
| 65536 | 4096 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @32 bpk: 2.3952 ns, **1.000×** | Split64BloomFilter @32 bpk: 2.5004 ns, **0.958×** | SbbfSafePinned @32 bpk: 2.5906 ns, **0.925×** |
| 65536 | 4096 | 32 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 1.6447 ns, **1.000×** | FourSectorBloomFilter @32 bpk: 1.7321 ns, **0.950×** | BloomsdayPinned @32 bpk: 2.0933 ns, **0.786×** |
| 65536 | 4096 | 32 | 0.01% | raw_insert | 1 | BloomsdayPinned @32 bpk: 1.6932 ns, **1.000×** | Split64RangeBloomFilter @32 bpk: 2.3055 ns, **0.734×** | Split64BloomFilter @32 bpk: 2.3845 ns, **0.710×** |
| 65536 | 4096 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 2.1594 ns, **1.000×** | SbbfSafePinned @32 bpk: 2.4416 ns, **0.884×** | Split64BloomFilter @32 bpk: 3.1124 ns, **0.694×** |
| 65536 | 4096 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.5725 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7071 ns, **0.921×** | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **0.689×** |
| 65536 | 4096 | 32 | 0.1% | raw_batched_public | 1 | FastPatternBF @32 bpk: 1.2102 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 1.5127 ns, **0.800×** | ByteSplitBloomFilter @32 bpk: 1.5197 ns, **0.796×** |
| 65536 | 4096 | 32 | 0.1% | raw_insert | 1 | ByteSplitBloomFilter @32 bpk: 1.4868 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6374 ns, **0.908×** | FastPatternBF @32 bpk: 2.0181 ns, **0.737×** |
| 65536 | 4096 | 32 | 0.1% | raw_visible_public | 1 | ByteSplitBloomFilter @32 bpk: 1.6625 ns, **1.000×** | BloomsdayPinned @24 bpk: 2.1466 ns, **0.774×** | SbbfSafePinned @24 bpk: 2.4284 ns, **0.685×** |
| 65536 | 4096 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3527 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.7071 ns, **0.792×** | Split64RangeBloomFilter @16 bpk: 2.2828 ns, **0.593×** |
| 65536 | 4096 | 32 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 1.0868 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 1.4286 ns, **0.761×** | FourSectorBloomFilter @16 bpk: 1.5127 ns, **0.718×** |
| 65536 | 4096 | 32 | 1% | raw_insert | 1 | ByteSplitBloomFilter @16 bpk: 1.3056 ns, **1.000×** | BloomsdayPinned @24 bpk: 1.6374 ns, **0.797×** | FastPatternBF @16 bpk: 2.0177 ns, **0.647×** |
| 65536 | 4096 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 1.6378 ns, **1.000×** | BloomsdayPinned @16 bpk: 2.1429 ns, **0.764×** | SbbfSafePinned @24 bpk: 2.4284 ns, **0.674×** |
| 33554432 | 1 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 33554432 | 1 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 33554432 | 1 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | Fastbloom017K7 @16 bpk: 25.1181 ns, **0.165×** |
| 33554432 | 1 | 16 | 0.1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** | Fastbloom017K6 @16 bpk: 37.3265 ns, **0.378×** |
| 33554432 | 1 | 16 | 0.1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | Fastbloom017K7 @16 bpk: 25.1177 ns, **0.157×** |
| 33554432 | 1 | 16 | 0.1% | raw_visible_public | 1 | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **1.000×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.938×** | Fastbloom017K6 @16 bpk: 30.2406 ns, **0.282×** |
| 33554432 | 1 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | ByteSplitBloomFilter @16 bpk: 4.4050 ns, **0.941×** |
| 33554432 | 1 | 16 | 1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 15.0750 ns, **0.935×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** |
| 33554432 | 1 | 16 | 1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | ByteSplitBloomFilter @16 bpk: 4.1736 ns, **0.947×** |
| 33554432 | 1 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 7.4461 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **0.872×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.819×** |
| 33554432 | 1 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.4513 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.6305 ns, **0.968×** | Fastbloom017K7 @24 bpk: 40.4820 ns, **0.135×** |
| 33554432 | 1 | 24 | 0.01% | raw_batched_public | 1 | Split64RangeBloomFilter @24 bpk: 20.3995 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 36.3131 ns, **0.562×** | Fastbloom017K7 @24 bpk: 49.2337 ns, **0.414×** |
| 33554432 | 1 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.0774 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.2656 ns, **0.964×** | Fastbloom017K7 @24 bpk: 40.4817 ns, **0.125×** |
| 33554432 | 1 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 12.2684 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 24.4051 ns, **0.503×** | Fastbloom017K7 @24 bpk: 39.8400 ns, **0.308×** |
| 33554432 | 1 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | FourSectorRange12BloomFilter @24 bpk: 5.6305 ns, **0.736×** |
| 33554432 | 1 | 24 | 0.1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** | BloomsdayPinned @24 bpk: 17.6806 ns, **0.797×** |
| 33554432 | 1 | 24 | 0.1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | FourSectorRange12BloomFilter @24 bpk: 5.2656 ns, **0.751×** |
| 33554432 | 1 | 24 | 0.1% | raw_visible_public | 1 | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **1.000×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.938×** | BloomsdayPinned @24 bpk: 9.4674 ns, **0.902×** |
| 33554432 | 1 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | ByteSplitBloomFilter @16 bpk: 4.4050 ns, **0.941×** |
| 33554432 | 1 | 24 | 1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 15.0750 ns, **0.935×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** |
| 33554432 | 1 | 24 | 1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | ByteSplitBloomFilter @16 bpk: 4.1736 ns, **0.947×** |
| 33554432 | 1 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 7.4461 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **0.872×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.819×** |
| 33554432 | 1 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.4513 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.6305 ns, **0.968×** | Split64BloomFilter @32 bpk: 6.3201 ns, **0.863×** |
| 33554432 | 1 | 32 | 0.01% | raw_batched_public | 1 | BloomsdayPinned @32 bpk: 19.7532 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 20.3995 ns, **0.968×** | Split64BloomFilter @32 bpk: 22.6062 ns, **0.874×** |
| 33554432 | 1 | 32 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.0774 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.2656 ns, **0.964×** | Split64BloomFilter @32 bpk: 5.7632 ns, **0.881×** |
| 33554432 | 1 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 10.3918 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 12.2684 ns, **0.847×** | SbbfSafePinned @32 bpk: 12.4893 ns, **0.832×** |
| 33554432 | 1 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | FourSectorRange12BloomFilter @24 bpk: 5.6305 ns, **0.736×** |
| 33554432 | 1 | 32 | 0.1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** | BloomsdayPinned @24 bpk: 17.6806 ns, **0.797×** |
| 33554432 | 1 | 32 | 0.1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | FourSectorRange12BloomFilter @24 bpk: 5.2656 ns, **0.751×** |
| 33554432 | 1 | 32 | 0.1% | raw_visible_public | 1 | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **1.000×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.938×** | ByteSplitBloomFilter @32 bpk: 9.4536 ns, **0.903×** |
| 33554432 | 1 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 4.1444 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.3593 ns, **0.951×** | ByteSplitBloomFilter @16 bpk: 4.4050 ns, **0.941×** |
| 33554432 | 1 | 32 | 1% | raw_batched_public | 1 | Split64RangeBloomFilter @16 bpk: 14.0910 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 15.0750 ns, **0.935×** | Split64BloomFilter @16 bpk: 15.4421 ns, **0.913×** |
| 33554432 | 1 | 32 | 1% | raw_insert | 1 | Split64RangeBloomFilter @16 bpk: 3.9529 ns, **1.000×** | Split64BloomFilter @16 bpk: 4.1483 ns, **0.953×** | ByteSplitBloomFilter @16 bpk: 4.1736 ns, **0.947×** |
| 33554432 | 1 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 7.4461 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.5358 ns, **0.872×** | Split64BloomFilter @16 bpk: 9.0957 ns, **0.819×** |
| 33554432 | 31 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 33554432 | 31 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 33554432 | 31 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 33554432 | 31 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 33554432 | 31 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | Fastbloom017K6 @16 bpk: 22.4583 ns, **0.188×** |
| 33554432 | 31 | 16 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 6.0817 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 6.2378 ns, **0.975×** | Fastbloom017K6 @16 bpk: 25.4198 ns, **0.239×** |
| 33554432 | 31 | 16 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | Fastbloom017K6 @16 bpk: 22.4580 ns, **0.179×** |
| 33554432 | 31 | 16 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.4588 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.9175 ns, **0.949×** | Fastbloom017K6 @16 bpk: 28.1914 ns, **0.300×** |
| 33554432 | 31 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.3170 ns, **0.980×** |
| 33554432 | 31 | 16 | 1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 5.7029 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.7129 ns, **0.998×** | Split64BloomFilter @16 bpk: 6.0817 ns, **0.938×** |
| 33554432 | 31 | 16 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.1098 ns, **0.979×** |
| 33554432 | 31 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.5456 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.1047 ns, **0.921×** | SbbfSafePinned @16 bpk: 8.1805 ns, **0.800×** |
| 33554432 | 31 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.1684 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.3960 ns, **0.958×** | Fastbloom017K7 @24 bpk: 34.4597 ns, **0.150×** |
| 33554432 | 31 | 24 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 7.6308 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 7.8262 ns, **0.975×** | Fastbloom017K7 @24 bpk: 33.0329 ns, **0.231×** |
| 33554432 | 31 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 4.8044 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.0368 ns, **0.954×** | Fastbloom017K7 @24 bpk: 34.4593 ns, **0.139×** |
| 33554432 | 31 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 12.0165 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 23.3192 ns, **0.515×** | Fastbloom017K7 @24 bpk: 36.7055 ns, **0.327×** |
| 33554432 | 31 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | FourSectorRange12BloomFilter @24 bpk: 5.3960 ns, **0.784×** |
| 33554432 | 31 | 24 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 6.0817 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 6.2378 ns, **0.975×** | FourSectorRange12BloomFilter @24 bpk: 7.6308 ns, **0.797×** |
| 33554432 | 31 | 24 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | FourSectorRange12BloomFilter @24 bpk: 5.0368 ns, **0.799×** |
| 33554432 | 31 | 24 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.4588 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.9175 ns, **0.949×** | BloomsdayPinned @24 bpk: 9.3806 ns, **0.902×** |
| 33554432 | 31 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.3170 ns, **0.980×** |
| 33554432 | 31 | 24 | 1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 5.7029 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.7129 ns, **0.998×** | Split64BloomFilter @16 bpk: 6.0817 ns, **0.938×** |
| 33554432 | 31 | 24 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.1098 ns, **0.979×** |
| 33554432 | 31 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.5456 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.1047 ns, **0.921×** | SbbfSafePinned @16 bpk: 8.1805 ns, **0.800×** |
| 33554432 | 31 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.1684 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.3960 ns, **0.958×** | Split64BloomFilter @32 bpk: 6.3467 ns, **0.814×** |
| 33554432 | 31 | 32 | 0.01% | raw_batched_public | 1 | FourSectorRange12BloomFilter @24 bpk: 7.6308 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 7.8262 ns, **0.975×** | FourSectorBloomFilter @32 bpk: 7.8547 ns, **0.971×** |
| 33554432 | 31 | 32 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 4.8044 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.0368 ns, **0.954×** | Split64BloomFilter @32 bpk: 5.8008 ns, **0.828×** |
| 33554432 | 31 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 10.4266 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 12.0165 ns, **0.868×** | Split64BloomFilter @32 bpk: 12.6339 ns, **0.825×** |
| 33554432 | 31 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | FourSectorRange12BloomFilter @24 bpk: 5.3960 ns, **0.784×** |
| 33554432 | 31 | 32 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 6.0817 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 6.2378 ns, **0.975×** | FourSectorRange12BloomFilter @24 bpk: 7.6308 ns, **0.797×** |
| 33554432 | 31 | 32 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | FourSectorRange12BloomFilter @24 bpk: 5.0368 ns, **0.799×** |
| 33554432 | 31 | 32 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.4588 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 8.9175 ns, **0.949×** | BloomsdayPinned @24 bpk: 9.3806 ns, **0.902×** |
| 33554432 | 31 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.2303 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.3056 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.3170 ns, **0.980×** |
| 33554432 | 31 | 32 | 1% | raw_batched_public | 1 | FourSectorBloomFilter @16 bpk: 5.7029 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 5.7129 ns, **0.998×** | Split64BloomFilter @16 bpk: 6.0817 ns, **0.938×** |
| 33554432 | 31 | 32 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 4.0236 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.0981 ns, **0.982×** | ByteSplitBloomFilter @16 bpk: 4.1098 ns, **0.979×** |
| 33554432 | 31 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.5456 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.1047 ns, **0.921×** | SbbfSafePinned @16 bpk: 8.1805 ns, **0.800×** |
| 33554432 | 4096 | 16 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | raw_batched_public | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | raw_insert | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.01% | raw_visible_public | 1 | — | — | — |
| 33554432 | 4096 | 16 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** | Fastbloom017K6 @16 bpk: 20.9474 ns, **0.197×** |
| 33554432 | 4096 | 16 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 4.4844 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.5259 ns, **0.991×** | Fastbloom017K6 @16 bpk: 24.2059 ns, **0.185×** |
| 33554432 | 4096 | 16 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** | Fastbloom017K6 @16 bpk: 20.9471 ns, **0.187×** |
| 33554432 | 4096 | 16 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.8956 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 9.3306 ns, **0.953×** | Fastbloom017K6 @16 bpk: 27.9406 ns, **0.318×** |
| 33554432 | 4096 | 16 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 4.1819 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** |
| 33554432 | 4096 | 16 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 4.2319 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.3062 ns, **0.983×** | FourSectorRange12BloomFilter @16 bpk: 4.4173 ns, **0.958×** |
| 33554432 | 4096 | 16 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 3.9784 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** |
| 33554432 | 4096 | 16 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.8606 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.3792 ns, **0.930×** | Split64BloomFilter @16 bpk: 8.8956 ns, **0.771×** |
| 33554432 | 4096 | 24 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.2559 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.4815 ns, **0.959×** | Fastbloom017K7 @24 bpk: 36.2152 ns, **0.145×** |
| 33554432 | 4096 | 24 | 0.01% | raw_batched_public | 1 | Split64RangeBloomFilter @24 bpk: 5.4348 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.4837 ns, **0.991×** | Fastbloom017K7 @24 bpk: 33.3091 ns, **0.163×** |
| 33554432 | 4096 | 24 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 4.8862 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.1114 ns, **0.956×** | Fastbloom017K7 @24 bpk: 36.2149 ns, **0.135×** |
| 33554432 | 4096 | 24 | 0.01% | raw_visible_public | 1 | Split64RangeBloomFilter @24 bpk: 11.9612 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 23.2835 ns, **0.514×** | Fastbloom017K7 @24 bpk: 37.4258 ns, **0.320×** |
| 33554432 | 4096 | 24 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** | FourSectorRange12BloomFilter @24 bpk: 5.4815 ns, **0.753×** |
| 33554432 | 4096 | 24 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 4.4844 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.5259 ns, **0.991×** | FourSectorRange12BloomFilter @24 bpk: 5.4837 ns, **0.818×** |
| 33554432 | 4096 | 24 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** | FourSectorRange12BloomFilter @24 bpk: 5.1114 ns, **0.768×** |
| 33554432 | 4096 | 24 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.8956 ns, **1.000×** | BloomsdayPinned @24 bpk: 9.3028 ns, **0.956×** | Split64RangeBloomFilter @16 bpk: 9.3306 ns, **0.953×** |
| 33554432 | 4096 | 24 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 4.1819 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** |
| 33554432 | 4096 | 24 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 4.2319 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.3062 ns, **0.983×** | FourSectorRange12BloomFilter @16 bpk: 4.4173 ns, **0.958×** |
| 33554432 | 4096 | 24 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 3.9784 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** |
| 33554432 | 4096 | 24 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.8606 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.3792 ns, **0.930×** | Split64BloomFilter @16 bpk: 8.8956 ns, **0.771×** |
| 33554432 | 4096 | 32 | 0.01% | allocate_filter_and_scratch_raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 5.2559 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.4815 ns, **0.959×** | Split64BloomFilter @32 bpk: 6.4106 ns, **0.820×** |
| 33554432 | 4096 | 32 | 0.01% | raw_batched_public | 1 | Split64RangeBloomFilter @24 bpk: 5.4348 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.4837 ns, **0.991×** | FastPatternBF @32 bpk: 6.0359 ns, **0.900×** |
| 33554432 | 4096 | 32 | 0.01% | raw_insert | 1 | Split64RangeBloomFilter @24 bpk: 4.8862 ns, **1.000×** | FourSectorRange12BloomFilter @24 bpk: 5.1114 ns, **0.956×** | Split64BloomFilter @32 bpk: 5.8629 ns, **0.833×** |
| 33554432 | 4096 | 32 | 0.01% | raw_visible_public | 1 | BloomsdayPinned @32 bpk: 10.4807 ns, **1.000×** | Split64RangeBloomFilter @24 bpk: 11.9612 ns, **0.876×** | SbbfSafePinned @32 bpk: 12.6262 ns, **0.830×** |
| 33554432 | 4096 | 32 | 0.1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** | FourSectorRange12BloomFilter @24 bpk: 5.4815 ns, **0.753×** |
| 33554432 | 4096 | 32 | 0.1% | raw_batched_public | 1 | Split64BloomFilter @16 bpk: 4.4844 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 4.5259 ns, **0.991×** | FourSectorRange12BloomFilter @24 bpk: 5.4837 ns, **0.818×** |
| 33554432 | 4096 | 32 | 0.1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** | FourSectorRange12BloomFilter @24 bpk: 5.1114 ns, **0.768×** |
| 33554432 | 4096 | 32 | 0.1% | raw_visible_public | 1 | Split64BloomFilter @16 bpk: 8.8956 ns, **1.000×** | BloomsdayPinned @24 bpk: 9.3028 ns, **0.956×** | Split64RangeBloomFilter @16 bpk: 9.3306 ns, **0.953×** |
| 33554432 | 4096 | 32 | 1% | allocate_filter_and_scratch_raw_insert | 1 | Split64BloomFilter @16 bpk: 4.1292 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 4.1819 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 4.1904 ns, **0.985×** |
| 33554432 | 4096 | 32 | 1% | raw_batched_public | 1 | FastPatternBF @16 bpk: 4.2319 ns, **1.000×** | FourSectorBloomFilter @16 bpk: 4.3062 ns, **0.983×** | FourSectorRange12BloomFilter @16 bpk: 4.4173 ns, **0.958×** |
| 33554432 | 4096 | 32 | 1% | raw_insert | 1 | Split64BloomFilter @16 bpk: 3.9256 ns, **1.000×** | ByteSplitBloomFilter @16 bpk: 3.9784 ns, **0.987×** | Split64RangeBloomFilter @16 bpk: 3.9876 ns, **0.984×** |
| 33554432 | 4096 | 32 | 1% | raw_visible_public | 1 | ByteSplitBloomFilter @16 bpk: 6.8606 ns, **1.000×** | BloomsdayPinned @16 bpk: 7.3792 ns, **0.930×** | Split64BloomFilter @16 bpk: 8.8956 ns, **0.771×** |
