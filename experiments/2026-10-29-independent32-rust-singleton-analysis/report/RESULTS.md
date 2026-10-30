# Independent32 singleton shortcut: CPU2 training screen

This compares the exact four-line public lookup shortcut with the unchanged Independent32 implementation and ten retained controls in one executable. It is a seed42 training screen, not fresh-seed confirmation or a global-fastest claim.

All192 rows from16 workloads pass full-output, clone, phase, trial-vector, quality and cross-batch checks. A separate sidecar reconstructs every row permutation from the frozen Rust producer's RNG consumption and source registration order. Source/dependency/binary hashes and committed blobs are checked before interpreting measurements.

The four contracts remain separate: generic batch prehashed; generic batch with staged common hash; whole-array visible public singleton prehashed; and visible singleton with fused common hash. Every visible loop still processes the whole query array at every batch tag. Measurements describe independent-query throughput, not dependent lookup latency.

CPU2/socket0, one complete inherited exclusive flock lease, n=2^16/2^25, actual16/32bpk, batch1/2/31/4096,2^20 timed queries,50% hits,four balanced query repetitions,2^20 independent calibration negatives,whole-input insertion. CPU affinity does not impose explicit NUMA memory binding. No cross-CPU or earlier-binary timing ratios are used.

Filter row order is randomized but this one-seed screen is not pair-order balanced: the shortcut appears at zero-based position1 for n=2^16 and0 for n=2^25, while unchanged Independent32 is position9 in both. Four-mode phase balance does not remove that between-filter order limitation. A confirmation would need fresh seeds and retained/reversed pair-order strata.

The source change preserves mapping, allocation and insertion, but compiled bulk code is not identical: the new public lookup saves six callee-saved registers rather than one, and its portable scalar remainder calls contains_scalar. These are part of the candidate being measured. The prior public visible API is unchanged in source; placement/code generation can still change its timing.

## Exact before/after comparison

Ratios are unchanged Independent32 / shortcut; above1 favors the shortcut. Each row below summarizes the four size/allocation conditions descriptively; min/max are the paired median-ratio range, not a confidence interval.

| Batch | Contract | Shortcut wins / losses / ties | Geometric mean ratio | Minimum | Maximum |
| ---: | --- | --- | ---: | ---: | ---: |
| 1 | lookup_ns | 1/3/0 | 0.9975 | 0.9758 | 1.0206 |
| 1 | hash_lookup_ns | 2/2/0 | 1.0435 | 0.9577 | 1.1621 |
| 1 | inline_lookup_ns | 3/1/0 | 1.0141 | 0.9968 | 1.0425 |
| 1 | inline_hash_lookup_ns | 2/2/0 | 1.0264 | 0.9983 | 1.1099 |
| 2 | lookup_ns | 0/4/0 | 0.9234 | 0.9099 | 0.9397 |
| 2 | hash_lookup_ns | 0/4/0 | 0.9620 | 0.9274 | 0.9962 |
| 2 | inline_lookup_ns | 2/2/0 | 0.9923 | 0.9467 | 1.0251 |
| 2 | inline_hash_lookup_ns | 3/1/0 | 1.0086 | 0.9992 | 1.0293 |
| 31 | lookup_ns | 0/4/0 | 0.9681 | 0.8995 | 0.9999 |
| 31 | hash_lookup_ns | 0/4/0 | 0.9788 | 0.9386 | 0.9992 |
| 31 | inline_lookup_ns | 2/2/0 | 0.9837 | 0.9504 | 1.0030 |
| 31 | inline_hash_lookup_ns | 2/2/0 | 0.9869 | 0.9612 | 1.0004 |
| 4096 | lookup_ns | 2/2/0 | 1.0285 | 0.9983 | 1.0868 |
| 4096 | hash_lookup_ns | 4/0/0 | 1.0175 | 1.0045 | 1.0427 |
| 4096 | inline_lookup_ns | 4/0/0 | 1.0219 | 1.0001 | 1.0537 |
| 4096 | inline_hash_lookup_ns | 1/3/0 | 1.0163 | 0.9941 | 1.0757 |

All64 exact shortcut/before comparisons follow, including visible and larger-batch losses. Each underlying trial vector and observed min/max remains in controlled-ratios.csv.

