# Native Range API integration validation

The optional range-capacity filter is now packaged as native C++ and Rust library
source. The tested source is `e8b89cd3c7c090287d1d4222db981ec7f8fb86ab`, on the
isolated `integration/range-capacity` branch. The benchmark worktree and its
frozen source/binaries were not changed. No build-policy optimization is part
of this validation and no new throughput claim is made.

The kernels, sizing and exact whole-line ownership come from the previously
validated native prototype. C++ headers and the serial type are renamed to
coexist with the existing Split64 headers. Rust exports the two new modules and
the public range type; the experiment-only bitmap-copy accessor is removed.
Formatting and API documentation change, including a tested public Rust example.
The independent bitmap/partition/boundary tests are retained with the new names.

All 15 recorded commands completed successfully under the exclusive socket0
flock on CPU2, using Clang23 and Rust1.92. CPU affinity is a correctness-run
placement, not a scaling measurement.

- C++ native, AVX2 and ASan+UBSan profiles each pass both native and portable
  Range test targets. Tests include the existing production-layout headers in
  the same translation unit, independent complete bitmap/output oracles,
  nondivisible ownership, incremental duplicate insertion, null-empty calls,
  guarded tails and serial/parallel agreement.
- Rust normal and `disable-avx512` profiles each pass all34 library tests,
  six serial-benchmark tests, two parallel-benchmark tests, and the new doctest.
  Range tests exercise detected SIMD and explicit scalar paths.
- Clippy passes for every Rust target with warnings denied.
- Nightly Rust AddressSanitizer passes all five Range tests, including native
  partitioning, sizing, output guards, required bits and the independent oracle.

`validation-v1/commands.json` preserves each actual argument vector, environment
override, exit status and stdout/stderr digest. `executed-runner.py` is the exact
local command driver, including its original paths. The supplied build/API
instructions work in ordinary checkouts; this archived driver is provenance,
not a path-independent installation script. Binary builds remain local.

The earlier benchmark evidence describes the prototype and its specified
workloads. Fresh-seed external confirmation is separate. This integration does
not replace the old power-of-two types or change their default build behavior.
