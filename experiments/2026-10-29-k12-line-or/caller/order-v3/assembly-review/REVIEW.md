# Order-only caller assembly review

The measured normal executable is `46c593a4740f161fac09e78e2b745f9b2aba7f2ea34ac6f4d7e06ec0061461cf`. This review uses the successful V3 captured disassembly, not a new compiler or filter execution.

All eight insertion bodies (two public noinline helpers, four vector kernels, two scalar tails) have identical normalized instructions to the earlier successful V2 proof. PCs, RIP displacements/comments and named target addresses are normalized; registers, opcodes, constants, symbols and relative branch offsets remain. Every body moved by +0x300; sizes and instruction counts are unchanged. The control retains 16 scalar ORs, and the candidate retains four ordered expand/load/OR/store operations per four-key group. This establishes unchanged compiled insertion code in these two binaries, not a universal code-placement guarantee.

Actual V3 clock windows:

| Type/contract | Allocation clock | Ready clock | Public insertion call | Stop clock |
|---|---:|---:|---:|---:|
| Control prehashed | 0x9e49 | 0x9e68 | 0x9ead → 0xd0d0 | 0x9ec7 |
| Control common hash | 0xa0f9 | 0xa117 | 0xa32e → 0xd0d0 | 0xa520 |
| Candidate prehashed | 0x112d9 | 0x112f8 | 0x1133d → 0x14560 | 0x11357 |
| Candidate common hash | 0x11589 | 0x115a7 | 0x117be → 0x14560 | 0x119b0 |

The four exact excerpts retain construction between allocation and ready clocks and actual public insertion between ready and stop. Common hashing/chunking remains inside its corresponding interval. The public helpers retain the original empty-input and bitmap-size dispatch; the order flag changes only job invocation order outside all measured helpers. No inline/private replacement was introduced.

The source change consumes no additional RNG draws. Both order flags reproduced the earlier full semantic records in native and ASan callers. The kernel's earlier native/minimal-AVX512F/ASan bitmap proof remains the independent mapping evidence; it was not repeated. Formal seed5011 will use original order and seed6011 reversed order. Fixed pure-before-hash construction phases and code-placement uncertainty remain disclosed.
