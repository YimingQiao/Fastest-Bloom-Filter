# One direct-lookahead bulk candidate

Proposal only: no candidate header, production change, compiler invocation or filter run is made here. Keep the completed queue192 evidence unchanged. That screen failed its full target: large4096 beat original range8/8, but split4/4 against both the external and production envelopes. The remaining pure-query losses and small/short-call costs motivate this one experiment; they do not establish a cause.

## Actual loop and proposed tradeoff

The proved native queue generic helper is0x29880/1390B in normal ELF SHA27668c987456fe9ad3ca1c87313309035e96a6f7b7a600bdf530357bd8096f75. It pushes R14/RBX and reserves0x88 bytes before the n>=128 branch. Its source256B index array also uses128B of the red zone. Fill writes indices at0x298b0/0x298cf/0x298ee/0x2990d; steady iteration reads the saved slot at0x29997, loads h[i+64] at0x2999c, replaces the slot at0x299b4 and prefetches at0x299c0, then loads the saved bucket at0x299c9 and rereads h[i] for the VBMI mask at0x299cf. The second unrolled key repeats this sequence. Tail consumption still masks an index and reads its slot. These are observed instructions, not a stall decomposition.

The control generic body is500B without that stack prologue. The queue's short-call frame is real even when the source takes its original fallback. The completed screen also retained small4096 regressions and generic-singleton costs. Removing the source array might reduce stack/register/index work and code size, but only new actual ASM can establish what the compiler emits; no stack-free or short-call improvement is assumed.

The single candidate keeps fixed lookahead64, threshold128, AVX2 compile-time dispatch and T0 read prefetch. It removes LookupPrepared and the ring. Every current key uses the original LookupOne unchanged, including its address calculation. The exact proposed helper replacement is:

```cpp
#if defined(__AVX2__)
void LookupPrefetched(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
    for (size_t j = 0; j < 64; ++j) {
        const uint32_t next = Block(hashes[j]);
        _mm_prefetch(reinterpret_cast<const char *>(buckets_[next].words), _MM_HINT_T0);
    }
    size_t i = 0;
    for (; i < size_t(n) - 64; ++i) {
        const uint32_t next = Block(hashes[i + 64]);
        _mm_prefetch(reinterpret_cast<const char *>(buckets_[next].words), _MM_HINT_T0);
        out[i] = LookupOne(hashes[i]);
    }
    for (; i < n; ++i) out[i] = LookupOne(hashes[i]);
}
#endif
```

The existing Lookup dispatch remains `if (n >= 128) { LookupPrefetched(...); return n; }`, followed by the original loop. A new isolated class/bucket name, `Independent32RangeDirectPrefetch64BloomFilter`, allows all three public implementations in one caller. No inline/noinline attributes, new ISA, mask refactoring, capacity policy, distance sweep or unplanned fallback is introduced. Block, Mask, LookupOne, ContainsHash, insertion, constructors, allocation and scalar fallback remain exact apart from required type names. The queued and original controls retain their frozen source bytes.

For each n>=128 call, both versions issue exactly n source-level prefetch operations:64 initial plus n−64 future requests. Both reference input hashes2n times at source level. The direct version evaluates Block2n times (n for prefetch and n inside LookupOne), versus n in the queue: n additional high24 multiply/reductions. It removes n uint32 queue stores+n queue loads (8n source-level bytes of stack traffic), ring-slot indexing and the256B source array. This does not assert an equal change in emitted loads or cache traffic. The recomputed current address remains dependent work before the current bucket load; extra integer multiplication/shift pressure can outweigh the removed bookkeeping. Prefetch coverage, mapping and requested distance are fixed, but actual instruction scheduling, register use and unrolling may change together.

## Bounds and semantic invariants

n>=128 guarantees that all initial64 hashes exist and n−64 cannot underflow. The steady condition gives i+64<n; it prefetches each index64..n−1 exactly once. Current keys0..n−65 are queried in the steady loop, then exactly the final64 keys are queried in order without another prefetch. n128, n129, nonmultiples, repeated buckets and two buckets sharing a64B line all use the same rule. `size_t` indices are safe for the existing uint32 input count. n0/null and n<128 keep the original path.

