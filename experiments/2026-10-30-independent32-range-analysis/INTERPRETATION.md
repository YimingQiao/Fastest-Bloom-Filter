# Independent32Range216: retain as an experiment

The prespecified large-table gap criterion was **not met**: candidate12 won 15 of 32 required comparisons and lost 17. Keep the candidate experimental. The useful result is a bounded large-table visible-singleton gain; it does not establish the intended singleton-and-bulk improvement over both retained rival groups.

The complete panel contains 18 API/geometry points, 216 rows, 24 processes and 4608 trial values. It uses n=2^16/2^25, q=2^22, hit 50%, batches 1/31/4096, eight trials, two previously seen construction seeds and two reverse launch rounds. Comparisons below select the fastest eligible rival separately in each seed/round cell. Ratios are candidate/rival latency: below 1 is faster. The ceiling is actual 16 bpk with a pointwise95% Wilson upper bound no greater than 1% in both seeds. All 18 points qualified; no missing rival or quality failure explains a loss.

Across all 128 per-cell comparisons, candidate12 was faster 30 times and slower 98. Each rival group contributed 15 faster and 49 slower outcomes. The separately retained descriptive four-cell geometric-mean leader comparisons have the same 30/98 outcome count; they are not independent confirmation or a substitute for the per-cell rivals.

At n=2^16, candidate12 lost all 64 comparisons, including every singleton and bulk contract, to both rival groups. Its bitmap is 96 KiB versus 128 KiB for the production controls, but this footprint reduction did not produce a query win in this panel.

At n=2^25, candidate12 uses 48 MiB versus 64 MiB for production. The retained external rival is Boost192Multi32K8 with 50,331,647 bytes of actual backing—one byte below 48 MiB. The strongest production rival varies by contract. Large-table visible results are:

| Batch 1 contract | Fastest eligible rival | Faster / slower | Four-cell candidate/rival latency range |
|---|---|---:|---:|
| Visible pure query | Boost192Multi32K8 | 4 / 0 | 0.935433–0.972242 |
| Visible fused common-hash+query | Boost192Multi32K8 | 4 / 0 | 0.957817–0.995860 |
| Visible pure query | ByteSplitBloomFilter | 3 / 1 | 0.963364–1.009846 |
| Visible fused common-hash+query | ByteSplitBloomFilter | 4 / 0 | 0.834963–0.884824 |

Thus the two visible contracts won all 8 external comparisons and 7 of 8 production comparisons. The separate generic singleton contracts still lost all 8 external comparisons: pure ratios 1.072832–1.119046 and staged common-hash ratios 1.046782–1.070893. Against production they split 4 faster/4 slower. Public calling shape therefore remains material; a visible-loop result cannot be substituted for the opaque generic contract.

Large batch 4096 lost all 16 comparisons. Against Boost, pure latency ratios were 1.149908–1.165323 and staged hash+query 1.071694–1.096572. Against FastPatternBF, they were 1.297078–1.329062 and 1.059900–1.102476 respectively. These 16 bulk losses plus the one visible-production loss account for the 17 failures of the 32-comparison criterion. Large batch 31 was mixed: 7 faster/1 slower against external and 4 faster/4 slower against production; its complete cells remain in the report.

The unconditional native controls remain separate from strongest-rival claims. Candidate16 versus equal-byte oldIndependent32 and the four production layouts records 118 faster/202 slower comparisons. Candidate12 versus the six larger-footprint native controls records 240 faster/144 slower. All 320 equal-byte and 384 footprint comparisons, including their eligibility flags and every loss, remain in `report-v2/controls.json`.

All 36 API-by-seed calibration records remain, with 180 exact reuse links and 34 known mapping groups after only the proved FastFilter alias. Denominators are not pooled and these groups are not asserted to be statistically independent. Candidate12's four pointwise Wilson upper bounds range from 0.539661% to 0.557905%, below the prespecified 1% threshold. The report retains every raw count, digest, quality record, 576 timing vectors and 288 round comparisons. Calibration ran only in round 1/batch 1; rounds also differ in process/environment history, so their differences do not isolate order causality. The seeds were already seen in earlier C++ work, and this finite panel does not support a same-data global winner claim.

The first complete-loader attempt failed before reading raw data because its caller-source inventory rejected the already proof-archived additive `seal.py`. The original loader and exact failed logs are preserved in commits f692681 and 00b9211. The reviewed sibling repair 515f6c0 verifies the complete proof first and permits only that exact proof-bound caller file. Calculation, producer, binaries, raw 66168c56 and anchor 9cc5517 stayed unchanged. One offline retry completed successfully; no filter, calibration or benchmark was rerun. Root's independent arithmetic audit also passed exact coverage and all numerical comparisons; its unchanged source, actual terminal result and stdout are archived under `audit/`.

This evidence contains no construction-time, Rust or multithread result. It supports neither default integration nor a broader external-leadership claim.

