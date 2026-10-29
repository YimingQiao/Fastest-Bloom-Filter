# Original VLDB public API and modern raw-u32 comparison: stage 2 preparation

This is **source-only preparation**, not a compiled or timed result. The passed
429-file parent at `e3e4b3f760aeb8d3b3370a82610f2653bac089fe` is unchanged.
The immediate next operation is a bounded larger-capacity/MAGIC correctness
preflight. Timing workers follow the fixed contract below only after that
preflight and source/binary freeze have been reviewed.

## Two process contexts, one workload and timing contract

The original archive was compiled with GCC12.2, Boost1.83 and non-PIC objects.
An ordinary C-linkage wrapper in a process also containing Boost1.92 does not
remove C++ ODR hazards. Putting those objects in a shared library would also
introduce an unverified relocation requirement. The first comparison therefore
uses two **separate serial executables**:

* `legacy`: GCC12.2, the unchanged verified original static archive, only the
  complete Boost1.83 root; original PImpl, public dynamic wrapper and public
  static alias remain separate named rows; all four production native controls.
* `modern`: GCC12.2 with the same optimization/ISA flags, only the complete
  Boost1.92 root; the fixed modern shortlist and the same four native controls.

There is no IPC, subprocess creation or dynamic loading inside query timers.
The parent launches the two panels in both orders across two fixed rounds.
Each original configuration runs in a fresh process so a previously inserted
tuner entry cannot retain the wrong U. Shared setup stays outside query timers;
its previously measured heap cost remains separately reported. No calibration
file is created, removed or overridden. Actual `name()` must identify the
requested U, address mode, K/W/S and size in every process.

`query_loop.hpp` is the same byte-identical source in both workers. Its outer
loops are noinline. The single-key loop exposes each public one-key API to the
compiler; the batch loop retains a common noinline `DenseCall` boundary. This
separates inlined independent-query throughput from count-one batch throughput.
Both workers receive the exact `Raw32Workload` implementation from the passed
parent; it is not generated independently by different libraries.

Native results are retained separately for both executables. Cross-executable
ratios are paired API/context observations, not a same-binary algorithm-only
claim. **Never subtract or divide out a native context-shift correction.**
Report every individual timing, both native contexts, both launch orders,
min/median/max/trials, losses and quality failures.

## Fixed configurations and accounting

`protocol.json` fixes seven original configurations (K8; W8/S8 32-bit or64-bit
words at U1/2/4, plus W1/S1 64-bit U0). Each has three separately labelled public
surfaces: original artifact PImpl; public std::function wrapper; named static
alias. Static is an additional public control, never a replacement for PImpl.
This yields21 original rows. Four native layouts occur in each worker.

The19 modern configurations are the union of all external leaders from the
frozen exact-capacity selection and visible-single screen (12 names), plus the
RocksK8 batch32 counterpart and all six pinned PageBloom K4/6/8 default/compact
APIs. Thus the legacy registry has25 names and modern has23. This shortlist is
scope-limited; it is not a claim to have exhausted all upstream configurations.

Caps are12/16/24/32 bitmap bits per actual inserted key at n=2^16 and2^25.
The largest requested cap is128MiB. Native constructors retain the real n and
choose their fitting power-of-two allocation:8/16/16/32 actual bits/key across
those caps, so the repeated16 geometry is measured once per round/context.
The same geometry deduplication applies to FastFilter SIMD power-of-two rows.
Existing exact-budget constructor inverses are reused for modern baselines;
Boost alignment/tail allocation counts against the cap.

For original DTL, power-of-two caps use the original automatic power-of-two
path. Other caps use the greatest original cheap-MAGIC divisor whose entire
64-byte-rounded bitmap allocation fits. `geometry.hpp` uses the pinned
`next_cheap_magic` function, never a replacement addressing algorithm. The
original constructor request is an exact positive multiple of its block size;
runtime logical bytes, backing bytes, block count and address mode must match
the planner. All padding is charged. No "requested cap" is mislabeled as the
actual bitmap size. Planner outputs are not yet measured or frozen data.

Memory output separates logical/backing bitmap, stack control object, owned
control heap, shared setup state and per-call scratch. The previous4096B
fixture's control figures must not be silently reused as large-geometry totals.
An allocation-only preflight verifies at least one large pow2 and one large
MAGIC PImpl fixture before any new memory claim. The existing requested-C++-heap
and directly wrapped-mmap scope still excludes allocator usable size/RSS and
malloc inside external libraries.

## Raw-u32 API and timer semantics

