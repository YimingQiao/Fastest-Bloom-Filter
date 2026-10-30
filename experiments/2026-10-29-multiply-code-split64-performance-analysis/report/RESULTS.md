# Multiply-code Split64: fixed70 training screen

All13 cases/70 rows passed committed source, dependency and binary hashes; exact commands, source-derived row order, four ownership distinctions plus the new candidate, trial vectors and raw-to-aggregate equality. All62 retained configurations reproduce the preceding Cyclic62 screen's workload, bytes, probes, dense checksum and calibration exactly. Earlier latency values are not imported.

This is one seed42 CPU3/socket1 binary: n=2^16/2^25, batch4096, q=2^22,50% intended hits, six alternating prehashed/common-hash phases,2^24 disjoint calibration negatives per mapping and one complete build outside query timing. Build columns are NaN. CPU affinity is recorded; no explicit NUMA memory-binding or construction-speed claim is made.

The measured shortlist retains62 old geometries and adds all8 fixed multiply-code geometries. It is not a speed measurement of all76 registered types or held-out confirmation. The24-row accuracy pilot uses a different counter interval from this shared benchmark: its candidate counts must not be required to reproduce here, substituted for current quality or pooled with this screen.

## All eight multiply-code allocations

| Keys | Actual bpk | FP / negatives | Wilson95 upper FPR | Pass0.1% | Pass0.01% | Prehashed ns | Common hash+query ns |
|---:|---:|---|---:|:---:|:---:|---:|---:|
| 65,536 | 16 | 15216/16777216 | 0.092146% | True | False | 1.5409 | 2.1158 |
| 65,536 | 24 | 1437/16777216 | 0.009020% | True | True | 1.5351 | 2.1122 |
| 65,536 | 28 | 607/16777216 | 0.003917% | True | True | 1.5421 | 2.1456 |
| 65,536 | 32 | 259/16777216 | 0.001744% | True | True | 1.5325 | 2.1274 |
| 33,554,432 | 16 | 15329/16777216 | 0.092825% | True | False | 5.5412 | 4.7086 |
| 33,554,432 | 24 | 1538/16777216 | 0.009637% | True | True | 6.2548 | 5.5302 |
| 33,554,432 | 28 | 590/16777216 | 0.003812% | True | True | 6.6507 | 6.0023 |
| 33,554,432 | 32 | 273/16777216 | 0.001832% | True | True | 7.0191 | 6.4106 |

## Eligible comparisons

Ratios are rival/multiply; above1 favors multiply. The24 nested views reuse measurements and are not independent significance trials. Production, original range experiments, cyclic, multiply and external ownership remain distinct. `retained_project` is an explicitly labeled minimum across production/original-range/cyclic controls.

| Rival class | Contract | Comparable views | Multiply wins / losses / ties | Minimum ratio | Maximum ratio |
|---|---|---:|---|---:|---:|
| external | lookup_ns | 10 | 3/7/0 | 0.7553 | 1.4026 |
| external | hash_lookup_ns | 10 | 4/6/0 | 0.8034 | 1.2904 |
| production | lookup_ns | 10 | 0/10/0 | 0.4474 | 0.9636 |
| production | hash_lookup_ns | 10 | 1/9/0 | 0.5772 | 1.0914 |
| range | lookup_ns | 10 | 2/8/0 | 0.7214 | 1.1017 |
| range | hash_lookup_ns | 10 | 2/8/0 | 0.7651 | 1.0859 |
| cyclic | lookup_ns | 8 | 2/6/0 | 0.9411 | 1.1110 |
| cyclic | hash_lookup_ns | 8 | 2/6/0 | 0.9598 | 1.1669 |
| retained_project | lookup_ns | 10 | 0/10/0 | 0.4474 | 0.9636 |
| retained_project | hash_lookup_ns | 10 | 0/10/0 | 0.5772 | 0.9924 |

