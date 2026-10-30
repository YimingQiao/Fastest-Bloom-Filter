# One K12 whole-line insertion candidate

This is source-only preparation. No compiler, Bloom filter, accuracy workload or timing has run for this candidate. It is an isolated experiment; production and every earlier measured source stay unchanged.

The hypothesis is narrow: replace the sixteen scalar word ORs for a four-key AVX512 insertion group with four sequential 64-byte line load/OR/store operations. Mask generation, address generation, prefetch distance, dispatch, scalar remainder, capacity and every query path stay unchanged. `derive.py` reconstructs both headers from immutable source `2263cf29ebc87d589b49ca015133312993b7db73` and checks that reversing this one insertion change restores the renamed control exactly. `CHANGE.patch` is the complete control/candidate difference.

For one key, the four word indices are in quarters 0–3, 4–7, 8–11 and 12–15 of the same line. They are therefore distinct and increasing. A mask with those four positions makes `maskz_expand_epi32` consume the four low input dwords in the correct order; the undefined upper portion of the 128-to-512 cast is not consumed. Clearing the low four index bits identifies the start of a complete, 64-byte-aligned allocation line. Each key finishes its line read/modify/write before the next key begins, preserving duplicate keys and different keys sharing a line or word. This relies on the existing single-writer or exclusive whole-line ownership contract. It introduces no atomic or concurrent-writer behavior.

The new operations require AVX512F: `VPEXPANDD`, 512-bit load/OR/store and a 128-bit mask load. They add no AVX512VL requirement. This is a source-level ISA assessment until the minimal-F build and actual assembly are checked. The unchanged two 64-byte temporary arrays remain stack storage; no new heap allocation is introduced.

Fewer stores do not establish a speedup. The candidate builds a destination mask from four indices, transfers it to an opmask register, expands the masks and writes the complete line. Those costs, store forwarding on shared lines, or compiler scheduling can outweigh any reduction in store instructions. The compiler may also choose a different instruction sequence. Actual assembly and complete build timings, rather than an instruction-count prediction, decide whether to retain it.

The fixed first screen has eight workloads and sixteen filter rows: two sizes (65,536 and 33,554,432 inserted keys), exactly 24 actual bits/key (192 KiB and 96 MiB), public insertion chunks of four or the complete input, and seeds 5011/6011. Five fresh builds per prehashed and common-hash contract use the existing K12 shared harness clock boundaries. It retains insertion-only and allocation-plus-insertion medians and every trial vector. Complete build time has priority over a faster insertion subinterval. Query results serve as semantic controls; this stage makes no query-speed, new FPR, external-ranking or multithread-scaling claim. See `protocol.json` for the finite ledger and the limited correctness gate.

The shared harness's build order is prehashed then common-hash on every repetition, and its source-derived filter shuffle is preserved and recorded. This is a bounded training screen, not a balanced paired-inference experiment. It must report every cell and regression; no seed, chunk, threshold, dictionary or prefetch search follows a loss. Any useful result needs a separately frozen confirmation before a production recommendation.

The next implementation stage will add the two-type shared caller and focused checker without editing these frozen source-proposal artifacts. It will retain the public insertion calls and existing timer boundaries, append build trial vectors outside the clocks, and verify all compilation inputs and actual bitmap allocation. Compilation and execution require a separately granted whole-socket lease; neither is authorized by this source proposal.

Reproduce the source derivation only with:

```sh
python3 experiments/2026-10-29-k12-line-or/derive.py
```

Both headers retain the project's original algorithm and allocator attribution through their pinned source provenance. This change does not copy an external insertion implementation.
