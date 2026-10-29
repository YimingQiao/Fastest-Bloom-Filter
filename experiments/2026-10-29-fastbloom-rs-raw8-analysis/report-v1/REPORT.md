# Complete raw8 public-API training screen

The new fastbloom-rs 0.5.10 raw-byte API has **0 wins, 96 losses and 12 no-comparable views** against the retained external envelope in each of the query and build classes. The same counts hold against all native and all retained implementations. This is a seed 42 training result within this fixed panel, not a claim about every workload or library.

All 18 original processes completed successfully in session 98863, without a retry or resumed measurement. The original 786 rows, 262 calibration sources and 524 strict reuse rows were committed before the frozen analysis ran. Analysis session 39150 also exited 0. Raw execution used CPU 2 and explicit NUMA node 0 binding; the correctness proof used CPU 3. No older latency was normalized or imported.

| Coverage | Count |
|---|---:|
| Catalog geometries / new fastbloom-rs K1–K24 geometries | 262 / 144 |
| Rows / measured processes | 786 / 18 |
| Query views / build views | 108 / 108 |
| All alternatives / new raw8 alternatives | 28,296 / 15,552 |
| Actual metric trial vectors / original samples | 3,144 / 25,152 |
| API comparisons / Fastbloom 0.17 fixed-default comparisons | 786 / 864 |
| Quality API records / groups after known-alias checks | 262 / 260 |

## Four separate contracts

Every filter receives the same original raw-u64 key streams. Direct fastbloom-rs uses the public byte-slice API on little-endian eight-byte keys; its upstream hashing and short-circuit membership work remain inside the raw operation. Common-prehash APIs pay the common hash inside each measured raw operation. There is no artificial identity-copy phase. The two query contracts remain separate: the visible loop exposes public singleton calls to the optimizer, while the batched path uses the public bulk opportunity or the direct public per-key loop.

Insertion uses a fixed 4096-key chunk, chosen independently of query batches 1/31/4096. `raw_insert` starts after filter and scratch readiness. `allocate_filter_and_scratch_raw_insert` starts before both required scratch allocation/initialization and filter construction, then includes raw insertion. Common-hash build scratch is 32 KiB; direct raw8 scratch is 0. Build scratch is dropped before query. Common-hash query scratch is 8/248/32768 bytes for batches 1/31/4096; direct raw8 scratch is 0. Caps apply to actual filter payload bytes, with caller scratch reported separately. Thus equal payload caps do not imply equal total process memory.

All four metrics retain eight samples, their medians, minima and maxima. Output poisoning is outside every timed query and is followed by full output/guard validation. Query phase order uses the frozen AB/BA/BA/AB schedule twice. Row order is one seeded training permutation; build measurements are not an independently balanced order experiment. Batch labels on the visible whole-array loop do not change that loop contract.

## New raw8 baseline versus retained external leaders

Each row below covers 54 nested views. The ratio is retained-external latency divided by new-raw8 latency; greater than 1 favors the new baseline. Every smaller actual allocation competes under the cap. No-comparable cases are the six size/batch combinations at 16 bpk and 0.01% FPR for each metric; they are not counted as speed losses.

| Metric | W / L / T / NC | Rival/new ratio range |
|---|---:|---:|
| Raw batched public | 0 / 48 / 0 / 6 | 0.095718–0.791377 |
| Raw visible public | 0 / 48 / 0 / 6 | 0.098673–0.694069 |
| Raw insert | 0 / 48 / 0 / 6 | 0.086949–0.575407 |
| Allocate filter + scratch + raw insert | 0 / 48 / 0 / 6 | 0.099365–0.575410 |

## Native counterexamples remain

These descriptive counts read the already-selected per-metric minima; they do not select a new candidate. Each owner class is compared with all registered external APIs. Optional Range and K12 are not silently merged into production. All 16 query and 9 build losses of the combined native envelope are to Bloomsday; the exact cases and latencies are in [NATIVE_LOSSES.md](NATIVE_LOSSES.md).

