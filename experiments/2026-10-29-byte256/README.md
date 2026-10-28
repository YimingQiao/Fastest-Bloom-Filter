# Byte256 probe experiment

Unpromoted experiment widening ByteSplit's signed-i16 multiplication/byte-shuffle
mask to a 32-byte bucket. Sixteen fixed salts include the original eight and eight
additional constants chosen before any accuracy or timing measurement. The new
group balances positive/negative multipliers for both source 16-bit words; unlike
the 128-bit mask, the high control bytes contribute at least eight probes (a zero source word adds
four more high-byte probes, so a zero low32 hash yields sixteen). Low
control bytes retain upstream sign-bit zeroing. No seeds tune the constants.

The hypothesis is that a larger block and roughly 16 probes can meet the 0.01% FPR
target at 32 actual bits/key while retaining the short SIMD dependency chain.
This is not established: the finite 32-bit mask source and correlated products may
produce materially higher FPR than an independent-probe calculation predicts.
Measure accuracy first and reject the design if it misses the stated band.

Bitmap payload follows the same strict-next-power-of-two sizing. The experiment
has scalar and AVX2 kernels, accepts prehashed u64s, and returns dense u32 answers.
It has no new concurrency API and is not included in production or prior results.
The mask construction derives from FastFilter Fixed16; the Apache license and
attribution are retained in `third_party/FastFilter` at the repository root.

## Result: rejected before timing

The fixed-salt candidate failed the preregistered 0.01% FPR target at actual 32 bits/key for both tested sizes. No salts were changed after accuracy was observed. No held-out confirmation or performance comparison was pursued. The shared calibration harness emits incidental timing columns; those columns are retained as raw evidence and are not performance claims.

| Keys | Actual bits/key | False positives / 16,777,216 independent negatives | FPR | One-sided 95% Wilson upper bound |
|---:|---:|---:|---:|---:|
| 65,536 | 16 | 107,661 | 0.641710% | 0.644924% |
| 65,536 | 32 | 2,490 | 0.014842% | 0.015339% |
| 1,048,576 | 16 | 104,313 | 0.621754% | 0.624919% |
| 1,048,576 | 32 | 2,494 | 0.014865% | 0.015363% |

All four workloads and nine filters per workload are retained in `initial/results.csv`; `initial/accuracy-summary.csv` contains all measured FPRs and bounds. Each row has 2^24 disjoint negative calibration probes, independently of the 2^12 timed query sample. Construction receives the full insertion set, batch 4096, one repetition, seed 42. Those short timed phases were used only to reuse the common correctness-checked harness. Actual payload allocation is reported per filter; no hidden memory allowance was added.

## Validation and provenance

Native AVX2 and portable scalar checks pass under GCC; both also pass Clang AddressSanitizer and UndefinedBehaviorSanitizer. Each executable reports checksum `11883093257913682570`. The independent oracle uses signed 64-bit multiplication and division rounded toward negative infinity, rather than the implementation's unsigned high-bit extraction. It covers 65,536 paired signed 16-bit source values, ten explicit boundary/address cases, all bitmap bytes after duplicate and colliding inserts, 11,880 tail/offset/size combinations, guard words, zero-length null calls, all inserted keys and query immutability. High-byte probes are verified to number 8, 12 or 16 according to whether zero, one or both source halves are zero.

`validation-commands.json` and six actual configure/build/test logs record the runs. `freeze.json` records the exact native binary, compiler, compile commands, revision and 34 source dependencies after correctness and before accuracy. `protocol.json` fixes the salts, initial seed, unused held-out seeds and eligibility rule before the first accuracy run. `accuracy.py` verifies source and binary hashes before and after each matrix, exact row names/counts, calibration counts and memory budget. No production files or previous benchmark binaries were changed. All heavy work used CPU2 with the socket0 lock after the primary confirmation released that socket.

Reproduce from the repository root with a fresh output directory:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 cmake -S experiments/2026-10-29-byte256 -B build/byte256-native -DFETCHCONTENT_BASE_DIR="$PWD/build/all-external-confirmation/_deps"
flock /tmp/fastest-bf-socket0.lock taskset -c 2 cmake --build build/byte256-native --parallel 1
flock /tmp/fastest-bf-socket0.lock taskset -c 2 ctest --test-dir build/byte256-native --output-on-failure
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-byte256/accuracy.py --mode initial --output experiments/2026-10-29-byte256/reproduction
```

The binary/source hashes are deliberately strict; reproducing with another compiler or changed source requires a new clearly named freeze and result series, rather than editing this archived freeze. Dependencies are pinned by `benchmarks/cpp-external/dependencies.cmake`. Local CSV attributes preserve exact bytes and logs are explicitly unignored.