| Keys | Actual bpk | Batch | Contract | Before ns | Shortcut ns | Before / shortcut |
| ---: | ---: | ---: | --- | ---: | ---: | ---: |
| 65536 | 16 | 1 | hash_lookup_ns | 6.2349 | 6.5105 | 0.9577 |
| 65536 | 16 | 1 | inline_hash_lookup_ns | 1.7436 | 1.7466 | 0.9983 |
| 65536 | 16 | 1 | inline_lookup_ns | 1.2962 | 1.3004 | 0.9968 |
| 65536 | 16 | 1 | lookup_ns | 3.8922 | 3.9043 | 0.9969 |
| 65536 | 16 | 2 | hash_lookup_ns | 4.0846 | 4.4046 | 0.9274 |
| 65536 | 16 | 2 | inline_hash_lookup_ns | 1.7444 | 1.7458 | 0.9992 |
| 65536 | 16 | 2 | inline_lookup_ns | 1.2963 | 1.2975 | 0.9990 |
| 65536 | 16 | 2 | lookup_ns | 2.5962 | 2.7628 | 0.9397 |
| 65536 | 16 | 31 | hash_lookup_ns | 1.7292 | 1.7309 | 0.9990 |
| 65536 | 16 | 31 | inline_hash_lookup_ns | 1.7457 | 1.7453 | 1.0002 |
| 65536 | 16 | 31 | inline_lookup_ns | 1.2998 | 1.2959 | 1.0030 |
| 65536 | 16 | 31 | lookup_ns | 1.2969 | 1.2970 | 0.9999 |
| 65536 | 16 | 4096 | hash_lookup_ns | 2.0725 | 2.0507 | 1.0106 |
| 65536 | 16 | 4096 | inline_hash_lookup_ns | 1.7442 | 1.7452 | 0.9994 |
| 65536 | 16 | 4096 | inline_lookup_ns | 1.2963 | 1.2960 | 1.0003 |
| 65536 | 16 | 4096 | lookup_ns | 1.2994 | 1.3011 | 0.9987 |
| 65536 | 32 | 1 | hash_lookup_ns | 6.2700 | 6.5240 | 0.9611 |
| 65536 | 32 | 1 | inline_hash_lookup_ns | 1.7536 | 1.7543 | 0.9996 |
| 65536 | 32 | 1 | inline_lookup_ns | 1.2990 | 1.2985 | 1.0004 |
| 65536 | 32 | 1 | lookup_ns | 3.9008 | 3.9122 | 0.9971 |
| 65536 | 32 | 2 | hash_lookup_ns | 4.1086 | 4.4144 | 0.9307 |
| 65536 | 32 | 2 | inline_hash_lookup_ns | 1.7570 | 1.7541 | 1.0016 |
| 65536 | 32 | 2 | inline_lookup_ns | 1.2987 | 1.2987 | 1.0000 |
| 65536 | 32 | 2 | lookup_ns | 2.5613 | 2.7678 | 0.9254 |
| 65536 | 32 | 31 | hash_lookup_ns | 1.7302 | 1.7316 | 0.9992 |
| 65536 | 32 | 31 | inline_hash_lookup_ns | 1.7564 | 1.7556 | 1.0004 |
| 65536 | 32 | 31 | inline_lookup_ns | 1.3004 | 1.2985 | 1.0015 |
| 65536 | 32 | 31 | lookup_ns | 1.2999 | 1.3030 | 0.9977 |
| 65536 | 32 | 4096 | hash_lookup_ns | 2.1086 | 2.0826 | 1.0125 |
| 65536 | 32 | 4096 | inline_hash_lookup_ns | 1.7548 | 1.7575 | 0.9984 |
| 65536 | 32 | 4096 | inline_lookup_ns | 1.2986 | 1.2985 | 1.0001 |
| 65536 | 32 | 4096 | lookup_ns | 1.3020 | 1.3042 | 0.9983 |
| 33554432 | 16 | 1 | hash_lookup_ns | 14.5575 | 13.1309 | 1.1086 |
| 33554432 | 16 | 1 | inline_hash_lookup_ns | 4.5027 | 4.4924 | 1.0023 |
| 33554432 | 16 | 1 | inline_lookup_ns | 3.8124 | 3.7469 | 1.0175 |
| 33554432 | 16 | 1 | lookup_ns | 7.5998 | 7.7883 | 0.9758 |
| 33554432 | 16 | 2 | hash_lookup_ns | 10.1273 | 10.1691 | 0.9959 |
| 33554432 | 16 | 2 | inline_hash_lookup_ns | 4.5826 | 4.4522 | 1.0293 |
| 33554432 | 16 | 2 | inline_lookup_ns | 3.8032 | 3.7101 | 1.0251 |
| 33554432 | 16 | 2 | lookup_ns | 5.2061 | 5.6670 | 0.9187 |
| 33554432 | 16 | 31 | hash_lookup_ns | 4.1769 | 4.2643 | 0.9795 |
| 33554432 | 16 | 31 | inline_hash_lookup_ns | 4.4384 | 4.4998 | 0.9863 |
| 33554432 | 16 | 31 | inline_lookup_ns | 3.7222 | 3.7948 | 0.9809 |
| 33554432 | 16 | 31 | lookup_ns | 3.7275 | 3.8077 | 0.9789 |
| 33554432 | 16 | 4096 | hash_lookup_ns | 3.9236 | 3.9058 | 1.0045 |
| 33554432 | 16 | 4096 | inline_hash_lookup_ns | 4.5216 | 4.5486 | 0.9941 |
| 33554432 | 16 | 4096 | inline_lookup_ns | 3.9017 | 3.7713 | 1.0346 |
| 33554432 | 16 | 4096 | lookup_ns | 3.8649 | 3.7431 | 1.0325 |
| 33554432 | 32 | 1 | hash_lookup_ns | 17.1210 | 14.7333 | 1.1621 |
| 33554432 | 32 | 1 | inline_hash_lookup_ns | 5.9982 | 5.4045 | 1.1099 |
| 33554432 | 32 | 1 | inline_lookup_ns | 4.5001 | 4.3169 | 1.0425 |
| 33554432 | 32 | 1 | lookup_ns | 9.6300 | 9.4359 | 1.0206 |
| 33554432 | 32 | 2 | hash_lookup_ns | 11.6333 | 11.6775 | 0.9962 |
| 33554432 | 32 | 2 | inline_hash_lookup_ns | 5.6684 | 5.6425 | 1.0046 |
| 33554432 | 32 | 2 | inline_lookup_ns | 4.2844 | 4.5254 | 0.9467 |
| 33554432 | 32 | 2 | lookup_ns | 6.3350 | 6.9620 | 0.9099 |
| 33554432 | 32 | 31 | hash_lookup_ns | 4.6597 | 4.9646 | 0.9386 |
| 33554432 | 32 | 31 | inline_hash_lookup_ns | 5.0640 | 5.2684 | 0.9612 |
| 33554432 | 32 | 31 | inline_lookup_ns | 4.2431 | 4.4643 | 0.9504 |
| 33554432 | 32 | 31 | lookup_ns | 4.1929 | 4.6612 | 0.8995 |
| 33554432 | 32 | 4096 | hash_lookup_ns | 4.3287 | 4.1516 | 1.0427 |
| 33554432 | 32 | 4096 | inline_hash_lookup_ns | 5.5160 | 5.1277 | 1.0757 |
| 33554432 | 32 | 4096 | inline_lookup_ns | 4.4070 | 4.1825 | 1.0537 |
| 33554432 | 32 | 4096 | lookup_ns | 4.5082 | 4.1483 | 1.0868 |

