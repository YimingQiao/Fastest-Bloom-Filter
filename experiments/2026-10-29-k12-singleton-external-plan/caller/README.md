# Actual public caller: source preparation

This additive caller implements the approved616-row proposal61f0689. It has not been compiled or executed. The proposal's ten committed blobs remain unchanged. No performance is authorized by this directory.

`derive.py` reconstructs exact current native headers, both frozen K12 headers and the exact-capacity external adapters from immutable commits. Boost adds only the already-proved `ScalarContains` facade; its constructor/Insert/Lookup are otherwise exact. Public visible traits select public ContainsHash, then the proved public ScalarContains, otherwise public Lookup(1). They never use a private query kernel. Generic lookup and whole-array visible loops retain the earlier attributes and bodies. `main.cpp` is generated from `main.in.cpp`; its complete phase/timing/switch block is copied byte-for-byte from the already-proved singleton caller2c85beb. `MAIN.patch` exposes all outside-clock changes.

There are19 real statically typed filter implementations and64 geometry jobs. A coarse typed function pointer selects each whole Run outside its clocks. Each Run allocates one canonical bitmap, inserts the complete real-n data, validates the exact backing/logical/unit/probe/constructor metadata, and destroys it before the next job. The new native Range traits change only constructor metadata to report its actual public bpk argument, not a derived byte count. All geometry planning, calibration, poisoning, validation, consumption and serialization are outside clocks. Four query contracts and their hashes/dense writes remain inside the inherited clocks.

The generic caller is shared across geometries of a type; no type erasure is introduced per key or per generic batch. No native inline hint or hot adapter body is changed. Later ASM must disclose compiler inlining, folding, frame and layout differences for the whole panel. The prior candidate/control SIMD versus inline/unroll caveat still applies.

Unmeasured validation has linear work in the data it validates. Each insertion chunk poisons only its `count` output entries and checks every inserted answer, so the complete insertion-validation loop writes/checksO(n), including batch1. Poisoning allq output words inside that n/batch loop would incorrectly createO(n*q/batch) work; this was caught and corrected during source review before any compilation or filter execution. Warmup and timed-query validation poison/check the complete query only once per whole-array phase, costingO(q) per phase. Calibration processes fixed4096-entry blocks inO(calibration_count); input digests and optional bitmap digests are complete linear passes per row. No other unmeasured n/batch loop scans a full query or bitmap on each iteration.

The first primary round uses the public singleton API for the entire fresh calibration stream, common-hashed in4096-key scratch outside clocks. Every returned value contributes to counts and a full-stream digest. Query validation uses a public scalar lookup where available and otherwise the public singleton path. Every timed full output is checked against that complete expected vector. Native K12/control/Range expose public Data and retain byte-level bitmap digests. Other native/external opaque types intentionally report null: no private storage is inspected and no full-bitmap identity is invented. Their deterministic constructor/insertion identities and complete output fingerprints remain checked. Diagnostic hit rates differ, so only insertion/bitmap identity spans hit rates; query fingerprints compare within identical n/seed/hit/batch.

`upstream-pins.json` derives the exact FastFilter/Page/Boost1.92/Rocks source closure previously consumed by committed d70077. CMake uses those existing read-only include roots directly; it does not fetch, configure upstream code, run vendor scripts or include mutable main-tree native headers. All repository dependencies in the new compiler .d must belong to the prepared local or pinned upstream maps. System input paths and hashes are also recorded and rechecked before executable tests and at exit. The actual compiler spelling remains `/usr/bin/clang++`, with its resolved target recorded separately.

## Focused proof proposed for review

The only executable seeds are the already-used74381, q12 and four repetitions. Fresh formal seeds are rejected by correctness modes. Normal, minimal-F and ASan profiles each run:

- All64 exact empty constructor observations at real n16/n25, with actual bytes/probes/units. These are allocation-only; there is no large full-insertion matrix.
- Two opposite-order primary n16/hit50/b1 cases covering all34 small public points, with onlycal10.
- Five native-only diagnostics matching the approved hit0/100 b1 and hit50 b3/31/4096 contracts, nine points each.
- One old seen n16/hit100/b31 native fixture, nine points, to replay the two K12 full semantic records from the original proved caller. The extra hit100/b31 combination is allowed only in correctness mode, never in the formal matrix.

That is122 caller rows and64 allocation rows per profile:366+192 in total, plus six old exact K12 semantic reproductions. No existing9222 per-bit kernel matrix, large native insertion or parallel proof is repeated. Two full-output faults and nine malformed CLI cases must produce exit1, empty stdout and the exact intended diagnostic; a crash is not a successful rejection.

The minimal-F executable keeps AVX2 because unchanged external Fixed32/64 require it. Only the candidate's new512-bit intrinsic requirement is AVX512F withoutVL/DQ/BW; this is not a claim that the whole program uses onlyAVX512F. Normal and ASan use the same host ISA, while ASan usesO1 for correctness.

The driver captures actual normal/minimal-F ELF symbol addresses for19 Run,19 opaque query and38 visible loops, with nonempty first-PC/span guards. Actual public callees and any hot residual calls must be checked before final manual gate approval. A successful disassembler exit alone is insufficient. Proof completion keeps manual_review_pending=true until a separate reviewed evidence record closes that gate. No formal launch is available in `validate.py`.

After exact source review/commit and an explicit socket1 lease only, the future command is:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  python3 experiments/2026-10-29-k12-singleton-external-plan/caller/validate.py \
  --source-commit FULL_IMMUTABLE_COMMIT --execute-correctness
```

The driver refuses existing/dangling-symlink output paths, retains all failure logs, passes the inherited exclusive flock descriptor to every child, and uses explicit CPU3/NUMA1 placement for filter calls. There is no automatic retry, source repair, compilation of an alternative or formal workload.
