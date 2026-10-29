# Benchmark evidence index

The shared C++ executable compares **56 configurations**: four native layouts,
pinned FastFilter SIMD/classical variants, PageBloomFilter, Boost.Bloom 1.92,
RocksDB FastLocalBloom core variants and explicit single-call controls.
A separate [988-row exact-capacity screen](../experiments/2026-10-29-exact-budget-range/screen/OBSERVATIONS.md)
expands this to **68 external configurations, four production natives and two
range-capacity experiments**, using actual backing-byte ceilings from 12 to 32 bits/key.
The [728-row original/modern raw-u32 comparison](../experiments/2026-10-29-vldb-raw32-analysis/RESULTS.md)
now measures the original VLDB public PImpl/dynamic/static APIs alongside modern
libraries, with identical native controls in separate executable contexts.
Production leaders win all 72 comparable original-context views, but lose 29 of
84 modern-context views. The large strict bulk loss against Boost24 persists in
both rounds. Actual allocations, public hash work, compact-to-dense conversion,
166 unpooled quality identities and all missing-qualifier cases remain visible.
No context adjustment or cross-context normalization is applied. The completed
[240-row Page caller control](../experiments/2026-10-29-page-pointer-single-analysis/RESULTS.md)
compares value and direct-pointer public single calls in both launch rounds.
Pointer calls show no stable gain; the large-table changes include both signs,
and unchanged dense callees also vary. Native leaders win all 84 comparable
Page-only views; 60 missing-qualifier views are not wins. This does not replace
the full-modern ranking or erase its Boost/FastFilter/RocksDB losses.
The [complete 336-row Rust public-K comparison](../experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/report/INTERPRETATION.md)
keeps every Fastbloom K1–12 and the automatic constructor. Public tuning improves
48/216 eligible query views, with a maximum 1.97× external gain. Experimental
Range24 still leads at the 24-bpk/0.01% ceiling, but equal-byte controls favor
production Split64 in 46/48 queries and 47/48 builds; Bloomsday retains several
32-bpk singleton advantages. All 432 query/build views and their full alternative
sets remain available. The first 316 raw rows were preserved after exit143;
only the unfinished 20-row case was resumed with the identical executable.
The derived archive explicitly records both sessions and never pools repeated
quality samples. The [fixed fresh24-row confirmation](../experiments/2026-10-29-split64-range-rust-strict24-analysis/REPORT.md)
passes all eight separate accuracy samples. Range beats the training-selected
K7 in all48 query and48 build metric records; pure batch-API gains are2.65–7.46×
and staged hash+query gains2.04–6.09×. It confirms this fixed shortlist, not a new
exhaustive external search on each seed. Range is now an optional native API;
its [packaging validation](../experiments/2026-10-29-range-production-integration/VALIDATION.md)
passes C++ native/AVX2/portable/sanitizers and Rust normal/AVX2/ASan/Clippy checks.
The existing power-of-two layouts and build defaults remain unchanged.
A separate native Rust suite includes
pinned Bloomsday, fastbloom and [SBBF](../benchmarks/rust-sbbf-external/README.md).
Its [168-row SBBF screen](../experiments/2026-10-29-rust-sbbf-screen/screen/RESULTS.md)
retains the small-filter singleton losses against Bloomsday.
The [Rust public-call screen](../experiments/2026-10-29-rust-visible-single/screen/RESULTS.md)
lets the compiler see each public lookup; Bloomsday still wins several settings.
The [132-row Independent32 Rust screen](../experiments/2026-10-29-independent32-rust-analysis/FINDINGS.md)
finds a promising strict-FPR singleton candidate: at 32 actual bits/key, its
public hash+query API leads Bloomsday by 6–22% at the two measured sizes.
The generic batch-one path still loses, and existing native layouts win several
large-batch settings. This is one-seed prototype evidence pending confirmation.
A subsequent [192-row singleton-branch experiment](../experiments/2026-10-29-independent32-rust-singleton-analysis/FINDINGS.md)
was rejected after short batches regressed; the candidate remains isolated.
Its [208-row scalar-inline follow-up](../experiments/2026-10-29-independent32-rust-scalar-inline-analysis/FINDINGS.md)
improves generic batch-one prehashed throughput by 10–20%, but small-table
batch-two queries regress by 16.6%. It also remains isolated.
A [six-seed ByteSplit confirmation](../experiments/2026-10-29-rust-byte-leaf-analysis/report/DECISION.md)
supports exposing its public singleton body to the Rust compiler. The Rust library
now includes the [minimal Byte-only inline hint](../experiments/2026-10-29-rust-byte-inline-integration/EVIDENCE.md).
Its isolated two-seed comparison improves public hash+query throughput by **16–38%**
at batch 1 across the four size/allocation settings, while some 32M-key, 16-bpk
short-batch cases are **2–3% slower**. This is a measured API tradeoff; full outputs,
allocation and FPR stay identical. The integration passes the existing 29 library
tests, Clippy and an actual public-caller assembly check. Earlier external
comparisons and all generic-mode losses remain linked separately.
The separate [BlowChoc screen](../experiments/2026-10-29-blowchoc-throughput/RESULTS.md)
compares eight upstream configurations using whole-array calls, with prehashed,
fused-hash and staged-hash timings reported separately.
See the [survey](external-survey-2026-10-28.md)
and [shared-harness instructions](../benchmarks/all-external/README.md).

