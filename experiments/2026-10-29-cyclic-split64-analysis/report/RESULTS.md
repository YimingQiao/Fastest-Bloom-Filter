# Cyclic Split64: fixed62 training comparison

All62 rows/13 cases passed frozen source/dependency/binary/commit checks, exact commands and raw-to-aggregate equality. The job-order oracle expands the frozen C++ registration macros, verifies the75-type planner registry, filters each case, advances the exact workload SplitMix draws and reconstructs every Fisher–Yates permutation.

The scope is one seed42 CPU3/socket1 executable, two key counts, batch4096,2^22 timed queries,50% intended hits,six balanced pure/common-hash repetitions and2^24 disjoint calibration negatives per mapping. Every bitmap is built once and fully validated outside query timing. Build times remain NaN; no construction-speed claim is made. CPU affinity does not impose explicit NUMA memory binding.

The shortlist retains54 previously selected configurations and adds eight prespecified cyclic geometries. This is not an all75-type speed comparison or held-out confirmation. Every fastest allocation below is a descriptive selection within the measured shortlist. Cap32 admits smaller tested allocations, including24-bpk rivals and28-bpk cyclic. No older-binary latency enters a ratio.

## All eight cyclic allocations

| Keys | Actual bpk | Wilson95 upper FPR | Pass0.1% | Pass0.01% | Prehashed ns | Common hash+query ns |
| ---: | ---: | ---: | --- | --- | ---: | ---: |
| 65536 | 16 | 0.132309% | False | False | 1.4624 | 1.9997 |
| 65536 | 24 | 0.016657% | True | False | 1.4571 | 2.0055 |
| 65536 | 28 | 0.007538% | True | True | 1.4536 | 1.9992 |
| 65536 | 32 | 0.004085% | True | True | 1.4502 | 2.0010 |
| 33554432 | 16 | 0.131367% | False | False | 5.2506 | 4.3580 |
| 33554432 | 24 | 0.016742% | True | False | 6.1406 | 5.4760 |
| 33554432 | 28 | 0.007532% | True | True | 6.5416 | 5.9095 |
| 33554432 | 32 | 0.003992% | True | True | 6.8133 | 6.2862 |

## Eligible cyclic versus retained rivals

Ratios are rival/cyclic; above1 favors cyclic. Counts are nested budget/quality views that reuse observations, not independent significance trials.

| Rival | Contract | Comparable views | Cyclic wins / losses / ties | Minimum ratio | Maximum ratio |
| --- | --- | ---: | --- | ---: | ---: |
| external | lookup_ns | 8 | 0/8/0 | 0.7793 | 0.9588 |
| external | hash_lookup_ns | 8 | 1/7/0 | 0.8099 | 1.0098 |
| production | lookup_ns | 8 | 0/8/0 | 0.4767 | 0.9133 |
| production | hash_lookup_ns | 8 | 1/7/0 | 0.6030 | 1.0162 |
| range | lookup_ns | 8 | 1/7/0 | 0.7551 | 1.1729 |
| range | hash_lookup_ns | 8 | 1/7/0 | 0.7987 | 1.1193 |

## All24 allocation/quality/contract views

Each cell gives filter, actual bpk and median ns. A dagger marks a configuration with a prior held-out quality failure at this threshold; a current seed42 pass does not erase it.

