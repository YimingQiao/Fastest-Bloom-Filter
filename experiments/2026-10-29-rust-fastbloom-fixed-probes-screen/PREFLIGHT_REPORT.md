# Focused real-timer preflight

Completed under source `7e548983bab6fe1ca6ade217eece2b67f61995ef` with one inherited exclusive socket1 flock and CPU3 affinity. The actual original timed package remains byte-identical to `bbc3474cdd15b2e3301384dff4afdc12505cbfe9`. No formal performance matrix ran.

All43 recorded commands had their expected status. Native and ASan each passed the existing actual four-mode corruption test and balanced phase-order test (four test invocations total). Each executable produced168 tiny rows across capacities16/24/32 and batch1/31/4096; all336 match the corresponding immutable untimed60-reference geometry, checksum and false-positive counts. All14 malformed-CLI cases failed before CSV. The complete fixed-K bitmap/allocation and native suites were already validated and were reused, not repeated.

The source-only14 offline guards passed. An earlier malformed synthetic test used an obsolete registry end-marker; `source-validation-v1.txt` discloses that fixture-only failure and `source-validation-v2.txt` retains the corrected run. Neither Rust source nor measured workload changed.

All compiler `*.d` records are retained. Each mode consumes17 bound repository inputs, including the actual timer, fixed-K adapters and immutable native modules; native/ASan consume190/197 bound external source files respectively. Full package-tree hashes cover build scripts and included documentation as well as the previous11 dependency versions. Four discovered test/standalone executables are pinned through Cargo's structured artifact messages; no directory-layout assumption was used. Initial203 prepared pins, prior298 source/evidence pins,11 dependency families and seven retained correctness binaries were verified again at completion.

The selected future timing executable is `/tmp/fastest-bf-fastbloom-fixed-k-performance/validation-v1/native/release/compare_benchmark`, SHA256 `f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05`. Native flags are `-C target-cpu=native -C symbol-mangling-version=v0`; ASan uses the separately recorded nightly toolchain and `-Zsanitizer=address`. Compiler versions, exact commands, actual artifacts and dependency records are in `validation-v1/`.

Read-only peer review by optimize_probe found no source-level blocker in immutable timer/public API preservation, all168×2 semantic rows, focused real timer tests, all dependency proofs, structured artifact discovery, and fresh/dangling-target rejection. Root separately reviewed and committed the source before execution. This review does not constitute a performance result.

`PERFORMANCE_COMPILED_FREEZE.json` binds the executable and source proof. The original112 calibration outcomes are unchanged, all K1..12 remain in the future336-row grid, and the old minimum-K neighborhood is diagnostic only. A separate committed full-matrix runner and explicit lease are still required.