## All24 budget/quality/contract views

Each cell gives the chosen measured allocation and median. A dagger flags earlier quality failure at this threshold: the FourSector records were held-out; Cyclic's older records were an accuracy pilot. Current seed42 qualification does not erase either history. Allocation selection is descriptive; cap32 admits every smaller eligible tested allocation.

| Keys | Contract | Cap | FPR ceiling | Multiply | External | Production | Original range | Cyclic | Best retained project / multiply |
|---:|---|---:|---:|---|---|---|---|---|---:|
| 65,536 | lookup_ns | 16 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;1.5409ns | FastFilterFixed16SingleV1;14bpk;1.1639ns | FastPatternBF;16bpk;0.6895ns | ByteSplitRangeExperiment;14bpk;1.1117ns | CyclicSplit64RangeExperiment;16bpk;1.4501ns | 0.4474 |
| 65,536 | lookup_ns | 16 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;1.5409ns | FastFilterFixed64;16bpk;2.1614ns | FourSectorBloomFilter†;16bpk;1.0728ns | Split64RangeExperiment;16bpk;1.6934ns | No qualifier | 0.6962 |
| 65,536 | lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 65,536 | lookup_ns | 32 | 1.00% | MultiplyCodeSplit64RangeExperiment;32bpk;1.5325ns | FastFilterFixed16;32bpk;1.1632ns | FastPatternBF;16bpk;0.6895ns | ByteSplitRangeExperiment;14bpk;1.1117ns | CyclicSplit64RangeExperiment;16bpk;1.4501ns | 0.4499 |
| 65,536 | lookup_ns | 32 | 0.10% | MultiplyCodeSplit64RangeExperiment;32bpk;1.5325ns | FastFilterFixed16;32bpk;1.1632ns | FastPatternBF;32bpk;0.7453ns | ByteSplitRangeExperiment;32bpk;1.1359ns | CyclicSplit64RangeExperiment;32bpk;1.4595ns | 0.4863 |
| 65,536 | lookup_ns | 32 | 0.01% | MultiplyCodeSplit64RangeExperiment;32bpk;1.5325ns | FastFilterSimdBlock;32bpk;1.2707ns | FourSectorBloomFilter;32bpk;1.1400ns | Split64RangeExperiment;32bpk;1.6883ns | CyclicSplit64RangeExperiment;32bpk;1.4595ns | 0.7439 |
| 65,536 | hash_lookup_ns | 16 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;2.1158ns | FastFilterFixed16SingleV1;14bpk;1.7022ns | FastPatternBF;16bpk;1.2211ns | ByteSplitRangeExperiment;14bpk;1.6702ns | CyclicSplit64RangeExperiment;16bpk;2.0338ns | 0.5772 |
| 65,536 | hash_lookup_ns | 16 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;2.1158ns | FastFilterFixed64;16bpk;2.7303ns | FourSectorBloomFilter†;16bpk;1.5932ns | Split64RangeExperiment;16bpk;2.2976ns | No qualifier | 0.7530 |
| 65,536 | hash_lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 65,536 | hash_lookup_ns | 32 | 1.00% | MultiplyCodeSplit64RangeExperiment;24bpk;2.1122ns | FastFilterFixed16;28bpk;1.6970ns | FastPatternBF;16bpk;1.2211ns | ByteSplitRangeExperiment;20bpk;1.6159ns | CyclicSplit64RangeExperiment;24bpk;2.0273ns | 0.5781 |
| 65,536 | hash_lookup_ns | 32 | 0.10% | MultiplyCodeSplit64RangeExperiment;24bpk;2.1122ns | FastFilterFixed16;28bpk;1.6970ns | FastPatternBF;32bpk;1.2885ns | ByteSplitRangeExperiment;28bpk;1.6571ns | CyclicSplit64RangeExperiment;24bpk;2.0273ns | 0.6101 |
| 65,536 | hash_lookup_ns | 32 | 0.01% | MultiplyCodeSplit64RangeExperiment;24bpk;2.1122ns | FastFilterSimdBlock;32bpk;1.8241ns | FourSectorBloomFilter;32bpk;1.6787ns | Split64RangeExperiment;28bpk;2.2681ns | CyclicSplit64RangeExperiment;32bpk;2.0412ns | 0.7948 |
| 33,554,432 | lookup_ns | 16 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;5.5412ns | Boost192Multi32K8;12bpk;4.8632ns | FastPatternBF;16bpk;4.3988ns | Split64RangeExperiment;12bpk;5.0141ns | CyclicSplit64RangeExperiment;16bpk;5.4409ns | 0.7938 |
| 33,554,432 | lookup_ns | 16 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;5.5412ns | Boost192Multi64K8;16bpk;5.8684ns | Split64BloomFilter;16bpk;4.9280ns | Split64RangeExperiment;16bpk;5.3910ns | No qualifier | 0.8893 |
| 33,554,432 | lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 33,554,432 | lookup_ns | 32 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;5.5412ns | Boost192Multi32K8;12bpk;4.8632ns | FastPatternBF;16bpk;4.3988ns | Split64RangeExperiment;12bpk;5.0141ns | CyclicSplit64RangeExperiment;16bpk;5.4409ns | 0.7938 |
| 33,554,432 | lookup_ns | 32 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;5.5412ns | Boost192Multi32K8;20bpk;5.4050ns | Split64BloomFilter;16bpk;4.9280ns | Split64RangeExperiment;16bpk;5.3910ns | CyclicSplit64RangeExperiment;24bpk;6.1560ns | 0.8893 |
| 33,554,432 | lookup_ns | 32 | 0.01% | MultiplyCodeSplit64RangeExperiment;24bpk;6.2548ns | Boost192Multi32K8;28bpk;6.2854ns | FastPatternBF;32bpk;6.0272ns | Split64RangeExperiment;24bpk;6.0887ns | CyclicSplit64RangeExperiment;28bpk;6.5400ns | 0.9636 |
| 33,554,432 | hash_lookup_ns | 16 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;4.7086ns | Boost192Multi32K8;12bpk;4.2161ns | Split64BloomFilter;16bpk;4.4060ns | Split64RangeExperiment;12bpk;4.0639ns | CyclicSplit64RangeExperiment;16bpk;4.6926ns | 0.8631 |
| 33,554,432 | hash_lookup_ns | 16 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;4.7086ns | Boost192Multi64K8;16bpk;5.4430ns | Split64BloomFilter;16bpk;4.4060ns | Split64RangeExperiment;16bpk;4.7006ns | No qualifier | 0.9357 |
| 33,554,432 | hash_lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 33,554,432 | hash_lookup_ns | 32 | 1.00% | MultiplyCodeSplit64RangeExperiment;16bpk;4.7086ns | Boost192Multi32K8;12bpk;4.2161ns | Split64BloomFilter;16bpk;4.4060ns | Split64RangeExperiment;12bpk;4.0639ns | CyclicSplit64RangeExperiment;16bpk;4.6926ns | 0.8631 |
| 33,554,432 | hash_lookup_ns | 32 | 0.10% | MultiplyCodeSplit64RangeExperiment;16bpk;4.7086ns | Boost192Multi32K8;20bpk;4.9794ns | Split64BloomFilter;16bpk;4.4060ns | Split64RangeExperiment;16bpk;4.7006ns | CyclicSplit64RangeExperiment;24bpk;5.4943ns | 0.9357 |
| 33,554,432 | hash_lookup_ns | 32 | 0.01% | MultiplyCodeSplit64RangeExperiment;24bpk;5.5302ns | Boost192Multi64K8;24bpk;5.8733ns | FastPatternBF;32bpk;6.0358ns | Split64RangeExperiment;24bpk;5.4879ns | CyclicSplit64RangeExperiment;28bpk;5.9796ns | 0.9924 |