Ranking constrains **measured filter payload allocation and observed FPR**, distinguishing
prehashed kernels from raw-key end-to-end work. Build batches are independently
configurable, temporary build allocations are reported, and timed construction
holds only one bitmap at a time. Screening uses explicit error ceilings and a
pointwise 95% Wilson bound; final candidates need held-out confirmation.
The completed large-batch confirmation has **234 C++ rows and 90 Rust rows**,
using three new insertion seeds and 50 million independent calibration negatives
per configuration. In the C++ shortlist, our eligible query leaders are
**1.10–1.73× faster** than the fastest eligible external configuration across the
reported memory/FPR ceilings. This covers 65K–32M keys, 50% hits, batch 4096,
and allocations up to 128 MiB on one Xeon Platinum 8474C core. This confirmation
uses 16/32-bpk allocation targets. The newer
[finer-capacity confirmation](../experiments/2026-10-29-exact-budget-confirmation/screen/RESULTS.md)
tests fixed leaders from the 988-row screen with three fresh seeds. At 32M keys
and a 0.01% FPR ceiling, production FastPattern loses to a 24-bpk Boost filter
on two seeds. The isolated 24-bpk Split64 range prototype has **4.3–6.7% lower
hash+query latency** on all three, with its worst FPR upper bound close to the
ceiling. FourSector at 16 bpk fails the small-table 0.1% quality gate on one seed;
its timing advantage does not count as a qualifying win under that original sample gate. These results preserve
fixed candidates and failures, and remain separate from the earlier confirmation.
A [62-row cyclic-mask experiment](../experiments/2026-10-29-cyclic-split64-analysis/FINDINGS.md)
also stays experimental: fewer mask instructions raised the required space,
and it lost 15 of 16 eligible views against the retained external leaders.
A [70-row multiply-code experiment](../experiments/2026-10-29-multiply-code-split64-performance-analysis/report/RESULTS.md)
improves small-table Split64Range throughput by about 8–10%, but loses to the
best current-seed project controls. A
[higher-resolution accuracy check](../experiments/2026-10-29-four-sector-quality-resolution/RESULTS.md)
qualifies both previously inconclusive FourSector16 constructions on new
disjoint negatives, with upper FPR bounds of **0.09906% and 0.09816%**.
The [144-row fresh-seed comparison](../experiments/2026-10-29-multiply-code-small-confirmation-analysis/report-final/REPORT.md)
finds a tradeoff: at 65K keys and 16 bpk, Multiply improves large-batch throughput
by about **6–9%** over the eligible native Split64 control, but singleton latency
is **12–19% worse**. FourSector remains faster in bulk cases that pass their
individual quality gates; one new seed fails its upper-bound gate. The new mask
remains experimental, with all quality failures and speed losses retained.

![Modern external large-batch confirmation](figures/modern-confirmation.svg)

| At 16M keys | Memory ceiling | Our query leader | Hash+query | Best eligible external |
| --- | --- | --- | --- | --- |
| FPR ≤ 1% | 16 bits/key | FastPattern | 3.709 ns/key | FastFilter SIMD: 4.096 ns/key |
| FPR ≤ 0.1% | 16 bits/key | Split64 | 3.789 ns/key | Boost Multi64K8: 4.433 ns/key |
| FPR ≤ 0.01% | 32 bits/key | FastPattern | 4.110 ns/key | FastFilter Fixed32: 4.855 ns/key |

