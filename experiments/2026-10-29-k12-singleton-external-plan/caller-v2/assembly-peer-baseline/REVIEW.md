# Independent typed-caller ASM review

This review reads the retained normal/minimal-F text and raw ELF-address inventories. It does not run a compiler, disassembler, filter, timing or statistical analysis. `extract.py` checks the recorded span hashes and emits `inventory.json`: 152 typed bodies, 38 actual clock pairs with four query routes apiece, and 32 additional callee bodies from the separate captured closure. Existing artifacts remain untouched.

The actual panel is **7 native types +3 Boost types +7 FastFilter/public-shortcut types +2 Rocks types**. Page is only an included dependency here: there is no Page registration or typed instantiation in these 19 bodies. Included headers are not evidence of a measured public API opportunity. The fixed panel is unchanged.

## Actual entry addresses

Every row has a real generic public wrapper and optimizer-visible pure/fused wrapper in each profile; addresses are ELF virtual addresses, not inferred names or historical binaries.

| Type | Normal generic | Normal visible pure | Normal visible fused | Minimal-F generic | Minimal-F visible pure | Minimal-F visible fused |
|---|---:|---:|---:|---:|---:|---:|
| FastPattern | `0x5a880` | `0x5a890` | `0x5aa20` | `0x514d0` | `0x514e0` | `0x51580` |
| Split64 | `0x5ded0` | `0x5e280` | `0x5e3d0` | `0x54670` | `0x54870` | `0x548f0` |
| ByteSplit | `0x5eaa0` | `0x5ec90` | `0x5ee40` | `0x54ec0` | `0x54f70` | `0x54fe0` |
| FourSector | `0x5c5d0` | `0x5c6f0` | `0x5c800` | `0x52e00` | `0x52f30` | `0x53040` |
| Split64Range | `0x63328` | `0x63330` | `0x63490` | `0x59118` | `0x59120` | `0x591b0` |
| K12 control | `0x5f4e8` | `0x5f620` | `0x5f6a0` | `0x555b8` | `0x556f0` | `0x55770` |
| K12 singleton candidate | `0x61208` | `0x61340` | `0x61570` | `0x57218` | `0x57350` | `0x57430` |
| Boost Multi32 K4 | `0x58808` | `0x58810` | `0x58960` | `0x4fdc8` | `0x4fdd0` | `0x4fe60` |
| Boost Multi32 K8 | `0x517e8` | `0x51b30` | `0x51c70` | `0x4aff8` | `0x4b310` | `0x4b3a0` |
| Boost Multi64 K8 | `0x52de0` | `0x52ea0` | `0x53060` | `0x4bfb0` | `0x4c080` | `0x4c140` |
| Fixed16 SingleShortcut | `0x54920` | `0x54a80` | `0x54b90` | `0x4d2c0` | `0x4d380` | `0x4d3f0` |
| SimdBlock SingleShortcut | `0x57740` | `0x578d0` | `0x57a00` | `0x4f2b0` | `0x4f390` | `0x4f410` |
| Fixed16 | `0x54100` | `0x54220` | `0x54330` | `0x4cce0` | `0x4cd50` | `0x4cdc0` |
| Fixed32 | `0x54ed0` | `0x55010` | `0x55140` | `0x4d640` | `0x4d6c0` | `0x4d740` |
| Fixed32 prefetch | `0x557d0` | `0x55910` | `0x55a40` | `0x4dce0` | `0x4dd60` | `0x4dde0` |
| Fixed64 | `0x56380` | `0x56530` | `0x566e0` | `0x4e4a0` | `0x4e550` | `0x4e5f0` |
| SimdBlock | `0x56de0` | `0x56f20` | `0x57050` | `0x4ebb0` | `0x4ec40` | `0x4ecc0` |
| Rocks K8 | `0x57eb0` | `0x58060` | `0x58210` | `0x4f7c0` | `0x4f870` | `0x4f920` |
| Rocks K8 Batch32 | `0x59f70` | `0x5a2d0` | `0x5a4a0` | `0x50ef0` | `0x51030` | `0x510f0` |

