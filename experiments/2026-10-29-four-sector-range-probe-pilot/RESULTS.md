# Fixed range probe-count accuracy results

Only K12 among the new variants meets the 24-bpk / 0.01% upper-bound gate at both sizes. K9 fails both; K10 passes only at 65K keys. This one-seed scalar pilot has **no performance result**. The original K8 failure remains unchanged.

The committed source is `685782fa446deda8129c0bfb09fce8bdc069cfb9`; compiled/correctness evidence is `deccc70f5600a174e43407bc26708849ace3a9fa`. The first fixed calibration run exited zero under the CPU2/socket0 lock. All 24 rows, full inserted-key checks, guarded dense answers and exact bytes passed. Six K8 counts/checksums exactly replay the prior pilot.

Each entry uses 16,777,216 disjoint negatives, seed 42, the fixed prior counter domain and a pointwise two-sided 95% Wilson interval. Repeated mappings are not pooled. These are not simultaneous guarantees or held-out confirmation.

| Actual bpk | K | 65K false positives | 65K upper FPR | 32M false positives | 32M upper FPR | 0.01% at both |
|---:|---:|---:|---:|---:|---:|:---:|
| 16 | 8 | 15723 | 0.095192027% | 16313 | 0.098735892% | no |
| 16 | 9 | 17112 | 0.103534351% | 17463 | 0.105642042% | no |
| 16 | 10 | 18452 | 0.111579983% | 18723 | 0.113206860% | no |
| 16 | 12 | 20653 | 0.124790779% | 21524 | 0.130017311% | no |
| 24 | 8 | 1694 | 0.010589407% | 1749 | 0.010924973% | no |
| 24 | 9 | 1619 | 0.010131613% | 1712 | 0.010699243% | no |
| 24 | 10 | 1546 | 0.009685784% | 1656 | 0.010357489% | no |
| 24 | 12 | 1496 | 0.009380276% | 1543 | 0.009667457% | yes |
| 32 | 8 | 316 | 0.002102937% | 329 | 0.002184645% | yes |
| 32 | 9 | 284 | 0.001901424% | 286 | 0.001914036% | yes |
| 32 | 10 | 267 | 0.001794124% | 284 | 0.001901424% | yes |
| 32 | 12 | 199 | 0.001362776% | 198 | 0.001356402% | yes |

At 16 bpk, K8 passes 0.1% at both sizes; every new variant fails it. At 32 bpk all four pass 0.01%. The old three-bit dictionaries therefore improve the targeted 24-bpk accuracy while making the 16-bpk result worse. No threshold or dictionary was adjusted after observing the data.

K12 keeps four word accesses and uses one active 64-byte mask table. That permits preparation of an isolated vector implementation, but does not prove its generated instructions or speed. The AVX2 arithmetic mask shortcut is specific to K8 and cannot be reused unchanged. Any vector candidate needs full scalar parity and its own frozen performance protocol against eligible native and external public APIs. Fresh-seed confirmation is required before promotion.

[All 24 original rows](accuracy-v1/calibration.stdout), [all quality bounds and gates](accuracy-v1/quality.json), [commands and compiled inputs](accuracy-v1/metadata.json), [raw hash inventory](accuracy-v1/archive.json).
