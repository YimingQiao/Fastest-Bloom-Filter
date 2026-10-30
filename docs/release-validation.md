# Source release validation · 2026-10-30

This release packages the native C++ and Rust libraries and publishes only batch4096 query performance. Library source was taken from research commit `551a3a4c648df223e29305cf89418e48a553c577`. All 39 files in `include/` and `rust/src/` match that snapshot byte for byte; their hashes are in [source-manifest.json](../benchmarks/results/source-manifest.json).

Fresh checks in the isolated release checkout on the Xeon Platinum 8474C host:

| Check | Result |
| :--- | :--- |
| Clang 23 native CMake build and CTest | 20/20 passed, including standalone scalar layout tests |
| Rust tests, normal dispatch | 40 library, 8 binary tests, 1 doc test passed |
| Rust tests, `disable-avx512` | 40 library, 8 binary tests, 1 doc test passed |
| Rust Clippy, all targets, warnings denied | Passed |
| Rust optimized library and benchmark build | Passed |
| Exact C++ and Rust examples extracted from README | Compiled and ran successfully |
| Range and K12 parallel C++/Rust parity | Four modes agreed across 18 workloads |
| Publication data arithmetic and generated tables | 30 scenarios, 1,170 qualifying configurations passed |

The library kernels were not changed during publication. Packaging changes remove the research-only CMake option and relocate the frozen ByteSplit comparison implementation under `tests/reference/`, with its license. Historical benchmark identifiers, source hashes and measured versions remain in the performance data. This release does not substitute fresh timings for the archived measurements.

An optional [GitHub Actions template](ci-checks.yml) covers the default AVX2 C++ build, scalar tests, publication tables, and Rust's declared minimum version 1.89 with normal and disabled-AVX512 dispatch. It is provided as a template, not an active workflow. The local checks above used rustc 1.92.0; minimum-version CI has not been run for this release.
