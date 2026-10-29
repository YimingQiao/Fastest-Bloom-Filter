# Additive v2 compile correction

V1's legacy worker compiled and linked, but the modern worker failed at
`bool(filter_)`: pinned PageBloom provides `operator!()` and `data()`, not a
boolean conversion. No BF case or timer ran. All committed v1 source bytes,
failure logs, and build artifacts remain unchanged.

This retry changes only the PageBloom constructor's allocation check to
`filter_.data()!=nullptr`. `candidate.patch` is the complete C++ delta. Raw4-byte
insertion/query bodies, common hashing, geometry, timers, output checks,
registry, and fixed future screen remain v1-exact.

The native legacy worker is reused byte-exact; its binary, actual original
compile database, dependency file and link command are anchored in `reuse.json`.
The new native build compiles only modern, accounting, and the unchanged
allocation tracker. The ASan build still compiles both workers against the
verified instrumented original archive. No upstream library is rebuilt.

The inherited CPU2 write-lease and new-output/build guards still apply. After
this retry source is reviewed and committed:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 benchmarks/vldb-raw32-stage3/retry-v2/preflight.py \
  --source-commit FULL_RETRY_COMMIT --cpu 2 --lease socket0 \
  --build build/vldb-raw32-stage3-v2 \
  --output benchmarks/vldb-raw32-stage3/validation-v2
```

The same 158 ordinary / 48 ASan worker cases and 18 large-accounting rows are
required; no successful BF validation is skipped. All v1 source inventory plus
this retry's exact inventory must match the requested commit before a compiler
runs. The final ordinary timing worker is the new modern binary paired with the
unchanged reused legacy binary. Correctness approval does not authorize timing.

After success the separate freeze must include this retry's source inventory
and actual compiler-input closure before any screen is authorized.
