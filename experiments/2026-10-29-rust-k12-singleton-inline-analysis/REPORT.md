# Rust K12 two-hint internal screen: retain as experiment

The fixed72-row screen does **not support promoting this two-hint change**. The actual public singleton chain is expanded, but its visible gains are modest and several staged/bulk contracts regress. The unchanged Split64Range control still wins every batch1/3, visible-query and construction comparison. No production code was changed.

All24 commands completed in one measurement session onCPU3 under the whole socket1 flock. The three seeds were already observed in Rust108; this is an internal code-generation/regression comparison, not fresh validation against external libraries. Source `d86e8d3ada25df6078f2fba6af5230e3d1e2695c`, complete raw `a081228155453078e5cfedcd568538553a707ee6`, executable SHA `2e57bbfae905d3c0d9b3281217a98e5db8a592fa8fe988730d0dd5128cff9cf5`. Raw52 files plus manifest were committed before numerical interpretation. Every actual payload is24 bits/key; all three filters run in the same process per case.

## All comparisons retained

The tables show the minimum–maximum ratio across all three seeds, followed by win/loss counts. Ratio=rival latency/candidate latency; **greater than1 favors the denominator (candidate named in that row)**. The eight samples within each query-trial vector, full minima/maxima and individual losses remain in `report/pairs.csv`. There are576 named pairs,192 three-seed condition groups,384 pair-order strata and144 staged/visible API ratios.

| Rival / candidate | Query win/loss/tie (96) | Build win/loss/tie (96) |
|---|---:|---:|
| Original K12 / two-hint K12 | 63/33/0 | 40/56/0 |
| Split64Range / two-hint K12 | 19/77/0 | 0/96/0 |
| Split64Range / original K12 | 19/77/0 | 0/96/0 |

### Original K12 / two-hint K12: query contracts

| Keys / batch | Staged prehashed | Staged common-hash+query | Visible prehashed | Visible fused common hash |
|---|---|---|---|---|
| 64K / 1 | 1.00569–1.00674 (3/0) | 0.97463–0.97649 (0/3) | 1.03994–1.04519 (3/0) | 1.01036–1.01359 (3/0) |
| 64K / 3 | 1.06218–1.06411 (3/0) | 1.03898–1.03937 (3/0) | 1.04190–1.04496 (3/0) | 1.00988–1.01198 (3/0) |
| 64K / 31 | 0.98667–0.99727 (0/3) | 0.98088–0.98202 (0/3) | 1.04054–1.04337 (3/0) | 1.01011–1.01141 (3/0) |
| 64K / 4096 | 0.99820–1.00036 (1/2) | 0.99840–1.01131 (2/1) | 1.04202–1.04363 (3/0) | 1.00945–1.01065 (3/0) |
| 32M / 1 | 0.99540–1.00402 (1/2) | 0.99757–1.00605 (1/2) | 0.99525–1.00523 (1/2) | 1.00796–1.00897 (3/0) |
| 32M / 3 | 1.01382–1.01762 (3/0) | 1.02647–1.03086 (3/0) | 0.99282–0.99784 (0/3) | 1.00221–1.01002 (3/0) |
| 32M / 31 | 1.00053–1.00742 (3/0) | 1.00363–1.01184 (3/0) | 0.98893–1.01389 (1/2) | 0.99732–1.01497 (2/1) |
| 32M / 4096 | 0.96034–0.96683 (0/3) | 0.99462–0.99991 (0/3) | 0.99385–0.99719 (0/3) | 1.00346–1.00732 (3/0) |

Small-table visible prehashed ratios are1.03994–1.04519 and fused ratios1.00945–1.01359 across all batch tags. Batch3 improves both staged contracts at both sizes. However, small batch1 common-hash+query loses on all three seeds, small batch31 loses both staged contracts on all seeds, and large batch4096 loses both staged contracts on all seeds (pure ratio0.96034–0.96683). Large visible prehashed results are mixed or losing; the fused changes are mostly around1%. These are descriptive ratios, not significance claims. The visible whole-array loop contract is unchanged by its batch tag.

