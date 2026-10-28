# Exact backing-byte budgets and query-only comparison

Status: design reviewed by root; isolated implementation and correctness preflight
authorized under `2026-10-29-exact-budget/`. No performance screen has run.
Existing frozen experiments remain unchanged.

The current 16/32-bit results are **measured-grid results**, not a frontier over
all permitted capacities. Most external public APIs support intermediate sizes;
our adapters impose the native strict-next-power-of-two budget. At 32M keys,
12/14/16/20/24/28/32 bits/key mean 48/56/64/80/96/112/128 MiB. Intermediate sizes
can alter cache fit without changing the upstream query algorithm.

## Verified constructor and allocation contracts

Let `B = floor(real_key_count * budget_bpk / 8)` be the checked byte ceiling.
Charge implementation-requested backing storage, including explicit tail or
alignment over-allocation. Do not mix this with allocator-internal metadata/RSS.
Record usable bitmap bytes separately where they differ. Minimum sizes, integer
limits and zero/overflow inputs must be checked before construction.

| Family | Unchanged public construction under ceiling B | Actual storage / constraint | Current extra restriction |
|---|---|---|---|
| Native FastPattern, FourSector, Split64, ByteSplit | Keep real `n`; choose a fitting legacy `bpk` so public constructor returns the largest power-of-two allocation <=B | Minimum128 B; power-of-two addressing is inherent (`& mask`). Current shared cap is256 MiB. FastPattern pattern density depends on real `n` and actual words | Strict-next-power-of-two constructor. Do not replace `n` with a synthetic capacity |
| FastFilter `SimdBlockFilter` | `log_heap_space = floor(log2(B))` | Power-of-two bytes, minimum64 B; inherent `directory_mask_` addressing | Adapter currently passes log of a **strictly rounded-up** common budget |
| FastFilter Fixed16 | `c=floor(B/16)`, public integer size argument `10*c` | Exactly16*c B, arbitrary positive bucket count; multiply-high range reduction | `PayloadBytes(n,bpk)` first rounds to the native power-of-two budget |
| FastFilter Fixed32 / Bulk | `c=floor(B/32)`, argument `24*c` in the pinned AVX2 build | Exactly32*c B, arbitrary positive bucket count. Direct and AddAll are valid for non-power-of-two counts | Same adapter restriction |
| FastFilter Fixed64 | `c=floor(B/64)`, argument `50*c` | Exactly64*c B, arbitrary positive bucket count | Same adapter restriction |
| FastFilter Classical K / branchless / Bulk | With existing `bits_per_item=8`, pass `8*floor(B/8)` as public constructor capacity | `ceil(argument/8)*8` B, so this choice is exactly8*floor(B/8). Arbitrary word count via multiply-high range reduction. The fixed K public template argument is unchanged | Same adapter restriction |
| PageBloom N, Default/Compact | Choose a legal page level L by the existing named policy, then `page_count=floor(B/2^L)` | Exactly `page_count*2^L` B; count need not be power-of-two. Require `1 <= count < 2^18`, `8-8/N <= L <=13` | Adapter currently receives a power-of-two budget and insists on exact equality. General fitting should allow unused remainder |
| Boost1.92 all existing aliases | Public `filter(m, hash, allocator)`, with the existing exact inverse below using B directly | Arbitrary range; count **all** allocator-requested bytes, not just `capacity()/8` | `requested_bits(n,bpk)` first rounds the ceiling to native power-of-two |
| RocksDB FastLocalBloom core | Own `L=64*floor(B/64)` bytes, pass L to unchanged AddHash/PrepareHash/HashMayMatch | Arbitrary positive cache-line count; `FastRange32(h1,L>>6)` addressing. Report vector capacity and require it <=B | Adapter `PayloadBytes` forces a power-of-two. Auto probe selection must use actual L and real n |

For the tested power-of-two key counts, all seven proposed integer-bpk budgets
are multiples of8192 bytes. Fixed, classical, Rocks and legal Page geometries can
therefore fit these points exactly. Boost may leave a stride remainder because
its explicit overhead counts against B. Native/SimdBlock must retain their
coarser feasible capacities; changing their address reduction would be a new
algorithm experiment, not this fairness expansion.

FastFilter public arguments named `bits`/`n` above are sizing inputs, not insertion
limits. Preserve the existing hash, mask, Find/Contain, scalar/SingleV1 and bulk
APIs; do not rewrite upstream kernels to achieve a desired capacity. Bound the
scaled Fixed16/32/64 integer arguments before narrowing to `int`.

