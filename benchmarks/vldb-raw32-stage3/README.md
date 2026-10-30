# Paired public raw-u32 workers — source preparation

This additive stage has not compiled or executed a Bloom filter yet. Thirteen
offline contract tests pass. It preserves the original public-API archive and
the completed 168-case larger/MAGIC geometry proof. No prior timings or u64
false-positive gates are reused for this different raw-u32 stream.

The legacy executable contains 21 original configurations plus four native
controls. The original variants are 32-bit and 64-bit eight-word/eight-sector
K8 blocks at U1/U2/U4, and a one-word 64-bit K8 register block at U0. Each retains
the actual PImpl, public dynamic, and public static API separately. Metadata is
queried after configuration/construction and checked before use; each variant
runs in a fresh process so the upstream non-overwriting tuner cannot silently
reuse a different U. The existing tuner file is fingerprinted, never changed.

The modern executable contains the same four native controls and the fixed 19
external aliases listed in `protocol.json`. These are the union of prior
exact-capacity and scalar-track external leaders, the RocksDB K8 batch control,
and all six PageBloom variants. This is a fixed panel, not an exhaustive search
over every possible original-library probe count.

**The executables use separate complete Boost contexts: legacy 1.83 and modern
1.92.** They share byte-identical workload, query loop, native snapshot, and
timer sources, GCC12.2, and the same new-harness optimization flags. The original
library archives are reused byte-exact with their recorded original flags;
they are not rebuilt. Both new harnesses use `-fno-strict-aliasing` for the
existing modern adapter contract. Original archived code keeps its original
compilation policy. These are paired API/context observations; results must
retain each executable's native controls and individual timings. Do not
subtract or normalize a measured native context shift.

`Query<F>` retains compiler-visible public singleton calls inside an independent
key loop. A symmetric erased call surrounds the whole query array, not each
key. Out-of-line original public APIs and their own function dispatch remain
intact. The singleton track measures independent-query throughput, not a
dependent single-lookup latency. The other tracks call a common noinline dense
boundary with batches 1 and 4096. Original compact-position conversion to dense
u32 output is inside both batch timers. Modern/native common Murmur64 hashing
of the zero-extended u32 is inside their timers; PageBloom uses its own public
hash of **four raw bytes**. The original APIs hash their raw u32 directly.

Scratch is prepared outside timing and charged by exact requested capacity:
original positions 0/4/16384 bytes, common hashes 0/8/32768 bytes, PageBloom zero.
Full-input build hashing and FastFilter bulk-build heap scratch are separate
columns. One complete untimed build is followed by all-inserted no-FN checks,
three full guarded warmups, then six repetitions containing all six query-mode
permutations. Every timed result is checked element-by-element after the clock,
with full checksum, input digest, and output guards. Build fields remain NaN
and `build_repeats=0`.

The fixed future screen has n=2^16/2^25, bitmap caps 12/16/24/32 bits/key,
q=2^22, 50% requested hits, seed42, and 2^24 unique disjoint calibration
negatives. Real n is preserved in native constructors. Actual geometry is
deduplicated per API alias: native and SIMD power-of-two points are measured
once for all represented caps. The source-derived plan contains 192 legacy
and 172 modern rows per launch round; two fixed rounds use legacy→modern and
modern→legacy, yielding **728 rows and 166 calibration identities**. API/U/round
aliases must reproduce their stream and outputs and are never pooled as extra
negative evidence. All losses and pointwise quality failures remain in the
eventual report; cap1%/.1%/.01% qualification uses actual charged bitmap bytes.

The bounded preflight compiles only the two worker TUs and a separate accounting
fixture against verified archives. It checks 158 ordinary and 48 ASan/UBSan
worker cases, including all48 API names, mixed/all-hit/all-miss streams, exact
native cross-context parity, aliases, tails0..131, offsets0..3, and batch-boundary
lengths4095/4096/4097/4127. Invalid CLI and a deliberate bad output must fail
before CSV. Correctness rows have no timing trials. Actual consumed compiler
headers and Boost roots are captured per target, along with bounded typed-query
assembly. No original-library source or frozen proof is modified.

Large accounting uses **six fresh processes / 18 surfaces**: three original
layout families × cap16 POW2/cap24 MAGIC at the n=2^25 geometry. These are actual
**64 MiB and 96 MiB** backing allocations, with 65536 inserted fixture keys and
4096 queries. All control/tuner/metadata/API/bitmap/position-scratch counts are
new measurements, never copied from the old 4096-byte fixture. The 128 MiB point
has the earlier Stage2 geometry/backing proof only. Accounting separately
captures requested C++ heap and wrapped mmap, not allocator usable bytes, RSS,
or libc-internal allocations. The worker's `adapter_object_bytes` includes its
benchmark facade; the accounting fixture reports its original public facade
separately. Bitmap caps do not hide these additional reported costs, and are
not a claim about total process memory.

After review and commit, the authorized correctness command is:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 benchmarks/vldb-raw32-stage3/preflight.py \
  --source-commit FULL_COMMITTED_PREPARATION_SHA --cpu 2 --lease socket0 \
  --build build/vldb-raw32-stage3-v1 \
  --output benchmarks/vldb-raw32-stage3/validation-v1
```

The whole-operation inherited write lock and absent build/output paths are
required. Failures stay archived and are not overwritten. After a successful
proof, `freeze_preflight.py --source-commit SHA --proof .../validation-v1` seals
the exact binaries, actual consumed inputs, and proof artifacts. That freeze
must be reviewed and committed before `run_screen.py` can run; no timing lease
is implied by correctness approval. The screen runner verifies the exact
requested commit and freeze, checks every returned row immediately, preserves
both launch orders, and verifies unchanged sources/binaries again at completion.

`source-deltas.patch` records the local derivations. Legacy adapters add only
metadata forwarding; Boost adds only a force-inlined forwarding call to public
`may_contain`. Original construction/Insert/Lookup bodies remain unchanged.
Third-party attribution and licenses remain in the pinned ancestor archives.
