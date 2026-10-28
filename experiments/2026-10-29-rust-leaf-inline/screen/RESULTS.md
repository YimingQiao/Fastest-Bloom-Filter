# Rust leaf-inline initial screen

Exactly three inline(always) hints were changed in a separate native crate. Production sources, allocation, probes, backend dispatch and bulk routing stayed unchanged. This seed42 CPU3 screen has 16 workloads / 112 rows: batch1 compares seven original public APIs plus three experimental clones; batches3/31/4096 compare only the three native original/clone pairs.

Key powers16/25, actual16/32 bpk, 50% hits, 2^22 queries, eight balanced four-mode trials, whole-input insertion, and 2^24 independent calibration negatives. CPU3 was pinned under the inherited exclusive socket1 flock; memory placement was not explicitly bound. All dense outputs, exact phase order, trial vectors, source/dependency/binary hashes and cross-batch semantic identity passed. No held-out confirmation or production promotion follows from this training screen.

The four modes remain separate: original batch prehashed (lookup_ns), original batch staged common hash (hash_lookup_ns), whole-array public singleton prehashed (inline_lookup_ns), and whole-array public singleton fused hash (inline_hash_lookup_ns). Each is independent-key throughput, not dependent-key latency. Visible Four/Split can use different kernels from bulk. Byte retains a scalar fallback call on non-AVX2 execution; the AVX2 hot path inlines. Split still emits qword products.

## Original/candidate regressions and gains

Each ratio is original/candidate; above1 favors the candidate. Aggregates describe four size/budget conditions and do not pool their timings. Every individual condition and its trial range is in candidate-ratios.csv.

