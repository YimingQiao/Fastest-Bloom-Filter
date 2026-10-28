# Independent32 scalar-inline V2: complete208-row screen

All208 rows,16 exact source-derived row orders, committed source and binary/dependency pins passed verification. Original Independent32, rejectedV1 and scalar-inlineV2 share one executable with ten other retained controls. No old-binary latency is pooled.

CPU3/socket1 whole-operation inherited flock; seed42; n2^16/2^25; actual16/32bpk; batches1/2/31/4096; q2^22;50% hits;4 balanced query repetitions;2^24 disjoint calibration negatives; whole-input build. This is independent-query throughput, not dependent query latency. CPU pinning does not impose memory binding.

The four modes remain distinct: generic prehashed, generic staged-hash, visible public singleton prehashed and visible fused-hash. Visible loops process the entire array at every generic batch tag. Filter/case order is not pair-order balanced. Min/max are observed trial ranges, not speed confidence intervals. Repeated modes/batches/aliases add no independent negatives. Earlier held-out FourSector16 failures remain evidence against robust0.1% qualification; this training screen cannot erase them.

V2 removes scalar-helper calls and restores a one-register64-byte public prologue; its five bulk loops match the original after branch-target normalization. Total code size and placement changed. These observations explain the hypothesis and do not substitute for timing.

## Original versus V2

Ratios are original/V2; above1 favors V2. Four size/allocation conditions per row are descriptive, not independent confidence bounds.

| Batch | Metric | V2 wins/losses/ties | Geometric mean | Minimum | Maximum |
| ---: | --- | --- | ---: | ---: | ---: |
| 1 | lookup_ns | 4/0/0 | 1.1557 | 1.1017 | 1.2000 |
| 1 | hash_lookup_ns | 4/0/0 | 1.0628 | 1.0188 | 1.1079 |
| 1 | inline_lookup_ns | 3/1/0 | 1.0042 | 0.9939 | 1.0090 |
| 1 | inline_hash_lookup_ns | 2/2/0 | 0.9973 | 0.9891 | 1.0042 |
| 2 | lookup_ns | 1/3/0 | 0.9420 | 0.8578 | 1.0916 |
| 2 | hash_lookup_ns | 2/2/0 | 1.0166 | 0.9967 | 1.0708 |
| 2 | inline_lookup_ns | 4/0/0 | 1.0086 | 1.0009 | 1.0260 |
| 2 | inline_hash_lookup_ns | 4/0/0 | 1.0111 | 1.0001 | 1.0441 |
| 31 | lookup_ns | 3/1/0 | 0.9992 | 0.9821 | 1.0071 |
| 31 | hash_lookup_ns | 0/4/0 | 0.9814 | 0.9713 | 0.9995 |
| 31 | inline_lookup_ns | 3/1/0 | 0.9962 | 0.9800 | 1.0038 |
| 31 | inline_hash_lookup_ns | 0/4/0 | 0.9926 | 0.9767 | 0.9986 |
| 4096 | lookup_ns | 3/1/0 | 1.0013 | 0.9888 | 1.0072 |
| 4096 | hash_lookup_ns | 1/3/0 | 0.9970 | 0.9902 | 1.0041 |
| 4096 | inline_lookup_ns | 2/2/0 | 0.9992 | 0.9970 | 1.0016 |
| 4096 | inline_hash_lookup_ns | 1/3/0 | 0.9972 | 0.9897 | 1.0011 |

## Strict0.01% FPR,32bpk cap

The fastest measured eligible external allocation competes in each mode, including smaller16bpk allocations if they qualify. This is a postprocessed training selection with pointwise Wilson95 upper bounds, not a simultaneous guarantee.

