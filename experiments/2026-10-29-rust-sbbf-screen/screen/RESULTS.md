# Rust SBBF14 initial screen

Twelve workloads / 168 rows compare four native layouts and three external implementations, each with an explicit public singleton control. CPU3, seed42, 2^22 queries, five repetitions, full-input insertion and 2^24 independent calibration negatives. This is an exploratory throughput screen; it does not establish global leadership or held-out performance.

The table keeps native original APIs and selects the strongest measured public external path. Exact actual-byte caps have zero slack. Eligibility uses the upper endpoint of a pointwise two-sided 95% Wilson interval. Values above 1 in the last column favor the native entry. All other API tracks and individual family wins/losses remain in `rankings.csv` and `summary.json`.

## lookup_ns

| Keys | Batch | Cap bpk | FPR ceiling | Native original | ns/key | External public path | ns/key | External/native |
| ---: | ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 1 | 16 | 1.00% | ByteSplitBloomFilter | 3.633 | BloomsdaySingleApiV1 | 3.241 | 0.892× |
| 65536 | 1 | 16 | 0.10% | Split64BloomFilter | 4.077 | FastbloomSingleApiV1 | 15.897 | 3.899× |
| 65536 | 1 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 1 | 32 | 1.00% | ByteSplitBloomFilter | 3.633 | BloomsdaySingleApiV1 | 3.241 | 0.892× |
| 65536 | 1 | 32 | 0.10% | ByteSplitBloomFilter | 3.633 | BloomsdaySingleApiV1 | 3.244 | 0.893× |
| 65536 | 1 | 32 | 0.01% | Split64BloomFilter | 4.078 | BloomsdaySingleApiV1 | 3.244 | 0.796× |
| 65536 | 31 | 16 | 1.00% | ByteSplitBloomFilter | 1.117 | BloomsdayPinned | 1.514 | 1.356× |
| 65536 | 31 | 16 | 0.10% | FourSectorBloomFilter | 1.232 | FastbloomSingleApiV1 | 13.927 | 11.306× |
| 65536 | 31 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 31 | 32 | 1.00% | ByteSplitBloomFilter | 1.078 | BloomsdayPinned | 1.514 | 1.404× |
| 65536 | 31 | 32 | 0.10% | ByteSplitBloomFilter | 1.078 | BloomsdayPinned | 1.553 | 1.440× |
| 65536 | 31 | 32 | 0.01% | FourSectorBloomFilter | 1.295 | BloomsdayPinned | 1.553 | 1.199× |
| 65536 | 4096 | 16 | 1.00% | FastPatternBF | 0.667 | BloomsdayPinned | 1.458 | 2.186× |
| 65536 | 4096 | 16 | 0.10% | FourSectorBloomFilter | 1.077 | Fastbloom017 | 13.555 | 12.583× |
| 65536 | 4096 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 4096 | 32 | 1.00% | FastPatternBF | 0.667 | BloomsdayPinned | 1.458 | 2.186× |
| 65536 | 4096 | 32 | 0.10% | FastPatternBF | 0.730 | BloomsdayPinned | 1.501 | 2.055× |
| 65536 | 4096 | 32 | 0.01% | FourSectorBloomFilter | 1.147 | BloomsdayPinned | 1.501 | 1.308× |
| 33554432 | 1 | 16 | 1.00% | ByteSplitBloomFilter | 8.700 | BloomsdaySingleApiV1 | 8.029 | 0.923× |
| 33554432 | 1 | 16 | 0.10% | Split64BloomFilter | 9.401 | FastbloomSingleApiV1 | 40.795 | 4.340× |
| 33554432 | 1 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 1 | 32 | 1.00% | ByteSplitBloomFilter | 8.700 | BloomsdaySingleApiV1 | 8.029 | 0.923× |
| 33554432 | 1 | 32 | 0.10% | Split64BloomFilter | 9.401 | BloomsdaySingleApiV1 | 13.704 | 1.458× |
| 33554432 | 1 | 32 | 0.01% | Split64BloomFilter | 16.147 | BloomsdaySingleApiV1 | 13.704 | 0.849× |
| 33554432 | 31 | 16 | 1.00% | ByteSplitBloomFilter | 5.011 | BloomsdayPinned | 6.058 | 1.209× |
| 33554432 | 31 | 16 | 0.10% | Split64BloomFilter | 5.974 | Fastbloom017 | 38.267 | 6.406× |
| 33554432 | 31 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 31 | 32 | 1.00% | ByteSplitBloomFilter | 5.011 | BloomsdayPinned | 6.058 | 1.209× |
| 33554432 | 31 | 32 | 0.10% | Split64BloomFilter | 5.974 | BloomsdayPinned | 8.298 | 1.389× |
| 33554432 | 31 | 32 | 0.01% | FourSectorBloomFilter | 7.093 | BloomsdayPinned | 8.298 | 1.170× |
| 33554432 | 4096 | 16 | 1.00% | FastPatternBF | 4.027 | BloomsdaySingleApiV1 | 6.107 | 1.517× |
| 33554432 | 4096 | 16 | 0.10% | Split64BloomFilter | 4.690 | Fastbloom017 | 37.747 | 8.048× |
| 33554432 | 4096 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 4096 | 32 | 1.00% | FastPatternBF | 4.027 | BloomsdaySingleApiV1 | 6.107 | 1.517× |
| 33554432 | 4096 | 32 | 0.10% | Split64BloomFilter | 4.690 | BloomsdayPinned | 8.110 | 1.729× |
| 33554432 | 4096 | 32 | 0.01% | FastPatternBF | 5.688 | BloomsdayPinned | 8.110 | 1.426× |

