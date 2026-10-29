# Independent32Range fixed accuracy results

The prespecified primary candidate at actual 12 bpk passes the 1% pointwise Wilson upper gate at both tested sizes. Its upper endpoints are 0.5352863% and 0.5567636%. The secondary 20 bpk/.1% and 28 bpk/.01% targets also pass at both sizes. No speed was measured, and this result does not establish a singleton or bulk performance improvement.

All 16 fixed constructions completed in session 45312 with exit 0. Raw evidence is committed at `344b72c14c2be92920d671ab01765ae9121f971f`; `ACCURACY_ARCHIVE.json` binds the complete raw outputs, metadata, decision, launcher log and actual terminal result. Source 779530e6 and the unchanged normal worker binary e047bc89 were used after committed proof 0aea62ad. CPU3/socket1 was released after completion.

This is seen seed 42, n=65,536 and 33,554,432, with one complete real-n insertion per filter and 2^26=67,108,864 disjoint negative probes per row. All inserted answers, all 4096 mixed outputs (2050 positive/2046 negative), public bulk/singleton equality, output guards, input/bitmap immutability, actual allocation and line bounds passed. The worker has no timers.

Each upper endpoint uses the two-sided 95% Wilson formula, z=1.959963984540054. Thresholds are 1%, 0.1%, 0.01%; equality qualifies. No seed, geometry, alias or old/new mapping denominator is pooled. These rows share source inputs, so they are separate mapping/geometry observations, not independent statistical evidence.

| Keys | Filter | Actual bpk | Backing bytes | False positives / 67,108,864 | Upper FPR (%) | 1% | 0.1% | 0.01% |
|---:|---|---:|---:|---:|---:|:---:|:---:|:---:|
| 65,536 | Range candidate | 12 | 98,304 | 358,053 | 0.535286312 | pass | fail | fail |
| 65,536 | Range candidate | 16 | 131,072 | 86,176 | 0.129271912 | pass | fail | fail |
| 65,536 | Range candidate | 20 | 163,840 | 27,873 | 0.042024369 | pass | pass | fail |
| 65,536 | Range candidate | 24 | 196,608 | 10,780 | 0.016369536 | pass | pass | fail |
| 65,536 | Range candidate | 28 | 229,376 | 4,493 | 0.006893733 | pass | pass | pass |
| 65,536 | Range candidate | 32 | 262,144 | 2,274 | 0.003530685 | pass | pass | pass |
| 65,536 | Old power-of-two control | 16 | 131,072 | 91,057 | 0.136569067 | pass | fail | fail |
| 65,536 | Old power-of-two control | 32 | 262,144 | 2,496 | 0.003868129 | pass | pass | pass |
| 33,554,432 | Range candidate | 12 | 50,331,648 | 372,443 | 0.556763569 | pass | fail | fail |
| 33,554,432 | Range candidate | 16 | 67,108,864 | 88,342 | 0.132510190 | pass | fail | fail |
| 33,554,432 | Range candidate | 20 | 83,886,080 | 30,782 | 0.046383913 | pass | pass | fail |
| 33,554,432 | Range candidate | 24 | 100,663,296 | 12,555 | 0.019038498 | pass | pass | fail |
| 33,554,432 | Range candidate | 28 | 117,440,512 | 5,821 | 0.008899663 | pass | pass | pass |
| 33,554,432 | Range candidate | 32 | 134,217,728 | 2,503 | 0.003878764 | pass | pass | pass |
| 33,554,432 | Old power-of-two control | 16 | 67,108,864 | 88,496 | 0.132740423 | pass | fail | fail |
| 33,554,432 | Old power-of-two control | 32 | 134,217,728 | 2,465 | 0.003821027 | pass | pass | pass |

Candidate 16 fails the 0.1% gate at both sizes; candidate 24 fails the 0.01% gate at both sizes. These failures remain alongside all other points. The old 16 controls also fail 0.1%, while old 32 controls pass 0.01%. Equal bytes do not imply equal bitmaps: the new high24 multiply reduction and old high23 mask select different address mappings at these pilot capacities, including equal power-of-two byte sizes.

The primary 12 bpk point was fixed before observation and was not replaced by any successful secondary point. Its exact backing is 98,304 bytes at the small size and 50,331,648 bytes at the large size. The primary stop condition did not trigger; the decision remains `separate_timing_source_review_required`, with `timing_authorized=false`. Any speed stage requires the separately reviewed finite caller/ledger, actual caller proof and explicit lease; no capacity, probe count, address partition or seed was retuned.
