# BlowChoc held-out accuracy results

All 96 prespecified rows completed without throughput timing. Every fresh build passed all inserted-key checks; all three query/input paths passed full dense-output checks. All64 actual-size/hash BlowChoc parameter sets passed independent complete-bitmap/answer oracles and reconstruction after later factories replaced module hash globals.

Each cell below is the **worst per-case Wilson95% upper bound in percent** over the paired seeds(input31991,construction503) and(input97157,construction1709), each using16,777,216 negatives. Counts from different construction hash functions are never pooled into a single fixed-filter interval. These are nominal per-case bounds, not simultaneous confidence or a performance ranking. Native4 ignore construction seed and vary only input seed.

| Filter | 64K,16bpk | 1M,16bpk | 64K,32bpk | 1M,32bpk |
|---|---:|---:|---:|---:|
| FastPatternBF | 0.209343% | 0.206689% | 0.009796% | 0.009625% |
| FourSectorBloomFilter | 0.099300% | 0.099703% | 0.002034% | 0.002454% |
| Split64BloomFilter | 0.094237% | 0.092723% | 0.001920% | 0.001971% |
| ByteSplitBloomFilter | 0.552888% | 0.557439% | 0.058268% | 0.059026% |
| BlowChocC1K8Random | 0.097090% | 0.090584% | 0.001870% | 0.001832% |
| BlowChocC1K8Distinct | 0.092483% | 0.087231% | 0.001769% | 0.001788% |
| BlowChocC1K14Random | 0.132597% | 0.122402% | 0.000823% | 0.000646% |
| BlowChocC1K14Distinct | 0.130359% | 0.124851% | 0.000633% | 0.000758% |
| BlowChocC2K8Random | 0.072443% | 0.070008% | 0.001235% | 0.001337% |
| BlowChocC2K8Distinct | 0.068221% | 0.065797% | 0.001017% | 0.001081% |
| BlowChocC2K14Random | 0.051933% | 0.050656% | 0.000199% | 0.000125% |
| BlowChocC2K14Distinct | 0.050770% | 0.049234% | 0.000125% | 0.000140% |

`accuracy.csv` retains all96 raw FP counts, per-case confidence bounds and threshold flags. `worst-case.csv` records the seed responsible for each worst bound. `results/` retains all64 construction hash sets, input digests, runtime/CPU details and complete metadata. The four unique held-out negative streams are pairwise disjoint and disjoint from all held-out inserted/query ranges and seed42 screen ranges; repeated budgets do not add independent samples. All configs have identical backing-payload caps within a case; BlowChoc's logical bitmap is448B smaller and its16B(K8)/28B(K14) positions buffer is separately reported as scratch.

Elapsed correctness/calibration runtime was 379.7s; that wall time is **not** a filter throughput result. CPU3/socket1 held one exclusive flock for the full matrix. Protocol, bridge sources and native binary were unchanged. Native controls remain the frozen `b437791` snapshot.
