# Native Rust SIMD singleton: bounded actual-caller proof

Source preparation only. No Rust compiler, Bloom filter or timed workload has run for this stage. The single candidate remains the exact committed5ac4b634 proposal; no kernel, dispatch threshold or inline hint is selected here.

`derive.py` copies the full native library source closure from ba5530a into two local packages. Their package/library identities differ; production library bytes otherwise stay exact except the frozen candidate module and an appended `cfg(test)` focused-test module. Existing unit tests remain available but the proof executes only the two new focused tests per arm. The root package has no registry dependencies. Ordinary trait wrappers call the native public `contains_hash`, `lookup_hashes` and insertion methods; no private target helper is substituted as the public caller.

Four release profiles are fixed: native host ISA; portable x86-64 with runtime dispatch; portable with `disable-avx512`; and portable ASan. Each uses the same source and locked local dependency graph. Actual portable and native ELF bodies must be reviewed separately: a runtime feature branch and target-feature call boundary may survive in the portable caller even if native compilation inlines them. No C++ timing benefit is assumed.

This correctness proof is fixed to the known AVX512-capable CPU3. All actual rows must report `avx512` for native/portable/ASan and `avx2` for the disabled profile. Silent fallback cannot satisfy the proof that the new target helper was exercised. These are runtime-backend checks, not a claim that portable callers inline the target-feature body.

## Finite functional scope

Per arm/profile, the required-bit test has exactly9,224 controlled hashes:256 high-offset patterns plus2,048 dictionary/rotation/wrap patterns and two endpoint hashes, across line counts2,3,17,32769. For each hash it checks the positive singleton and batches1/2/3, then removes each of the twelve required bits and verifies a negative singleton and batch3. It touches/reset only the selected64-byte line. Whole large bitmap scans occur once per allocation, not once per field combination.

The second test builds1,031 inserted keys with an independent u128 address/per-bit bitmap oracle and verifies all inserted positives. It covers2,128 complete-output cases per arm/profile:four allocations ×four offsets ×(lengths0..131 and4096), plus24 mismatched-output cases that must fail before writes. Complete bitmaps are compared per construction before and after queries. Insertion, allocation, kernels for batches>=4, scalar fallback and ownership code remain untouched; no broad MT/kernel matrix is repeated.

The actual two-arm caller has twelve tiny cases per profile: n256, q4096, actual24 bpk, seen seed74381, hit0/50/100 and batches1/3/31/4096. Four query repetitions use a fixed balanced four-phase schedule at batch1 and two-phase ABBA elsewhere. Generic pure and staged common-hash calls go through a common noinline public batch helper. Visible pure/fused loops use each actual public singleton. Hash computation and all dense stores stay inside their clocks; poisoning, full exact oracle output/bitmap/input validation and consumption stay outside. Every arm constructs/inserts one bitmap, untimed, and destroys it before the next arm. The same independent reference bitmap and raw/prehashed/reference-output arrays remain resident for both arms; both also retain equivalent input-check copies. This is correctness/codegen evidence, not a memory-minimized or formal performance result.

Two faults per profile skip the last generic write or invert the last visible result after all valid warmups; both must fail the first affected timed output check with exact exit1/empty stdout/`full output mismatch`. Six malformed CLI cases per profile must reject before row output. The CLI has only `--check` for the fixed grid and rejects `--measure`; calibration is always zero. Totals:16 focused test executions,96 public rows,24 invalid CLI cases and8 faults across twelve compiled executables. The emitted small timings are never ranked.

## Provenance and next operation

`PREPARATION.json` binds every authored/derived source. Before a build, the driver requires exact Git blobs, deterministic crate derivation, no Cargo/environment override, fresh target/output paths, actual Rust tool hashes and an inherited exclusive socket1 flock pinned to CPU3. Structured Cargo metadata/artifacts identify each library test and caller executable. The reused collector handles literal/normalized target names with exact package/hash/out and actual/final executable SHA equality. Actual `.d` sources must match prepared repository inputs before any test/filter runs; complete original dep-info is retained. Source, all consumed files, tools and binaries are checked before each profile/case and at completion.

Both native and portable ASM capture binds ELF FUNC address+size, all same-address aliases, raw instruction spans and relocation evidence. It retains public/target bodies when outlined and the actual generic/visible/clock functions. Display labels are not identities; absent methods may be inlined and require manual caller/callee tracing. The capture gate does not by itself claim successful public inlining or a speed improvement.

After source review/commit and an explicit correctness lease only:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 \
  python3 experiments/2026-10-29-rust-k12-singleton-vector-plan/caller/validate.py \
  --source-commit FULL_COMMIT
```

Target `/tmp/fastest-bf-rust-k12-simd-caller-v1-cpu3` and local `validation-v1/` must not exist. Failure evidence remains; no automatic retry or formal screen follows. Any future timing matrix and stronger-rival selection require a separate protocol.
