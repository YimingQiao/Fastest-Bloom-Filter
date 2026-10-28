# Split64 BITALG/KTEST internal training screen

All 24 workloads/144 rows completed. Every Split64 policy matches original bitmap bytes, output checksum and false-positive count in every workload. Each of 24 filter/size/allocation groups also matches those fields across all six batches. Frozen inputs/binaries were verified before and after.

This is seed42, hit50, q2^22, five repetitions, CPU3/Clang, with all construction inputs and no independent calibration. Query-only equivalence is established by the independent oracle and exact unchanged bitmap. FastPattern remains a separate context row; it is not an accuracy-equivalent Split64 control. No cross-compiler/socket/API ranking is made.

All ratios below are candidate/original latency; lower is faster. Every case and both metrics are retained. Aggregate means weight test cases equally and are descriptive, not confidence bounds.

| Policy | Metric | Geomean ratio | Faster /24 | Slower /24 | Minimum | Maximum |
|---|---|---:|---:|---:|---:|---:|
| Split64BitShuffleHybrid | lookup_ns | 1.0717 | 0 | 24 | 1.0119 | 1.1533 |
| Split64BitShuffleHybrid | hash_lookup_ns | 1.0605 | 2 | 22 | 0.9152 | 1.1816 |
| Split64BitShuffleHybridKtest | lookup_ns | 1.0175 | 2 | 22 | 0.9756 | 1.0724 |
| Split64BitShuffleHybridKtest | hash_lookup_ns | 1.0160 | 7 | 17 | 0.9755 | 1.1013 |
| Split64BitShuffleNarrow | lookup_ns | 1.0852 | 0 | 24 | 1.0096 | 1.1558 |
| Split64BitShuffleNarrow | hash_lookup_ns | 1.0692 | 2 | 22 | 0.9491 | 1.1859 |
| Split64BitShuffleWide | lookup_ns | 1.0789 | 2 | 22 | 0.9733 | 1.2811 |
| Split64BitShuffleWide | hash_lookup_ns | 1.0640 | 5 | 19 | 0.9647 | 1.1861 |

## lookup_ns

| Keys | Actual bpk | Batch | Original ns | V1 hybrid | V1 narrow | V1 wide | Hybrid KTEST |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 65,536 | 16 | 1 | 2.6420 | 1.1444 | 1.1471 | 1.2766 | 1.0443 |
| 65,536 | 16 | 3 | 1.9918 | 1.0674 | 1.0897 | 1.0656 | 1.0020 |
| 65,536 | 16 | 4 | 1.7766 | 1.0814 | 1.1054 | 1.0957 | 1.0065 |
| 65,536 | 16 | 8 | 1.6522 | 1.0372 | 1.1112 | 1.0451 | 1.0021 |
| 65,536 | 16 | 31 | 1.5875 | 1.0574 | 1.0574 | 1.0258 | 1.0267 |
| 65,536 | 16 | 4096 | 1.6484 | 1.0337 | 1.0352 | 0.9733 | 1.0130 |
| 65,536 | 32 | 1 | 2.6370 | 1.1477 | 1.1480 | 1.2811 | 1.0724 |
| 65,536 | 32 | 3 | 1.9916 | 1.0662 | 1.0915 | 1.0692 | 1.0035 |
| 65,536 | 32 | 4 | 1.7780 | 1.0868 | 1.1558 | 1.1031 | 1.0111 |
| 65,536 | 32 | 8 | 1.6589 | 1.0401 | 1.1111 | 1.0471 | 1.0041 |
| 65,536 | 32 | 31 | 1.5878 | 1.1029 | 1.1080 | 1.0298 | 1.0274 |
| 65,536 | 32 | 4096 | 1.6497 | 1.0343 | 1.0334 | 0.9743 | 1.0137 |
| 33,554,432 | 16 | 1 | 7.0214 | 1.1194 | 1.1105 | 1.1153 | 1.0516 |
| 33,554,432 | 16 | 3 | 6.4817 | 1.0305 | 1.0385 | 1.0016 | 0.9756 |
| 33,554,432 | 16 | 4 | 6.3860 | 1.0126 | 1.0543 | 1.0212 | 1.0151 |
| 33,554,432 | 16 | 8 | 6.1184 | 1.0857 | 1.1198 | 1.1055 | 1.0428 |
| 33,554,432 | 16 | 31 | 6.0100 | 1.1267 | 1.1298 | 1.2108 | 1.0048 |
| 33,554,432 | 16 | 4096 | 4.7360 | 1.0252 | 1.0162 | 1.0269 | 1.0026 |
| 33,554,432 | 32 | 1 | 11.4403 | 1.1533 | 1.1210 | 1.1155 | 1.0464 |
| 33,554,432 | 32 | 3 | 9.4858 | 1.0674 | 1.0533 | 1.1002 | 1.0227 |
| 33,554,432 | 32 | 4 | 9.3134 | 1.0462 | 1.0470 | 1.0515 | 1.0284 |
| 33,554,432 | 32 | 8 | 8.6317 | 1.0726 | 1.0786 | 1.0713 | 1.0128 |
| 33,554,432 | 32 | 31 | 8.1234 | 1.0896 | 1.0924 | 1.1365 | 1.0069 |
| 33,554,432 | 32 | 4096 | 6.2492 | 1.0119 | 1.0096 | 1.0169 | 0.9883 |

