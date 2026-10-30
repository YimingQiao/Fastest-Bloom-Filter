# Optimizer-visible single-key API throughput

Unvalidated isolated harness under development. No performance claim.

This track appends two measurements to the existing batch-count-one harness:
`inline_lookup_ns` and `inline_hash_lookup_ns`. The whole-query loop is a separate
non-inlined function, but each public `Lookup(1, &hash, &answer)` call has a
compile-time constant length and an always-inlined wrapper. All candidates get
the same optimizer visibility. Assembly must establish whether the nested public
method and upstream Find/Contain/may_contain actually inline; the wrapper alone
does not guarantee that. This is throughput of one-key API calls and permits
cross-key compiler optimization, not dependent-call latency.

The raw loop computes the existing common hash exactly once per key inside the
loop. PageBloom retains its own raw-byte hash and NaN pure-query fields. There is
one u32 output store per query in every mode. Original batch API measurements
remain separate columns; do not merge their rankings with the new API-loop track.
SingleV1 controls can compile identically to original public paths here and do
not thereby become different algorithms.

The four timing modes use a seed-permuted, four-trial balanced order, identical
for every candidate. Each mode occupies every position once and every ordered
within-trial adjacent pair appears once per four trials. `query_phase_order`
records the exact order (0=old pure, 1=old raw, 2=visible pure, 3=visible raw).
Use repetitions divisible by four for complete balance. Every phase performs
the same checksum/full-output/guard validation outside timing, including the
same volatile consumption; the earlier modes have no extra accumulate pass.

Native filters and external adapters reuse the committed snapshot in
`../2026-10-29-external-parallel-query/snapshot/`. Their original bitmap, insertion,
allocation and FPR behavior are retained. Four independent split-block controls
are added, including the frozen VBMI mask from `f96adea` (only include paths changed).
The complete registration has 60 configurations; the representative build has 18.

Full output equality, dense 0/1 answers, all inserted keys and output guards are
checked outside timing. Every timed phase is validated. Calibration also checks
the visible scalar call against the original public path. Separate fault targets
corrupt the last answer after each new timing mode to verify rejection. Batch
arguments other than one are rejected before workloads run. Before timing, native
and sanitizer validation, full registration checks, and per-family assembly
inspection are required. No production source is modified.
