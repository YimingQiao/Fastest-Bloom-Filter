# Rust public singleton: unchanged natural API screen

Four workloads / 28 rows on CPU2 compare seven original implementations under four separately reported query contracts. The whole-array modes expose the actual public singleton API to the compiler; they do not force every probe body to inline. Dense outputs, hashing, all four eight-trial vectors and the exact seed-derived Williams schedule were checked. Source and executable hashes were unchanged.

Seed42, key powers 16/25, actual 16/32 bpk, 50% hits, query power 22, eight balanced repetitions, whole-input insertion and 2^24 independent calibration negatives. This is independent-key throughput, not serial dependent latency. No CPU NUMA binding was applied; CPU2 was pinned. These initial results are not held-out confirmation.

FastPattern, Fastbloom and Bloomsday probe logic is present inside their visible loops. ByteSplit retains a public contains_hash call per key; FourSector/Split64 retain out-of-line scalar helpers; SBBF retains its public runtime-selected trait-object call. See the pre-data assembly audit. Visible Split/Four paths also differ from their batch SIMD kernels. The measurements must not be attributed solely to removing call overhead.

Each table uses exact allocated-byte caps and pointwise two-sided 95% Wilson upper endpoints. A ratio above 1 favors the native layout. All individual candidates, including losses, remain in summary.json.

## lookup_ns

| Keys | Cap bpk | FPR ceiling | Native | ns/key | External | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter | 3.475 | BloomsdayPinned | 3.242 | 0.933× |
| 65536 | 16 | 0.10% | Split64BloomFilter | 3.907 | Fastbloom017 | 16.438 | 4.207× |
| 65536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter | 3.475 | BloomsdayPinned | 3.242 | 0.933× |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter | 3.479 | BloomsdayPinned | 3.243 | 0.932× |
| 65536 | 32 | 0.01% | Split64BloomFilter | 3.937 | BloomsdayPinned | 3.243 | 0.824× |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter | 9.219 | BloomsdayPinned | 8.353 | 0.906× |
| 33554432 | 16 | 0.10% | Split64BloomFilter | 9.586 | Fastbloom017 | 41.321 | 4.311× |
| 33554432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter | 9.219 | BloomsdayPinned | 8.353 | 0.906× |
| 33554432 | 32 | 0.10% | Split64BloomFilter | 9.586 | BloomsdayPinned | 13.273 | 1.385× |
| 33554432 | 32 | 0.01% | Split64BloomFilter | 15.940 | BloomsdayPinned | 13.273 | 0.833× |

## hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native | ns/key | External | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter | 5.509 | BloomsdayPinned | 5.334 | 0.968× |
| 65536 | 16 | 0.10% | Split64BloomFilter | 5.850 | Fastbloom017 | 20.909 | 3.574× |
| 65536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter | 5.509 | BloomsdayPinned | 5.334 | 0.968× |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter | 5.514 | BloomsdayPinned | 5.339 | 0.968× |
| 65536 | 32 | 0.01% | Split64BloomFilter | 5.837 | BloomsdayPinned | 5.339 | 0.915× |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter | 13.637 | SbbfSafePinned | 15.191 | 1.114× |
| 33554432 | 16 | 0.10% | Split64BloomFilter | 14.415 | Fastbloom017 | 46.724 | 3.241× |
| 33554432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter | 13.637 | SbbfSafePinned | 15.191 | 1.114× |
| 33554432 | 32 | 0.10% | Split64BloomFilter | 14.415 | SbbfSafePinned | 24.469 | 1.698× |
| 33554432 | 32 | 0.01% | Split64BloomFilter | 23.588 | SbbfSafePinned | 24.469 | 1.037× |

## inline_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native | ns/key | External | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter | 1.529 | BloomsdayPinned | 1.476 | 0.965× |
| 65536 | 16 | 0.10% | Split64BloomFilter | 2.378 | Fastbloom017 | 13.612 | 5.723× |
| 65536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter | 1.529 | BloomsdayPinned | 1.476 | 0.965× |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter | 1.548 | BloomsdayPinned | 1.519 | 0.981× |
| 65536 | 32 | 0.01% | Split64BloomFilter | 2.379 | BloomsdayPinned | 1.519 | 0.639× |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter | 6.305 | BloomsdayPinned | 6.405 | 1.016× |
| 33554432 | 16 | 0.10% | Split64BloomFilter | 7.121 | Fastbloom017 | 37.932 | 5.327× |
| 33554432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter | 6.305 | BloomsdayPinned | 6.405 | 1.016× |
| 33554432 | 32 | 0.10% | Split64BloomFilter | 7.121 | BloomsdayPinned | 8.416 | 1.182× |
| 33554432 | 32 | 0.01% | Split64BloomFilter | 10.369 | BloomsdayPinned | 8.416 | 0.812× |

## inline_hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native | ns/key | External | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 16 | 1.00% | ByteSplitBloomFilter | 2.266 | BloomsdayPinned | 2.143 | 0.946× |
| 65536 | 16 | 0.10% | Split64BloomFilter | 3.039 | Fastbloom017 | 16.828 | 5.537× |
| 65536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65536 | 32 | 1.00% | ByteSplitBloomFilter | 2.266 | BloomsdayPinned | 2.143 | 0.946× |
| 65536 | 32 | 0.10% | ByteSplitBloomFilter | 2.305 | BloomsdayPinned | 2.147 | 0.931× |
| 65536 | 32 | 0.01% | Split64BloomFilter | 3.098 | BloomsdayPinned | 2.147 | 0.693× |
| 33554432 | 16 | 1.00% | ByteSplitBloomFilter | 7.421 | BloomsdayPinned | 6.948 | 0.936× |
| 33554432 | 16 | 0.10% | Split64BloomFilter | 8.159 | Fastbloom017 | 40.346 | 4.945× |
| 33554432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33554432 | 32 | 1.00% | ByteSplitBloomFilter | 7.421 | BloomsdayPinned | 6.948 | 0.936× |
| 33554432 | 32 | 0.10% | Split64BloomFilter | 8.159 | BloomsdayPinned | 10.436 | 1.279× |
| 33554432 | 32 | 0.01% | Split64BloomFilter | 12.723 | BloomsdayPinned | 10.436 | 0.820× |

api-ratios.csv retains all 56 within-family original/visible ratios. An improvement in a visible mode does not replace an original-mode loss. The 28 family/size calibration records are shared across all four query modes, and all families use the same inputs. Nested caps and ceilings are not independent performance trials. Min/max ranges are descriptive, with no speed confidence interval or simultaneous FPR-selection guarantee. The tested 16/32 bpk grid does not cover finer upstream capacities.
