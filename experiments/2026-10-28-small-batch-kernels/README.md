# Small-batch kernel experiments

These isolated candidates preserve the existing bitmaps and hashes:

- `FastPatternEarlySmallBF` handles query batches of at most three keys directly
  in a scalar branch before the size-based SIMD dispatcher. All other paths
  retain the frozen FastPattern implementation.
- `Split64WideP32` broadcasts the low hash into eight 64-bit lanes whose high
  halves are zero, multiplies against eight zero-extended salts with 32-bit
  products, shifts those 64-bit products by 26, and generates bit masks directly.
  This removes the explicit 32-to-64-bit widening step from the source intrinsic
  chain. Fewer intrinsics do not imply lower latency on every workload.
- `Split64SingleP32` keeps the original masks and adds a direct single-query
  return. `Split64ShortHybridP32` adds the wide mask only for batches 2–15.
  The `NativeSplitBeforeBF`, `NativeSplitSingleBF`, and `NativeSplitAfterBF`
  snapshots repeat that comparison using the actual production class, including
  its portable and AVX2 fallbacks.

The snapshots and metadata are retained here. This experiment does not edit
production files; later integration can use the frozen reports below.
The shared comparison executable registers the before/after candidates alongside
pinned FastFilter SimdBlock, Fixed64, and Fixed16. Allocation and raw/prehashed
metrics follow the existing external adapter contract.

`check.cpp` validates complete before/after answers, allocation, every inserted
key, duplicate/same-line writes, and output guards at
capacities 1024/65539/1048579, requested 4/8/16 bits/key, and batches
1/2/3/4/7/8/15/16/31/4096. The native build passed, producing checksums
`5169750958418592356` (FastPattern) and `5453255702312952638` (Split64).

## Reproduce

```sh
cmake -S experiments/2026-10-28-small-batch-kernels -B build/small-batch-kernels \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build/small-batch-kernels -j2
build/small-batch-kernels/check
python3 experiments/2026-10-28-small-batch-kernels/run_speed.py \
  --output-dir build/small-batch-reproduction --cpu 3
```

CMake uses the pinned external dependency declarations. The recorded build reused
local source checkouts at those exact pinned revisions; their identities are
listed in each timing directory's metadata. Timings use one process, shuffled
filter order, matched workloads, CPU 3, and the same native compiler flags.
All candidates include hashing only in the explicitly named hashing metrics.

## Decisions and evidence

- [FastPattern early return](fast-pattern-early-report.md): retained. Fresh-seed
  single-query timings improve approximately 12–17% depending on the measured
  metric and bitmap size. Exact bitmap and complete answer checks pass scalar,
  AVX2, and AVX-512 sanitizer builds.
- Unconditional Split64 wide masks: rejected as a default. In the small bitmap
  screen they slow single prehashed lookups by approximately 11% and hashing plus
  lookup by approximately 7%, despite helping some batched cases.
- [Production Split64 short dispatcher](native-split-report.md): retained as the
  conservative candidate. It preserves the original mask for one key and for
  batches of at least 16, using wide masks only for batches 2–15. At the large
  bitmap, batch 31 has an approximately 2% hashing-plus-lookup regression in the
  final confirmation. The report includes the unchanged-mask control: most of
  the very large gains in short hashing-plus-lookup batches also occur with only
  the single-key branch, and cannot be attributed to one removed intrinsic.

Timing stages are `screen-small` (seed 42), `heldout-small` and `heldout-large`
(2053/4099), `short-grid` (104729), `hybrid-confirmation` (8191), and the final
actual-production `native-confirmation` (12289/65537). Every directory retains
raw CSV, commands, compiler flags, binary/source hashes, and source-change audit.
`native-confirmation-32bpk` repeats the final matrix at the larger actual budget.
The initial and hybrid adapter snapshots preserve the older registration state;
the current adapter adds the final production controls. The final comparison
checks unchanged answers and FPR, rather than estimating a new FPR target.

