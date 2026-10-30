# Additive correctness and assembly preparation

Uncompiled preparation; no Rust test or benchmark executable has run from
this package. These additions leave all36 source artifacts from initial
commit `d93d45c6cf09e8da687981fa77bb01b5fecbda70` unchanged. The original
manifest itself is also preserved. `verify_preparation.py` checks these bytes,
copied public adapter prefixes, immutable reference crate/dependencies and
Python syntax without compiling.

After review and a new committed additive manifest, the entry point is:

```
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-split64-range-rust-screen/preflight/validate.py \
  --source-commit FULL_ADDITIVE_COMMIT
```

This command requires a separate explicit CPU3 lease. It rejects Python -O,
checks the actual inherited exclusive flock descriptor and exact CPU affinity,
then verifies every original/additive source byte against its committed blob.
It cannot launch the120-row performance matrix. It creates `validation-v1/`
with commands, flags, toolchain versions, outputs and source/dependency/binary
hashes; failures stop immediately and retain their logs. Future source fixes
must preserve this preparation and failed evidence rather than silently
refresh its initial anchor.

The driver runs the complete current native library plus Range tests in
normal, disabled-AVX512 and AddressSanitizer modes, and the entire eight-API
harness suite in each mode. The native Range tests already contain explicit
scalar-path overrides. Generic-target correctness builds avoid enabling
AVX512 auto-vectorization in the disabled-dispatch build; upstream SBBF retains
its own public AVX2 dispatch. Twelve full word/output fixtures must equal the
frozen C++ fixture SHA `511faca6e2b3933b5cf607e3b753e803be7877d03f9b7bda2bb8c90d5531f075`.
Both primary crates then run Clippy.

The dense audit is separate from all timers. `audit-current` includes the
exact eight public adapter definitions from the initial candidate;
`audit-reference` includes the frozen original seven adapter definitions and
an immutable copy of the previously frozen native crate. Both include the
same input/validation fixture. The only requested-size difference is old
8/16 versus new byte ceilings16/32. It must yield:

- 72 current cases:8 APIs ×3 item counts ×16/24/32bpk ceilings;
- 42 reference cases:7 APIs ×3 item counts ×16/32 actualbpk;
- 42 exact full comparisons, each with4097 mixed query answers plus4096
  independent negative answers, all inserted hashes checked, input fingerprints,
  actual allocations and false-positive counts identical;
- Identical complete results across normal, disabled and ASan executables.

Every current24-bpk public API is exercised. Native power-of-two aliases at24
must reproduce their16-bpk outputs/bytes exactly; new Range and external
families use their distinct24-bpk capacity. Accounting and independent
Bloomsday/SBBF24-bpk scalar-oracle tests remain part of the actual harness
suite. Temporary audit allocations are validation-only and never become
performance scratch or a private query shortcut.

The final release harness uses the proposed native CPU flags, ThinLTO and one
codegen unit. Twenty-seven small CLI cases produce216 current rows, including
24-bpk cases; eighteen of these compare126 retained-family rows against the
unchanged frozen reference executable. The intended requested-bpk rename is
ignored only for that comparison; actual bytes, full-output checksum, FP and
calibration counts, workload and phases must agree. Eight malformed CLI cases
must fail before emitting CSV. Those small timing fields are unclaimed.

The assembly extractor archives16 typed visible loops and their relevant
public/private callees. It requires two actual Range visible loops and records
direct/indirect calls and mask instructions. It does not assume inlining or
infer speed from source. Manual inspection of actual public Range dispatch,
per-key calls, register pressure and bulk paths is a final preflight gate.

No explicit NUMA memory binding is applied by this correctness driver. Future
performance placement, binary/source freeze, row/order/quality guards and
runner remain a separate reviewed stage. Old timings are not imported.
