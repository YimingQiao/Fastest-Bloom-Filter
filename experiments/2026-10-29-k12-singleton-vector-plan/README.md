# One C++ K12 singleton SIMD candidate — source only

The recommended next candidate replaces four scalar sector reads with one aligned 64-byte line load and a register permutation, then forms the four existing masks with a register dictionary lookup and variable rotations. It changes only public `ContainsHash` and AVX512 `Lookup` for lengths1–3. `LookupScalar` remains the original oracle; insertion, allocation, mapping, all paths for lengths>=4, AVX2/scalar lookup and parallel ownership remain byte-identical after removing the documented class rename. This stage has no compiler, Bloom-filter execution, ASM result or performance evidence.

`derive.py` reads the actual optional native C++ header at36979eb4439abce1977accb505053f7b5fa74b1a, copies its two local dependencies and MIT license unchanged, and produces the one candidate plus `CHANGE.patch`. Its exact reverse assertion restores every original byte. The renamed friend declaration has no new implementation. The existing authors retain attribution in `LICENSE`. No early-reject candidate or Rust SIMD variant is generated.

## Why this one candidate

The scalar implementation already reads four words in the same cache line. The proposed SIMD implementation also fetches one cache line; it does not reduce the number of cache lines touched. Its hypothesis is lower load/mask instruction cost with a branchless membership test. The costs are two register permutations, shifts/rotations, broadcasts, constants, a wider load and possible register pressure. Which instructions can be hoisted or folded is an actual-caller ASM question.

A first-sector early return would avoid three masks and loads for some absent keys, but not the first cache-line fetch. If the absent first-sector pass probability is p and true-hit fraction is h, its pass branch frequency is h+(1-h)p. At50% hits the branch may be difficult to predict; at100% hits it saves no remaining work. Do not infer p by taking the fourth root of whole-filter FPR: shared block occupancy and masks can correlate. No previous K12 first-sector early-reject experiment was identified; the earlier two-inline-hint and SingleLine experiments changed public-call code generation and line borrowing, respectively. They did not test this rejection order. The choice here is a source-level hypothesis, unrelated to any partial Poppy data.

## One fixed instruction arrangement

The scalar physical-line calculation remains `Block(hi)`; it is evaluated once. All four sector offsets belong to that allocated line. An aligned `load_si512` is valid because the existing allocator aligns to64 bytes and each line contains16 allocated u32 words. Immutable concurrent readers remain safe under the original contract; concurrent insertion is not added.

One broadcast of hi is reused by the local-index expression:

```
quarters XOR ((hi XOR logical_shift_right(hi,[32,2,4,6])) AND 3)
```

The quarter values are0,4,8,12. VPSRLVD with count32 yields zero in the first lane; therefore that lane preserves hi&3. The other lanes exactly reproduce the original base-offset XOR sector offsets. Repeating these four lanes only initializes the unused upper lanes; membership compares the low four. No scalar C++ shift by32 is used.

The low32 hash broadcast is rotated right by[0,8,16,24]. VPERMD's low4-bit index selects the existing16-entry dictionary without another AND. VPROLVD's low5-bit count rotates that dictionary word by `(code>>4)&31`, again without another AND. The second VPERMD selects the four line words. The final AND/equality mask tests only those four lanes. `mapping_oracle.hpp` independently reconstructs the dictionary from bit-position triples and uses explicit scalar masks/shift bounds.

All intrinsics in the new helper are AVX512F intrinsics; no128/256-bit masked operation, extract, AVX512VL, DQ or BW requirement is introduced. The installed Clang23 `avx512fintrin.h` definitions were inspected, but a future minimal-F compilation and actual instruction capture are still required. There is no forced-inline annotation, new runtime feature dispatch or instruction-count claim.

## Actual public boundaries

The C++ header uses compile-time `__AVX512F__` and in-class ordinary inline methods. Public `ContainsHash` delegates to the new helper only in that build; AVX512 `Lookup`'s existing n<4 branch invokes the same helper per key. In a non-AVX512 build public singleton falls back to the original `LookupScalar`, and AVX2 batch behavior is unchanged. A future caller must exercise these actual public methods. It may not call the private helper or remove the generic batch boundary. Both generic batch and optimizer-visible public singleton must be reported separately.

The current native Rust K12 keeps ordinary-inline `contains_hash`/`contains_scalar`, with one safe line borrow and four branchless tests. A new Rust SIMD singleton would add a runtime backend selection and target-feature helper boundary; its setup/call costs might differ materially from this header implementation. Rust is deferred, not silently treated as equivalent. The previously tested two-hint candidate is not reused.

## Bounded proof and proposed performance controls

Before any measurement, normal, AVX512F-without-VL/DQ/BW, and ASan/UBSan callers must compare both public entrypoints against unchanged `LookupScalar` and the independent per-bit oracle. Cover all256 offset bytes, each dictionary/rotation position, empty/full/partial filter words, first/last and non-power-of-two lines, lengths0..7 plus31/4096, input offsets, output guards, inserted positives, and a negative constructed by clearing one required bit in each sector. Null input/output is permitted only for n=0. Full bitmap equality after the same inserts demonstrates no insertion change. Reuse existing native ownership proofs; no new multithread speed matrix is proposed.

Actual normal/minimal-F ASM must identify both public caller paths, the one line read, dictionary/word permutations, rotations and comparison, and retain the generic dispatch boundary. Check calls/spills/setup honestly; compare unchanged >=4 paths after address normalization, disclosing layout differences. A compiler may transform the source, so intrinsic spelling alone is not proof of an instruction sequence. Failed builds/captures remain archived; no tuning variants are inferred from them.

The proposed fixed performance ledger is96 processes/192 rows: n16/n25 at actual24bpk, hit0/50/100, batches1/3/31/4096, two prespecified input seeds and two opposite launch rounds. All cases retain generic prehashed and staged common-hash query tracks. Batch1 additionally retains actual public `ContainsHash` optimizer-visible prehashed and fused-common tracks; those contracts are never combined into one ratio. This gives240 paired metric contrasts,480 total trial vectors and3840 metric samples. Larger batches are unchanged-path controls, not extra opportunities to select another kernel. Eight balanced phase repetitions retain all dense outputs, all timings and every loss. Round1 fixes A/B positions after original job shuffling; round2 reverses the entire48-case ledger and each A/B order without changing workload RNG. Every same-input case therefore sees both orders. No calibration is introduced between rounds, but their environment histories differ; the round contrast is not independent causal evidence for order alone. Exact seeds, orders and case ledger are in `protocol.json`.

This is a same-mapping implementation comparison, with identical bytes and exact dense answers required. It makes no new FPR, external-leadership, Rust or thread-scaling claim. No quality-driven seed selection, first-sector rejection alternative, threshold search or expanded matrix is authorized. A gain only in visible-single and a loss in generic1 must remain separate. The source proposal awaits parent review before an actual caller or any CPU lease.
