# Optimizer-visible singleton screen

All 60 configurations ran on CPU2: four native layouts, four project experiments and 52 external configurations. Four workloads / 240 rows use seed42, 2^22 queries, eight balanced repetitions, full-input serial construction and 2^24 independent calibration negatives. Every timed phase validates complete dense output. This is exploratory throughput evidence, not a dependent-latency measurement or held-out claim. The runner pins CPU2 on socket0 but does not force a NUMA memory policy.

Native leaders below exclude the independent-layout experiments. All external configurations remain eligible rivals, subject to exact allocation and the two-sided95 Wilson FPR upper. Page's native raw-hash path can compete only in raw metrics. Identical SingleV1 controls remain explicit rows; they do not add calibration samples.

## lookup_ns

| Keys | Cap bpk | FPR ceiling | Native leader | ns/key | External leader | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65,536 | 16 | 1.00% | ByteSplitBloomFilter | 2.039 | FastFilterFixed16SingleV1 | 2.206 | 1.082× |
| 65,536 | 16 | 0.10% | Split64BloomFilter | 2.643 | Boost192Multi64K8 | 3.232 | 1.223× |
| 65,536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65,536 | 32 | 1.00% | ByteSplitBloomFilter | 2.039 | FastFilterFixed16SingleV1 | 2.206 | 1.082× |
| 65,536 | 32 | 0.10% | ByteSplitBloomFilter | 2.083 | FastFilterFixed16SingleV1 | 2.255 | 1.083× |
| 65,536 | 32 | 0.01% | Split64BloomFilter | 2.637 | FastFilterSimdBlockSingleV1 | 2.380 | 0.902× |
| 33,554,432 | 16 | 1.00% | ByteSplitBloomFilter | 7.913 | FastFilterFixed16 | 9.105 | 1.151× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter | 8.730 | FastFilterFixed64 | 9.449 | 1.082× |
| 33,554,432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33,554,432 | 32 | 1.00% | ByteSplitBloomFilter | 7.913 | FastFilterFixed16 | 9.105 | 1.151× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter | 8.730 | FastFilterFixed64 | 9.449 | 1.082× |
| 33,554,432 | 32 | 0.01% | Split64BloomFilter | 11.867 | FastFilterSimdBlockSingleV1 | 13.117 | 1.105× |

## hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native leader | ns/key | External leader | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65,536 | 16 | 1.00% | ByteSplitBloomFilter | 3.933 | FastFilterFixed16SingleV1 | 4.057 | 1.031× |
| 65,536 | 16 | 0.10% | Split64BloomFilter | 4.234 | FastFilterFixed64 | 5.191 | 1.226× |
| 65,536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65,536 | 32 | 1.00% | ByteSplitBloomFilter | 3.920 | FastFilterFixed16SingleV1 | 4.057 | 1.035× |
| 65,536 | 32 | 0.10% | ByteSplitBloomFilter | 3.920 | FastFilterFixed16SingleV1 | 4.108 | 1.048× |
| 65,536 | 32 | 0.01% | Split64BloomFilter | 4.238 | FastFilterSimdBlockSingleV1 | 4.234 | 0.999× |
| 33,554,432 | 16 | 1.00% | ByteSplitBloomFilter | 11.763 | Boost192Multi32K4 | 12.787 | 1.087× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter | 12.822 | FastFilterFixed64 | 13.685 | 1.067× |
| 33,554,432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33,554,432 | 32 | 1.00% | ByteSplitBloomFilter | 11.763 | Boost192Multi32K4 | 12.787 | 1.087× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter | 12.822 | FastFilterFixed64 | 13.685 | 1.067× |
| 33,554,432 | 32 | 0.01% | Split64BloomFilter | 18.235 | FastFilterSimdBlockSingleV1 | 19.555 | 1.072× |

