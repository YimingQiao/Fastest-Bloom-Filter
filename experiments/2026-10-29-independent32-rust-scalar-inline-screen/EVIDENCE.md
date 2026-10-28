# Preflight and code generation

The isolated candidate passed36 full native tests,7 Independent32 tests in
each disabled-AVX512 and ASan mode,11 harness tests in each of the three modes,
and all9 C++ full-bitmap/output fixture rows in each mode. Clippy passed for
both crates. Eighteen small CLI cases produced234 candidate-binary rows and
216 exact retained-reference semantic comparisons;8 invalid commands were
rejected. These small timing fields are not performance evidence. Eleven
offline row/order/lease guards passed, including all18 actual preflight row
orders reconstructed from the thirteen-type source registry.

The initial harness build missed unchanged SBBF/support source copies. Its
logs and initial driver are retained in `validation-v1`; no previously
compiled source changed when the missing files were copied. `validation-v2`
reuses only the successful36-test native result, checking the prior command
and all earlier compiled source hashes. The complete resumed run used the
actual inherited socket1 flock and CPU3 affinity. No explicit NUMA memory
binding was imposed.

The final same-process executable is
`/tmp/fastest-bf-independent32-rust-scalar-inline/release/compare_benchmark`,
SHA256 `1243cbea0869852cc1d7eda969f1a1c38cded9daedf7afd9ac57858aa82dcb27`.
All configurations share target-cpu=native, ThinLTO and codegen-units1.
The12-type reference binary was verified before and after the CLI checks.

Actual public batch entries in this executable show the intended codegen change:

| Module | Entry | Saved registers | Stack reservation | Symbol span |
| --- | --- | ---: | ---: | ---: |
| Original | 0x7cb90 | 1 | 64 bytes | 1328 bytes |
| Rejected V1 | 0x7e3d0 | 6 | 72 bytes | 1344 bytes |
| Scalar-inline V2 | 0x7d710 | 1 | 64 bytes | 1648 bytes |

The spans include symbol padding and are not cache-footprint measurements.
V2 retains the singleton shortcut and removes both scalar-helper calls from
the public batch body. Its remaining three calls resolve through GOT slots
0xbebe8/0xbeb40 to `core::panicking::assert_failed` at0x72b60 and
`panic_bounds_check` at0x72bdf. V1 still calls `contains_scalar` from its
singleton fallback and scalar batch loop. All three generic monomorphized
wrappers retain an indirect tail jump to their respective public methods.

`assembly/loop-comparison.json` compares actual original/V2 instruction
sequences after normalizing only the final branch target: the four-key VBMI
loop (56 instructions), VBMI tail (16), four-key AVX2 loop (64), AVX2 tail
(18), and scalar fallback loop (30) are identical. This does not imply the
complete functions have equal speed: entry paths, code positions, alignment,
exit jumps and total code size changed.

All26 optimizer-visible typed loops were retained separately. The two V2
visible loops also lose their scalar-fallback helper calls; their only calls
resolve to the same cold assertion/bounds handlers. SIMD paths still use the
public runtime dispatch. No target-specific private benchmark shortcut was
introduced.

This evidence justifies a speed screen, not a speed claim. The fixed screen
uses seed42, n2^16/2^25, requested8/16 (actual16/32bpk), batches1/2/31/4096,
q2^22,50% hits,4 balanced repetitions and2^24 independent calibration
negatives. It retains all13 configurations, all four query contracts and
every before/V1/V2 loss. Whole-array visible timings remain whole-array at
every batch tag. Source-derived filter order is verified but is not
pair-order balanced; reused aliases/batch rows do not add independent quality
samples. Earlier V1 timings used q2^20 and are not pooled with this screen.
