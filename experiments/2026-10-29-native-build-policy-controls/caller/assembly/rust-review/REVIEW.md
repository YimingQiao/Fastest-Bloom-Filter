# Rust four-arm actual-native timing gate

Read-only inspection of the captured text passes the requested gate for normal Rust binary SHA256 `ff89a3d77e6cf6d82b019202448c56f6d4b2d9bb44c40e7bca0da735b8a16e8f`. This review did not run a disassembler, compiler, filter or performance workload. `extract.py` verifies the existing capture's text hashes, resolves GOT relocations and saves the relevant bodies without changing the binary or source.

Cargo package/manifest/rlib identity distinguishes the three libraries despite identical demangled names:

| Arm | Raw crate disambiguator | Range trial / public insert | Split trial / public insert |
|---|---|---|---|
| A0/A1 before | `Cs3PxcHUqBtNr` | `0x4dc00` / `0x3ff70` | `0x4ea40` / `0x440b0` |
| Clone | `Cs28oJ7btYGaS` | `0x4bee0` / `0x299a0` | `0x4cd20` / `0x2dae0` |
| Policy | `Csi2Sxoo6zDzi` | `0x4f920` / `0x34c20` | `0x50760` / `0x38d40` |

There are six distinct monomorphized trial addresses and six distinct public insert addresses. Before and Clone are not linker-folded at these entries. This does not imply identical instruction placement, dependency addresses or performance, nor does it claim no shared internal helper was folded.

`main-arm-dispatch.asm` shows the Split selector at0x5a4df comparing arm2 and arm3: arm2 reaches Clone0x4cd20, arm3 reaches Policy0x50760, and both0/1 reach the same Before0x4ea40 call at0x5a57b. The equivalent Range selector at0x5c81f sends arm2 to0x4bee0, arm3 to0x4f920, and both0/1 to the same0x4dc00 call at0x5c8ae. Other unrolled phase call sites retain those same targets; there is no separate A1 trial specialization. Different output-sample pointers remain arm-specific by design.

All four Policy build intervals call the actual public native method, with the original requested T loaded from Case+0x30 inside the clock:

| Family / boundary | Instant::now | Original T load | Public insert call | Instant::elapsed |
|---|---:|---:|---:|---:|
| Range allocation+insert |0x4fa90|0x4fb6f|0x4fb7c|0x4fb87|
| Range insert-only |0x502ff|0x5033e|0x50347|0x50352|
| Split allocation+insert |0x508d9|0x511f7|0x51203|0x51211|
| Split insert-only |0x50fef|0x5102e|0x51037|0x51042|

Relocations map GOT0xa4728→Instant::now0x7b780 and0xa4730→Instant::elapsed0x7b790. GOT0xa4538→Policy Range insert0x34c20 and0xa4550→Policy Split insert0x38d40. Allocation/initialization lies after the allocation clock starts. The source also separately times prefill setup; those earlier setup clock pairs are not mistaken for the reported insertion interval here. Affinity changes, final observe/validation and destruction remain outside the measured build interval.

At Range public entry,0x34c37..0x34c6e computes actual bitmap bytes, compares256KiB and the current batch length65536, and conditionally preserves original RCX or selects1. At Split0x38d57..0x38d72, the equivalent comparisons use4096 cache lines and current batch length65536. These gates execute inside the actual method called between both clocks. Subsequent worker clamping/scatter/serial fallback therefore remains charged; the caller does not substitute a precomputed effective worker request before timing.

This is a timing-boundary and identity proof. It does not predict the Policy/Clone/A0/A1 ratios, remove layout/order effects or authorize a performance claim. The preserved source correctness and upcoming controlled observations address different questions.
