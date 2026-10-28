# Cyclic mask accuracy: fewer instructions require more space

All sixteen fixed accuracy rows completed with unchanged committed sources and binaries. Full inserted-key checks found no false negatives. There are no timing measurements. The reference is unchanged range-addressed Split64; both filters use exactly the same unique inserted and disjoint negative streams.

The cyclic mask fails two intended equal-space quality targets: at16 bpk its Wilson upper bound exceeds0.1%, and at24 bpk it exceeds0.01%, at both sizes. The reference passes both targets in this pilot. At28 and32 bpk the cyclic candidate passes0.01%; that is only a potential configuration for a later same-cap external comparison, not a speed result.

| Keys | Actual bpk | Filter | False positives / 16,777,216 | Observed FPR | Wilson95 upper |
| ---: | ---: | --- | ---: | ---: | ---: |
| 65536 | 16 | Split64Range | 15112 | 0.090075% | 0.091521% |
| 65536 | 16 | CyclicSplit64Range | 21745 | 0.129610% | 0.131343% |
| 65536 | 24 | Split64Range | 1566 | 0.009334% | 0.009808% |
| 65536 | 24 | CyclicSplit64Range | 2704 | 0.016117% | 0.016736% |
| 65536 | 28 | Split64Range | 649 | 0.003868% | 0.004178% |
| 65536 | 28 | CyclicSplit64Range | 1210 | 0.007212% | 0.007630% |
| 65536 | 32 | Split64Range | 318 | 0.001895% | 0.002116% |
| 65536 | 32 | CyclicSplit64Range | 623 | 0.003713% | 0.004017% |
| 33554432 | 16 | Split64Range | 15167 | 0.090402% | 0.091852% |
| 33554432 | 16 | CyclicSplit64Range | 21828 | 0.130105% | 0.131841% |
| 33554432 | 24 | Split64Range | 1529 | 0.009114% | 0.009582% |
| 33554432 | 24 | CyclicSplit64Range | 2733 | 0.016290% | 0.016912% |
| 33554432 | 28 | Split64Range | 654 | 0.003898% | 0.004209% |
| 33554432 | 28 | CyclicSplit64Range | 1217 | 0.007254% | 0.007673% |
| 33554432 | 32 | Split64Range | 262 | 0.001562% | 0.001763% |
| 33554432 | 32 | CyclicSplit64Range | 625 | 0.003725% | 0.004029% |

The position correlations have a material cost: the observed false-positive counts are about1.44–2.39 times the reference at equal bytes in these cases. Marginally uniform positions and a shorter SIMD sequence do not establish an equal-quality improvement. Retain all rows and the unchanged mask; do not present the24-bpk candidate as eligible for the strict0.01% band.

Seed42, n=2^16/2^25, exact16/24/28/32-bpk backing, batch4096 insertion/query and2^24 absent probes per configuration were fixed before calibration. The common64 hash is bijective over u64; counter domains [0,n) and[n+q,n+2q) are disjoint before the same XOR salt and hash. Negative streams are reused between configurations at the same n; no configuration, API or seed counts are pooled. Wilson bounds are pointwise, not simultaneous confidence guarantees over this grid.

Source/preflight commit: `d97c0719d1245f493a1f89fc78698411fd48adfb`. The complete operation held socket0 flock with CPU2-only affinity. Parent copies, all frozen inputs, all twelve binaries and every committed archive blob were checked before and after calibration. `metadata.json`, `results.csv` and `quality.json` retain the complete results; the source-only initial README and preflight gate remain historical records.
