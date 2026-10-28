# Independent Rust source review

Reviewed `rust/src/four_sector.rs`, `split64.rs`, and `layout_parallel.rs` after
the native integration. The review found no out-of-bounds SIMD access, partition
ownership error, or unsupported-feature dispatch in the inspected paths. This
is a source/ownership review; the JSON evidence in this directory records C++
executions, not an independently run Rust sanitizer suite.

The one concrete finding was unchecked construction-scratch arithmetic. Both
new public filters accept an arbitrary `usize n` for estimation, so
`build_scratch_bytes(usize::MAX, 2)` could wrap to a small value in release mode.
The implementation owner replaced the arithmetic with checked multiplication
and addition and an explicit `build scratch size overflow` panic, and added a
public-API regression test. This finding concerns accounting/error behavior;
no memory-unsafe operation follows from the estimator itself.

## Ownership and initialization

The owner function is `floor(line_index * workers / line_count)`. The mutable
line slices use boundaries `ceil(part * line_count / workers)`, so every hash in
a partition maps into exactly its owned slice, including non-power-of-two worker
counts. Worker count is bounded by line count. Histogram rows and scatter slices
are disjoint; scoped threads join before later phases consume their output.

The `MaybeUninit<u64>` allocation is converted to an initialized input slice only
after every histogram-counted slot has been written. A worker panic unwinds the
scope before that conversion; dropping incomplete `MaybeUninit` storage is safe.
Concrete private index closures depend only on the hash and immutable mask, so
they do not change ownership between histogram, scatter, and insertion.

FourSector subtracts `begin * 16` from global word indices; Split64 subtracts
`begin` from global line indices. Both are bounded by the owned slice. The sizing
cap keeps FourSector's indices below 2^26 and the rebasing constants within signed
32-bit SIMD index range. Every probe remains in the same physical line. Complete
line loads/stores in Split64 therefore do not touch another worker's memory.

## SIMD boundaries and feature selection

Runtime AVX-512 dispatch checks both AVX2 and AVX-512F, matching the functions'
`target_feature` annotations. AVX2 is checked separately. `disable-avx512`
retains AVX2/scalar dispatch, and non-x86-64 builds select the scalar path.

FourSector's AVX-512 insert reads four hashes only when all four exist, and its
AVX2 insert reads two only when both exist. Prepared writes use sequential ORs,
so same-word collisions preserve all masks. Query loads/gathers/stores use valid
lane masks for the last partial AVX-512 group; it forms the second eight-key
pointer only when that group exists. AVX2 queries consume complete eight-key
blocks and finish scalarly. The public query length check precedes all writes.

Prefetch indices are masked and rebased into the same owned allocation as real
writes. FourSector checks the full 64-key lookahead plus vector width. Split64
uses `saturating_sub(32)` to bound its prefix, so every `i+32` is valid. Empty
partitions never enter a raw-pointer load/store loop. Both line types have
`repr(C, align(64))` and exactly 64 bytes of integer payload, matching their
aligned SIMD loads and word reinterpretations.

The subsequently added short-query AVX-512 path was also inspected. It repeats
at most eight hashes in both vector halves, uses two masked gathers for sector
pairs 0/1 and 2/3, intersects low/high answer masks, and stores only valid low-half
lanes. `valid * 0x101` fits `u16` even for eight active keys. Every input load is
masked for incomplete groups; advancing the loop past the final short group
forms no later pointer. Its upfront prefetch touches only masked bitmap indices.

Ordinary writes require `&mut self`; read-only calls use `&self` and distinct
mutable output slices. `Send + Sync` derives from the fields without custom
unsafe trait implementations. These are exclusive-build/read-only filters,
not online concurrent-writer atomic types.

## Scope and follow-up

The existing tests force scalar/AVX2/runtime paths, compare complete bitmaps,
exercise 0/max hashes and same-line contention, use irregular worker counts,
and cover large owned slices that enable prefetch. Further checks should keep
public invalid-size behavior and scratch overflow explicit. A genuine non-x86
cross-build and Rust sanitizers/Miri would be additional evidence, not results
established by this review.

One performance distinction is intentional: Rust's parallel FourSector prefetch
threshold uses the owned slice's bytes, while the C++ wrapper currently calls a
kernel whose threshold uses total bitmap bytes. This changes performance tuning,
not layout or membership, and should remain visible in cross-language analysis.
