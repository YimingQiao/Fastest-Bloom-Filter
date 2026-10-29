# Two-hint Rust K12 actual caller proof

The first frozen attempt completed successfully. No throughput matrix or independent FPR calibration ran. Source commit `612e85c975c38063cdb7aaf38d5cf484f0fc6e25` changes only two existing native `#[inline]` annotations to `#[inline(always)]`, plus clone package/library identity. Every native function body and every old public adapter/timed helper remains unchanged.

Normal and ASan builds passed all six focused test executions,68 tiny caller rows,58 retained semantic comparisons against29 original-binary rows, and six expected malformed-CLI rejections. The cloned and original public filters have equal full bitmaps after partial, duplicate and hotspot insertion; all inserted keys, dense outputs, tails0..131/4096, offsets, guards, immutable inputs/bitmaps and invalid-length rejection pass. Constructor observations remain one64-byte-aligned allocation with the exact requested backing bytes. This reuses the previous multi-backend/real-multicore algorithm proof instead of repeating it.

Structured Cargo identities bind all four local packages. Before any BF/test invocation, the normal compiler consumed219 pinned inputs (29 repository files and190 external files); ASan consumed226 (29+197). Four actual executables, complete flags/package events, dependency rules and all56 command logs are retained. The operation held the inherited exclusive socket1 flock andCPU3 affinity. `audit.py` replays the logs, all tiny rows and source/binary hashes without executing a filter.

The normal actual caller is `/tmp/fastest-bf-rust-k12-inline-v1-cpu3/normal/release/compare_benchmark`, SHA256 `2e57bbfae905d3c0d9b3281217a98e5db8a592fa8fe988730d0dd5128cff9cf5`.

| Actual visible caller | Address | Successful-path singleton calls/key | Saved registers | Stack subtraction | Captured symbol span |
|---|---:|---:|---:|---:|---:|
| Original prehashed | `0x246c0` | 1 | 6 | 72B | 192B |
| Candidate prehashed | `0x24180` | 0 | 6 | 136B | 656B |
| Original fused common hash | `0x24780` | 1 | 6 | 72B | 224B |
| Candidate fused common hash | `0x24410` | 0 | 6 | 120B | 688B |

Original visible callers still call the scalar helper at `0x93790` (five additional saved registers). Candidate loops expand the full public singleton chain. Their remaining calls occur after the successful-return path and resolve through the frozen ELF relocations to `assert_failed` or `panic_bounds_check`; the fused caller visibly includes the common hash before probing. There is no hot call merely moved to public `contains_hash`. All16 captures use raw symbol address bounds and require real instructions, avoiding the earlier empty demangled-symbol capture issue.

The costs remain material: candidate visible loops retain register pressure and use larger frames. The unchanged public batch body compiles to a7664-byte captured span at `0xa6f00`, versus6336 bytes for the old body at `0xa9d20`; its scalar/remainder helper is now expanded. Both still use the public batch dispatch. Split64Range remains an untouched control, including its outlined visible singleton helper. Symbol spans include alignment/padding and are not hot-loop byte counts.

These observations establish a testable code-generation difference, not a speedup. The unchanged72-row proposal must retain all four query contracts, all four build boundaries and every regression at batches1/3/31/4096. Its three inputs are previously observed Rust108 seeds, not fresh external-leadership evidence. No new quality sample may be pooled or silently substituted.