| Candidate | Batch | Mode | Geometric ratio | Lowest | Highest | Candidate faster / original faster / ties |
| --- | ---: | --- | ---: | ---: | ---: | --- |
| ByteLeafInlineV1 | 1 | lookup_ns | 1.001 | 0.983 | 1.020 | 2/2/0 |
| ByteLeafInlineV1 | 1 | hash_lookup_ns | 0.999 | 0.996 | 1.000 | 0/4/0 |
| ByteLeafInlineV1 | 1 | inline_lookup_ns | 1.341 | 1.185 | 1.485 | 4/0/0 |
| ByteLeafInlineV1 | 1 | inline_hash_lookup_ns | 1.260 | 1.093 | 1.379 | 4/0/0 |
| ByteLeafInlineV1 | 3 | lookup_ns | 0.963 | 0.864 | 1.006 | 1/3/0 |
| ByteLeafInlineV1 | 3 | hash_lookup_ns | 0.973 | 0.877 | 1.019 | 2/2/0 |
| ByteLeafInlineV1 | 3 | inline_lookup_ns | 1.288 | 1.045 | 1.478 | 4/0/0 |
| ByteLeafInlineV1 | 3 | inline_hash_lookup_ns | 1.224 | 1.058 | 1.380 | 4/0/0 |
| ByteLeafInlineV1 | 31 | lookup_ns | 0.984 | 0.969 | 1.003 | 1/3/0 |
| ByteLeafInlineV1 | 31 | hash_lookup_ns | 0.997 | 0.981 | 1.005 | 2/2/0 |
| ByteLeafInlineV1 | 31 | inline_lookup_ns | 1.347 | 1.192 | 1.493 | 4/0/0 |
| ByteLeafInlineV1 | 31 | inline_hash_lookup_ns | 1.259 | 1.079 | 1.380 | 4/0/0 |
| ByteLeafInlineV1 | 4096 | lookup_ns | 0.997 | 0.984 | 1.017 | 2/2/0 |
| ByteLeafInlineV1 | 4096 | hash_lookup_ns | 1.008 | 0.996 | 1.023 | 3/1/0 |
| ByteLeafInlineV1 | 4096 | inline_lookup_ns | 1.357 | 1.239 | 1.483 | 4/0/0 |
| ByteLeafInlineV1 | 4096 | inline_hash_lookup_ns | 1.271 | 1.123 | 1.378 | 4/0/0 |
| FourSectorLeafInlineV1 | 1 | lookup_ns | 0.927 | 0.806 | 1.028 | 2/2/0 |
| FourSectorLeafInlineV1 | 1 | hash_lookup_ns | 0.997 | 0.994 | 1.001 | 1/3/0 |
| FourSectorLeafInlineV1 | 1 | inline_lookup_ns | 1.015 | 0.948 | 1.087 | 2/2/0 |
| FourSectorLeafInlineV1 | 1 | inline_hash_lookup_ns | 0.994 | 0.986 | 1.002 | 2/2/0 |
| FourSectorLeafInlineV1 | 3 | lookup_ns | 1.054 | 1.003 | 1.106 | 4/0/0 |
| FourSectorLeafInlineV1 | 3 | hash_lookup_ns | 1.040 | 1.009 | 1.063 | 4/0/0 |
| FourSectorLeafInlineV1 | 3 | inline_lookup_ns | 1.017 | 0.938 | 1.099 | 2/2/0 |
| FourSectorLeafInlineV1 | 3 | inline_hash_lookup_ns | 0.998 | 0.987 | 1.015 | 2/2/0 |
| FourSectorLeafInlineV1 | 31 | lookup_ns | 0.943 | 0.802 | 0.998 | 0/4/0 |
| FourSectorLeafInlineV1 | 31 | hash_lookup_ns | 0.951 | 0.792 | 1.035 | 2/2/0 |
| FourSectorLeafInlineV1 | 31 | inline_lookup_ns | 0.945 | 0.720 | 1.091 | 2/2/0 |
| FourSectorLeafInlineV1 | 31 | inline_hash_lookup_ns | 0.930 | 0.766 | 1.000 | 0/4/0 |
| FourSectorLeafInlineV1 | 4096 | lookup_ns | 0.994 | 0.981 | 1.000 | 1/3/0 |
| FourSectorLeafInlineV1 | 4096 | hash_lookup_ns | 0.998 | 0.987 | 1.007 | 2/2/0 |
| FourSectorLeafInlineV1 | 4096 | inline_lookup_ns | 1.010 | 0.937 | 1.089 | 2/2/0 |
| FourSectorLeafInlineV1 | 4096 | inline_hash_lookup_ns | 0.994 | 0.988 | 1.009 | 1/3/0 |
| Split64LeafInlineV1 | 1 | lookup_ns | 1.094 | 1.078 | 1.108 | 4/0/0 |
| Split64LeafInlineV1 | 1 | hash_lookup_ns | 0.991 | 0.923 | 1.044 | 2/2/0 |
| Split64LeafInlineV1 | 1 | inline_lookup_ns | 1.101 | 0.967 | 1.173 | 3/1/0 |
| Split64LeafInlineV1 | 1 | inline_hash_lookup_ns | 1.198 | 1.139 | 1.228 | 4/0/0 |
| Split64LeafInlineV1 | 3 | lookup_ns | 1.029 | 0.994 | 1.053 | 3/1/0 |
| Split64LeafInlineV1 | 3 | hash_lookup_ns | 1.012 | 0.994 | 1.028 | 2/2/0 |
| Split64LeafInlineV1 | 3 | inline_lookup_ns | 1.099 | 0.962 | 1.173 | 3/1/0 |
| Split64LeafInlineV1 | 3 | inline_hash_lookup_ns | 1.197 | 1.143 | 1.224 | 4/0/0 |
| Split64LeafInlineV1 | 31 | lookup_ns | 0.949 | 0.804 | 1.005 | 2/2/0 |
| Split64LeafInlineV1 | 31 | hash_lookup_ns | 0.936 | 0.785 | 0.994 | 0/4/0 |
| Split64LeafInlineV1 | 31 | inline_lookup_ns | 1.054 | 0.912 | 1.172 | 2/2/0 |
| Split64LeafInlineV1 | 31 | inline_hash_lookup_ns | 1.148 | 1.020 | 1.218 | 4/0/0 |
| Split64LeafInlineV1 | 4096 | lookup_ns | 0.997 | 0.991 | 1.001 | 1/3/0 |
| Split64LeafInlineV1 | 4096 | hash_lookup_ns | 0.997 | 0.982 | 1.007 | 2/2/0 |
| Split64LeafInlineV1 | 4096 | inline_lookup_ns | 1.102 | 0.982 | 1.173 | 3/1/0 |
| Split64LeafInlineV1 | 4096 | inline_hash_lookup_ns | 1.195 | 1.128 | 1.227 | 4/0/0 |

