# Actual public Rust K12 caller

This is a minimal additive caller for the already fixed [108-row proposal](../README.md).
No new kernel, probe count, routing, scheduler or annotation is introduced. The
original20 public adapters, query/build timers, complete-output validation,
workload and phase helpers are derived from committed `571186b420bf7e5fc08269ed4a65feab42ac8400`.
Only the isolated K12 public adapter, constructor geometry and21st registration
are added. The package name and two frozen local dependency paths change;
all external dependency versions/revisions are unchanged. `derive.py` proves
the exact delta and the complete timed body equality.

The K12 crate is the exact serial/parallel source already proved in
[`645f397`](../../2026-10-29-four-sector-range12-rust-port/PREFLIGHT_REPORT.md).
Its full kernel/backend/parallel matrix is not repeated. This stage verifies
the actual linked caller, reusing both existing four-mode corruption/phase tests
and adding one adapter test for actual allocation, public singleton/bulk parity,
duplicates, tails and complete output guards. Both native and ASan build modes
run these three focused tests. Generic ASan flags intentionally match the old
caller proof; production/runtime backend selection remains unmodified.

The bounded tiny CLI grid uses only old seed42, n1024, q4096, calibration4096,
4balanced repetitions and full-input insertion. At budget24 it tests the three
primary APIs for batch1/31/4096; at budget32 the four retained small-size APIs;
one budget16/batch31 call executes all21 names. This is42 rows per mode (84total),
with38 old-reference rows from the exact immutable `f499f5d…` executable and76
retained semantic comparisons across the two modes. The existing timer guards
check every timed dense output, not merely an aggregate checksum. Twelve bad
CLI calls must fail before any CSV. None of these tiny timings is used to choose
an algorithm or a formal configuration; no held-out seed is touched.

Builds are `--locked --offline`, single-job, under the inherited exclusive
socket1 flock and CPU3. Cargo first emits structured metadata, no-run tests and
the actual standalone binary. Before any test/filter executes, every actual
`.d` input is resolved against the structured package/manifest/target identity;
repository inputs must match committed snapshots and external inputs must match
the old complete pinned dependency trees. The proven collector retains stable
and nightly artifact handling. Its only adaptation accepts a metadata-verified
registry/git package rather than assuming every package is local. Relative
paths are never assigned to the repository or first existing file as a fallback.
Unfrozen Cargo configuration, encoded flags, wrappers and loader overrides are
rejected, and target/output paths must be fresh (including dangling symlinks).
All logs, failed attempts, source/dependency hashes and exact artifact paths are
retained. An actual linked K12 public-query symbol capture follows for read-only
codegen review; no inlining or speed outcome is presumed.

The previously completed proposal and native proof are immutable. Formal108
execution requires this caller's correctness and ASM review, a newly frozen
performance binary and a separate reviewed runner. This caller stage makes no
quality, speed, strongest-baseline or multithread-performance claim.

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 \
  taskset -c 3 python3 \
  experiments/2026-10-29-four-sector-range12-rust-screen/caller/preflight/validate.py \
  --source-commit FULL_COMMITTED_REVISION
```
