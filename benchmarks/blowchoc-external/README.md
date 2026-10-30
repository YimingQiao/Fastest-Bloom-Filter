# BlowChoc whole-array bridge (validation stage)

This isolates the unmodified public API of
[BlowChoc 1.1.0, commit 2c6da955](https://gitlab.com/rahmannlab/blowchoc-filters/-/tree/2c6da95532eda8b1dd0444c24516193a67edc508).
`upstream.json` records every vendored file's SHA256 and size. The upstream code
is MIT licensed; see `vendor/LICENSE`. Native controls are frozen FastPattern,
FourSector, Split64 and ByteSplit headers from commit `b437791b6edf23fe8725f87e62d21d638216861a`;
their manifest is `native-snapshot.json`. This bridge does not establish a speed
win or loss, and the native controls are this explicit snapshot, not an implicit
claim about the newest working tree.

## Contract

Python invokes one compiled whole-array operation for each build or query phase.
C++ performs one virtual dispatch per operation; its typed loop can inline each
filter's public `Insert(1)` / `Lookup(1)`. Numba compiles its whole loop around
the original `insert(array, key, positions)` / `lookup(array, key, positions)`.
There is no per-key FFI crossing. Both write every answer to the same dense u32
output array and retain the same batch boundaries and insertion order.

Three modes stay separate in the results:

* `prehashed`: uniformly mixed u64 input, with the common hash prepared outside
  the operation.
* `common-fused`: compute the repository's common u64 hash immediately before
  each scalar insertion/query.
* `common-staged`: hash each batch into the same-sized reusable u64 scratch,
  then perform scalar insertions/queries for that batch. Scratch writes and reads
  are included. This has the common harness's staging boundaries, but its native
  scalar call shape is a different track from the original noinline bulk API.

Upstream BlowChoc's own hash functions, prefetches, cost-selected insertion,
duplicate random bit positions, and early exits are unchanged and remain inside
the operation. The initial fixed configurations use one/two choices, eight
probes, random/distinct bits, one subfilter, and exponential cost with golden-ratio
beta and mu=1. `--probes` supports explicit subsequent controls; parameters and
hashes must be fixed before looking at quality or speed outcomes.

For non-power-of-two moduli, the pinned Numba 0.61.0 lowers upstream's mixed
`uint64 % int64` expression to signed i64 remainder with a nonnegative
adjustment. This matters for full-u64 keys: `linear2808315403`, key 1, modulus 25
returns 22, whereas unsigned integer modulo would return 13. The independent
oracle explicitly matches the observed signed interpretation; the upstream
baseline remains unchanged. Power-of-two bit selection uses unsigned shifts.

The workload exactly reproduces shared-harness SplitMix64/Fisher-Yates inputs.
The construction RNG seed defaults to 113, independent of workload/calibration
seed. Its state is restored after generating explicit upstream hash strings.
All generated strings are saved in the JSON record. The negative calibration
stream is disjoint from both inserted and measured query raw keys.

## Allocation and compilation

The upstream aligned allocator adds 56 **u64 elements**, or 448 bytes. We preserve
this behavior, follow the returned NumPy view to the owning backing array, and
charge its entire `nbytes` against the same native byte cap. Blocks are selected
to fit after deducting this overhead and must be odd. Logical bitmap bytes are
reported separately. A reusable `uint16[probes]` positions buffer is reported as
filter scratch. Common-hash scratch is a separate shared harness allocation.
Allocator/runtime object headers and JIT code memory are not counted as bitmap
payload, just as native allocator bookkeeping and compiled code are not.

Upstream dynamically generated functions reuse module globals such as
`block_hf_0`. Every operation and oracle-accessor signature is therefore compiled
immediately after its factory, before another factory can replace those names.
Only aligned, writable, contiguous arrays of the warmed types are accepted.
Cold factory/compilation duration is saved separately; it also includes warm-up
allocation and release, and is not a steady-state build number.

The warm-up descriptor is detached from its bitmap. Closure inspection and weak
references verify release. Prepared operations share a lifetime token: closing
either language's filter invalidates operations and drops captured arguments.
The driver weakref-checks actual BlowChoc build allocations before allocating
the next trial. Pure, fused and staged fresh builds have disjoint lifetimes;
the canonical query filter is allocated only after all build trials.

## Reproduction

Use Python 3.12 and the versions in `requirements.txt`, in an isolated environment.
The commands below use this machine's socket1 lock; no machine settings change.

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 uv venv --python 3.12 benchmarks/blowchoc-external/.venv
flock /tmp/fastest-bf-socket1.lock taskset -c 3 uv pip install --python benchmarks/blowchoc-external/.venv/bin/python -r benchmarks/blowchoc-external/requirements.txt
flock /tmp/fastest-bf-socket1.lock taskset -c 3 cmake -S benchmarks/blowchoc-external -B build/blowchoc-bridge -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release
flock /tmp/fastest-bf-socket1.lock taskset -c 3 cmake --build build/blowchoc-bridge -j1
flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python benchmarks/blowchoc-external/check_bridge.py --native build/blowchoc-bridge/libblowchoc_native.so --report build/blowchoc-bridge/check.json
flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python benchmarks/blowchoc-external/run.py --native build/blowchoc-bridge/libblowchoc_native.so --output build/blowchoc-bridge/accuracy.json
```

`run.py` defaults to accuracy-only. Throughput requires explicit `--measure` and
a repetition count divisible by six, balancing all permutations of the three
phases. Each timed call includes its one Python/JIT-or-FFI dispatch and identical
lifetime guard; pointer conversion and output checking occur outside timing.
Allocation and insertion are reported separately, with every raw trial. No
allocation-plus-build claim is synthesized by adding different medians.
Every timed query's full outputs, guards and checksum are checked; every build
is checked against every inserted key and the complete reference query output.
No throughput table should be published until correctness, calibration and an
explicit frozen comparison protocol have been reviewed.