## Batch1 lookup_ns

Actual-byte caps include any smaller tested allocation. Eligibility uses the pointwise two-sided95% Wilson upper endpoint; this is no simultaneous-selection guarantee.

| Keys | Cap bpk | FPR ceiling | Original native (ns) | Experimental native (ns) | External (ns) | External / experimental |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter (3.731) | ByteLeafInlineV1 (3.701) | BloomsdayPinned (3.264) | 0.882 |
| 65536 | 16 | 0.10% | Split64BloomFilter (4.090) | Split64LeafInlineV1 (3.751) | Fastbloom017 (16.358) | 4.361 |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter (3.731) | ByteLeafInlineV1 (3.697) | BloomsdayPinned (3.252) | 0.880 |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter (3.770) | ByteLeafInlineV1 (3.697) | BloomsdayPinned (3.252) | 0.880 |
| 65536 | 32 | 0.01% | Split64BloomFilter (4.104) | Split64LeafInlineV1 (3.703) | BloomsdayPinned (3.252) | 0.878 |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter (9.010) | ByteLeafInlineV1 (9.163) | BloomsdayPinned (8.557) | 0.934 |
| 33554432 | 16 | 0.10% | Split64BloomFilter (10.019) | Split64LeafInlineV1 (9.292) | Fastbloom017 (41.607) | 4.478 |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter (9.010) | ByteLeafInlineV1 (9.163) | BloomsdayPinned (8.557) | 0.934 |
| 33554432 | 32 | 0.10% | Split64BloomFilter (10.019) | Split64LeafInlineV1 (9.292) | BloomsdayPinned (14.444) | 1.554 |
| 33554432 | 32 | 0.01% | Split64BloomFilter (17.179) | Split64LeafInlineV1 (15.615) | BloomsdayPinned (14.444) | 0.925 |

## Batch1 hash_lookup_ns

Actual-byte caps include any smaller tested allocation. Eligibility uses the pointwise two-sided95% Wilson upper endpoint; this is no simultaneous-selection guarantee.

| Keys | Cap bpk | FPR ceiling | Original native (ns) | Experimental native (ns) | External (ns) | External / experimental |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter (6.209) | ByteLeafInlineV1 (6.210) | BloomsdayPinned (6.027) | 0.970 |
| 65536 | 16 | 0.10% | Split64BloomFilter (6.512) | Split64LeafInlineV1 (6.239) | Fastbloom017 (21.481) | 3.443 |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter (6.209) | ByteLeafInlineV1 (6.210) | BloomsdayPinned (6.016) | 0.969 |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter (6.210) | ByteLeafInlineV1 (6.217) | BloomsdayPinned (6.016) | 0.968 |
| 65536 | 32 | 0.01% | Split64BloomFilter (6.513) | Split64LeafInlineV1 (6.261) | BloomsdayPinned (6.016) | 0.961 |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter (15.607) | ByteLeafInlineV1 (15.616) | BloomsdayPinned (16.447) | 1.053 |
| 33554432 | 16 | 0.10% | Split64BloomFilter (15.622) | Split64LeafInlineV1 (16.246) | Fastbloom017 (47.402) | 2.918 |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter (15.607) | ByteLeafInlineV1 (15.616) | BloomsdayPinned (16.447) | 1.053 |
| 33554432 | 32 | 0.10% | Split64BloomFilter (15.622) | Split64LeafInlineV1 (16.246) | BloomsdayPinned (27.319) | 1.682 |
| 33554432 | 32 | 0.01% | Split64BloomFilter (25.166) | Split64LeafInlineV1 (27.271) | BloomsdayPinned (27.319) | 1.002 |