Boost's pinned inverse is already present in the adapter. With stride S, used
bytes U, block object size T, and alignment A (`max(64,alignof(Block))` when the
stride is aligned, otherwise1), set:

```
overhead = (A - 1) + T - S
range = floor((B - overhead) / S)
m = 8 * (range*S + U - S)
allocated = (A - 1) + range*S + T - S
usable = range*S + U - S
```

Require at least one range entry. Retain the counting allocator to verify the
inverse against the unchanged public constructor. There is no power-of-two range
requirement in Boost's `fastrange_and_mcg` strategy.

Page's Default/Compact policies remain distinct. Compact page level can increase
when the maximum page count is reached; record both level and count, rather than
claiming only memory size changed. Page remains a raw-byte API: no additional
common hash and no prehashed-query timing.

## Rust cross-check

The existing pins also permit intermediate capacities; the power-of-two equality
policy is ours. The Rust baseline owner independently verified:

- Fastbloom0.17 `with_num_bits(...).expected_items(real_n)` supports arbitrary
  whole-u64 storage. Fit8-byte words and report actual boxed-slice bytes; retain
  its actual probe-count policy and public prehashed APIs.
- Bloomsday's pinned constructor uses `ceil(-ln(fpr)/ln(2)^2)` integer bits/key,
  then32-byte block rounding. The existing midpoint-FPR inversion can select
  each proposed integer-bpk point at power-of-two n. The sizing FPR is not a
  claimed measured FPR. Record the resulting block count and real allocation.
- SBBF safe0.3.2/kernel0.2.8 supports arbitrary32-byte logical block counts.
  `new(8, logical_bytes)` reaches that logical size, but backing allocation rounds
  to64 bytes. Charge that padding; the direct public FilterFn control also keeps
  logical bucket count and backing allocation separate. A ceiling-fitting choice
  can use a64-byte-aligned logical length, or explicitly account for an odd
  logical block's extra32 bytes.

No native Rust or upstream kernel change is needed for the proposed size grid.
The pinned-source detail is also recorded in
[the Rust SBBF audit](2026-10-29-rust-sbbf-survey.md).

## Minimal isolated implementation

1. Snapshot the validated generic C++ harness and the existing native/external
   adapter sources into a new experiment. Preserve hash/query/output/calibration
   contracts and all upstream source pins. Change only local construction/fitting
   helpers plus the isolated harness's factory/metadata. Verify Insert/Lookup
   bodies against their parent copies. Retain direct, bulk, SingleV1 and fixed-K
   controls as distinct APIs even when their bitmaps are identical.
2. Introduce an explicit checked byte budget and a **pure geometry planner**.
   External constructors use the formulas above. Native factory chooses a
   fitting legacy bpk while passing real n; for these n values, an actual native
   bpk of8/16/32 can be obtained with legacy4/8/16. Never use a synthetic n for
   FastPattern: it would change mask density. Charge actual size after allocation
   and reject any over-budget result. Public objects with deleted moves must
   still be returned as C++17 prvalues; no trial allocations or moved counters.
3. Record `budget_mode`, `budget_bytes`, requested budget bpk, constructor sizing
   arguments, actual backing bytes/bpk, usable bytes, bucket/page/range geometry,
   effective probe count, hash/input mode and ISA. The legacy `requested_bpk`
   column alone cannot identify this new contract. Auto Rocks probes follow the
   actual allocation (12/14=>8,16=>9,20=>11,24/28=>12,32=>14 in this grid).
4. Deduplicate **before timing** by implementation/API identity plus effective
   geometry, probes, hash contract and real n. Native/SimdBlock allocations repeat
   across nominal ceilings. Measure each once and map it to every fitting cap;
   do not select the fastest of several repetitions disguised as new capacities.
   Keep distinct API controls, but never pool their identical calibration samples.
5. Generate an explicit planned row manifest. Different budget points may have
   different selected-filter lists after deduplication. Invoke the unchanged
   shared runner with each exact list, or use a separate planner/driver with the
   same strict returned-set/workload validation. No silent skipping of unknown
   filters or unsupported geometry. Keep unsupported cases in the plan with a
   reason, not invented NaN performance rows.

