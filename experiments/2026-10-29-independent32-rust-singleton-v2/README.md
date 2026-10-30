# Independent32 scalar-inline V2: source-only candidate

`candidate-v2.rs` adds exactly one annotation change to rejected
`shortcut-v1.rs`: private `contains_scalar` changes from `#[inline]` to
`#[inline(always)]`. `original.rs` preserves the unchanged Independent32
module. These are extracted source modules for a future isolated crate,
not a newly built library or executable.

The prior frozen V1 assembly provides a concrete hypothesis. Public
`lookup_hashes` at0x77600 saves six callee-saved registers and reserves72
stack bytes; unchanged lookup at0x76a80 saves one register and reserves64
bytes. V1 calls `contains_scalar` at0x7774a in the singleton fallback and
0x7777b in the scalar loop. Its ABI needs preserved state even though the
VBMI path does not take those calls. Removing the calls may let the compiler
reduce the shared prologue. Neither call elimination nor reduced register
saves is guaranteed by the annotation, and neither proves faster execution.

V1's192-row training screen was rejected: generic batch1 prehash did not
improve consistently and batches2/31 regressed. That complete result remains
frozen. This stage changes no V1 source, result, binary, bitmap mapping or
quality record. It does not consume fresh seeds or establish a new speed
claim.

An eventual same-process harness must retain all twelve frozen public
configurations and add `Independent32ScalarInlineV2` as the thirteenth. Keep
unchanged Independent32, rejected V1 and V2 separately registered. Existing
public API dispatch, generic noinline boundaries, four query contracts,
external APIs and complete output checks remain intact. The exact phase
schedule and filter row order must be reconstructed from the final new
binary's source; adding one type changes the permutation.

`plan.json` specifies correctness and assembly review before any speed test:
normal/disabled-AVX512/ASan modes, all native tests, all available forced
backends, full C++ bitmap/output parity, retained-reference CLI parity,
thirteen public tail/guard checks and all larger-batch assembly paths.
The proposed208-row training grid is not authorized for execution. Both
sockets are assigned elsewhere; no V2 compilation, test binary, JIT,
assembly generation or timing has run.

Source-only verification:

```sh
python3 experiments/2026-10-29-independent32-rust-singleton-v2/verify_source.py
```

The native source retains its original MIT AND Apache-2.0 licensing;
unchanged `LICENSE-MIT`, `LICENSE-APACHE` and `NOTICE` are included. The
provenance manifest pins copied modules, prior measured assembly/results and
their existing binary hash. All claimed assembly observations refer to V1,
not to an unbuilt V2.
