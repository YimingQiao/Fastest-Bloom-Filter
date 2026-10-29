# Native Rust Split64Range exact-capacity training screen

This seed42 screen compares current production4, three public external families and the unchanged Range candidate. It is a training allocation/API comparison, not held-out confirmation or a global fastest claim.

All120 rows are retained. Each of the216 query views fixes size, batch tag, actual byte ceiling16/24/32, FPR ceiling1%/0.1%/0.01% and one of four query contracts. Every view sees all20 measured allocations for that size/batch; smaller allocations remain eligible under larger ceilings. The4320 alternatives and648 Range alternatives include every loss and ineligible allocation.

## Query comparisons

Wins/losses below compare the fastest eligible Range allocation with the fastest eligible allocation in each rival ownership class. Exact ties are retained, and ineligible/missing views are reported separately. These descriptive counts do not measure independent repeated evidence.

| Query contract | Versus external W/L/T | Versus production W/L/T | Ineligible/missing external / production |
|---|---:|---:|---:|
| lookup_ns | 23/25/0 | 2/40/0 | 6 / 12 |
| hash_lookup_ns | 27/21/0 | 4/38/0 | 6 / 12 |
| inline_lookup_ns | 18/30/0 | 3/39/0 | 6 / 12 |
| inline_hash_lookup_ns | 18/30/0 | 3/39/0 | 6 / 12 |

The visible prehashed and fused-hash measurements each call the library's actual public singleton API in a whole-array loop. Their batch tag labels the separately run case; it does not change that query loop. Generic staged batch, generic common-hash batch, visible singleton prehashed and visible fused hash are ranked independently. SBBF's public dispatch remains intact; no private external kernel is substituted.

## Quality and historical context

The40 family/actual-geometry/size/seed calibration records each use2^24 independent negatives. Reuse across three batch tags and four modes is counted once. Distinct families are not assumed to share a hash mapping or combined into a larger binomial sample. quality.json preserves every point estimate and two-sided95% Wilson endpoint.

Historical FourSector actual16 upper-endpoint gate failures and the separate higher-resolution resolutions are contextual evidence only. The current training ranking uses the current seed42 endpoint; it does not exclude the row because of a prior failure or import old timings. A pass on one seed does not erase historical uncertainty, and an upper endpoint crossing the target does not prove that the true rate exceeds it.

## Serial construction and equal-allocation controls

build-views.csv, build-alternatives.csv and build-range-alternatives.csv retain all four serial build metrics: prehashed insertion, allocation-inclusive prehashed build, common-hash insertion and allocation-inclusive common-hash build. They use the same nested capacity/quality eligibility. Eight construction trials ran, but the frozen CSV retains only their medians: no build trial dispersion is invented. This is not a parallel-build comparison.

same-allocation-controls.csv retains96 query/build pairs between Range16/32 and production Split64 at the same bytes, across both sizes and all three batch tags. Equal bytes do not imply identical hash-to-block mapping. api-ratios.csv retains240 within-row generic/visible API comparisons, including losses.

## Provenance and limits

Source commit `2c7b1668880ab5a1e3ea0c73f2034b89da0d8650`; binary SHA `448ca811711c2ea29654208b18bc8d9f58ed876555f371aac147d787257a7a23`. All18 commands, source-derived filtered registry orders, four balanced phase schedules and trial vectors, geometry/probe fields, dense checksums and independent counts match raw outputs and the ordered aggregate. The audit checks259 frozen source/evidence files,11 dependency sets,12 executables and258 committed archive entries.

CPU3/socket1 held one exclusive inherited flock. Affinity only was applied; no explicit NUMA memory binding is claimed. Case order was fixed by size, ceiling and batch with one seed42, so allocation placement and execution order remain limitations. No production source or measured binary changed for this analysis; no timing or accuracy workload was rerun.