### Split64Range / two-hint K12: query contracts

| Keys / batch | Staged prehashed | Staged common-hash+query | Visible prehashed | Visible fused common hash |
|---|---|---|---|---|
| 64K / 1 | 0.41978–0.42026 (0/3) | 0.48943–0.49004 (0/3) | 0.41059–0.41334 (0/3) | 0.36831–0.36904 (0/3) |
| 64K / 3 | 0.33724–0.35579 (0/3) | 0.43167–0.43417 (0/3) | 0.41033–0.41219 (0/3) | 0.36741–0.36926 (0/3) |
| 64K / 31 | 1.13208–1.14539 (3/0) | 1.02029–1.02270 (3/0) | 0.41093–0.41227 (0/3) | 0.36750–0.36982 (0/3) |
| 64K / 4096 | 1.40110–1.40837 (3/0) | 1.28629–1.30837 (3/0) | 0.41069–0.41194 (0/3) | 0.36794–0.36885 (0/3) |
| 32M / 1 | 0.51320–0.52561 (0/3) | 0.62695–0.64020 (0/3) | 0.35645–0.36108 (0/3) | 0.51101–0.51561 (0/3) |
| 32M / 3 | 0.34866–0.35876 (0/3) | 0.45138–0.45868 (0/3) | 0.35065–0.35872 (0/3) | 0.50597–0.51806 (0/3) |
| 32M / 31 | 1.02519–1.04227 (3/0) | 1.00447–1.01562 (3/0) | 0.35603–0.35940 (0/3) | 0.51012–0.51608 (0/3) |
| 32M / 4096 | 0.94294–0.95661 (0/3) | 0.99325–1.00907 (1/2) | 0.35955–0.36839 (0/3) | 0.51960–0.53063 (0/3) |

The retained narrow staged niche remains: both query contracts win on all seeds for small batches31/4096 and large batch31. Large batch4096 prehashed remains slower, while its hash+query result is mixed. Every visible and batch1/3 comparison loses. The extra nineteenth query win is one large4096 hash+query seed, not a new all-seed niche. This screen contains no external library; it does not revise external-leadership claims.

### Original K12 / two-hint K12: construction

| Keys / batch | Insert | Allocate+insert | Hash+insert | Allocate+hash+insert |
|---|---|---|---|---|
| 64K / 1 | 0.99701–1.00463 (2/1) | 0.79842–1.01097 (1/2) | 0.99280–1.01753 (2/1) | 0.79204–1.01805 (1/2) |
| 64K / 3 | 0.99798–1.00093 (1/2) | 0.80328–1.11499 (1/2) | 0.98862–1.00370 (2/1) | 0.81965–1.00680 (1/2) |
| 64K / 31 | 0.99579–1.00510 (2/1) | 0.79182–1.00247 (2/1) | 0.98391–1.01107 (1/2) | 0.79548–1.01142 (1/2) |
| 64K / 4096 | 1.00048–1.02557 (3/0) | 0.79925–1.10866 (2/1) | 0.98374–1.00117 (1/2) | 0.78796–1.00171 (1/2) |
| 32M / 1 | 0.99665–0.99986 (0/3) | 0.99688–0.99990 (0/3) | 0.99759–0.99868 (0/3) | 0.99744–0.99894 (0/3) |
| 32M / 3 | 0.99726–1.00058 (1/2) | 0.99634–1.00091 (1/2) | 0.99846–1.00171 (2/1) | 0.99872–1.00143 (2/1) |
| 32M / 31 | 0.99817–1.00586 (2/1) | 0.99852–1.00539 (1/2) | 1.00068–1.00344 (3/0) | 0.99839–1.00325 (2/1) |
| 32M / 4096 | 0.98139–0.99759 (0/3) | 0.98063–0.99858 (0/3) | 0.98066–1.00040 (1/2) | 0.97946–1.00024 (1/2) |

