# Native layout integration proposal — 2026-10-28

Keep `FastPatternBF` and its existing behavior. Add **Split64 first**, then
**FourSector16K8 as an explicit alternative**, with the same batch API and the
same distinction between exclusive parallel construction and concurrent atomic
updates. Share the line-partitioning machinery; keep each layout's hot loops
concrete and independently testable. This document proposes integration, not a
change to the selected default or a claim of a universal winner.

## Why this order

| Candidate | Evidence and useful regime | Cost or remaining limit |
| --- | --- | --- |
| Existing FastPattern | Fastest of these in most unconstrained query screens; already has scalar, AVX2, AVX-512 and parallel/atomic implementations | About 0.203% FPR at 16 actual bits/key; fails a 0.1% target there |
| Split64P32 | About 0.0913% FPR at 16 actual bits/key; eight 64-bit sectors; simple full-line SIMD; strong insertion and small-batch end-to-end performance | Slightly worse accuracy than Boost Multi64K8 in the initial screen; requires new native AVX2 path and parallel/atomic wrappers |
| FourSector16K8 | Held-out per-case Wilson upper endpoint below 0.1% at 64K/1M keys; substantially faster query than Split64 at 64K keys | Narrow FPR margin; construction slower; at 16M keys/batch31 hashing+lookup loses about 37% to Split64 |

Sources: [Split64 results](2026-10-28-split64/README.md),
[FourSector accuracy and timing](2026-10-28-four-sector/README.md), and its
[held-out counts](2026-10-28-four-sector/heldout.csv). These are development
measurements on one machine. The main confirmation matrix must decide the final
recommendation. FourSector K9 has no compelling advantage over K8 at the 0.1%
target; K10/K12 can remain experimental until a stricter target justifies them.
A future three-sector experiment should not change this frozen evidence.

Do not select the layout automatically from the requested bits/key alone.
Actual allocation, FPR target, query batch size, hashing cost, construction rate,
and CPU ISA all affect the choice. All public types should remain native C++
implementations; neither new type requires Boost or other baseline dependencies.

## Minimal public and internal structure

Suggested public headers and types:

```cpp
#include "fast_pattern_BF.h"   // FastPatternBF: unchanged
#include "split64_BF.h"        // Split64BF: frozen Split64P32 mapping
#include "four_sector_BF.h"    // FourSectorBF: frozen 16-entry K8 mapping
#include "parallel_bloom.h"

// All three keep this existing prehashed batch contract:
Filter(size_t expected_keys, uint32_t requested_bits_per_key);
size_t SizeInBytes() const;
void Insert(uint32_t n, const uint64_t* hashes);
uint32_t Lookup(uint32_t n, const uint64_t* hashes, uint32_t* out) const;

ParallelSplit64BF / ParallelFourSectorBF;
AtomicSplit64BF   / AtomicFourSectorBF;
```

The public FourSector class should have a fixed layout, without `MASK_MODE`,
`MASK_TABLE_ENTRIES`, `BF_FOUR_EXTERNAL_BASE`, or a shadow `FastPatternBF` alias.
Keep tuning switches such as prepared insertion and prefetch distance internal.
Preserve the existing public FastPattern concrete class names; replacing
`ParallelFastPatternBF` with a type alias immediately would conflict with its
current friend declaration and potentially downstream forward declarations.

Factor only these small internal pieces:

1. A checked sizing helper matching the current strict-next-power-of-two rule.
   Reject zero bits/key, multiplication overflow, and budgets reaching 2^31 bits.
   This yields power-of-two line counts, a minimum 128-byte allocation, and a
   maximum 256 MiB bitmap. Preserve existing sizing for comparison compatibility.
2. Immutable layout metadata and a scalar probe enumerator for each new layout.
   It returns typed `(word_index, mask)` pairs: four `uint32_t` probes for
   FourSector, eight `uint64_t` probes for Split64. The scalar native kernel and
   atomic implementation must share this calculation.
3. A narrow internal access trait providing `LineCount(filter)` and
   `LineIndex(filter, hash)`, plus access to the immutable layout configuration.
   It must not expose mutable bitmap storage as a public API.
4. Reusable exclusive partition/build and read-only batch helpers under
   `parallel_detail`. New `ParallelBlockedBF<Filter>` wrappers can use these;
   the existing FastPattern wrapper can delegate to the same helpers without
   changing its public class identity.

Keep the bitmap types natural to their kernels: aligned `uint32_t` words for
FourSector and aligned lines of eight `uint64_t` words for Split64. Do not force
them through one runtime-polymorphic base class or add virtual calls per key.
Copying an immutable/native filter retains its layout and contents; copying or
moving while another thread accesses it remains unsupported.

## ISA paths and build boundaries

The first integration can preserve C++'s current compile-time ISA selection:
AVX-512 when compiled with that target, otherwise AVX2 when available, otherwise
scalar. Explicitly document that a binary built with `-march=native` is not a
runtime-dispatched portable binary. Rust already chooses a supported kernel at
runtime; that difference does not change bitmap semantics.

