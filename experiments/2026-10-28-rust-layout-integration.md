# Rust candidate integration design, 2026-10-28

The two benchmark prototypes can become native Rust types without copying the
existing histogram/scatter scheduler. Keep their bitmap and SIMD kernels
concrete, extract the shared cache-line partitioner and read-only batch scheduler,
and retain the existing `BloomFilter<const PATTERN: bool>` API. This is a design
note; no production API or multithreaded candidate implementation was added.

Reviewed: `rust/src/lib.rs`, `rust/src/parallel.rs`, the native parallel benchmark,
both modules under `benchmarks/rust-external/src/`, and the comparison/ranking
scripts. The current prototypes are exclusive-write/read-only batch filters;
they do not yet expose native multithreaded methods.

## Current contracts worth preserving

`BloomFilter<P>` owns aligned 64-byte `Line([u32;16])` storage. Construction
validates size, allocates the next strictly larger power of two with a 128-byte
minimum, and caps the bitmap at 256 MiB. Its safe API uses `&mut self` for inserts
and `&self` for queries. SIMD dispatch is detected at construction;
`disable-avx512` keeps AVX2/scalar available. The public `SizeError`, hash function,
sizing behavior, output-length check and existing aliases should remain stable.

`parallel.rs` already supplies three useful contracts:

- Exclusive bulk construction partitions complete cache lines, then gives each
  worker a disjoint mutable slice. Histogram/scatter and thread launch costs are
  included, and `build_scratch_bytes()` reports explicit peak scratch allocation.
- Immutable queries split input/output slices among scoped threads. No atomics
  are needed because queries do not mutate the bitmap.
- `AtomicFastPatternBloomFilter` permits overlapping writers/readers using atomic
  word operations. An unfinished insert can be missed; joined/synchronized
  writers give the usual no-false-negative guarantee. Relaxed operations do not
  publish unrelated application data.

The worker policy falls back to one worker below 16K items, limits the count by
input size and line count, supports request 0 as available parallelism, and caps
at 1024. Preserve this policy initially so layout comparisons do not also change
thread scheduling.

## Public types and private shared pieces

Suggested concrete additions are `SplitBlock64BloomFilter` and
`FourSectorBloomFilter` (the latter explicitly documented as the fixed K8,
16-pattern layout). Expose the same methods as the current plain type:

```rust
new(keys: usize, bits_per_key: u32) -> Result<Self, SizeError>
size_in_bytes(&self) -> usize
backend(&self) -> &'static str
insert_hash(&mut self, hash: u64)
insert_hashes(&mut self, hashes: &[u64])
contains_hash(&self, hash: u64) -> bool
lookup_hashes(&self, hashes: &[u64], out: &mut [u32])
build_workers(&self, keys: usize, requested: usize) -> usize
build_scratch_bytes(&self, keys: usize, requested: usize) -> usize
insert_hashes_parallel(&mut self, hashes: &[u64], requested: usize)
lookup_hashes_parallel(&self, hashes: &[u64], out: &mut [u32], requested: usize)
```

Share a private checked `word_count`/line-count helper. FourSector can reuse the
existing 32-bit `Line`; Split64 should own a distinct aligned `[u64;8]` line type.
Keeping these two tiny structs avoids reinterpreting ordinary and atomic storage
or forcing every kernel through a generalized word abstraction. Their 64-byte
size/alignment can be asserted in tests. Concrete generic monomorphization or
small closures can share scheduling without trait-object calls per key.

For parallel build, extract the histogram/scatter mechanism into a private
generic function with three explicit inputs: the mutable line slice, a pure
global-line-index closure, and a per-owned-slice insertion closure. The insertion
closure receives the exclusive owned slice, its global starting line, and the
partitioned hash slice. Capture immutable layout metadata separately, before
borrowing storage. Reuse `split_at_mut` for both scatter destinations and bitmap
ownership, preserving the current `MaybeUninit` initialization proof. Share the
scratch-size formula with the allocation code rather than duplicating it in each
public type.

The existing plain type can initially call this helper with its current kernel;
then add candidates. The unsafe SIMD implementation stays inside each concrete
layout module. A separate private query scheduler can accept a `Sync` lookup
closure and disjoint output chunks, eliminating three copies of thread plumbing.

## Correct cache-line ownership

The shard formula is `floor(global_line_index * workers / line_count)`, with
the existing ceil-based contiguous line boundaries. The input line count is a
power of two, so the current multiply/right-shift computation remains valid.
Crucially, each layout must provide its own global line index:

| Layout | Global line index | Writes within its line |
| --- | --- | --- |
| FastPattern | `((hash >> 32) & word_mask) >> 4` | Two 32-bit words |
| FourSector K8 | `((hash >> 32) & word_mask) >> 4` | Four separate 32-bit words |
| Split64 | `(hash >> 32) & line_mask` | Eight 64-bit words |

