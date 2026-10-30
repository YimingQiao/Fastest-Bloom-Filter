# Fixed multiply-code accuracy pilot

The candidate passes the pointwise0.1% gate at actual16bpk and0.01% at actual24/28/32bpk for both tested sizes on seed42. All16 old Split64Range/Cyclic rows reproduce their pinned counts and dense checksums exactly. The fixed multiplier was not changed. No throughput measurements were made.

Each row has2^24 unique disjoint negatives. The table retains every row; Wilson bounds are pointwise95% intervals, not a simultaneous guarantee. Old controls repeat an existing stream and are reproduction checks, not extra independent samples. The eight candidate rows are separate geometry/size observations and are not pooled.

| Keys | Actual bpk | Filter | FP count | FPR % | Wilson upper % | ≤0.1% | ≤0.01% |
|---:|---:|---|---:|---:|---:|:---:|:---:|
| 65,536 | 16 | Split64Range | 15112 | 0.090075 | 0.091521 | yes | no |
| 65,536 | 16 | CyclicSplit64Range | 21745 | 0.129610 | 0.131343 | no | no |
| 65,536 | 16 | MultiplyCodeSplit64Range | 15075 | 0.089854 | 0.091299 | yes | no |
| 65,536 | 24 | Split64Range | 1566 | 0.009334 | 0.009808 | yes | yes |
| 65,536 | 24 | CyclicSplit64Range | 2704 | 0.016117 | 0.016736 | yes | no |
| 65,536 | 24 | MultiplyCodeSplit64Range | 1566 | 0.009334 | 0.009808 | yes | yes |
| 65,536 | 28 | Split64Range | 649 | 0.003868 | 0.004178 | yes | yes |
| 65,536 | 28 | CyclicSplit64Range | 1210 | 0.007212 | 0.007630 | yes | yes |
| 65,536 | 28 | MultiplyCodeSplit64Range | 644 | 0.003839 | 0.004147 | yes | yes |
| 65,536 | 32 | Split64Range | 318 | 0.001895 | 0.002116 | yes | yes |
| 65,536 | 32 | CyclicSplit64Range | 623 | 0.003713 | 0.004017 | yes | yes |
| 65,536 | 32 | MultiplyCodeSplit64Range | 282 | 0.001681 | 0.001889 | yes | yes |
| 33,554,432 | 16 | Split64Range | 15167 | 0.090402 | 0.091852 | yes | no |
| 33,554,432 | 16 | CyclicSplit64Range | 21828 | 0.130105 | 0.131841 | no | no |
| 33,554,432 | 16 | MultiplyCodeSplit64Range | 15309 | 0.091249 | 0.092705 | yes | no |
| 33,554,432 | 24 | Split64Range | 1529 | 0.009114 | 0.009582 | yes | yes |
| 33,554,432 | 24 | CyclicSplit64Range | 2733 | 0.016290 | 0.016912 | yes | no |
| 33,554,432 | 24 | MultiplyCodeSplit64Range | 1526 | 0.009096 | 0.009564 | yes | yes |
| 33,554,432 | 28 | Split64Range | 654 | 0.003898 | 0.004209 | yes | yes |
| 33,554,432 | 28 | CyclicSplit64Range | 1217 | 0.007254 | 0.007673 | yes | yes |
| 33,554,432 | 28 | MultiplyCodeSplit64Range | 624 | 0.003719 | 0.004023 | yes | yes |
| 33,554,432 | 32 | Split64Range | 262 | 0.001562 | 0.001763 | yes | yes |
| 33,554,432 | 32 | CyclicSplit64Range | 625 | 0.003725 | 0.004029 | yes | yes |
| 33,554,432 | 32 | MultiplyCodeSplit64Range | 311 | 0.001854 | 0.002071 | yes | yes |

The candidate has both lower and higher FP counts than the original Split64Range, depending on geometry. This pilot does not establish identical mask distributions or statistically significant quality superiority. The24bpk small-size upper endpoint is0.009808%, close to0.01%; fresh fixed-seed confirmation is needed before treating that threshold as robust. Neither the quality gate nor the shorter compiled instruction sequence proves a speed benefit.

Source and binary were frozen at commit`079a562951c99930ec1e40d58e45bbe372b867cd` before data. Run `python3 experiments/2026-10-29-multiply-code-split64-analysis/summarize.py` to verify the committed source/binary anchors, raw output digest, all24 row contracts, all16 reproduced controls and saved quality endpoints before regenerating this report.
