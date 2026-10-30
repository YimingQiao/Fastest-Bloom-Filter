# FastPattern direct-word range prototype

**Source preparation only. Not compiled, validated, calibrated or timed.** The
production library and the running exact-budget74 matrix remain unchanged.

This prototype follows the primary mapping in the neighboring
[capacity design](../2026-10-29-native-range-capacity-design.md):

```
a = (uint64_t(high32) * word_count) >> 32
b = a XOR (8 + ((low32 >> 20) & 7))
```

`word_count` is16 times the number of complete64-byte lines fitting the explicit
byte ceiling. Therefore XOR changes only the low4 slot bits and both words stay
in the same allocated line. Mask/delta input remains disjoint from address input.
Range preimage counts differ by at most one; this is not a perfectly uniform
finite-domain map. No FPR or speed improvement is assumed.

The explicit constructor is `(real_keys, FastPatternRangeBytes{byte_ceiling})`;
the `(real_keys,bpk)` convenience form uses checked `floor(real_keys*bpk/8)`.
Minimum128 bytes and maximum256MiB match the earlier range prototypes. Real n
and logical bitmap bits determine the unchanged6/8-probe threshold. Complete
backing capacity is charged and must fit the ceiling. Explicit empty expected
input is allowed with a valid byte ceiling; the n/bpk form rejects zero bytes.

All two-mask tables/rotations, public tiny-query dispatch, paired8/full16
structure, prefetch distances and sequential OR insertion remain unchanged.
Only sizing and scalar/vector primary address reduction change. Paired SIMD
preparation multiplies duplicated high32 values and shuffles the product high
halves. Full-lane reduction computes even/odd unsigned products separately,
then blends their high halves. The AVX512 path needs F plus the existing AVX2
load/store support, with no additional VL/BW/DQ requirement; this remains an
unverified source-level expectation until the feature-boundary build passes.

`parent.h` and `source-snapshot/base.h` preserve the source used for preparation.
`source-provenance.json` records their hashes. The scalar oracle uses independent
division/modulo addressing, independently implemented rotation and literal
copies of the frozen tables. Planned tests compare every bitmap word, missing
required probe bits, all1024 codes in both dictionaries, reducer boundaries,
duplicate inserts, real-n density threshold, short/long tails, output guards,
and both sides of the2MiB prefetch threshold. CMake has native, AVX2, scalar and
AVX512F-minimum configurations, with optional ASan+UBSan. No build command has
run yet, and a separate CPU lease is required before any validation.

Construction is serial/exclusive. Read-only queries can be shared after external
synchronization. The production power-of-two parallel ownership algorithm is
deliberately not attached: arbitrary-line partitioning requires a separate
verified implementation. No Rust port or promotion is implied.
