# Independent32 Rust initial screen

This seed42 CPU3 training screen compares eleven frozen public APIs in one executable. It is not held-out confirmation or a global-fastest claim. All132 rows, full outputs, trial vectors, phase balance, retained-control semantics and source/dependency/binary hashes passed.

The four contracts remain separate: generic batch prehashed, generic batch with staged common hash, whole-array visible public singleton prehashed, and visible singleton with fused common hash. These are independent-key throughput tests. Visible loops process the complete array at every batch tag; those tags do not create distinct singleton algorithms.

Key counts2^16/2^25, actual allocations16/32bpk, batches1/31/4096,50% hits,2^22 queries, eight balanced repetitions and2^24 separate calibration negatives. Whole-input build metrics remain in raw rows. CPU3/socket1 affinity and the exclusive inherited flock cover the complete matrix; memory is not explicitly NUMA-bound.

Eligibility uses actual allocated bytes and the pointwise two-sided95% Wilson upper endpoint. Cap32 includes tested16bpk allocations. Known leaf aliases and repeated batch/mode streams do not add negatives. There are32 family/size/seed calibration records; distinct public API families can implement the same mapping and are kept separate without pooling. These are nested resource/quality views, not independent speed or confidence experiments.

## Independent32 comparison counts

Ratios are rival/Independent32; above1 favors Independent32. Ineligible pairs are omitted from these descriptive counts but retained in the detailed tables. All individual native configurations and allocations, including every loss, are in `individual-native.csv`.

| Batch | Mode | Rival | Comparable views | Independent32 faster / rival faster / ties | Lowest ratio | Highest ratio |
| ---: | --- | --- | ---: | --- | ---: | ---: |
| 1 | lookup_ns | external | 8 | 0/8/0 | 0.834 | 0.903 |
| 1 | lookup_ns | byte_leaf | 6 | 0/6/0 | 0.948 | 0.981 |
| 1 | lookup_ns | native | 8 | 2/6/0 | 0.667 | 1.078 |
| 1 | hash_lookup_ns | external | 8 | 0/8/0 | 0.959 | 0.990 |
| 1 | hash_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.930 | 1.001 |
| 1 | hash_lookup_ns | native | 8 | 1/7/0 | 0.625 | 1.046 |
| 1 | inline_lookup_ns | external | 8 | 8/0/0 | 1.125 | 1.186 |
| 1 | inline_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.765 | 0.983 |
| 1 | inline_lookup_ns | native | 8 | 7/1/0 | 0.991 | 1.813 |
| 1 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.012 | 1.230 |
| 1 | inline_hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.942 | 0.998 |
| 1 | inline_hash_lookup_ns | native | 8 | 7/1/0 | 0.858 | 1.773 |
| 31 | lookup_ns | external | 8 | 8/0/0 | 1.149 | 1.217 |
| 31 | lookup_ns | byte_leaf | 6 | 2/4/0 | 0.852 | 1.010 |
| 31 | lookup_ns | native | 8 | 1/7/0 | 0.847 | 1.012 |
| 31 | hash_lookup_ns | external | 8 | 8/0/0 | 1.057 | 1.216 |
| 31 | hash_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.874 | 1.014 |
| 31 | hash_lookup_ns | native | 8 | 1/7/0 | 0.759 | 1.225 |
| 31 | inline_lookup_ns | external | 8 | 8/0/0 | 1.119 | 1.212 |
| 31 | inline_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.756 | 0.999 |
| 31 | inline_lookup_ns | native | 8 | 8/0/0 | 1.004 | 1.809 |
| 31 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.067 | 1.226 |
| 31 | inline_hash_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.941 | 1.025 |
| 31 | inline_hash_lookup_ns | native | 8 | 7/1/0 | 0.858 | 1.772 |
| 4096 | lookup_ns | external | 8 | 8/0/0 | 1.129 | 1.242 |
| 4096 | lookup_ns | byte_leaf | 6 | 2/4/0 | 0.765 | 1.015 |
| 4096 | lookup_ns | native | 8 | 0/8/0 | 0.552 | 0.881 |
| 4096 | hash_lookup_ns | external | 8 | 8/0/0 | 1.051 | 1.165 |
| 4096 | hash_lookup_ns | byte_leaf | 6 | 3/3/0 | 0.804 | 1.066 |
| 4096 | hash_lookup_ns | native | 8 | 0/8/0 | 0.630 | 0.912 |
| 4096 | inline_lookup_ns | external | 8 | 8/0/0 | 1.124 | 1.248 |
| 4096 | inline_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.765 | 1.026 |
| 4096 | inline_lookup_ns | native | 8 | 8/0/0 | 1.038 | 1.815 |
| 4096 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.078 | 1.224 |
| 4096 | inline_hash_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.943 | 1.051 |
| 4096 | inline_hash_lookup_ns | native | 8 | 7/1/0 | 0.911 | 1.771 |