## Quality-gated external comparisons

Each mode independently selects the fastest measured external allocation under the actual-byte cap and pointwise two-sided95% Wilson upper FPR limit. Actual16bpk configurations compete under cap32. These are postprocessed nested budget/FPR views; they are not independent significance trials or a simultaneous confidence guarantee.

| Batch | Contract | Rival | Comparable views | Shortcut wins / losses / ties | Minimum rival/shortcut | Maximum |
| ---: | --- | --- | ---: | --- | ---: | ---: |
| 1 | lookup_ns | external | 8 | 0/8/0 | 0.8317 | 0.9384 |
| 1 | lookup_ns | byte_leaf | 6 | 0/6/0 | 0.9068 | 0.9460 |
| 1 | lookup_ns | native | 8 | 1/7/0 | 0.9306 | 1.0479 |
| 1 | hash_lookup_ns | external | 8 | 4/4/0 | 0.9532 | 1.1855 |
| 1 | hash_lookup_ns | byte_leaf | 6 | 3/3/0 | 0.9533 | 1.0390 |
| 1 | hash_lookup_ns | native | 8 | 5/3/0 | 0.9538 | 1.0393 |
| 1 | inline_lookup_ns | external | 8 | 8/0/0 | 1.1180 | 1.2231 |
| 1 | inline_lookup_ns | byte_leaf | 6 | 2/4/0 | 0.7352 | 1.0191 |
| 1 | inline_lookup_ns | native | 8 | 8/0/0 | 1.1478 | 1.8387 |
| 1 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.0725 | 1.2390 |
| 1 | inline_hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.9388 | 0.9953 |
| 1 | inline_hash_lookup_ns | native | 8 | 8/0/0 | 1.2070 | 1.7808 |
| 2 | lookup_ns | external | 8 | 0/8/0 | 0.8243 | 0.8754 |
| 2 | lookup_ns | byte_leaf | 6 | 0/6/0 | 0.8643 | 0.9026 |
| 2 | lookup_ns | native | 8 | 1/7/0 | 0.8639 | 1.0357 |
| 2 | hash_lookup_ns | external | 8 | 0/8/0 | 0.9271 | 0.9867 |
| 2 | hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.9232 | 0.9523 |
| 2 | hash_lookup_ns | native | 8 | 3/5/0 | 0.9253 | 1.0415 |
| 2 | inline_lookup_ns | external | 8 | 8/0/0 | 1.0377 | 1.1607 |
| 2 | inline_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.7366 | 0.9863 |
| 2 | inline_lookup_ns | native | 8 | 8/0/0 | 1.1232 | 1.8413 |
| 2 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.0172 | 1.2367 |
| 2 | inline_hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.9383 | 0.9733 |
| 2 | inline_hash_lookup_ns | native | 8 | 8/0/0 | 1.1910 | 1.7811 |
| 31 | lookup_ns | external | 8 | 8/0/0 | 1.0204 | 1.1899 |
| 31 | lookup_ns | byte_leaf | 6 | 0/6/0 | 0.8079 | 0.9801 |
| 31 | lookup_ns | native | 8 | 0/8/0 | 0.8065 | 0.9941 |
| 31 | hash_lookup_ns | external | 8 | 6/2/0 | 0.9840 | 1.2168 |
| 31 | hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.8506 | 0.9741 |
| 31 | hash_lookup_ns | native | 8 | 1/7/0 | 0.8286 | 1.2138 |
| 31 | inline_lookup_ns | external | 8 | 8/0/0 | 1.0527 | 1.1559 |
| 31 | inline_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.7373 | 0.9716 |
| 31 | inline_lookup_ns | native | 8 | 8/0/0 | 1.0904 | 1.8382 |
| 31 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.0197 | 1.2379 |
| 31 | inline_hash_lookup_ns | byte_leaf | 6 | 0/6/0 | 0.9409 | 0.9685 |
| 31 | inline_hash_lookup_ns | native | 8 | 8/0/0 | 1.1671 | 1.7774 |
| 4096 | lookup_ns | external | 8 | 8/0/0 | 1.1241 | 1.1682 |
| 4096 | lookup_ns | byte_leaf | 6 | 3/3/0 | 0.7409 | 1.0620 |
| 4096 | lookup_ns | native | 8 | 0/8/0 | 0.5055 | 0.9755 |
| 4096 | hash_lookup_ns | external | 8 | 4/4/0 | 0.9251 | 1.0292 |
| 4096 | hash_lookup_ns | byte_leaf | 6 | 3/3/0 | 0.7360 | 1.0427 |
| 4096 | hash_lookup_ns | native | 8 | 0/8/0 | 0.5254 | 0.9435 |
| 4096 | inline_lookup_ns | external | 8 | 8/0/0 | 1.1228 | 1.1697 |
| 4096 | inline_lookup_ns | byte_leaf | 6 | 3/3/0 | 0.7378 | 1.0328 |
| 4096 | inline_lookup_ns | native | 8 | 8/0/0 | 1.1241 | 1.8347 |
| 4096 | inline_hash_lookup_ns | external | 8 | 8/0/0 | 1.0431 | 1.2245 |
| 4096 | inline_hash_lookup_ns | byte_leaf | 6 | 1/5/0 | 0.9387 | 1.0011 |
| 4096 | inline_hash_lookup_ns | native | 8 | 8/0/0 | 1.1960 | 1.7785 |

