# Read-only query audit

The frozen local adapter sources and native headers are listed by SHA-256 in
`snapshot.json`. This audit concerns queries after completed serial construction;
it does not authorize overlapping writes or destruction. The harness publishes
`const BF&` and joins all workers before touching the filter lifetime again.

| Family | Inspected query path | Shared state during query |
|---|---|---|
| FastPattern/FourSector/Split64/ByteSplit | Native const `Lookup` and called scalar/SIMD helpers | Immutable bitmap, dimensions and constant mask tables; output belongs to the call |
| FastFilter SimdBlock/Fixed16/32/64 | Const adapter `Lookup`, upstream const `Find` | Immutable bucket directory and stateless identity hasher; masks are local |
| FastFilter classic and branchless/bulk-build aliases | Const adapter `Lookup`, upstream const `Contain` | Immutable bitmap and stateless identity hash; bulk insertion scratch is not retained for queries |
| Boost 1.92 | Const adapter `Lookup`, const `filter::may_contain` and its bulk overload | Immutable core bitmap and identity hasher; bulk callbacks capture per-call iterators and output pointer; counting allocator is not called |
| RocksDB FastLocalBloom direct/fixed/bulk | Const adapter `Lookup`, upstream `HashMayMatch` / `PrepareHash` / `HashMayMatchPrepared` | Immutable char bitmap and probe count; bulk upper-hash/offset arrays are local stack storage |
| PageBloom | Const adapter `Lookup`, upstream const `PageBloomFilter::test` | Reads page directory; raw-byte hashing uses local accumulators; any empty-key fallback is static const |

Upstream sources inspected locally include the pinned FastFilter
`src/bloom/{simd-block.h,simd-block-fixed-fpp.h,bloom.h}`, PageBloom
`include/pbf.h` and `src/{pbf.cc,hash.cc}`, Boost
`boost/bloom/filter.hpp`, and the vendored RocksDB `util/bloom_impl.h`.
The adapter headers already expose const APIs; no const-cast is applied to the
filter object. The copied shared kernel retains its legacy cast on the input
pointer only, while all selected APIs treat input hashes as read-only.

Fourteen representative adapter types are validated with concurrent reads of
the same filter at T=1/3/8 and multiple tail sizes. Native, ASan/UBSan and
ThreadSanitizer tests provide additional evidence for these paths; they do not
claim a proof for arbitrary future adapter changes or concurrent mutation.
