# V3 entry preconditions: CPU3 screening

V3 remains an isolated experiment and is not promoted. It removes only the private bulk method's duplicate length assertion and unreachable singleton branch, retaining `debug_assert_eq!`/`debug_assert_ne!` preconditions. The public inline entry still validates output length before any write and handles a singleton via the existing public membership method. All other bulk kernel source remains unchanged. `v3-entry.patch` compares the exact source change with frozen V2.

This stage runs on CPU3/socket1, after an explicit lease release, under the shared socket1 flock. All original/V2/V3 controls run in the same process. **Do not compare absolute CPU3 timings with previous CPU2 stages.** The fixed screen uses key counts 2^16/2^25, requested 8/16 (actual 16/32) bits per key, batches 1/3/4/8/31/4096, seed 42, query power 22, five repetitions, full insertion and calibration power 24. It completed 24 workloads / 144 rows with exact family bytes, query checksums and calibration counts. Source/binary hashes remained unchanged.

Six focused tests pass in each normal, `disable-avx512`, and AddressSanitizer build. The tests retain all prior native/external controls, add V3 full-output and guard comparisons against original and V2, and verify mismatched lengths panic before writes. An eighteen-row all-registry semantic smoke also passes; smoke timings are unclaimed. Both V3 singleton wrappers still have zero callee-saved pushes, verified by their named private-bulk fallback and archived assembly.

The following are original/V3 speedup ratios from this single-seed screen. Every V2 row is retained, and `v3-guard/v3-versus-v2.csv` compares V3 directly with V2 in this same executable.

| Keys | Actual bits/key | Batch | Byte pure | Byte hash + query | Split pure | Split hash + query |
|---:|---:|---:|---:|---:|---:|---:|
| 65,536 | 16 | 1 | 1.316× | 1.176× | 1.096× | 1.103× |
| 65,536 | 16 | 3 | 0.945× | 0.937× | 1.001× | 1.000× |
| 65,536 | 16 | 4 | 0.979× | 0.994× | 1.043× | 0.992× |
| 65,536 | 16 | 8 | 0.977× | 0.991× | 0.983× | 1.003× |
| 65,536 | 16 | 31 | 0.990× | 0.987× | 1.009× | 0.996× |
| 65,536 | 16 | 4096 | 1.001× | 0.986× | 1.002× | 0.966× |
| 65,536 | 32 | 1 | 1.332× | 1.173× | 1.092× | 1.104× |
| 65,536 | 32 | 3 | 0.945× | 0.939× | 1.000× | 1.000× |
| 65,536 | 32 | 4 | 0.935× | 0.992× | 1.037× | 0.994× |
| 65,536 | 32 | 8 | 0.973× | 0.990× | 0.988× | 1.002× |
| 65,536 | 32 | 31 | 1.008× | 0.984× | 1.018× | 1.000× |
| 65,536 | 32 | 4096 | 1.002× | 0.996× | 1.000× | 0.997× |
| 33,554,432 | 16 | 1 | 1.001× | 0.984× | 1.154× | 1.018× |
| 33,554,432 | 16 | 3 | 1.009× | 1.033× | 0.968× | 1.005× |
| 33,554,432 | 16 | 4 | 0.980× | 1.030× | 1.042× | 1.021× |
| 33,554,432 | 16 | 8 | 1.027× | 1.006× | 1.006× | 0.997× |
| 33,554,432 | 16 | 31 | 1.045× | 1.012× | 0.992× | 1.002× |
| 33,554,432 | 16 | 4096 | 0.993× | 0.996× | 1.002× | 1.000× |
| 33,554,432 | 32 | 1 | 1.100× | 1.006× | 1.175× | 1.019× |
| 33,554,432 | 32 | 3 | 0.965× | 0.996× | 0.994× | 0.993× |
| 33,554,432 | 32 | 4 | 0.974× | 1.009× | 1.003× | 1.004× |
| 33,554,432 | 32 | 8 | 0.962× | 0.976× | 0.987× | 0.987× |
| 33,554,432 | 32 | 31 | 0.982× | 0.998× | 1.009× | 0.999× |
| 33,554,432 | 32 | 4096 | 1.006× | 1.005× | 1.000× | 0.997× |

V3 does not clear Byte's short-batch guard: small batch 3 hash plus query remains 0.937–0.939× and pure query approximately 0.945×. Split's small batch 3 guard improves to approximately parity, but one small batch 4096 hash-plus-query case is 0.966×. The single-seed large Byte singleton actual 16 case is also weak (pure 1.001×, hash plus query 0.984×); no stronger claim is made from other cases. Deleting checks does not establish an instruction-level explanation for the result: compiler range facts, function shape and caller code generation may also change.

Keep the full original/V2/V3 results unchanged. No new external held-out run or production integration is warranted from this screen. A future small-length public-entry policy is a separate hypothesis and has not been implemented here. The complete original native source is still archived in `native-before/` and pinned to git `c4b6a08`; old stage manifests and binaries are preserved.
