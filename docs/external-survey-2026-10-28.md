# External baseline survey — 2026-10-28

This is a source/API survey, not a performance ranking. Integration priority
reflects relevance to general-purpose, insertion-capable Bloom filters. A project
calling itself “fastest” is a candidate to measure, not evidence that it wins our
workload. An unintegrated candidate below has not been benchmarked by this project.

## Initial mandatory comparisons

| Priority | Implementation and immutable revision | Integration contract | Caveats |
| --- | --- | --- | --- |
| 1 | [Boost.Bloom 1.92.0](https://github.com/boostorg/bloom/tree/0909b9955e2dc02a0356351a2dfb567d4d5af772) | Native C++, scalar and public bulk insertion/query; register blocks, cache blocks and SIMD multiblocks; custom avalanching identity hasher for prehashed input | Use its bulk prefetch pipeline for batched comparisons. Count alignment/tail allocation, not just `capacity()/8`. Probe count and stride are meaningful tuning dimensions. |
| 2 | [FastFilter C++](https://github.com/FastFilter/fastfilter_cpp/tree/7c5bf187d5096ccbcec6a16e02975d0af3328b01) | `SimdBlockFilter<HashFamily>` and `SimdBlockFilterFixed<HashFamily>` support identity hash injection; fixed variant exposes `AddAll`; classic `bloom.h` adds an accuracy reference | The library is explicitly research code. SIMD constructor arguments have different semantics; validate `SizeInBytes()` rather than interpreting their names. Preserve upstream batch insertion where available. |
| 3 | [PageBloomFilter](https://github.com/PeterRK/PageBloomFilter/tree/bcf10622ab740b4dfd99631b27484ecedb96646a) | C++ `PageBloomFilter<N>(page_level,page_num)` with N=4…8, `set(bytes,len)` / `test(bytes,len)`; portable and AES hash builds | Public APIs hash byte strings internally, so compare end-to-end on identical raw bytes. Calling these APIs on prehashed words does not create a pure-query measurement. `data_size()` gives bitmap bytes. |
| 4 | [Bloomsday](https://github.com/sidd-27/Bloomsday/tree/11f16a91a1c8a20344cd263e908f957dac7cf5d0) | Native Rust `BlockedBloomFilter`, `insert_hash(u64)` / `may_match_hash(u64)`; eight multiply/shift probes per 32-byte split block | Constructor takes expected entries and an FPR sizing parameter, no byte getter. Bitmap bytes must be derived from its pinned constructor, and FPR must still be measured. No public batch API. |
| 5 | [fastbloom 0.17.0](https://docs.rs/fastbloom/0.17.0/fastbloom/) | Native Rust prehashed APIs and separately documented atomic type; already pinned by the external Cargo lockfile | Ordinary Bloom probing supplies a lower-FPR comparator at equal space. Its speed cannot be separated from that accuracy advantage. |

Boost's [current release page](https://www.boost.org/releases/1.92.0/) and
[API documentation](https://www.boost.org/doc/libs/1_92_0/libs/bloom/doc/html/bloom.html)
confirm that the stable release supplies bulk operations. The optional adapter uses
the release archive SHA-256 from the official archive metadata, and leaves the
upstream implementation unchanged. Its identity hasher is marked avalanching to
avoid Boost's additional default remix of a non-avalanching hash.

The [FastFilter source](https://github.com/FastFilter/fastfilter_cpp/tree/7c5bf187d5096ccbcec6a16e02975d0af3328b01/src/bloom)
contains the Impala-derived split-block implementations. Its ordinary SIMD variant
uses a power-of-two directory, while the fixed variant uses a multiply-high range
reduction. These must be separate rows. Using a templated identity hasher preserves
the actual upstream mask and address logic while moving only the common source
hash outside the pure-query timer.

[PageBloomFilter's header](https://github.com/PeterRK/PageBloomFilter/blob/bcf10622ab740b4dfd99631b27484ecedb96646a/include/pbf.h)
exposes explicit page size and count, along with a target-FPR factory. Use explicit
page dimensions for memory sweeps and retain multiple ways/page sizes. Its source
has language-specific and AES variants; testing one variant does not establish a
result for all of them.

[Bloomsday's pinned implementation](https://github.com/sidd-27/Bloomsday/blob/11f16a91a1c8a20344cd263e908f957dac7cf5d0/src/lib.rs)
uses compiler-friendly loops rather than hand-coded SIMD. Its public prehashed API
makes it a direct native Rust comparator without imposing its raw-key xxHash cost.
The external lockfile must still retain its transitive dependency revision.

## Further relevant candidates and scope boundaries

- [BlowChoc / Blocked Bloom Filters with Choices](https://drops.dagstuhl.de/storage/00lipics/lipics-vol338-sea2025/html/LIPIcs.SEA.2025.25/LIPIcs.SEA.2025.25.html), SEA 2025;
  [implementation](https://gitlab.com/rahmannlab/blowchoc-filters/-/tree/2c6da95532eda8b1dd0444c24516193a67edc508).
  It chooses among two or more cache-line blocks using a cost function, improving
  blocked-filter space/FPR efficiency particularly at low target error rates.
  The published implementation uses Python/Numba with parallel partitioning.
  Additional block probes and insertion work are the intended tradeoff. Include
  it when expanding the low-FPR or JIT-compiled baseline suite; this survey has
  not timed it.
- [RocksDB FastLocalBloom](https://github.com/facebook/rocksdb/wiki/RocksDB-Bloom-Filter)
  is now integrated at [v11.12 / ef3dd12](https://github.com/facebook/rocksdb/tree/ef3dd12e9a6314aaf08fba6d5d445494eac9b253).
  The [adapter](../benchmarks/rocksdb-external/README.md) preserves its bitmap
  primitives, eight-slot insertion pipeline and MultiGet32 query schedule. Eight
  configurations distinguish automatic/fixed probe counts and scalar/bulk APIs.
  These are prehashed core-filter comparisons; SST queues, serialized metadata,
  byte hashing, reader and database costs are explicitly excluded. Integration
  validation precedes the separate performance screen.
- [peterboncz/bloomfilter-repro](https://github.com/peterboncz/bloomfilter-repro)
  is the authors' original reproduction source for the
  [VLDB 2019 paper](https://www.vldb.org/pvldb/vol12/p502-lang.pdf).
  It is useful for validating the provenance of the repository's historical
  sectorized baselines and testing original rather than reconstructed variants.
  The existing local variants alone do not establish superiority over every
  configuration in the original artifact.
- [SuperBloom](https://github.com/EtienneC-K/SuperBloom/tree/2bab3d9b10e7f555b46d65b4029429814394526a)
  is a 2026 genomic-stream design using minimizer grouping and overlap consistency.
  Adjacent k-mer streams provide locality absent from shuffled independent u64
  queries. Compare it on a separate sequence workload, preserving its streaming
  interface and error semantics. An ordinary random-hash result cannot establish
  a win over its intended workload.
- [cuSBF](https://github.com/tdortman/cuSBF) and GPU blocked Bloom filters change the
  hardware and host/device transfer contract. Their throughput belongs in a GPU
  track with transfer, memory and batching costs stated; they are not ruled out
  by CPU-only results.

Xor, binary-fuse, Ribbon, Cuckoo and quotient filters are useful approximate-membership
controls but should retain their actual semantics. In particular, static xor/fuse
construction cannot replace arbitrary online insertion, and deletion-capable filters
provide a capability absent from ordinary Bloom filters. Report them in a separate
AMQ track if included, with build/rebuild/failure costs and capabilities explicit.
The [FastFilter project](https://github.com/FastFilter/fastfilter_cpp) collects many
of these families and links their original papers.

## Comparison requirements

1. Measure public single-key and bulk APIs separately; avoid disabling an opponent's
   available software-prefetch or SIMD path by wrapping only its scalar API.
2. Preserve real allocation sizes, actual operation counts, build scratch, and
   no-false-negative checks. Record each dependency revision and compiler flags.
3. Compare pure query only where all participants actually accept prehashed input.
   Separately time hashing plus insert/query on identical raw keys.
4. Sweep layout/probe configurations and memory budgets, then report the
   latency–space–measured-FPR frontier. Do not let a saturated small filter win by
   returning nearly all positives.
5. Use enough independent absent queries for the claimed FPR band. Keep confidence
   or conservative count bounds visible when the number of observed errors is small.
6. Define a performance claim by hardware, API, batch, hit ratio, size/FPR budget,
   and tested baseline set. No finite survey proves an unrestricted global winner.
