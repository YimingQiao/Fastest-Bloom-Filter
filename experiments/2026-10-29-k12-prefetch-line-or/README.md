# Conditional K12 line-OR: source-only fixed follow-up

This single candidate reuses the existing public insertion dispatch exactly: `SizeInBytes() > (1u << 21)` selects `InsertVector<true>`, otherwise `InsertVector<false>`. Inside that already selected template, only `Prefetch=true` uses the previously tested whole-line RMW; `Prefetch=false` retains the original sixteen scalar word ORs. There is no new comparison, threshold search, prefetch change, hash/mask change, query edit or public API change. No compiler, filter or performance run has occurred at this stage.

The prior unconditional experiment is preserved: balanced raw `ceee2396ce0606d700091f5872aab908a893dd4e`, analysis `dddf9acba34c969eaaffabb4bd9159ef8ac1c393`. Its large-table improvement does not erase all eight small-table whole-input regressions. This follow-up tests a conditional implementation using an existing policy boundary; it is not evidence that all tables above2MiB benefit.

`derive.py` reads immutable original control and line-OR blocks from `5cb840406f1b4c48763bd660246e51c03bfe56c2`. Reversing the conditional replacement and class rename exactly restores the original control. `CHANGE.patch` lists every change. The internal native Range control comes from `81f40f16caa44586537d577f998c33fec4c22be8`; its only adaptation routes the sizing include to an identical local copy. The common base and sizing bytes are asserted identical. There is one algorithm candidate; Range is an internal baseline, not an external-build leadership panel.

The proposed fixed confirmation has24 processes and72 rows: four sizes ×two insertion chunks ×three seeds, with old K12, conditional K12 and native Split64Range at the same actual24bpk in each process.

| Inserted keys | Actual bitmap | Existing branch | Evidence before this stage |
|---:|---:|---|---|
| 65,536 | 192KiB | Prefetch=false; original word OR | Unconditional full-build regressions retained |
| 1,048,576 | 3MiB | Prefetch=true; line OR | Unknown performance |
| 4,194,304 | 12MiB | Prefetch=true; line OR | Unknown performance |
| 33,554,432 | 96MiB | Prefetch=true; line OR | Earlier two-seed large-table signal; new inputs remain unmeasured |

Insertion chunks are4 and the whole input. The fresh seeds15485863,32452843 and49979687 are fixed before data; “fresh” means different from this experiment's5011/6011 and tiny-proof74381. It does not claim disjointness from every historical experiment or independent hash functions. No seed is selected using FPR or timing.

Seven fresh build repetitions retain four boundaries: prehashed insertion, allocation+insertion, common-hash insertion and allocation+common-hash insertion. This means288 build vectors/2016 metric samples from1008 actual fresh bitmap lifetimes, plus72 later canonical validation bitmaps. Allocation-inclusive outcomes take priority. Every inserted key and full dense output must be checked outside clocks, with no additional live filter object. Query q18/hit50/batch4096/repeats2 is semantic control only, with no query ranking.

Because Range has a different mapping, each canonical filter streams2^26 independent negative probes after timing. The calibration interval starts at `key_base + n + q`, beyond all inserted/query raw keys. Fixed inserted/query/calibration intervals and arithmetic bounds must be checked by the actual caller. There are36 API/size/seed quality records after chunk deduplication and24 mapping records after the proved K12 alias; repeated chunks and aliases are never pooled. Use per-construction pointwise95% Wilson upper bounds against0.01%. Keep failures. Across-seed competitive claims require all three relevant cases to qualify; same-mapping before/after timing remains reportable with its actual quality status.

Before timing, the caller will apply a fixed three-way Latin order after the existing job shuffle, consuming no additional RNG. Each size/chunk gives every type each absolute position once. Three rows cannot fully balance six predecessor directions; that limitation and fixed pure-before-common build phases remain explicit. Seed0 runs cells forward, seed1 reverse and seed2 rotated by four. `plan.json` is the exact finite ledger.

Required preflight is bounded caller/dispatch evidence, reusing the previous full mapping proof: old seen input74381 only, below/equal/above2MiB boundaries, duplicate/shared-line and incremental full bitmap equality, normal/minimal-F/ASan caller checks, and actual public insertion ASM. Confirm the false branch matches the old word-OR body and the true branch matches the previous line-OR body after address normalization; public original dispatch and insertion must remain inside the clock interval. No formal fresh input is consumed by correctness checks.

This source proposal has no CPU lease. It does not authorize production changes, a threshold sweep, new masks, extra variants or outcome-driven extensions. Any result will retain all288 fixed construction contrasts (conditional/control, conditional/Range, control/Range), all trials and losses. Ratios are numerator latency divided by denominator latency; above1 is slower. No broad external, Rust or multithread claim follows from this isolated C++ construction test.
