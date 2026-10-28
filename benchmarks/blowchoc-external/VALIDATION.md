# Bridge validation, 2026-10-29

This is correctness and adapter validation, not a throughput comparison. All
compilation/JIT/test commands ran on CPU3, socket1, with the shared socket1
`flock`; no competing socket1 workload ran concurrently. The native bridge uses
Clang23 `-O3 -march=native`; the scalar control disables the native-ISA flag.
ASan+UBSan instruments the C++ shared library and its direct ABI test. Python is
3.12.12, NumPy1.26.4, Numba0.61.0 and llvmlite0.44.0 / LLVM15.0.7; the detected
JIT CPU is Sapphire Rapids. Upstream files are unmodified and hash-checked.

Passed checks:

* Four configurations (one/two choices, random/distinct positions, K8) against
  an independent integer oracle: exact frozen hash positions/blocks, complete
  bitmap equality after ordered duplicate/skew/edge-key insertion, idempotence,
  complete output vectors, no false negatives and read-only bitmap invariance.
* Prehashed, common-hash fused and batch-staged builds produce the same bitmap;
  all three query modes have identical dense outputs. Query batches1/7/31/4096,
  input offsets0/1/7, empty input and short/long tails retain output guards.
* After later factories overwrite upstream module hash names, every earlier
  factory still produces its exact original bitmap and complete output vector;
  no extra JIT signature is compiled. RNG state, hash strings, descriptor
  detachment and warm-up allocation release are checked.
* Native and scalar C++ builds have identical 24-row build-mode reports across
  four filters and two budgets. Both direct ABI tests pass; ASan+UBSan passes
  the same C ABI test, including null/invalid ranges, full outputs and noFN.
* Closed prepared operations reject execution symmetrically and immediately
  release arguments. Weak references prove the NumPy view and backing allocation
  are gone after closing, even while the stale operation itself remains live.
  The actual driver repeats release checks between every build allocation.
* Shared-harness SplitMix64/Fisher-Yates generation agrees with a separate Python
  integer implementation for four seeds, including u64-max, and hit0/50/100.
  The common u64 hash agrees on all edge and test inputs. Five CLI tests reject
  unknown/duplicate selections, invalid ranges and unbalanced timing repeats.

The eight-filter accuracy-only driver smoke uses n1024, q16384, requested8
(actual16bpk), batch4096, hit50, workload seed42, construction seed113 and 65,536
independent negative probes per configuration. Every row has empty build/query
timing arrays. The four native controls and four BlowChoc configurations all
pass complete build/query validation. At this tiny size BlowChoc's actual2048B
backing allocation contains only1600B logical bitmap plus448B alignment slack;
its16B positions scratch is reported separately. These small accuracy counts
are a contract check, not adequate evidence for a tier or fastest claim.

`validation/hash-diagnostic.log` records the pinned JIT's signed remainder
semantics for non-power-of-two moduli (`srem i64`), including high-bit u64 values.
The oracle was corrected to match the actual unmodified baseline; no upstream
algorithm or generated hash function was changed to make the check pass.

`validation/accuracy.json` records source/library SHA256 before/after the run,
all explicit construction hashes, workload hashes, actual bytes, scratch,
calibration interval/counts, JIT versions/CPU features and cold factory/warm-up
duration. `FREEZE.json` pins the final archive and the native/scalar/sanitized
libraries. The original full-output/ABI checks and accuracy smoke logs are kept.
