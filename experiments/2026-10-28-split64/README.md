# Widened split-block experiment, 2026-10-28

`Split64P32` improves the measured 16M-key, all-miss lookup result over
Boost 1.92 `fast_multiblock64<8>` while retaining a measured FPR below 0.1%
at 16 actual bits/key. It is an experimental candidate, not a universal winner.

The construction adapts the public [Parquet split-block algorithm](https://parquet.apache.org/docs/file-format/bloomfilter/):
eight fixed multiply-shift salts generate one bit per sector. Here sectors are
64 bits, so a block occupies one 64-byte cache line and the shift is 26.
The upper 32 hash bits select a power-of-two block through masking. This differs
from Parquet's 32-bit sectors and range reduction, so it is not file-compatible.
AVX-512 computes all eight masks for one key, then loads and tests one line.
Inserts update keys sequentially, preserving same-block collisions. A scalar
fallback implements the same mapping. `P0`, `P16`, `P32`, and `P64` select the
number of future keys prefetched; all four produce identical answers.

## Accuracy

`accuracy.csv` pools seeds 42/43/44, each with 1,048,576 inserted keys and
16,777,216 disjoint negative queries. Entries below are **percent FPR**.

| Actual bits/key budget | Split64 | Boost Multi64K8 | FastPatternBF |
| ---: | ---: | ---: | ---: |
| 8 | 2.934152% | 2.932223% | 2.849354% |
| 16 | 0.091312% | 0.090305% | 0.202851% |
| 32 | 0.001693% | 0.001617% | 0.009193% |

Every inserted key passed the harness's false-negative check. Boost's counting
allocator reports one byte below each shared budget; the other filters exactly
use the budget. Requested 4/8/16 bits/key become actual 8/16/32 in this repository's
strict-next-power-of-two sizing rule. The CSV retains requested and actual sizes.

## Large-filter screen

`large-timing.csv`: 16,777,216 inserted keys, 32 MiB budget, 4,194,304 all-miss
queries, query batch 4096, one insertion batch, three timed repetitions per seed,
seeds 42/43/44. Values are median ns/key across the three per-seed medians.

| Filter | Prehashed query | Hash + query | Prehashed insert | Hash + insert |
| --- | ---: | ---: | ---: | ---: |
| Boost Multi64K8 | 5.041 | 4.671 | 4.464 | 5.468 |
| Split64P0 | 5.222 | 4.069 | 4.706 | 5.760 |
| Split64P16 | 4.363 | 3.861 | 4.346 | 5.363 |
| **Split64P32** | **4.222** | **3.847** | **4.153** | **5.157** |
| Split64P64 | 4.369 | 3.849 | 4.354 | 5.349 |
| FastPatternBF | 3.735 | 3.759 | 4.130 | 5.139 |

P32 gives a 1.19× query speedup and 1.21× hash-plus-query speedup over this Boost
variant in this screen. Its pooled FPR is 0.092761%; Boost's is 0.091632%.
FastPatternBF's 0.202529% exceeds the 0.1% ceiling at this memory budget.
Prefetch32 was selected using these results; it needs held-out seeds, batch
sizes, hit ratios and data sizes before a broader claim. The small accuracy
runs are not intended as a performance study.

All filters share `src/compare_benchmark.cpp`, compiler flags, seeded order,
source hashing, query data and verification. Timings were pinned to CPU 3;
other repository work ran on the machine, including a separate CPU 2 baseline
run. These measurements are development evidence, not an isolated machine run.
`metadata.json` records commands, source and executable SHA-256 values, compiler
and timestamp. `compile_commands.json` captures the build command.
The recorded harness is from commit `aae4e5c4b6e22330f07efbc39a07ea416df51c39`;
later harness changes require a fresh run rather than reusing these timings.

## Reproduce

```sh
python3 benchmarks/boost-external/fetch_boost.py
cmake -S experiments/2026-10-28-split64 -B build/split64 -DCMAKE_CXX_COMPILER=clang++
cmake --build build/split64 -j2
python3 experiments/2026-10-28-split64/run.py
```

`check.cpp` independently constructs the scalar bitmap and compares all four
variants at three budgets, including duplicate insertion, many keys in the
same block, query lengths 0–144, and offsets 0–7 with output sentinels.
Both AVX-512 ASan/UBSan and a baseline-ISA scalar build pass:

```sh
clang++ -std=c++17 -O1 -g -march=native -fsanitize=address,undefined -fno-omit-frame-pointer -Iinclude -Iexperiments/2026-10-28-split64 experiments/2026-10-28-split64/check.cpp -o build/split64/check-sanitize
build/split64/check-sanitize
clang++ -std=c++17 -O2 -Iinclude -Iexperiments/2026-10-28-split64 experiments/2026-10-28-split64/check.cpp -o build/split64/check-scalar
build/split64/check-scalar
```
