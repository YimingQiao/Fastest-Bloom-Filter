# Rust K12 actual-caller proof

The actual public21-configuration benchmark caller passed the fixed bounded
normal/ASan preflight. Its old20 public adapters and full workload/timed body
remain exact derivatives of `571186b420bf7e5fc08269ed4a65feab42ac8400`; the only
new filter adapter calls the already proved isolated Rust K12 public API.
No native kernel, hint, routing or parallel scheduler changed.

- 57 logged commands, all matching their expected exit status.
- 6focused test executions: four-mode timed-output corruption detection,
  source phase balance, and the new allocation/full-output public K12 adapter test,
  once per build mode.
- 84tiny caller rows (42per mode),38 rows from the immutable original executable,
  and76 exact retained semantic comparisons. Normal and ASan all42 rows also
  agree exactly on every non-timing field; cross-batch outputs/calibration agree.
- 12invalid CLIs rejected before CSV output.
- 4actual executable artifacts bound by structured Cargo metadata;
  213normal and220ASan compiler input paths resolved and pinned **before** test
  or filter execution. The3 local packages and all consumed external files are
  tied to committed snapshots/full pinned trees. All final source/binary checks pass.

All BF inputs were the fixed old seed42/n1024 fixtures. The original kernel's
15tests/36full-byte C++/Rust/parallel comparisons were reused, not rerun. Tiny
benchmark timings are retained as raw outputs but not interpreted or used for
selection. There was no held-out performance or formal FPR run.

The normal executable is:

`/tmp/fastest-bf-rust-k12-caller-v1-cpu3/normal/release/compare_benchmark`

SHA256: `dc6864c5cfb5324e4689e677705189fa5758be037530189a39e2bffafed2251e`.
The whole preflight ran under the inherited exclusive socket1 flock pinned to
CPU3; this serial caller preflight makes no new multithread throughput claim.

The linked implementation has a material public-query call cost. The visible
prehashed loop at `0x23420` and fused-common-hash loop at `0x234e0` each have
six pushes and a72-byte frame, and call the unchanged `contains_scalar` helper
at `0x8dc40` once per key (`0x2346b` and `0x2354b`). That helper has five pushes
and four bitmap-line bounds checks. These are direct machine-code observations,
not a measured speed penalty. The same checks preserve safe public semantics.
The batch wrapper at `0x2ac10` is an indirect tail jump; the ELF relative
relocation at `0xe41e0` resolves to public `lookup_hashes` at `0xa11a0`, whose
compiled body retains length validation and the runtime scalar/AVX2/AVX512
routes. A future inline-helper experiment must retain this frozen implementation
as its baseline; no such change is included in the fixed108 protocol.

The first five objdump captures in the passed preflight were empty function
sections: GNU demangling and raw `--disassemble` names did not select the body,
although the commands returned0. Those original bytes remain at raw commit
`0b2425682ad6435089aab89a84e55eedebbea86c`. The separate
[archive-only correction](../caller-asm-v2/README.md), source commit
`0b5514aa763a970a848caf4023cf3f13ce63fb5b`, uses frozen nm address ranges on the
same executable and asserts each symbol label plus nonempty bounded instruction
body. All five corrected captures pass. No compiler or BF execution was repeated.

[`audit.py`](audit.py) replays committed raw command/source hashes, all row/order/
phase/trial validators, exact retained/normal-ASan comparisons, final consumed
inputs and corrected ASM instructions. It also reads the immutable ELF relocation
directly to verify the public batch target. [`AUDIT.json`](AUDIT.json) records
the resulting proof. The next108 workload must measure this actual Rust API;
prior C++ K12 wins are not Rust performance evidence.
