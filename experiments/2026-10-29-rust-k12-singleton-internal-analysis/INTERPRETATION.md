# Rust SIMD singleton: complete internal comparison

The fixed experiment supports a substantial improvement for batches 1 and 3 within both Rust compilation profiles. Every one of the 112 tiny-query contrasts in each profile favors the candidate, including hit rates of 0/50/100%, both sizes, two seeds and both opposite-order rounds. Larger batches retain 21 slower observations in the native profile and 13 in portable. This is an internal comparison against the original safe SingleLine K12, with no external leadership or production promotion claim.

All ratios below are **candidate latency / control latency**; below 1 is faster. Counts describe repeated fixed observations, not independent experiments or a pooled win probability. Native and portable comparisons are reported separately and are not ranked against one another; their shared inputs do not establish independent evidence.

| Profile | Batch | Faster / slower / ties | Observed ratio range |
|---|---:|---:|---:|
| Native | 1 | 96 / 0 / 0 | 0.436546–0.729158 |
| Native | 3 | 16 / 0 / 0 | 0.480144–0.679271 |
| Native | 31 | 5 / 11 / 0 | 0.953927–1.029520 |
| Native | 4096 | 6 / 10 / 0 | 0.971863–1.025721 |
| Portable | 1 | 96 / 0 / 0 | 0.511751–0.820001 |
| Portable | 3 | 16 / 0 / 0 | 0.501424–0.621705 |
| Portable | 31 | 11 / 5 / 0 | 0.972731–1.016792 |
| Portable | 4096 | 8 / 8 / 0 | 0.973099–1.030662 |

The table ranges include all applicable contracts, sizes, seeds and rounds within each row. They are descriptive extrema, not confidence intervals. The complete [generated report](report-v1/REPORT.md) keeps all 72 separate profile/size/hit/batch/contract ranges and explicitly lists all 34 slower observations; [pairs.csv](report-v1/pairs.csv) retains all 288 comparisons. Batches 31/4096 have only the two generic contracts; visible whole-array contracts are measured at batch 1.

## Public singleton contracts remain separate

Every entry below contains 24 observations: two sizes × three hit ratios × two seeds × two rounds. Each of these observations favors the candidate.

| Profile | Batch 1 contract | Candidate/control ratio range |
|---|---|---:|
| Native | Visible prehashed | 0.436546–0.575236 |
| Native | Visible fused common hash + query | 0.445600–0.468157 |
| Portable | Visible prehashed | 0.511751–0.709864 |
| Portable | Visible fused common hash + query | 0.556748–0.595432 |

The generic batch 1 comparisons are included in the first table and the complete per-contract artifacts; their values are not substituted for visible public calls. Prehashed and hash+query results never share a selected minimum. These are latency ratios, not percentages of throughput gained.

## Bulk regressions and order sensitivity

The largest native slowdown is small-size batch 31 hash+query, ratio 1.029520; the largest portable slowdown is small-size batch 4096 prehashed, ratio 1.030662. Both are retained. Native large-size batch 31 is slower in 7/8 observations; its hash+query path is slower in all four seed × round points, ratios 1.002461–1.015101. Portable large-size batch 31 instead improves in all 8 observations, ratios 0.972731–0.983390. This disagreement is another reason to retain profile separation and both generic contracts.

There are 22 same-input direction changes between the opposite rounds: native batch 31 five and batch 4096 six; portable batch 31 three and batch 4096 eight. No batch 1/3 comparison changes direction. All 144 same-input round sensitivities, each arm's round 2/round 1 ratio and all 72 four-point seed × round ranges remain in their CSVs. Round 2 reverses process and API order, but it also occurs later; the experiment does not identify order as the sole cause of a change. It does not establish that a small positive or negative bulk difference is statistically significant. Batch 31 at q=2^22 has remainder 4 and does not enter a new 1–3-key tail.

## Code generation and scope

The [rebuilt actual-caller proof](../2026-10-29-rust-k12-singleton-internal-plan/caller/proof-final/REPORT.md) governs interpretation. Native visible loops inline the checked-line SIMD body, while portable retains a per-key public facade call and a target-feature tail jump. Both profiles and both arms include an outlined 412-byte `timed_work` wrapper once per whole query phase inside the clocks. Native visible frames remain 72/104 bytes; portable visible frames remain 72 bytes. Inlining, target boundaries, frame pressure and body expansion are coupled compiler decisions; the observed gain is not attributed solely to one vector instruction.

The fixed scope is actual 24 bits/key, n=2^16/2^25, q=2^22, two fresh seeds and two rounds with opposite launch/API order, with eight samples per query vector. No new calibration, construction timing, multithread test or external baseline was measured. Full bitmap/public-output correctness comes from the bounded proof and each producer lifetime's validation; this comparison does not estimate a new false-positive rate. Older C++/Rust latencies are not imported. A useful next decision may consider this tiny-query improvement together with the explicitly observed bulk tradeoffs, but this report makes no global or across-workload promotion claim.

## Complete provenance

Producer `5c679ae126854586f52cea6bd17a385ae0bd29c6` completed once as actual session 73927 with exit 0. Commit `f8662cc9d28bd44b3fc3e5228cdf11a590f94bf7` contains all 194 raw artifacts, the raw manifest, complete 97-line launcher log and exact terminal tool result. The unchanged predata calculation `55571389d14fe178bdc3f9f00fd630c9c11ac98c` was loaded through `1867e7a313263fa5dec34583a414935a0de530e8` only after that commit. Its one successful offline execution retained stdout/stderr and generated 288 pairs, 576 vectors, 4608 values, 144 round sensitivities and 72 ranges. The source binding's historical `complete_raw_available=false` records that it was frozen before data; the separately verified `raw_anchor.complete=true` and actual terminal evidence identify this completed run.
