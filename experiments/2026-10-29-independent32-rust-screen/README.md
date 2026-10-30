# Independent32 native Rust comparison preflight

The eleven-configuration harness passed correctness and generated-code checks.
No performance matrix has run. The separate Independent32 native crate also
passed its full bitmap, parallel ownership and C++/Rust parity preflight.
`validation/freeze.json` pins the measured executable, reference executable,
repository inputs and external dependencies; a reviewed source commit and a
separate CPU3/socket1 lease are required before throughput execution.

The final leaf-inline four-mode harness is copied unchanged except registration
and full-output tests for one additional public filter, Independent32. The
original seven configurations and three leaf-inline controls all remain. Every
one of the eleven configurations runs at every batch1/31/4096, unlike the earlier
leaf screen's native-only bulk guards. Proposed matrix: n2^16/2^25, requested8/16
(actual16/32bpk), input42,50% hits,q2^22,eight balanced repetitions, whole-input
insertion,calibration2^24:12 workloads and132 rows.

`original-native/` and `leaf-native/` are exact local source snapshots, including
their license/NOTICE files. The Independent32 dependency is the separately
frozen prototype. Future production source changes do not change the old/native
control snapshots. The external dependencies, versions and public methods are
unchanged. Shared source provenance is in `copy-source.json`; no private kernel,
native FFI or external adapter shortcut is added.

The four query contracts stay separate:

- Existing generic batch prehashed query.
- Existing generic batch query with staged common hashing.
- Whole-array loop over the actual public singleton API, prehashed.
- Whole-array public singleton loop with common hashing fused per key.

The visible singleton loops always process the complete array, so changing the
original batch size does not turn them into a different singleton algorithm.
All output vectors, guards, checksums, phase positions and predecessor balance
remain checked. Backend dispatch is retained in every library.

Rankings must distinguish original native, experimental native and external
ownership. Compare Independent32 individually against the fastest eligible
external and against the Byte leaf control under each actual-byte/FPR cap;
also retain every original/native loss. Cap32 must consider actual16 as well as
actual32 allocations. Each of four modes and each batch is separate. The earlier
Independent32 FPR at16bpk does not satisfy0.1%; eligibility is recalibrated from
the new matrix, never borrowed from a favorable previous seed.

Calibration identity is mapping/size/requested budget/input seed. Leaf clones
share their original mapping; Independent32 has its own mapping. Repeated
batches and query modes must not be pooled into extra negatives. Per-case
Wilson95% bounds remain pointwise, not simultaneous selection guarantees.

The prepared CLI preflight uses all11 names at all three batches and three hit
rates. All ten retained configurations must exactly match the frozen leaf
reference executable's checksums, mixed FPR and calibration counts. The new
candidate's public API joins the full dense-output/tail tests; its separate
native/C++ bitmap oracle freeze remains required. Malformed filter selections
and phase labels must be rejected before any speed run.

All eleven harness tests passed in normal, disable-avx512 and AddressSanitizer
builds. They cover public API dense outputs and tail guards for every filter,
all four timed-mode corruption injections, phase balance, and strict selection.
Clippy passed with warnings denied. Eighteen small CLI workloads produced198
rows and180 exact semantic comparisons against the ten retained controls in the
frozen leaf binary. Eight invalid CLI selections were rejected. These small
checks include timing fields only because they exercise the real harness; those
values are not performance evidence. Seven offline malformed-row tests and four
runner/lease tests passed. Logs and exact commands are in `validation/`.

The22 public singleton loops have distinct typed bodies in `assembly/`. The
Independent32 prehashed loop at0x1fe50 and fused loop at0x202b0 move runtime
backend checks before their key loops. Their VBMI paths inline multishift, byte
widening, rotate and the32-byte bucket test, with no per-key helper call; the
AVX2 path is also inline. The portable scalar fallback retains a per-key helper
call. Original Byte/FourSector/Split64 retain their public/leaf calls, leaf
controls expose their intended hot bodies, and SBBF retains its upstream trait
object call. Visibility therefore remains a public API contract, not a promise
of identical generated call boundaries. See `assembly/README.md` for details.

The release binary is `/tmp/fastest-bf-independent32-rust-screen/release/compare_benchmark`,
SHA256 `5e7d08133b4404fcfe8090a482c55256eb7dc91fba7533a7a02f9ffed0f4305c`.
Compiler flags are `-C target-cpu=native -C symbol-mangling-version=v0`; all
eleven configurations share ThinLTO and codegen-units1. CPU3 affinity does not
impose explicit NUMA memory binding. No production library was changed.

`run.py` rejects Python `-O` at entry, verifies committed source blobs and both
executables, requires an actual inherited exclusive socket1 flock descriptor,
checks the registry and all output fields, and refuses an existing output
directory. The lock covers the complete matrix. `PREPARATION.json` records the
earlier source-only draft; the final executable-input freeze is
`validation/freeze.json`. `freeze.py --verify` checks that final freeze without
running the benchmark. No performance claim is made at this stage.
