# Wider mask dictionaries: SIMD query prototypes

These experimental C++ filters keep the two-sector bitmap structure but expand each
four-bit mask dictionary from 32 to 64 or 128 entries. They change the hash-to-bit
mapping and therefore **do not have the same answers or FPR as FastPattern32**.
They are not native defaults and have no Rust port yet.

Every key sets four bits in each of two 32-bit words (**eight probes per key**), at
all space budgets. There is no sparse six-probe mode. Insertion is a simple scalar
loop, not the optimized native builder; insertion costs must be measured and shown
separately before selecting these variants.

| Dictionary | First mask fields | Second mask fields | Partner selector |
| --- | --- | --- | --- |
| 64 entries | low bits 0–5 index, 6–10 rotation | 11–16 index, 17–21 rotation | 22–24 |
| 128 entries | low bits 0–6 index, 7–11 rotation | 12–18 index, 19–23 rotation | 24–26 |

The high 32 hash bits select the first word, as in FastPattern32. The partner stays
in the same cache line. Dictionary generation and independent scalar FPR results
are in [the mask sweep](../2026-10-28-mask-sweep/README.md). Active dictionaries
occupy **256 or 512 shared bytes**, versus 128 active bytes in FastPattern32. This
static storage is additional to the equal bitmap payload and must not be hidden.

## Query implementation

The selected prototype uses four/eight resident ZMM tables and tree-shaped
`permutex2var` lookups, followed by a variable rotate. It retains the 16-key main
loop, 8-key paired-sector tail, scalar final tail, and 64-key look-ahead prefetch.
A second prototype fetches masks with L1 gathers; this loses roughly 45% on tiny
filters in the screening matrix and is not registered in the unified benchmark.

## Measurements

`screen.csv` holds 48 screening cases (seed 42, 0/50/100% hits, four sizes, both
strategies and widths). `confirm.csv` holds 72 register-kernel cases (seeds
43/44/731, 50% hits, batches 8/31/4096). Each case interleaves old and new kernels in
pseudorandom order, warms before timing, then records median ns/query over nine
repetitions of 2^20 prehashed queries. Outputs are consumed outside timing.

All timing uses **CPU 3**, Xeon Platinum 8474C, Clang 23,
`-O3 -std=c++17 -march=native -DNDEBUG`. `metadata.json` records compiler flags and
source hashes. `baseline_snapshot.h` preserves the native 32-entry implementation
including the eight-key tail. These are same-process kernel comparisons, not an
external-library ranking. Candidate and baseline FPR differ.

Median reference/candidate speedup across the three confirmation seeds; requested
16 bits/key, actual 32 bits/key. Values below 1 are regressions.

| Dictionary | Batch | 16 KiB | 4 MiB | 64 MiB | 128 MiB |
| --- | --- | --- | --- | --- | --- |
| 64 | 8 | 0.985× | 1.025× | 1.033× | 1.039× |
| 64 | 31 | 0.968× | 1.003× | 1.011× | 1.015× |
| 64 | 4096 | 0.996× | 1.001× | 1.008× | 1.023× |
| 128 | 8 | 0.864× | 1.002× | 0.995× | 1.018× |
| 128 | 31 | 0.898× | 0.964× | 0.952× | 0.967× |
| 128 | 4096 | 0.864× | 1.000× | 0.997× | 1.012× |

The 64-entry variant is close enough to justify unified external/FPR-constrained
measurements. The 128-entry version trades more lookup work for a larger dictionary;
it is not an unconditional improvement. Noise at a few percent is not evidence of
a universal speed advantage. Use the mask sweep's much larger independent negative
sample counts for accuracy, not these throughput runs' `positive_queries` column.

## Unified benchmark

```sh
cmake -S benchmarks/all-external -B build/all-external-wide \
  -DCMAKE_CXX_COMPILER=clang++ -DBF_NATIVE=ON -DBF_WIDE_EXPERIMENTS=ON
cmake --build build/all-external-wide -j
# Names: FastPattern64Experiment, FastPattern128Experiment
build/all-external-wide/compare_benchmark 20 16 50 22 4096 5 731 \
  FastPatternBF,FastPattern64Experiment,FastPattern128Experiment 1048576
```

The option defaults off. Registration also requires `__AVX512F__`; there is no
AVX2 implementation. Use a separate build/output directory so an existing baseline
binary is not overwritten during a measurement matrix.

## Standalone reproduction and checks

```sh
clang++ -O3 -std=c++17 -march=native -DNDEBUG -DDICT_BITS=6 -DUSE_GATHER=0 \
  -Iinclude experiments/2026-10-28-wide-pattern/probe.cpp -o build/wide-6-0
taskset -c 3 build/wide-6-0 20 16 50 4096 43
```

Arguments are key power, requested bits/key, hit percent, batch, and seed.
Use `DICT_BITS=7` for 128 entries or `USE_GATHER=1` for the rejected mask-gather
strategy. The microbenchmark verifies every SIMD output against its scalar
interpretation and checks all inserted keys for false negatives.

```sh
clang++ -O1 -g -std=c++17 -march=native -fsanitize=address,undefined \
  -fno-omit-frame-pointer -DDICT_BITS=6 -DUSE_GATHER=0 -Iinclude \
  experiments/2026-10-28-wide-pattern/check.cpp -o build/wide-check-6
taskset -c 3 build/wide-check-6
```

The dedicated ASan/UBSan check compares with the mask sweep's independently written
scalar filter. It passes for both dictionary widths over lengths 0–131, unaligned
inputs, output canaries, empty filters, repeated inserts, and multiple payload sizes.
The unified-harness smoke also checks full construction and raw/prehash accounting.
