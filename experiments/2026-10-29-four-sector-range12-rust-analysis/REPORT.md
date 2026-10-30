# Fixed fresh Rust K12 public-API confirmation

The frozen Rust K12 implementation passed the fixed 0.01% quality gate at 24 bits/key on all three fresh seeds and has a useful staged bulk-query niche. It does **not** replace the existing Range filter generally: singleton/visible queries and all four construction measures lose to equal-byte Range, and the large 4096 batch also loses. The C++ wins do not transfer to every Rust API.

The complete 36-command/108-row measurement is committed at `ab0b27067ae60f9e4a19c6c5aedfadbd8e5bb6e5`; the executed source is `b71707b5f7b562e3544befc6877492854673ff08`. All command/raw/aggregate/source/binary/order/phase/trial and quality guards passed before analysis. There was one measurement session, 36 separate process invocations, and no rerun, additional seed, calibration extension or post-data selection.

## Equal 24 bits/key primary comparison

The following ratios are **Range latency / K12 latency**, shown as the minimum–maximum of the three paired fresh-seed ratios. Values above 1 favor K12. These two staged contracts use their specified batch; the visible contracts below are whole-array public-single loops regardless of batch tag. All APIs in each primary comparison share a process and the same actual payload bytes.

| Keys | Batch | Prehashed ratio | Hash+query ratio | Three-seed outcome |
|---:|---:|---:|---:|---|
| 65,536 | 1 | 0.4186–0.4195× | 0.4789–0.4798× | K12 loses both on all 3 |
| 65,536 | 31 | 1.1364–1.1403× | 1.0350–1.0467× | K12 wins both on all 3 |
| 65,536 | 4096 | 1.3820–1.4049× | 1.2700–1.2829× | K12 wins both on all 3 |
| 33,554,432 | 1 | 0.5107–0.5223× | 0.6224–0.6381× | K12 loses both on all 3 |
| 33,554,432 | 31 | 1.0244–1.0287× | 1.0159–1.0248× | K12 wins both on all 3 |
| 33,554,432 | 4096 | 0.9748–0.9832× | 0.9907–0.9931× | K12 loses both on all 3 |

The staged bulk advantage is narrow in some cells: large batch 31 hash+query is 1.0159–1.0248×, and small batch 31 hash+query is 1.0350–1.0467×. Small batch 4096 is stronger (prehashed 1.3820–1.4049×, hash+query 1.2700–1.2829×). Large4096 instead loses by roughly 0.7–2.6% depending on contract/seed. Three seeds and eight within-process query repetitions do not establish statistical significance for the narrow margins.

The visible prehashed API loses all 18 comparisons to Range (ratio 0.3994–0.4419×), and visible fused hash+single loses all 18 (0.3548–0.4376×). All 72 construction comparisons lose; insert ratio is 0.5033–0.8544× and the other boundaries are retained below. Across all 144 primary metric/seed views, K12 wins 18 and loses 126 to the best retained project filter, here equal-byte Range.

K12 beats the selected Fastbloom public K7@24 control in every 144 primary metric/seed view. K7 was derived from the complete prior 336-row bounded-K training union across all 96 strict24/32 views; it is **not** a fresh measurement of every K or proof against all Rust libraries. The complete SBBF/Bloomsday/default/fixed-K training eligibility evidence and old losses remain in that immutable training archive.

## All main-policy leader comparisons

Each cell reports K12 wins/losses/ties against the independently selected fastest eligible leader in that owner set, then the three-seed/batch ratio range. There are 18 comparisons per row/column (two sizes×three batches×three seeds). All 12 allocation gates pass, so no row is silently removed. Cap 32 admits the measured 24-bit allocations as well as 32-bit extras.

| Contract | Cap24 external | Cap24 retained project | Cap32 external | Cap32 retained project |
|---|---|---|---|---|
| Staged prehashed | 18/0/0; 1.364–9.742× | 9/9/0; 0.419–1.405× | 12/6/0; 0.322–1.405× | 0/18/0; 0.406–0.983× |
| Staged hash+query | 18/0/0; 1.311–7.174× | 9/9/0; 0.479–1.283× | 11/7/0; 0.442–1.377× | 6/12/0; 0.478–1.035× |
| Visible public-single | 18/0/0; 1.247–1.735× | 0/18/0; 0.399–0.442× | 0/18/0; 0.230–0.321× | 0/18/0; 0.362–0.442× |
| Visible fused hash+single | 18/0/0; 1.292–1.607× | 0/18/0; 0.355–0.438× | 0/18/0; 0.243–0.379× | 0/18/0; 0.352–0.438× |
| Insert | 18/0/0; 1.850–5.973× | 0/18/0; 0.503–0.854× | 9/9/0; 0.340–1.099× | 0/18/0; 0.477–0.854× |
| Allocate+insert | 18/0/0; 1.433–5.659× | 0/18/0; 0.408–0.862× | 9/9/0; 0.279–1.124× | 0/18/0; 0.393–0.862× |
| Hash+insert | 18/0/0; 1.738–5.256× | 0/18/0; 0.544–0.874× | 9/9/0; 0.400–1.079× | 0/18/0; 0.530–0.874× |
| Allocate+hash+insert | 18/0/0; 1.379–5.019× | 0/18/0; 0.450–0.881× | 9/9/0; 0.330–1.100× | 0/18/0; 0.440–0.881× |