## Batch1 lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (3.889,16) | BloomsdayPinned (3.242,16) | ByteLeafInlineV1 (3.686,16) | 0.834 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (16.792,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (3.888,32) | BloomsdayPinned (3.242,16) | ByteLeafInlineV1 (3.686,16) | 0.834 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (3.888,32) | BloomsdayPinned (3.252,32) | ByteLeafInlineV1 (3.689,32) | 0.836 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (3.888,32) | BloomsdayPinned (3.252,32) | No qualifier | 0.836 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (9.858,16) | BloomsdayPinned (8.791,16) | ByteLeafInlineV1 (9.457,16) | 0.892 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (42.621,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (9.858,16) | BloomsdayPinned (8.791,16) | ByteLeafInlineV1 (9.457,16) | 0.892 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (15.971,32) | BloomsdayPinned (14.426,32) | ByteLeafInlineV1 (15.674,32) | 0.903 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (15.971,32) | BloomsdayPinned (14.426,32) | No qualifier | 0.903 |

## Batch1 hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (6.217,16) | BloomsdayPinned (6.011,16) | ByteLeafInlineV1 (6.221,16) | 0.967 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (21.594,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (6.217,16) | BloomsdayPinned (6.011,16) | ByteLeafInlineV1 (6.220,32) | 0.967 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (6.237,32) | BloomsdayPinned (6.027,32) | ByteLeafInlineV1 (6.220,32) | 0.966 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (6.237,32) | BloomsdayPinned (6.027,32) | No qualifier | 0.966 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (17.198,16) | BloomsdayPinned (16.496,16) | ByteLeafInlineV1 (15.997,16) | 0.959 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (48.543,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (17.198,16) | BloomsdayPinned (16.496,16) | ByteLeafInlineV1 (15.997,16) | 0.959 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (27.663,32) | BloomsdayPinned (27.378,32) | ByteLeafInlineV1 (26.809,32) | 0.990 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (27.663,32) | BloomsdayPinned (27.378,32) | No qualifier | 0.990 |

## Batch1 inline_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.312,16) | BloomsdayPinned (1.477,16) | ByteLeafInlineV1 (1.004,16) | 1.125 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (13.873,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.312,16) | BloomsdayPinned (1.477,16) | ByteLeafInlineV1 (1.004,16) | 1.125 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.313,32) | BloomsdayPinned (1.524,32) | ByteLeafInlineV1 (1.039,32) | 1.160 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.313,32) | BloomsdayPinned (1.524,32) | No qualifier | 1.160 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (5.384,16) | BloomsdayPinned (6.388,16) | ByteLeafInlineV1 (5.217,16) | 1.186 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (39.209,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (5.384,16) | BloomsdayPinned (6.388,16) | ByteLeafInlineV1 (5.217,16) | 1.186 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (7.352,32) | BloomsdayPinned (8.439,32) | ByteLeafInlineV1 (7.229,32) | 1.148 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (7.352,32) | BloomsdayPinned (8.439,32) | No qualifier | 1.148 |

## Batch1 inline_hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.750,16) | BloomsdayPinned (2.151,16) | ByteLeafInlineV1 (1.648,16) | 1.230 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (16.671,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.750,16) | BloomsdayPinned (2.149,32) | ByteLeafInlineV1 (1.648,16) | 1.228 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.756,32) | BloomsdayPinned (2.149,32) | ByteLeafInlineV1 (1.670,32) | 1.224 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.756,32) | BloomsdayPinned (2.149,32) | No qualifier | 1.224 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (6.799,16) | BloomsdayPinned (6.883,16) | ByteLeafInlineV1 (6.782,16) | 1.012 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (41.063,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (6.799,16) | BloomsdayPinned (6.883,16) | ByteLeafInlineV1 (6.782,16) | 1.012 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (9.825,32) | BloomsdayPinned (10.463,32) | ByteLeafInlineV1 (9.552,32) | 1.065 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (9.825,32) | BloomsdayPinned (10.463,32) | No qualifier | 1.065 |