Eligibility uses a pointwise 95% FPR upper bound; exact allocations remain visible.
This is a query result within the stated contract. FourSector still has construction
and short-batch losses. In the separate [47-configuration single-key screen](single-screen-2026-10-28.md),
FastFilter wins the shown 1% and 0.01% bands; Split64 wins 0.1% at 16 bits/key.
That screen is exploratory and single-key optimization continues. The wider
mask dictionary in the report remains experimental. See the
[complete confirmation, including Rust and build timings](modern-confirmation-2026-10-28.md),
[screening results](modern-screen-2026-10-28.md), and
[frozen protocol](confirmation-protocol-2026-10-28.md).

A newer [240-row RocksDB-inclusive screen](rocksdb-screen-2026-10-29.md)
retains large-batch leads while exposing remaining single-key and short-batch
losses. The completed [native single-key confirmation](byte-confirmation-2026-10-29.md)
adds **276 C++ / 96 Rust rows** with three held-out seeds and stronger FastFilter
single-call controls. C++ ByteSplit's small-filter prehashed query is **7–8% faster**,
but its hash+query advantage shrinks to **0.5–0.9%**. Split64 leads the C++ 0.1% FPR
band by **1.10–1.20×** in hash+query; FastFilter still wins the strict 0.01% band
and the large-filter 1% band in that metric. Rust also retains small-filter losses
against Bloomsday. These results supersede the prototype's roughly 8% end-to-end
gain as evidence for the native port; optimization continues from the losses.

A separate [240-row public single-call screen](../experiments/2026-10-29-inline-single-query/screen/RESULTS.md)
lets the compiler optimize across successive calls and keeps the original batch-one
measurements alongside it. Calling convention changes the ranking: the native
strict-accuracy small-filter loss remains. This is a one-seed screen, pending confirmation.

The new [eight-core external confirmation](external-parallel-confirmation-2026-10-29.md)
compares the same 23 shortlisted configurations on identical physical cores and a
shared immutable bitmap. Across three fresh seeds, our per-scenario leaders are
**1.06–1.59× faster including hashing, fresh thread startup and joining** at batch
4096, 50% hits and 65K/32M keys, at the two measured 16/32-bpk allocation targets.
Memory caps and measured FPR ceilings still apply;
individual ByteSplit/Split64 losses remain in the report. This is a C++ external
comparison; Rust's separately reported scaling uses its own serial baseline.

## Latest additive evidence

The [all-eight-API precision audit](../experiments/2026-10-29-eight-api-quality-resolution/RESULTS.md)
uses117,440,512 new disjoint negatives for every one of the six constructions.
All eight APIs pass0.1%; FourSector's worst upper endpoint is0.09952591%.
Applying this separate new gate to the original144 timings makes Multiply lose
all36 comparisons against the fastest native rival. The original rankings and
sample gates remain archived; there is no new timing run or production promotion.

The [native Rust Range120 screen](../experiments/2026-10-29-split64-range-rust-analysis/report-final/REPORT.md)
adds actual24-bpk capacity and four query contracts. Range24 passes0.01% at both
sizes, while power-of-two production types cannot use that budget fully. It
loses47/48 equal16/32-byte-budget query comparisons and all48 build comparisons
against production Split64. The qualifying fastbloom baseline here uses its
accuracy-optimal default probe count; its public configurable probe-count API
was subsequently covered by the complete336-row comparison above. Large ratios
against the default in this earlier screen are not a claim against tuned fastbloom.

The [112-row public Fastbloom probe calibration](../experiments/2026-10-29-rust-fastbloom-fixed-probes-analysis/report/REPORT.md)
tests every K from 1 to 12 at both sizes and all three capacities, preserving
all 40 old constructions and their exact quality results. At 24 actual bpk,
K7 passes the 0.01% upper-bound gate at both sizes, versus default K17. K6 at
16 bpk passes 0.1%, and K5 at 32 bpk passes 0.01%. These are quality minima
within the tested grid, not latency winners. The completed336-row timing grid
above retains every K, automatic defaults and existing native/external controls.

The [original VLDB public PImpl baseline](../benchmarks/vldb-original-external/README.md)
now passes native, AVX2 and ASan/UBSan correctness checks. Its public calls,
compact output conversion, allocations and original upstream sources are
preserved. The [168-case large-geometry preflight](../benchmarks/vldb-raw32-stage2/PREFLIGHT_RESULTS.md)
also passes, including 48–128 MiB backing allocations with bounded correctness
fixtures. The completed728-row raw-u32 comparison above supplies the separate
full-population timing evidence; these fixtures alone do not establish throughput.