All APIs receive the same raw32-bit keys. The fixture is a32-bit bijection over
disjoint insertion, timed-negative and calibration counter intervals. PageBloom
receives **four bytes**, not a pointer to a widened8-byte key. DTL calls its
unchanged raw-u32 hash/contains API. Native, FastFilter, Boost identity-hash and
Rocks core adapters widen the raw key and apply the same `MurmurHash64` inside
each timed query path. There is no prehash-only metric in this track.

Three modes are fixed: public singleton; public dense batch1; public dense
batch4096. Page's byte hash remains inside all three. DTL batch modes include
`batch_contains` **and zero-fill/compact-to-dense conversion** inside the timer.
Its compact scratch is exactly4*batch bytes; full-width physical stores are
allowed through that capacity, never beyond it. The modern common-hash scratch
is8*batch bytes; Page needs none. Scratch allocation is outside query timers and
its requested capacity is reported. The singleton mode uses no batch scratch.

Every mode materializes the same dense u32[query_count] output. No count-only
or returned-position-only result competes against dense output. Initial warmup
checks every output against public singleton answers, verifies every inserted
key and validates compact positions separately. Every timed repetition checks
the full vector, 0/1 domain, guards, checksum and hit count after its timer.
Poison/reset, checksum, volatile consumption and validation are identical and
outside all timers. The six permutations of three modes are used once each in
each six-repeat block, seeded by a rotation shared by all configurations.

The initial screen is seed42 only: n16/25, q2^22,50% hits, six query repeats,
two launch-order rounds, independent cal2^24 negatives, one complete build per
configuration/round. Construction is untimed with `build_repeats=0` and all
construction timing fields NaN. Calibration repeats across API aliases are
checked for equality but **never pooled as independent evidence**. Report
pointwise Wilson95 upper endpoints at1%,0.1%,0.01%; fixed failures stay failed.
The raw-u32 results cannot inherit u64 quality gates or historical timings.
Fresh seeds and any confirmation shortlist will be fixed before follow-up data.

## Minimal next preflight

`geometry_check.cpp` and CMake define56 fresh-process cases per backend: seven
original configurations × two n values × four caps. Each allocates the actual
target geometry, inserts65536 keys (a correctness fixture, not an FPR sample),
compares every bitmap byte across all three public surfaces, validates all
insertions, all-miss/all-hit/mixed compact+dense results,0..131 tails/offsets and
4096/4097/4127 lengths with exact-n protected scratch. The independent numeric
address oracle checks original MAGIC against `%` and power-of-two addressing
against unsigned multiply-high. The planner proves maximal fitting divisor
and rejects zero/small/overflow/invalid block geometries.

Reuse each matching existing archive: native-O3, AVX2-O3, native-ASan-O1.
No whole-library rebuild and no unsupported non-AVX replacement is required.
Compiler/version, flags, actual consumed Boost root, archive hash and original
passed binary provenance must be verified before configuration. The linked
archive hashes and final56-case planner outputs will enter the next preflight
freeze. Native, AVX2 and ASan output/geometry parity is mandatory.

After this original-API preflight, compile the two timing workers and run only
small semantic checks:0/50/100% hits, the three modes, output guards, matching
raw-workload digests/native outputs across contexts, Page4-byte identity,
malformed selection/geometry, exact trial scheduling and fixture-only injected
output faults. Check both actual native and modern header closures. A complete
source/binary freeze and root approval precede the first timed matrix.

Current blockers are explicit: geometry sources have not compiled; archive
reuse and large/MAGIC accounting are not yet validated; timing workers/driver
must still implement this reviewed contract. Offline tests only validate the
prespecified registry/domain/schedule, not the BF code.

Once the preparation commit and CPU2 lease are granted, the explicit command is:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 benchmarks/vldb-raw32-stage2/preflight.py \
  --source-commit FULL_PREPARATION_COMMIT --cpu 2 --lease socket0 \
  --output benchmarks/vldb-raw32-stage2/validation-v1 \
  --build build/vldb-raw32-stage2-v1
```

The driver checks committed blobs, the original429-file proof, unchanged pinned
upstream trees, consumed original headers and all three archive hashes before
building. It compiles one new translation unit per backend and refuses to
rebuild original library sources. All168 fresh-process cases, current consumed
headers, macro boundaries, commands, errors and actual binaries are retained.
Different backend outputs must agree exactly. Elapsed build/check durations
are diagnostic bookkeeping, never BF performance observations.
The build root must be absent; the driver reserves it before configuring any
backend, so stale CMake cache overrides cannot leak in. Before calling the
frozen parent's lease helper, the local guard requires CPU2 affinity and an
inherited descriptor whose `/proc/self/fdinfo` already records `FLOCK ADVISORY
WRITE` on the exact socket0 lock. Merely opening that file is insufficient.
