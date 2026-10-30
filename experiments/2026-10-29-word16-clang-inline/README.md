# Prepared Clang inline61 Word16 experiment

**Source preparation only. No build, validation, assembly result or timing has
been run in this directory.** Both compute sockets were leased to other work at
preparation. Run commands only after an explicit lease, under the socket flock.

This separate directory copies the frozen direct-Boost inline60 harness and adds
one candidate, `Word16Split256Experiment`. The original inline60 directory and
all its binaries remain untouched. `parent-provenance.json` records exact source
hashes; `registry.expected.json` contains the original 60 names plus Word16.
`benchmark.cpp`, `inline_query.hpp`, the direct Boost shim and all four query
mode contracts are byte-identical copies. Registration and CMake additions are
explicitly identified in the provenance.

Word16's mask, salts, buckets, sizing and methods are unchanged from its successful
independent accuracy experiment. Only two include paths are redirected to the
same frozen native include tree used by the original inline60 candidates; the
complete change is `word16-include-only.patch`. This avoids mixing live and
frozen definitions. The original independent byte-level oracle is also copied
unchanged. No Rust or production port is included.

## Validation and code-generation gate

The prepared validation runner uses new build directories only:
`build/word16-clang-inline-{native,asan,full}`. The representative registry has
19 configurations, and the full registry has 61. Required checks are:

1. Native and scalar Word16 bitmaps/outputs, all halfwords, bounds, collisions,
   no false negatives, tails, guards and the identical oracle checksum
   `9063729662564169232`.
2. Shared inline-track native/ASan checks, all seven semantic workloads,
   both late-output fault targets, exact selection validation and complete
   four-trial phase balance. Full registration must match all 61 expected names.
3. Verify original inline60 source/binary hashes remain unchanged.
4. Archive all 122 raw/prehashed outer loops. Word16's two loops and Boost's 38
   loops must have no adapter calls. Retain genuine upstream FastFilter `Contain`
   boundaries and inspect actual Word16 packed multiply/shift/test code; the
   facade's forced-inline annotation alone is not evidence of nested inlining.

Prepared commands from the repository root, **not yet executed**:

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-word16-clang-inline/validate.py --cpu 3
flock /tmp/fastest-bf-socket1.lock taskset -c 3 python3 experiments/2026-10-29-word16-clang-inline/audit_assembly.py
```

A separate freeze after these checks must precede any timing. If approved, the
first inline61 screen should match the existing scalar-track context: n=2^16/2^25,
requested8/16, batch1, seed42, 50% hits, q=2^22, **eight** repeats for complete
four-phase balance, cal24, full-input construction, all 61 explicit names.
Use only within-binary comparisons. Independent-query compiler throughput and
the retained noinline batch1 track remain distinct columns; do not compare a
Clang inline61 timing with the prior GCC/CPU3 Word16 numbers as a port speedup.

## Proposed generic batch gate before held-out performance

The earlier GCC nine-config screen lacks FourSector and most modern baselines.
It only suggests a small-table batch31 hash+query opportunity. Before any
fresh-seed performance decision, prepare a **separate** generic shared-harness
Clang executable, retaining the existing batch API and adding FourSector to the
current nine configurations (10 exact names). Do not relax this inline harness's
batch1 restriction or alter its four-phase timing loop.

For initial generic validation, reuse the same frozen native headers and exact
Word16 mapping. Check full outputs/guards/calibration, compare batch1/31/4096
semantics, inspect Word16 and FourSector code generation, and retain all losses.
A bounded training screen would use n=2^16/2^25, requested8/16, batches31/4096,
seed42, q=2^22, five repeats, hit50, cal24 and full-input builds: eight cases,
80 rows. These are proposed parameters, not permission to run them.

The 10-config gate is a port/control check, not proof against the strongest
external panel. If it remains promising, include the full frozen modern external
registration in that **generic** same-process binary before prespecifying fresh
performance seeds. Compare at common actual memory ceilings and FPR bounds,
pool all measured allocations within each ceiling, and retain pure lookup and
hash+query separately. A raw-only improvement cannot erase a pure-query loss.
No native promotion or Rust port follows from the current GCC training evidence.
