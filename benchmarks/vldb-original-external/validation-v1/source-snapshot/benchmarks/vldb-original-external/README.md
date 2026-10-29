# Original VLDB public API baseline

Correctness-stage source is prepared. **No compile, calibration, timing or memory
ranking has yet been validated.** The source-only design remains
[the design note](../../experiments/2026-10-29-vldb-public-api-adapter-design.md).

The isolated exact pins are reproduction
`0d2fe8e72496909cdac73c914e8f1a3dd956ac7f` and its DTL gitlink
`c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`. `source-lock.json` records all394 DTL
file hashes; `verify_sources.py` checks the unchanged commits, trees, URLs,
gitlink and file contents without editing the dependencies. Historical local
working trees are untouched. Original license files are retained.

`ArtifactPublic` calls the original `dtl::bbf_32`/`dtl::bbf_64` PImpl API.
`DirectDynamic` separately calls the public std::function wrapper; `StaticLogic`
separately calls its public named alias. No private implementation is extracted
or substituted. Public force-unroll setup is sequential and checked immediately
after construction; Configure is rejected while an older same-word PImpl object
is alive. No call to tuning benchmarks or persistence is made.

Raw keys are u32 values generated through a seeded permutation of checked,
disjoint insertion/negative/calibration counter domains, never truncated from
the existing u64 stream. Native controls widen them and apply the common64 hash
inside raw insert/query calls. The artifact keeps its own hashing. This is a
separate raw-u32 workload with no artifact pure-prehash claim.

[SCRATCH-AND-ALLOCATION.md](SCRATCH-AND-ALLOCATION.md) explains the independently
reviewed exact-n physical compact capacity and the separate allocation audit.
The ordinary correctness target uses exact guard-ended input, compact and dense
buffers, checks complete output and bitmap equality between the public surfaces,
and tests U0/U1/U2/U4 query boundaries. The allocation-only target distinguishes
bitmap padding, owned control heap, shared setup, file mappings and metadata.
Its prefix tracker is excluded from ordinary ASan/UBSan and all future timings.

CMake compiles the two PImpl sources, all ten explicit word-count instantiation
units, calibration-data and platform support. It uses system Boost headers and
the pinned bundled libdivide headers, links Threads/dl, and leaves optional NUMA
and FAST_BUILD disabled. Native, AVX2 and scalar options are explicit; upstream
implementation files remain unchanged. Instantiation may be expensive, so the
lease-gated driver is the only intended build/check entry point:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 benchmarks/vldb-original-external/validate.py \
  --lease socket0 --cpu 2 \
  --output-dir benchmarks/vldb-original-external/validation-v1 \
  --build-root build/vldb-public-preflight-v1 \
  --backends native
```

Use a new output/build archive for later backend or sanitizer passes. Adding
`--with-sanitizers` also tests the uninstrumented ASan/UBSan executable; the
instrumented accounting executable is deliberately omitted from sanitizer
configurations. All command logs and failures are retained. The driver records
and preserves an existing tuner file and rejects source drift. It records build
wall time only for diagnostics, with no query-throughput measurement.

Concrete pending blockers are the first pinned-source compile/link, execution
of exact-capacity guard tests and heap/mapping accounting, and the remaining
backend/sanitizer checks. Only after those pass should a frozen raw-u32 accuracy
and performance protocol be designed. No throughput executable exists here.
