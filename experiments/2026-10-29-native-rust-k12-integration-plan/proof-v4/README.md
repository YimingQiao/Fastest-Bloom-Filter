# V4: exact nightly alias and no-build completion

V3's 13 commands passed: normal40 library tests, disabled6 K12 tests, and24 public parity fixtures passed; both ASan executables built. The collector then stopped before ASan execution because nightly Cargo's `build/package/hash/out/` dep-info also normalizes the Cargo target's hyphens to underscores. Original incomplete metadata and all binaries/logs remain sealed at18b51be438b02ad46353b3cdae43f0a8a91a1496.

The one-line collector repair permits precisely the literal target and its normalized Rust crate identifier inside the already-required exact structured package/hash/out path. It still requires the actual sibling executable to have the same SHA as the reported final binary. It never searches for a first existing path. Eight offline guards include wrong package, wrong stem, ambiguity and actual/final byte mismatch rejection. An initial source-preparation syntax typo in the new read-only audit (`else6`) was corrected before any freeze or runtime; no source/Bloom workload was involved.

`REUSE_CLOSURE.json` independently closes all three already-built profiles against the committed source and structured Cargo metadata, including all actual dep-info, six binaries and prior passed runtime masks/results. V4 performs no build, no normal/disabled test rerun, and no new Clippy run. It executes only the six pending ASan K12 tests and twelve ASan public parity fixtures, then captures exact symbol-address spans from the unchanged normal caller. Passed normal/disabled evidence remains attributed to V3, normal builds and Clippy to V2; original attempts remain incomplete.

The final combined proof covers40 normal +6 disabled +6 ASan tests,36 parity fixtures and actual native public pure/fused/batch codegen. Runtime uses physical CPUs3,5,7,9,11,13,15 while the CPU3 parent holds the socket1 exclusive flock. Native3af9, every caller/kernel/helper body, all geometries and all fixture inputs are unchanged. No throughput or FPR calibration is performed.

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 experiments/2026-10-29-native-rust-k12-integration-plan/proof-v4/validate.py --source-commit FULL_COMMIT
```
