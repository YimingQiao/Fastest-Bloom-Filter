# Proposed finite Rust K12 comparison

Source only. No performance executable has been built and no new filter workload has run. The isolated Rust K12 public implementation has [committed correctness evidence](../2026-10-29-four-sector-range12-rust-port/PREFLIGHT_REPORT.md) at `645f397cd406fd7e89cc75020b0b6fe2f142b3ab`, including exclusive parallel builds and complete C++ bitmap/output parity. That evidence establishes semantics, not Rust throughput. Production/default APIs remain unchanged.

This proposal measures the actual public K12 methods in a minimally derived copy of the [complete336 Rust producer](../2026-10-29-rust-fastbloom-fixed-probes-screen/README.md). Its four query contracts and four serial construction boundaries remain distinct. The strict24 niche is primary; strict32 is an explicit secondary comparison against additional higher-capacity rivals. Batch1 is included to expose singleton losses, alongside31 and4096. The previous C++ bulk result does not imply a Rust singleton or build win.

## Selection from complete evidence

`plan.py` reads the exact committed336 raw rows and recomputes all96 strict24/32 views: two sizes × three batch tags × two caps × eight metrics, using actual bytes and each independent two-sided95% Wilson upper bound <=0.01%. For each view it retains every exact tie for the fastest external allocation and fastest combined retained-project allocation. It independently checks these minima against the committed query/build analysis. The union is then fixed for each size and repeated across all three batch tags; no convenient K or old favorable metric is hand-selected.

| Keys | Existing selected allocations | New candidate |
|---:|---|---|
| 65,536 | Fastbloom K7@24, Range@24, Bloomsday@32, FourSector@32, Split64@32, Range@32 | K12@24 |
| 33,554,432 | Fastbloom K7@24, Range@24, Bloomsday@32, FourSector@32 | K12@24 |

The proposal is36 commands and108 rows over three seeds. The more fragmented per-batch union would save15 rows but omit some retained controls from neighboring batch tags; the fixed size panels keep all selected rivals visible throughout. Every one of the original20 APIs remains registered in the future derived producer; only this explicit finite union is timed. The original automatic-K controls, all public K1…12, SBBF and Bloomsday capacity/quality support remain in `selection.json` as112 unpooled training API records. The original336 losses and all alternative allocations stay in their immutable archive.

The prior [fresh Rust Range24 confirmation](../2026-10-29-split64-range-rust-strict24-analysis/REPORT.md) independently supports retaining Range@24 and public K7@24: all96 query/build paired outcomes favored Range under both fixed old fresh seeds. Its values are context, not samples in this new comparison, and it does not establish K7 is universally fastest on new inputs. The strongest external union here comes from all96 complete training views, not that two-family report alone.

## Inputs fixed before any new output

All selected APIs use q=2^22,50% source hit pattern, eight balanced query repeats, eight build repeats, whole-input insert batches and **2^26 independent calibration negatives**. The three fixed fresh seeds are:

- `48714180869863897`
- `13312860449584497766`
- `9336338316380403537`

They were chosen only by the exact source job-order permutation and raw counter-domain separation. A deterministic SplitMix sequence starts at `0x4b31325255535431`; all124 candidate IDs, including rejected candidates, are retained. The accepted IDs16,31,123 place K12 first, middle and last respectively in the primary three-API group at both sizes. Correct RNG advancement includes2,097,154 positive-query draws (q/2+2), rather than rounded q/2. Each seed's two size envelopes are disjoint from each other, all accepted envelopes and the old Rust training/fresh plus C++ K12 fresh input envelopes. Within one construction, positive queries intentionally revisit inserted keys; timed negatives and calibration are disjoint. Batch/budget repetitions deliberately reuse the same construction and are not independent quality samples.

This balances K12's primary absolute position only. It does not claim complete pairwise reversal among the two retained controls or secondary-group order balance. Exact expected row orders and all raw intervals are retained. Each seed rotates the batch sequence; the second seed reverses size and budget order. No seed was selected using FPR, latency or a new filter output.

## Contracts and decision limits

The future caller adds a static `Filter` adapter using only K12's public `with_byte_budget`, `size_in_bytes`, `contains_hash`, `insert_hashes` and `lookup_hashes`. It adds one registry entry, one dispatch arm and the exact64-byte/12-probe geometry metadata. All20 old adapter bodies, dense-output validation, aligned buffers, four-mode timing helpers, raw/prehashed semantics and build boundaries must remain byte-identical. The candidate kernel crate must remain exact to the correctness commit; no leaf annotations, routing changes or private-kernel bypass are included. Original controls stay linked to their existing immutable snapshots. A new Cargo package/target and explicit candidate dependency are necessary, so the old binary itself cannot supply the new candidate.

A bounded later actual-caller preflight will check the new public adapter against the already-proved crate, all selected names/actual allocations/full outputs, malformed selections, output guards and structured compiler dependencies. It will compare the retained control semantics with the unchanged original executable on tiny non-heldout fixtures, and inspect generated query entry points. It will not repeat the complete K12 algorithm/backend matrix or use a fresh performance seed for preflight. No compile, BF or timing is authorized by this source-only proposal; exact caller/binary freeze and separate CPU lease follow review.

The108 rows contain36 independent API/size/allocation/seed quality records and12 all-three-seed geometry gates. Repeated batch tags and query/build modes are never pooled. Main eligibility requires every fixed seed to pass the0.01% Wilson upper gate; also retain current-seed eligibility and every unconditional latency win/loss/tie. All original lower-capacity alternatives remain eligible in secondary32 comparisons. No adaptive calibration extension, K substitution, geometry substitution or seed extension is permitted.

Primary24 comparisons run the candidate and both rivals in the same process. Secondary32 reuses candidate@24 and includes the extra32 allocations from a separate process; this is a nested-capacity comparison, not a same-process or equal-byte claim. Query modes are ranked separately, and the whole-array visible modes retain their original meaning at every batch tag. The four build boundaries keep their existing fixed order and median-only output, so no missing build-trial uncertainty or balanced build ordering is inferred. This screen uses serial construction; the new parallel API has correctness evidence but no performance conclusion here.

All720 named rival/candidate metric pairs,240 three-seed conditions, all qualifying/no-comparable views and all losses must remain visible. Broadest permissible conclusion is about this fixed Rust public-API shortlist at strict24 or separately strict32 on this host. No all-K fresh leadership, cross-language latency, global fastest, production-default replacement or statistical significance claim follows from this proposal.

Five offline tests reproduce the complete plan, independently walk the source RNG draw sequence, verify nested-cap/tie selection, check all accepted domain separations and verify108/36 panel and quality identities. The first source-only derivation stopped on a proof-field naming mismatch before selection output; its error is preserved in derive-v1.stderr. Corrected schema lookups produce derive-v2/selection.json; no filter was executed.