| Native owner | Class | W / L / T / NC |
|---|---|---:|
| production_native | query | 68 / 16 / 0 / 24 |
| production_native | build | 75 / 9 / 0 / 24 |
| optional_native_range | query | 45 / 51 / 0 / 12 |
| optional_native_range | build | 66 / 30 / 0 / 12 |
| optional_native_k12 | query | 33 / 51 / 0 / 24 |
| optional_native_k12 | build | 30 / 54 / 0 / 24 |
| all_native | query | 80 / 16 / 0 / 12 |
| all_native | build | 87 / 9 / 0 / 12 |

At the strict 24 bpk/0.01% slice, the retained external leader is Fastbloom 0.17 public K7 in all 24 size/batch/metric views. Native Range wins 21 of those views and optional K12 wins the three batched-query views at small batch 31, small batch 4096 and large batch 31. This is an allocation niche in the current raw contract. It does not erase their losses at other caps or against other native APIs.

## Quality is unpooled and finite

Each construction has exactly 2^24 absent queries, collected only at query batch 1. These negatives are disjoint from the inserted and mixed-query domains, not mutually disjoint across API records; implementations intentionally share input streams. Batches 31/4096 reuse the result only after the frozen geometry/raw-input/full-mixed-output identity checks. The only collapsed aliases are Fastbloom 0.17 default at 16 bpk and K11 at the two sizes. The 260 groups are not a proof that all other mappings are pairwise distinct or independent. Pointwise two-sided 95% Wilson upper bounds determine this screen's gates; there is no multiple-comparison guarantee and no cross-configuration or cross-batch pooling.

| New raw8 size | Actual bpk | K passing 1% | K passing 0.1% | K passing 0.01% |
|---:|---:|---|---|---|
| 65536 | 16 | 3–24 | 6–18 | none |
| 65536 | 24 | 2–24 | 4–24 | 7–24 |
| 65536 | 32 | 2–24 | 3–24 | 5–24 |
| 33554432 | 16 | 3–24 | 6–18 | none |
| 33554432 | 24 | 2–24 | 4–24 | 7–24 |
| 33554432 | 32 | 2–24 | 3–24 | 5–24 |

All 144 new configurations remain in the raw data and alternatives, including every quality failure. At actual 24 bpk, both native Range and K12 pass 0.01% at both sizes in this seed; their Wilson upper percentages are approximately 0.009509%/0.009209% and 0.009124%/0.009344%, respectively. K12 at 16 bpk fails 0.1% at both sizes. A finite upper-bound miss is not permanent algorithmic disqualification, and near-target configurations require a later prespecified uniform confirmation rather than an adaptive extension here.

## Complete evidence and limits

The [216-view table](VIEWS.md) preserves every metric, size, batch, cap, target and all exact leader ties. [views.json](views.json) retains all five owner classes and four composite minima, nulls and all three new-baseline comparisons. [alternatives.json](alternatives.json) retains all 28,296 alternatives, actual bytes, scratch, quality gates, eight samples and losses. [quality.json](quality.json), [api_ratios.json](api_ratios.json) and [fixed_default_ratios.json](fixed_default_ratios.json) retain the complete corresponding records. Fixed/default speed wins do not imply quality qualification.

This is one seen seed, one training round and 18 separately allocated processes on one machine. Ratios are descriptive median comparisons, not significance tests. The cap/threshold views reuse measurements and are not independent observations. Selection across requested allocations can cross process boundaries. Public compiler decisions, including outlined singleton helpers, remain part of the measured APIs; the report does not infer their causal contribution.

Poppy is absent from this binary. Both natural public byte8 and typed-u64 forms for the separately frozen 14-constructor shortlist remain required future controls, with 28 new, separate quality records. The historical Poppy shortlist is not an exhaustive natural-API search. No old Poppy timing or FPR is transferred, and no all-library leadership or fresh-seed claim follows from this screen.

Raw commit: `ff572807b0444a76044cba4c5170fb6a57189ea2`. Producer: `075b4fd88607c91e00fdf84bc3f1b87ea8d459ae`. Frozen calculation: `ca83c8770fc054d28943e6f85fdf618e3576fe47`. Loader: `c30592d5eaf6b0294e869137edfcced043ab7002`. See [provenance.json](provenance.json) and [actual analysis outcome](../analysis-v1-outcome.json).
