# Additive Range shared-query preflight

Source preparation only. No compiler or Bloom-filter executable has run from this additive stage. The original53 artifacts plus their manifest remain unchanged at `63ff706b823791270cefebbbc77601e90d0b8815`. This directory adds an out-of-tree CMake wrapper, untimed full-output/allocation fixtures, fail-closed runner and offline tests. The original timer, executor, 25 registered public APIs and exact-capacity constructors are untouched.

The proposed execution requires a reviewed committed additive freeze and an explicit socket1 lease. Compilers and the parent driver remain on CPU3. Shared-query CLI children first run `taskset -c 3,5,7`, then `numactl --physcpubind=3,5,7 --membind=1`; this expands only the child affinity before libnuma validates its allowed physical CPUs, while the parent stays on CPU3. The CLI checks use the caller plus T-1 spawned threads, with T=1/3. The already-frozen executor and adapter tests additionally exercise T=1/3/8, global batch boundaries and late spawn, affinity and work exceptions. Those untimed thread tests inherit CPU3 and do not make a physical-core scaling claim. All work is held under the same inherited exclusive socket1 flock. No performance matrix or ranking is authorized by this package.

Planned checks:

- Native and AVX2 Clang builds, native ASan/UBSan, and AVX2 GCC TSan shared-reader/executor checks. Upstream public APIs require AVX2; no scalar external-baseline claim is made. Native Range's separately validated scalar implementation stays unchanged.
- All25 current types match complete query outputs at caps16/24/32. Additional untimed fixtures compare225 current cases with216 retained old-public-API cases over n=64/1024/65536. Each fixture checks every inserted key,4097 mixed outputs and4096 disjoint calibration outputs. The current Range family additionally matches Fixed64's equivalent complete outputs; API timing identities remain distinct.
- Twelve complete native Range word/output fixtures reproduce the pinned C++ correctness archive. The tiny fixture source is an exact extraction with only the validated class spelling changed. Normal, AVX2 and sanitizer answers must be identical.
- Eighteen25-row CLI cases per backend: cap16/24/32 crossed with(hit0,batch1), (hit50,batch31), (hit100,batch4096), then T1/3. All vectors, summaries, timing decomposition, raw-only NaNs, geometry, actual bytes, probes, input counts and exact source-derived row order are checked. Four modes total72 cases/1800 rows. They are correctness smoke timings, never ranked. Each current row also matches semantics from225 distinct rows emitted once by the unchanged frozen74-API serial executable; those references contribute no performance evidence.
- Eleven invalid argument/selection/CPU-list cases per backend fail before CSV. The inherited lock guard requires an existing exclusive WRITE lock in fdinfo, not merely an open descriptor. The parent must remain pinned CPU3 while child CLI commands receive their explicit allowed CPU set.
- An untimed actual-construction pass observes350 formal-size geometries: all25 constructors at n=2^16/2^25 and ceilings12/14/16/20/24/28/32. Each bitmap is destroyed before the next. `SizeInBytes()` must equal the arithmetic planner and fit the exact byte ceiling. This observes declared backing capacity, including Boost's counted alignment/padding allocation; it is not allocator usable-size, object overhead or RSS. No insert/query/clock is used. The fixed selection must yield132 distinct grid points plus10 already-selected external points,142 total. It verifies all17 prior external geometry IDs before deduplicating the seven already represented by the grid.

`bindings.json` anchors the original preparation, the immutable serial source/binary descriptor, the12-fixture reference and constructor/API inputs before execution. Extra configure-script/vendor/compiler-conditional Boost headers are pinned too. The runner checks actual `.o.d` consumption: a repository header not in the prepared closure stops the preflight rather than silently expanding it. Compiler versions, complete commands, flags, dependency files and every executable SHA are archived. Failed runs remain in `validation-v1`; source fixes or expanded inputs require a separate versioned follow-up rather than rewriting failed evidence.

Offline tests use only synthetic rows and the old committed arithmetic planner data; the142 count currently means source-level consistency, not executed constructor validation. Run them with:

```sh
python3 -m unittest discover \
  -s experiments/2026-10-29-split64-range-parallel-screen/preflight -p 'test_*.py'
```

After review/commit and an explicit lease:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-split64-range-parallel-screen/preflight/validate.py \
  --source-commit FULL_REVIEWED_ADDITIVE_COMMIT --execute-correctness
```

The future142-row performance protocol remains a separate stage. It must retain direct serial controls, distinguish gated and thread-end-to-end metrics, charge actual capacity, include smaller qualified allocations under each cap and deduplicate reused calibration. Earlier FourSector confidence-bound failures and the later precision-resolution evidence must be reported as such, without treating a finite-sample gate failure as proof of true FPR above the target.
