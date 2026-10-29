# Isolated Rust FourSectorRange12 port proposal

This is source preparation only: no compiler, filter, accuracy or performance run has executed for this port. The complete C++ fresh78 confirmation is sealed at `689e40b8`; it supports the strict24 bulk niche, not a default replacement. Production `rust/` and `include/` are untouched.

`derive.py` reads immutable native source from `79351bc33a256b79dc9cd71e7ac1aebfac37f8c5` with `git show`. It derives the FourSector SIMD pipelines, mask dispatch/tails, exclusive build and immutable query helper mechanisms into a separate dependency-free MIT crate. The exact K12 table/mapping is taken from the already validated C++ layout. The initial Python source-only syntax attempt and corrected derivation records are retained; no compiler ran in either attempt.

## Mapping and API

Each cache line holds16 u32 words. `L=floor(byte_budget/64)` accepts128 bytes through256MiB, so2<=L<=2^22. Actual backing capacity is checked against the supplied ceiling. `new(real_n,bpk)` uses checked floor(n*bpk/8); it does not reinterpret n as a capacity proxy.

- `line = floor((h>>40)*L / 2^24)` uses only the top24 bits.
- `base = line*16 | ((h>>32)&3)`; sectors1/2/3 XOR4/8/12 and the next pairs of offset bits at34/36/38.
- Each sector uses the fixed16-entry three-bit dictionary and rotated low32 code (right rotations0/8/16/24). Address, offset and low-mask fields remain disjoint.
- AVX512 and AVX2 range addressing multiply even/odd u32 lanes into u64 products before shifting24; existing gather, sequential-OR collision handling and output tail guards remain. AVX2 retains the native Rust prepared insertion pipeline; the C++ scalar AVX2 insertion path is semantically equivalent, not claimed to have identical code generation.

The isolated public type exposes `with_byte_budget`, `new`, `size_in_bytes`, `line_index`, `bitmap_words` (read-only fixture access), `backend`, single/batch insert and lookup, build workers/scratch, exclusive parallel build and immutable parallel lookup. `disable-avx512` retains runtime AVX2/scalar fallback. No atomic concurrent writer API is added.

## Exact parallel ownership

The private scheduler is copied from the pinned native helper, replacing its power-of-two-only shard computation with `owner = floor(physical_line*T/L)`. It receives the actual top24-derived physical line. Shard p owns `[ceil(p*L/T), ceil((p+1)*L/T))`; the integer inequalities are exactly equivalent to that owner formula. Each mutable slice is exclusive, every SIMD index subtracts the global `begin*16`, and scatter counts derive from the same owner. The rest of the three-pass histogram/scatter/insert mechanism, worker rules, checked scratch accounting and immutable lookup scheduling stays unchanged.

There is deliberately no high32 or divisibility shortcut. The generic division may cost throughput, but avoids importing an invalid address proof. In particular `floor(high32*T/2^32)` is not a substitute for the top24 mapping near arbitrary T boundaries. Optimization comes only after correctness and actual port measurements.

## Focused correctness proposal, not yet run

Five Rust test functions cover exact allocation/3-bit dictionaries, full independent u128-address/per-bit bitmap oracle, collision-heavy and duplicate insertion, scalar/runtime AVX2/AVX512 parity, all lengths0..131 plus4096 and input offsets0..7 around the2MiB threshold, owned-slice rebasing, T3/T7 builds on17 and32769 lines, old+new key membership, concurrent immutable readers, invalid output length and checked scratch overflow. A pure owner test covers arbitrary line counts up to2^22 and top24 boundary values around shard splits for T1/3/7/8.

Proposed finite compilation stage after source review/commit and a socket lease:

1. Rust optimized baseline-target, `disable-avx512`, and ASan tests/fixture binaries. Forced scalar and AVX2 tests remain inside the module, with no public bypass adapter. Baseline-target code checks portable ordinary paths; target-feature SIMD is reached only through detected capabilities.
2. One normal C++ fixture built against the exact frozen public K12 header and its recorded dependencies. The already passed42 algorithm/backend checks are not repeated.
3. Six C++ full bitmap+dense-output byte streams:3/17/32769 lines × ordinary/hotspot hashes. Twelve Rust streams per mode add worker requests3/7. Compare every byte, not only checksums; retain sizes/digests/commands and exact comparison outcomes. This gives36 Rust cross-language fixture comparisons, plus the five focused tests per Rust mode. No throughput or FPR inference from these fixtures.

All build outputs use new paths. The native crate has no external dependencies or links to mutable production sources. Compile errors, sanitizer failures and changes will be retained/versioned. A future performance adapter must call the actual isolated public API and preserve before/strong external controls; no performance run is part of this proposal.
