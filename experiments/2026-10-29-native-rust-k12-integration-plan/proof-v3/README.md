# Additive V3 dependency-identity repair and bounded resume

V1 and V2 remain immutable failed attempts. V1 stopped at Clippy's tautological test assertion; the separate native commit `3af9c6555bbd42b778c93075d1740e243ac9f11e` removes only that assertion. V2 completed both normal builds and Clippy, then stopped before tests or Bloom-filter execution because rustc normalized the binary target's hyphens to underscores in hashed dep-info.

V3 changes the collector by one exact rule: derive both Cargo's literal target name and its Rust crate identifier (`-` to `_`) from the validated structured package, manifest and target. Ambiguous identities are rejected. No path-existence fallback is used. The exact patch and alias/collision guards are retained.

The normal V2 test executable and caller are reused at their original paths and hashes. `NORMAL_REUSE_CLOSURE.json` records a read-only complete closure audit of all 11 actual dep-info files, exact build flags, package metadata and both executables, including the successful Clippy command. V3 verifies this preserved source/evidence again and repeats complete closure verification before any runtime. Normal compilation and Clippy are not repeated. Pending disable-AVX512 and ASan builds use fresh V3 targets and the immutable V2 caller source.

The bounded proof is unchanged: one normal full library test run, six K12-only tests in each other mode, and 12 exact native/reference public fixtures per mode (36 total). Parent/build affinity is CPU3; test and fixture execution explicitly uses physical CPUs 3,5,7,9,11,13,15 while the parent owns the socket1 exclusive flock. Actual pre-exec masks are recorded. Public pure/fused/batch machine-code spans are captured by exact symbol addresses from the reused normal caller; no speed or inlining conclusion is inferred before review.

Native source, caller semantics, geometries, worker counts, SIMD masks, public routing and hashes are unchanged. There are no performance workloads or new false-positive calibration samples. Every failure is retained under a fresh output directory. The original incomplete metadata is never rewritten.

Run after this source is committed:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 experiments/2026-10-29-native-rust-k12-integration-plan/proof-v3/validate.py --source-commit FULL_COMMIT
```
