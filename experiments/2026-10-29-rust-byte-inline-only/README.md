# Byte-only public leaf inlining: isolated source preparation

This experiment separates the one useful ByteSplit source hint from the previous three-hint crate. It does not change the production library. Correctness and generated-code preflight passed on CPU3. No throughput matrix has been run for this directory yet.

All three local crates are copied from immutable commit `9011d5228118373f89786d3a1a304f83ea689a85`, whose original native file hashes match the previous leaf experiment's original snapshot. No dependency points at a mutable production or experiment working tree.

| Row | Source delta from original | Role |
| --- | --- | --- |
| `ByteSplitBloomFilter` | No Rust source changes | Original-source control |
| `ByteTripleHintControl` | Byte public `contains_hash`, Four private `contains_scalar`, Split private `contains_scalar`: `inline` to `inline(always)` | Previously selected three-hint control |
| `ByteOnlyInlineV1` | Byte public `contains_hash`: `inline` to `inline(always)` | One-hint candidate |

Cargo package/library names distinguish the candidate types; the original package name is retained. All copies disable automatic binary discovery and publishing. The frozen original binary from the earlier experiment remains unchanged and will be used only for semantic parity. Performance compares the three types in this new single executable; it does not compare timings across binaries or CPUs. Compiler folding of identical functions is possible and will be reported rather than prevented with artificial code changes.

The four-mode timing/helper region is byte-identical to the committed leaf harness. Only imports, three-type registration, unused external adapters and test registration change. Modes remain staged batch prehash, staged batch common-hash, whole-array public singleton prehash and whole-array fused common-hash. Public bulk routing, masks, hash, backend detection, sizes, insertions and parallel code are unchanged. Every timed repetition is validated outside its timer against the full warmup output, including guards and consumption. Four-mode Williams scheduling has eight balanced repetitions.

## Prespecified compact comparison

`protocol.json` proposes 32 workloads / 96 rows: n=2^16 or2^25; requested8/16 (actual16/32) bits/key; batch1/3/31/4096; q=2^22;50% hits;eight repetitions;whole-input insertion;2^24 disjoint calibration negatives. All three rows appear in every workload. CPU3 is the final proposed single pinned CPU, with no NUMA memory-policy claim.

`seed_selection.py` selects the first source-order-only seed pair from integers2000003..2000514 whose complete three-row orders reverse at both key counts. The result is2000003/2000015. Requested budget and batch do not advance the workload RNG, so each pair is first/second once in all16 size/budget/batch groups. Candidate IDs and every derived permutation are retained in `seed-selection.json`. No timings, FPR or key arrays entered seed selection. Two reversed orders do not balance absolute positions: the middle configuration stays in the middle, a remaining limitation.

Report each mode and each seed separately, then descriptive paired geometric ratios with every loss. Compare one-hint/original, one-hint/triple and triple/original. Check equal allocation, checksum and calibration counts. Count quality once per original family/size/budget/seed, not once per clone or reused batch. This native-only experiment cannot establish external leadership or global fastest status. In particular, retain the earlier seed42 batch3 regression and subsequent Byte216 measurements instead of overwriting them.

## Correctness and code-generation preflight required before timing

1. `verify_copy.py` must prove0/1/3 source-hint deltas against immutable Git blobs and exact preservation of the timed helper region.
2. Run all three native libraries and the harness under normal runtime dispatch, `disable-avx512` and AddressSanitizer; run formatting checks and Clippy. The copied native tests retain independent bitmap oracles and collision/parallel checks.
3. Harness tests compare all three public paths and outputs across lengths0..131,4096/4097, offsets0..7, duplicate/colliding inputs, small/large allocations and no-false-negative checks. Invalid output lengths must panic before writes. Corruption of the last result in each of the four timed phases must be detected.
4. Tiny correctness-only CLI fixtures compare all modes at hit0/50/100 and both requested budgets, plus batches1/3/31/4096, against the frozen prior leaf binary. Reject unknown, duplicate or empty selection tokens and invalid dimensions before CSV output.
5. Archive typed whole-array public-call and bulk assembly, identify remaining hot calls, shared constants and any folded bodies. Explain differences between one-hint and triple-hint codegen before interpreting performance.
6. Freeze all copied sources, helpers, protocol and executable; independently guard exact three-row ordering, phase schedule, row dimensions, full trial vectors and final hashes. Require the inherited actual exclusive socket lock descriptor, matching environment and CPU affinity. Reject Python `-O` at driver entry.

The initial CPU2 proposal is preserved in `initial-proposal/`; final performance placement moved to CPU3 before any throughput, with all dimensions and seeds unchanged.

No performance run is authorized until parent review, a committed freeze and an explicit matching socket lease. Existing Byte216, leaf112 and production sources/binaries are untouched.

## Completed preflight

All three copied native crates passed29 tests each under normal runtime dispatch, `disable-avx512` and AddressSanitizer (nine suites). The harness passed9 tests under each of the same three modes. Formatting, Clippy,24 tiny semantic fixtures (72 current rows and48 immutable old-reference rows),6 invalid CLI cases and17 offline guard tests passed. Initial import ordering failed the formatting check; `validation-format-attempt/` preserves that failure before compiler/test work. Reordering imports changed no timed helper or library code. The initial proposal source hashes remain preserved.

The executable SHA-256 is `e07494fceb045dacea9942e03a9edbb850e49a56a701616ce78dea0a320cac12`. Typed assembly contains six distinct visible functions; no folding occurred. Both inlined Byte variants embed AVX2 `vpmulhw`/`vpshufb`/`vptest` directly in the visible loop. Their remaining `contains_scalar` calls belong to the runtime scalar fallback. Original public `contains_hash` remains a per-key call in its visible loop.

`audit_byte_equality.py` verifies identical active AVX2 code for one-hint and triple-hint visible loops:82 prehash and110 fused instructions. All three public batch functions are500 bytes and have the same79 selected active batch3 AVX2 instructions. Normalization preserves opcodes, registers, ordinary operands and relative instruction offsets, resolves RIP references to exact shared constant addresses, and converts local branches to offsets. It excludes scalar fallback and cold panic code, which remain in full disassembly. Batch hot-loop addresses differ: original/triple are32 modulo64, one-hint is0. This code-generation evidence supports a controlled performance test; it does not establish its outcome or attribute future timing differences to alignment.

Only Byte types are registered here. Unreferenced Four/Split code in the triple-hint copy may be removed by LTO. This isolates the one-hint Byte API in the new executable; it does not reproduce the previous ten-type binary's layout or establish invariance across applications. Production, earlier binaries and all previous gains/losses remain untouched.
