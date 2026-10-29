# Minimal original-VLDB public-API integration

Source-only design; no adapter build, accuracy run or timing. This is a separate raw-u32 benchmark contract. Existing 64-bit-stream results remain separate.

Implementation source inspection found that the pinned reproduction calls the public `bbf_32`/`bbf_64` PImpl facade. The scaffold therefore retains that as the primary artifact API, with the direct `blocked_bloomfilter<Word>` wrapper and named static aliases as additional separate controls. The source-only scaffold and concrete build constraints are now recorded in [its README](../benchmarks/vldb-original-external/README.md). None has been compiled or timed.

**Implementation location:** `benchmarks/vldb-original-external/`, with `fetch.py`, `raw32_workload.hpp`, `adapters.hpp`, `compare_raw32.cpp`, `check.cpp`, a source lock and a small CMake target. Fetch into an isolated ignored dependency directory, never from a historical working tree. Pin reproduction revision `0d2fe8e72496909cdac73c914e8f1a3dd956ac7f` and its DTL revision `c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`, retain original licenses, and verify the gitlink plus archive/header hashes before compiling. The existing local DTL repository does not contain that exact commit object; copying its current headers would be wrong. The artifact declares DTL as a submodule. [Original submodule declaration](https://github.com/peterboncz/bloomfilter-repro/blob/0d2fe8e72496909cdac73c914e8f1a3dd956ac7f/.gitmodules).

## Workload and hash contract

Create distinct raw keys directly in the 32-bit domain. Do not truncate the current 64-bit stream. Reserve checked counter ranges `[0,n)` for insertion, `[n,n+a)` for the `a` mixed-query negatives, and `[n+a,n+a+c)` for independent calibration. Require `n+a+c <= 2^32`, using checked 64-bit arithmetic. Apply the same seeded bijection to every counter:

```cpp
uint32_t permute32(uint32_t x, uint32_t seed) {
  x += seed;
  x ^= x >> 16; x *= UINT32_C(0x7feb352d);
  x ^= x >> 15; x *= UINT32_C(0x846ca68b);
  x ^= x >> 16;
  return x;
}
```

The odd multipliers and xor-shifts are invertible modulo 2^32. This guarantees unique inserted keys and disjoint negatives without a giant uniqueness set. Present queries select existing insertion indices; repeats among present queries are allowed. Shuffle insertion/query arrays with the established independent SplitMix stream. Freeze the generator before calibration; verify inverse round trips, range boundaries, exact hit counts and the disjoint counter-domain proof.

All candidates receive these same raw u32 values. Native APIs widen losslessly to u64 and apply the existing common 64-bit hash inside raw-query/build timers. The artifact receives raw u32 keys and performs its own hashing inside its public API. Label `raw_u32/common_hash64` and `raw_u32/upstream_hash_family` explicitly. These are application-level raw-key comparisons; do not publish an artifact “pure prehash” number by omitting its internal hash work. [Upstream insertion and query logic](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter_logic.hpp).

## Adapter shape

The dynamic adapter owns a stable `FixedTune` member, then the upstream `dtl::blocked_bloomfilter<Word>`, then aligned bitmap storage. Declaration/destruction order keeps the tune reference alive. `FixedTune` overrides the public `get_unroll_factor` and returns the registered constant; it performs no workload-dependent tuning. The default upstream factor is one and zero selects scalar batch execution. [Tuning interface](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter_tune.hpp).

Use public `insert`, `batch_insert`, `contains`, and `batch_contains` without extracting the hidden instance pointer or replacing dynamic dispatch. The public API takes u32 keys even when `Word` is u64. A separately named static control instantiates the public `bbf<W,S,K,Address,false>` alias and calls its exposed logic methods. It must retain the same hash family, geometry, address policy and vector length. Dynamic and static results stay separate. [Public wrapper and alias](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter.hpp).

Start correctness with three matched dynamic/static configurations: `(Word32,W8,S8,K8,U1)`, `(Word64,W8,S8,K8,U1)`, and `(Word64,W1,S1,K8,U0)`, plus the four unchanged native layouts. After that works, freeze an initial accuracy registry containing `(Word64,W1,S1,K4/K8)`, `(Word32,W8,S8,K8)`, and `(Word64,W8,S8,K8/K16)`, each with U=0/1/4 and separate dynamic/static labels. This is a finite starting registry, not a claim to cover the artifact's full parameter space. Keep `FAST_BUILD` disabled because it excludes needed configurations.

## Query outputs and memory

Measure two raw-key contracts independently: a whole-array loop through each actual public singleton method, and native batch query producing dense u32 answers. For upstream batch queries, call `batch_contains(..., match_offset=0)`, zero the corresponding dense output, then mark the returned positions. Both zeroing and positions-to-dense conversion stay inside the timer. Preallocate position scratch and report its full backing allocation, including any conservatively required SIMD padding; test the minimum safe length before reducing it. Verify returned positions are in range and unique, and compare the complete dense vector with singleton answers. Preserve the original batch prefix/tail behavior; its implementation processes an alignment prefix even when the input is aligned. [Batch dispatcher](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter_batch_dispatch.hpp).

A compact-output track is deferred. If later added, every native implementation must also produce positions/count within that timer; its results cannot replace dense-output results. Native hash workspace and upstream position workspace have distinct reported scratch fields. Inputs and required dense outputs are common harness storage.

Size from the public constructor's actual reported length, then allocate that many words with a counted aligned allocator. Record requested bits, logical bitmap bytes, actual bitmap backing bytes, persistent control heap, inline object bytes, and peak construction scratch separately. Count the dynamic logic and retained `std::function` allocations during isolated construction; do not hide them in payload bytes or scratch. For the new track, report both bitmap-backed and total retained heap caps explicitly rather than silently calling them equal memory. Native n remains the real insertion count. Geometry selection happens in a recorded plan before timing; each measured build constructs exactly one real API object/bitmap and includes zeroing and own/common hashing as appropriate.

Public size policy chooses power-of-two addressing for power-of-two requested lengths and magic addressing otherwise; the latter rounds block counts to supported cheap divisors. Plan actual allocations at intermediate budgets as well as 16/32 bpk, and verify the final constructor result against the plan. Do not assume requested bits equal allocated bytes or substitute multiply-high addressing for this original API. [Addressing implementation](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/block_addressing_logic.hpp).

## Gate before timing

Test public dynamic/static bitmap and full-output equality, all inserted keys, duplicates/collisions, zero length, all tails around vector lengths, shifted input pointers, guarded compact scratch and dense outputs, allocation lifetime, and budget boundaries. Use normal/portable/SIMD and ASan/UBSan builds where supported. Freeze the original source, compatibility includes, compiler flags, registry, allocation plan and executable before independent FPR calibration. Only after correctness and quality are known should a separate reviewed raw-u32 timing protocol be prepared. No production change or existing 64-bit result is implied by this design.
