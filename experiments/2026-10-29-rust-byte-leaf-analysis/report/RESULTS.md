# Byte leaf hint: six-seed confirmation

The unchanged executable completed 96 workloads / 216 rows on CPU2. Original/candidate order is exactly 3:3 within each size/budget/batch group. Every output, workload, filter order, phase order and source/dependency/binary hash passed. The original CPU3 seed42 screen and its regression remain separate. This report makes no production decision.

All 384 per-seed original/candidate ratios and their trial ranges remain in paired-ratios.csv. Ratios above1 favor the candidate. The128 order-stratified views report the three candidate-first and three original-first seeds separately; they are descriptive subsets, not additional samples.

| Keys | Requested bpk | Batch | Metric | Geometric original/candidate | Lowest | Highest | Candidate/original/ties |
| ---: | ---: | ---: | --- | ---: | ---: | ---: | --- |
| 65536 | 8 | 1 | hash_lookup_ns | 0.999 | 0.997 | 1.001 | 1/5/0 |
| 65536 | 8 | 1 | inline_hash_lookup_ns | 1.368 | 1.365 | 1.371 | 6/0/0 |
| 65536 | 8 | 1 | inline_lookup_ns | 1.475 | 1.465 | 1.486 | 6/0/0 |
| 65536 | 8 | 1 | lookup_ns | 1.011 | 0.999 | 1.035 | 5/1/0 |
| 65536 | 8 | 3 | hash_lookup_ns | 1.003 | 1.001 | 1.006 | 6/0/0 |
| 65536 | 8 | 3 | inline_hash_lookup_ns | 1.369 | 1.366 | 1.373 | 6/0/0 |
| 65536 | 8 | 3 | inline_lookup_ns | 1.491 | 1.459 | 1.529 | 6/0/0 |
| 65536 | 8 | 3 | lookup_ns | 0.999 | 0.995 | 1.001 | 3/3/0 |
| 65536 | 8 | 31 | hash_lookup_ns | 1.000 | 0.997 | 1.002 | 3/3/0 |
| 65536 | 8 | 31 | inline_hash_lookup_ns | 1.367 | 1.365 | 1.371 | 6/0/0 |
| 65536 | 8 | 31 | inline_lookup_ns | 1.484 | 1.450 | 1.520 | 6/0/0 |
| 65536 | 8 | 31 | lookup_ns | 0.988 | 0.964 | 1.011 | 2/4/0 |
| 65536 | 8 | 4096 | hash_lookup_ns | 1.006 | 0.990 | 1.022 | 3/3/0 |
| 65536 | 8 | 4096 | inline_hash_lookup_ns | 1.366 | 1.362 | 1.370 | 6/0/0 |
| 65536 | 8 | 4096 | inline_lookup_ns | 1.492 | 1.461 | 1.522 | 6/0/0 |
| 65536 | 8 | 4096 | lookup_ns | 1.005 | 0.994 | 1.013 | 4/2/0 |
| 65536 | 16 | 1 | hash_lookup_ns | 0.999 | 0.998 | 1.001 | 2/4/0 |
| 65536 | 16 | 1 | inline_hash_lookup_ns | 1.374 | 1.370 | 1.377 | 6/0/0 |
| 65536 | 16 | 1 | inline_lookup_ns | 1.470 | 1.454 | 1.495 | 6/0/0 |
| 65536 | 16 | 1 | lookup_ns | 1.015 | 0.997 | 1.043 | 4/2/0 |
| 65536 | 16 | 3 | hash_lookup_ns | 1.002 | 0.999 | 1.005 | 5/1/0 |
| 65536 | 16 | 3 | inline_hash_lookup_ns | 1.373 | 1.368 | 1.375 | 6/0/0 |
| 65536 | 16 | 3 | inline_lookup_ns | 1.473 | 1.451 | 1.491 | 6/0/0 |
| 65536 | 16 | 3 | lookup_ns | 1.000 | 0.999 | 1.000 | 2/4/0 |
| 65536 | 16 | 31 | hash_lookup_ns | 1.000 | 0.998 | 1.004 | 2/4/0 |
| 65536 | 16 | 31 | inline_hash_lookup_ns | 1.374 | 1.371 | 1.376 | 6/0/0 |
| 65536 | 16 | 31 | inline_lookup_ns | 1.472 | 1.454 | 1.489 | 6/0/0 |
| 65536 | 16 | 31 | lookup_ns | 0.998 | 0.964 | 1.035 | 3/3/0 |
| 65536 | 16 | 4096 | hash_lookup_ns | 0.995 | 0.983 | 1.007 | 3/3/0 |
| 65536 | 16 | 4096 | inline_hash_lookup_ns | 1.374 | 1.371 | 1.378 | 6/0/0 |
| 65536 | 16 | 4096 | inline_lookup_ns | 1.465 | 1.447 | 1.486 | 6/0/0 |
| 65536 | 16 | 4096 | lookup_ns | 1.001 | 0.983 | 1.016 | 3/3/0 |
| 33554432 | 8 | 1 | hash_lookup_ns | 0.986 | 0.956 | 1.016 | 2/4/0 |
| 33554432 | 8 | 1 | inline_hash_lookup_ns | 1.100 | 1.080 | 1.119 | 6/0/0 |
| 33554432 | 8 | 1 | inline_lookup_ns | 1.208 | 1.183 | 1.226 | 6/0/0 |
| 33554432 | 8 | 1 | lookup_ns | 0.984 | 0.949 | 1.017 | 3/3/0 |
| 33554432 | 8 | 3 | hash_lookup_ns | 0.997 | 0.988 | 1.016 | 1/5/0 |
| 33554432 | 8 | 3 | inline_hash_lookup_ns | 1.121 | 1.107 | 1.134 | 6/0/0 |
| 33554432 | 8 | 3 | inline_lookup_ns | 1.220 | 1.197 | 1.251 | 6/0/0 |
| 33554432 | 8 | 3 | lookup_ns | 1.001 | 0.990 | 1.024 | 2/4/0 |
| 33554432 | 8 | 31 | hash_lookup_ns | 1.002 | 0.983 | 1.012 | 5/1/0 |
| 33554432 | 8 | 31 | inline_hash_lookup_ns | 1.133 | 1.102 | 1.177 | 6/0/0 |
| 33554432 | 8 | 31 | inline_lookup_ns | 1.224 | 1.209 | 1.249 | 6/0/0 |
| 33554432 | 8 | 31 | lookup_ns | 0.999 | 0.985 | 1.008 | 4/2/0 |
| 33554432 | 8 | 4096 | hash_lookup_ns | 1.003 | 0.993 | 1.015 | 3/3/0 |
| 33554432 | 8 | 4096 | inline_hash_lookup_ns | 1.107 | 1.081 | 1.135 | 6/0/0 |
| 33554432 | 8 | 4096 | inline_lookup_ns | 1.212 | 1.199 | 1.222 | 6/0/0 |
| 33554432 | 8 | 4096 | lookup_ns | 1.002 | 0.993 | 1.013 | 5/1/0 |
| 33554432 | 16 | 1 | hash_lookup_ns | 1.002 | 0.997 | 1.007 | 4/2/0 |
| 33554432 | 16 | 1 | inline_hash_lookup_ns | 1.230 | 1.220 | 1.237 | 6/0/0 |
| 33554432 | 16 | 1 | inline_lookup_ns | 1.258 | 1.252 | 1.266 | 6/0/0 |
| 33554432 | 16 | 1 | lookup_ns | 1.000 | 0.997 | 1.002 | 2/4/0 |
| 33554432 | 16 | 3 | hash_lookup_ns | 0.998 | 0.995 | 1.001 | 1/5/0 |
| 33554432 | 16 | 3 | inline_hash_lookup_ns | 1.228 | 1.224 | 1.233 | 6/0/0 |
| 33554432 | 16 | 3 | inline_lookup_ns | 1.257 | 1.251 | 1.261 | 6/0/0 |
| 33554432 | 16 | 3 | lookup_ns | 0.999 | 0.998 | 1.000 | 1/5/0 |
| 33554432 | 16 | 31 | hash_lookup_ns | 0.997 | 0.993 | 1.004 | 1/5/0 |
| 33554432 | 16 | 31 | inline_hash_lookup_ns | 1.226 | 1.222 | 1.236 | 6/0/0 |
| 33554432 | 16 | 31 | inline_lookup_ns | 1.257 | 1.251 | 1.264 | 6/0/0 |
| 33554432 | 16 | 31 | lookup_ns | 0.998 | 0.995 | 1.003 | 2/4/0 |
| 33554432 | 16 | 4096 | hash_lookup_ns | 1.000 | 0.995 | 1.005 | 3/3/0 |
| 33554432 | 16 | 4096 | inline_hash_lookup_ns | 1.229 | 1.225 | 1.231 | 6/0/0 |
| 33554432 | 16 | 4096 | inline_lookup_ns | 1.256 | 1.253 | 1.263 | 6/0/0 |
| 33554432 | 16 | 4096 | lookup_ns | 1.001 | 0.998 | 1.003 | 4/2/0 |

External comparisons use only batch1 and the prespecified Bloomsday public API. All four modes stay separate; original generic-mode losses are not replaced by visible-mode gains. All1152 allocation/seed/cap/ceiling alternatives, including ineligible pairs and losses, are retained. Cap32 includes eligible actual16 allocations.

rankings.json gives48 descriptive views. To retain a single configuration across seeds, each family chooses its eligible tested allocation by the geometric mean of six seed medians. This is postprocessing, not a preregistered statistical superiority test. Selection does not erase alternatives. Eligibility requires all six pointwise95% Wilson upper endpoints under the ceiling, with the worst endpoint reported. This is not a simultaneous-selection guarantee.

quality.csv retains48 family/size/seed calibration records; quality-worst.csv gives8 across-seed extrema without pooling negatives. Byte original/candidate and repeated modes/batches reuse streams. Trial ranges and six-seed ratios are descriptive, not speed confidence intervals. No explicit NUMA memory binding or global-fastest claim is made.