## hash_lookup_ns

| Keys | Batch | Cap bpk | FPR ceiling | Native original | ns/key | External public path | ns/key | External/native |
| ---: | ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 1 | 16 | 1.00% | ByteSplitBloomFilter | 6.159 | BloomsdaySingleApiV1 | 5.779 | 0.938× |
| 65536 | 1 | 16 | 0.10% | Split64BloomFilter | 6.507 | FastbloomSingleApiV1 | 21.131 | 3.247× |
| 65536 | 1 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 1 | 32 | 1.00% | ByteSplitBloomFilter | 6.159 | BloomsdaySingleApiV1 | 5.779 | 0.938× |
| 65536 | 1 | 32 | 0.10% | ByteSplitBloomFilter | 6.162 | BloomsdaySingleApiV1 | 5.803 | 0.942× |
| 65536 | 1 | 32 | 0.01% | Split64BloomFilter | 6.506 | BloomsdaySingleApiV1 | 5.803 | 0.892× |
| 65536 | 31 | 16 | 1.00% | ByteSplitBloomFilter | 1.481 | BloomsdayPinned | 2.081 | 1.405× |
| 65536 | 31 | 16 | 0.10% | FourSectorBloomFilter | 1.983 | FastbloomSingleApiV1 | 14.495 | 7.310× |
| 65536 | 31 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 31 | 32 | 1.00% | ByteSplitBloomFilter | 1.481 | BloomsdayPinned | 2.081 | 1.405× |
| 65536 | 31 | 32 | 0.10% | ByteSplitBloomFilter | 1.492 | BloomsdaySingleApiV1 | 2.103 | 1.409× |
| 65536 | 31 | 32 | 0.01% | FourSectorBloomFilter | 2.049 | BloomsdaySingleApiV1 | 2.103 | 1.026× |
| 65536 | 4096 | 16 | 1.00% | FastPatternBF | 1.096 | BloomsdayPinned | 1.914 | 1.745× |
| 65536 | 4096 | 16 | 0.10% | FourSectorBloomFilter | 1.510 | FastbloomSingleApiV1 | 14.043 | 9.301× |
| 65536 | 4096 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 4096 | 32 | 1.00% | FastPatternBF | 1.096 | BloomsdayPinned | 1.914 | 1.745× |
| 65536 | 4096 | 32 | 0.10% | FastPatternBF | 1.156 | BloomsdayPinned | 1.954 | 1.691× |
| 65536 | 4096 | 32 | 0.01% | FourSectorBloomFilter | 1.583 | BloomsdayPinned | 1.954 | 1.235× |
| 33554432 | 1 | 16 | 1.00% | ByteSplitBloomFilter | 14.129 | BloomsdaySingleApiV1 | 15.194 | 1.075× |
| 33554432 | 1 | 16 | 0.10% | Split64BloomFilter | 14.549 | FastbloomSingleApiV1 | 46.956 | 3.227× |
| 33554432 | 1 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 1 | 32 | 1.00% | ByteSplitBloomFilter | 14.129 | BloomsdaySingleApiV1 | 15.194 | 1.075× |
| 33554432 | 1 | 32 | 0.10% | Split64BloomFilter | 14.549 | BloomsdaySingleApiV1 | 25.137 | 1.728× |
| 33554432 | 1 | 32 | 0.01% | Split64BloomFilter | 23.244 | BloomsdaySingleApiV1 | 25.137 | 1.081× |
| 33554432 | 31 | 16 | 1.00% | FourSectorBloomFilter | 5.599 | BloomsdaySingleApiV1 | 6.020 | 1.075× |
| 33554432 | 31 | 16 | 0.10% | Split64BloomFilter | 6.064 | Fastbloom017 | 37.117 | 6.121× |
| 33554432 | 31 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 31 | 32 | 1.00% | FourSectorBloomFilter | 5.599 | BloomsdaySingleApiV1 | 6.020 | 1.075× |
| 33554432 | 31 | 32 | 0.10% | Split64BloomFilter | 6.064 | BloomsdaySingleApiV1 | 8.479 | 1.398× |
| 33554432 | 31 | 32 | 0.01% | FourSectorBloomFilter | 7.566 | BloomsdaySingleApiV1 | 8.479 | 1.121× |
| 33554432 | 4096 | 16 | 1.00% | FastPatternBF | 4.039 | BloomsdayPinned | 4.818 | 1.193× |
| 33554432 | 4096 | 16 | 0.10% | Split64BloomFilter | 4.195 | FastbloomSingleApiV1 | 36.076 | 8.599× |
| 33554432 | 4096 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 4096 | 32 | 1.00% | FastPatternBF | 4.039 | BloomsdayPinned | 4.818 | 1.193× |
| 33554432 | 4096 | 32 | 0.10% | Split64BloomFilter | 4.195 | BloomsdaySingleApiV1 | 7.234 | 1.724× |
| 33554432 | 4096 | 32 | 0.01% | FastPatternBF | 5.634 | BloomsdaySingleApiV1 | 7.234 | 1.284× |

`quality.csv` has 28 unique calibration experiments, not 168 independent samples. `api-ratios.csv` preserves every original/control query and construction ratio, including regressions. Query repetition min/max ranges are descriptive; no confidence interval for speed is asserted. The frozen harness always measures prehashed query before hash-plus-query within a repetition, so this screen does not claim balanced phase ordering.
