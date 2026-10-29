# Fixed C++ singleton query comparison

Every ratio below is candidate latency / control latency; below one is faster. The 240 contrasts share inputs, constructions and phase schedules; they are not 240 independent experiments. All eight values per API/contract remain in the artifacts.

The four points per condition are descriptive seed × round ranges, not confidence intervals. Round 2 reverses the full launch ledger and API positions, but environmental history also changes. The candidate combines SIMD/body, inline/frame and sometimes unrolling changes; no single-instruction causal claim is made.

| n exponent | Hit % | Batch | Contract | Minimum ratio | Maximum ratio | Seed/round outcomes |
|---:|---:|---:|---|---:|---:|---|
| 16 | 0 | 1 | generic_pure | 0.698404 | 0.701201 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 1 | generic_staged_common_hash | 0.673278 | 0.674596 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 1 | visible_public_fused_common_hash | 0.441093 | 0.442952 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 1 | visible_public_pure | 0.523186 | 0.524983 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 3 | generic_pure | 0.668298 | 0.670530 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 3 | generic_staged_common_hash | 0.730853 | 0.733302 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 31 | generic_pure | 0.977909 | 1.002332 | 16057/r1: faster; 16057/r2: faster; 32029/r1: slower; 32029/r2: faster |
| 16 | 0 | 31 | generic_staged_common_hash | 0.979450 | 0.983989 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 0 | 4096 | generic_pure | 0.982884 | 1.017074 | 16057/r1: faster; 16057/r2: slower; 32029/r1: slower; 32029/r2: faster |
| 16 | 0 | 4096 | generic_staged_common_hash | 0.982505 | 1.028989 | 16057/r1: slower; 16057/r2: faster; 32029/r1: faster; 32029/r2: slower |
| 16 | 50 | 1 | generic_pure | 0.697135 | 0.699707 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 1 | generic_staged_common_hash | 0.673833 | 0.674555 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 1 | visible_public_fused_common_hash | 0.441046 | 0.442804 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 1 | visible_public_pure | 0.523382 | 0.524167 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 3 | generic_pure | 0.668038 | 0.669211 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 3 | generic_staged_common_hash | 0.729932 | 0.732436 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 31 | generic_pure | 0.982848 | 1.000315 | 16057/r1: faster; 16057/r2: slower; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 31 | generic_staged_common_hash | 0.981478 | 0.985009 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 50 | 4096 | generic_pure | 0.983911 | 1.016475 | 16057/r1: faster; 16057/r2: slower; 32029/r1: slower; 32029/r2: faster |
| 16 | 50 | 4096 | generic_staged_common_hash | 0.975746 | 1.016536 | 16057/r1: slower; 16057/r2: faster; 32029/r1: faster; 32029/r2: slower |
| 16 | 100 | 1 | generic_pure | 0.697748 | 0.700135 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 1 | generic_staged_common_hash | 0.673790 | 0.675097 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 1 | visible_public_fused_common_hash | 0.440292 | 0.441471 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 1 | visible_public_pure | 0.523186 | 0.524273 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 3 | generic_pure | 0.667865 | 0.669902 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 3 | generic_staged_common_hash | 0.731476 | 0.732222 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 31 | generic_pure | 0.983965 | 1.005251 | 16057/r1: faster; 16057/r2: slower; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 31 | generic_staged_common_hash | 0.980263 | 0.982934 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 16 | 100 | 4096 | generic_pure | 0.984146 | 1.018603 | 16057/r1: faster; 16057/r2: slower; 32029/r1: slower; 32029/r2: faster |
| 16 | 100 | 4096 | generic_staged_common_hash | 0.982409 | 1.016428 | 16057/r1: faster; 16057/r2: faster; 32029/r1: slower; 32029/r2: slower |
| 25 | 0 | 1 | generic_pure | 0.711520 | 0.725139 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 1 | generic_staged_common_hash | 0.794101 | 0.813616 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 1 | visible_public_fused_common_hash | 0.515500 | 0.523579 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 1 | visible_public_pure | 0.549528 | 0.555160 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 3 | generic_pure | 0.642410 | 0.658842 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 3 | generic_staged_common_hash | 0.743863 | 0.755605 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 0 | 31 | generic_pure | 0.996914 | 1.007988 | 16057/r1: slower; 16057/r2: faster; 32029/r1: slower; 32029/r2: slower |
| 25 | 0 | 31 | generic_staged_common_hash | 1.022220 | 1.027138 | 16057/r1: slower; 16057/r2: slower; 32029/r1: slower; 32029/r2: slower |
| 25 | 0 | 4096 | generic_pure | 0.991565 | 1.005317 | 16057/r1: faster; 16057/r2: faster; 32029/r1: slower; 32029/r2: faster |
| 25 | 0 | 4096 | generic_staged_common_hash | 0.998201 | 1.000590 | 16057/r1: slower; 16057/r2: faster; 32029/r1: slower; 32029/r2: faster |
| 25 | 50 | 1 | generic_pure | 0.704923 | 0.717800 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 1 | generic_staged_common_hash | 0.787226 | 0.806984 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 1 | visible_public_fused_common_hash | 0.513139 | 0.521180 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 1 | visible_public_pure | 0.549989 | 0.556342 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 3 | generic_pure | 0.641911 | 0.659321 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 3 | generic_staged_common_hash | 0.731607 | 0.754502 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 50 | 31 | generic_pure | 0.995015 | 1.003100 | 16057/r1: faster; 16057/r2: slower; 32029/r1: slower; 32029/r2: faster |
| 25 | 50 | 31 | generic_staged_common_hash | 1.018383 | 1.029918 | 16057/r1: slower; 16057/r2: slower; 32029/r1: slower; 32029/r2: slower |
| 25 | 50 | 4096 | generic_pure | 0.992762 | 1.010102 | 16057/r1: faster; 16057/r2: faster; 32029/r1: slower; 32029/r2: slower |
| 25 | 50 | 4096 | generic_staged_common_hash | 0.993865 | 1.004329 | 16057/r1: slower; 16057/r2: faster; 32029/r1: slower; 32029/r2: slower |
| 25 | 100 | 1 | generic_pure | 0.696798 | 0.719218 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 1 | generic_staged_common_hash | 0.784365 | 0.804836 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 1 | visible_public_fused_common_hash | 0.510635 | 0.522861 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 1 | visible_public_pure | 0.547283 | 0.555543 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 3 | generic_pure | 0.639077 | 0.657440 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 3 | generic_staged_common_hash | 0.738868 | 0.749600 | 16057/r1: faster; 16057/r2: faster; 32029/r1: faster; 32029/r2: faster |
| 25 | 100 | 31 | generic_pure | 0.995534 | 1.002058 | 16057/r1: faster; 16057/r2: faster; 32029/r1: slower; 32029/r2: faster |
| 25 | 100 | 31 | generic_staged_common_hash | 1.019256 | 1.029228 | 16057/r1: slower; 16057/r2: slower; 32029/r1: slower; 32029/r2: slower |
| 25 | 100 | 4096 | generic_pure | 0.999310 | 1.018589 | 16057/r1: slower; 16057/r2: faster; 32029/r1: slower; 32029/r2: slower |
| 25 | 100 | 4096 | generic_staged_common_hash | 0.997038 | 1.021879 | 16057/r1: slower; 16057/r2: slower; 32029/r1: faster; 32029/r2: slower |

