# Fixed nearby-divisor accuracy pilot

All 12 prespecified nearby geometries have fewer observed false positives than their matched original geometries. This is one seed and an accuracy-only experiment: it contains no speed measurement, no cross-seed confirmation, and no isolated causal decomposition of the improvement.

At cap12, sector32 and sector64 pass the 1% pointwise Wilson gate at both sizes; register64 still fails. At cap24, sector32 passes 0.1% but fails 0.01% at both sizes. Sector64 passes 0.01% only for the small table, while the large table fails. Register64 fails 0.1% for the small table and passes it for the large table. Thus none of the new layouts passes 0.01% at both tested sizes.

The unchanged original public PImpl API uses K8 and the fixed U shown in each name. The only selected change is the constructor capacity: largest accepted odd divisor within the fixed top 1% window, with all 64-byte backing padding charged. Unsupported points would remain unsupported; all 12 were supported here. No private kernel, new hash, probe policy, or tuner override was substituted.

Each row uses seed42, a complete construction of 2^16 or 2^25 distinct raw-u32 keys, 2^22 mixed queries, and 2^24 distinct nonmember calibration keys. All inserted keys and complete outputs pass the frozen caller checks. The 24 original rows exactly reproduce the earlier raw728 semantic observations and are not fresh evidence. Matched points use the same raw query and calibration streams; samples are not pooled across geometries, APIs, or the two sizes.

Wilson endpoints are two-sided 95% pointwise endpoints, not simultaneous guarantees for this 36-point panel. FPR values below are percentages. The paired count change is descriptive; no paired statistical test or claim that oddness alone caused it is made.

## All 12 fixed original/nearby comparisons

| Public configuration | Keys | Cap bpk | Original / nearby backing bytes | Original / nearby FP counts | Original / nearby Wilson upper, % | Nearby gates passed |
|---|---:|---:|---:|---:|---:|---|
| sector32-u1/artifact_pimpl | 65,536 | 12 | 98,304 / 98,304 | 301,672 / 90,137 | 1.8044748 / 0.5407677 | 1% |
| sector32-u1/artifact_pimpl | 65,536 | 24 | 196,608 / 196,480 | 18,884 / 2,627 | 0.1141733 / 0.0162684 | 1%, 0.1% |
| sector32-u1/artifact_pimpl | 33,554,432 | 12 | 50,331,648 / 50,331,520 | 1,053,799 / 86,759 | 6.2927512 / 0.5205674 | 1% |
| sector32-u1/artifact_pimpl | 33,554,432 | 24 | 100,663,296 / 100,663,296 | 173,410 / 1,951 | 1.0384550 / 0.0121564 | 1%, 0.1% |
| sector64-u1/artifact_pimpl | 65,536 | 12 | 98,304 / 97,856 | 202,384 / 74,133 | 1.2115376 / 0.4450522 | 1% |
| sector64-u1/artifact_pimpl | 65,536 | 24 | 196,608 / 196,544 | 12,107 / 1,491 | 0.0734598 / 0.0093497 | 1%, 0.1%, 0.01% |
| sector64-u1/artifact_pimpl | 33,554,432 | 12 | 50,331,648 / 50,331,584 | 1,155,663 / 66,182 | 6.9004166 / 0.3974863 | 1% |
| sector64-u1/artifact_pimpl | 33,554,432 | 24 | 100,663,296 / 100,662,976 | 229,475 / 1,717 | 1.3733466 / 0.0107297 | 1%, 0.1% |
| register64-u0/artifact_pimpl | 65,536 | 12 | 98,304 / 98,304 | 243,838 / 217,458 | 1.4591255 / 1.3015742 | none |
| register64-u0/artifact_pimpl | 65,536 | 24 | 196,608 / 196,608 | 28,149 / 17,207 | 0.1697509 / 0.1041048 | 1% |
| register64-u0/artifact_pimpl | 33,554,432 | 12 | 50,331,648 / 50,331,648 | 466,029 / 212,960 | 2.7856236 / 1.2747085 | none |
| register64-u0/artifact_pimpl | 33,554,432 | 24 | 100,663,296 / 100,663,296 | 170,798 / 15,497 | 1.0228500 / 0.0938344 | 1%, 0.1% |