Add an include-only CMake interface for native filters, separate from the
legacy benchmark's `bf_options`, which currently requires AVX2. Consumers of the
native scalar headers should not inherit AVX2 or `-fno-strict-aliasing` merely
because an external benchmark needs them. Keep standalone scalar, AVX2, and
AVX-512 checks as distinct targets. Runtime C++ multiversioning can follow later:
select function pointers once, keep baseline code compiled without AVX flags,
and isolate target-specific kernels. It need not block the first native release.

**Split64 AVX2 implementation:** compute the eight 32-bit multiply/shift
positions with `_mm256_mullo_epi32`, preserving modulo-2^32 multiplication.
Widen the low and high four positions to 64 bits, generate two four-lane bit
masks with variable shifts, and test or OR the two halves of the cache line.
Insert one key at a time so duplicate addresses cannot lose updates. Retain the
scalar mapping and the selected prefetch32 behavior until measured otherwise.

**FourSector AVX2 implementation:** deinterleave eight hashes using the existing
FastPattern AVX2 pattern, compute the four word-index vectors, and issue four
word gathers. A 16-entry dictionary can use two eight-entry register permutations
and a full-lane blend selected by index bit3; expand that bit to all bits of the
lane before `_mm256_blendv_epi8`. Rotate masks with variable left/right shifts.
Use scalar tails first, then a separately validated masked-tail optimization.
Scalar insertion is a correct initial fallback; a later two-key/eight-lane
preparation kernel can use sequential ORs. Do not assume this more expensive
AVX2 path will outperform scalar or Split64 before measuring it.

For AVX-512, retain FourSector's prepared four-key insertion, four-gather query,
and masked tails. Keep the sequential OR stage: a gather/OR/scatter replacement
can lose bits when multiple keys share a word. Masked query loads/stores must
respect exact input/output lengths. A zero-length call should return before any
pointer arithmetic, allowing the current empty-batch/null-buffer convention.

## Parallel construction and query

Both candidates satisfy the existing essential invariant: **all writes from
one hash lie in one physical 64-byte cache line**. The correct line-index hooks
are:

| Layout | Physical line index |
| --- | --- |
| FastPattern | `((hash >> 32) & word_mask) >> 4` |
| FourSector | `((hash >> 32) & word_mask) >> 4` |
| Split64 | `(hash >> 32) & line_mask` |

Do not apply `>>4` to Split64's current `Block()` result: it already indexes
lines. Worker limits likewise use line count, not the number of 32-bit words.

Reuse the current three-pass build:

1. Per-worker, cache-line-aligned/padded histograms count destination owners.
2. Prefix sums and a disjoint scatter partition the input hashes by owner.
3. Each worker calls the native insertion kernel on its partition. It owns
   every byte of those lines, including Split64's full-line vector stores.

For power-of-two `L` lines and `W` workers, the owner is
`(uint64_t(line_index) * W) >> log2(L)`. Keep arbitrary worker counts, not only
powers of two. No atomics or bitmap replicas are required. Concurrent external
queries or inserts during this operation are prohibited for the ordinary type.
After the method returns, all workers are joined and the updated filter can be
published or queried normally. Multiple read-only query calls can overlap if
output buffers are disjoint; `LookupParallel` only splits input/output ranges.

Preserve the serial threshold and worker cap initially. Line-skewed or cloned
keys can concentrate all updates on one worker; this must remain correct and
must not be advertised as scalable. Whole-filter zero initialization currently
first-touches pages on the constructing thread; NUMA placement and persistent
thread pools are separate future optimizations requiring their own measurements.

The current C++ partition arrays occupy
`8*n + sizeof(size_t)*(W*stride + W + 1)` bytes. This excludes the `std::thread`
vector, implementation thread state, allocator metadata, and OS stacks; document
that scope rather than calling it total process memory. Generalize the row
stride using `64/sizeof(size_t)` and use checked arithmetic for scratch sizes and
range splits if supporting 32-bit platforms. A failed allocation or thread
creation must leave existing inserted bits intact and may leave a partial new
batch; the operation throws and cannot claim the whole batch was inserted.

`parallel_detail::For` already joins successfully created threads during a
thread-creation failure. It does not catch exceptions escaping worker callbacks.
The current native hot loops do not throw; retain that internal requirement or
capture exceptions, join all workers, then rethrow before accepting a generic
throwing backend. Do not silently broaden the helper to arbitrary callbacks.

## Concurrent writers and readers

Keep concurrency as a distinct atomic type. An ordinary filter's bitmap cannot
be made concurrently writable merely by putting locks around partition setup.
For `AtomicFourSectorBF`, store `atomic<uint32_t>` words; for `AtomicSplit64BF`,
store `atomic<uint64_t>` words. Group words into aligned lines and verify/report
the actual allocation. Check whether the target's atomic word operations are
lock-free before making throughput claims; ISA-portable scalar support does not
imply identical atomic representations or costs on every platform.

