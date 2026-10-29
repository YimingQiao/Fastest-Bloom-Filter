# Safe single-line scalar K12 hypothesis

This single isolated candidate derives the **original** K12 crate at `645f397cd406fd7e89cc75020b0b6fe2f142b3ab`. It does not inherit either rejected `inline(always)` hint. The public `contains_hash` and private `contains_scalar` retain their original ordinary `#[inline]` annotations.

Only `contains_scalar` changes: take one safe reference to `self.lines[indices[0] >>4].0`, then read the four words through their local `index &15`. There is no unsafe access, new hint, altered mask/index calculation, allocation change, public routing change, insertion change, backend change or parallel helper change. Clone package/library identity and a focused test are the only other deltas. The completed two-hint experiment remains archived as a loss-bearing alternative, not the parent of this candidate.

## Why one reference is valid

Let the physical line be `L=floor(top24(hash)*line_count/2^24)`. The original base word is `16L | (hi &3)`. The other three indices XOR only values in the low four bits: `4 ^ ((hi>>2)&3)`, `8 ^ ((hi>>4)&3)`, and `12 ^ ((hi>>6)&3)`. Therefore all four global word indices have the same value after shifting right4. Each local index masked by15 is in0..15. Because `top24<2^24` and the constructor keeps `line_count>0`, `L<line_count`; the same checked vector access that the old first probe required obtains the one valid line.

`line_invariant.rs` checks the actual private probe function against independent u128 division at the minimum, nonpower-of-two, prefetch-boundary and maximum line counts. It exercises boundary addresses immediately below/at range transitions, all256 offset bytes and five low-hash patterns, without allocating a maximum-size bitmap. Its purpose is this new physical-line invariant; the old broad kernel/parallel tests are not the intended rerun.

The hypothesis is that one global bounds check and one line address can replace four repeated checks/base calculations, possibly reducing register pressure. The actual compiler may still outline the helper, inline it, or generate equivalent code. Actual linked caller assembly is the first gate; no speedup or fewer instructions is presumed.

## Bounded next proof and comparison

Derive the same original21-config actual caller at `72625673e6b5bb57874a5fa53e04d23ffb8c6ab2`, append only `FourSectorRange12SingleLineV1`, and preserve every old adapter/timed/workload helper. Normal and ASan focused checks will compare complete original/candidate bitmaps and singleton/bulk outputs, tails/guards/immutable inputs/invalid lengths, plus this new invariant. Reuse earlier mapping/backend/parallel evidence instead of a broad revalidation. Inspect the actual old/new public callers and scalar helpers, retaining any outlining or failed hypothesis.

The possible performance protocol remains the finite72-row old/new/Range internal comparison: actual24 bits/key, n2^16/2^25, batches1/3/31/4096, three seen Rust108 seeds, q2^22, eight balanced query repetitions, all eight query/build contracts, calibration0. No new quality sample, seed search or variant search is permitted. Historical quality is context only after exact bitmap/output identity. Preserve all losses and the same source-derived first/middle/last candidate order. Source preparation alone does not authorize compilation or performance.
