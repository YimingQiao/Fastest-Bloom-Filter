# Proposed120-row Rust exact-capacity training screen

The unchanged benchmark executable has passed the completed correctness, full-output, allocator and public-codegen preflight in `../PREFLIGHT_REPORT.md`. This directory only adds timing protocol, fail-closed runner and offline guards. It changes no Rust source, compiler option, timed code or native library. Performance requires a separately reviewed committed archive and an explicit CPU3 lease.

The grid is n=2^16/2^25, byte ceilings16/24/32 bit/key, batches1/31/4096, seed42, 2^22 mixed50% queries, eight balanced query trials, eight full-input serial build trials and 2^24 disjoint independent negatives. At16/32 all eight public configurations run; at24 the four distinct Range/external geometries run. Native cap24 aliases actual16 and is omitted. There are18 cases,120 rows and40 family/actual-geometry/size/seed calibration records. These are API-family records, not necessarily distinct hash mappings. No calibration samples are pooled across families, and reuse across batches/modes adds no independent probes.

The four metrics are generic prehashed batch lookup, generic staged common hash+batch lookup, optimizer-visible public singleton prehashed lookup, and optimizer-visible fused common hash+singleton lookup. The latter two loop over the full array regardless of the batch tag. Every trial checks dense results outside timing. Pure and hash builds have separate lifetimes; the canonical validation filter is allocated afterward. Serial insertion-only and allocation-inclusive metrics remain separate. No native parallel or whole-application claim is made.

The runner validates source-derived job order including exact filtered registry before Fisher-Yates, all geometry/probe/ownership fields, four complete trial vectors, medians/ranges, Williams phase order, counts, calibration and cross-batch semantic equality. It rejects incomplete successful subprocesses and preserves each exact raw CSV/stderr before appending validated rows. Final raw/aggregate rows, commands, source/dependency/12-executable hashes and committed blobs must match. It pins the formerly implicit parent dependency descriptor by immutable revision and SHA and checks the current Cargo.lock package/source pins. Source/hash audits are outside timed subprocesses.

Cases remain ordered by size, ceiling and batch; seed42 yields one deterministic per-case filter order. This is training, with no superiority inference across fresh seeds. All losses must be retained. Under cap32 the fastest eligible16/24/32 allocation is eligible; select separately for all four metrics. Earlier FourSector actual16 failures were upper-confidence-bound qualification failures, not proof that its true FPR exceeds0.1%; retain this historical uncertainty when discussing a seed42 pass.

Run offline guards with `python3 -m unittest discover -s experiments/2026-10-29-split64-range-rust-screen/screening -p 'test_*.py'`. They execute no compiler or benchmark.

After review, commit and an explicit lease, the only intended command is:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-split64-range-rust-screen/screening/run.py \
  --source-commit FULL_REVIEWED_COMMIT --execute-frozen
```

The inherited flock descriptor and exact CPU3 affinity are checked. There is no explicit NUMA memory binding. Output goes to a fresh `../screen/` directory; the runner never resumes or overwrites a partial run. `freeze.json` binds all local source/evidence plus immutable external descriptor and C++ fixture; `../ARCHIVE.json` additionally lists the freeze itself and every ignored validation log. Initial source-only manifests stay unchanged. Postprocessing must be separate from this frozen preparation.
