# Proposed native integration

`native-cpp.patch` implements the `FourSectorHybridWideUnmasked` scheduling policy
against the native header whose SHA-256 is recorded in `native-patch-base.json`.
It is deliberately **not applied** to the production source. `git apply --check`
passes. A renamed, patched native class is retained in
`four_sector_native_candidate.h`; `check_native.cpp` compares its complete outputs
with the frozen scalar oracle. Both ASan/UBSan and a build enabling only AVX2 plus
AVX512F (explicitly disabling AVX512VL/DQ/BW) pass on CPU5. The standalone native
patch was correctness-tested, not performance-measured; the recorded timings use
the equivalent experiment template. Native code generation needs its own final
comparison after integration.

The dispatch policy is:

1. Keep empty queries and 1–3 keys on the existing paths.
2. Under AVX512F, for 4–63 keys and bitmap >2 MiB, prefetch every queried cache line
   before computing masks or gathering words.
3. Use the new eight-key/two-gather kernel for 4–8 keys at any bitmap size and for
   every 4–63-key batch above 2 MiB.
4. Keep the existing 16-key kernel for resident batches of 9–63 and all batches of
   at least 64. Preserve scalar and AVX2 fallbacks.

The eight-key kernel repeats the eight input hashes across both halves of a ZMM
register. Low/high 32-bit fields use index vectors
`[0,2,...,14,0,2,...,14]` and that vector plus one. The first gather probes sectors
0/1, the second sectors2/3. Lower eight lanes use rotations0/16, upper lanes8/24.
Indices, dictionary lookup, rotation bits, and word masks are unchanged. Combine
the two 16-bit match masks, then `pass &= pass >> 8`; the low eight bits become
query answers. Valid gather lanes are `valid8 * 0x101`. Full eight-key groups use
an unmasked 64-byte load; shorter groups use the masked load. Output stores remain
masked to the number of valid keys. No extra bitmap or scratch allocation occurs.

## Rust mapping

Add `lookup_short_avx512` inside `rust/src/four_sector.rs`'s x86_64 implementation,
with the same `#[target_feature(enable = "avx2,avx512f")]` as existing kernels.
Use `self.lines.as_ptr().cast::<u32>()` as the gather/prefetch base and retain the
existing `word_mask`. The Rust intrinsics map directly to those in the patch;
`_mm512_srli_epi32::<26>` and `::<4>` use const parameters. Mask types are u8 for
hash loads and u16 for gathers/output stores. Check the remaining slice length
before the unmasked load. Avoid constructing pointers past the input slice even
when corresponding lanes would be masked.

Apply the short-batch dispatch only after the public output-length assertion and
runtime AVX512 check. The existing `disable-avx512` feature must continue to skip
this entire path. `_mm_prefetch::<_MM_HINT_T0>` uses the unchanged word index
`((hash >> 32) as u32 & self.word_mask) as usize` for each key in the short batch.
The public API, insertion, parallel partitioning, ownership, and atomics are
unchanged; this patch introduces no mutable query state.

Repeat native/Rust full-output parity at lengths 0–131, unaligned offsets, all
inserted keys and absent probes, then normal/disable-avx512 tests and sanitizers.
Compare new and old query-only and hash+query times separately. Expected tradeoff:
large short batches improve strongly, while resident batch31 hash+query can lose
roughly 2–3%. This does not address the remaining single-key external-baseline gap.
