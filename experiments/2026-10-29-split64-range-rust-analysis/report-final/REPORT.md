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

### The exact24-bpk/0.01% capacity gap

At this ceiling, the current power-of-two production types can use only the smaller16-bpk geometry, which does not qualify for0.01%. Range24 passes at both sizes. Fastbloom qualifies among these three external families; the two public32-byte split-block families do not. This is a current-seed capacity/quality advantage, not evidence that Range beats every query API at a32-bpk ceiling.

**Fastbloom configuration scope:** this frozen screen calls `.expected_items(real_n)`, which selects17 probes at24 bpk and achieves about0.001% FPR, substantially below the0.01% ceiling. The pinned0.17.0 public builder also exposes `.hashes(k)` in `src/builder.rs`. Those cheaper fixed-probe configurations have not been measured here. The large ratios below therefore compare the current default-optimal-probe configuration, not the strongest possible Fastbloom configuration at the chosen ceiling. A separate public fixed-K accuracy/performance comparison is needed before making that broader claim.

| Family at actual24 bpk | Keys | FP /2^24 | Wilson95 upper (%) |
|---|---:|---:|---:|
| BloomsdayPinned | 65536 | 2738 | 0.01694254 |
| BloomsdayPinned | 33554432 | 2777 | 0.01717933 |
| Fastbloom017 | 65536 | 171 | 0.00118388 |
| Fastbloom017 | 33554432 | 169 | 0.00117107 |
| SbbfSafePinned | 65536 | 2738 | 0.01694254 |
| SbbfSafePinned | 33554432 | 2777 | 0.01717933 |
| Split64RangeBloomFilter | 65536 | 1517 | 0.00950860 |
| Split64RangeBloomFilter | 33554432 | 1468 | 0.00920914 |

| Keys | Query contract | Batch tag | Range24 ns/key | Best eligible external ns/key | External / Range |
|---:|---|---:|---:|---:|---:|
| 65536 | lookup_ns | 1 | 4.2249 | 19.9360 | 4.7187× |
| 65536 | lookup_ns | 4096 | 1.7025 | 17.3205 | 10.1733× |
| 65536 | inline_hash_lookup_ns | 1 | 3.1368 | 20.4634 | 6.5237× |
| 33554432 | lookup_ns | 1 | 15.3166 | 70.3715 | 4.5945× |
| 33554432 | lookup_ns | 4096 | 5.9151 | 71.1694 | 12.0319× |
| 33554432 | inline_hash_lookup_ns | 1 | 11.9837 | 68.0194 | 5.6760× |

The visible prehashed and fused-hash measurements each call the library's actual public singleton API in a whole-array loop. Their batch tag labels the separately run case; it does not change that query loop. Generic staged batch, generic common-hash batch, visible singleton prehashed and visible fused hash are ranked independently. SBBF's public dispatch remains intact; no private external kernel is substituted.

## Quality and historical context

The40 family/actual-geometry/size/seed calibration records each use2^24 independent negatives. Reuse across three batch tags and four modes is counted once. Distinct families are not assumed to share a hash mapping or combined into a larger binomial sample. quality.json preserves every point estimate and two-sided95% Wilson endpoint.

Historical FourSector actual16 upper-endpoint gate failures and the separate higher-resolution resolutions are contextual evidence only. The current training ranking uses the current seed42 endpoint; it does not exclude the row because of a prior failure or import old timings. A pass on one seed does not erase historical uncertainty, and an upper endpoint crossing the target does not prove that the true rate exceeds it.

In this current Rust screen, FourSector16's upper endpoint is0.09710818% at65,536 keys and0.10023738% at33,554,432 keys. The larger row therefore misses the0.1% gate on its current sample; the smaller row remains eligible. This differs from importing a historical exclusion. All14 immutable contextual records are separately retained in prior-quality.json with source commits, including the two larger disjoint-suffix resolutions and six fresh-seed observations.

## Serial construction and equal-allocation controls

build-views.csv, build-alternatives.csv and build-range-alternatives.csv retain all four serial build metrics: prehashed insertion, allocation-inclusive prehashed build, common-hash insertion and allocation-inclusive common-hash build. They use the same nested capacity/quality eligibility. Eight construction trials ran, but the frozen CSV retains only their medians: no build trial dispersion is invented. This is not a parallel-build comparison.

same-allocation-controls.csv retains96 query/build pairs between Range16/32 and production Split64 at the same bytes, across both sizes and all three batch tags. Equal bytes do not imply identical hash-to-block mapping. api-ratios.csv retains240 within-row generic/visible API comparisons, including losses.

| Same-allocation metric | Range W/L/T | Split64 / Range minimum–maximum |
|---|---:|---:|
| lookup_ns | 0/12/0 | 0.959574–0.992612× |
| hash_lookup_ns | 1/11/0 | 0.970330–1.000150× |
| inline_lookup_ns | 0/12/0 | 0.909916–0.996730× |
| inline_hash_lookup_ns | 0/12/0 | 0.930184–0.991738× |
| insert_ns | 0/12/0 | 0.932015–0.955512× |
| allocate_insert_ns | 0/12/0 | 0.535586–0.951954× |
| hash_insert_ns | 0/12/0 | 0.898130–0.975635× |
| allocate_hash_insert_ns | 0/12/0 | 0.583169–0.957520× |

Range loses47 of48 same-allocation query comparisons; its lone staged-hash win is only0.015%. It loses all48 corresponding build comparisons. The especially larger small-table allocation-inclusive cost is retained; this screen alone does not identify whether allocator/code-generation/placement effects cause it. The exact24-bpk capacity is the useful difference, rather than a demonstrated universal speed improvement at an equal allocation.

The frozen build harness runs prehashed and common-hash construction phases separately; unlike the four query modes, those build phases do not have the same balanced Williams ordering. Construction results remain descriptive and separate from query conclusions.

## Provenance and limits

Source commit `2c7b1668880ab5a1e3ea0c73f2034b89da0d8650`; binary SHA `448ca811711c2ea29654208b18bc8d9f58ed876555f371aac147d787257a7a23`. All18 commands, source-derived filtered registry orders, four balanced phase schedules and trial vectors, geometry/probe fields, dense checksums and independent counts match raw outputs and the ordered aggregate. The audit checks259 frozen source/evidence files,11 dependency sets,12 executables and258 committed archive entries.

CPU3/socket1 held one exclusive inherited flock. Affinity only was applied; no explicit NUMA memory binding is claimed. Case order was fixed by size, ceiling and batch with one seed42, so allocation placement and execution order remain limitations. No production source or measured binary changed for this analysis; no timing or accuracy workload was rerun.
