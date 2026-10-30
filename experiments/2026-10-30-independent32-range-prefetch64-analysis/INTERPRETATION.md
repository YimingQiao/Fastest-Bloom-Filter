# Prefetch64: useful large-bulk control gains, primary target not met

The fixed64-entry pipeline improves its exact non-prefetch control in all eight required large-table bulk comparisons, but **does not meet the prespecified target against both rival groups**. The primary 24 contains 16 faster and 8 slower outcomes: control 8/0, external 4/4, production 4/4. Keep this version experimental; no default integration or general superiority follows.

This is one fixed distance 64/threshold 128 variant, measured in 24 processes/192 rows at n=2^16/2^25, q=2^22, hit 50%, batches 1/31/4096 and eight trials. Two previously seen construction seeds each run in both launch/API orders. Pipeline and control have identical 96 KiB/48 MiB bitmaps. Actual backing no greater than 16 bpk and a pointwise 95% Wilson upper bound no greater than 1% in both seeds qualify rivals. All 16 points passed, so the missing primary wins are timing losses, not missing qualifiers.

Large batch 4096 is the primary scope. Ratios below are pipeline/rival latency; below 1 is faster. Each row retains all four seed/round cells.

| Contract | Rival | Faster / slower | Latency ratio range |
|---|---|---:|---:|
| Prehashed generic query | Exact range12 control | 4 / 0 | 0.873698–0.912530 |
| Staged common-hash+query | Exact range12 control | 4 / 0 | 0.875309–0.911655 |
| Prehashed generic query | Boost192Multi32K8 | 0 / 4 | 1.029325–1.060077 |
| Staged common-hash+query | Boost192Multi32K8 | 4 / 0 | 0.986833–0.997555 |
| Prehashed generic query | FastPatternBF | 0 / 4 | 1.156487–1.186146 |
| Staged common-hash+query | Fastest production rival per cell: FastPatternBF or FourSectorBloomFilter | 4 / 0 | 0.981911–0.992428 |

The pipeline reduces large-bulk latency about 8.7–12.6% against the unchanged range control. However, prehashed query still loses about 2.9–6.0% to Boost and 15.6–18.6% to the production leader. Staged hash+query wins all eight external/production comparisons, with only 0.24–1.81% lower latency. These are distinct contracts; the staged win cannot substitute for a prehashed win. Boost's actual backing is 50,331,647 bytes, one byte below 48 MiB; the production layouts use 64 MiB.

Across all 128 per-cell rival comparisons, the pipeline records 35 faster and 93 slower outcomes: external 19/45, production 16/48. The descriptive four-cell fixed-leader pairs also total 35/93; they remain separate same-data selections. All 64 small-table rival comparisons lose. The complete small/large, batch and mode breakdowns—including rival identities—remain in `report-v1/REPORT.md`, `envelopes.json` and `interpretation/summary.json`.

All 64 unconditional pipeline/control ratios are preserved, totaling 19 faster/45 slower: small 7/25 and large 12/20. Small batch 4096 loses all eight control comparisons, with pure latency 3.72–4.21% higher and staged latency 1.83–3.56% higher. The 16 generic-singleton control comparisons also all lose, even though their short-call path does not execute the pipeline. Small generic-singleton pure latency rises 14.33–14.69%; its staged counterpart rises 5.27–6.39%. Large generic-singleton losses remain smaller but consistent in all eight cells. Batch 31 direct controls are mixed, 5 faster/11 slower. Visible singleton direct controls are also mixed, 6 faster/10 slower; their retained rival wins do not demonstrate a benefit from a bulk path that was not taken.

The actual caller proof records queue stack setup before the generic batch-size branch in both native and AVX2 code, while the unchanged range control has a different generated body. Thus an unchanged short-query source branch does not promise unchanged machine-code cost. The result measures the complete queue/dispatch/generated-code change, including repeated input-hash reads and queue work; it does not isolate prefetch causality or measure hardware miss concurrency.

Round sensitivity remains explicit. Of 32 same-seed direct-control condition pairs, seven change faster/slower direction between rounds; all seven concern singleton or batch 31. Of 64 per-cell rival condition pairs, one flips outcome: large visible-fused singleton versus external for seed 982451653, slower in round 1 and faster in round 2. The same one flip appears in the fixed-rival pairs. Ten per-cell rival identities change between rounds. No required large4096 comparison changes direction. Full ratio pairs and identities are retained; these counts describe the observations rather than independent significance. Calibration occurs only in round 1/batch1, and process/environment history also differs, so the round differences cannot isolate order effects.

All 32 API-by-seed calibration records and 160 strict reuse links remain, with 26 known mapping groups after only the proved pipeline/control and FastFilter aliases. Every case checks shared insertion/bitmap/query fingerprints; fresh calibration counts also agree for the aliases. The pipeline's four Wilson upper bounds range from 0.539661% to 0.557905%. Denominators are never pooled, and known mapping groups are not declared statistically independent. Counts were recorded again in this execution using seen seeds and deterministic streams; this is not fresh-seed or unseen-negative confirmation.

The first formal run completed successfully and its full raw/log/actual terminal evidence is committed in 32ef108. The separately committed anchor 52e9967 fed frozen loader ba2c6f2 once; its first offline run also completed successfully as session 50841. Root's independent audit 74615f recomputed exact product coverage and all 32 quality records/26 groups,512 vectors/4096 samples,512 alternatives,128 per-cell and128 fixed pairs,64 controls,256 round pairs and24 primary comparisons. The unchanged audit source 0c6d8d9, actual terminal result and stdout are preserved under `audit/`; neither data nor audit was rerun for this archive.

This is a C++ query-only experiment. It provides no build, Rust, multithread, automatic-promotion or global-winner result.

