# Fixed36 public nearby-geometry accuracy run

This separate runner is source preparation only. It uses the unchanged tested
native accuracy worker and cannot compile or rebuild a filter. Every point was
fixed before data:24 original PImpl geometries plus12 nearby odd geometries,
three families, two sizes, seed42, q22/hit50 and cal24. Each point receives one
fresh process and one complete build. Construction and query timing fields stay
NaN with zero trials. Wall-clock process duration is diagnostic only.

The24 original points must reproduce the committed old728 mixed/calibration
counts and complete-output/input checksums exactly. These are reproduction
controls, not new independent evidence. All12 new points remain in the report
regardless of their quality. Unsupported geometries remain explicit and cannot
be replaced. The interval/divisor, public hash, probes and APIs are unchanged.
Each point reports its actual logical/backing bytes and its own2^24-negative
denominator; no API or repeated-query sample pooling is permitted.

`run.py` requires the exact committed source, the complete committed caller
proof, live frozen binaries/dependencies, and an inherited exclusive socket0
flock with CPU2 affinity. It records each command before launch, both raw
streams, every result and the tuner-file fingerprint. It replays all36 raw
outputs and the exact command ledger before setting complete=true. Any failure
leaves complete=false and all evidence intact. No partial ranking is produced.

The post-run quality table is fixed to pointwise two-sided Wilson95 intervals
and1%,0.1%,0.01% upper-bound gates. The future narrative must retain every old
and new count, gate failure and unsupported point, and may compare their
paired quality at the two nearby caps. A difference does not decompose address
correlation from changed block count, and supports no speed conclusion. Any
later independent seed or throughput protocol requires a separate fixed plan.

After source review, commit and an explicit execution lease:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-vldb-nearby-geometry/accuracy/screening/run.py \
  --source-commit FULL_RUNNER_COMMIT --cpu 2 --lease socket0 --execute-accuracy
```

The output path is fixed to fresh `results-v1/`. The exact caller-proof commit is `14a5a1cb7d96d41abd62ce05e82dcb29b6a42353`;
the native binary hash is `4e67b8e0351f574004c0db485ba4883d128dd8906120d49b5b0eacaab781e930`.
The worker preflight never invokes this runner automatically.