## Batch31 lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.314,16) | BloomsdayPinned (1.515,16) | ByteLeafInlineV1 (1.120,16) | 1.153 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (13.906,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.314,16) | BloomsdayPinned (1.515,16) | ByteLeafInlineV1 (1.120,16) | 1.153 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.314,32) | BloomsdayPinned (1.569,32) | ByteLeafInlineV1 (1.183,32) | 1.194 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.314,32) | BloomsdayPinned (1.569,32) | No qualifier | 1.194 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (5.450,16) | BloomsdayPinned (6.634,16) | ByteLeafInlineV1 (5.507,16) | 1.217 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (39.148,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (5.450,16) | BloomsdayPinned (6.634,16) | ByteLeafInlineV1 (5.507,16) | 1.217 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (7.528,32) | BloomsdayPinned (8.648,32) | ByteLeafInlineV1 (7.439,32) | 1.149 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (7.528,32) | BloomsdayPinned (8.648,32) | No qualifier | 1.149 |

## Batch31 hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.737,16) | BloomsdayPinned (2.094,16) | ByteLeafInlineV1 (1.518,16) | 1.205 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (14.539,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.737,16) | BloomsdayPinned (2.094,16) | ByteLeafInlineV1 (1.518,16) | 1.205 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.738,32) | BloomsdayPinned (2.113,32) | ByteLeafInlineV1 (1.533,32) | 1.216 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.738,32) | BloomsdayPinned (2.113,32) | No qualifier | 1.216 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (6.046,16) | BloomsdayPinned (6.652,16) | ByteLeafInlineV1 (6.132,16) | 1.100 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (37.692,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (6.046,16) | BloomsdayPinned (6.652,16) | ByteLeafInlineV1 (6.132,16) | 1.100 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (8.439,32) | BloomsdayPinned (8.919,32) | ByteLeafInlineV1 (8.331,32) | 1.057 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (8.439,32) | BloomsdayPinned (8.919,32) | No qualifier | 1.057 |

## Batch31 inline_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.311,16) | BloomsdayPinned (1.468,16) | ByteLeafInlineV1 (0.991,16) | 1.119 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (13.873,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.311,16) | BloomsdayPinned (1.468,16) | ByteLeafInlineV1 (0.991,16) | 1.119 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.314,32) | BloomsdayPinned (1.523,32) | ByteLeafInlineV1 (1.034,32) | 1.159 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.314,32) | BloomsdayPinned (1.523,32) | No qualifier | 1.159 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (5.393,16) | BloomsdayPinned (6.539,16) | ByteLeafInlineV1 (5.390,16) | 1.212 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (38.813,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (5.393,16) | BloomsdayPinned (6.539,16) | ByteLeafInlineV1 (5.390,16) | 1.212 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (7.347,32) | BloomsdayPinned (8.480,32) | ByteLeafInlineV1 (7.242,32) | 1.154 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (7.347,32) | BloomsdayPinned (8.480,32) | No qualifier | 1.154 |

## Batch31 inline_hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.756,16) | BloomsdayPinned (2.142,16) | ByteLeafInlineV1 (1.652,16) | 1.220 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (16.669,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.756,16) | BloomsdayPinned (2.142,16) | ByteLeafInlineV1 (1.652,16) | 1.220 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.756,32) | BloomsdayPinned (2.152,32) | ByteLeafInlineV1 (1.667,32) | 1.226 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.756,32) | BloomsdayPinned (2.152,32) | No qualifier | 1.226 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (6.873,16) | BloomsdayPinned (7.339,16) | ByteLeafInlineV1 (7.043,16) | 1.068 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (40.653,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (6.873,16) | BloomsdayPinned (7.339,16) | ByteLeafInlineV1 (7.043,16) | 1.068 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (9.839,32) | BloomsdayPinned (10.499,32) | ByteLeafInlineV1 (9.568,32) | 1.067 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (9.839,32) | BloomsdayPinned (10.499,32) | No qualifier | 1.067 |

## Batch4096 lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.313,16) | BloomsdayPinned (1.482,16) | ByteLeafInlineV1 (1.004,16) | 1.129 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (13.573,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.312,32) | BloomsdayPinned (1.482,16) | ByteLeafInlineV1 (1.004,16) | 1.129 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.312,32) | BloomsdayPinned (1.517,32) | ByteLeafInlineV1 (1.019,32) | 1.156 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.312,32) | BloomsdayPinned (1.517,32) | No qualifier | 1.156 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (5.256,16) | BloomsdayPinned (6.528,16) | ByteLeafInlineV1 (5.337,16) | 1.242 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (38.764,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (5.256,16) | BloomsdayPinned (6.528,16) | ByteLeafInlineV1 (5.337,16) | 1.242 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (7.330,32) | BloomsdayPinned (8.526,32) | ByteLeafInlineV1 (7.236,32) | 1.163 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (7.330,32) | BloomsdayPinned (8.526,32) | No qualifier | 1.163 |

