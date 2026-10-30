# Dictionary-free two-sector masks: rejected, 2026-10-29

These scalar mask families reduce some table-lookup latency, but the selected
asymmetric-pair family is **not a new performance winner**. Fresh-seed confirmation
shows FastFilter's pinned Fixed32 filter using the same 16 actual bits/key has
both lower FPR (~0.132% versus ~0.349%) and faster prehashed/hash-plus-query results
in every measured batch1/3/8/4096 scenario. No core code or public layout changed.

## Construction

All candidates keep FastPattern's two-word addresses: `first = hi32 & word_mask`
and `second = first ^ (8 + ((lo32 >> 20) & 7))`. The two masks use disjoint ten-bit
fields `lo32 & 1023` and `(lo32 >> 10) & 1023`. They differ only in mask generation.
Let `R(x,r)` denote a 32-bit left rotation and `c` the ten-bit mask code.

| Family | Mask construction | Unique masks |
| --- | --- | ---: |
| DenseTable32 | Native 32-entry dense dictionary, rotated by `c>>5` | 1024 |
| PeriodicAllowCollision | `R(0x10001,c&15) \| R(0x10001,(c>>4)&15)` | 136 |
| PeriodicCrossHalf | `a=c&15`, `b=a^(8+((c>>4)&7))`; paired16 masks at a/b | 64 |
| PeriodicDistinctModulo | `a=c&15`, `b=(a+1+((c>>4)%15))&15`; paired16 masks at a/b | 120 |
| AdjacentPairs16 | `R(3 \| (3 << (2+((c>>5)&15))), c&31)` | 464 |
| AsymmetricPairs16 | `R(3 \| (5 << (2+((c>>5)&15))), c&31)` | 512 |
| NonperiodicPair8 | `R(0x10001,c&31) \| R(0x2001,(c&31)+8+((c>>5)&7))` | 256 |
| NonperiodicPair4 | Same as Pair8 with offset4 instead of8 | 256 |
| TriadOddSingleton | `R(0x10101,c&31) \| R(1,(c&31)+1+2*((c>>5)&15))` | 512 |

The three paired16 families have period16 and therefore only16 independent bit
positions per word. AllowCollision sometimes sets only two bits; every other
candidate sets exactly four. `mask-enumeration.csv` exhaustively checks all1024
codes, including bit counts and period16 symmetry. These are isolated generated
mask experiments, not new public API or novelty claims.

## Accuracy gate

Key counts65,536 and1,048,576; actual16/32 bits/key; fresh seeds195023/1048583/2900017;
**2^24 disjoint negative queries per case**. Each inserted key is checked. The
scalar DenseTable32 reference is compared against native FastPattern for every
query output. All108 rows pass without false negatives. The native constructor
receives requested8/16 so its strict-next-power-of-two allocation matches the
candidate's actual16/32 bits/key exactly.

Observed FPR at1,048,576 keys, pooled over three seeds (50,331,648 negatives):

| Family | 16 actual bits/key | 32 actual bits/key |
| --- | ---: | ---: |
| DenseTable32 | 0.203129% | 0.009131% |
| PeriodicAllowCollision | 3.179695% | 0.490922% |
| PeriodicCrossHalf | 3.368576% | 0.524809% |
| PeriodicDistinctModulo | 2.978367% | 0.404179% |
| AdjacentPairs16 | 0.679197% | 0.062166% |
| AsymmetricPairs16 | 0.349424% | 0.024470% |
| NonperiodicPair8 | 0.518767% | 0.047133% |
| NonperiodicPair4 | 0.520790% | 0.047412% |
| TriadOddSingleton | 0.726368% | 0.064635% |

Results at65,536 keys are similar and retained in full. `accuracy-summary.csv`
includes one-sided95% Wilson upper bounds. The periodic families fail the1%
ceiling at16bits/key and were not timed. The five remaining candidates meet1%
at16bits/key, but none meets0.01% at32bits/key; DenseTable32 meets that stricter
ceiling for both tested sizes.