Native allocations below16 bpk are feasible even though they are likely to fail
the requested FPR ceilings. Either include the8-bpk native/SimdBlock point once
under12/14 caps, or explicitly label native scope as measured16/32 only. Do not
round a16-bpk native allocation upward past a12/14 cap and call it eligible.

## Query-only mode without repeated-construction tax

Add this only in the isolated harness. Preserve full-construction mode as the
default, including its existing repeated build measurements. Expose separate
`query_repeats` and `build_repeats`; explicit query-only sets `build_repeats=0`.

The query-only path constructs **one complete filter per planned configuration**,
prepares the shared hashes (raw Page inputs remain raw), inserts the full input
with the declared scalar/bulk batch, and validates every inserted key. Then run
the existing warmup, pure/common-hash query kernels, full output validation and
independent negative calibration. Calibration remains outside timers. Timed
query repetitions must not reconstruct or clear the filter.

Set all disabled construction summaries/ranges/trials to NaN, including
`insert_ns`, `allocate_insert_ns`, `hash_insert_ns` and
`allocate_hash_insert_ns`; emit `build_repeats=0` explicitly. Do not print zero
construction cost or reuse a singleton setup sample as a repeated-build median.
A first version can omit optional setup-cost timing entirely. If later added,
name it `setup_*_once`, define its scope and exclude it from rankings.

Still report actual filter build scratch: the single complete build uses it.
Query-only needs query-batch hash scratch, not the n-sized scratch needed for
repeated hash+insert timing. Report actual harness scratch bytes and keep its
policy uniform across candidates; do not attribute an old/full versus new/query-
only timing difference to a filter optimization. Page pure metrics remain NaN.
Existing full mode can keep its old scratch policy.

## Validation and first screen

Before measurement, check odd/non-power-of-two word/bucket/page/range sizes,
zero/overflow/minimum inputs, fitting boundaries, explicit padding, no false
negatives, complete outputs/tails/guards, and direct/bulk bitmap parity where
supported. Verify dense0/1 answers and late-output corruption rejection. Native
fitting must preserve real-n mask choice. Check dedup manifests and wrong/missing
filter rejection. Query-only tests must prove one completed build, zero timed
build trials, NaN build summaries, unchanged output/calibration versus full mode,
and correct actual scratch accounting.

Freeze sources, geometry plan and binary before the proposed screen:

- n=2^16/2^25; actual byte ceilings from12/14/16/20/24/28/32 bits/key;
- batch4096, same explicit API rows and full-input construction;
- seed42 training, q2^22, six balanced query repeats, build_repeats0, hit50, cal2^24;
- rank pure and common-hash query metrics separately, using actual charged bytes;
- for cap16 admit every measured allocation <=16; for cap32 admit all seven
  points, and all smaller measured native/SimdBlock allocations;
- retain1%/.1%/.01% FPR ceilings. Use the upper endpoint of two-sided95 Wilson
  (`z=1.959963984540054`) to match the current main comparison protocol.

All grid points and losses remain in the archive. Selecting a configuration on
this training grid requires fresh-seed confirmation before a performance claim.
Before implementation, root prespecified Classical K10/14/17/19 in all three
existing APIs (direct, Branchless, Bulk) and Rocks fixed K11/K12 in direct/Batch32
forms. These16 additions bring the registry to72 configurations: four native and
68 external. Auto policies remain visible. This fixed grid is broader but still
not an exhaustive optimization over every possible probe count.

## Pinned source locations checked

- Native: `include/fast_pattern_BF.h`, `layout_detail.h`, and the three other
  layout headers; constructors and address masks are unchanged.
- FastFilter commit `7c5bf187d5096ccbcec6a16e02975d0af3328b01`:
  `src/bloom/simd-block.h`, `simd-block-fixed-fpp.h`, `bloom.h`; current adapter
  sizing lives in `benchmarks/cpp-external/adapters.hpp`.
- PageBloom commit `bcf10622ab740b4dfd99631b27484ecedb96646a`:
  `include/pbf.h` and `src/pbf.cc`, page-count divisor and exact byte allocation.
- Boost1.92: `boost/bloom/filter.hpp`, `detail/core.hpp` and the existing counted
  adapter's inverse in `benchmarks/boost-external/adapters.hpp`.
- RocksDB v11.12 commit `ef3dd12e9a6314aaf08fba6d5d445494eac9b253`:
  `benchmarks/rocksdb-external/vendor/util/bloom_impl.h` and its adapter. This is
  the same unmodified core API baseline, not an SST/DB factory measurement.