## inline_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native leader | ns/key | External leader | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65,536 | 16 | 1.00% | ByteSplitBloomFilter | 0.996 | FastFilterFixed16SingleV1 | 1.092 | 1.096× |
| 65,536 | 16 | 0.10% | Split64BloomFilter | 1.524 | FastFilterFixed64 | 2.149 | 1.410× |
| 65,536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65,536 | 32 | 1.00% | ByteSplitBloomFilter | 0.996 | FastFilterFixed16SingleV1 | 1.092 | 1.096× |
| 65,536 | 32 | 0.10% | ByteSplitBloomFilter | 1.034 | FastFilterFixed16SingleV1 | 1.141 | 1.103× |
| 65,536 | 32 | 0.01% | Split64BloomFilter | 1.530 | FastFilterSimdBlockSingleV1 | 1.249 | 0.816× |
| 33,554,432 | 16 | 1.00% | ByteSplitBloomFilter | 5.449 | FastFilterFixed16 | 6.203 | 1.138× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter | 6.584 | FastFilterFixed64 | 6.925 | 1.052× |
| 33,554,432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33,554,432 | 32 | 1.00% | ByteSplitBloomFilter | 5.449 | FastFilterFixed16 | 6.203 | 1.138× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter | 6.584 | FastFilterFixed64 | 6.925 | 1.052× |
| 33,554,432 | 32 | 0.01% | Split64BloomFilter | 8.194 | FastFilterSimdBlock | 8.354 | 1.019× |

## inline_hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Native leader | ns/key | External leader | ns/key | External/native |
| ---: | ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65,536 | 16 | 1.00% | ByteSplitBloomFilter | 1.682 | FastFilterFixed16 | 1.795 | 1.067× |
| 65,536 | 16 | 0.10% | Split64BloomFilter | 2.012 | RocksDBFastLocalBloom64K8 | 3.043 | 1.512× |
| 65,536 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 65,536 | 32 | 1.00% | ByteSplitBloomFilter | 1.682 | FastFilterFixed16 | 1.795 | 1.067× |
| 65,536 | 32 | 0.10% | ByteSplitBloomFilter | 1.700 | FastFilterFixed16 | 1.835 | 1.080× |
| 65,536 | 32 | 0.01% | Split64BloomFilter | 2.021 | FastFilterFixed32Bulk | 1.872 | 0.926× |
| 33,554,432 | 16 | 1.00% | ByteSplitBloomFilter | 6.694 | FastFilterFixed16 | 7.283 | 1.088× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter | 7.320 | FastFilterFixed64 | 8.082 | 1.104× |
| 33,554,432 | 16 | 0.01% | No qualifier | — | No qualifier | — | — |
| 33,554,432 | 32 | 1.00% | ByteSplitBloomFilter | 6.694 | FastFilterFixed16 | 7.283 | 1.088× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter | 7.320 | FastFilterFixed64 | 8.082 | 1.104× |
| 33,554,432 | 32 | 0.01% | Split64BloomFilter | 9.888 | FastFilterFixed32Bulk | 10.390 | 1.051× |

## Interpretation

The old generic batch-count-one loop and the new compiler-visible singleton loop are separate API contracts. A win in one does not replace a loss in the other. The new raw loop permits the compiler to keep the common hash in registers and optimize across keys. Boost uses its actual public `may_contain` through a force-inline shim; original adapter construction/insertion/bulk methods are unchanged. Genuine non-inlined upstream FastFilter `Contain` calls remain visible in the assembly audit.

`summary.json` retains every individual native/experimental comparison, every API-induced gain or loss, chosen allocations, FPR bounds and sample ranges. No experimental layout is counted as an external rival. Speed ratios are descriptive; pointwise FPR bounds are not simultaneous selection guarantees. The frozen correctness/assembly inventory and `screen/validation.json` identify the exact executable. No production source was changed by this harness experiment.
Five focused analysis regression tests reject invalid old-path timings, raw-only pure-query values and impossible allocation metadata before ranking.