Reuse the scalar layout enumerator, relaxed `fetch_or`, and relaxed atomic loads
for membership tests. Do not reinterpret atomic storage as ordinary words for
SIMD loads or gathers, even while only some threads are writing. Parallel atomic
insert/query batches simply divide key/output ranges and call these atomic
operations. They do not use the exclusive non-atomic partition kernel.

Keep the existing precise contract: a query overlapping an unfinished insertion
may miss that key. After externally synchronizing completed writers, for example
by joining them or publishing completion with release/acquire synchronization,
queries have no false negatives for those completed insertions. This is not a
transactional, multiword snapshot or a linearizable insert/query pair. Existing
bits are monotone; concurrent clear, resize, destruction, ordinary bitmap access,
or unsynchronized publication is unsupported. Benchmark atomic throughput
separately from immutable SIMD lookup.

## Frozen FourSector portability audit

The configured frozen header compiled and produced identical complete output
checksums under **Clang 23 and GCC 12.2** for all four modes K8/K9/K10/K12, plus
Split64 and native FastPattern, in these configurations:

```text
-std=c++17 -O2 -march=x86-64 -mno-avx -mno-avx2 -mno-avx512f
-std=c++17 -O2 -march=x86-64 -mavx2 -mno-avx512f
-std=c++17 -O2 -march=x86-64 -mavx512f -mavx2
```

The standalone audit used 65,539 inserted hashes; copied filters; hit/miss
queries; batches 1/3/4/7/8/15/16/31/4096; all inserted-key checks; and output guards.
These were correctness runs on CPU5, not timing measurements. The FourSector K8
checksum was `12380077936821394320` in all six builds. The AVX2-only candidate
builds currently run their scalar kernels: **this confirms a correct fallback,
not an existing AVX2 implementation**. Earlier native tests cover prepared
insertion collisions, exact tails, the >2MiB prefetch path, and ASan/UBSan.

Before public integration, fix these experimental packaging/validation gaps:

- Directly including `four_sector.h` without experiment macros currently fails:
  the bottom alias references undefined `MASK_MODE`. Remove the alias and all
  experiment configuration macros from the production header.
- The default dictionary size is 8, while enabling its SIMD implementation
  requires 16. A fixed public K8 layout eliminates this contradictory default.
- The constructor currently accepts zero bits/key, lacks checked `n*bpk`, and
  does not enforce the maximum word count. The four-sector independence argument
  requires at most 26 address bits; enforce the same 256 MiB limit as FastPattern.
- `base.h` supplies a POSIX allocator; GCC/Clang Linux compilation does not prove
  MSVC/Windows or non-x86 compilation. Isolate compiler prefetch helpers, and add
  platform-specific allocation only when those platforms are actually supported.
- The native header must include no snapshot files or generated experiment paths.
  Embed the frozen 16 masks as private constant data with generator provenance.

No frozen source, core header, or confirmation executable was changed by this
audit. Only this design document was added; temporary compile probes lived in
`/tmp`.

## Implementation and acceptance sequence

1. Add checked native Split64 and fixed-K8 FourSector headers with scalar and
   existing AVX-512 kernels. Keep FastPattern unchanged. Compile public headers
   without experiment macros or external dependencies; validate empty/invalid
   sizes and exact cross-language bitmap/query parity.
2. Implement the shared line-access/partition helpers and new parallel wrappers.
   Validate serial versus parallel outputs at 1/2/3/7/8 workers, incremental builds,
   clone-key hotspots, incomplete batches, concurrent read-only calls, and exact
   scratch accounting. Keep partition/thread overhead inside measured build time.
3. Add separate atomic variants from the shared scalar probe descriptions.
   Validate completed-key visibility after writer synchronization, duplicate
   inserts, readers overlapping writers, and rejection of unsupported mutation
   patterns in the documented API. Run a race detector where the environment
   supports it; ordinary correctness tests alone do not establish race freedom.
4. Add the native AVX2 kernels, prioritizing Split64's simpler full-line path.
   Require exact output parity with scalar and AVX-512 before performance tests.
5. Mirror the public types and concurrency semantics in Rust. Its `&mut self`
   build API naturally expresses exclusive construction; shared mutation belongs
   to separate atomic types. Keep current runtime ISA detection. Existing
   cross-language experiment parity is a starting point, not a replacement for
   the new public/parallel tests.
6. Run the same-process external comparison and multithread matrix with identical
   memory ceilings, hash/API modes, FPR confidence gates, construction batches,
   thread counts, and CPU/NUMA placement. Report build, immutable query, and atomic
   workloads separately. Recommend a layout by measured use case; do not replace
   FastPattern's default solely because a candidate wins one FPR target.
