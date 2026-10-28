# Public-call code-generation audit

The final preflight executable uses `-C target-cpu=native -C symbol-mangling-version=v0`. The v0 spelling exposes all seven concrete filter types and the raw/prehashed const-generic flag in the 14 whole-array loop symbols. This naming choice was made before any performance run, for inspection; it is not a measured optimization. The preceding legacy-symbol executable and its successful semantic preflight remain preserved under `/tmp/fastest-bf-rust-visible-single/legacy-preflight/` and `validation/`.

`inventory.json` identifies the final executable hash and all 14 loops; `public-query-kernels.txt` retains their full bodies and relevant native/public callees. Source-level public-call visibility does **not** guarantee that every library's full probe body is inlined:

| Implementation | Observed call/probe path in the visible loop |
| --- | --- |
| FastPattern | Scalar table/rotate/word probe logic is present in both loop bodies. |
| Fastbloom | Public multiply/index/double-hash membership logic is present in the loop; the nested early-exit probe loop remains. |
| Bloomsday | Public 8-lane SIMD multiplication/shift/test logic is in both loop bodies. |
| SBBF safe | One upstream trait-object call per key remains: `call *%rbx` at `0x1d2f7` for prehash and `call *%r15` at `0x1d3f7` for fused raw. The public runtime-selected AVX2 implementation is retained. |
| ByteSplit | Direct per-key call to the existing public `ByteSplitBloomFilter::contains_hash` at `0x46680`; its runtime backend handling remains. |
| FourSector | The public wrapper reaches its existing out-of-line `contains_scalar` at `0x46230`; the per-key call remains. |
| Split64 | The public wrapper reaches its existing out-of-line `contains_scalar` at `0x463d0`; the per-key call remains. |

The non-SBBF RIP-relative indirect calls at the end of loop bodies are assertion/bounds failure paths, not indirect per-key filter dispatch. The inventory distinguishes direct and indirect call operands but retains cold failure paths as well. Both original generic batch-one and visible whole-array metrics will remain separately reported. No source annotation, private kernel bypass, or production edit was applied to force a favorable inlining decision.

This audit establishes the generated public API paths. It does not quantify their performance or attribute a future speed gap to one instruction. An isolated follow-up could test native inlining annotations against this unchanged natural-API baseline, but it is outside the current source and requires its own correctness/performance evidence.
