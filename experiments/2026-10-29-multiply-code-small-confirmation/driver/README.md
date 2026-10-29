# Additive execution contract

The seven initial proposal artifacts remain byte-identical to commit
`77fd38ef640caa6dbb257338896057a20e00de37`. This directory adds validation and
execution only. It executes the existing 76-registration binary compiled at
`9e4362f1068d37d134ef8447a44146b52c1edc9f`; it contains no alternative filter,
mask, query timer, allocation policy, compiler command or parameter search.

The initial 18 cases/144 rows, eight geometries, six selected seeds, 31-entry
source-only seed ledger, alternating six-phase schedule and case rotations are
checked against their immutable source. The full 1016 planner and unchanged
source-derived 76 registry anchor each geometry and raw order. The initial 7,
all compiled parent archive entries, 321 consumed source/dependency hashes and
39 retained executable hashes are checked; manifests are checked against their
Git blobs before their descriptors are trusted. The final additive freeze must
also be committed before execution. The initial input hashes include the70-row
screen that was subsequently sealed at evidence commit
`0c8088f6316aa5933625fe278d7c21030896ed75`; those bytes are checked against that
commit, without claiming they were already committed with the initial proposal.

The coordinator assigns CPU2/socket0 or CPU3/socket1 explicitly at execution.
This is a single-CPU, same-process comparison within each case. The runner
requires exactly that CPU affinity, matching `BF_SOCKET_LEASE`, and an inherited
descriptor already carrying an exclusive kernel `flock` for that socket. A
matching filename or an unrelated lock held by another process is insufficient.
The whole 18-case matrix retains the lock. Only CPU affinity is set; no explicit
NUMA memory policy is claimed. Comparisons must not combine timings from
different CPU leases or from older screens.

After review, offline guard tests and freeze, the coordinator commits the
additive artifacts and supplies the exact 40-character source commit and lease.
For an explicitly assigned CPU3 lease, the invocation is:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 experiments/2026-10-29-multiply-code-small-confirmation/driver/run.py --cpu 3 --source-commit COMMITTED_SHA
```

The runner refuses an existing output directory. Failed attempts retain command,
return code and exact stdout/stderr; there is no silent resume or case replacement.
Python `-O` is rejected before any work. Each row must match exact budget and
probe metadata, all six timing trials and their median/min/max, source-derived
row/phase order, full output checksum and calibration. The frozen producer
already validates every dense timed output outside its timer. All 144 rows are
required before final quality output; 48 API/seed records collapse to 36 distinct
mapping/seed records across known API aliases and reused batches, without adding
their negative counts together. Every mapping must satisfy all six two-sided95%
Wilson upper endpoints for robust eligibility. FourSector16 stays a historical
failure diagnostic even if it passes every fresh endpoint.
Here, historical failure means that an observed Wilson upper endpoint exceeded
0.1%. It does not prove the true FPR is above0.1% or permanently disqualify the
algorithm. The diagnostic exclusion is the fixed rule for this confirmation.

Before this confirmation starts, a separate fixed higher-resolution accuracy
audit of the two formerly failing FourSector constructions reproduced the old
prefix and measured117,440,512 new disjoint negatives per construction. Both new
Wilson upper endpoints pass0.1%. Its source is
[`experiments/2026-10-29-four-sector-quality-resolution/RESULTS.md`](../../2026-10-29-four-sector-quality-resolution/RESULTS.md), with source frozen at
`17f37f8b55baabb1d741d72d872f6b6e5074fc87`. This new evidence remains separate
from the144 workload and must not be erased by its historical diagnostic rule.
The output's `all_fresh_seeds_pass` independently includes all eight APIs.
The **main competitive ranking must include every API for which that field is
true, including FourSector**; `main_competitive_eligible` expresses that policy.
Report per-seed current eligibility and the original restricted comparison
alongside it. `robust_eligible` labels only the preregistered restricted set.
A win in that restricted set cannot establish an overall win that excludes
FourSector or be described as beating the strongest eligible rival. Report
every fresh FourSector timing and gate result, together with the separate
precision audit; do not silently change the frozen restricted rule or claim
proven true FPR above the target from the old upper endpoint.
`policy-context.json` pins the separately committed report and raw evidence;
their samples and timings are never added to the144 results.

`audit.py` independently reconstructs every exact command and raw case file,
ordered aggregate row, trial vector, source pin and quality result. A raw manifest
preserves all stdout/stderr bytes. Future analysis must keep both query contracts
separate; all candidate/rival pairs, individual trials, per-seed losses and both
first/last order strata remain reportable. It must show current-seed qualification
separately from the across-seed robust gate and retain FourSector as diagnostic.
Three batches reuse each quality sample; repeated samples must never be pooled.
Passing these conditioned seeds is not a universal error-rate guarantee.

No workload execution is authorized by this file or by `freeze.py`. Timing starts
only after coordinator review/commit and an explicit socket lease.