| Keys | Contract | Cap | FPR limit | Cyclic | External | Production | Range experiment | External/cyclic |
| ---: | --- | ---: | ---: | --- | --- | --- | --- | ---: |
| 65536 | lookup_ns | 16 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 1.4624ns | FastFilterFixed16SingleV1; 14bpk; 1.1396ns | FastPatternBF; 16bpk; 0.6971ns | ByteSplitRangeExperiment; 14bpk; 1.1042ns | 0.7793 |
| 65536 | lookup_ns | 16 | 0.10% | No qualifier | FastFilterFixed64; 16bpk; 2.1613ns | FourSectorBloomFilter†; 16bpk; 1.0716ns | Split64RangeExperiment; 16bpk; 1.6960ns | — |
| 65536 | lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 65536 | lookup_ns | 32 | 1.00% | CyclicSplit64RangeExperiment; 32bpk; 1.4502ns | FastFilterFixed16; 28bpk; 1.1386ns | FastPatternBF; 16bpk; 0.6971ns | ByteSplitRangeExperiment; 14bpk; 1.1042ns | 0.7852 |
| 65536 | lookup_ns | 32 | 0.10% | CyclicSplit64RangeExperiment; 32bpk; 1.4502ns | FastFilterFixed16; 28bpk; 1.1386ns | FastPatternBF; 32bpk; 0.7410ns | ByteSplitRangeExperiment; 32bpk; 1.1222ns | 0.7852 |
| 65536 | lookup_ns | 32 | 0.01% | CyclicSplit64RangeExperiment; 32bpk; 1.4502ns | FastFilterSimdBlock; 32bpk; 1.2639ns | FourSectorBloomFilter; 32bpk; 1.1319ns | Split64RangeExperiment; 32bpk; 1.7009ns | 0.8715 |
| 65536 | hash_lookup_ns | 16 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 1.9997ns | FastFilterFixed16SingleV1; 14bpk; 1.6195ns | FastPatternBF; 16bpk; 1.2059ns | ByteSplitRangeExperiment; 14bpk; 1.5972ns | 0.8099 |
| 65536 | hash_lookup_ns | 16 | 0.10% | No qualifier | FastFilterFixed64; 16bpk; 2.6873ns | FourSectorBloomFilter†; 16bpk; 1.5669ns | Split64RangeExperiment; 16bpk; 2.2451ns | — |
| 65536 | hash_lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 65536 | hash_lookup_ns | 32 | 1.00% | CyclicSplit64RangeExperiment; 28bpk; 1.9992ns | FastFilterFixed16SingleV1; 14bpk; 1.6195ns | FastPatternBF; 16bpk; 1.2059ns | ByteSplitRangeExperiment; 14bpk; 1.5972ns | 0.8100 |
| 65536 | hash_lookup_ns | 32 | 0.10% | CyclicSplit64RangeExperiment; 28bpk; 1.9992ns | FastFilterFixed16; 28bpk; 1.6528ns | FastPatternBF; 32bpk; 1.2561ns | ByteSplitRangeExperiment; 28bpk; 1.6289ns | 0.8267 |
| 65536 | hash_lookup_ns | 32 | 0.01% | CyclicSplit64RangeExperiment; 28bpk; 1.9992ns | FastFilterSimdBlock; 32bpk; 1.7925ns | FourSectorBloomFilter; 32bpk; 1.6307ns | Split64RangeExperiment; 28bpk; 2.2377ns | 0.8966 |
| 33554432 | lookup_ns | 16 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 5.2506ns | Boost192Multi32K8; 12bpk; 4.7771ns | FastPatternBF; 16bpk; 4.2161ns | Split64RangeExperiment; 12bpk; 4.9324ns | 0.9098 |
| 33554432 | lookup_ns | 16 | 0.10% | No qualifier | Boost192Multi64K8; 16bpk; 5.6490ns | Split64BloomFilter; 16bpk; 4.8785ns | Split64RangeExperiment; 16bpk; 5.2972ns | — |
| 33554432 | lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 33554432 | lookup_ns | 32 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 5.2506ns | Boost192Multi32K8; 12bpk; 4.7771ns | FastPatternBF; 16bpk; 4.2161ns | Split64RangeExperiment; 12bpk; 4.9324ns | 0.9098 |
| 33554432 | lookup_ns | 32 | 0.10% | CyclicSplit64RangeExperiment; 24bpk; 6.1406ns | Boost192Multi32K8; 20bpk; 5.4806ns | Split64BloomFilter; 16bpk; 4.8785ns | Split64RangeExperiment; 16bpk; 5.2972ns | 0.8925 |
| 33554432 | lookup_ns | 32 | 0.01% | CyclicSplit64RangeExperiment; 28bpk; 6.5416ns | Boost192Multi32K8; 28bpk; 6.2721ns | FastPatternBF; 32bpk; 5.9745ns | Split64RangeExperiment; 24bpk; 6.0910ns | 0.9588 |
| 33554432 | hash_lookup_ns | 16 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 4.3580ns | Boost192Multi32K8; 12bpk; 4.1574ns | FastPatternBF; 16bpk; 4.1604ns | Split64RangeExperiment; 12bpk; 4.0172ns | 0.9540 |
| 33554432 | hash_lookup_ns | 16 | 0.10% | No qualifier | Boost192Multi64K8; 16bpk; 4.6525ns | Split64BloomFilter; 16bpk; 4.2754ns | Split64RangeExperiment; 16bpk; 4.4029ns | — |
| 33554432 | hash_lookup_ns | 16 | 0.01% | No qualifier | No qualifier | No qualifier | No qualifier | — |
| 33554432 | hash_lookup_ns | 32 | 1.00% | CyclicSplit64RangeExperiment; 16bpk; 4.3580ns | Boost192Multi32K8; 12bpk; 4.1574ns | FastPatternBF; 16bpk; 4.1604ns | Split64RangeExperiment; 12bpk; 4.0172ns | 0.9540 |
| 33554432 | hash_lookup_ns | 32 | 0.10% | CyclicSplit64RangeExperiment; 24bpk; 5.4760ns | Boost192Multi64K8; 16bpk; 4.6525ns | Split64BloomFilter; 16bpk; 4.2754ns | Split64RangeExperiment; 16bpk; 4.4029ns | 0.8496 |
| 33554432 | hash_lookup_ns | 32 | 0.01% | CyclicSplit64RangeExperiment; 28bpk; 5.9095ns | Boost192Multi64K8; 24bpk; 5.9674ns | FastPatternBF; 32bpk; 6.0050ns | Split64RangeExperiment; 24bpk; 5.4769ns | 1.0098 |