The [142-row eight-core Range screen](../experiments/2026-10-29-split64-range-parallel-analysis/report-final/REPORT.md)
uses the same shared immutable bitmap and executor across all public APIs.
At 24 bpk and a 0.01% ceiling, Range leads the eligible external controls by
14.7–27.1% at 65K keys and 2.7–5.4% at 32M keys across pure/hash and gated/full
end-to-end query contracts. It loses 36 of 64 eligible nested views against
external configurations and 54 of 56 against production natives. This is one
seed with a fixed phase order; the useful capacity niche is not a general
replacement claim. Serial-build losses and same-row scaling remain separate.

The [60-row native C++/Rust API screen](../experiments/2026-10-29-split64-range-native-scaling-analysis/report-final/REPORT.md)
measures T1/4/8 with full public construction and whole-array query calls.
At 32M inserted keys, T8 allocation+build gains 2.18–2.61× and queries gain
6.83–7.81× against each configuration's own serial control. All ten 65K-key
T8 build configurations lose: allocation+build ratios are 0.133–0.273×.
Query arrays still contain 4M keys at both table sizes. The report retains
all 444 comparisons, including 245 losses across overlapping views, and
20 language-specific calibration records without pooling repeated thread counts.
This is a single-seed scaling result, with no cross-language speed ranking.

A [FourSector range-addressing pilot](../experiments/2026-10-29-four-sector-range24/accuracy/RESULTS.md)
passes all six backend/sanitizer correctness profiles but misses the proposed
24-bpk/0.01% quality gate at both sizes. The two upper endpoints are 0.01059%
and 0.01092%, while the retained Split64Range controls pass. No throughput
measurement or integration was justified by that pilot.

The [fixed96-pair build-policy confirmation](../experiments/2026-10-29-native-build-policy-analysis/DECISION.md)
tests one fallback rule: a current insertion of at most65,536 hashes into at
most256KiB uses one build worker. All48 active-gate contracts improve on both
fresh seeds, with per-cell gains of2.25–8.47× across languages and build contracts.
However,66 of112 unchanged-policy controls regress. Rust Split64 just above the
batch threshold has14–21% higher allocation+build latency atT8 on both seeds.
All160 paired contracts,320 shared-serial comparisons and480 trial vectors are
retained. An actual native port must resolve these repeated losses before a
default change; no query or external-leadership claim follows from this result.

The [296-row K12 bulk screen](../experiments/2026-10-29-four-sector-range12-analysis/INTERPRETATION.md)
keeps all284 retained control rows and12 new candidate rows at batches31/4096.
K12 passes the strict24-bpk gate at both sizes and wins all eight corresponding
query views against both external and optional-Range leaders. Across the wider
72 views it has26 wins/30 losses/16 ineligible against externals and12/44/16
against retained project layouts. All5,328 allocation alternatives and98
unpooled quality identities remain. Its weakest hash+query margins are2.84%
and3.47%, requiring fresh confirmation;16bpk fails0.1% and32bpk is not a general
replacement. Rust performance and native integration evidence follow below;
parallel K12 construction performance remains unmeasured.

The [fixed three-seed K12 confirmation](../experiments/2026-10-29-four-sector-range12-strict24-analysis/REPORT.md)
retains all78 rows and qualifies all13 API geometries on all three separate
2^26-negative samples. K12 wins24/24 primary24-bpk views against both external
and retained-project leaders, plus12/12 prespecified large-table cap32 views.
All180 named pairs remain; the primary native margin falls to1.96% in one cell.
The secondary views reuse primary observations and add separate-process28/32-bpk
controls. First/middle/last candidate order is balanced across the three seeds,
without claiming complete position balance or separating seed from order effects.

The [fixed108-row Rust K12 confirmation](../experiments/2026-10-29-four-sector-range12-rust-analysis/REPORT.md)
passes all12 separate three-seed quality gates and retains all720 named outcomes:
324 wins and396 losses. At equal24 bits/key it beats Range in staged batch31 at
both sizes and small-table batch4096; both singleton modes, all visible-single
queries, every construction contract and large-table batch4096 lose. At cap32
it wins only6/144 views against retained project leaders. The actual linked
visible caller still invokes the scalar helper per key. This is a specific
optimization hypothesis, not proof that inlining will remove the losses.
All36 Wilson records,720 paired ratios, trial summaries and288 nested views
were independently recomputed; secondary32-bpk observations remain separate
processes from primary24-bpk comparisons.

