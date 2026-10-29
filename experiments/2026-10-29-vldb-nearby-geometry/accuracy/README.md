# Fixed nearby geometry accuracy pilot: source preparation

This is the next additive caller preparation after the completed 93-case
geometry proof. No caller compilation, full-occupancy calibration, or timing
has run here. The original geometry proof and all prior results remain frozen.

`worker.cpp` uses only the original public PImpl APIs: sector32/U1,
sector64/U1 and register64/U0. It reuses the frozen Stage3 raw-u32 workload and
complete build/no-false-negative/output/calibration checks. Every accepted
invocation has zero query repetitions. The public CLI rejects measurement
actions and positive repetition counts before construction. The only new
algorithm-independent choice is the exact constructor capacity from the
already-proved finite nearby rule. Public hash/probes/queries and compact
conversion stay unchanged; no private kernel replaces the artifact.

The fixed pilot contains 24 original geometries (three families × two sizes ×
four caps) and 12 nearby geometries (three families × two sizes × two caps).
Each uses one fresh process and one complete bitmap construction, seed42,
q=2^22, hit50 and exactly2^24 independent negative calibration keys. All
inserted keys are checked. The full mixed-output checksum and the exact input
stream checksums are retained. Three public query forms must produce identical
complete outputs; the untimed calibration additionally checks singleton/dense
parity. This is accuracy evidence only, with NaN timing columns and zero trials.

`selection.json` fixes the exact old geometry and old semantic expectations
from committed raw728, and the exact accepted nearby geometry from completed
raw93. The 24 original rows must reproduce their old seed42 counts and checksums;
that is a reproduction control, not a new independent sample. API or repeated
query forms never add calibration denominators. Every new row, failure or
unsupported point remains present. No observed outcome can select another
divisor or widen the one-percent window. Pointwise Wilson95 endpoints at1%,
0.1%, and0.01% will be reported without a speed conclusion or causal decomposition
between changed address correlation and changed block count.

Before the full pilot, a minimal native/ASan caller preflight is planned:
three families × two policies × two backends at the already-proved n=2^16 geometry, q=2^12 and cal=2^10,
plus old-worker parity for the original points and malformed/fault CLI guards.
It will link the already verified original archives and rebuild only this
small caller, against complete Boost1.83/GCC12.2. It does not rerun the 93-case
geometry suite or compile upstream. Its exact source guard, compiler-input
capture, fresh build/output paths and inherited socket lease must be reviewed
and committed before any compile. The full36 calibration needs a later tested
worker freeze and a separate authorized runner; it cannot auto-launch from
the preflight.

The geometry proof is committed as `11584813b8f300d0405c58d458bbf901c996468b`.
`nearby_accuracy_guard.py` binds every artifact in that proof, its original
source/archives, the frozen Stage3 shared caller and both old reference
binaries, and the deterministic36-row selection to exact committed bytes.
Actual compiler dependency capture must include the shared workload/checker
and forbids current production headers outside the frozen native snapshot.
Six offline synthetic guards check exact geometry, old counts, stream sizes,
NaN-only timing fields, physical compact scratch, row shape and Wilson bounds.
No filter is executed by those guards.

After source review, commit and an explicit socket0 lease, the bounded caller
preflight command is:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-vldb-nearby-geometry/accuracy/preflight.py \
  --source-commit FULL_PREPARATION_COMMIT --cpu 2 --lease socket0 \
  --build build/vldb-nearby-accuracy-caller-v1 \
  --output experiments/2026-10-29-vldb-nearby-geometry/accuracy/validation-v1
```

The normal and instrumented old workers are retained, not recompiled. Their
three original-policy rows per backend must match every field produced by the
new caller. The new six rows per backend must agree exactly, and their geometry
must match the completed93 proof. Twelve rejected/fault invocations cover
unknown API/policy, an unapproved nearby cap, a measurement action, positive
repeats, and corrupted dense output. The preflight cannot launch the future
full36 accuracy matrix.
