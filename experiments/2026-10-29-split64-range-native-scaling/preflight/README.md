# Focused new-harness preflight

Only normal and ASan versions of the two new C++/Rust harnesses are compiled. Existing native library backend/ownership tests are reused through exact committed snapshot identity. Each of the four executables runs six small cases: n2^16, q2^14, cal2^12, T1/T3, caps16/24/32. T3 therefore exercises three real public build/query workers rather than the tiny-input serial fallback. The24 cases produce40 rows and five distinct semantic geometries; every backend/language/T must match bytes, full checksum, hit/miss counts and calibration.

The row guard independently checks C++ and Rust scratch formulas, caller/coordinator models, spawned-worker counts, exact actual bytes, source-derived family order and all six full trial vectors. Ten malformed CLI cases run only on the two normal executables. Six offline corruption tests cover these guards and argument indices. No new full library suite, external baseline, formal-size calibration or throughput matrix runs here. The tiny emitted times are unclaimed.

The driver requires the exact committed whole-stage preparation, an inherited socket1 exclusive lock and CPU3 parent affinity. CLI children expand to3 or3,5,7 before numactl/membind1. Fresh build/target paths reject existing files and dangling symlinks; failed commands and all logs are retained. Rust executable discovery uses Cargo structured artifact messages. All native Rust dependency .d files and C++ .o.d files are archived, including representative library modules; consumed repository files must be prepared and unchanged. Final source/binary hashes and the actual inherited lock are rechecked.

After source review/commit and an explicit correctness lease:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  python3 experiments/2026-10-29-split64-range-native-scaling/preflight/validate.py \
  --source-commit REVIEWED_COMMIT --execute-correctness
```

This preparation does not itself authorize compilation or performance.