Strict0.01%/cap32 views (all tested eligible allocations compete):

| Keys | Batch | Contract | Shortcut ns | External | External ns | External/shortcut |
| ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 1 | lookup_ns | 3.9122 | BloomsdayPinned | 3.2536 | 0.8317 |
| 65536 | 1 | hash_lookup_ns | 6.5240 | BloomsdayPinned | 6.2464 | 0.9575 |
| 65536 | 1 | inline_lookup_ns | 1.2985 | BloomsdayPinned | 1.5033 | 1.1577 |
| 65536 | 1 | inline_hash_lookup_ns | 1.7543 | BloomsdayPinned | 2.1736 | 1.2390 |
| 65536 | 2 | lookup_ns | 2.7678 | BloomsdayPinned | 2.2968 | 0.8298 |
| 65536 | 2 | hash_lookup_ns | 4.4144 | BloomsdayPinned | 4.1284 | 0.9352 |
| 65536 | 2 | inline_lookup_ns | 1.2987 | BloomsdayPinned | 1.5074 | 1.1607 |
| 65536 | 2 | inline_hash_lookup_ns | 1.7541 | BloomsdayPinned | 2.1684 | 1.2362 |
| 65536 | 31 | lookup_ns | 1.3030 | BloomsdayPinned | 1.5504 | 1.1899 |
| 65536 | 31 | hash_lookup_ns | 1.7316 | BloomsdayPinned | 2.1071 | 1.2168 |
| 65536 | 31 | inline_lookup_ns | 1.2985 | BloomsdayPinned | 1.5010 | 1.1559 |
| 65536 | 31 | inline_hash_lookup_ns | 1.7556 | BloomsdayPinned | 2.1638 | 1.2325 |
| 65536 | 4096 | lookup_ns | 1.3042 | BloomsdayPinned | 1.5062 | 1.1549 |
| 65536 | 4096 | hash_lookup_ns | 2.0826 | BloomsdayPinned | 1.9414 | 0.9322 |
| 65536 | 4096 | inline_lookup_ns | 1.2985 | BloomsdayPinned | 1.5030 | 1.1575 |
| 65536 | 4096 | inline_hash_lookup_ns | 1.7575 | BloomsdayPinned | 2.1465 | 1.2213 |
| 33554432 | 1 | lookup_ns | 9.4359 | BloomsdayPinned | 8.8547 | 0.9384 |
| 33554432 | 1 | hash_lookup_ns | 14.7333 | BloomsdayPinned | 17.4659 | 1.1855 |
| 33554432 | 1 | inline_lookup_ns | 4.3169 | BloomsdayPinned | 5.0053 | 1.1595 |
| 33554432 | 1 | inline_hash_lookup_ns | 5.4045 | BloomsdayPinned | 6.3748 | 1.1795 |
| 33554432 | 2 | lookup_ns | 6.9620 | BloomsdayPinned | 5.7908 | 0.8318 |
| 33554432 | 2 | hash_lookup_ns | 11.6775 | BloomsdayPinned | 11.3974 | 0.9760 |
| 33554432 | 2 | inline_lookup_ns | 4.5254 | BloomsdayPinned | 4.6958 | 1.0377 |
| 33554432 | 2 | inline_hash_lookup_ns | 5.6425 | BloomsdayPinned | 5.7397 | 1.0172 |
| 33554432 | 31 | lookup_ns | 4.6612 | BloomsdayPinned | 4.7564 | 1.0204 |
| 33554432 | 31 | hash_lookup_ns | 4.9646 | BloomsdayPinned | 4.8849 | 0.9840 |
| 33554432 | 31 | inline_lookup_ns | 4.4643 | BloomsdayPinned | 4.6997 | 1.0527 |
| 33554432 | 31 | inline_hash_lookup_ns | 5.2684 | BloomsdayPinned | 5.3724 | 1.0197 |
| 33554432 | 4096 | lookup_ns | 4.1483 | BloomsdayPinned | 4.7103 | 1.1355 |
| 33554432 | 4096 | hash_lookup_ns | 4.1516 | BloomsdayPinned | 4.2726 | 1.0292 |
| 33554432 | 4096 | inline_lookup_ns | 4.1825 | BloomsdayPinned | 4.7499 | 1.1357 |
| 33554432 | 4096 | inline_hash_lookup_ns | 5.1277 | BloomsdayPinned | 5.3490 | 1.0431 |

rankings.json retains192 cap/FPR/batch/mode views, separating original native, experimental native, external, shortcut and ByteLeaf choices. individual-native.csv retains3456 individual eligible/ineligible native-allocation comparisons. controlled-ratios.csv retains256 exact control pairs (64 shortcut/before plus192 leaf/original). api-ratios.csv retains384 generic/visible ratios. quality.csv retains32 family/size/seed records, deduplicating known clone and batch/mode reuse without pooling across families; distinct public families can implement the same mapping. The calibration denominator is2^20 here and is never pooled with earlier seed42 screens that used different intervals or denominators.

The external scope is the three frozen Rust public API families in this binary. Only actual16/32bpk allocations were tested; finer capacities and other implementations are outside this screen. Trial min/max are observed ranges, not speed confidence intervals.