The [optional native C++ K12 integration](../experiments/2026-10-29-native-k12-cpp/RESULTS.md)
preserves the measured serial kernel and adds a dedicated parallel wrapper.
Native AVX-512, AVX2, portable and ASan/UBSan checks pass, including complete
bitmap/output oracles, actual three/seven-worker execution and non-divisible
physical-line ownership. Its source is now available through the native headers;
the generic power-of-two wrapper is intentionally inaccessible for this layout.
This is correctness and packaging evidence, with no parallel-speed claim.

The [actual-native96-pair policy comparison](../experiments/2026-10-29-native-build-policy-port-analysis/DECISION.md)
measures the public before/after C++ and Rust implementations with policy
selection inside the clocks. All48 active-gate contracts improve2.33–5.74×;
outside the gate,56 improve and56 regress. All160 pairs,480 trial summaries and
320 shared-serial comparisons are retained. The two seeds were already seen in
the wrapper study, whose latencies are not imported. Repeated losses remain,
but this sign pattern alone does not establish deterministic regressions.
The policy stays isolated; the completed unchanged-code follow-up is below.

The [fresh four-arm native build comparison](../experiments/2026-10-29-native-build-policy-controls-analysis/DECISION.md)
uses40 processes,72 contracts and9,216 fresh timed bitmap lifetimes, with A0/A1
sharing the exact same compiled function and a separate unchanged-source Clone.
All48 active-gate Policy/A0 or Policy/A1 comparisons favor the policy, with
observed C++ gains of2.28–3.13× and Rust gains of3.32–4.76×. Outside the gate,
46/96 paired observations are slower. The fixed two-seed classification yields
one consistently faster contract, four practically within the ±3% band, and31
unresolved because negative-control intervals exceed that band. All432
contrasts,864 interval endpoints,288 trial vectors and their summaries are
retained and independently recomputed from raw records. Shared control samples
and eight-cycle bootstrap assumptions limit inference. Default selection stays
unchanged; no more repetitions of this policy are planned.

The [Poppy public-constructor proof](../experiments/2026-10-29-poppy-public-geometry/GEOMETRY_REPORT.md)
checks all 86 source-selected public configurations against actual constructor
metadata and requested live heap bytes. Both bucket and cache allocations are
charged; the public serializer's separate 8 KiB temporary buffer is recorded.
All configurations and over-budget controls remain. This is geometry/accounting
evidence only: no keys were inserted and no accuracy or throughput claim follows.

The subsequent [Poppy public semantic proof](../experiments/2026-10-29-poppy-public-semantics/SEMANTIC_REPORT.md)
passes 172 normal/ASan constructor rows, all complete byte/iterator serialization
comparisons and 1,409,196 mixed-query comparisons. Duplicate insertion and
uninitialized-iterator errors leave the complete serialization unchanged;
34 None/Space alias comparisons differ only in the public policy flag.
Zero/full-capacity and invalid-FPP cases also pass. The public byte-slice path
retains the common first hash while preserving mandatory internal hash work.
No accuracy or timing samples were collected in this stage.

The [complete Poppy full-load accuracy stage](../experiments/2026-10-29-poppy-public-accuracy-analysis/REPORT.md)
then checks all86 fixed public constructors with seen seed42 and separate
2^26-negative streams. Every inserted key remains present. Under the actual
24-bpk/0.01% ceiling, six small and four large public configurations qualify;
these counts include policy aliases. The ordinary Best control qualifies at
20.5/20.17 actual bits/key, while large ordinary None/Space controls exceed
their requested quality bands. The analysis keeps86 records,24 cap/FPR views
and1032 alternatives, with no pooled denominator or latency ranking. All17
proved None/Space pairs reproduce full-load counts/checksums. Other mapping
group equality is observational, not a full-bitmap assertion. The actual
accuracy caller passed normal/ASan fixtures before the single complete run.

The [complete160-row nearby public-capacity comparison](../experiments/2026-10-29-vldb-nearby-raw32-analysis/INTERPRETATION.md)
retains20 APIs, two sizes, two capacity ceilings and two opposite launch rounds
in one GCC12.2/Boost1.83 raw-u32 context. Project controls win42 comparable views;
30 no-comparable views are excluded. Nearby/original geometry yields76 wins
and92 losses across168 unconditional pairs, with20 both-round wins,28 both-round
losses and36 mixed outcomes. K12/Range singleton and dense1 comparisons each
record0W/8L; bulk4096 is7W/1L, including a direction change at large strict24.
All80 API quality records,48 proven mappings,72 nested views and2160 alternatives
remain, with no pooled negatives or imported old latencies. The full trial
summaries, Wilson gates, paired ratios and nested group minima were independently
recomputed. These are original public-PImpl results, not a modern-library or
global ranking.