The secondary cap 32 comparisons include extra 32-bit allocations measured in a different process from K12@24; they are not same-process or equal-byte comparisons. K12 wins only 6/144 views against the best retained project leader there, with 138 losses. Against the best external leader it wins 59 and loses 85. All four owner classes, current-seed and unconditional leaders, ties and allocation alternatives remain in the machine-readable tables; this report does not promote secondary winners into a general claim.

## Independent quality

Each API/allocation/size has three separate 67,108,864-negative calibration streams. Repeated batch/mode observations reuse the same construction and denominator only after exact semantic equality; they are not pooled. Main eligibility requires **each** seed’s two-sided 95% Wilson upper endpoint to be at most 0.01%. These pointwise intervals are finite-sample evidence, not a simultaneous guarantee for all future workloads.

| API | Keys | Actual bits/key | Worst separate upper bound | All3 pass |
|---|---:|---:|---:|---|
| BloomsdayPinned | 65,536 | 32 | 0.0037800% | True |
| BloomsdayPinned | 33,554,432 | 32 | 0.0038666% | True |
| Fastbloom017K7 | 65,536 | 24 | 0.0070117% | True |
| Fastbloom017K7 | 33,554,432 | 24 | 0.0069149% | True |
| FourSectorBloomFilter | 65,536 | 32 | 0.0021372% | True |
| FourSectorBloomFilter | 33,554,432 | 32 | 0.0020806% | True |
| FourSectorRange12BloomFilter | 65,536 | 24 | 0.0092754% | True |
| FourSectorRange12BloomFilter | 33,554,432 | 24 | 0.0095440% | True |
| Split64BloomFilter | 65,536 | 32 | 0.0018800% | True |
| Split64RangeBloomFilter | 65,536 | 24 | 0.0095575% | True |
| Split64RangeBloomFilter | 65,536 | 32 | 0.0018754% | True |
| Split64RangeBloomFilter | 33,554,432 | 24 | 0.0095259% | True |

K12’s worst endpoint is 0.0092754% at 65,536 keys and 0.0095440% at 33,554,432 keys. Both pass; no quality gate was relaxed and no sample was extended. The historical K12@16 failures and prior broader training losses remain applicable scope limitations.

## Public API and ordering limits

The normal linked binary SHA256 is `dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e`. Its visible K12 loops call the unchanged scalar helper per key; the caller has six saved registers and a 72-byte frame, and the helper has five saved registers plus bounds checks. Batch paths retain runtime SIMD and scalar/remainder routing. These costs were disclosed before measurement. The poor singleton/visible results are consistent with that codegen hypothesis but do not isolate causality: a separate unchanged-mapping hint experiment must keep this exact implementation as its baseline.

The three primary seed positions are first/middle/last at both sizes, and all 48 order-stratum summaries are retained. There is no complete pairwise or secondary-position balance claim. Query four-mode schedules balance eight repetitions; construction keeps the old four fixed-order boundaries and medians only. No build dispersion or cross-language speed ranking is inferred. CPU3 was pinned under an actual inherited socket1 flock, with no NUMA policy set.

## Complete outputs

- [720 named paired outcomes](report/pairs.csv): 324 wins, 396 losses, 0 ties, all comparable under the fixed quality policy.
- [240 three-seed conditions](report/conditions.csv), retaining each ratio and order position.
- [288 nested views](report/views.json) and [1728 allocation alternatives](report/alternatives.csv), with all-three/current/unconditional policies.
- [36 unpooled quality records and 12 all-seed gates](report/quality.json).
- [48 primary-position strata](report/order_strata.csv) and [216 same-row API ratios](report/api_ratios.csv).
- [Replay/provenance metadata](report/metadata.json) and [pre-data rules](../2026-10-29-four-sector-range12-rust-screen/screening/ANALYSIS_RULES.md).
