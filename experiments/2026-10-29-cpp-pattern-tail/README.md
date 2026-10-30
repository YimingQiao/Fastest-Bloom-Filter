# FastPattern masked 4–7-key tail experiment

This directory keeps three C++ implementations of the same bitmap and query semantics in one executable. `before.h` is the frozen native header with its class renamed. `after.h` uses one masked AVX-512 paired gather for the last 4–7 queries. `after_grouped.h` additionally requires a preceding 8- or 16-key vector group, so an entire batch of 4–7 queries keeps the original scalar path. Insertion, the public <=3-key path, complete vector groups, allocation, hash fields, and sparse/dense dictionaries are unchanged. Neither candidate is a production change.

The grouped control was specified before the C++ timing screen after the Rust implementation showed that standalone 4–7-key masked queries could improve prehashed throughput while worsening hash-plus-query throughput. Freshly written hash scratch interacting with masked input loads is a hypothesis; these experiments do not establish the cause.

Both masked loads and gathers suppress inactive lanes. Equality combines each adjacent pair of 32-bit sectors into one 64-bit comparison. The output is a masked AVX-512F store; AVX-512VL, DQ, and BW are unnecessary. The AVX2 and scalar fallbacks remain unchanged.

## Correctness

`check.cpp` independently computes scalar mask rotation and sector selection, compares every bitmap word and every answer against both candidates and the old implementation, checks all inserted keys, duplicate inserts, collision-heavy hashes, null zero-length calls, input alignment offsets 0–7, output sentinels, lengths 0–131, and 4096–4127. Capacity zero, small filters, both dictionary densities, and allocations crossing the prefetch threshold are included. Exact input allocation ends let ASan detect unintended masked-tail overreads.

Native and scalar CTest, minimal AVX-512F+AVX2 without VL/DQ/BW, and native ASan+UBSan all pass with checksum `14935109807921651589`. Commands, compiler version, and source/binary hashes are recorded in `validation.json`.

```sh
cmake -S experiments/2026-10-29-cpp-pattern-tail -B build/cpp-pattern-tail -DCMAKE_CXX_COMPILER=clang++
cmake --build build/cpp-pattern-tail --parallel 1
taskset -c 3 ctest --test-dir build/cpp-pattern-tail --output-on-failure
```

## Timing protocol

The copied common harness executes all three candidates in one process, randomizes filter order, checks all inserted keys, and compares the complete first timed prehashed and hash-plus-query output against warmup outside timers. The runner additionally requires identical bytes, workload checksums, false-positive counts, and calibration counts. Scenario order is randomized once and command lines, compiler flags, CPU information, source hashes, and binary hash are saved. `sources_changed_during_run` must be empty.

The initial screen uses seed 42, 50% hits, `2^22` queries, five repetitions, `2^16` and `2^24` inserted keys, requested 8/16 bits per key (actual 16/32), and batches 4/5/6/7/8/15/31/63/4096. Build uses all keys in one call. It is a training screen and cannot establish a universal speed claim. Any selected variant requires separate fresh-seed confirmation; the ByteSplit preregistration seeds 2309/6311/10007 are not used here.

```sh
python3 experiments/2026-10-29-cpp-pattern-tail/run.py --mode speed \
  --output experiments/2026-10-29-cpp-pattern-tail/screen --cpu 3 \
  --key-powers 16,24 --requested-bpk 8,16 --seeds 42 --hits 50 \
  --batches 4,5,6,7,8,15,31,63,4096 --query-power 22 \
  --calibration-power 0 --repeats 5
```

## Initial C++ result

All 36 workloads (108 rows) matched allocation, checksum, and false-positive counts. The runner found no source changes during the screen. All figures below are candidate latency divided by the frozen original; below 1 is faster. This single-seed screen is sufficient to reject the regressions, but is not held-out evidence for promotion.

