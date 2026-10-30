# Prespecified BlowChoc accuracy screen

This uses the frozen whole-array bridge from `benchmarks/blowchoc-external`.
It measures accuracy and validates complete outputs; it makes no speed ranking.
All twelve configurations are fixed before results: four native controls and
BlowChoc choices1/2 × probes8/14 × random/distinct bit selection.

Four cases use n2^16/2^20, requested8/16 (actual16/32 bits/key), input seed42,
construction seed113, q2^20, hit50%, batch4096 and 2^24 independent negatives.
`protocol.json` prespecifies each actual payload, inserted/query/calibration raw
interval, all 32 BlowChoc construction hash sets, the source/binary pin and exact
compiler/JIT CPU settings. The native four controls remain the bridge's explicit
`b437791` snapshot. No hash seed is selected based on observed FPR.

Before accuracy in each case, all eight BlowChoc parameter sets—including K14—
pass independent full-bitmap/full-output oracle checks. After all factories have
replaced upstream's module hash names, every earlier factory must reproduce its
original exact bitmap and answers without another JIT signature. The accuracy
runner then reuses the frozen bridge driver: all inserted keys are checked in
every fresh build, all three input paths agree on complete dense answers,
allocation lifetimes remain disjoint, and the independent negative stream is
processed only after the ordinary query checks.

Each row reports actual backing bytes (including upstream448B slack), logical
bitmap, positions scratch2*K, common hash scratch, explicit hash strings, raw
FP counts and Wilson95% upper. No counts are pooled across configurations,
allocations or data sizes. Equal-seed calibration streams reused across bit
budgets are repeated streams, not independent evidence. This screen uses one
input/construction seed; any later held-out accuracy must use fresh seeds for
both before choosing configurations for a performance comparison.

Preparation requires only Python's standard library and does not run JIT/data:

```sh
python3 experiments/2026-10-29-blowchoc-accuracy/prepare.py --bridge-commit COMMITTED_BRIDGE_SHA
```

After source review and the explicit socket1 lease release:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python experiments/2026-10-29-blowchoc-accuracy/run_matrix.py
```

The entire matrix holds that lock. Existing results are never overwritten. The
runner checks every frozen bridge file, the native library and its own sources
before/after; output remains under this experiment, leaving the original bridge
freeze intact.
