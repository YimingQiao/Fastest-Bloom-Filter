# Optimizer-visible single-key API throughput

Validated isolated harness, frozen before any performance matrix. No performance claim.

This track appends two measurements to the existing batch-count-one harness:
`inline_lookup_ns` and `inline_hash_lookup_ns`. The whole-query loop is a separate
non-inlined function, but each public `Lookup(1, &hash, &answer)` call has a
compile-time constant length and an always-inlined wrapper. Boost instead uses a
local `ScalarContains(hash)` shim forwarding directly to its unchanged public
`may_contain(hash)` API. The shim matches that upstream method’s
`BOOST_FORCEINLINE` annotation. All candidates get compiler visibility; assembly
establishes whether each nested public method actually inlines. The wrapper alone
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

## Final preflight and reproduction

The final executable is `../../build/inline-single-v2-direct-full/benchmark`.
`registry.json` lists all 60 names observed in seven complete semantic checks;
it contains no selected performance results. `freeze-v2-direct.json` freezes the
source inputs, registry and 12 final binaries. `source-inventory.json` identifies
the active sources, evidence and retained earlier builds.

Run from the repository root, preserving earlier build directories:

```sh
flock /tmp/fastest-bf-socket0.lock python3 experiments/2026-10-29-inline-single-query/validate.py
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-inline-single-query/audit_v2_direct.py
```

Native18 and ASan+UBSan18 each pass the unit contract and seven CLI workloads
(126 rows each). Full60 passes the unit contract and seven CLI workloads
(420 rows). These cover requested 8/16 bits per key, 0/50/100% hits, complete
four-trial phase balance, one common schedule across candidates, summary/trial
consistency, raw-only NaNs, full outputs and guards, both late-answer corruption
targets, invalid selections and invalid batch sizes. Logs and command outcomes
are in `v2-direct-*.log` and `validation-v2-direct.json`. Timings produced by these
small correctness cases are not benchmark evidence.

The final assembly audit retains all 120 raw/prehashed outer functions in
`assembly-v2-direct/`. All 38 Boost outer functions inline the local shim and
upstream one-key API; none calls the adapter’s `Lookup` or `ScalarContains`.
The remaining 12 functions with calls invoke genuine FastFilter classical Bloom
`Contain` methods. That upstream boundary remains unchanged. The audit also
verifies every frozen final source/binary and all retained V1/unforced-V2 binary
hashes. These observations describe this compiler/native build; no portable
code-generation guarantee is implied.

## Preserved intermediate evidence

`preflight-v1/path-map.json` maps original paths to archived initial sources,
transitive non-system dependencies, logs and all-loop assembly. It records the
12 original `build/inline-single-{native,asan,full}` binaries retained in place.
This version had six Boost `Lookup` callsites in the visible track.

`preflight-v2-unforced/path-map.json` preserves the next version and its 12
`build/inline-single-v2-{native,asan,full}` binaries. Its correctness checks all
passed, but the assembly audit rejected six remaining calls to the unforced
local `ScalarContains` shim. Those sources, logs and assembly remain intact.
External dependencies are shared with the V1 archive and pinned in its manifest.
For old-source reproduction, restore files using the corresponding path map;
the top-level active sources are now the final direct-shim version.

The final change is shown in `boost-direct.patch`. Removing its exact four-line
addition reproduces the frozen upstream-facing adapter byte for byte, as recorded
in `boost-direct-proof.json`; its constructor, insertion and original batch
lookup are unchanged. Only the local forwarding shim is added. No production
header, upstream core, storage layout or benchmark candidate registration changed.