## Every slower or tied comparison

| Case | Round | n exponent | Hit % | Batch | Seed | Contract | Control ns/key | Candidate ns/key | Ratio | Outcome |
|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---|
| 3 | 1 | 16 | 0 | 4096 | 16057 | generic_staged_common_hash | 1.711280 | 1.760888 | 1.028989 | slower |
| 7 | 1 | 16 | 50 | 4096 | 16057 | generic_staged_common_hash | 1.709352 | 1.737618 | 1.016536 | slower |
| 14 | 1 | 25 | 0 | 31 | 16057 | generic_pure | 6.845279 | 6.899956 | 1.007988 | slower |
| 14 | 1 | 25 | 0 | 31 | 16057 | generic_staged_common_hash | 7.510635 | 7.703802 | 1.025719 | slower |
| 15 | 1 | 25 | 0 | 4096 | 16057 | generic_staged_common_hash | 5.288336 | 5.291458 | 1.000590 | slower |
| 18 | 1 | 25 | 50 | 31 | 16057 | generic_staged_common_hash | 7.473286 | 7.688138 | 1.028749 | slower |
| 19 | 1 | 25 | 50 | 4096 | 16057 | generic_staged_common_hash | 5.280394 | 5.288085 | 1.001457 | slower |
| 22 | 1 | 25 | 100 | 31 | 16057 | generic_staged_common_hash | 7.461214 | 7.675352 | 1.028700 | slower |
| 23 | 1 | 25 | 100 | 4096 | 16057 | generic_pure | 5.608101 | 5.712347 | 1.018589 | slower |
| 23 | 1 | 25 | 100 | 4096 | 16057 | generic_staged_common_hash | 5.243373 | 5.358093 | 1.021879 | slower |
| 24 | 1 | 25 | 100 | 4096 | 32029 | generic_pure | 5.715441 | 5.726664 | 1.001964 | slower |
| 25 | 1 | 25 | 100 | 31 | 32029 | generic_pure | 6.658759 | 6.672464 | 1.002058 | slower |
| 25 | 1 | 25 | 100 | 31 | 32029 | generic_staged_common_hash | 7.311908 | 7.525623 | 1.029228 | slower |
| 28 | 1 | 25 | 50 | 4096 | 32029 | generic_pure | 5.714908 | 5.772642 | 1.010102 | slower |
| 28 | 1 | 25 | 50 | 4096 | 32029 | generic_staged_common_hash | 5.389613 | 5.412392 | 1.004227 | slower |
| 29 | 1 | 25 | 50 | 31 | 32029 | generic_pure | 6.716154 | 6.736975 | 1.003100 | slower |
| 29 | 1 | 25 | 50 | 31 | 32029 | generic_staged_common_hash | 7.368272 | 7.588713 | 1.029918 | slower |
| 32 | 1 | 25 | 0 | 4096 | 32029 | generic_pure | 5.752335 | 5.782921 | 1.005317 | slower |
| 32 | 1 | 25 | 0 | 4096 | 32029 | generic_staged_common_hash | 5.420352 | 5.422359 | 1.000370 | slower |
| 33 | 1 | 25 | 0 | 31 | 32029 | generic_pure | 6.795794 | 6.798539 | 1.000404 | slower |
| 33 | 1 | 25 | 0 | 31 | 32029 | generic_staged_common_hash | 7.465084 | 7.630960 | 1.022220 | slower |
| 36 | 1 | 16 | 100 | 4096 | 32029 | generic_pure | 1.202604 | 1.219421 | 1.013984 | slower |
| 36 | 1 | 16 | 100 | 4096 | 32029 | generic_staged_common_hash | 1.735235 | 1.758795 | 1.013577 | slower |
| 40 | 1 | 16 | 50 | 4096 | 32029 | generic_pure | 1.210266 | 1.222507 | 1.010114 | slower |
| 44 | 1 | 16 | 0 | 4096 | 32029 | generic_pure | 1.207440 | 1.228055 | 1.017074 | slower |
| 45 | 1 | 16 | 0 | 31 | 32029 | generic_pure | 1.381397 | 1.384619 | 1.002332 | slower |
| 51 | 2 | 16 | 0 | 4096 | 32029 | generic_staged_common_hash | 1.713935 | 1.738659 | 1.014425 | slower |
| 55 | 2 | 16 | 50 | 4096 | 32029 | generic_staged_common_hash | 1.717388 | 1.737274 | 1.011579 | slower |
| 59 | 2 | 16 | 100 | 4096 | 32029 | generic_staged_common_hash | 1.713446 | 1.741594 | 1.016428 | slower |
| 62 | 2 | 25 | 0 | 31 | 32029 | generic_pure | 6.793394 | 6.830671 | 1.005487 | slower |
| 62 | 2 | 25 | 0 | 31 | 32029 | generic_staged_common_hash | 7.485119 | 7.673005 | 1.025101 | slower |
| 66 | 2 | 25 | 50 | 31 | 32029 | generic_staged_common_hash | 7.558307 | 7.697250 | 1.018383 | slower |
| 67 | 2 | 25 | 50 | 4096 | 32029 | generic_pure | 5.760672 | 5.766458 | 1.001004 | slower |
| 67 | 2 | 25 | 50 | 4096 | 32029 | generic_staged_common_hash | 5.372236 | 5.395494 | 1.004329 | slower |
| 70 | 2 | 25 | 100 | 31 | 32029 | generic_staged_common_hash | 7.392947 | 7.535303 | 1.019256 | slower |
| 71 | 2 | 25 | 100 | 4096 | 32029 | generic_pure | 5.696476 | 5.742833 | 1.008138 | slower |
| 71 | 2 | 25 | 100 | 4096 | 32029 | generic_staged_common_hash | 5.286038 | 5.378052 | 1.017407 | slower |
| 72 | 2 | 25 | 100 | 4096 | 16057 | generic_staged_common_hash | 5.247719 | 5.255699 | 1.001521 | slower |
| 73 | 2 | 25 | 100 | 31 | 16057 | generic_staged_common_hash | 7.478478 | 7.645646 | 1.022353 | slower |
| 77 | 2 | 25 | 50 | 31 | 16057 | generic_pure | 6.805894 | 6.822917 | 1.002501 | slower |
| 77 | 2 | 25 | 50 | 31 | 16057 | generic_staged_common_hash | 7.455336 | 7.650147 | 1.026130 | slower |
| 81 | 2 | 25 | 0 | 31 | 16057 | generic_staged_common_hash | 7.457428 | 7.659806 | 1.027138 | slower |
| 84 | 2 | 16 | 100 | 4096 | 16057 | generic_pure | 1.204740 | 1.227152 | 1.018603 | slower |
| 85 | 2 | 16 | 100 | 31 | 16057 | generic_pure | 1.391024 | 1.398328 | 1.005251 | slower |
| 88 | 2 | 16 | 50 | 4096 | 16057 | generic_pure | 1.207968 | 1.227869 | 1.016475 | slower |
| 89 | 2 | 16 | 50 | 31 | 16057 | generic_pure | 1.381531 | 1.381967 | 1.000315 | slower |
| 92 | 2 | 16 | 0 | 4096 | 16057 | generic_pure | 1.206928 | 1.222456 | 1.012866 | slower |

Batch 31 and 4096 retain the original source paths; their machine code and caller context are not assumed identical. No external, accuracy, insertion, parallel, significance, or global-fastest claim follows from this two-API query comparison. Every loss and exact tie remains in pairs.csv, alongside all round sensitivity records and original trial vectors.
