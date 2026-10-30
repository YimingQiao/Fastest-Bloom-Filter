# Exact-capacity external training screen

All 988 planned rows completed. CPU2, 65K/32M keys, batch4096, hit50%, seed42, six balanced query repetitions and 2^24 independent negative probes per mapping. The grid adds actual backing-byte ceilings12/14/16/20/24/28/32 bpk; repeated native/Simd power-of-two capacities are measured once. CPU affinity does not impose an explicit NUMA memory policy.

Four production native layouts,68 external configurations and two range-capacity project experiments remain separate. The experiments are not production releases or external rivals. Disabled construction fields are unavailable; each query measurement follows one complete validated build. All query answers and guards are checked after every timed phase.

Each memory/FPR cell admits every measured fitting allocation. Eligibility uses a pointwise two-sided95 Wilson upper endpoint. Identical API/mapping counts are not pooled; the intervals do not provide simultaneous coverage after selecting among many candidates. Ratios are descriptive training results, pending fresh-seed confirmation.

## lookup_ns

| Keys | Cap bpk | FPR ceiling | Production native | Best external | External/native | Range experiment | External/experiment |
| ---: | ---: | ---: | --- | --- | ---: | --- | ---: |
| 65,536 | 16 | 1.00% | FastPatternBF (16.000 bpk, 0.678 ns) | FastFilterFixed16SingleV1 (14.000 bpk, 1.101 ns) | 1.625× | ByteSplitRangeExperiment (14.000 bpk, 1.078 ns) | 1.021× |
| 65,536 | 16 | 0.10% | FourSectorBloomFilter (16.000 bpk, 1.062 ns) | FastFilterFixed64 (16.000 bpk, 2.158 ns) | 2.033× | Split64RangeExperiment (16.000 bpk, 1.691 ns) | 1.277× |
| 65,536 | 16 | 0.01% | No qualifier | No qualifier | — | No qualifier | — |
| 65,536 | 32 | 1.00% | FastPatternBF (16.000 bpk, 0.678 ns) | FastFilterFixed16SingleV1 (14.000 bpk, 1.101 ns) | 1.625× | ByteSplitRangeExperiment (14.000 bpk, 1.078 ns) | 1.021× |
| 65,536 | 32 | 0.10% | FastPatternBF (32.000 bpk, 0.732 ns) | FastFilterFixed16 (32.000 bpk, 1.141 ns) | 1.559× | ByteSplitRangeExperiment (32.000 bpk, 1.110 ns) | 1.028× |
| 65,536 | 32 | 0.01% | FourSectorBloomFilter (32.000 bpk, 1.129 ns) | FastFilterSimdBlockSingleV1 (32.000 bpk, 1.246 ns) | 1.104× | Split64RangeExperiment (28.000 bpk, 1.690 ns) | 0.737× |
| 33,554,432 | 16 | 1.00% | FastPatternBF (16.000 bpk, 4.188 ns) | Boost192Multi32K8 (12.000 bpk, 4.723 ns) | 1.128× | Split64RangeExperiment (12.000 bpk, 4.859 ns) | 0.972× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter (16.000 bpk, 4.850 ns) | Boost192Multi64K8 (16.000 bpk, 5.671 ns) | 1.169× | Split64RangeExperiment (16.000 bpk, 5.261 ns) | 1.078× |
| 33,554,432 | 16 | 0.01% | No qualifier | No qualifier | — | No qualifier | — |
| 33,554,432 | 32 | 1.00% | FastPatternBF (16.000 bpk, 4.188 ns) | Boost192Multi32K8 (12.000 bpk, 4.723 ns) | 1.128× | Split64RangeExperiment (12.000 bpk, 4.859 ns) | 0.972× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter (16.000 bpk, 4.850 ns) | Boost192Multi32K8 (20.000 bpk, 5.468 ns) | 1.128× | Split64RangeExperiment (16.000 bpk, 5.261 ns) | 1.039× |
| 33,554,432 | 32 | 0.01% | FastPatternBF (32.000 bpk, 6.047 ns) | Boost192Multi32K8 (28.000 bpk, 6.264 ns) | 1.036× | Split64RangeExperiment (24.000 bpk, 6.059 ns) | 1.034× |