## Batch1 inline_lookup_ns

Actual-byte caps include any smaller tested allocation. Eligibility uses the pointwise two-sided95% Wilson upper endpoint; this is no simultaneous-selection guarantee.

| Keys | Cap bpk | FPR ceiling | Original native (ns) | Experimental native (ns) | External (ns) | External / experimental |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter (1.518) | ByteLeafInlineV1 (1.030) | BloomsdayPinned (1.476) | 1.432 |
| 65536 | 16 | 0.10% | Split64BloomFilter (2.378) | Split64LeafInlineV1 (2.027) | Fastbloom017 (13.952) | 6.883 |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter (1.518) | ByteLeafInlineV1 (1.028) | BloomsdayPinned (1.476) | 1.436 |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter (1.527) | ByteLeafInlineV1 (1.028) | BloomsdayPinned (1.518) | 1.476 |
| 65536 | 32 | 0.01% | Split64BloomFilter (2.378) | Split64LeafInlineV1 (2.028) | BloomsdayPinned (1.518) | 0.748 |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter (6.152) | ByteLeafInlineV1 (5.193) | BloomsdayPinned (6.391) | 1.231 |
| 33554432 | 16 | 0.10% | Split64BloomFilter (7.071) | Split64LeafInlineV1 (7.312) | Fastbloom017 (38.699) | 5.292 |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter (6.152) | ByteLeafInlineV1 (5.193) | BloomsdayPinned (6.391) | 1.231 |
| 33554432 | 32 | 0.10% | Split64BloomFilter (7.071) | ByteLeafInlineV1 (7.242) | BloomsdayPinned (8.431) | 1.164 |
| 33554432 | 32 | 0.01% | Split64BloomFilter (10.362) | Split64LeafInlineV1 (9.385) | BloomsdayPinned (8.431) | 0.898 |

## Batch1 inline_hash_lookup_ns

Actual-byte caps include any smaller tested allocation. Eligibility uses the pointwise two-sided95% Wilson upper endpoint; this is no simultaneous-selection guarantee.

| Keys | Cap bpk | FPR ceiling | Original native (ns) | Experimental native (ns) | External (ns) | External / experimental |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter (2.263) | ByteLeafInlineV1 (1.656) | BloomsdayPinned (2.147) | 1.296 |
| 65536 | 16 | 0.10% | Split64BloomFilter (3.084) | Split64LeafInlineV1 (2.551) | Fastbloom017 (16.716) | 6.552 |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter (2.263) | ByteLeafInlineV1 (1.656) | BloomsdayPinned (2.147) | 1.296 |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter (2.300) | ByteLeafInlineV1 (1.667) | BloomsdayPinned (2.150) | 1.289 |
| 65536 | 32 | 0.01% | Split64BloomFilter (3.109) | Split64LeafInlineV1 (2.555) | BloomsdayPinned (2.150) | 0.841 |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter (7.223) | ByteLeafInlineV1 (6.607) | BloomsdayPinned (6.727) | 1.018 |
| 33554432 | 16 | 0.10% | Split64BloomFilter (7.897) | Split64LeafInlineV1 (6.932) | Fastbloom017 (40.440) | 5.834 |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter (7.223) | ByteLeafInlineV1 (6.607) | BloomsdayPinned (6.727) | 1.018 |
| 33554432 | 32 | 0.10% | Split64BloomFilter (7.897) | Split64LeafInlineV1 (6.932) | BloomsdayPinned (10.468) | 1.510 |
| 33554432 | 32 | 0.01% | Split64BloomFilter (12.678) | Split64LeafInlineV1 (10.326) | BloomsdayPinned (10.468) | 1.014 |

rankings.csv and summary.json retain all48 four-mode cap/quality views and every individual native comparison. candidate-ratios.csv retains192 original/candidate comparisons, api-ratios.csv all224 within-row API ratios, and quality.csv28 distinct original-family/size calibrations. Clone and batch reuse is not additional quality evidence. The16/32-bpk grid does not cover finer upstream capacities. No external leadership is inferred for the native-only batch guards.
