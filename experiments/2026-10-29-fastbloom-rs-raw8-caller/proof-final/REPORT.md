# Public raw8 actual-caller correctness proof

The fixed normal/ASan preflight passed on its first attempt: four executables,
12 focused test invocations, 122 tiny caller rows and 12 expected invalid CLI
rejections. No formal accuracy or performance matrix ran, and no tiny timing
value is used to select a configuration or claim a speed advantage.

The frozen caller source is `d23791243dabdda85a8ff2eb11ce2d9b3e5a6b47`;
the executed driver is `efb5142fdc3e5cb62d68004b1f8ca1d75bd8728e`.
Session13529 completed with exit0 while holding the inherited exclusive
socket1 flock on CPU3. The lease was explicitly released afterward. The
unchanged producer metadata remains in
[validation-v1](../validation-v1/metadata.json); its original
`manual_assembly_review_pending` field records the state at capture time.
This additive report and [ASM_REVIEW.md](ASM_REVIEW.md) close that review.

## What passed

Each of the normal and ASan profiles ran these six focused tests:

- All21 retained public common-hash adapters match full dense public outputs,
  inserted keys, offsets, tails, guards and invalid-length behavior.
- All24 new public probe counts match an independent u128/per-bit bitmap
  oracle at two small construction sizes and three budgets (144 constructions
  per profile). Complete bitmap bytes, raw8 little-endian inputs, duplicates,
  collision cases, inserted positives, lookup tails and immutability are checked.
- Twelve empty public constructors per profile cover both formal sizes,
  actual16/24/32bpk and K1/K24. Allocator accounting checks actual backing;
  these allocate at most one128MiB bitmap at a time and do not insert a large
  input or establish throughput.
- A real allocator observer checks required scratch allocation and release,
  complete-build/insert-only boundaries, canonical-build scratch destruction,
  and zero allocation for the direct API's zero scratch requirement.
- Both skipped-last-write and wrong-value faults fail after valid warmups in
  both query contracts. Poisoning happens outside the timer and prevents
  inherited correct output from hiding a skipped write.
- The two-phase seeded schedule balances positions over four repetitions.

The actual caller ran all45 APIs with query batch31, plus eight fixed APIs at
batches1 and4096, for61 rows/profile. Every row uses n128, requested24bpk,
q4096, seed42, independent insertion batch31 and cal4096. Complete outputs,
guards, checksums, raw-domain hit/negative classification, geometry, phase
order and trial fields passed; semantics agree across query batches and
normal/ASan modes. Calibration here is a small correctness fixture, not a
formal FPR qualification.

Per profile, unknown/duplicate/empty filter selections require exit2 and their
specific diagnostic; negative/overflow seed and zero insertion batch require
exit101 and their specific panic message. A generic nonzero exit, signal, or
sanitizer diagnostic cannot count as an expected rejection. Successful caller
stderr equals the pinned upstream SBBF backend information line exactly.

## Actual source and binary binding

The initial86 source artifacts and additive12 driver artifacts stayed unchanged.
Cargo metadata binds all34 packages and the final lock
`fcc2015371e2c3e6592877f75ce3ac4c3e86f29e2c4fbb5e5fe9b9121cf0cf9d`.
The package lock retains all13 common packages from the prior caller unchanged.
The new caller and upstream dependencies are explicitly recorded; no unused
upstream package was manually stripped.

For each profile, test `--no-run` and caller compilation finish first; structured
Cargo executable/package/manifest identities and every actual dep-info rule are
checked before any test or filter runs. The observed closures contain380 normal
and387 ASan input files, including the actual native K12, upstream Bloom/bit
storage, raw adapter, reporter and test sources. The prepared closure also pins
all31 external source trees (1856 files). All final actual input, binary,
toolchain and source hashes passed again after execution.

The normal caller SHA256 is
`c7aa0e69cac551e177c4cc68ea9d4e190490dd312f9921a52989007519b7a6df`;
the ASan caller SHA256 is
`1cfe697ce59c307b6e95c6d322da761800182f9f685d5614a09cb4169dab0467`.
Both test executable identities, all50 command records,68 captured dep-info
rules and complete stdout/stderr are retained. No executable is committed into
the source repository; its exact path and digest remain in the freeze.

## Contract and limits

These are original raw u64 keys. The new library receives their eight
little-endian bytes through public Membership methods. Its real hash and probe
work stays inside the raw operation; native/prehash controls execute the common
hash within that operation. There is no identity-copy phase and no misleading
prehash-only ranking column. Compiler-permitted early exits and shared bodies
remain observable costs, without forcing extra hash evaluation.

The two query contracts are raw batched public API and raw visible public
singleton loops. The two construction metrics are raw insertion after readiness
and `allocate_filter_and_scratch_raw_insert`. The latter includes required hash
scratch allocation/initialization and filter construction. Build scratch is
released after validation, canonical scratch dies before queries, and direct
raw8 APIs receive no unused hash buffer. Caller workspace bytes are reported
separately from actual filter backing bytes. Insertion batch remains independently
configurable; a4096 CLI default is not an empirically selected optimum.

This closes bounded correctness, allocation and actual code-generation review.
It does not authorize the proposed262-geometry/786-row formal matrix, qualify
its accuracy, compare throughput, or establish external leadership. A later
formal protocol must freeze workloads, insertion batching and all measured
configurations before data, retain quality failures, and use the proven binary
or separately validate a changed actual caller.
