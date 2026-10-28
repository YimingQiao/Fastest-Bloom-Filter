# RocksDB FastLocalBloom core baseline

This optional adapter pins the official [RocksDB v11.12 release](https://github.com/facebook/rocksdb/releases/tag/v11.12),
published on 2026-10-26, to commit
[`ef3dd12e9a6314aaf08fba6d5d445494eac9b253`](https://github.com/facebook/rocksdb/tree/ef3dd12e9a6314aaf08fba6d5d445494eac9b253).
The commit date is 2026-10-09. `manifest.json` records immutable URLs and SHA-256
for fifteen unmodified files: nine compile-time headers, two implementation
references, and four license/attribution files (179,441 bytes total). No RocksDB
library or database is built. Apache-2.0 is the selected upstream license; the
LevelDB notices and all supplied license files are retained under `vendor/`.

## What is measured

The unchanged [`FastLocalBloomImpl`](vendor/util/bloom_impl.h) exposes prehashed
`AddHash`, `HashMayMatch`, `PrepareHash`, and prepared add/query methods. The adapter
passes the low 32 hash bits to cache-line selection and the high 32 bits to probe
generation, exactly as RocksDB's production reader does. The upstream AVX2 query
kernel is enabled by the compiler's AVX2 feature; the original scalar fallback is
used otherwise. This is a core bitmap benchmark, not an SST or database benchmark.

| Row | Probe count | Query schedule | Insertion schedule |
| --- | --- | --- | --- |
| RocksDBFastLocalBloom64 | Upstream automatic choice | Direct prehashed API per key | Direct AddHash per key |
| RocksDBFastLocalBloom64Batch32 | Upstream automatic choice | Prepare all, then query all, groups of at most 32 | Upstream eight-slot prepare/add/drain pipeline |
| RocksDBFastLocalBloom64K8 | 8, compile-time constant | Direct prehashed API per key | Direct AddHash per key |
| RocksDBFastLocalBloom64K9 | 9, compile-time constant | Direct prehashed API per key | Direct AddHash per key |
| RocksDBFastLocalBloom64K14 | 14, compile-time constant | Direct prehashed API per key | Direct AddHash per key |
| RocksDBFastLocalBloom64K8Batch32 | 8, compile-time constant | Same batch32 schedule | Same eight-slot pipeline |
| RocksDBFastLocalBloom64K9Batch32 | 9, compile-time constant | Same batch32 schedule | Same eight-slot pipeline |
| RocksDBFastLocalBloom64K14Batch32 | 14, compile-time constant | Same batch32 schedule | Same eight-slot pipeline |

The scheduling references are `FastLocalBloomBitsBuilder::AddAllEntries` and
`FastLocalBloomBitsReader::MayMatch` in
[`filter_policy.cc`](vendor/table/block_based/filter_policy.cc); the upstream
[`MultiGetContext`](vendor/table/multiget_context.h) limit is 32. Only the input
container changes: prehashed contiguous words replace the builder's deque and the
reader's Slice hashing. No masks, probe generation, range reduction, or SIMD code
are rewritten. Fixed aliases compile-specialize the unchanged upstream core API:
the adapter's probe-count helper returns the template constant for fixed rows,
so the compiler can fold the upstream loop and selector conditions. Automatic
rows retain a runtime member chosen by upstream `ChooseNumProbes`. This exposes
the same constant-folding opportunity as the other fixed-probe baseline families.
These are explicit core configurations, not calls to the DB factory or claims
about its default specialization. Each fixed count has both direct and batch32
schedules so a bulk schedule does not conceal a stronger single-query option.

All timing comes from `src/compare_benchmark.cpp`. `input_mode=prehashed` and
`hash_bits=64` are reported. End-to-end hashing rows use the same benchmark
`MurmurHash64` as other prehashed filters; they do **not** measure RocksDB's
`GetSliceHash64`/XXPH3 byte hashing, virtual reader calls, SST I/O, or DB lookups.

## Memory and construction contract

The adapter requests the common native strict-next-power-of-two bitmap budget,
with a minimum 128 bytes, and uses a 64-byte-aligned allocation. `SizeInBytes()`
reports the byte vector's actual capacity. Each logical bitmap is a multiple of 64
bytes. This alignment is an adapter choice; an SST-owned buffer need not have the
same alignment. Automatic probe selection calls upstream `ChooseNumProbes` with
**actual bitmap millibits/key**, not the benchmark's requested-bpk label. Thus,
requested 8/16 at a power-of-two key count produce actual 16/32 bpk and automatic
K9/K14. These are equal-memory core settings, not a call to RocksDB's factory with
those requested-bpk labels.

Only bitmap capacity is charged to `filter_bytes`, consistently with the other
core filters. Object fields and allocator bookkeeping are excluded. Bulk insert
uses two eight-entry u32 arrays (64 bytes of fixed stack scratch); bulk query uses
two 32-entry arrays (256 bytes of fixed stack scratch). The shared CSV column
`filter_build_scratch_bytes` counts explicit temporary **heap** storage only, so
it is zero for every RocksDB row. Fixed stack arrays are documented separately,
consistently with the native FourSector kernel. There is no O(n) adapter staging
allocation.

The SST builder separately collects hashes in a deque, may deduplicate entries,
can verify construction checksums, and appends five metadata bytes. Those costs
and bytes are outside this core adapter. Therefore insertion results must not be
presented as complete RocksDB SST construction times or serialized sizes.

## Validation and observed accuracy

The native, forced-scalar, and ASan/UBSan builds each pass two CTest tests. The
core test checks exact direct/bulk bitmaps against upstream AddHash and an
independent byte-level insertion oracle, all inserted
keys through both APIs, duplicate inserts, both query schedules against an
independent scalar byte-level oracle, insertion/query batches around 8/32,
lengths 0–131, explicit zero-length null pointers and output guards. Inputs also
isolate the low/high hash halves, exercise unsigned range-reduction endpoints,
and force many writes to the same cache line. The shared-harness test covers 72
configurations and all eight rows, including mixed hits, partial/full construction
batches, independent calibration, scratch accounting, fixed direct/bulk pairing,
and automatic/fixed probe agreement. Native and forced-scalar results match
exactly on the larger accuracy sample too. `validation-metadata.json` records
commands, compiler, hashes and CPU 3.
The scratch getter was subsequently corrected to the shared heap-only CSV
contract; native and ASan/UBSan contracts were rerun successfully. This metadata
correction does not change the archived bitmap/query accuracy evidence. The same
metadata file also retains the historical combined-header check with macro
redefinitions treated as errors: 49 unique registered rows, including the
original five RocksDB and two native-layout rows (plus FastPattern registered by
the shared harness). The expanded-coverage validation records the later eight-row
adapter separately: 52 unique combined adapter registrations, plus the shared
FastPattern row, for 53 total configurations. Native, forced-scalar, and
ASan/UBSan contracts all pass after expansion. A further 32 accuracy-only rows
(native/scalar, actual 16/32 bpk, eight variants) have matching checksums and
independent calibration counts. No source changed during that validation. The
RocksDB dependency target contributes no ISA flags beyond the common executable
settings.

The expanded core test initially exposed a native Clang 23 failure in its own
conditional test-input generator, before any filter query: a guarded modulo and
load were compiled into an invalid gather. The scalar and sanitizer builds did
not reproduce it. Splitting negative-key generation from an explicitly guarded
positive-key loop resolved the native failure; the adapter and vendored core
were unchanged. The failed run and subsequent successful suites are retained in
the validation metadata, rather than discarded.

`accuracy.csv` contains an **accuracy-only** check at 65,536 inserted keys,
seed 731 and 16,777,216 independent negative calibration keys per row. Timing values
printed by the common harness were discarded; this integration has no performance
ranking yet. The observed rates below are samples, not theoretical guarantees or
universal bounds. Direct/bulk automatic rows have identical counts. The archived
sample predates compile-time fixed-probe specialization and the three fixed direct
aliases; unchanged bitmap/probe semantics are checked by the expanded contracts.

| Actual bits/key | K8 | K9 | K14 |
| --- | --- | --- | --- |
| 16 | 0.089592% | 0.085729% (automatic) | 0.120860% |
| 32 | 0.001651% | 0.001299% | 0.0005245% (automatic) |

## Build and reproduce

```sh
python3 benchmarks/rocksdb-external/vendor.py
cmake -S benchmarks/rocksdb-external -B build/rocksdb-external \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build/rocksdb-external -j1
ctest --test-dir build/rocksdb-external --output-on-failure

taskset -c 3 build/rocksdb-external/compare_benchmark \
  16 8 50 22 32 5 2053 RocksDBFastLocalBloom64,RocksDBFastLocalBloom64Batch32 \
  65536 24
```

`vendor.py --fetch` restores missing/changed vendored files from the immutable
manifest and verifies each hash. The default verification and CMake configuration
work offline. `BF_NATIVE=OFF` uses the compiler's default ISA; the recorded scalar
check additionally passed `-mno-avx2 -mno-avx512f`. `BF_SANITIZERS=ON` enables ASan
and UBSan. The minimal platform headers currently support Linux and macOS; Linux
Clang is validated here.

`dependencies.cmake` exposes the `bf_rocksdb_baseline` interface target for
unified integration. `BF_REGISTER_ROCKSDB_FILTERS(ADD)` registers the eight rows.
Historical benchmark binaries retain their original baseline sets; combined
integration uses a separate build directory.
