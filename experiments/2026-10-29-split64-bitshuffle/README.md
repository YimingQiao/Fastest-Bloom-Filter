# Split64 direct bit selection

Correctness and assembly preflight passed; no timing workloads or performance claim.

The existing Split64 query first constructs eight one-bit masks and then tests
those masks against the cache line. This candidate keeps exactly the same
positions and bitmap but uses AVX-512 BITALG to select those eight stored bits
directly. One output-mask bit per 64-bit sector is enabled; all eight must be set.
The hybrid variant preserves the original narrow/wide position-generation policy;
always-narrow and always-wide controls isolate the 32-to-64 conversion.
Insertion, allocation, prefetch distance, and batch dispatch remain unchanged.

Semantics follow the [official intrinsic documentation](https://doc.rust-lang.org/core/arch/x86_64/fn._mm512_mask_bitshuffle_epi64_mask.html)
and [Intel instruction reference](https://cdrdv2-public.intel.com/774492/325383-sdm-vol-2abcd.pdf).
This is an instruction-level hypothesis, not a novel probabilistic layout.

Before timing, validate full bitmap/query equality with the original and an
independent scalar oracle, native/scalar/sanitizer builds, and inspect actual
assembly. If compiler mask conversion cancels the saved variable shift or any
batch regresses, retain that evidence. No core header is edited.

## Preflight evidence

All eight Clang correctness modes pass the identical checksum
`3906731148184842256`: native, forced portable source path, AVX2 fallback, and
AVX2+AVX512F/BW/BITALG with VL/DQ disabled, each normal and ASan+UBSan. The explicit
minimum-BITALG target rejects a silent fallback at compile time. Disabling BW
also disables BITALG in Clang's target-feature closure; this archive makes no
claim for BITALG without BW. `feature-boundary.json` records the probe.

The independent byte oracle checks complete bitmaps and dense 0/1 answers,
inserted keys, collisions, duplicates, empty calls, offsets, tails and output
guards. The controlled bitmap tests prove all 8×64 possible sector positions
are covered: a single missing selected bit rejects even when every other bit
in the allocation is set. Input fixtures fill negatives and then guarded
positives in separate loops, avoiding the previously reproduced Clang23
predicated-gather fixture bug. No filter/query algorithm change was needed.

`unchanged-mapping-proof.json` verifies the original copy against the production
header and checks byte-identical mask generation, insertion, block mapping,
allocation initializer, prefetch and public batch dispatch. Only candidate query
bit selection differs. `freeze.json` hashes all source inputs and ten retained
binaries; repository-relative source copies are under `source-snapshot/`.
`validation.json` and the native/ASan logs record exact commands and outcomes.

`assembly/audit.json` retains all five compiled query kernels (FastPattern plus
original, hybrid, narrow and wide Split64). All three candidate policies emit
`vpshufbitqmb`; the original does not. The assembly limits the proposed mechanism:
Clang already transforms the original test into `vpsrlvq` on bitmap words followed
by `vptestnmq`/`kortestb`, rather than materializing left-shifted query masks.
The candidate uses unmasked `vpshufbitqmb`, then `kmovq`, a GPR mask and comparison.
The current hybrid wrapper also saves four callee-saved registers versus two in
the original. These extra operations/register pressure could offset the removed
vector operation. Full instruction listings and `assembly/interpretation.json`
are retained; no speed conclusion follows from instruction counting.

No benchmark workloads were run. Before any future timing, preserve this source
freeze and prespecify cases, include both raw and prehashed metrics, and retain
all original/hybrid/narrow/wide results. Reproduce the checks from repository root:

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-split64-bitshuffle/validate.py
flock /tmp/fastest-bf-socket1.lock taskset -c 3 python3 experiments/2026-10-29-split64-bitshuffle/audit_assembly.py
```

The comparison target's missing native include path was corrected before build.
All production headers remain unchanged.
