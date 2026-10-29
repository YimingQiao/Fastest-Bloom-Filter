# Bounded actual raw8 caller preflight

This additive driver binds the unchanged initial 86 source files at `d23791243dabdda85a8ff2eb11ce2d9b3e5a6b47`, including the approved allocation-inclusive raw build and zero-scratch direct API. It prepares execution only; no compiler/BF has yet run. No 262/786 formal matrix is authorized.

The fixed scope is two fresh normal/ASan targets, four executables (test and caller per mode), six focused tests per mode, three tiny CLI workloads per mode (45+8+8=61 rows, 122 total), and six invalid CLIs per mode. Each selection error must exit2 with its expected source diagnostic; numeric parsing/argument assertions must exit101 with their stable panic message. Unrelated failure, crash, extra stdout and sanitizer/runtime-error diagnostics are rejected, including for deliberately invalid calls. The proposal's small all-K bitmap oracle, actual scratch allocation/lifetime and stale-output faults are exercised, along with 12 empty formal-size constructor checks per mode. Native library-wide tests and earlier backend grids are not repeated. Tiny timings are discarded as performance evidence; no tuning or ranking occurs.

`dependencies.py` is byte-identical to the validated Poppy actual-caller collector at `6fd92279…`; `lease.py` is byte-identical to the existing CPU3 exclusive inherited-flock guard at `72625673…`. `HELPERS.json` pins their exact source blobs. The initial package graph has 34 packages, including three local source snapshots and 31 external trees containing 1,856 files. `INPUTS.json` binds all initial source/ancestor descriptors and full external trees. Before runtime, structured Cargo metadata, package/manifest/target identities, every actual dep-info file, emitted test/caller artifacts and any build-script-owned generated inputs must pass the source-closure checks. Relative `.d` paths are resolved by their exact package owner. No first-existing-path fallback is permitted.

The driver rejects hidden Rust/Cargo/allocator/sanitizer overrides and implicit Cargo config, and requires the actual CPU3 affinity and inherited exclusive socket1 flock for the entire operation. It refuses existing or dangling-symlink output/target paths. It retains each command, stdout/stderr, exit status, tool/binary hash and any failure before stopping. Tests are first built with `--no-run`; the release caller is also built, and only then does validated actual compiler consumption permit tests and tiny cases. The only permitted successful CLI stderr is the exact already-archived SBBF backend information from the corresponding normal/ASan profile; no additional diagnostic bytes pass.

The row contract independently reconstructs the source-derived job shuffle and seeded two-phase order, requires the complete raw-only schema and actual geometry, validates scratch bytes and all four trial vectors/medians/ranges, and compares full semantic fingerprints across batches and profiles. These CSV fingerprints supplement the caller's per-call complete output checks; they are not a substitute for those checks or a claim of archived full arrays.

ELF capture retains raw/demangled symbols, defined `FUNC` address/size, folded aliases, full disassembly and relocations. It extracts actual raw-loop/insertion/caller spans by address ranges, verifies real first instructions, and does not use the displayed objdump label as identity. This capture is evidence for later manual review, not automatic proof that a particular hash or allocation was inlined or timed. Actual required hashes and complete build clock placement remain manual gates before performance.

After this source is reviewed and committed, execution requires a separate explicit lease:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 \
  taskset -c 3 python3 experiments/2026-10-29-fastbloom-rs-raw8-caller/preflight/validate.py \
  --source-commit FULL_REVIEWED_PREFLIGHT_COMMIT
```

Before this additive source freeze, source review corrected two guard-only issues: typed invalid-CLI exit/diagnostic checking replaces any-nonzero acceptance, and subset order is reconstructed by registry filtering before shuffle. Neither correction changes the immutable Rust caller, commands, seeds or inputs; no compiler/BF attempt preceded them.
