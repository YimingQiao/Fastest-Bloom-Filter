# SingleLine interpretation

The one-body simplification is a useful K12 improvement candidate. It wins85 of96 query comparisons against original K12, including all48 visible-loop comparisons and every staged batch1/3 comparison. It is not a replacement for Split64Range across workloads: Range still wins every singleton, visible-loop and construction comparison in this screen. No production integration or external-leadership claim follows from this internal result alone.

All24 commands and72 rows were sealed in raw commit `49298ee5386d4fc639cf8cbc773bcdc8e4bec2d1` before interpretation. The normal executable was unchanged from its passed normal/ASan actual-caller proof. The three seeds are seen Rust108 constructions; there was no fresh calibration, allocation search, extra hint or routing variant.

## Gains and regressions against original K12

At64K keys, visible prehashed old/new ratios span1.42355–1.45778 and fused ratios1.31105–1.33123. At32M keys, they span1.27244–1.28336 and1.18682–1.20674. These are latency ratios, equivalently throughput factors for the identical query counts, not percentage reductions in latency or significance claims. The visible whole-array contract does not depend on its batch tag.

Batch1 improves both staged contracts on all seeds: small pure1.32232–1.32595 and common-hash1.18120–1.18360; large pure1.09393–1.09968 and common-hash1.07707–1.10849. Batch3 also improves all seeds: small pure1.44687–1.44713/common-hash1.30775–1.31006, and large pure1.22591–1.22872/common-hash1.16187–1.16656.

The complete regression set remains material. Small batch31 loses all six staged comparisons, with old/new ratios0.99387–0.99736 pure and0.99184–0.99446 common-hash. Large batch31 gains are small (1.00126–1.00416 and1.00572–1.01220). At batch4096, small pure wins1/3 and common-hash2/3; large pure and common-hash each win2/3. The overall4096 ratios span0.99240–1.01042. This does not support a claim of universal bulk improvement or exact parity.

Insertion bodies and allocation policies are unchanged. The49 construction wins and47 losses against original K12 include wide small-table allocation-inclusive variation; the minimum old/new allocate+hash+insert ratio is0.77374. Actual timings and row positions remain available. Because this one scalar query-body change can affect compilation/layout and allocations occur sequentially, those differences cannot be attributed to a new build algorithm. Stored build medians have no per-trial vectors and provide no basis for invented confidence intervals.

## Range remains the stronger general control here

SingleLine wins21/96 query comparisons against Range, all in the staged-query contracts: small batch31/4096 and large batch31 both contracts, plus large4096 common-hash. Large4096 pure still loses on every seed; its Range/new ratio is0.98519–0.99339. Large4096 common-hash margins are only1.00139–1.01946, so these observed wins are not an all-environment or statistical-superiority claim.

Every batch1/3, visible pure/fused and all96 construction comparisons still lose to Range. For example, small visible fused Range/new ratios are about0.465–0.467, and large visible prehashed ratios about0.453–0.462. The K12 scalar simplification reduces its own overhead but does not close that algorithm/API gap. There is no new external library measurement in this screen.

## What was isolated, and what remains coupled

The source change is exactly one safe line borrow followed by four in-line word accesses. Original ordinary public/private inline hints, masks, addressing, feature dispatch, allocation and insertion are preserved. The actual compiler now expands the successful singleton chain and emits one global line bounds check. Body simplification and the compiler's changed inline decision occur together, so their separate causal contributions are not identified.

All visible callers still save six registers; the candidate fused frame is104B versus72B, and its public batch function is larger. The proof and this screen retain these costs. Original and candidate share bitmaps and full outputs in focused normal/ASan tests; formal rows reproduce the prior construction's mixed counts/checksums. The12 historical quality contexts are unpooled, and the candidate is an alias, not extra independent quality evidence.

Candidate row positions cover first/middle/last at each size, and every pair appears in both directions, but pair counts are2:1. All384 order-stratified summaries remain in the archive. The result supports considering this exact safe body simplification for the optional K12 implementation, with its mild staged regressions and all Range losses explicitly retained; any actual native packaging still requires an exact-port proof. No further variant was selected or implemented after these measurements.
