# Initial whole-array BlowChoc query-speed screen

Separate from the frozen accuracy archives. This screen retains native4 and all
eight BlowChoc choices1/2 × probes8/14 × random/distinct configurations. It uses
n2^16/2^25, requested8/16 (**actual16/32bits/key only**), q2^22, hit50%, input42,
construction113, batch4096 and calibration2^24. Intermediate exact-byte budgets
such as12/14bits/key are outside this first grid. No global fastest claim follows.

The unchanged frozen bridge/native library processes a complete query array per
prepared call. Its three independent contracts stay separate: prehashed,
common-hash fused per key, and common-hash staged through batch scratch. All six
permutations of these modes run once (six repetitions per mode), identically for
every candidate. Each phase writes a dense u32 vector and checks its complete
answers, guards and checksum outside timing. Python/FFI crossings occur once per
whole-array phase; original upstream hash/probe work remains inside.

This is **query-only**. Each candidate constructs one canonical prehashed bitmap
before queries and checks every inserted key. Allocation/insertion times are
unmeasured: JSON uses `null`, and CSV/report exports must show `NaN`/unavailable,
never a synthesized build rate. First-use factory/JIT duration is separate
metadata. Rows explicitly report `query_repeats=6` and `build_repeats=0`.
The two-choice construction cost is therefore not assessed by this
screen and must not be inferred from its query rankings.

Actual owning allocation includes upstream448B slack; the logical bitmap and
positions scratch16B(K8)/28B(K14) remain separate. Common hash scratch is32KiB for
every candidate. All actual-size construction hashes are prespecified. Complete
bitmap/answer oracles and earlier-factory rebuilds after later hash-global
overwrites precede actual construction. Warm-up and prior canonical bitmaps are
weakref-checked as released before the next candidate. The native .so and its
`b437791` native-header snapshot are identical to the previous bridge tracks.

`check.py` is correctness-only and never calls the timing branch. It compares
24 small-case rows directly with the frozen original bridge, validates16 bitmap
and hash-overwrite configurations, and rejects mislabeled/duplicate phase
samples, checksum errors, unaccounted memory and fabricated build metrics.

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python experiments/2026-10-29-blowchoc-throughput/check.py
```

Actual timing is disabled until `SOURCE_FREEZE.json`, protocol, runner and native
binary hash are reviewed and committed, followed by an explicit socket lease:

```sh
BF_SOCKET_LEASE=socket1-cpu3 flock /tmp/fastest-bf-socket1.lock taskset -c 3 benchmarks/blowchoc-external/.venv/bin/python experiments/2026-10-29-blowchoc-throughput/run_matrix.py --source-commit FULL_COMMIT --execute-frozen
```

The full matrix holds the lock; existing results are never overwritten. Every
source blob must match the named commit before and after timing. The initial
process is pinned to CPU3, but affinity does not impose an explicit NUMA memory
binding; allocation follows the host's current memory policy. The initial
speed data use training seeds42/113; any subsequent performance claim needs a
new prespecified held-out comparison. FPR confidence and payload caps constrain
each mode's native/external comparison independently; repeated streams or
different construction hashes must not be pooled into extra sample support.
