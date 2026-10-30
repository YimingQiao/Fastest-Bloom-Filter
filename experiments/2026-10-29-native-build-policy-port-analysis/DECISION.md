# Decision: retain this policy as an experiment

Do not merge this bounded build policy as the default native behavior. All48 gate-active comparisons improve, but56 of112 outside-gate comparisons regress, including15 exact geometry/contract groups that regress with both retained seeds. These observations do not establish a deterministic slowdown in every losing cell, nor do correctness and identical worker requests establish an outside-gate performance guarantee. Keep the policy experimental pending a fixed negative-control study.

The fixed96 paired cases cover both C++ and Rust, Split64 and Split64Range, requested4/8, six scenarios and seen seeds74381/164321. Each contract has four balanced control/candidate trials, with one separately recorded serial reference. This is actual-native before/after code in one binary per language. No old wrapper latency is imported, and no scenario or threshold was changed after measurement.

The active gate is current insertion length≤65,536 and actual bitmap≤256KiB. Across the retained active individual records, C++ control/candidate ratios range2.6062–5.7384× and Rust2.3325–5.3611×. These are ranges across explicit cases, not pooled estimates. Empty insertion, empty allocation+insertion and populated-hotspot insertion all improve; full individual records and four-trial vectors remain in report/.

The mandatory Rust Split64 65,537-key/256KiB/T8 allocation+insertion boundary is slower with both seeds:0.986963× and0.880514× control/candidate, approximately1.32% and13.57% higher candidate latency. Range at the same boundary has one gain and one loss,1.114572× and0.932230×. Every other outside-gate cell remains included; the decision does not select only this known boundary.

## Every outside-gate group slower with both seeds

Ratios are control/candidate; below1 means the candidate is slower. Each row holds language/family/scenario/T/contract fixed. The two columns are descriptive observed ratios, not confidence intervals or independent statistical significance tests.

| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |
|---|---|---|---:|---|---:|---:|
| cpp | Split64 | above_batch_empty_uniform | 4 | insert | 0.819641 | 0.970791 |
| cpp | Split64 | above_batch_empty_uniform | 8 | insert | 0.977973 | 0.975850 |
| cpp | Split64 | above_bytes_empty_uniform | 8 | allocate_insert | 0.906550 | 0.975086 |
| cpp | Split64Range | above_bytes_empty_uniform | 4 | insert | 0.977006 | 0.865473 |
| cpp | Split64Range | above_bytes_empty_uniform | 8 | insert | 0.935671 | 0.978662 |
| cpp | Split64Range | large_prefilled_hotspot | 8 | insert | 0.987201 | 0.980693 |
| rust | Split64 | above_batch_empty_uniform | 4 | allocate_insert | 0.878053 | 0.970375 |
| rust | Split64 | above_batch_empty_uniform | 4 | insert | 0.922965 | 0.985181 |
| rust | Split64 | above_batch_empty_uniform | 8 | allocate_insert | 0.986963 | 0.880514 |
| rust | Split64 | large_empty_uniform | 8 | insert | 0.980570 | 0.999676 |
| rust | Split64 | large_prefilled_hotspot | 8 | insert | 0.933492 | 0.976484 |
| rust | Split64Range | above_batch_empty_uniform | 4 | allocate_insert | 0.958394 | 0.982075 |
| rust | Split64Range | above_batch_empty_uniform | 4 | insert | 0.994368 | 0.972154 |
| rust | Split64Range | above_bytes_empty_uniform | 8 | insert | 0.982976 | 0.922908 |
| rust | Split64Range | large_empty_uniform | 8 | allocate_insert | 0.992945 | 0.995504 |

The counts alone are not evidence that15 groups have deterministic regressions. Under a simple independent symmetric-sign noise model,56 outside-gate two-seed groups would yield14 groups with two losses on average;15 is close to that expectation. This is a descriptive reference, not a valid fitted significance test: neighboring cases, fixed order and shared execution conditions can be dependent. A no-change A/A control and prespecified higher-repeat confirmation are needed to separate policy overhead from thread/startup and code-layout variability.

The largest single outside-gate loss is C++ Split64 above-batch/T4 insertion at0.819641× (approximately22.00% more latency); the same cell is0.970791× at the other seed. The full report also preserves outside-gate gains and every nonrepeated loss. This run does not isolate code placement, public-call overhead, thread scheduling or cache state as the cause. None is assumed away as noise.

## Serial overhead and scope

Within the active gate, the candidate is slower than its same-row direct serial reference in23/24 C++ and13/24 Rust records. The observed candidate/serial latency ranges are0.9937–1.1164 for C++ and0.8477–1.4230 for Rust. Rust Range small-empty/T4 allocation+insertion is1.4103/1.4214 times its reference latency. Serial always occupies the first/last position, so this comparison includes a disclosed order limitation; the reference is never duplicated as independent samples.

Single-worker dispatch still uses the real public native call, and its actual gate/prologue is inside the clocks as proven by the frozen assembly. Query code is unchanged and query timing is outside this study. Each language is compared only to itself; no external or cross-language leadership claim is supported. The populated cases expose incremental insertion only; setup and destruction remain outside clocks.

Keep the experimental native branch and complete evidence. A future implementation or order/seed confirmation needs a separate fixed protocol; this result does not justify altering the threshold or excluding large-bitmap short batches. The independently validated optional Range API can be considered separately from this rejected default worker-policy change.

Raw commit `df0d132515d63f141d5de2b47dbabfcf0f7fb845`; analysis source `521be76ff52d3c063b0af02d6dd854f23e571211`. All196 raw artifacts, exact commands, complete outputs,349 source/proof pins,8 binaries and470 consumed compiler inputs passed the frozen run/audit. The analysis retains160 pairs,320 arm/reference comparisons,480 timing vectors,288 setup records and80 exact-geometry seed ranges.