Reusing FastPattern's shard expression for Split64 would assign hashes to the
wrong owned slices. FourSector's XOR quarter/offset changes affect only the low
four word-index bits, so all writes remain in its selected line. Its high-bit
offsets are independent of the address at the supported maximum size.

For an owned FourSector slice, subtract `begin_line * 16` from each globally
computed word index before accessing its local base pointer. For Split64,
subtract `begin_line` from the global line index. Never create a pointer before
the owned allocation and rely on a later index to bring it back in bounds.
Prefetch addresses need the same rebasing and ownership proof. Preserve sequential
ORs for prepared insertion: a vector scatter with colliding words could lose bits.

Use the owned slice's byte size for the existing FourSector prefetch threshold,
matching the native partitioned FastPattern behavior. Split64 currently always
uses distance 32; retain it until separate multithreaded measurements justify a
different policy. SIMD masks and address mapping must stay identical between
serial and partitioned paths, yielding identical bitmap/query results.

## Concurrent writer support

Exclusive partitioned construction and immutable parallel reads meet the initial
multithreaded API with no new atomic machinery. For overlapping writers, add
separate concrete `AtomicFourSectorBloomFilter` and `AtomicSplitBlock64BloomFilter`
types following the existing atomic contract. Use four `AtomicU32::fetch_or`
operations for FourSector or eight `AtomicU64::fetch_or` operations for Split64,
optionally retaining the current relaxed load-before-OR shortcut.

Do not SIMD-load an atomically modified line through a plain-word pointer:
queries must use atomic loads while concurrent writers are possible. Gate the
64-bit atomic type with `target_has_atomic = "64"`; the ordinary Split64 filter
can remain portable. An atomic type needs its own benchmark because atomic
construction/query costs differ from exclusive ownership. A frozen plain-filter
conversion is optional future work, not required for initial integration.

## Promotion gates and focused validation

First add the shared schedulers with existing FastPattern behavior unchanged;
test its present serial/parallel/atomic parity. Then move each proven candidate
into its own native module and make the external adapter call that implementation
so there is one kernel source. Both prototypes must gain the native
`disable-avx512` dispatch rule, public `SizeError` signatures and single-key
methods. Their current fallback is scalar, whereas FastPattern already has an
AVX2 path; report this backend distinction explicitly. AVX2 candidate kernels
can be added as an independently measured improvement.

Preserve the existing scalar-versus-SIMD, tail, collision and cross-language
tests. Add serial-versus-partitioned bitmap/query parity for worker counts
1/2/3/7/8, zero/tiny inputs, concentrated single-line hashes, duplicate keys,
non-divisible shard boundaries, and both sides of the prefetch threshold.
Run the same tests with AVX-512 disabled. Check `Send + Sync` for immutable
ordinary filters without hand-written unsafe implementations. If atomic types
are added, test overlapping readers/writers and verify all inserted keys after
joining writers, as the existing atomic test does.

For scaling evidence, extend the parallel benchmark's filter selection and CSV
identity before adding rows. `run_parallel.py` currently requires exactly three
FastPattern modes with one checksum; it must instead compare modes within each
layout, because different layouts legitimately have different false positives.
Retain actual allocation, effective workers and scratch columns. Use one-socket
physical-core sets, the same workload, and matching serial baselines. Do not infer
multiworker speedups from the single-thread prototype results.

## Standalone Rust report capability

The existing external Rust executable already works with `run_comparison.py`
and `rank_external.py`; no new reporting implementation is needed. Argument 9
sets insertion batch size, argument 10 enables separate negative calibration.
The runner forwards both and documents external Rust support. The updated
`benchmarks/rust-external/README.md` contains a complete Rust-only run and ranking
recipe. This review performed no timing runs.

The ranker accepts the shared fields, uses actual `filter_bytes`, a chosen
memory ceiling with `--allocation-slack 0`, pooled independent calibration, and
a one-sided 95% Wilson upper bound. It ranks prehashed or hash-plus-operation
metrics separately and keeps workload/batch dimensions separate. Missing Rust
scratch columns do not block this serial ranking, but must not be interpreted
as zero scratch in a construction-memory report. The Rust external harness
currently allocates hash scratch of `max(query_batch, insert_batch) * 8` bytes;
record it explicitly before a build-peak-memory comparison.

Retain raw data, exact selection/seeds/arguments, executable hash, compiler and
target flags, and dependency lockfile. The standard runner's tracked diff does
not capture untracked prototype sources, so commit or snapshot them before a
published run. Keep different binaries as different report series; choose
candidate parameters on training seeds and confirm them on fresh held-out seeds.
The 35-case FourSector C++/Rust parity artifact and the Split64 parity checks
establish answer compatibility, not cross-language speed equivalence.
