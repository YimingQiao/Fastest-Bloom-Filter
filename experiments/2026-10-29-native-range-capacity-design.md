# Native capacities without power-of-two rounding

This is a source-only design audit, not a performance result. The production native constructors and bitmap mapping remain unchanged. The native Rust source referenced here is the unchanged library recorded by the visible-single preflight at `4004e3f50e85385e5a3c7752d62b7a8797f15146`. Subsequent isolated C++ ByteSplit/Split64 prototypes and correctness evidence are archived in [range-layouts](2026-10-29-range-layouts/README.md); FastPattern/FourSector changes and arbitrary-capacity parallel construction remain design proposals.

The first experiment should add an explicit byte-budget constructor to isolated ByteSplit and Split64 types. Their probe masks use the low 32 hash bits, so arbitrary-capacity range reduction of the high 32 bits preserves independence between block selection and mask selection. FastPattern is feasible by directly range-reducing to the complete u32 word count, while preserving its low-hash masks and XOR delta. FourSector needs a separate mapping decision: a direct substitution for its address mask can introduce substantial address/probe correlation. None of these changes should silently replace the existing default mapping.

## Capacity and reporting contract

Keep the actual input count `n` unchanged. An isolated `with_byte_budget(n, B)` should allocate `L = floor(B / 64)` complete aligned cache lines, reject budgets below the existing 128-byte minimum or above the 256 MiB limit, and expose actual allocated bytes. It must not fake `n`, inflate the nominal bits/key, or construct trial filters during a timed phase. An explicit `from_line_count(L)` can provide the exact internal constructor. A separate convenience constructor that rounds `ceil(n*bpk/8)` upward to 64 bytes is useful, but its actual allocation may exceed that nominal byte budget and must not be confused with an at-most budget API.

FastPattern must still choose its sparse/dense dictionary using the real `n` and actual bitmap bits (the current threshold is `n > actual_bits / 12`). A synthetic constructor `n` would change the mask distribution as well as capacity; supplying real `n` explicitly prevents that hidden change. Byte/Split/Four do not currently use `n` to choose their mask families.

All integer sizing calculations need checked multiplication/addition. Actual allocation must be reported from the actual backing allocation/capacity rather than the requested payload. Whole-line allocation avoids partially owned lines; ByteSplit can continue using all four 16-byte buckets in each line. A future odd bucket count could save logical bytes but would still pay its 64-byte backing padding, which must remain counted.

Retain the existing power-of-two constructors and their bitmaps. Range addressing changes which line a hash chooses, even at a power-of-two size if multiply-high selects high bits while the old mask selects low bits. Label the address policy explicitly. Isolated types or compile-time policy parameters avoid adding a per-key policy branch to the unchanged baseline. A public runtime policy would need its own measured singleton dispatch cost; batch dispatch could select a monomorphized policy once per call.

## Address mappings

Let `hi = h >> 32`, `lo = uint32(h)`, and `L` be the line count. Every expression below uses a wide unsigned product. The common 32-bit range reducer is `R32(x, m) = (uint64(x) * m) >> 32`. It maps to `[0,m)`; when `m` does not divide `2^32`, bucket source-state counts differ by at most one. This small finite-domain bias must not be described as perfectly uniform.

