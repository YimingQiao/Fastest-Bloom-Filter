# Fixed Rust singleton query comparison

Ratios are candidate latency / control latency; below one is faster. Native and portable profiles are reported separately, with no pooled winner or cross-profile speed ranking. The 288 paired contrasts reuse inputs and constructions; they are not independent experiments.

Every API/contract retains eight measured values. Four-point seed × round ranges are descriptive, not confidence intervals. Round 2 reverses the full process ledger and API order; environmental history changes too, so order is not isolated causally. Dynamic caller bounds and actual compiler boundaries belong to this experiment, not the earlier tiny proof.

| Profile | n exponent | Hit % | Batch | Contract | Minimum ratio | Maximum ratio | Seed/round outcomes |
|---|---:|---:|---:|---|---:|---:|---|
| native | 16 | 0 | 1 | generic_hash_query | 0.691217 | 0.694061 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 0 | 1 | generic_pure | 0.727473 | 0.728667 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 0 | 1 | visible_hash_query | 0.460488 | 0.467302 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 0 | 1 | visible_pure | 0.572559 | 0.574940 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 1 | generic_hash_query | 0.690916 | 0.694337 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 1 | generic_pure | 0.727581 | 0.729158 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 1 | visible_hash_query | 0.460446 | 0.465177 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 1 | visible_pure | 0.571802 | 0.574822 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 3 | generic_hash_query | 0.678177 | 0.679271 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 3 | generic_pure | 0.602456 | 0.611576 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 50 | 31 | generic_hash_query | 0.953927 | 1.029520 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 16 | 50 | 31 | generic_pure | 0.992552 | 1.012116 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 16 | 50 | 4096 | generic_hash_query | 0.998315 | 1.015216 | 6812364731/r1: slower; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 16 | 50 | 4096 | generic_pure | 0.971863 | 1.025721 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 16 | 100 | 1 | generic_hash_query | 0.692112 | 0.718506 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 100 | 1 | generic_pure | 0.727344 | 0.728952 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 100 | 1 | visible_hash_query | 0.463244 | 0.468157 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 16 | 100 | 1 | visible_pure | 0.572946 | 0.575236 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 0 | 1 | generic_hash_query | 0.693827 | 0.710837 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 0 | 1 | generic_pure | 0.557522 | 0.560079 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 0 | 1 | visible_hash_query | 0.446383 | 0.452352 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 0 | 1 | visible_pure | 0.439934 | 0.461465 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 1 | generic_hash_query | 0.703560 | 0.723209 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 1 | generic_pure | 0.559822 | 0.568821 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 1 | visible_hash_query | 0.450421 | 0.457112 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 1 | visible_pure | 0.440966 | 0.449663 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 3 | generic_hash_query | 0.540649 | 0.547844 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 3 | generic_pure | 0.480144 | 0.487895 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 50 | 31 | generic_hash_query | 1.002461 | 1.015101 | 6812364731/r1: slower; 6812364731/r2: slower; 9517218469/r1: slower; 9517218469/r2: slower |
| native | 25 | 50 | 31 | generic_pure | 0.990174 | 1.018798 | 6812364731/r1: slower; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 25 | 50 | 4096 | generic_hash_query | 0.995819 | 1.003347 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: slower; 9517218469/r2: slower |
| native | 25 | 50 | 4096 | generic_pure | 0.987215 | 1.003844 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| native | 25 | 100 | 1 | generic_hash_query | 0.698476 | 0.704924 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 100 | 1 | generic_pure | 0.551820 | 0.560958 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 100 | 1 | visible_hash_query | 0.445600 | 0.450927 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| native | 25 | 100 | 1 | visible_pure | 0.436546 | 0.447184 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 0 | 1 | generic_hash_query | 0.697025 | 0.697749 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 0 | 1 | generic_pure | 0.816862 | 0.818742 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 0 | 1 | visible_hash_query | 0.594036 | 0.595353 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 0 | 1 | visible_pure | 0.706967 | 0.709864 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 1 | generic_hash_query | 0.697267 | 0.699235 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 1 | generic_pure | 0.816426 | 0.820001 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 1 | visible_hash_query | 0.594282 | 0.595051 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 1 | visible_pure | 0.707150 | 0.709557 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 3 | generic_hash_query | 0.581048 | 0.603274 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 3 | generic_pure | 0.620386 | 0.621705 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 50 | 31 | generic_hash_query | 0.999555 | 1.016792 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: slower; 9517218469/r2: slower |
| portable | 16 | 50 | 31 | generic_pure | 0.987883 | 1.006464 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| portable | 16 | 50 | 4096 | generic_hash_query | 0.990328 | 1.004742 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| portable | 16 | 50 | 4096 | generic_pure | 0.973099 | 1.030662 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: faster; 9517218469/r2: slower |
| portable | 16 | 100 | 1 | generic_hash_query | 0.697107 | 0.698647 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 100 | 1 | generic_pure | 0.817097 | 0.818502 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 100 | 1 | visible_hash_query | 0.594763 | 0.595432 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 16 | 100 | 1 | visible_pure | 0.707824 | 0.708812 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 0 | 1 | generic_hash_query | 0.755858 | 0.765503 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 0 | 1 | generic_pure | 0.669250 | 0.678683 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 0 | 1 | visible_hash_query | 0.556748 | 0.579009 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 0 | 1 | visible_pure | 0.514383 | 0.530118 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 1 | generic_hash_query | 0.756054 | 0.766182 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 1 | generic_pure | 0.670824 | 0.677397 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 1 | visible_hash_query | 0.563158 | 0.568047 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 1 | visible_pure | 0.515518 | 0.525090 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 3 | generic_hash_query | 0.606402 | 0.617168 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 3 | generic_pure | 0.501424 | 0.507229 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 31 | generic_hash_query | 0.972731 | 0.981606 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 31 | generic_pure | 0.976240 | 0.983390 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 50 | 4096 | generic_hash_query | 0.995883 | 1.011874 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: slower; 9517218469/r2: faster |
| portable | 25 | 50 | 4096 | generic_pure | 0.993935 | 1.005251 | 6812364731/r1: faster; 6812364731/r2: slower; 9517218469/r1: slower; 9517218469/r2: faster |
| portable | 25 | 100 | 1 | generic_hash_query | 0.747074 | 0.758549 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 100 | 1 | generic_pure | 0.664622 | 0.680976 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 100 | 1 | visible_hash_query | 0.560730 | 0.567380 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |
| portable | 25 | 100 | 1 | visible_pure | 0.511751 | 0.522664 | 6812364731/r1: faster; 6812364731/r2: faster; 9517218469/r1: faster; 9517218469/r2: faster |

