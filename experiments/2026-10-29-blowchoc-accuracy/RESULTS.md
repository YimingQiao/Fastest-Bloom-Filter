# BlowChoc accuracy screen results

All 48 prespecified rows completed without throughput timing. Every fresh build passed all inserted-key checks; all three query/input paths passed full dense-output checks. All 32 actual-size BlowChoc parameter sets passed independent complete-bitmap/answer oracles and reconstruction after later factories replaced module hash globals.

Each cell below is the independent-calibration Wilson95% **upper bound in percent**, using16,777,216 negatives. No samples are pooled. Input seed42 and construction seed113 are one screening combination; these are nominal per-configuration intervals, not simultaneous confidence or held-out confirmation. Fresh input **and** construction seeds remain necessary before performance selection.

| Filter | 64K,16bpk | 1M,16bpk | 64K,32bpk | 1M,32bpk |
|---|---:|---:|---:|---:|
| FastPatternBF | 0.206317% | 0.206449% | 0.009362% | 0.009234% |
| FourSectorBloomFilter | 0.099252% | 0.099210% | 0.002166% | 0.002160% |
| Split64BloomFilter | 0.092092% | 0.091996% | 0.001914% | 0.001807% |
| ByteSplitBloomFilter | 0.556446% | 0.548996% | 0.057744% | 0.056600% |
| BlowChocC1K8Random | 0.089617% | 0.091347% | 0.001813% | 0.001813% |
| BlowChocC1K8Distinct | 0.090230% | 0.088265% | 0.001668% | 0.001661% |
| BlowChocC1K14Random | 0.118585% | 0.123086% | 0.000607% | 0.000653% |
| BlowChocC1K14Distinct | 0.121226% | 0.121544% | 0.000520% | 0.000567% |
| BlowChocC2K8Random | 0.070868% | 0.069791% | 0.001100% | 0.001190% |
| BlowChocC2K8Distinct | 0.067860% | 0.066555% | 0.001113% | 0.001062% |
| BlowChocC2K14Random | 0.053415% | 0.050873% | 0.000155% | 0.000170% |
| BlowChocC2K14Distinct | 0.048927% | 0.048818% | 0.000133% | 0.000117% |

`accuracy.csv` retains every raw FP count, confidence bound and threshold flag. `results/` retains the actual construction hashes, input digests, disjoint raw-key intervals, runtime/CPU details and complete metadata. All configs have identical backing-payload caps within a case; BlowChoc's logical bitmap is448B smaller and its16B(K8)/28B(K14) positions buffer is separately charged as scratch.

Elapsed correctness/calibration runtime was 187.4s; that wall time is **not** a filter throughput result. CPU3/socket1 held one exclusive flock for the full matrix. Protocol, bridge sources and native binary were unchanged. Native controls remain the frozen `b437791` snapshot.