Block's existing high24 multiply/reduction remains within the same actual bucket allocation; its product remains below2^47. Every address passed to prefetch is valid for the live bitmap. Probe bits, byte budget, allocation lifetime and dense output count/order do not change. No queue allocation is replaced by hidden caller scratch. The new/queue/range mappings must match full bitmaps and complete output during proof; formal fingerprints/calibration identities must agree within each same-input process. This is not a new accuracy search.

## Bounded proof and comparison

After source review, derive one isolated header and minimally adapt the current actual caller. Reuse its common hash, generic/visible helpers, literal timing block, full-output/immutable-input checks, public external factories and exact geometry. One caller per native VBMI, explicit AVX2 and native ASan profile covers only the changed path. Reuse the current independent-oracle fixtures:648 calls per direct/range arm/profile,360 requests with n>=128 and four extra null0 calls; non-saturated mixed queries, first/last buckets, duplicates, offsets and threshold/tail lengths remain. The old queue receives actual caller parity checks as a retained control; do not rerun an old broad kernel matrix. Final tiny-row/allocation/reference counts are to be fixed with the actual caller before compilation.

Actual native and AVX2 ELF review must inspect the direct generic helper and any outlined target, both sides of threshold128, entry/exit frame placement, current/future range computations, valid prefetch coverage, dense stores and timer boundaries. Review direct/queue/range visible bodies too. Removing the array is not proof that the short prologue disappears. Capture the actual new caller's code; prior addresses cannot stand in for it. Any unexpected codegen is disclosed, not repaired by hints or another candidate.

Use one new same-execution panel:18 points (10 small/8 large),24 processes/216 rows, n16/n25, q22, hit50, batches1/31/4096, eight trials, the same two explicitly seen seeds982451653/961748941 and two complete reverse launch/API rounds. Each size contains direct12, queue12, original range12 and all four production layouts at actual16. Keep every previous external point: small Fixed16@16, SingleV1@16 and SingleV1@14; large BoostMulti32K8@12 with50331647 actual backing bytes. No historical latency is imported or normalized.

This yields576 vectors/4608 values. Round1/b1 alone records36 fresh cal26 API/construction observations, with26 known mapping groups after the three-way range alias and equal-byte Fixed16 alias;180 rows reuse exact identities without pooling. Actual<=16bpk and both-seed pointwise1% Wilson eligibility apply to external/production envelopes and qualified primary comparisons. Never reuse the old screen's qualification as current evidence.

The large4096 target has32 comparisons: eight each versus the queue, original range, strongest eligible external and strongest eligible production, covering both generic contracts and every seed×round. Require eight strict wins per group; tie/loss/no qualifier fails that group. Retain128 direct/queue and direct/range control ratios unconditionally,128 external/production envelope comparisons, all216 rows, all576 vectors and all288 within-input round pairs. Report every small/b1/b31 regression and unchanged-source visible result, without treating trials/rounds as independent evidence. No new build, Rust, parallel or automatic-promotion claim is proposed.

Evidence anchors: core6981a9139f6b10785036dd6a43c398a337cfce09; actual callerac71d43cc64eb75edfc1a490f0429c4be6003c8a; proof9563af240b0536a033659aa07cbdeeb440442c09; completed raw32ef10863857b95404be44cd4fc645b6755141a2; calculation8d672c5b3eb3ef96f806eb3b4783b7a22bf39b84 and complete-only loaderba2c6f2351bd785b7ba9d71515ac7864947e5bf5. The existing [actual native queue span](../2026-10-30-independent32-range-prefetch64/caller/validation-v1/041-normal-asm-5.stdout) and [complete report](../2026-10-30-independent32-range-prefetch64-analysis/report-v1/REPORT.md) are evidence, not inputs to future timing/quality values. Root owns shared documentation. No existing source or result is edited by this proposal.