## Known-failure exclusion sensitivity

The primary tables use current-seed quality and flag history. This separate descriptive sensitivity also excludes a configuration when any retained earlier upper endpoint fails the current ceiling. It does not pool counts, is not a preregistered superiority test, and has unequal historical coverage across families. All24 sensitivity views remain in history-aware-rankings.json; changed retained-project winners are shown below.

| Keys | Contract | Cap | FPR ceiling | Best remaining project | Multiply | Remaining project / multiply |
|---:|---|---:|---:|---|---|---:|
| 65,536 | lookup_ns | 16 | 0.10% | Split64BloomFilter;16bpk;1.6700ns | MultiplyCodeSplit64RangeExperiment;16bpk;1.5409ns | 1.0838 |
| 65,536 | hash_lookup_ns | 16 | 0.10% | Split64BloomFilter;16bpk;2.2494ns | MultiplyCodeSplit64RangeExperiment;16bpk;2.1158ns | 1.0632 |

This distinction matters at small cap16/0.1%: the primary FourSector16 winner has a known held-out quality failure. Excluding it allows the multiply candidate to lead the remaining measured project and external controls in this training view. Fresh fixed-rival confirmation is needed before accepting that advantage.


## Same-allocation controls

These direct pairs use the same current executable and exact bitmap size. They do not impose equal FPR; both confidence endpoints are retained. Missing old geometries are not invented or filled with older timings.