## Every slower or tied comparison

| Case | Profile | Round | n exponent | Hit % | Batch | Seed | Contract | Control ns/key | Candidate ns/key | Ratio | Outcome |
|---:|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---|
| 3 | native | 1 | 16 | 50 | 4096 | 6812364731 | generic_hash_query | 1.777320 | 1.780173 | 1.001605 | slower |
| 14 | native | 1 | 25 | 50 | 31 | 6812364731 | generic_pure | 7.442371 | 7.582275 | 1.018798 | slower |
| 14 | native | 1 | 25 | 50 | 31 | 6812364731 | generic_hash_query | 7.469941 | 7.529459 | 1.007968 | slower |
| 20 | native | 1 | 25 | 50 | 31 | 9517218469 | generic_hash_query | 7.521386 | 7.539898 | 1.002461 | slower |
| 21 | native | 1 | 25 | 50 | 4096 | 9517218469 | generic_hash_query | 5.326725 | 5.327567 | 1.000158 | slower |
| 32 | portable | 1 | 16 | 50 | 31 | 9517218469 | generic_hash_query | 3.403082 | 3.428904 | 1.007588 | slower |
| 45 | portable | 1 | 25 | 50 | 4096 | 9517218469 | generic_pure | 5.686144 | 5.714760 | 1.005033 | slower |
| 45 | portable | 1 | 25 | 50 | 4096 | 9517218469 | generic_hash_query | 5.955729 | 6.026446 | 1.011874 | slower |
| 56 | portable | 2 | 25 | 50 | 4096 | 6812364731 | generic_pure | 5.607061 | 5.636502 | 1.005251 | slower |
| 56 | portable | 2 | 25 | 50 | 4096 | 6812364731 | generic_hash_query | 5.826362 | 5.830620 | 1.000731 | slower |
| 62 | portable | 2 | 16 | 50 | 4096 | 9517218469 | generic_pure | 1.324436 | 1.354585 | 1.022763 | slower |
| 62 | portable | 2 | 16 | 50 | 4096 | 9517218469 | generic_hash_query | 2.503883 | 2.515756 | 1.004742 | slower |
| 63 | portable | 2 | 16 | 50 | 31 | 9517218469 | generic_pure | 1.415444 | 1.422643 | 1.005085 | slower |
| 63 | portable | 2 | 16 | 50 | 31 | 9517218469 | generic_hash_query | 3.393321 | 3.446216 | 1.015588 | slower |
| 68 | portable | 2 | 16 | 50 | 4096 | 6812364731 | generic_pure | 1.320088 | 1.360564 | 1.030662 | slower |
| 68 | portable | 2 | 16 | 50 | 4096 | 6812364731 | generic_hash_query | 2.509138 | 2.518622 | 1.003780 | slower |
| 69 | portable | 2 | 16 | 50 | 31 | 6812364731 | generic_pure | 1.413907 | 1.423047 | 1.006464 | slower |
| 69 | portable | 2 | 16 | 50 | 31 | 6812364731 | generic_hash_query | 3.392142 | 3.449102 | 1.016792 | slower |
| 74 | native | 2 | 25 | 50 | 4096 | 9517218469 | generic_pure | 5.691805 | 5.713683 | 1.003844 | slower |
| 74 | native | 2 | 25 | 50 | 4096 | 9517218469 | generic_hash_query | 5.253484 | 5.271067 | 1.003347 | slower |
| 75 | native | 2 | 25 | 50 | 31 | 9517218469 | generic_pure | 7.503572 | 7.520818 | 1.002298 | slower |
| 75 | native | 2 | 25 | 50 | 31 | 9517218469 | generic_hash_query | 7.527664 | 7.607204 | 1.010566 | slower |
| 80 | native | 2 | 25 | 50 | 4096 | 6812364731 | generic_pure | 5.791178 | 5.797120 | 1.001026 | slower |
| 80 | native | 2 | 25 | 50 | 4096 | 6812364731 | generic_hash_query | 5.363985 | 5.371070 | 1.001321 | slower |
| 81 | native | 2 | 25 | 50 | 31 | 6812364731 | generic_pure | 7.522948 | 7.559269 | 1.004828 | slower |
| 81 | native | 2 | 25 | 50 | 31 | 6812364731 | generic_hash_query | 7.519977 | 7.633540 | 1.015101 | slower |
| 86 | native | 2 | 16 | 50 | 4096 | 9517218469 | generic_pure | 1.243908 | 1.275902 | 1.025721 | slower |
| 86 | native | 2 | 16 | 50 | 4096 | 9517218469 | generic_hash_query | 1.802235 | 1.829658 | 1.015216 | slower |
| 87 | native | 2 | 16 | 50 | 31 | 9517218469 | generic_pure | 1.362597 | 1.375896 | 1.009760 | slower |
| 87 | native | 2 | 16 | 50 | 31 | 9517218469 | generic_hash_query | 2.162995 | 2.226846 | 1.029520 | slower |
| 92 | native | 2 | 16 | 50 | 4096 | 6812364731 | generic_pure | 1.244231 | 1.276027 | 1.025555 | slower |
| 92 | native | 2 | 16 | 50 | 4096 | 6812364731 | generic_hash_query | 1.784422 | 1.795581 | 1.006253 | slower |
| 93 | native | 2 | 16 | 50 | 31 | 6812364731 | generic_pure | 1.358624 | 1.375086 | 1.012116 | slower |
| 93 | native | 2 | 16 | 50 | 31 | 6812364731 | generic_hash_query | 2.162190 | 2.221086 | 1.027239 | slower |

Batch 31 and 4096 are regression controls; retained source does not imply identical machine code. Batch 31 has remainder 4 at q=2^22 and does not exercise a new 1–3-key remainder. Successful-path inlining, target boundaries, frame size and unrolling can change together. All wins, losses, ties, vectors and opposite-round sensitivities remain in the artifacts. There is no calibration, external comparison, build, multithread, significance, or global-fastest claim.
