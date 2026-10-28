# Direct-address split-block prototypes

These are unpromoted experiments, not external baselines or a fastest-filter claim.
They share the repository's strict-next-power-of-two bitmap allocation and the
unchanged `src/compare_benchmark.cpp` timer/hash/calibration contract.

`ByteSplit128Experiment` adapts the exact signed-high-16-bit multiply and byte
shuffle mask from [FastFilter Fixed16](https://github.com/FastFilter/fastfilter_cpp/blob/7c5bf187d5096ccbcec6a16e02975d0af3328b01/src/bloom/simd-block-fixed-fpp.h).
The upstream Apache-2.0 license is retained as `FastFilter-LICENSE`, source hashes
are in `attribution.json`, and the header prominently lists modifications.
Typed 16-byte aligned buckets use `(hash >> 32) & (bucket_count - 1)` instead of
upstream multiply-high address reduction. The mask still has zero byte lanes
when a shuffle control has its sign bit set; those semantics are preserved.

`IndependentSplit32Experiment` uses eight disjoint 5-bit fields from hash bits
0..39, one bit per 32-bit sector. Bits 41..63 select the 32-byte bucket. The
maximum 256 MiB allocation needs at most 23 address bits, so address and probe
fields remain disjoint. The AVX2 kernel uses four qword shifts, dword duplication,
alternating 0/5-bit shifts, and variable one-bit shifts. Its scalar reference
accesses individual bytes and does not call the SIMD implementation.

`ByteSplit128SingleExperiment` and `IndependentSplit32SingleExperiment` are
controls that give the base lookup method a compile-time batch length of one
when the caller requests one key. All bitmap/query semantics remain identical;
this isolates address/mask cost from general-loop setup. Equivalent
`FastFilterFixed16SingleControl` and `FastFilterSimdBlockSingleControl` wrappers
give the unchanged upstream adapters the same shortcut, preventing a speed claim
that comes only from prototype adapter specialization.

Both prototypes have zero explicit temporary heap scratch. Bitmap accounting
reports actual vector capacity; checks assert capacity equals logical payload.
The aligned bucket types own their storage, and arbitrary key batches produce
one dense u32 result per query. There are no concurrent mutation APIs yet.

The comparison contains unchanged pinned FastFilter Fixed16, SimdBlock and
Fixed32 plus a class-renamed snapshot of native Split64 (`split64_frozen.h`).
Correctness and independent FPR must pass before any speed claim. Runtime feature
dispatch is not implemented in these isolated headers: the experiment is built
with the common host ISA for every row, and a separate scalar correctness target
turns SIMD off. None of these prototypes are promoted to native library APIs.

## Correctness and accuracy

Clang 23 native and forced-scalar CTest targets each pass; ASan+UBSan versions
also pass. `validation.json` records the test commands and the initial query
fixture correction. Checks compare every bitmap byte and query answer against
an independent scalar reference, verify all inserted keys and duplicate
idempotence, and cover empty inputs, capacities, overflow rejection, batch tails
0..131, four input offsets, and output guards. No kernel change was needed after
the initial implementation.

The accuracy screen uses 2^24 disjoint absent calibration queries per row, outside
all timing phases, at n=2^16 and 2^20. The development seed is 42; heldout seeds
731 and 8675309 were not used to tune the mapping. Every row has the same bitmap
bytes within a scenario and uses the same common 64-bit hash stream. The complete
rows are in `accuracy-screen/` and `accuracy-heldout/`; only accuracy/accounting
columns are retained, so these runs make no performance claims.

| Implementation | Actual bpk | Pooled heldout FPR | Largest per-case Wilson 95% upper |
|---|---:|---:|---:|
| ByteSplit128 | 16 | 0.55447% | 0.56720% |
| FastFilter Fixed16 | 16 | 0.55010% | 0.56036% |
| ByteSplit128 | 32 | 0.05704% | 0.05895% |
| FastFilter Fixed16 | 32 | 0.05611% | 0.05808% |
| IndependentSplit32 | 16 | 0.13121% | 0.13456% |
| FastFilter SimdBlock | 16 | 0.13015% | 0.13326% |
| IndependentSplit32 | 32 | 0.00358% | 0.00421% |
| FastFilter SimdBlock | 32 | 0.00356% | 0.00397% |

Thus ByteSplit128 qualifies for the 1% / 16-bpk and 0.1% / 32-bpk comparisons,
but not 0.01%. IndependentSplit32 qualifies for 1% / 16-bpk and 0.01% / 32-bpk,
but fails 0.1% at 16 bpk. The native Split64 reference passes 0.1% at 16 bpk;
these prototypes do not replace that quality tier.

## Reproduction

From the repository root (the dependency URLs and hashes are pinned in the shared
CMake dependency file):

```sh
cmake -S experiments/2026-10-29-direct-split -B build/direct-split -DCMAKE_CXX_COMPILER=clang++
taskset -c 3 cmake --build build/direct-split --parallel 1
taskset -c 3 ctest --test-dir build/direct-split --output-on-failure
python3 experiments/2026-10-29-direct-split/check_controls.py build/direct-split/compare_benchmark
python3 experiments/2026-10-29-direct-split/run.py --mode accuracy --output /tmp/direct-split-accuracy --key-powers 16,20 --seeds 731,8675309 --calibration-power 24
```

Use a separate build directory with `-DBF_SANITIZERS=ON` for ASan/UBSan; build only
`check` and `check_scalar` for correctness. `check_controls.py` validates four
original/shortcut pairs across 24 mixed-hit/batch cases, including complete
checksum and independent calibration equality. Performance runs require an idle
socket, CPU pinning, and a new output directory; `run.py` records full commands,
compiler, CPU, binary/source hashes, common compile flags and actual allocation.
The original filter loops and the explicit single-key shortcuts are reported as
separate rows, never relabeled as a new upstream implementation.

## Frozen single-key confirmation

The frozen `heldout/` matrix uses CPU 3 (socket 1), Clang 23, the common native ISA,
2^22 timed queries, seven repetitions, 50% hits, seeds 2053/4099 and 2^24 independent
negative calibration queries per row. It covers n=2^16 and 2^24, actual 16/32 bpk,
and batch 1. No source changed during the 64-row run. Both prototypes passed their
stated quality gates in every case. Candidate selection was fixed from the earlier
seed-42 screen; the comparison then conservatively selects the fastest qualifying
baseline/control separately for each metric/case.

| Candidate / quality gate | Keys | Actual bpk | Hash + query speedup | Prehashed speedup |
|---|---:|---:|---:|---:|
| ByteSingle / 1% | 65,536 | 16 | 1.080x | 1.066x |
| ByteSingle / 0.1% | 65,536 | 32 | 1.084x | 1.075x |
| ByteSingle / 1% | 16,777,216 | 16 | 1.046x | 1.055x |
| ByteSingle / 0.1% | 16,777,216 | 32 | 1.045x | 1.029x |
| IndependentSingle / 0.01% | 65,536 | 32 | 1.029x | 1.004x |
| IndependentSingle / 0.01% | 16,777,216 | 32 | 1.042x | 1.013x |

These are medians of paired seed ratios, not confidence intervals or universal
wins. IndependentSplit32's strict-tier prehashed improvement is near parity. At
1%/16 bpk it does not beat Fixed16's best prehashed path in the small case. The
generic prototypes without the single-key shortcut lost in the initial screen.
Therefore the observed gains combine layout/address choices and dispatch/code
generation; they are not evidence that address arithmetic alone explains them.

The baseline shortcut results also matter: Fixed16's explicit n=1 path improves
prehashed queries but consistently worsens hash-plus-query, and SimdBlock's
shortcut has mixed effects. Both versions are retained. `heldout/summary.json`
contains each selected rival, quality threshold, timing and ratio; it never gives
a weaker baseline path priority merely because it makes the candidate look better.
All paired external shortcut/base checksum and calibration counts match.

This archive is frozen before comparison against the newest native layouts and
all eight RocksDB rows; those follow-up comparisons belong in a separate directory.
No production integration or strongest-baseline claim is justified by this matrix
alone. `FREEZE.json` identifies the exact source/data files and executable digest.
