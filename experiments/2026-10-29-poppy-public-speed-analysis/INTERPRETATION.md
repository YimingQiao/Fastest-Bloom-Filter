# Poppy's public API does not lead this fixed panel

The complete 486-row Rust comparison gives Poppy no qualified win over the retained external leaders in any query or construction view. Poppy loses all 384 comparable views in each class; 48 views have no qualified comparison and are not wins. Its closest query result is still 10.05% slower than the best retained external in that view. This is evidence about the 47 fixed public Poppy mappings and this caller, not a claim about every possible Poppy configuration.

The native filters still have substantial gaps against other external implementations. All 73 production-native query losses and all 42 production-native construction losses here are against BloomsdayPinned. Adding Poppy therefore strengthens the baseline coverage without making native leadership universal.

The [generated report](report-v1/REPORT.md) retains every mode and round. These descriptive counts summarize its repeated, nested views; they are **not independent trials or an estimated win probability**. Each class contains 432 views, including unavailable comparisons.

| Numerator versus best eligible external | Query wins / losses / unavailable | Build wins / losses / unavailable |
|---|---:|---:|
| Production native | 263 / 73 / 96 | 294 / 42 / 96 |
| Optional Split64Range | 158 / 226 / 48 | 237 / 147 / 48 |
| Optional original K12 | 120 / 168 / 144 | 72 / 216 / 144 |
| Explicit union of native groups | 311 / 73 / 48 | 342 / 42 / 48 |

There are no exact-median ties in those contrasts. The native union is a composite selected per view, not a single production layout. The K12 rows are the exact original caller control; they do not measure the new singleton SIMD candidate or later Rust inline experiments.

## What remains slower

At n=2^16, cap24 and 0.1% FPR, the visible common-hash singleton loop chooses production Split64 at actual16 bpk and Bloomsday at actual24 bpk. The two rounds are 3.083/2.151 ns and 3.091/2.147 ns respectively: native/external latency ratios 1.434 and 1.440. Smaller actual allocations are allowed under the same cap, but this is not an equal-bitmap comparison.

At n=2^25, cap32 and 0.01% FPR, the same visible common-hash singleton contract compares Split64 and Bloomsday at actual32 bpk: 12.750/10.552 ns and 12.668/10.466 ns, ratios 1.208 and 1.210. Both rounds preserve the native loss. The complete CSV also retains all other losses, including different query modes and batches; these examples do not replace those records.

The optional layouts do fill the strict cap24 quality gap in this panel. The native composite wins all 48 comparable cap24/0.01% query views across two sizes, three batch-labelled caller contexts, four query contracts and two rounds. Production has no qualified point there. This is scoped to the retained external shortlist, seen seed and actual caller; it does not cancel the 73 native-composite query losses elsewhere.

Poppy loses every comparable query and build view against the production group, Split64Range group and native composite. Against original K12 alone, Poppy has four query wins and 284 losses, with 144 unavailable views; all 288 comparable construction views lose. Those four wins remain in the output. A weaker isolated rival is not substituted for the strongest eligible external or native group.

## Quality, memory and caller limits

All 81 exact API/geometry records have one 2^26-negative calibration beyond inserted and timed mixed-key ranges. The common seed and negative stream correlate APIs and mappings; reuse across 486 rows never adds a denominator. Every pointwise Wilson endpoint and failed ceiling is retained. No Poppy point qualifies for 0.01% under cap16. Under cap24, four small and three large canonical Poppy mappings qualify for that threshold; under cap32, seven small and five large qualify. These are counts of this canonical measured panel, not counts of all public constructor aliases.

Actual-byte caps include Poppy's cache backing. Construction uses the complete real input. Query and build comparisons use their own four contracts; allocation-plus-insertion includes its insertion interval and is not added to it. The actual Poppy `contains_bytes` remains an out-of-line call per key; its eight-byte preparation and public hashing/probing are charged. Staged lookup, visible lookup, pure input and common-hash input are distinct opportunities. The visible loop is still one-key work when it appears in a row labelled batch31 or batch4096; that label controls the row's separate staged contract, not a new visible batch algorithm.

In this frozen caller, `allocate_hash_insert_ns` includes filter allocation, common-hash computation and insertion, but the caller's hash-scratch allocation occurs outside that interval. It is not a complete allocation-of-all-working-memory raw build. The newer Raw8 caller explicitly includes its required hash-scratch allocation in its full-build clock; that different lifecycle is not measured or substituted here.

Poppy receives the shared prepared u64 as eight bytes and still performs its own byte hashing. The common-hash modes additionally include the project hash, just as they do for the other APIs. This does not measure a separate Poppy raw8 caller that bypasses the project hash, and no time is subtracted to simulate that unmeasured contract.

Both rounds and all 1,944 round2/round1 pairs are retained. Reversed launch/API order also changes environment and calibration history, because only first-round batch4096 performs calibration. It does not isolate an order effect or provide independent confirmation. Query data contain 1,944 eight-sample vectors; construction emits only 1,944 medians, so no missing construction vectors or uncertainty estimates are invented.

This is a seen-seed Rust public-API screen, not a fresh-seed confirmation, multithread comparison, C++ comparison or global-fastest result. No parameter is replaced after observing quality, and no implementation is promoted by this report.

## Reproducible artifacts

The producer source is `3c2be48860b52fc55e50aff1170f30724db772da`; complete raw and launcher log are committed at `50e08fbb1e61bc6bd2f712a7e00d74b36ddb9bb1`. The unchanged analysis rules were committed before data at `6795792d0f8edbdb7a67d5d6034160e9af36e5df`.

`report-v1/` preserves 26,640 alternatives, 7,776 named contrasts, 864 owner-group views, 15,552 query sample values, all calibration links and round pairs. [interpretation_counts.py](interpretation_counts.py) only counts these completed frozen outputs; it changes no eligibility, leader or ranking rule. Complete-output checksums and calibration counts identify cross-process semantic agreement; full output arrays are checked inside each process but are not archived for cross-process byte comparison.
