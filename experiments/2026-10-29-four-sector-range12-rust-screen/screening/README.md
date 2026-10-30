# Fixed108 public Rust K12 execution

This additive runner executes the immutable [108-row proposal](../README.md)
using the actual public21-API caller proved in
[`a2d6f832`](../caller-proof/REPORT.md), normal executable SHA256
`dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e`.
There is no rebuild, constructor search, K/hint change or alternate private
kernel. In particular, each visible K12 singleton still calls the outlined
scalar helper; this cost belongs to the measured public implementation.

All36 commands,108 rows, three seeds, q22/cal26, eight balanced query repetitions,
full-input insertion and all selected controls are unchanged. Every configuration
runs regardless of its quality or latency. The main cap24 comparison is within
each three-API process; cap32 secondary views also admit24 allocations and compare
extra32 geometries from a different process. The size panels retain the complete
training-derived leader union at every batch1/31/4096. No claim covers unmeasured
fresh K values, all libraries or all workloads.

The runner holds one actual inherited exclusive socket1 flock and pins CPU3 for
the complete matrix. It sets no NUMA memory policy. CPU/host/environment and exact
source/binary/preflight/initial-selection identities are verified before and after;
every case rechecks the actual lock and executable. Exact source-derived row order,
geometry, four-mode phase order, every query trial/median/min/max, existing dense
output checks, and all four original serial build boundaries remain in force.
The build phases keep their original fixed order and only published medians;
no balanced-build or unrecorded dispersion claim is added.

Raw stdout/stderr are written before validation. An atomic versioned write keeps
`cases` as an ordered list; distinct `case_count`/`row_count` fields cannot overwrite
it. Failed or interrupted attempts remain `complete=false`; there is no automatic
replay/resume or partial ranking. Final audit replays all exact commands/raw rows
and compares the entire CSV aggregate.36 API/size/bytes/seed quality records reuse
batch results only after complete semantic equality;12 all-three-seed gates use
the worst separate95% Wilson endpoint, never pooled denominators or repeated modes.
No retrospective sample extension is allowed.

Formal execution is authorized only after the source freeze is reviewed and
committed. The fixed initial proposal and passed caller evidence remain immutable.

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 \
  taskset -c 3 python3 \
  experiments/2026-10-29-four-sector-range12-rust-screen/screening/run.py \
  --source-commit FULL_COMMITTED_EXECUTION_REVISION
```