| Keys | Actual bits/key | Batch | Always masked: pure | Always masked: hash+query | Grouped only: pure | Grouped only: hash+query |
|---:|---:|---:|---:|---:|---:|---:|
| 65536 | 16 | 4 | 1.083 | 2.066 | 1.081 | 1.075 |
| 65536 | 16 | 5 | 0.907 | 1.727 | 1.089 | 1.058 |
| 65536 | 16 | 6 | 0.773 | 1.575 | 1.065 | 1.082 |
| 65536 | 16 | 7 | 0.682 | 1.226 | 1.047 | 1.007 |
| 65536 | 16 | 8 | 1.050 | 1.003 | 1.050 | 1.011 |
| 65536 | 16 | 15 | 0.832 | 0.924 | 0.834 | 0.914 |
| 65536 | 16 | 31 | 0.935 | 0.885 | 0.933 | 0.882 |
| 65536 | 16 | 63 | 0.959 | 0.987 | 0.956 | 0.975 |
| 65536 | 16 | 4096 | 1.017 | 0.987 | 0.992 | 1.003 |
| 65536 | 32 | 4 | 1.079 | 2.072 | 1.063 | 1.076 |
| 65536 | 32 | 5 | 0.925 | 1.734 | 1.088 | 1.062 |
| 65536 | 32 | 6 | 0.788 | 1.585 | 1.067 | 1.083 |
| 65536 | 32 | 7 | 0.707 | 1.231 | 1.046 | 1.004 |
| 65536 | 32 | 8 | 1.026 | 0.999 | 1.022 | 1.005 |
| 65536 | 32 | 15 | 0.827 | 0.926 | 0.824 | 0.921 |
| 65536 | 32 | 31 | 0.961 | 0.895 | 0.955 | 0.891 |
| 65536 | 32 | 63 | 0.970 | 0.988 | 0.966 | 0.975 |
| 65536 | 32 | 4096 | 1.002 | 0.994 | 0.997 | 1.000 |
| 16777216 | 16 | 4 | 0.957 | 2.744 | 1.057 | 1.046 |
| 16777216 | 16 | 5 | 0.875 | 2.235 | 1.053 | 0.997 |
| 16777216 | 16 | 6 | 0.853 | 1.957 | 1.028 | 1.092 |
| 16777216 | 16 | 7 | 0.846 | 1.636 | 1.013 | 1.054 |
| 16777216 | 16 | 8 | 1.007 | 0.993 | 1.008 | 0.999 |
| 16777216 | 16 | 15 | 0.928 | 1.075 | 0.923 | 1.077 |
| 16777216 | 16 | 31 | 1.002 | 1.004 | 0.997 | 1.000 |
| 16777216 | 16 | 63 | 0.987 | 0.995 | 0.982 | 0.991 |
| 16777216 | 16 | 4096 | 1.034 | 1.005 | 1.012 | 1.001 |
| 16777216 | 32 | 4 | 0.937 | 2.496 | 0.974 | 1.016 |
| 16777216 | 32 | 5 | 0.843 | 2.138 | 0.999 | 0.991 |
| 16777216 | 32 | 6 | 0.811 | 1.852 | 1.036 | 1.104 |
| 16777216 | 32 | 7 | 0.791 | 1.641 | 1.023 | 1.068 |
| 16777216 | 32 | 8 | 1.020 | 1.007 | 1.008 | 0.992 |
| 16777216 | 32 | 15 | 0.888 | 1.075 | 0.889 | 1.064 |
| 16777216 | 32 | 31 | 0.994 | 1.003 | 0.988 | 1.003 |
| 16777216 | 32 | 63 | 1.005 | 0.999 | 0.987 | 0.997 |
| 16777216 | 32 | 4096 | 1.013 | 1.005 | 1.010 | 0.997 |

Neither implementation is recommended for unconditional C++ promotion. Always masking standalone 4–7-key batches causes severe hash-plus-query regressions. The grouped control improves resident-filter batches 15 and 31, but regresses large-filter batch 15 and changes code generation enough to slow some standalone scalar batches by up to 10.4%. Batch 4096 remains close to parity. A separate dispatch experiment could isolate the scalar entry point or restrict the masked tail further; that is not implemented or measured here.

The C++ and Rust results differ in magnitude, so cross-language performance must not be inferred from identical SIMD semantics. No microarchitectural cause is established by this screen. Both failed versions, their exact source hashes, complete raw timing rows, and summaries are retained. The confirmed bitmap equality means FPR is unchanged.
