# Initial eight-core exact-capacity screen

All142 configurations completed and the frozen raw/aggregate, command, placement and source/binary audit passed. This is a single-seed training comparison on eight physical cores of socket1/node1, using one serially built shared bitmap. It is not a held-out or order-independent superiority claim.

Ratios below are strongest eligible external time / project time: values above1 favor the project. Every cap admits selected smaller actual allocations, including the fixed extra external geometries. Each of the four metrics chooses its own eligible external and native leader.

| Keys | Cap bpk | FPR limit | Metric | External leader (actual bpk) | Best production (ratio) | Range actual bpk (ratio) |
|---:|---:|---:|---|---|---|---|
| 65536 | 16 | 1% | lookup_gated | FastFilterFixed16SingleV1 (14) | FastPatternBF (1.626) | 16 (0.658) |
| 65536 | 16 | 1% | lookup_end_to_end | FastFilterFixed16 (16) | FastPatternBF (1.386) | 16 (0.728) |
| 65536 | 16 | 1% | hash_lookup_gated | FastFilterSimdBlock (16) | FastPatternBF (1.451) | 16 (0.801) |
| 65536 | 16 | 1% | hash_lookup_end_to_end | FastFilterSimdBlockSingleV1 (16) | FastPatternBF (1.357) | 16 (0.830) |
| 65536 | 16 | 0.1% | lookup_gated | FastFilterFixed64 (16) | FourSectorBloomFilter (2.048) | 16 (1.265) |
| 65536 | 16 | 0.1% | lookup_end_to_end | FastFilterFixed64 (16) | FourSectorBloomFilter (1.736) | 16 (1.219) |
| 65536 | 16 | 0.1% | hash_lookup_gated | FastFilterFixed64 (16) | FourSectorBloomFilter (1.651) | 16 (1.195) |
| 65536 | 16 | 0.1% | hash_lookup_end_to_end | FastFilterFixed64 (16) | FourSectorBloomFilter (1.537) | 16 (1.159) |
| 65536 | 16 | 0.01% | lookup_gated | — | — | — |
| 65536 | 16 | 0.01% | lookup_end_to_end | — | — | — |
| 65536 | 16 | 0.01% | hash_lookup_gated | — | — | — |
| 65536 | 16 | 0.01% | hash_lookup_end_to_end | — | — | — |
| 65536 | 24 | 1% | lookup_gated | FastFilterFixed16SingleV1 (14) | FastPatternBF (1.626) | 24 (0.661) |
| 65536 | 24 | 1% | lookup_end_to_end | FastFilterFixed16 (16) | FastPatternBF (1.386) | 16 (0.728) |
| 65536 | 24 | 1% | hash_lookup_gated | FastFilterSimdBlock (16) | FastPatternBF (1.451) | 24 (0.803) |
| 65536 | 24 | 1% | hash_lookup_end_to_end | FastFilterSimdBlockSingleV1 (16) | FastPatternBF (1.357) | 24 (0.830) |
| 65536 | 24 | 0.1% | lookup_gated | FastFilterFixed32 (24) | FourSectorBloomFilter (1.282) | 24 (0.794) |
| 65536 | 24 | 0.1% | lookup_end_to_end | FastFilterFixed32Bulk (24) | FourSectorBloomFilter (1.188) | 16 (0.834) |
| 65536 | 24 | 0.1% | hash_lookup_gated | FastFilterFixed32 (20) | FourSectorBloomFilter (1.153) | 24 (0.837) |
| 65536 | 24 | 0.1% | hash_lookup_end_to_end | FastFilterFixed32 (24) | FourSectorBloomFilter (1.142) | 24 (0.862) |
| 65536 | 24 | 0.01% | lookup_gated | FastFilterFixed64 (24) | — | 24 (1.271) |
| 65536 | 24 | 0.01% | lookup_end_to_end | FastFilterFixed64 (24) | — | 24 (1.222) |
| 65536 | 24 | 0.01% | hash_lookup_gated | FastFilterFixed64 (24) | — | 24 (1.186) |
| 65536 | 24 | 0.01% | hash_lookup_end_to_end | FastFilterFixed64 (24) | — | 24 (1.147) |
| 65536 | 32 | 1% | lookup_gated | FastFilterFixed16SingleV1 (14) | FastPatternBF (1.626) | 24 (0.661) |
| 65536 | 32 | 1% | lookup_end_to_end | FastFilterFixed16 (16) | FastPatternBF (1.386) | 16 (0.728) |
| 65536 | 32 | 1% | hash_lookup_gated | FastFilterSimdBlock (32) | FastPatternBF (1.439) | 24 (0.797) |
| 65536 | 32 | 1% | hash_lookup_end_to_end | FastFilterSimdBlock (32) | FastPatternBF (1.356) | 24 (0.830) |
| 65536 | 32 | 0.1% | lookup_gated | FastFilterFixed16 (32) | FastPatternBF (1.536) | 24 (0.682) |
| 65536 | 32 | 0.1% | lookup_end_to_end | FastFilterFixed16 (32) | FastPatternBF (1.318) | 16 (0.733) |
| 65536 | 32 | 0.1% | hash_lookup_gated | FastFilterSimdBlock (32) | FastPatternBF (1.352) | 24 (0.797) |
| 65536 | 32 | 0.1% | hash_lookup_end_to_end | FastFilterSimdBlock (32) | FastPatternBF (1.285) | 24 (0.830) |
| 65536 | 32 | 0.01% | lookup_gated | FastFilterSimdBlock (32) | FourSectorBloomFilter (1.127) | 24 (0.756) |
| 65536 | 32 | 0.01% | lookup_end_to_end | FastFilterSimdBlock (32) | FourSectorBloomFilter (1.088) | 24 (0.796) |
| 65536 | 32 | 0.01% | hash_lookup_gated | FastFilterSimdBlock (32) | FourSectorBloomFilter (1.062) | 24 (0.797) |
| 65536 | 32 | 0.01% | hash_lookup_end_to_end | FastFilterSimdBlock (32) | FourSectorBloomFilter (1.053) | 24 (0.830) |
| 33554432 | 16 | 1% | lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.134) | 16 (0.923) |
| 33554432 | 16 | 1% | lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.125) | 16 (0.930) |
| 33554432 | 16 | 1% | hash_lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.031) | 16 (0.976) |
| 33554432 | 16 | 1% | hash_lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.021) | 16 (0.974) |
| 33554432 | 16 | 0.1% | lookup_gated | Boost192Multi64K8 (16) | Split64BloomFilter (1.143) | 16 (1.086) |
| 33554432 | 16 | 0.1% | lookup_end_to_end | Boost192Multi64K8 (16) | Split64BloomFilter (1.125) | 16 (1.075) |
| 33554432 | 16 | 0.1% | hash_lookup_gated | Boost192Multi64K8 (16) | Split64BloomFilter (1.086) | 16 (1.079) |
| 33554432 | 16 | 0.1% | hash_lookup_end_to_end | Boost192Multi64K8 (16) | Split64BloomFilter (1.081) | 16 (1.075) |
| 33554432 | 16 | 0.01% | lookup_gated | — | — | — |
| 33554432 | 16 | 0.01% | lookup_end_to_end | — | — | — |
| 33554432 | 16 | 0.01% | hash_lookup_gated | — | — | — |
| 33554432 | 16 | 0.01% | hash_lookup_end_to_end | — | — | — |
| 33554432 | 24 | 1% | lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.134) | 16 (0.923) |
| 33554432 | 24 | 1% | lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.125) | 16 (0.930) |
| 33554432 | 24 | 1% | hash_lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.031) | 16 (0.976) |
| 33554432 | 24 | 1% | hash_lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.021) | 16 (0.974) |
| 33554432 | 24 | 0.1% | lookup_gated | Boost192Multi32K8 (20) | Split64BloomFilter (1.099) | 16 (1.044) |
| 33554432 | 24 | 0.1% | lookup_end_to_end | Boost192Multi32K8 (20) | Split64BloomFilter (1.094) | 16 (1.044) |
| 33554432 | 24 | 0.1% | hash_lookup_gated | Boost192Multi64K8 (16) | Split64BloomFilter (1.086) | 16 (1.079) |
| 33554432 | 24 | 0.1% | hash_lookup_end_to_end | Boost192Multi64K8 (16) | Split64BloomFilter (1.081) | 16 (1.075) |
| 33554432 | 24 | 0.01% | lookup_gated | Boost192Multi64K8 (24) | — | 24 (1.054) |
| 33554432 | 24 | 0.01% | lookup_end_to_end | Boost192Multi64K8 (24) | — | 24 (1.048) |
| 33554432 | 24 | 0.01% | hash_lookup_gated | Boost192Multi64K8 (24) | — | 24 (1.030) |
| 33554432 | 24 | 0.01% | hash_lookup_end_to_end | Boost192Multi64K8 (24) | — | 24 (1.027) |
| 33554432 | 32 | 1% | lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.134) | 16 (0.923) |
| 33554432 | 32 | 1% | lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.125) | 16 (0.930) |
| 33554432 | 32 | 1% | hash_lookup_gated | Boost192Multi32K8 (12) | FastPatternBF (1.031) | 16 (0.976) |
| 33554432 | 32 | 1% | hash_lookup_end_to_end | Boost192Multi32K8 (12) | FastPatternBF (1.021) | 16 (0.974) |
| 33554432 | 32 | 0.1% | lookup_gated | Boost192Multi32K8 (20) | Split64BloomFilter (1.099) | 16 (1.044) |
| 33554432 | 32 | 0.1% | lookup_end_to_end | Boost192Multi32K8 (20) | Split64BloomFilter (1.094) | 16 (1.044) |
| 33554432 | 32 | 0.1% | hash_lookup_gated | Boost192Multi64K8 (16) | Split64BloomFilter (1.086) | 16 (1.079) |
| 33554432 | 32 | 0.1% | hash_lookup_end_to_end | Boost192Multi64K8 (16) | Split64BloomFilter (1.081) | 16 (1.075) |
| 33554432 | 32 | 0.01% | lookup_gated | Boost192Multi32K8 (28) | FastPatternBF (1.037) | 24 (1.030) |
| 33554432 | 32 | 0.01% | lookup_end_to_end | Boost192Multi32K8 (28) | FastPatternBF (1.037) | 24 (1.029) |
| 33554432 | 32 | 0.01% | hash_lookup_gated | Boost192Multi64K8 (24) | FastPatternBF (0.940) | 24 (1.030) |
| 33554432 | 32 | 0.01% | hash_lookup_end_to_end | Boost192Multi64K8 (24) | FastPatternBF (0.943) | 24 (1.027) |

