# Actual Rust singleton caller assembly

The native and portable binaries execute the intended public APIs, but their call boundaries differ. This is correctness and code-generation evidence, not a speed result.

All addresses below are ELF virtual addresses in the retained V2 captures. Function identity uses raw ELF address, size and aliases, rather than the disassembler's displayed label. `EXTRA_SPANS.json` binds the additional facade and clock excerpts to the original full disassembly, symbol tables, relocation tables and metadata. It extracts existing text only; no binary was rebuilt or rerun.

| Role | Native host | Portable runtime |
|---|---:|---:|
| Candidate run / clocks | `0x2b460`, 6872 B | `0x2b9d0`, 5450 B |
| Candidate visible pure | `0x2ec30`, 637 B | `0x2e7e0`, 133 B |
| Candidate visible hash+query | `0x2f060`, 771 B | `0x2ea20`, 181 B |
| Candidate generic wrapper | `0x2f040`, 6 B | `0x2ea00`, 6 B |
| Candidate public lookup | `0x192b0`, 7646 B | `0x1b6f0`, 875 B |
| Candidate whole-query dispatch | `0x2f540`, 1329 B | `0x2ecb0`, 1104 B |
| Portable public trait facade | inlined in visible loops | `0x31e40`, 270 B |
| Portable single-key target helper | inlined | `0x31380`, 187 B |
| Portable tiny-batch target helper | inlined in public lookup | `0x1b2f0`, 268 B |

Native visible pure checks the cached AVX512 flag at `0x2ec60`, before its hot loop. Each key has one checked physical-line address, one memory-source ZMM `vpermd` at `0x2ece6`, a dictionary `vpermd`, variable right/left rotations, a low-four comparison and a dense u32 store. The fused loop includes the common hash's two multiplies before the same work. Neither hot loop makes a per-key helper call. They retain six saved GPRs and respectively 72/104 bytes of local stack frame, including the fallback route. Control visible loops also inline their scalar SingleLine implementation: this is not the C++ experiment's old out-of-line scalar helper.

Portable visible pure calls the actual public trait facade at `0x2e81b`; fused calls it at `0x2ea8b` after the common hash. Both retain six saved GPRs and a 72-byte local frame. The facade checks the AVX512 field at `0x31e43`; its enabled path tail-jumps at `0x31e4c` to the target-feature helper `0x31380`. The disabled path contains the unchanged scalar mapping. The target helper checks the line bound, performs the memory `vpermd` at `0x313e2`, dictionary lookup and rotations, then returns the low-four Boolean. Thus the portable route retains a per-key public facade call and target-feature jump. It must not be described as fully inlined.

The generic wrapper resolves via recorded `R_X86_64_RELATIVE` relocations: native GOT `0x6f3d8` points to public lookup `0x192b0`; portable GOT `0x6e4e0` points to `0x1b6f0`. Both public methods compare input/output lengths before writes. Portable tests `(len-1)<=2` only after the AVX512 flag and tail-jumps to `0x1b2f0`; zero and lengths at least four retain the original routes. Native expands the three possible tiny keys in the public body. This increases that body's size; unchanged bulk source does not imply identical bulk machine code or latency.

Native candidate timed work is bracketed by the start call at `0x2c145`, whole-query dispatch at `0x2c1e9`, and elapsed call at `0x2c264`. The clock GOT entries resolve to `Instant::now` (`0x4b270`) and `Instant::elapsed` (`0x4b280`). Full output validation is after the stop at `0x2c2ab`. Portable uses `Timespec::now` at `0x2c318` and `0x2c426`, with dispatch at `0x2c3ae` and full validation at `0x2c4c0`. Dispatch contains staged common hashing, public generic calls, or the visible loops; dense result stores remain inside these clocks. Output poisoning, bitmap/input checks and full answer validation are outside. Deliberate fault switches are part of the check-only caller and are not a performance claim.

Parent and baseline_survey independently inspected these native/portable boundaries from the retained text. The facade extraction closes the missing narrow-span role without modifying V2's original capture or its historical `manual_review_pending` fields. No throughput, FPR, build, external or promotion conclusion follows from this proof.