## hash_lookup_ns

| Keys | Actual bpk | Batch | Original ns | V1 hybrid | V1 narrow | V1 wide | Hybrid KTEST |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 65,536 | 16 | 1 | 4.5165 | 1.1079 | 1.1085 | 1.1042 | 1.0384 |
| 65,536 | 16 | 3 | 3.0644 | 1.1092 | 1.1235 | 1.1053 | 1.0397 |
| 65,536 | 16 | 4 | 3.8691 | 1.0659 | 1.0931 | 1.0637 | 1.0089 |
| 65,536 | 16 | 8 | 3.3484 | 1.1444 | 1.1767 | 1.1351 | 0.9955 |
| 65,536 | 16 | 31 | 2.1097 | 1.1804 | 1.1797 | 1.1861 | 1.1013 |
| 65,536 | 16 | 4096 | 2.1122 | 1.0136 | 1.0125 | 0.9914 | 1.0297 |
| 65,536 | 32 | 1 | 4.5310 | 1.1052 | 1.1059 | 1.1010 | 1.0372 |
| 65,536 | 32 | 3 | 3.0823 | 1.1114 | 1.1176 | 1.1048 | 1.0407 |
| 65,536 | 32 | 4 | 3.8682 | 1.0679 | 1.1061 | 1.0661 | 1.0085 |
| 65,536 | 32 | 8 | 3.3423 | 1.1492 | 1.1859 | 1.1384 | 1.0001 |
| 65,536 | 32 | 31 | 2.1132 | 1.1816 | 1.1807 | 1.1859 | 1.0999 |
| 65,536 | 32 | 4096 | 2.1246 | 1.0089 | 1.0046 | 0.9866 | 1.0105 |
| 33,554,432 | 16 | 1 | 11.3707 | 1.0564 | 1.0552 | 1.0819 | 1.0083 |
| 33,554,432 | 16 | 3 | 8.8963 | 1.0134 | 1.0132 | 0.9830 | 0.9755 |
| 33,554,432 | 16 | 4 | 6.9919 | 1.0515 | 1.0758 | 1.0626 | 0.9939 |
| 33,554,432 | 16 | 8 | 8.0251 | 0.9152 | 0.9491 | 0.9647 | 0.9916 |
| 33,554,432 | 16 | 31 | 5.7992 | 1.0358 | 1.0473 | 1.0668 | 0.9969 |
| 33,554,432 | 16 | 4096 | 4.1815 | 1.0074 | 1.0052 | 1.0235 | 0.9975 |
| 33,554,432 | 32 | 1 | 19.1673 | 1.0331 | 1.0293 | 1.0250 | 1.0031 |
| 33,554,432 | 32 | 3 | 14.6975 | 1.0364 | 1.0355 | 1.0319 | 1.0097 |
| 33,554,432 | 32 | 4 | 10.6340 | 1.0538 | 1.0571 | 1.0716 | 1.0077 |
| 33,554,432 | 32 | 8 | 10.9961 | 0.9771 | 0.9782 | 0.9898 | 1.0004 |
| 33,554,432 | 32 | 31 | 8.1527 | 1.0624 | 1.0626 | 1.0934 | 1.0085 |
| 33,554,432 | 32 | 4096 | 5.9187 | 1.0083 | 1.0063 | 1.0148 | 0.9898 |

`results.csv` contains all original timings, ranges, allocations and query counts. `comparisons.csv` includes original self-controls; `losses.csv` includes every ratio greater than one without suppressing small differences. `report.json` retains extrema and their workloads. No production promotion or fresh-seed conclusion follows from this initial screen.