## Preserved earlier quality evidence

Only six FourSector actual16-bpk quality records are imported from the previous three-seed confirmation; no latency column is imported. Each old record keeps its separate confidence bound and never adds negatives to this training screen.

| Keys | Earlier seed | False positives / negatives | Wilson95 upper FPR | Pass0.1% |
| ---: | ---: | --- | ---: | --- |
| 65536 | 7562001474399208876 | 16542/16777216 | 0.100111% | False |
| 33554432 | 7562001474399208876 | 16569/16777216 | 0.100273% | False |
| 65536 | 3054562362472030614 | 16422/16777216 | 0.099391% | True |
| 33554432 | 3054562362472030614 | 16386/16777216 | 0.099174% | True |
| 65536 | 6571923779321589834 | 16163/16777216 | 0.097835% | True |
| 33554432 | 6571923779321589834 | 16391/16777216 | 0.099204% | True |

## Limits and retained evidence

Known calibration aliases collapse to56 records. No counts are pooled across mappings, sizes, seeds or earlier runs. Each quality gate uses the pointwise two-sided95% Wilson upper endpoint; selection across many candidates does not imply simultaneous coverage.

Filter order is randomized within each selected case and verified exactly, but one seed does not balance pair order. Cases execute in sorted key-count/budget groups, so different allocations can be measured in different processes and fixed case positions. Six alternating query phases balance pure/common-hash order within each filter, not filter or case order. Observed trial min/max are retained and are not speed confidence intervals.

all-allocations.csv retains all62 configurations, actual bytes, quality, both trial vectors, min/max and exact case/row positions. individual-comparisons.csv retains744 individual allocation alternatives, including every failed/ineligible configuration. cyclic-comparisons.csv retains all96 cyclic alternatives and pure/hash losses. rankings.json keeps production, range experiments, cyclic and external ownership separate. No candidate is promoted by this training report.