## Batch4096 hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.908,16) | BloomsdayPinned (2.004,16) | ByteLeafInlineV1 (1.535,16) | 1.051 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (14.144,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.908,16) | BloomsdayPinned (2.004,16) | ByteLeafInlineV1 (1.535,16) | 1.051 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.925,32) | BloomsdayPinned (2.054,32) | ByteLeafInlineV1 (1.569,32) | 1.067 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.925,32) | BloomsdayPinned (2.054,32) | No qualifier | 1.067 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (4.650,16) | BloomsdayPinned (5.416,16) | ByteLeafInlineV1 (4.954,16) | 1.165 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (36.416,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (4.650,16) | BloomsdayPinned (5.416,16) | ByteLeafInlineV1 (4.954,16) | 1.165 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (6.817,32) | BloomsdayPinned (7.696,32) | ByteLeafInlineV1 (6.833,32) | 1.129 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (6.817,32) | BloomsdayPinned (7.696,32) | No qualifier | 1.129 |

## Batch4096 inline_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.314,16) | BloomsdayPinned (1.477,16) | ByteLeafInlineV1 (1.005,16) | 1.124 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (13.874,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.310,32) | BloomsdayPinned (1.477,16) | ByteLeafInlineV1 (1.005,16) | 1.128 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.310,32) | BloomsdayPinned (1.512,32) | ByteLeafInlineV1 (1.018,32) | 1.155 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.310,32) | BloomsdayPinned (1.512,32) | No qualifier | 1.155 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (5.255,16) | BloomsdayPinned (6.561,16) | ByteLeafInlineV1 (5.392,16) | 1.248 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (38.775,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (5.255,16) | BloomsdayPinned (6.561,16) | ByteLeafInlineV1 (5.392,16) | 1.248 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (7.344,32) | BloomsdayPinned (8.542,32) | ByteLeafInlineV1 (7.267,32) | 1.163 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (7.344,32) | BloomsdayPinned (8.542,32) | No qualifier | 1.163 |

## Batch4096 inline_hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Independent32(ns,actual bpk) | Strongest external(ns,actual bpk) | ByteLeaf(ns,actual bpk) | External / Independent32 |
| ---: | ---: | ---: | --- | --- | --- | ---: |
| 65536 | 16 | 1.00% | Independent32BloomFilter (1.752,16) | BloomsdayPinned (2.145,16) | ByteLeafInlineV1 (1.652,16) | 1.224 |
| 65536 | 16 | 0.10% | No qualifier | Fastbloom017 (16.679,16) | No qualifier | — |
| 65536 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 65536 | 32 | 1.00% | Independent32BloomFilter (1.752,16) | BloomsdayPinned (2.145,16) | ByteLeafInlineV1 (1.652,16) | 1.224 |
| 65536 | 32 | 0.10% | Independent32BloomFilter (1.758,32) | BloomsdayPinned (2.152,32) | ByteLeafInlineV1 (1.674,32) | 1.224 |
| 65536 | 32 | 0.01% | Independent32BloomFilter (1.758,32) | BloomsdayPinned (2.152,32) | No qualifier | 1.224 |
| 33554432 | 16 | 1.00% | Independent32BloomFilter (6.702,16) | BloomsdayPinned (7.354,16) | ByteLeafInlineV1 (7.042,16) | 1.097 |
| 33554432 | 16 | 0.10% | No qualifier | Fastbloom017 (40.543,16) | No qualifier | — |
| 33554432 | 16 | 0.01% | No qualifier | No qualifier | No qualifier | — |
| 33554432 | 32 | 1.00% | Independent32BloomFilter (6.702,16) | BloomsdayPinned (7.354,16) | ByteLeafInlineV1 (7.042,16) | 1.097 |
| 33554432 | 32 | 0.10% | Independent32BloomFilter (9.813,32) | BloomsdayPinned (10.574,32) | ByteLeafInlineV1 (9.619,32) | 1.078 |
| 33554432 | 32 | 0.01% | Independent32BloomFilter (9.813,32) | BloomsdayPinned (10.574,32) | No qualifier | 1.078 |

`rankings.json` preserves all144 cap/FPR/mode/batch views, with the fastest original native, experimental native, external, Independent32 and ByteLeaf choices kept separate. `individual-native.csv` preserves2304 eligible and ineligible individual native comparisons; `leaf-ratios.csv` preserves144 exact original/leaf comparisons; `api-ratios.csv` preserves264 generic/visible ratios; `quality.csv` preserves32 family/size/seed calibration records. Trial min/max are observed ranges, not speed confidence intervals. The16/32bpk grid does not cover finer capacities, and only the three frozen Rust external families participate in this screen.