### Split64Range / two-hint K12: construction

| Keys / batch | Insert | Allocate+insert | Hash+insert | Allocate+hash+insert |
|---|---|---|---|---|
| 64K / 1 | 0.50740–0.51540 (0/3) | 0.40776–0.79975 (0/3) | 0.55310–0.57463 (0/3) | 0.44048–0.84413 (0/3) |
| 64K / 3 | 0.50452–0.50919 (0/3) | 0.40412–0.79902 (0/3) | 0.53919–0.57351 (0/3) | 0.44576–0.84865 (0/3) |
| 64K / 31 | 0.50765–0.51077 (0/3) | 0.40850–0.80817 (0/3) | 0.54879–0.57624 (0/3) | 0.44836–0.85391 (0/3) |
| 64K / 4096 | 0.51037–0.51622 (0/3) | 0.40755–0.80121 (0/3) | 0.53740–0.56035 (0/3) | 0.43520–0.83689 (0/3) |
| 32M / 1 | 0.83741–0.84699 (0/3) | 0.84674–0.85529 (0/3) | 0.86263–0.86776 (0/3) | 0.86848–0.87488 (0/3) |
| 32M / 3 | 0.84187–0.84594 (0/3) | 0.84934–0.85366 (0/3) | 0.86563–0.86822 (0/3) | 0.87243–0.87359 (0/3) |
| 32M / 31 | 0.84045–0.84880 (0/3) | 0.84859–0.85679 (0/3) | 0.86663–0.87375 (0/3) | 0.87231–0.87930 (0/3) |
| 32M / 4096 | 0.83571–0.84342 (0/3) | 0.84508–0.85254 (0/3) | 0.86131–0.86428 (0/3) | 0.86751–0.86924 (0/3) |

Every one of the96 construction comparisons against Range loses. Original/new insertion bodies are byte-identical. Allocation-inclusive small-table variation is large and can reflect allocator placement, row order and code layout; it is not isolated evidence of a changed insertion algorithm. Build boundaries retain the original fixed ordering and stored medians only. There are no recorded build-trial vectors from which to manufacture confidence intervals.

## What the code-generation proof established

Excluding clone crate identity, the only native source delta is two existing `#[inline]` annotations becoming `#[inline(always)]`, on public `contains_hash` and private `contains_scalar`. Actual visible callers contain no hot singleton helper calls; original callers still call the scalar helper per key. This did not eliminate register pressure: candidate callers save six registers and use136/120-byte frames versus72 bytes for the old callers. Captured candidate visible symbol spans grow to656/688 bytes from192/224; public batch lookup expands from6336 to7664 bytes, including scalar/remainder paths. Repeated bounds checks and address arithmetic remain. Symbol spans include padding; they are not isolated hot-loop sizes. See [the exact proof](../2026-10-29-rust-k12-singleton-inline/proof/REPORT.md).

No further annotation or routing variant was selected after these measurements. A future separate hypothesis could take one safe cache-line reference for the four in-line words to remove repeated address/bounds work; that is not implemented or measured here. Removing a call alone was not enough to close the observed gap.

## Quality and limits

All old/new full bitmap/output fixtures passed normal and ASan. Every formal row reproduces the prior construction's mixed-query count/checksum; all new calibration counters are0. The12 historical independent size/seed/family records remain unpooled context, with the clone explicitly aliasing original K12. Their old two-sided95% Wilson upper endpoints remain below0.01%; no new FPR estimate or extra independent evidence is claimed.

The candidate occupies first/middle/last at each size, and every pair appears in both directions. With three seeds the pair counts are2:1, not exactly balanced. All384 order-stratified summaries remain available; prior inputs and repeated batch tags are not independent samples. No NUMA memory-placement policy was set. The original Rust108 losses, all current regression rows and the unchanged controls remain in the archive. The decision is to preserve the two-hint candidate as an unsuccessful general improvement experiment and retain the original implementation.
