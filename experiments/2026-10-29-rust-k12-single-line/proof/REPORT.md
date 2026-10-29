# Original-hint SingleLine actual caller proof

The first focused attempt passed without a compiler or runtime correction. The only production-body change obtains one checked physical-line reference inside `contains_scalar`, then reads four local words. Public/private ordinary `#[inline]` hints remain original; neither rejected `inline(always)` hint is inherited. Native source proposal `0c0eb382a817245e379b01339ecd71b747bd5cea`; actual caller source `c05d5a0f00e37aa53680af08792607f424afe773`. No performance matrix or FPR calibration ran.

Normal and ASan passed eight focused test executions: each mode runs the independent u128 physical-line invariant, full old/new bitmap/public-output equivalence, the real timed-tail fault test and four-mode scheduling test.68 tiny caller rows reproduce58 retained semantic records from29 original-binary rows; six malformed CLI calls reject before CSV. The invariant covers nonpower-of-two and maximum line counts, immediately adjacent range-boundary addresses, all256 offset bytes and five low-hash patterns without allocating a maximum bitmap. The public tests cover complete bitmaps, duplicate/partial/hotspot inserts, no false negatives, all tails0..131 plus4096, offsets/guards, immutable inputs/bitmaps, and invalid-length rejection. Previous broad backend and real parallel-owner proofs remain inherited and were not executed again.

The61-command ledger retains every source/build/test/CLI/ASM invocation. Structured Cargo metadata and actual dependency rules bind six executables, including the native invariant test binaries. Before any test/BF execution, the normal closure checks220 inputs (30 repository +190 external); ASan checks227 (30+197). The entire operation held the actual inherited exclusive socket1 lock andCPU3 affinity.165 raw files are retained. `audit.py` replays all rows, commands and source/binary identities without running a filter.

Normal actual caller: `/tmp/fastest-bf-rust-k12-single-line-v1-cpu3/normal/release/compare_benchmark`; SHA256 `64ecc64b307f32dc5ff215720c608d9423abdc55d54536034ecbebe0334f91a3`.

| Actual visible caller | Address | Successful-path helper calls/key | Saved registers | Stack subtraction | Captured span |
|---|---:|---:|---:|---:|---:|
| Original prehashed | `0x24390` | 1 | 6 | 72B | 192B |
| SingleLine prehashed | `0x24e20` | 0 | 6 | 72B | 448B |
| Original fused common hash | `0x24450` | 1 | 6 | 72B | 224B |
| SingleLine fused common hash | `0x24fe0` | 0 | 6 | 104B | 496B |

The compiler now expands the candidate chain under the original ordinary hints. Candidate pure code performs one global line comparison at `0x24e89` and bounds branch at `0x24e8c`, forms one64-byte base, and reads the four local words. Fused code similarly checks the physical line once at `0x25076`/`0x2507b`; its common hash precedes probing. Successful returns occur at `0x24f7f` and `0x25172` before all remaining calls. Frozen ELF relocation resolution identifies those calls as length-assert or bounds panics. No per-key scalar/public/probe helper call remains. Original callers still call scalar helper `0x93b80`, which saves five further registers.

The body simplification reduces the repeated line access work and also changes inlining decisions; these effects are not isolated from each other. Costs remain: fused stack subtraction is still larger than original, all visible callers save six registers, and captured code spans include alignment/padding. Public batch lookup expands to7088 bytes at `0xa9a40` versus6336 for original at `0xa7300`, while both use72-byte frames. Its scalar/remainder path is expanded; the public dispatch and masks/addressing are source-identical. Split64Range remains unchanged, including its outlined visible scalar helper.

This establishes the intended code-generation difference, not a speedup. The same fixed72 internal old/new/Range comparison must retain every singleton, short/bulk and construction loss. It reuses seen inputs and adds no independent quality sample. No production promotion or performance variant search is part of this proof.
