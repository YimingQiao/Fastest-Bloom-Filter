# Native K12 multithreaded callers: bounded correctness preparation

This directory implements the two callers for the fixed [195-row plan](../2026-10-29-native-k12-parallel-plan/README.md), committed as `295ff839e4f3199f05992add42f85ff54861e45c`. It is source preparation, not a completed measurement. The bounded preflight below does not launch that matrix or rank its incidental timing values.

`derive.py` copies the complete native header closure from `6e7df603a02e2e7d1c226afaff6d37c14f841f3b`, including the accepted dedicated K12 parallel owner. It copies the external adapters, executor and placement code from the proved exact-budget MT caller at `35c97d584b600fdd71e6c086459433a53d4e567a`. `DERIVATION.json`, `QUERY.patch` and `GEOMETRY.patch` record every derived change. No native kernel or upstream filter is edited. The existing native correctness proof is committed at `83db1921ddecec0f14820f264cc64da2add3b6fb`; this stage tests the actual new callers rather than repeating that kernel matrix.

## Track A: common executor query

`query.cpp` registers the six production/optional native layouts and nine fixed external API controls named in `checks.NAMES`. The plan selects 49 distinct size/API/actual-geometry points from these 15 types. The external points retain both the previous exact-budget leaders and the fixed/conservative rivals from the earlier three-seed T8 confirmation, including smaller allocations and exact Boost padding. The planned 147 rows use three already-seen construction seeds; this is not a new-seed quality claim.

Each process constructs one complete serial bitmap and validates every inserted key. Construction timings are NaN and `build_repeats=0`; the original repeated-build tax is removed. The pure and hash-plus-query paths share each type's same noinline lookup kernel. The unchanged executor uses caller worker zero, seven spawned workers and complete global batches. Launch, gated query, join and end-to-end metrics retain their separate meanings.

The four timed modes are serial pure, serial hash-plus-query, parallel pure and parallel hash-plus-query. A seed-permuted four-row Williams schedule balances each position and every directed adjacent pair; only complete blocks are accepted. Every timed output is checked element by element against the full untimed reference, with guards, 0/1 checks and the same post-timer checksum consumption. Raw and prehashed input fingerprints must be unchanged. Calibration follows timing in a disjoint raw-key interval; each API/geometry/seed retains its own denominator, and known aliases do not provide extra samples.

## Track B: actual native public APIs

`public_api.cpp` instantiates the actual `ParallelSplit64BloomFilter`, `ParallelSplit64RangeBloomFilter` and `ParallelFourSectorRange12BloomFilter` from the pinned native closure. Calls to public `InsertParallel` and `LookupParallel`, including their real partitioning and thread lifecycle, remain inside the clocks. Requested T1 and T8 alternate first position equally. Build measurements use a fresh object; insertion-only and allocation-plus-insertion describe the same operation. Query timing uses a separately built immutable object. Hashing is prepared outside these clocks, so this track is explicitly prehashed whole-array public API work. It is not ranked against Track A's batch executor, and there is no external-serial-versus-native-parallel build victory panel.

The native wrappers use their actual ownership rules. K12's owner is computed from its top-24-derived physical line, not the generic power-of-two/high-32 approximation. Effective worker counts and public construction scratch are recorded. The caller permits the eight declared physical cores on one socket; it does not add private per-thread pinning to the native public implementation. Track A individually pins its executor workers. That placement/context distinction remains visible.

Before quality can be reused from Track A, this caller checks all inserted keys for false negatives and every threaded query element against its serial reference. Across the two processes, the raw/prehashed input fingerprints, complete-output checksum, mixed-query counts, false positives and actual bytes must agree. This process does not generate new calibration samples. Range and K12 additionally compare every public bitmap byte after each construction. Split64 has no public bitmap accessor, so this caller does not invent one or claim its full bitmap comparison.

**Validation memory is part of the measured working-set context.** The serial reference object is destroyed before timed objects are created, but its copied bitmap remains resident for Range/K12 full-byte checks. Split64 has no such copy. All three retain raw inputs, prepared hashes, expected output and guarded output. `validation_bitmap_bytes`, `validation_expected_output_bytes` and `caller_buffer_bytes` disclose these requested vector backing bytes. The extra reference copy is not part of the filter bitmap-cap charge, but can affect cross-family cache/memory interpretation. T1/T8 within a family have the same auxiliary memory. This is not a one-bitmap-equivalent-residency or total RSS claim; native partition scratch is reported separately, and allocator/thread-runtime overhead is not included.

## Minimal preflight

After review, an exact source commit and an explicit CPU2/socket0 lease, run from the repository root:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 experiments/2026-10-29-native-k12-parallel-caller/preflight.py \
  --source-commit FULL_REVIEWED_40_HEX_COMMIT
```

The complete operation holds the inherited exclusive lock. It requires new `validation-v1/` and `build/native-k12-parallel-caller-v1/` paths. Compilation remains on CPU2; executable children explicitly expand to `2,4,6,8,10,12,14,16` with NUMA node 0 binding. The preserved placement validator requires distinct physical cores on the same socket/node. The actual invocation `/usr/bin/clang++` is retained rather than replacing its driver name with its resolved `clang` target.

The bounded native and ASan/UBSan profiles execute:

- 15 shared-query API rows per profile: n=q=32,768, requested24 bits/key, 50% hits, batch4096, four balanced repetitions, seed101, whole-input setup, 4096 independent calibration negatives, and eight actual workers.
- Three public native rows per profile using the same input, two paired repetitions and actual T1/T8. These 6 rows must agree semantically with the corresponding 30 shared-query rows and with the other backend.
- Seven invalid selections/arguments per profile, rejected before CSV, for 14 expected failures.
- The unchanged executor coverage/cancellation/fault tests and the new schedule test. Six Python synthetic guards cover complete registration, exact hits/disabled builds, seeded schedule, sample summaries, cross-caller identity and auxiliary bitmap memory disclosure.

The tiny power15 fixture reaches exactly eight workers under the actual public worker policy. No formal construction seed, large workload, new kernel matrix or 195-row run is executed. The preflight contains 32 recorded commands: 18 expected successes and 14 expected CLI failures. Failure logs and partial metadata are preserved instead of relabelled as success.

The guard first checks committed local bytes and original anchors. `dependency-pins.json` contains the 348 exact previously consumed dependency files from the committed parent proof. Actual `.o.d` files are retained and every consumed repository input must match prepared local or inherited bytes; a live root-native include or an unprepared dependency fails before BF execution. Compiler invocation/target, flags, topology, dependency files, binary hashes, stdout/stderr and exact commands are retained. A later manual assembly review must trace the actual native call/timer boundaries before any formal performance authorization.

The initial six Python synthetic tests passed without compiling or executing a Bloom filter. There is no performance result in this preparation.
