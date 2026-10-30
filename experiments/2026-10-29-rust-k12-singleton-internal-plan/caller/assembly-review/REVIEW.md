# Rebuilt internal caller: actual assembly review

This review uses only the retained native/portable ELF address+size captures from the first successful bounded proof. No old address or timing result is reused. Native binary SHA is `8ea5ddd7f274b32042987a555b7ba0c53c3ec6520763807bfbd66a6e78e08084`; portable SHA is `897a530360665b3b35307fb5ab91a0e458209abdaba8b435711274de653dd9bc`.

| Candidate role | Native | Portable |
|---|---:|---:|
| run / clock caller | `0x2bb10`, 7057 B | `0x2bfa0`, 6152 B |
| outlined timed_work | `0x2b7d0`, 412 B | `0x2bc60`, 412 B |
| visible pure | `0x2f4d0`, 653 B | `0x2f320`, 149 B |
| visible hash+query | `0x2f920`, 779 B | `0x2f580`, 181 B |
| generic wrapper | `0x2f900`, 6 B | `0x2f560`, 6 B |
| public lookup | `0x19620`, 7646 B | `0x1b980`, 875 B |
| whole-query execute | `0x2fe10`, 1377 B | `0x2f810`, 1136 B |
| public trait facade | inlined | `0x33290`, 270 B |
| single-key target helper | inlined | `0x327d0`, 187 B |
| tiny-batch target helper | inlined in lookup | `0x1b580`, 268 B |

The runtime bounds changed compiler decisions despite byte-identical query helpers and literal timing block. `timed_work` is now outlined in both arms and both profiles, with six saved GPRs and a 24-byte local frame, once per whole query phase. Its slice/fault checks and call to whole-query `execute` are inside the clock; this is not an extra per-key dispatch. The Control work symbols are native `0x2b970` and portable `0x2be00`, also 412 bytes. Source equality does not establish old caller machine-code equality or performance.

Native candidate visible pure checks length/empty input, then the cached AVX512 flag at `0x2f509` outside the hot loop. Its hot loop performs one checked physical-line address and memory-source ZMM `vpermd` at `0x2f596`, dictionary `vpermd`, variable right/left rotations and low-four-bit membership reduction, then a dense u32 store. Fused similarly includes both common-hash multiplies before the line load at `0x2fa05`. Neither hot loop makes a per-key helper call. Both retain six saved registers and 72/104-byte frames with their scalar fallback paths. The old safe SingleLine control also inlines its scalar mapping.

Portable visible loops call the captured public trait facade `0x33290` once per key (fused call at `0x2f5eb`, after its common hash). The facade checks the cached AVX512 field and tail-jumps at `0x3329c` to `contains_single_avx512` at `0x327d0`. The target has the checked line, SIMD permutation/dictionary/rotation/test and no additional hot call. The disabled branch retains scalar SingleLine. Portable visible loops retain six saved registers and 72-byte frames. They are not fully inlined and cannot inherit native-host or C++ speed conclusions.

Generic wrapper relocations are explicit in the captured tables: native GOT `0x70738` resolves to public lookup `0x19620`; portable GOT `0x6fa60` resolves to `0x1b980`. Both compare input/output lengths before writes. The portable AVX512 path uses `(len-1)<=2` to tail-jump to `0x1b580`; zero and lengths at least four retain old routes. Native expands the tiny bodies in public lookup. The original >=4 source remains unchanged, but public dispatch, body size and layout still belong in later regression checks.

| Profile / arm | Start clock call | Whole-query work call | Stop clock call | Full validation call |
|---|---:|---:|---:|---:|
| Native Candidate | `0x2c8f7` | `0x2c94a` | `0x2c95b` | `0x2c9b2` |
| Native Control | `0x2e4d7` | `0x2e52a` | `0x2e53b` | `0x2e590` |
| Portable Candidate | `0x2cb54` | `0x2cba1` | `0x2cbb2` | `0x2cc1a` |
| Portable Control | `0x2e449` | `0x2e496` | `0x2e4a7` | `0x2e510` |

Native clock GOT entries `0x70a70`/`0x70a78` resolve to `Instant::now` `0x4c490` and `Instant::elapsed` `0x4c4a0`. Portable start calls `Timespec::now` `0x488c0`; stop GOT `0x6fda0` resolves to `Instant::elapsed` `0x4b110`. Output poison loops precede these clocks. Hashing, actual public queries and dense result writes are in the transitive work/execute bodies; full output/guard validation follows stop. Bitmap/input checks and construction are outside. Checks use the tiny fixture only and produce no performance conclusion.
