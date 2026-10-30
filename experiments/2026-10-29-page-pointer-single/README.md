# Direct raw-byte-pointer Page singleton control — source only

The successful raw32 preflight's GCC assembly shows that all six Page value
facades load a raw u32, store it into a4-byte stack slot, then call the unchanged
public `PageBloomFilter::test(ptr,4)`. Their dense paths already pass the input
array pointer. This caller distinction was identified from frozen assembly
without inspecting partial728 performance values. The existing source,
proof, measured binaries and live728 matrix remain unchanged.

This new experiment keeps four identical native controls and all six Page value
facades, and adds six `PointerSingleV1` aliases in the **same new executable**.
The only change inside a copied Page class is a forwarding member
`SinglePointer(const uint32_t*)` calling the original public `test(ptr,4)`.
Allocation, Insert, value Single, Dense, Prepare and sizing bodies remain exact.
The derived pointer facade has no additional storage, with six compile-time
size checks. Its distinct surface label identifies the singleton caller.

Explicit `Query` specializations change only public_single to pass `keys+i`.
Dense modes retain the same batch-loop bounds and call the original frozen
`DenseCall<Base>` specialization; no private Page kernel or rewritten hash is
introduced. The shared whole-array erased boundary, timers, output validation,
hash/domain generator, masks and native kernels are reused byte-exact. The
new16-row registry replaces the old modern23 registry only in this isolated
caller-control executable; it is not a new overall strongest-filter panel.

Before any throughput, native and ASan/UBSan correctness must cover all16 names,
all-hit/all-miss/mixed streams, full outputs, offsets/tails and native/canonical
Page alias parity. Assembly must show direct input-array addresses for pointer
singletons, without a per-key4-byte stack store. The public upstream test may
remain out of line. Dense branch and native controls are also inspected; every
observed code-generation difference is retained. No compiler lease is currently
granted, and no test/assembly/performance evidence is claimed here.

The proposed fixed comparison uses the same n=2^16/2^25, actual caps12/16/24/32,
q=2^22, hit50, seed42, cal2^24, and six balanced query repetitions. Deduplicate
each API's repeated actual native geometry. One fixed round uses forward alias
order, the other reverse alias order at each size/cap:120 rows per round,
240 total and72 distinct calibration identities. All three modes are retained,
including any unchanged-path regression. Value/pointer and launch-round
calibration is semantic replay, not additional independent evidence.

Compare pointer versus value within this new executable and each round/mode.
Do not subtract native context shifts or present differences from the earlier
modern23 binary as a pointer-only gain. Exact payload/output/calibration parity
against the completed728 archive may be checked, but its old latency values do
not enter this caller-control result. Every loss and quality failure remains.

`bindings.json` anchors frozen ancestor sources; `page-helper.patch` is the
complete change to the old Page class. A bounded driver/provenance freeze is to
be completed after source review, and compiled/ASM-reviewed only on a separately
granted lease after the active728 matrix and its analysis finish.