| Layout | Isolated range mapping | Independence and finite-domain limits |
| --- | --- | --- |
| Split64 | `line = R32(hi, L)`; existing eight masks from `lo` | Exactly separates line input bits from all probe input bits. At the 256 MiB maximum there are at least 1,024 high-hash source states per line. |
| ByteSplit | `bucket = R32(hi, 4*L)`; `line = bucket >> 2`, slot `bucket & 3`; existing signed-multiply/shuffle masks from `lo` | Exactly separates bucket input bits from masks. Maximum 16,777,216 buckets leaves at least 256 source states per bucket. Preserve flat `bucket*16` pointer arithmetic and 16-byte load alignment. |
| FastPattern, primary direct-word mapping | `a = R32(hi, 16*L)`; `b = a XOR (8 + ((lo >> 20) & 7))`; `line = a >> 4` | All address input bits remain independent of every mask/delta input bit. The XOR changes only low4 bits, so both words remain in the same allocated 64-byte line. Word preimage counts differ by at most one, with at least 64 states per word at the maximum. Within-line slot probabilities have only this finite-domain bias, not the strong reused-top-bit correlation discussed for FourSector. |
| FastPattern, conservative field split | `line = ((uint64(hi >> 4) * L) >> 28)`; first word `16*line + (hi & 15)`; second word XORs the existing low-hash distance | Conditional base-word independence is exact because the reducer and word offset use disjoint fields. The line reducer has only 28 input bits, with at least 64 source states per line at the maximum; its finite-domain load imbalance is larger than R32 but bounded by one source state. Existing low-hash mask and distance fields remain unchanged. |
| FastPattern, full-width alternative | `line = R32(hi, L)`; first word `16*line + ((lo >> 23) & 15)`; existing mask/distance code | Low-hash bits23..26 are currently unused: masks consume0..19 and distance20..22. This preserves independence between line, first word, masks and distance while using all32 index bits. It changes the intra-line mapping and adds a low-word extraction; it needs separate semantic/FPR validation. |

The primary FastPattern option is simpler than splitting out a separate word-offset field. For any `a < 16*L`, write `a = 16*line + slot`; XOR with a value in 8..15 changes only `slot`, so `b < 16*L` and `b >> 4 == a >> 4`. Its two masks and delta use only `lo`, while the complete word address uses only `hi`. Conditional slot probabilities within a line need not be perfectly uniform for arbitrary counts, but the source preimage counts are `floor(2^32/(16*L))` or the next integer. The worst count ratio is at most 65/64 under the existing maximum. This is a bounded finite-range effect, not shared mask/address bits. The field-split alternatives remain documented as controls, not the recommended first implementation.

For ByteSplit, mapping the bucket count directly is preferable to selecting a line from high32 and then reusing its low2 bits for the slot. The direct bucket range remains independent of masks, automatically covers every bucket, and computes physical ownership by a simple shift.

### FourSector cannot use a naive replacement

Current FourSector uses `a = hi & word_mask`, then `a XOR 4/8/12 XOR offsets`, with offsets from `hi[26..31]`. At the largest bitmap, disjoint fields are: line22 bits, base word4 bits and three offsets6 bits. Its low32 supplies the cyclic mask codes and is fully used.

If `line = R32(hi,L)` while the original top6 offset bits are retained, line selection is largely determined by those same high bits. For large `L`, a line's preimage can have almost fixed top6 bits, removing the intended offset variation. The fact that all accesses remain inside the allocation does not establish acceptable FPR.

Two source-only alternatives have different compromises:

1. Preserve exact separation by reducing only the old middle22 line bits: `x = (hi >> 4) & ((1<<22)-1)`, `line = (uint64(x)*L) >> 22`, retain low4 and top6. This is conditionally independent, but near the maximum arbitrary `L` each line has only one or two possible index states. The resulting line-load imbalance can be large. This is not a sensible unqualified replacement across the entire 256 MiB range.
2. Use the product residue as a new mixed-radix intra-line code: `p = uint64(hi)*L`, `line = p >> 32`, `code = (p >> 22) & 1023`; split `code` into a4-bit base word and three2-bit offsets. This spreads the residual states over all within-line choices rather than retaining nearly fixed original high bits. The block range has full32-bit precision, and at maximum power-of-two capacity the joint mapping is exact. At arbitrary capacities, conditional intra-line independence is approximate, not guaranteed: the discretized joint state counts can differ. This changes the mapping and requires independent accuracy gates before any speed claim.

An additional hash permutation could reduce particular correlations, but it adds arithmetic and still requires evidence; it should not be assumed independent simply because it looks mixed. FourSector should follow the simpler Byte/Split experiment, rather than sharing an unchecked generic reducer.

## Query and insertion cost hypothesis

