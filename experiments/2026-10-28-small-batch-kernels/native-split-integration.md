# Split64 integration mapping

Apply [native-split-production.patch](native-split-production.patch) with
`git apply`. It passes `git apply --check` against the current production header
and is exactly the validated `native_split_after.h` with its class renamed to
`Split64BloomFilter`. Expected production header SHA-256 after application:
`9b548e880b927ade57ef27c946f0105e9abe9c2b2436eecdbbbff0a22d30f429`.

The public query dispatch is:

1. One query: return the original one-key lookup directly, retaining the original
   32-bit multiply, 32-bit shift, widening, and 64-bit variable shift mask.
2. AVX-512 and fewer than 16 queries: loop over `LookupOneWide`. This branch also
   accepts length zero without dereferencing the input/output pointers.
3. All other cases: retain the existing prefetch-32 and original mask path.

Insertion is unchanged, including its original mask path and prefetch distance.
Scalar and AVX2 paths retain their existing mask implementations and receive only
the direct one-query return. The new private helper has fallback code for those
backends, but public dispatch invokes it only in the AVX-512 build.

For Rust, preserve the existing compile/runtime feature checks. The wide helper
requires AVX-512F. Construct eight `u64` salts from the same eight low-32-bit
constants; broadcast `(hash as u32) as i64`; use `_mm512_mullo_epi32`,
`_mm512_srli_epi64::<26>`, then `_mm512_sllv_epi64` with eight ones. Each high
32-bit salt is zero, so each high product lane is zero. The 64-bit right shift
therefore yields exactly the old unsigned 32-bit product shifted by 26. Keep
the existing line index and containment reduction, as well as any partition
rebasing and bounds checks. The optimization changes no bitmap mapping.

The Rust single-only control should add only the one-query return while retaining
the old mask everywhere. This control matters: in C++ it reproduces most of the
large short-batch hashing-plus-lookup improvements. Do not attribute those gains
solely to eliminating a widening instruction. Native C++ prehashed comparisons
favor the hybrid over that control at batches 4/8/15, with an approximately 2%
hashing-plus-lookup regression at large-bitmap batch 31 in the actual16 screen.
The separate [report](native-split-report.md) contains the exact evidence.

A possible full-64-bit broadcast variant is mathematically equivalent because
the high salt lanes are zero. It was deliberately excluded from this frozen
patch: any further source-level reduction needs its own measurements.