| Keys | Actual bpk | Contract | Control | Multiply ns | Control ns | Control / multiply |
|---:|---:|---|---|---:|---:|---:|
| 65,536 | 16 | lookup_ns | CyclicSplit64RangeExperiment | 1.5409 | 1.4501 | 0.9411 |
| 65,536 | 16 | hash_lookup_ns | CyclicSplit64RangeExperiment | 2.1158 | 2.0338 | 0.9613 |
| 65,536 | 16 | lookup_ns | Split64BloomFilter | 1.5409 | 1.6700 | 1.0838 |
| 65,536 | 16 | hash_lookup_ns | Split64BloomFilter | 2.1158 | 2.2494 | 1.0632 |
| 65,536 | 16 | lookup_ns | Split64RangeExperiment | 1.5409 | 1.6934 | 1.0989 |
| 65,536 | 16 | hash_lookup_ns | Split64RangeExperiment | 2.1158 | 2.2976 | 1.0859 |
| 65,536 | 24 | lookup_ns | CyclicSplit64RangeExperiment | 1.5351 | 1.4607 | 0.9515 |
| 65,536 | 24 | hash_lookup_ns | CyclicSplit64RangeExperiment | 2.1122 | 2.0273 | 0.9598 |
| 65,536 | 24 | lookup_ns | Split64RangeExperiment | 1.5351 | 1.6937 | 1.1033 |
| 65,536 | 24 | hash_lookup_ns | Split64RangeExperiment | 2.1122 | 2.2838 | 1.0813 |
| 65,536 | 28 | lookup_ns | Split64RangeExperiment | 1.5421 | 1.6988 | 1.1016 |
| 65,536 | 28 | hash_lookup_ns | Split64RangeExperiment | 2.1456 | 2.2681 | 1.0571 |
| 65,536 | 28 | lookup_ns | CyclicSplit64RangeExperiment | 1.5421 | 1.4627 | 0.9485 |
| 65,536 | 28 | hash_lookup_ns | CyclicSplit64RangeExperiment | 2.1456 | 2.0501 | 0.9555 |
| 65,536 | 32 | lookup_ns | Split64RangeExperiment | 1.5325 | 1.6883 | 1.1017 |
| 65,536 | 32 | hash_lookup_ns | Split64RangeExperiment | 2.1274 | 2.2803 | 1.0719 |
| 65,536 | 32 | lookup_ns | CyclicSplit64RangeExperiment | 1.5325 | 1.4595 | 0.9524 |
| 65,536 | 32 | hash_lookup_ns | CyclicSplit64RangeExperiment | 2.1274 | 2.0412 | 0.9595 |
| 65,536 | 32 | lookup_ns | Split64BloomFilter | 1.5325 | 1.6665 | 1.0874 |
| 65,536 | 32 | hash_lookup_ns | Split64BloomFilter | 2.1274 | 2.2677 | 1.0660 |
| 33,554,432 | 16 | lookup_ns | Split64BloomFilter | 5.5412 | 4.9280 | 0.8893 |
| 33,554,432 | 16 | hash_lookup_ns | Split64BloomFilter | 4.7086 | 4.4060 | 0.9357 |
| 33,554,432 | 16 | lookup_ns | Split64RangeExperiment | 5.5412 | 5.3910 | 0.9729 |
| 33,554,432 | 16 | hash_lookup_ns | Split64RangeExperiment | 4.7086 | 4.7006 | 0.9983 |
| 33,554,432 | 16 | lookup_ns | CyclicSplit64RangeExperiment | 5.5412 | 5.4409 | 0.9819 |
| 33,554,432 | 16 | hash_lookup_ns | CyclicSplit64RangeExperiment | 4.7086 | 4.6926 | 0.9966 |
| 33,554,432 | 24 | lookup_ns | CyclicSplit64RangeExperiment | 6.2548 | 6.1560 | 0.9842 |
| 33,554,432 | 24 | hash_lookup_ns | CyclicSplit64RangeExperiment | 5.5302 | 5.4943 | 0.9935 |
| 33,554,432 | 24 | lookup_ns | Split64RangeExperiment | 6.2548 | 6.0887 | 0.9734 |
| 33,554,432 | 24 | hash_lookup_ns | Split64RangeExperiment | 5.5302 | 5.4879 | 0.9924 |
| 33,554,432 | 28 | lookup_ns | CyclicSplit64RangeExperiment | 6.6507 | 6.5400 | 0.9834 |
| 33,554,432 | 28 | hash_lookup_ns | CyclicSplit64RangeExperiment | 6.0023 | 5.9796 | 0.9962 |
| 33,554,432 | 32 | lookup_ns | CyclicSplit64RangeExperiment | 7.0191 | 6.8994 | 0.9829 |
| 33,554,432 | 32 | hash_lookup_ns | CyclicSplit64RangeExperiment | 6.4106 | 6.3737 | 0.9942 |
| 33,554,432 | 32 | lookup_ns | Split64BloomFilter | 7.0191 | 6.5320 | 0.9306 |
| 33,554,432 | 32 | hash_lookup_ns | Split64BloomFilter | 6.4106 | 6.2584 | 0.9763 |

## Preserved quality history and limits

The six historical FourSector actual16 records and eight Cyclic pilot records are retained separately in prior-quality.json. They import counts/quality only, never old latency. Cyclic16 previously failed0.1% and Cyclic24 failed0.01% at both sizes. The older FourSector16 held-out upper-bound failures remain visible. These records are not pooled with current samples.

Known aliases collapse the70 current rows to64 mapping/size/seed quality records. Each pointwise two-sided95% Wilson endpoint has its own denominator; many-candidate selection does not provide simultaneous coverage. Different configurations can occupy different fixed sorted case processes; one shuffled seed does not balance pair order. Trial min/max are observations, not speed confidence intervals.

all-allocations.csv keeps all70 rows, actual bytes, both complete trial vectors/min/max and case/row positions. individual-comparisons.csv keeps840 allocation alternatives, including all failed/ineligible points; multiply-comparisons.csv keeps all96 candidate alternatives. All wins, losses and exact ties remain. Source/codegen changes, allocation placement, order and noise cannot be separated by this single training run. No production promotion or global-fastest claim follows.