## External public-call decisions

All 24 external visible wrappers per profile contain the public scalar membership body directly, with dense u32 output stores and **no call instruction** in these particular captured wrapper bodies. This is the actual compiler result for the pinned public source, not a private-kernel adapter or a promise of inlining in another caller. Normal code often duplicates/unrolls a loop while minimal-F code is smaller; no performance inference follows from body size.

FastFilter Fixed16 demonstrates the complete fused route in minimal-F at `0x4cdc0`: the common hash performs two multiplies at `0x4cdfe`/`0x4ce0c`, followed by range reduction, signed-word multiply / byte shuffle, bitmap test, and dense store at `0x4ce52`. Fixed32, Fixed64, SimdBlock and the two retained public singleton shortcuts likewise retain their actual mask/address tests and dense output. Shortcut and original API wrappers remain distinct controls even when a compiler emits equivalent scalar bodies.

Boost generic dispatch remains a stronger bulk opportunity than merely forcing the per-key loop. Normal Multi32 K4/K8 generic wrappers tail-jump to public adapter Lookup at `0x59450`/`0x52720`; minimal-F targets are `0x505e0`/`0x4bb20`. Their captured bodies retain upstream prefetch, block mask tests and output callbacks. Multi64 K8 normal generic wrapper calls the upstream `bulk_may_contain` specialization at `0x53a90` (minimal-F `0x4c8a0`), with public iterator/callback state prepared by the adapter. This internal symbol is reached by the actual public bulk method; the benchmark does not invoke the private core directly. The visible wrappers independently retain the public scalar path. The supplementary callable-kernel closure records no unbound direct transfer in its tracked set.

Rocks K8 and Batch32 keep their distinct public bulk arrangements. The Batch32 fused visible minimal-F wrapper at `0x510f0` performs common-hash multiplies at `0x5112e`/`0x5113c`, then the original range/probe/prefetch work, YMM bit tests and dense store at `0x511b3`. Bulk32's batching/preparation is retained in the generic body; it is not silently replaced by the scalar-visible route. Both routes remain separately measurable.

## Timed work and limits

Every one of the 19 Run specializations in both profiles contains exactly two steady_clock::now call sites bracketing the measured mode dispatch. Four typed call sites occur between them: generic pure, generic hash+query, visible pure and visible hash+query. `inventory.json` records all 38 pairs, all actual targets and hash multiplication sites inside the interval. Warmup invocations are separately visible before the first clock.

For example, normal Fixed16 starts at `0x1e572`, reaches generic `0x54100` or visible `0x54220`/`0x54330` inside the interval, and stops at `0x1e9b0`; minimal-F Fixed16 is `0x1d312`→public routes→`0x1d640`. Normal Boost32 K8 is `0x18122`→public routes→`0x18560`; its minimal-F counterpart is `0x17aa2`→public routes→`0x17dd0`. The staged hash route's actual common-hash scratch writes precede its generic query call while still inside the interval. The fused route's hash and dense stores live in the visible callee within the same interval. For normal Fixed16, the poison tail store is at `0x1e560` before the first clock and `Output::Check` is called at `0x1eb15` after the stop. Every captured Run similarly has no Output::Check call inside its clock pair and a complete check afterward. Full output validation, poisoning, construction and calibration remain outside these query clocks in the unchanged caller source and inspected Run control flow.

The normal and minimal-F binaries deliberately have different code generation. The external headers require at least AVX2, so minimal-F describes the candidate's extra AVX512F requirement, not an AVX512F-only entire executable. This proof establishes actual public API/caller availability and charged work, not speed, FPR, significance, cross-profile ranking, or global coverage. Root/primary review separately covers detailed native candidate/control/Range kernels and the added full callee traces.