The strict small sector64 point has 1,491/16,777,216 false positives and upper 0.0093497%; its large counterpart has 1,717 false positives and upper 0.0107297%, so the latter failure is retained. Register64 cap24 has 17,207 false positives and upper 0.1041048% at the small size, versus 15,497 and 0.0938344% at the large size.

## All 36 point records

| Public configuration | Keys | Cap bpk | Policy | Backing bytes | Logical units | FP / 2^24 | Point FPR, % | Wilson 95% interval, % |
|---|---:|---:|---|---:|---:|---:|---:|---:|
| sector32-u1/artifact_pimpl | 65,536 | 12 | original | 98,304 | 3,072 | 301,672 | 1.7981052 | 1.7917578–1.8044748 |
| sector32-u1/artifact_pimpl | 65,536 | 12 | nearby_odd | 98,304 | 3,071 | 90,137 | 0.5372584 | 0.5337718–0.5407677 |
| sector32-u1/artifact_pimpl | 65,536 | 16 | original | 131,072 | 4,096 | 22,770 | 0.1357198 | 0.1339695–0.1374929 |
| sector32-u1/artifact_pimpl | 65,536 | 24 | original | 196,608 | 6,144 | 18,884 | 0.1125574 | 0.1109643–0.1141733 |
| sector32-u1/artifact_pimpl | 65,536 | 24 | nearby_odd | 196,480 | 6,139 | 2,627 | 0.0156581 | 0.0150708–0.0162684 |
| sector32-u1/artifact_pimpl | 65,536 | 32 | original | 262,144 | 8,192 | 636 | 0.0037909 | 0.0035075–0.0040971 |
| sector32-u1/artifact_pimpl | 33,554,432 | 12 | original | 50,331,648 | 1,572,864 | 1,053,799 | 6.2811315 | 6.2695318–6.2927512 |
| sector32-u1/artifact_pimpl | 33,554,432 | 12 | nearby_odd | 50,331,520 | 1,572,859 | 86,759 | 0.5171239 | 0.5137032–0.5205674 |
| sector32-u1/artifact_pimpl | 33,554,432 | 16 | original | 67,108,864 | 2,097,152 | 18,707 | 0.1115024 | 0.1099169–0.1131108 |
| sector32-u1/artifact_pimpl | 33,554,432 | 24 | original | 100,663,296 | 3,145,728 | 173,410 | 1.0336041 | 1.0287757–1.0384550 |
| sector32-u1/artifact_pimpl | 33,554,432 | 24 | nearby_odd | 100,663,296 | 3,145,727 | 1,951 | 0.0116289 | 0.0111242–0.0121564 |
| sector32-u1/artifact_pimpl | 33,554,432 | 32 | original | 134,217,728 | 4,194,304 | 416 | 0.0024796 | 0.0022525–0.0027295 |
| sector64-u1/artifact_pimpl | 65,536 | 12 | original | 98,304 | 1,536 | 202,384 | 1.2063026 | 1.2010901–1.2115376 |
| sector64-u1/artifact_pimpl | 65,536 | 12 | nearby_odd | 97,856 | 1,529 | 74,133 | 0.4418671 | 0.4387047–0.4450522 |
| sector64-u1/artifact_pimpl | 65,536 | 16 | original | 131,072 | 2,048 | 15,538 | 0.0926137 | 0.0911695–0.0940807 |
| sector64-u1/artifact_pimpl | 65,536 | 24 | original | 196,608 | 3,072 | 12,107 | 0.0721633 | 0.0708898–0.0734598 |
| sector64-u1/artifact_pimpl | 65,536 | 24 | nearby_odd | 196,544 | 3,071 | 1,491 | 0.0088871 | 0.0084473–0.0093497 |
| sector64-u1/artifact_pimpl | 65,536 | 32 | original | 262,144 | 4,096 | 297 | 0.0017703 | 0.0015801–0.0019834 |
| sector64-u1/artifact_pimpl | 33,554,432 | 12 | original | 50,331,648 | 786,432 | 1,155,663 | 6.8882883 | 6.8761797–6.9004166 |
| sector64-u1/artifact_pimpl | 33,554,432 | 12 | nearby_odd | 50,331,584 | 786,431 | 66,182 | 0.3944755 | 0.3914874–0.3974863 |
| sector64-u1/artifact_pimpl | 33,554,432 | 16 | original | 67,108,864 | 1,048,576 | 17,155 | 0.1022518 | 0.1007338–0.1037926 |
| sector64-u1/artifact_pimpl | 33,554,432 | 24 | original | 100,663,296 | 1,572,864 | 229,475 | 1.3677776 | 1.3622309–1.3733466 |
| sector64-u1/artifact_pimpl | 33,554,432 | 24 | nearby_odd | 100,662,976 | 1,572,859 | 1,717 | 0.0102341 | 0.0097614–0.0107297 |
| sector64-u1/artifact_pimpl | 33,554,432 | 32 | original | 134,217,728 | 2,097,152 | 443 | 0.0026405 | 0.0024058–0.0028981 |
| register64-u0/artifact_pimpl | 65,536 | 12 | original | 98,304 | 12,288 | 243,838 | 1.4533877 | 1.4476722–1.4591255 |
| register64-u0/artifact_pimpl | 65,536 | 12 | nearby_odd | 98,304 | 12,287 | 217,458 | 1.2961507 | 1.2907495–1.3015742 |
| register64-u0/artifact_pimpl | 65,536 | 16 | original | 131,072 | 16,384 | 76,549 | 0.4562676 | 0.4530541–0.4595038 |
| register64-u0/artifact_pimpl | 65,536 | 24 | original | 196,608 | 24,576 | 28,149 | 0.1677811 | 0.1658341–0.1697509 |
| register64-u0/artifact_pimpl | 65,536 | 24 | nearby_odd | 196,608 | 24,575 | 17,207 | 0.1025617 | 0.1010415–0.1041048 |
| register64-u0/artifact_pimpl | 65,536 | 32 | original | 262,144 | 32,768 | 6,235 | 0.0371635 | 0.0362526–0.0380973 |
| register64-u0/artifact_pimpl | 33,554,432 | 12 | original | 50,331,648 | 6,291,456 | 466,029 | 2.7777493 | 2.7698966–2.7856236 |
| register64-u0/artifact_pimpl | 33,554,432 | 12 | nearby_odd | 50,331,648 | 6,291,455 | 212,960 | 1.2693405 | 1.2639949–1.2747085 |
| register64-u0/artifact_pimpl | 33,554,432 | 16 | original | 67,108,864 | 8,388,608 | 71,738 | 0.4275918 | 0.4244808–0.4307255 |
| register64-u0/artifact_pimpl | 33,554,432 | 24 | original | 100,663,296 | 12,582,912 | 170,798 | 1.0180354 | 1.0132432–1.0228500 |
| register64-u0/artifact_pimpl | 33,554,432 | 24 | nearby_odd | 100,663,296 | 12,582,909 | 15,497 | 0.0923693 | 0.0909271–0.0938344 |
| register64-u0/artifact_pimpl | 33,554,432 | 32 | original | 134,217,728 | 16,777,216 | 5,075 | 0.0302494 | 0.0294286–0.0310930 |

