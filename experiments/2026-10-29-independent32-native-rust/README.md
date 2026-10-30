# Native Rust Independent32 prototype

Correctness and public-call code-generation preflight completed; no timing has
occurred for this Rust port. Production `rust/` and every earlier experiment
remain unchanged. `native/` is an isolated clone of the seven current native source
files, with one added module and export. The new package is unpublished.
The clone retains the upstream/native attribution unchanged in
`native/LICENSE-MIT`, `native/LICENSE-APACHE` and `native/NOTICE`, including the
copied ByteSplit mask's Apache-2.0 attribution. Their original and copied hashes
are recorded in `source-reference.json`.

The mapping is exactly the frozen C++ `IndependentVbmi32`: sector j receives
`1u32 << ((hash >> (5*j)) & 31)` for j=0..7, and bucket address is
`(hash >> 41) & bucket_mask`. Bit40 is unused. Sizing retains the existing
strict-next-power-of-two behavior, 128B minimum and 256MiB maximum. This is a new
layout, not a change to existing native bitmaps or serialization.

The Rust storage is `#[repr(C, align(64))] Line([[u32;8];2])`. Two 32B buckets
share one line. Public operations are native Rust singleton insertion/query,
batch insertion/query, and exclusive parallel construction/immutable parallel
query. There is no FFI, extra hash or new prefetch policy. Runtime detection
selects scalar, AVX2, or AVX2+AVX512F/BW/VL/VBMI; the existing disable-avx512
feature prevents VBMI dispatch while retaining AVX2.

The new public `contains_hash` deliberately uses `inline(always)` so callers can
see its backend branch. Target-feature helpers retain ordinary `inline` hints.
This decision preceded all performance data. The first correctness logs before
that single hint adjustment are retained separately; final-source tests and
assembly are under `validation/`.

VBMI preserves the exact C++ mask construction: `VPMULTISHIFTQB` extracts bytes
at offsets0,5,...,35, widens the low eight bytes to u32 lanes and rotates a one
by each count. The rotate's low-five-bit count semantics discard extracted
bits beyond each independent five-bit field. AVX2 uses the original
shift/shuffle/extract sequence; the scalar oracle is expressed separately with
byte addresses and division/remainder. Upstream C++ reference paths and hashes
are retained in `source-reference.json`.

This candidate targets the strict32bpk tier, where the C++ public-call screen
was promising. Its independent layout does not satisfy the0.1% target at
16bpk in earlier accuracy screens, so it is not a substitute for Split64's
16bpk operating point. The Rust port has no measured speed advantage yet.

## Parallel ownership

The unchanged shared `layout_parallel` helper assigns complete64B lines to
workers. The owner index is `bucket >> 1`; insertion into an owned slice rebases
the global bucket by `begin_line * 2`. Every32B vector OR stays within one owned
line. Both buckets on a line always have the same worker, avoiding cross-worker
cache-line sharing. Duplicate/colliding updates remain sequential within that
owner. Immutable readers modify no shared state.

Existing histogram/scatter/thread-launch costs and checked scratch estimates
are retained. This prototype does not introduce a new parallel algorithm or
atomic writer/reader semantics.

## Completed validation

Five tests cover capacity/alignment/overflow, all probe fields and bit40,
complete scalar-oracle bitmaps, runtime/scalar/AVX2/VBMI parity, idempotence,
query tails/offsets and guards, mismatched-output rejection before writes,
parallel builds with uniform/skewed/two-buckets-per-line inputs, full query
outputs and concurrent immutable readers. All five pass in normal,
disable-avx512 and AddressSanitizer builds. All 34 copied-library plus new tests
also pass in the final normal build. Clippy passes with warnings denied, and
the added module/test/CLI source files were formatted with rustfmt.

The validation-feature-only parity executable accepts `--parity`. It emits
JSON lines for n=17/1000/4096 and requested bpk=1/8/16. Each case resets SplitMix64
state to0x243f6a8885a308d3, inserts2048 outputs, queries the next1024 plus the first
128 inserted hashes, then exports flat u32 words and dense output. The paired
C++ prototype uses this exact fixture; comparison checks every word and answer.
All nine rows match in normal, disable-avx512 and ASan builds. The C++ fixture
SHA256 is `f71e72230306fc22ebcc812e80e3ae1bb814534f36783f03bab1bc3d12609eec`.

The two typed whole-array code-generation callers use only public
`contains_hash`, with separate prehashed and fused-common-hash loops. On the
recorded native build, both backend tests move before the loops. VBMI and AVX2
probe bodies inline completely; the scalar fallback retains a per-key helper
call. VBMI emits `vpmultishiftqb`, `vpmovzxbd`, `vprolvd` and one 32B bitmap load.
This records generated code, not a measured performance gain. Full bodies and
the executable hash are preserved in `validation/`.

No heavy command may run before an explicit socket1 lease; every future build,
test or timing matrix must hold `/tmp/fastest-bf-socket1.lock` and use CPU3.
No throughput protocol is authorized by this source preparation.
