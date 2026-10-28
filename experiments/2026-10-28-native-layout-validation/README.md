# Native C++ layout validation evidence

The native FourSector and Split64 implementations matched their frozen prototypes
for complete query outputs, allocation, copies, collision-heavy insertion,
parallel construction, and overlapping immutable queries. Scalar/AVX2/AVX-512
builds agreed. ASan, UBSan, and TSan reported no errors in the exercised cases.
These are correctness checks, not throughput measurements or a proof covering
all possible concurrent schedules.

## Retained evidence

| File | Scope |
| --- | --- |
| [native-tests.json](native-tests.json) | GCC scalar, GCC AVX2, Clang AVX-512F ASan/UBSan, GCC scalar TSan builds of `tests/test_layouts.cpp` |
| [frozen-parity.json](frozen-parity.json) | GCC AVX2, Clang AVX-512F and GCC scalar TSan builds of the additional prototype comparison |
| [parity.cpp](parity.cpp) | Preserved source of that full-output comparison |
| [post-hardening-parity.json](post-hardening-parity.json) | Final GCC AVX2 rerun after counter-stride, range-arithmetic and scratch-overflow hardening |
| [source-manifest.json](source-manifest.json) | Native/frozen source hashes, retained executable hashes, compiler versions, CPU details and capture time |

The initial sanitizer/ISA matrix preceded three portability hardenings in
`parallel_layout_bloom.h`: counter rows now derive their stride from
`sizeof(size_t)`, range splits use 64-bit products, and scratch-size estimation
checks overflow. The final GCC AVX2 parity run includes those changes. Their
64-bit partition/membership behavior was unchanged. No exact pre-hardening
header snapshot was captured, so the manifest's source hashes identify the
**post-hardening state**, not an asserted byte-for-byte source identity for the
earlier sanitizer binaries. Historical command paths in the JSON retain `/tmp`;
the runner below uses the archived source instead.

## Covered cases

The repository test independently derives each required bit in a flat bitmap,
checks every inserted key, and tests tails 0–145 with offsets 0–7 and exact input
allocations. It covers tiny/saturated and larger filters, duplicate and same-line
keys, invalid sizes, output sentinels, and serial/parallel results for 1/2/3/7
workers. AVX-512 ASan checks masked-tail memory bounds; TSan exercises the
partitioned writes and scoped joins.

The extra parity source uses both production and frozen implementations with
capacities 1024,65539,1048579; requested 4/8/16 bits/key; query batches 7/31/4096;
full-size insertion; uniform and collision-heavy hashes; copied filters; parallel
builds with 3 workers; parallel queries with 7 workers; and overlapping read-only
queries. It also checks the largest accepted sizing geometry without allocating
the full 256 MiB bitmap. Every backend produces these aggregate checksums:

```text
FourSector: 2018356366237207559
Split64:    7874112049163596729
```

## Reproduce

From the repository root on an x86-64 host with AVX2 and AVX-512F, GCC, Clang and
working sanitizer runtimes:

```sh
python3 experiments/2026-10-28-native-layout-validation/run.py \
  --output-dir build/native-layout-validation-new --cpu 3
```

The runner creates a new directory, rebuilds all seven checks with the recorded
flags, records current source/binary hashes and complete status/output, compares
cross-ISA parity checksums, and removes its temporary executables. It returns an
error for any compile, execution, sanitizer or checksum failure. It does not
silently skip unsupported ISA/sanitizer cases. To run a selected subset:

```sh
python3 experiments/2026-10-28-native-layout-validation/run.py \
  --output-dir build/native-layout-validation-avx2 --cpu 3 \
  --cases native-gcc-avx2,parity-gcc-avx2
```

Source changes after this archive create new validation evidence; inspect the
new hashes rather than attributing earlier results to later code. No production
or frozen source was modified by this independent review.
