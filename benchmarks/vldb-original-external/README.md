# Original VLDB public API baseline

The correctness and requested-allocation stage passes with GCC12.2 on native
AVX-512 and AVX2-only backends. Native ASan/UBSan also passes with the ordinary
allocator. No throughput or FPR ranking has been measured. The unchanged
artifact does not build without AVX; that compiler failure is retained.

| Proof | Evidence | Result |
|---|---|---|
| Native public APIs and allocation accounting | [V4](validation-v4-gcc-process/metadata.json) |8 process cases,9 allocation rows pass|
| Native ASan/UBSan | [V5](validation-v5-gcc-native-asan/metadata.json) |8 cases pass, no diagnostics, ordinary-output digests match|
| Non-AVX whole-library build | [V6](validation-v6-gcc-portable/scalar-build.stderr) |Unsupported upstream emulated `storeu` specialization|
| AVX2-only public APIs and allocation accounting | [V7](validation-v7-gcc-avx2/metadata.json) |8 cases pass; outputs and allocation records exactly match native|

The original public `U=0` scalar query policy passes in the native/ASan/AVX2
builds. The unsupported case is the complete artifact built without AVX.
AVX2 macro records contain no AVX-512 feature macros. Normal targets use-O3;
the correctness-only ASan/UBSan target uses-O1 with recovery disabled. Full
compiler commands, actual consumed headers, source snapshots and binary hashes
are archived. Executables remain locally retained and Git-ignored.

The exact pins are reproduction `0d2fe8e72496909cdac73c914e8f1a3dd956ac7f`
and DTL `c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`.
[source-lock.json](source-lock.json) records394 DTL file hashes;
`verify_sources.py` checks unchanged commits, trees, URLs, gitlink and contents.
Historical local worktrees remain untouched. Original license files are retained.
The [design note](../../experiments/2026-10-29-vldb-public-api-adapter-design.md)
records the initial scope; [BUILD-NOTES.md](BUILD-NOTES.md) retains all failed
and corrected preparation stages.

`ArtifactPublic` calls the original `dtl::bbf_32`/`dtl::bbf_64` PImpl API.
`DirectDynamic` and `StaticLogic` separately expose the public std::function
wrapper and its public named alias. No private kernel replaces the artifact
label, and no upstream implementation is edited.

A fresh process is required for each configured U. Upstream
`calibration_data.cpp:450` uses `map.insert`, so repeated force-unroll calls do
not replace existing entries. Each process performs
Configure→construct→metadata→use→destroy; guards reject retuning while an object
is alive and reject a different U even after its destruction. Actual name()
metadata is checked every time. HOME and the original tuner file remain
untouched; this proof observed that the file was absent. No tuning benchmark or
persistence API is called.

Raw keys are u32 values from a seeded permutation of disjoint checked counter
domains. They are never truncated from the existing u64 stream. Native controls
widen them and apply the common64 hash inside raw insert/query calls; the
artifact keeps its own hashing. This is a separate raw-u32 contract with no
artifact pure-prehash claim.

[SCRATCH-AND-ALLOCATION.md](SCRATCH-AND-ALLOCATION.md) describes the exact physical
compact capacity: `n` u32 slots, including stores beyond the returned hit count.
Guard-ended buffers check all-miss, all-hit and mixed queries, complete outputs,
all inserted keys, duplicate inserts, bitmap equality between public surfaces,
tails0..131 and long tails4096/4097/4127. The seven layout/U cases cover32/64-bit
W8/S8/K8 at U1/2/4 and64-bit W1/S1/K8 at U0, with32768-bit bitmaps.

For those4096B bitmaps, both normal backends report:

| Public surface | Adapter object bytes | Owned control heap bytes | Bitmap request bytes |
|---|---:|---:|---:|
| DirectDynamic |216|108|4096|
| StaticLogic |40|0|4096|
| Original PImpl |48|284|4096|

Each fresh PImpl process additionally retains39217B of shared setup C++ heap;
setup allocation traffic is194575B. Temporary metadata traffic is318B. The
checked insert/contains/batch calls request no C++ heap or mappings, and owned
control/bitmap destruction restores exact prior live totals. Compact scratch
for4096 queries is16384B. Shared state, stack objects, tracker overhead and
scratch are separate from the bitmap; these are not total-process/RSS or
allocator-usable-size claims. The allocation-prefix tracker is a separate
correctness executable and is never a sanitizer or throughput target.

The build consumes one complete Boost1.83 header root. Native and AVX2 records
contain609 Boost headers among1153 consumed compiler inputs, with17 complete
compile commands each. CMake compiles both PImpl sources, all ten unchanged
explicit-instantiation units, calibration-data and platform support; Threads/dl
are linked, while FAST_BUILD and optional NUMA support remain disabled.

A new reproduction must use fresh output/build paths and an authorized lease:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 benchmarks/vldb-original-external/validate.py \
  --lease socket0 --cpu 2 --compiler g++ \
  --output-dir /tmp/vldb-normal-proof \
  --build-root /tmp/vldb-normal-build --backends native avx2

flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 benchmarks/vldb-original-external/validate.py \
  --lease socket0 --cpu 2 --compiler g++ \
  --output-dir /tmp/vldb-asan-proof \
  --build-root /tmp/vldb-asan-build --backends native --sanitizers-only
```

The pinned Clang23 failure is a four-declaration restrict-placement syntax issue;
no compatibility overlay is applied here. A future combined build using
Boost.Bloom1.92 must choose one complete Boost root and revalidate it. Larger or
MAGIC-addressing geometries, FPR calibration, and a fair raw-u32 performance
protocol remain separate work. There is no throughput executable in this archive.
