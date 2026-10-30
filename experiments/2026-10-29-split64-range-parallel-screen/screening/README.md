# Fixed142 T8 performance preparation

This additive driver implements the shared-query portion of the plan committed at `333759a`. It executes the unchanged native executable validated by V3, with the same25 registry and fixed142 geometry selection. It does not rebuild or change any filter, adapter, timer or executor. The completed preflight and its two preserved failures are described in `../PREFLIGHT_REPORT.md`; all515 local artifacts are bound by `../PREFLIGHT_ARCHIVE.json`.

The protocol is n=2^16/2^25, q=2^22, batch4096, 50%-pattern hits, seed42, six repetitions and 2^24 additional disjoint negative calibration keys. Each configuration is serially built from the whole insertion array. The132 unique grid points at ceilings16/24/32 and10 extra nonduplicate points from17 already-fixed external IDs produce142 rows in13 processes. Selection is fixed before performance; quality or timing cannot replace a selected point. Requested ceilings12/14/20/28 exist only for the prespecified extra geometries. All actual capacities were constructed and checked in preflight.

Eight physical cores are CPUs3,5,7,9,11,13,15,17, all on socket1/NUMA node1. Caller0 counts as one of the eight execution threads; only seven are spawned. The parent driver remains onCPU3 and must inherit an already-owned exclusive socket1 flock. Each child first widens its affinity with taskset, then applies numactl physical binding and `--membind=1`. The unchanged C++ main pins caller0 toCPU3 before allocating workloads or building any filter. Thus serial builds, direct serial controls and first-touch allocation occur onCPU3/node1; worker queries use all eight cores. Topology is checked by both Python and the frozen executable.

Every timed query repetition validates the complete dense output and guards against the canonical answer. First timed pure/hash builds and the final canonical filter check every inserted key. Pure prehashed and common-hash query modes remain separate; PageBloom is explicitly raw-byte-only, with unavailable pure metrics represented by NaN. Each row keeps direct serial controls, fresh-thread gated and full end-to-end costs, launch/join decomposition, all six trial vectors and min/max. Gated time still includes wake-up, completion synchronization and worker0 work; it is not a synchronization-free kernel time. End-to-end includes creation, affinity, synchronization, joins and executor temporary destruction. Serial build medians are separate and support no parallel-build claim.

The unchanged within-trial schedule is **fixed**, in this order: serial pure, serial hash, parallel pure, parallel hash. Six repetitions do not balance that order. Filter order is the frozen producer's exact seeded shuffle after filtering each case's initial25-name registry. Case groups run in ascending n/ceiling order. This single-seed training screen cannot establish a held-out or order-independent superiority claim.

Quality uses each geometry's independent calibration Wilson95 upper; the142 API rows contain92 family/geometry/size/seed calibration records. Equivalent public wrappers and the nativeRange/Fixed64 mapping must agree and reuse one denominator. They are never pooled, nor are timed mixed negatives pooled with calibration. Caps16/24/32 admit every selected smaller **actual backing** allocation. Pure/raw and gated/end-to-end winners are selected separately; external, production-native and project-experimental ownership remain distinct. Serial scaling uses the same row's serial control. All losses and quality failures remain visible. Older FourSector quality evidence is context only and never overrides this seed's pointwise gate.

The budget is adapter-reported backing allocation, including charged padding. It excludes object/allocator metadata, fixed stack storage and separately reported filter/harness/worker scratch. No RSS or total-memory claim follows. Original17 external IDs and allocation policy are unchanged.

`contract.py` rejects partial/duplicate/reordered cases, schema changes, geometry/capacity/scratch mismatch, malformed or raw-only trial fields, inconsistent decomposition and alias answers. `audit.py` rechecks recorded lease/affinity/topology/environment, exact command ownership, raw hashes, aggregate equality and every committed source/binary pin before later analysis. `freeze.json` binds the full preflight archive, new scripts/protocol and all46 validation/reference binaries through the preflight descriptor; it includes actual native compile evidence. Normalized paths never replace original consumed compiler paths in the evidence.

Only the thirteen offline corruption tests have run for this preparation; no extra BF/compiler execution was needed after the completed preflight. Performance is not authorized by this document. After root review and commit, the explicitly leased command is:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-split64-range-parallel-screen/screening/run.py \
  --source-commit REVIEWED_COMMIT --execute-frozen
```

The runner refuses an existing `screen/` directory, unsupported loader/allocator overrides, Python `-O`, a missing or merely-open/shared lock, the wrong driver affinity, changed committed artifacts or binaries. Failed raw outputs and commands are preserved. There is no automatic resume, tuning or post-result substitution.