Scalar `AND` becomes a 32-by32-to64 multiply plus extraction. That adds a dependent address calculation before the bitmap load; it may be visible for single queries and hidden partly by independent-key throughput or memory latency. No latency or speed estimate has been measured. Byte/Split otherwise retain their mask kernels, prefetch distances and collision-safe sequential OR operations.

AVX2 and AVX512F provide unsigned widening multiplication for even u32 lanes, not a single all-lane u32 high-product instruction. A vectorized FastPattern/Four address path may need even/odd multiplies plus shifts/repacking, or an alternative lane arrangement already carrying paired sectors. This can be a larger regression than the scalar multiply. Byte/Split currently derive one cache-line or bucket address per key in their horizontal kernels, making them lower-risk first candidates. A power-of-two-only specialization should remain a separate control; compiler-generated divisions or extra policy branches must be checked in assembly rather than assumed absent.

The intended tradeoff is lower actual memory for the required FPR, not a guaranteed faster address operation. Comparisons should retain both exact actual-byte/FPR leaderboards and equal-size kernel controls. Proposed initial capacities are12/14/16/24/28/32bpk with real `n`, actual64-byte rounding, independent calibration and no constructor retuning after observing results.

## Parallel ownership must change with sizing

`rust/src/layout_parallel.rs`, `rust/src/parallel.rs`, and `include/parallel_layout_bloom.h` currently compute the shard with `line_count.trailing_zeros()`/`Log2` and a right shift. This is valid only when the number of lines is a power of two. The shared Rust helper even asserts that condition in debug builds. Removing the constructor restriction without changing these formulas can select the wrong shard or go out of bounds.

The correct general ownership is `part = floor(line * workers / L)`, with line slice boundaries `begin = ceil(part * L / workers)` and `end = ceil((part+1) * L / workers)`. Both counting and scatter must use the exact same global line mapping as insertion. The existing Rust disjoint slices and sequential OR kernels then remain sound; C++ workers likewise own disjoint physical lines. All four ByteSplit buckets in a line must stay with the same worker. Every prefetch and rebased SIMD index must use the new global address policy consistently.

A runtime integer division in each of the histogram and scatter passes may hurt construction. An exact precomputed reciprocal divider could remove that division, but needs exhaustive boundary/property tests and overflow checks; it is a separate optimization. Deriving the shard directly from the original hash as `R32(hi,workers)` is generally **not** equivalent to `floor(R32(hi,L)*workers/L)`. Rare boundary differences can put a hash outside its owned slice and are correctness bugs, not acceptable approximation. Padding `L` back to a power of two defeats the memory goal. A power-of-two partition span changes the effective worker count and load balance and must not be silently reported as the same worker experiment.

The explicit construction scratch remains approximately8 bytes per input hash plus worker metadata. Arbitrary capacity itself does not remove the two partition passes. Read-only parallel lookup requires no ownership change beyond the filter's address mapping.

## IndependentVbmi32 scope

The isolated IndependentVbmi32 candidate has40 position bits and24 remaining block-index bits, with up to8,388,608 32-byte buckets under the current maximum. A disjoint24-bit multiply-range index preserves mask/index separation but at the maximum gives only two source states per bucket (and two/three near arbitrary capacities); its load bias can be substantial. At the strict small-table setting, the number of source states per bucket is much larger, making that concern smaller but still measurable. This is a candidate for a separate strict-small investigation after intermediate-budget rivals are measured; the existing isolated screen is not a production or global-leadership result.

## Required evidence before promotion

Use independent byte/word oracles for arbitrary line counts, including2/3/5/7/31/257 lines and values near size/overflow limits. Check every hash-field boundary, exact duplicate/collision behavior, tail guards, backend parity and unchanged mask calculations. Parallel tests need non-divisible line/worker counts, complete output/bitmap equality with serial insertion, and race/sanitizer checks. Fresh-seed FPR calibration is required for every changed address policy, especially FourSector's conditional distribution. Performance must include singleton and bulk queries, allocation-inclusive builds and equal-core full construction. The linked ByteSplit/Split64 preflight covers serial correctness; it does not establish performance or complete the remaining promotion requirements.
