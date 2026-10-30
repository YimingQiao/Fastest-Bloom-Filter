# Three-hint generated-code result

The final executable is `/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark`, SHA256 `0caf0d3ff982ffdc295b6bb7010ae148bd5ffa240426573429e2ae2e92036926`, built uniformly with `-C target-cpu=native -C symbol-mangling-version=v0`. All 20 typed whole-array loop bodies are retained. The source verifier proves that the cloned library differs by exactly the requested three `inline(always)` hints, aside from declared crate identity metadata. No performance matrix has run.

| Family | Original visible path | Candidate visible path |
| --- | --- | --- |
| ByteSplit | Per-key public `contains_hash` call remains in both original loops at 0x1fe00/0x1fec0. | AVX2 membership is inside loops 0x1f290/0x1f440: `vpmulhw`, `vpshufb`, `vptest`. Backend selection is checked before the loop; the AVX2 loop is unrolled across two inputs. |
| FourSector | Per-key private `contains_scalar` call remains in original loops 0x1ffa0/0x20060. | Loops0x1f6a0/0x1f910 contain scalar pattern loads, rotates, four word probes and bounds checks. There is no per-key probe call. This is not the bulk SIMD query kernel. |
| Split64 | Per-key private `contains_scalar` call remains in original loops 0x20140/0x20200. | Loops0x1fb90/0x1fcb0 contain the auto-vectorized source probe body, with constants loaded before the loop. They still use 64-bit `vpmullq`, then right-shift 26, mask 63, `vpsllvq` and membership reduction. Inlining has not selected the explicit bulk mask kernel. |

ByteSplit's non-AVX2 fallback still calls `contains_scalar` per key (0x1f2fb/0x1f4d8 to 0x56b50). This is outside the active AVX2 path on this host, but it is not claimed to be eliminated. No fourth hint was added. The runtime branch and fallback remain supported by the source and correctness checks.

The other recorded indirect calls in native candidate loops are cold length-assertion or bounds-failure paths. SBBF retains its public runtime trait-object dispatch, with per-key calls at 0x1f127/0x1f227. FastPattern, Fastbloom and Bloomsday remain unchanged public controls.

These observations establish a changed compiler path, not a speedup. Inlining changes instruction scheduling, constant placement, loop unrolling, register pressure and code size in addition to removing calls. The source's bulk routing is unchanged, but its generated code can still move, which is why the proposed experiment includes original-batch regression controls.

The earlier batch1-only preflight and executable are preserved under `batch1-preflight/` and `/tmp/fastest-bf-rust-leaf-inline/batch1-preflight/compare_benchmark`. The final harness only relaxes its original-batch CLI restriction to permit the prespecified 3/31/4096 guards; its visible modes still process the entire input array through public singleton APIs. No native hint, mask, backend or allocation changed between these two preflights.
