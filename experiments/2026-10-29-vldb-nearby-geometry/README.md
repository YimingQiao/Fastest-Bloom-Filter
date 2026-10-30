# Finite nearby MAGIC capacity: correctness preparation

The [accepted proposal](../2026-10-29-vldb-nearby-geometry-proposal.md) is frozen
at360c89f. This additive target implements its one fixed rule: the largest odd
divisor accepted unchanged by upstream next_cheap_magic within the top1% of
fitting block counts. All64-byte backing padding is charged. An empty finite
window produces an explicit unsupported row; there is no fallback or adaptive
extension. No planner, compiler, filter or calibration has run for this source.

Only public constructor size changes. The original pinned hash, address,
insertion, singleton and compact-batch algorithms stay unchanged. The checker
is an explicit patch from the passed Stage2 checker, reusing its independent
modulo oracle, complete bitmap comparisons across PImpl/dynamic/static APIs,
full dense outputs, exact-n compact scratch guards and all tail/offset fixtures.
New checks cover the finite odd window/maximality, known unsupported tiny window,
zero/null insertion and zero-valued backing padding. The bitmap digest covers
logical bytes; padding is checked separately and charged in backing_bytes.

The finite preflight has31 fresh-process cases per backend: all28 new cases
(seven U/family configurations ×two sizes ×12/24 caps), plus three existing
small24bpk MAGIC controls. Native, AVX2 and ASan/UBSan total93 cases. The three
controls must reproduce the old committed metadata, bitmap digest and output
digest exactly. All31 results must agree across backends, including unsupported
status. The old168-case proof remains unchanged and covers the original POW2
and MAGIC grid. Nine malformed CLI checks reject unsupported names/policies
without emitting geometry rows.

The fixture inserts65,536 keys into the requested actual geometry, including
large layouts; it is correctness evidence, not a full-occupancy FPR sample.
Every supported result records the public constructor's actual metadata and
both logical/backing bytes. The fresh-process Configure→construct→metadata→use
sequence is unchanged, and the user's tuner file must remain byte-identical.
The compact-to-dense conversion is used only for correctness here. There are no
query timers, throughput values or independent-negative calibration samples.

CMake links the three already verified GCC12.2/Boost1.83 original archives;
it never rebuilds the heavy upstream library. The driver pins the accepted
proposal, passed Stage2 proof, source closure and those archives, records actual
compiler dependencies/macros and refuses stale build/output directories. The
upstream pure-scalar public artifact remains unsupported. No modern Boost1.92
headers or objects enter this executable.

After review, exact source commit and an explicit CPU2 lease, the command is:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-vldb-nearby-geometry/preflight.py \
  --source-commit FULL_PREPARATION_COMMIT --cpu 2 --lease socket0 \
  --build build/vldb-nearby-geometry-v1 \
  --output experiments/2026-10-29-vldb-nearby-geometry/validation-v1
```

The separate36-row accuracy-only pilot remains a later operation:24 original
geometries plus12 new geometries, seed42 with unchanged raw-u32 streams,
q22/hit50 and cal24. It must first receive an exact geometry/worker freeze and
reviewed runner. No quality gate can select a different divisor or remove a
failed point. A changed FPR would not isolate how much is caused by address
correlation versus the changed block count, and supplies no timing conclusion.