## Evidence and limits

- Complete raw commit: `f8d1449cb5abb41609b426229bde11f77ad03921`; descriptor SHA `094f0e256662b3341c396436a9397956f0c8bc8f66921f4d3d8acf2ebde08aa3`.
- Frozen accuracy producer: `174081860f588e9a1aef8f2b016ca3c0e6523790`; native binary SHA `4e67b8e0351f574004c0db485ba4883d128dd8906120d49b5b0eacaab781e930`.
- Caller proof `14a5a1cb7d96d41abd62ce05e82dcb29b6a42353` covers native/ASan public calls; geometry proof `11584813b8f300d0405c58d458bbf901c996468b` covers 93 native/AVX2/ASan configurations.
- All 36 processes completed under the socket0 whole-operation lock and CPU2 affinity. All 76 raw artifacts and the raw descriptor were committed byte-exact before this analysis.
- Every build and query timing field is unavailable (`nan`), repeats are zero, and no throughput sample is inferred from command duration.
- These results add a stronger public-constructor baseline capacity choice. They do not replace the earlier original MAGIC results or establish a speed winner. Any performance comparison or fresh-seed extension requires a separately fixed protocol.

Reproduce without executing a filter: `taskset -c 4 python3 experiments/2026-10-29-vldb-nearby-geometry-analysis/summarize.py`.