| Keys | Batch | Metric | V2 ns | Best external | External ns | External/V2 |
| ---: | ---: | --- | ---: | --- | ---: | ---: |
| 65536 | 1 | lookup_ns | 3.2423 | BloomsdayPinned | 3.2572 | 1.0046 |
| 65536 | 1 | hash_lookup_ns | 5.6206 | BloomsdayPinned | 6.0141 | 1.0700 |
| 65536 | 1 | inline_lookup_ns | 1.3170 | BloomsdayPinned | 1.5267 | 1.1592 |
| 65536 | 1 | inline_hash_lookup_ns | 1.7595 | BloomsdayPinned | 2.1479 | 1.2207 |
| 65536 | 2 | lookup_ns | 2.8386 | BloomsdayPinned | 2.2880 | 0.8060 |
| 65536 | 2 | hash_lookup_ns | 4.0991 | BloomsdayPinned | 4.1067 | 1.0019 |
| 65536 | 2 | inline_lookup_ns | 1.3187 | BloomsdayPinned | 1.5205 | 1.1530 |
| 65536 | 2 | inline_hash_lookup_ns | 1.7565 | BloomsdayPinned | 2.1484 | 1.2231 |
| 65536 | 31 | lookup_ns | 1.3254 | BloomsdayPinned | 1.5792 | 1.1915 |
| 65536 | 31 | hash_lookup_ns | 1.7738 | BloomsdayPinned | 2.1344 | 1.2033 |
| 65536 | 31 | inline_lookup_ns | 1.3238 | BloomsdayPinned | 1.5246 | 1.1517 |
| 65536 | 31 | inline_hash_lookup_ns | 1.7616 | BloomsdayPinned | 2.1484 | 1.2196 |
| 65536 | 4096 | lookup_ns | 1.3192 | BloomsdayPinned | 1.5280 | 1.1583 |
| 65536 | 4096 | hash_lookup_ns | 1.9155 | BloomsdayPinned | 2.0731 | 1.0823 |
| 65536 | 4096 | inline_lookup_ns | 1.3164 | BloomsdayPinned | 1.5276 | 1.1604 |
| 65536 | 4096 | inline_hash_lookup_ns | 1.7586 | BloomsdayPinned | 2.1480 | 1.2214 |
| 33554432 | 1 | lookup_ns | 14.1230 | BloomsdayPinned | 14.4629 | 1.0241 |
| 33554432 | 1 | hash_lookup_ns | 27.0215 | BloomsdayPinned | 27.5675 | 1.0202 |
| 33554432 | 1 | inline_lookup_ns | 7.3441 | BloomsdayPinned | 8.5278 | 1.1612 |
| 33554432 | 1 | inline_hash_lookup_ns | 9.9016 | BloomsdayPinned | 10.4953 | 1.0600 |
| 33554432 | 2 | lookup_ns | 11.9566 | BloomsdayPinned | 10.7747 | 0.9011 |
| 33554432 | 2 | hash_lookup_ns | 20.6377 | BloomsdayPinned | 20.5323 | 0.9949 |
| 33554432 | 2 | inline_lookup_ns | 7.3010 | BloomsdayPinned | 8.4748 | 1.1608 |
| 33554432 | 2 | inline_hash_lookup_ns | 9.7847 | BloomsdayPinned | 10.4064 | 1.0635 |
| 33554432 | 31 | lookup_ns | 7.4745 | BloomsdayPinned | 8.6563 | 1.1581 |
| 33554432 | 31 | hash_lookup_ns | 8.3832 | BloomsdayPinned | 9.1860 | 1.0958 |
| 33554432 | 31 | inline_lookup_ns | 7.2962 | BloomsdayPinned | 8.6293 | 1.1827 |
| 33554432 | 31 | inline_hash_lookup_ns | 9.7920 | BloomsdayPinned | 10.4869 | 1.0710 |
| 33554432 | 4096 | lookup_ns | 7.3276 | BloomsdayPinned | 8.4580 | 1.1543 |
| 33554432 | 4096 | hash_lookup_ns | 6.8254 | BloomsdayPinned | 7.6203 | 1.1165 |
| 33554432 | 4096 | inline_lookup_ns | 7.3294 | BloomsdayPinned | 8.5195 | 1.1624 |
| 33554432 | 4096 | inline_hash_lookup_ns | 9.8142 | BloomsdayPinned | 10.4814 | 1.0680 |

All192 nested cap/FPR/mode views and3840 individual native alternatives, including every loss/ineligible allocation, remain in rankings.json and individual-native.csv. controlled-ratios.csv retains320 before/candidate pairs; v1-v2-ratios.csv adds64 direct rejectedV1/V2 pairs. build-ratios.csv retains128 construction comparisons without assuming the unchanged insertion source has identical timing. api-ratios.csv retains416 generic/visible ratios; quality.csv has32 unpooled family/size/allocation/seed records. Original, V1 and V2 bitmaps/counts match exactly.

The three external families are Bloomsday, fastbloom and SBBF. This screen tests16/32bpk, not finer capacities or all available libraries. Retained Byte controls deliberately predate the production minimal one-hint integration; the leaf control carries the older hint variant. None is silently relabeled as current production. No promotion or global-fastest conclusion follows from this one seed.
