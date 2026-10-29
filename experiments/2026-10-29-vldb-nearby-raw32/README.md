# Nearby-capacity raw32 caller proof preparation

Source-only implementation of the reviewed160-row proposal at `a46dab6fc0bc9f18b7fa1f00174ce55c3a63d78c`. No compiler, filter, geometry planner or timing run has executed for this stage. The previous36 accuracy rows and93 geometry proof remain unchanged.

The registered20 aliases and ordering match that proposal:14 original/nearby public PImpl U shapes and six project controls. `worker.cpp` delegates every typed API to the exact existing Stage3 `RunObject` and `Query` sources; the new worker can support the future `--measure` protocol, but this preflight only issues `--check` with zero repeats. It does not contain or launch a160-row runner.

## What changed

- `PublicFilter` preserves the frozen nearby accuracy adapter's public constructor, hash, insertion, singleton, compact batch call and dense conversion. It adds U2/U4 registrations and a fixture-only const bitmap accessor. Fresh processes preserve Configure→construct→metadata→use→destroy; actual U is checked, never relabeled.
- The four production native controls are the unchanged Stage3 snapshot and `RawHash` definitions. Their real-n sizing stays8bpk at cap12 and16bpk at cap24.
- Optional production Range is copied from `81f40f16caa44586537d577f998c33fec4c22be8`. K12 is copied from the frozen C++ actual-caller proof `e150be33b95a22dca9b75175e6174b9555c82393`. They allocate exact whole-line12/24bpk and have separate owner labels. The best existing public `ContainsHash` is exposed through a trivial `ScalarContains` shim for the common raw singleton trait; public batch `Lookup` is unchanged.
- `derive.py` binds all immutable inputs and permits only namespace/include routing for K12. Its complete base/sizing/kernel closure changes the identifier `bloom_filters` to `nearby_k12`; expressions, masks and kernels remain byte-for-byte otherwise. The original sizing helper and production Range sizing helper are byte-identical. A separate reference copy of original K12 changes only that include path, allowing the original and namespace-isolated types to coexist without duplicate `RangeBytes` definitions.
- The two new raw wrappers use a derived copy of the exact existing `RawHash` template. Only the class identifier and a read-only fixture bitmap accessor are added; timed Insert/Prepare/Single/Dense and scratch methods are unchanged. The shared common Murmur64 hash remains inside each raw query. The generation record is `DERIVED.json`.

## Fixed correctness scope

Two backend builds, GCC12.2 native and native ASan+UBSan, reuse the existing verified original archives. Only `worker.cpp` and `check.cpp` compile; no original library source is rebuilt and no live production `include/` input is allowed. One complete Boost1.83 root is required.

- **80 small caller rows:** all20 aliases × caps12/24 × native/ASan, with n=65,536, q=4096, cal=1024, hit50, seed42. They retain complete all-inserted validation, singleton/dense agreement, boolean/guard checks and exact metadata/scratch. Native/ASan complete rows must match.
- **56 frozen-reference rows:** each backend compares22 original/native rows to the old Stage3 public worker, plus six nearby U1/register rows to the exact prior nearby accuracy worker. Only worker/API labels differ; all other serialized fields must match. No old timing is read or imported.
- **56 complete public bitmap payloads:**14 public aliases × two caps × two backends, using1,031 deterministic insertion values (including0, high-bit, UINT32_MAX and duplicates) and8,193 queries. Each payload retains every charged backing byte followed by every dense answer. U1/U2/U4 same-family/same-policy payloads compare byte-for-byte; cross-backend payloads do too. These are raw fixture data, not executable binaries.
- **16 native whole-bitmap oracle records:** Range/K12 × powers16/25 × caps12/24 × two backends. Each actual raw wrapper is compared against the original public prehashed class on every backing byte and every output. An independently written common hash expression verifies raw-u32 zero extension. Original prehashed insertions use single-key calls; raw insertion uses batches. Both ordinary and duplicate input states must agree. The large48/96MiB bitmaps contain1,031 fixture keys, not full occupancy or accuracy evidence.
- All fixture APIs additionally exercise input offsets0..7, tails0..131, lengths4095/4096/4097/4127 and all three query contracts. All output guards and input digests must survive. Actual scratch capacities are0/4/16384 bytes for public PImpl and0/8/32768 for native wrappers. The oracle separates its actual1,031-key hash payload from the advertised full-n construction scratch getter; neither is a total allocator/RSS measurement.
- **12 rejected/fault commands:** wrong API/cap/action/repeat count, forbidden large public payload fixture, and deliberate nonboolean output, across both backends. Rejections must emit no CSV row; deliberate faults must identify the full-output mismatch.
- Capture all actual typed Query disassembly from the native worker. Correctness completion does not mark this manual ASM review complete; inspect the public ContainsHash/PImpl calls, common hash and compact conversion inside the unchanged whole-array timing boundary before any performance lease.

No quality gate, speed observation, calibration extension or new geometry is selected from these fixtures. Exact hashes of all compiler inputs, tool commands, source snapshots, raw stdout/stderr and tested binaries remain in the proof. User tuner-file fingerprints must remain unchanged. Timing medians/trials are all unavailable; elapsed command durations are diagnostic only.

## Reproduction after explicit review, source commit and CPU2 lease

The proposal is committed, but this implementation is not yet authorized to compile. After approval, substitute the full source commit below. Build/output paths must be absent; all failures remain at those paths.

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 experiments/2026-10-29-vldb-nearby-raw32/preflight.py \
  --source-commit FULL_REVIEWED_COMMIT --cpu 2 --lease socket0 \
  --build build/vldb-nearby-raw32-v1 \
  --output experiments/2026-10-29-vldb-nearby-raw32/validation-v1 \
  > experiments/2026-10-29-vldb-nearby-raw32/preflight-v1.log 2>&1
```

The parent must inherit the actual advisory write flock descriptor; matching lock filenames alone are insufficient. The driver checks this before compile, before every command and at completion, and rejects dirty compiler/loader/sanitizer environment overrides. A separate frozen timing runner and source/binary proof are required after this stage passes.
