# VBMI screen: unchanged mapping, separate timing outcomes

CPU 2, seed 42, 12 workloads × 11 configurations = 132 rows, five repetitions,
2^22 mixed queries and 2^24 independent calibration negatives per insertion set.
The source/binary hashes still match the pre-timing freeze. The four independent
layout variants have identical full-output checksums, FPR counts and allocation.
Repeated calibration across query batches is the same stream, not extra evidence.

Ratios are old/new latency (above one is faster). This first table compares the
explicit single-key shortcuts; their bulk paths also retain the changed mask.
The complete CSV retains both versions without the shortcut too.

| Keys | Actual bits/key | Batch | Pure query | Hash+query | Hash+insert | FPR upper95 |
| --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 | 1 | 1.129× | 1.036× | 1.096× | 0.12959% |
| 65,536 | 16 | 31 | 1.018× | 1.035× | 1.138× | 0.12959% |
| 65,536 | 16 | 4096 | 0.953× | 0.952× | 1.094× | 0.12959% |
| 65,536 | 32 | 1 | 1.149× | 1.011× | 1.022× | 0.00394% |
| 65,536 | 32 | 31 | 1.028× | 1.039× | 1.044× | 0.00394% |
| 65,536 | 32 | 4096 | 0.969× | 0.932× | 1.090× | 0.00394% |
| 33,554,432 | 16 | 1 | 1.097× | 1.041× | 1.045× | 0.13247% |
| 33,554,432 | 16 | 31 | 1.119× | 1.068× | 1.038× | 0.13247% |
| 33,554,432 | 16 | 4096 | 1.129× | 1.021× | 1.039× | 0.13247% |
| 33,554,432 | 32 | 1 | 1.001× | 1.007× | 1.072× | 0.00385% |
| 33,554,432 | 32 | 31 | 1.053× | 1.026× | 1.073× | 0.00385% |
| 33,554,432 | 32 | 4096 | 1.094× | 1.033× | 1.069× | 0.00385% |

For the strict 0.01% FPR ceiling, both actual allocations may compete under 32 bits/key.
These external leaders are selected from this limited FastFilter shortlist,
not the full modern suite. The candidate remains unpromoted; these are exploratory
timings on one seed and do not establish a global or production-library win.

| Keys | Batch | Metric | VBMI ns/key | FastFilter leader | ns/key | External/VBMI |
| --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 1 | lookup_ns | 2.149 | FastFilterSimdBlockSingleV1 | 2.382 | 1.108× |
| 65,536 | 1 | hash_lookup_ns | 4.485 | FastFilterSimdBlockSingleV1 | 4.315 | 0.962× |
| 65,536 | 31 | lookup_ns | 1.304 | FastFilterSimdBlockSingleV1 | 1.345 | 1.031× |
| 65,536 | 31 | hash_lookup_ns | 1.763 | FastFilterSimdBlockSingleV1 | 1.901 | 1.078× |
| 65,536 | 4096 | lookup_ns | 1.308 | FastFilterSimdBlockSingleV1 | 1.221 | 0.933× |
| 65,536 | 4096 | hash_lookup_ns | 1.834 | FastFilterSimdBlockSingleV1 | 1.700 | 0.927× |
| 33,554,432 | 1 | lookup_ns | 11.812 | FastFilterSimdBlockSingleV1 | 12.453 | 1.054× |
| 33,554,432 | 1 | hash_lookup_ns | 19.009 | FastFilterSimdBlockSingleV1 | 18.890 | 0.994× |
| 33,554,432 | 31 | lookup_ns | 7.521 | FastFilterSimdBlock | 8.257 | 1.098× |
| 33,554,432 | 31 | hash_lookup_ns | 7.899 | FastFilterSimdBlockSingleV1 | 8.205 | 1.039× |
| 33,554,432 | 4096 | lookup_ns | 7.216 | FastFilterSimdBlockSingleV1 | 8.042 | 1.114× |
| 33,554,432 | 4096 | hash_lookup_ns | 6.713 | FastFilterSimdBlockSingleV1 | 7.375 | 1.099× |