These72 nested views reuse measurements and are not72 independent statistical tests. `query-alternatives.csv` retains all5112 allocation alternatives, including over-cap, unavailable and quality-failing records; all216 Range alternatives and every eligible native loss are retained separately. Exact ties are reported as ties.

Quality consists of92 mapping/geometry/size/seed records. Alias APIs reuse their original2^24 calibration denominator, never pool it. Each gate uses the pointwise two-sided Wilson95 upper; timed mixed-query negatives are separate. A failed upper-bound gate is not proof that the true FPR exceeds its limit. Historical FourSector intervals do not override current qualification.

| Range keys | Actual bpk | Calibration FP / probes | Wilson95 upper |
|---:|---:|---:|---:|
| 65536 | 16 | 15186 / 16777216 | 0.091966% |
| 65536 | 24 | 1517 / 16777216 | 0.009509% |
| 65536 | 32 | 278 / 16777216 | 0.001864% |
| 33554432 | 16 | 15240 / 16777216 | 0.092290% |
| 33554432 | 24 | 1468 / 16777216 | 0.009209% |
| 33554432 | 32 | 262 / 16777216 | 0.001763% |

`serial-scaling.csv` contains568 same-row serial/parallel comparisons, including unavailable raw-only pure entries. Gated time includes wake-up and completion synchronization. End-to-end additionally includes thread creation, affinity, joins and executor temporary destruction. Caller0 counts toward T8; only seven threads are spawned. A scaling ratio does not establish leadership over another filter.

`build-views.csv` and `build-alternatives.csv` keep all four serial medians separate: pure insert, allocation+insert, hash+insert and allocation+hash+insert. These measurements support no parallel-build claim. `equal-capacity-pairs.csv` additionally preserves every Range/other-API equal-byte pair across all eight query/build metrics, with quality and mapping-alias status.

The query phase order is fixed serial pure → serial common-hash → parallel pure → parallel common-hash. Six repetitions do not balance that order. Each process filters the source registry then shuffles it once using seed42; case groups run in ascending n/ceiling order. All variants share the same compiler/ISA, byte ceiling, raw input, common hash and full-output checks. Backing-byte budgets exclude object/allocator metadata and separately reported scratch.

No production promotion follows this training screen. Fresh seeds and order controls are required before a broader superiority claim.