## hash_lookup_ns

| Keys | Cap bpk | FPR ceiling | Production native | Best external | External/native | Range experiment | External/experiment |
| ---: | ---: | ---: | --- | --- | ---: | --- | ---: |
| 65,536 | 16 | 1.00% | FastPatternBF (16.000 bpk, 1.214 ns) | FastFilterFixed16SingleV1 (14.000 bpk, 1.607 ns) | 1.324× | ByteSplitRangeExperiment (14.000 bpk, 1.583 ns) | 1.015× |
| 65,536 | 16 | 0.10% | FourSectorBloomFilter (16.000 bpk, 1.574 ns) | FastFilterFixed64 (16.000 bpk, 2.723 ns) | 1.730× | Split64RangeExperiment (16.000 bpk, 2.275 ns) | 1.197× |
| 65,536 | 16 | 0.01% | No qualifier | No qualifier | — | No qualifier | — |
| 65,536 | 32 | 1.00% | FastPatternBF (16.000 bpk, 1.214 ns) | FastFilterFixed16SingleV1 (14.000 bpk, 1.607 ns) | 1.324× | ByteSplitRangeExperiment (20.000 bpk, 1.579 ns) | 1.018× |
| 65,536 | 32 | 0.10% | FastPatternBF (32.000 bpk, 1.243 ns) | FastFilterFixed16 (32.000 bpk, 1.651 ns) | 1.329× | ByteSplitRangeExperiment (28.000 bpk, 1.633 ns) | 1.011× |
| 65,536 | 32 | 0.01% | FourSectorBloomFilter (32.000 bpk, 1.627 ns) | FastFilterSimdBlock (32.000 bpk, 1.780 ns) | 1.094× | Split64RangeExperiment (32.000 bpk, 2.250 ns) | 0.791× |
| 33,554,432 | 16 | 1.00% | FastPatternBF (16.000 bpk, 4.175 ns) | Boost192Multi32K8 (12.000 bpk, 4.194 ns) | 1.005× | Split64RangeExperiment (12.000 bpk, 4.041 ns) | 1.038× |
| 33,554,432 | 16 | 0.10% | Split64BloomFilter (16.000 bpk, 4.288 ns) | Boost192Multi64K8 (16.000 bpk, 4.721 ns) | 1.101× | Split64RangeExperiment (16.000 bpk, 4.466 ns) | 1.057× |
| 33,554,432 | 16 | 0.01% | No qualifier | No qualifier | — | No qualifier | — |
| 33,554,432 | 32 | 1.00% | FastPatternBF (16.000 bpk, 4.175 ns) | Boost192Multi32K8 (12.000 bpk, 4.194 ns) | 1.005× | Split64RangeExperiment (12.000 bpk, 4.041 ns) | 1.038× |
| 33,554,432 | 32 | 0.10% | Split64BloomFilter (16.000 bpk, 4.288 ns) | Boost192Multi64K8 (16.000 bpk, 4.721 ns) | 1.101× | Split64RangeExperiment (16.000 bpk, 4.466 ns) | 1.057× |
| 33,554,432 | 32 | 0.01% | FastPatternBF (32.000 bpk, 6.007 ns) | Boost192Multi64K8 (24.000 bpk, 5.753 ns) | 0.958× | Split64RangeExperiment (24.000 bpk, 5.521 ns) | 1.042× |

`summary.json` preserves every qualified individual native/experimental allocation comparison and loss, plus the quality identities and leader trial ranges. PageBloom competes only in the raw-key metric; its prehashed columns remain unavailable. This balanced query-only harness is separate from historical repeated-build, single-call and multithreaded results; elapsed values from different binaries are not merged.

Measured source commit: `d70077b28fb3cd5821ae471f185e98393423ec64`. Full commands, phase orders, trial vectors, allocation geometry and source hashes remain in the archive.