An ASan/UBSan smoke covers all nine families and native-reference equality;
`sanitizer-smoke.csv` retains its output. There is no separate saved sanitizer
console log; the compile/run exited successfully.

## Training and fresh-seed confirmation

Training uses one shared `src/compare_benchmark.cpp` executable with native
FastPattern, an exact DenseTable scalar control, the five qualifying families,
and pinned FastFilterFixed16. Its native FastPattern header predates the later
early scalar return: `fast_pattern_before_early.h` preserves that version, and
`adapters-training.hpp` matches the recorded adapter hash. The clean training
results are in `timing-screen/`. An earlier possibly overlapping run is retained
in `timing-screen-contended/` and excluded from selection and reported conclusions.

AsymmetricPairs was selected for its better accuracy than the other table-free
families at essentially the same speed as adjacent pairs. Confirmation rebuilds
against **current FastPattern with the early scalar return**, and adds pinned
FastFilterFixed32. It uses new seeds820109/1760881/3670013, actual16 bits/key,
50% hits,2^22 timed queries, five repetitions, batches1/3/8/4096, one insertion
batch, and2^22 separate negative calibration queries after timing. Runs are serial
and pinned to CPU3. The dense scalar control and native FastPattern have matching query checksums
and calibration counts.

Median hash-plus-query ns/key across the three fresh seeds:

| Keys | Batch | Current FastPattern | Asymmetric pairs | Fixed16 | Fixed32 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 65,536 | 1 | 5.579 | 4.972 | 4.275 | 4.541 |
| 65,536 | 3 | 3.971 | 3.727 | 2.827 | 3.005 |
| 65,536 | 8 | 3.352 | 3.737 | 2.374 | 3.109 |
| 65,536 | 4096 | 1.107 | 2.218 | 1.560 | 1.785 |
| 1,048,576 | 1 | 10.498 | 9.113 | 8.379 | 8.522 |
| 1,048,576 | 3 | 7.887 | 6.393 | 5.744 | 5.855 |
| 1,048,576 | 8 | 8.133 | 4.661 | 3.850 | 4.409 |
| 1,048,576 | 4096 | 1.867 | 3.755 | 3.019 | 2.967 |

Confirmation calibration (deduplicated across batch sizes) puts Fixed32 around
0.132% FPR, Fixed16 around0.55%, and asymmetric pairs around0.349%. Thus Fixed32
also defeats the candidate on accuracy. Native bulk SIMD remains much faster
than the candidate's scalar loop at4096. This experiment supports rejecting
these masks for promotion; table removal alone does not close the modern
single-key baseline gap.

All raw rows/commands/source hashes/binary hashes are retained. `upstreams.json`
pins FastFilter to `7c5bf187d5096ccbcec6a16e02975d0af3328b01`. Static bitmap size
excludes object fields and allocator metadata, consistently across the shared
harness. These measurements cover one machine and the listed workload matrix.

## Reproduction

```sh
clang++ -std=c++17 -O3 -march=native -fno-strict-aliasing -Iinclude experiments/2026-10-29-dictionary-free/accuracy.cpp -o build/dictionary-free/accuracy
python3 experiments/2026-10-29-dictionary-free/run.py
cmake -S experiments/2026-10-29-dictionary-free -B build/dictionary-free -DCMAKE_CXX_COMPILER=clang++
cmake --build build/dictionary-free -j1
```

The timing scripts require their output directories not to exist; preserve or
move the archived results before a new run. `time_screen.py` is the training grid;
`confirm.py` uses the fresh-seed confirmation grid and current native baseline.
To reconstruct the original training binary, use the frozen training adapter and
pre-early-return header, not the current core header. `compile_commands_training.json`
records the original build command; external source trees can be supplied with
CMake's `FETCHCONTENT_SOURCE_DIR_FASTFILTER/PAGEBLOOM` variables to reuse pinned
local downloads. No performance run should overlap other work on the chosen core.
