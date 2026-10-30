This additive driver measures the unchanged native public APIs already validated
by the focused C++/Rust normal/ASan preflight. The measured sources remain at
`5fd487fe3381ce05be2ba823a6137107f4108854`; completed preflight artifacts are pinned
to `a35ed9af797b78f78f1a88cad731cd7f0152d55c`. It reuses the two exact normal
executables in `COMPILED_FREEZE.json`, without rebuilding or changing any filter.

The fixed grid is 2 sizes × 3 capacities × 3 core budgets × 2 languages:
36 commands and 60 rows. Each case runs C++ then Rust, in n/capacity/T order.
Split64 uses actual16/32 bpk; Range uses actual16/24/32. No duplicate Split24
alias is measured. Four balanced build orders and alternating serial/parallel
query orders are retained inside each row. All build trials precede queries;
the case and language orders remain fixed. This is an initial seed42 screen,
not a held-out significance test or a cross-language timing comparison.

All six metrics are prehashed64 native public-API intervals. Insert-only and
allocate+insert use separate fresh objects; neither is reconstructed by adding
measurements. Public partitioning, scratch allocations, and thread start/join
are included. Destruction and full output validation stay outside clocks.
Query calls receive the whole array and include fresh thread costs. They do not
use the prior external4096-batch executor and have no gated or hash-inclusive
column. Compare each language only with its own same-row serial controls.

The driver stays onCPU3 under an inherited exclusive socket1 flock. Each child
widens affinity with taskset before numactl binds node1 memory. The unchanged
harness pins serial work toCPU3 and expands the allowed mask before parallel
calls; expansion/restoration is outside timers. Workers inherit firstT physical
cores and may migrate or colocate within them; individual worker pinning is not
claimed. C++ uses caller+W−1 workers. Rust uses W workers+coordinator whenW>1;
the caller shares the sameT core budget, and W1 uses direct fallback. Insert-only
allocation happens onCPU3; inclusive allocation happens after expansion.

Every raw row is checked against source-derived filtered shuffle order, exact
geometry, effective workers, language-specific scratch, all six trial vectors,
and the prescribed phase/output contract before aggregation. Full arrays are
validated by the executable on every trial. Cross-T/language output checksum,
FP/calibration counts, and allocation must match. Calibration is disjoint from
insert/query inputs. Its repeated stream is one denominator per family, geometry,
size and seed: ten records per language, retained separately with no pooling.
This stage does not select an overall external leader or hide any slowdowns.

`source_guard.py` verifies the committed local archive, immutable successful
preflight,442 actual compiler inputs and all four checked executables before
and after the matrix. Runtime and offline checks validate exact parent affinity,
eight unique socket1/node1 cores, inherited WRITE flock and environment.
`audit.py` checks all36 exact commands, raw hashes, full ordered aggregate and
completed metadata before any interpretation. Failed outcomes remain in place;
the runner refuses an existing screen directory, including a dangling symlink.

After review and commit of `screening/freeze.json`, an explicitly assigned lease
may execute the entire matrix with:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-split64-range-native-scaling/screening/run.py \
  --source-commit REVIEWED_FULL_COMMIT --execute-frozen
```

No formal performance was run while preparing this driver. The source-only
guard tests use synthetic rows and never execute a Bloom filter or compiler.
