# FastPatternRange correctness preflight

The initial source preparation is preserved unchanged in `initial-record/` and
commit `bcd66d8`. The original README and PREPARATION.json describe that initial
state. **Correctness validation is now complete; no throughput or calibrated FPR
measurement has been performed.**

All eight Clang release configurations pass the full scalar word oracle:
native, AVX2, scalar, AVX512F-minimum, and each mode with ASan+UBSan. Every mode
returns the same bitmap/output digest: `4417359686136842711`. The minimum feature
build's actual compiler macro output proves AVX2+AVX512F enabled and AVX512VL,
AVX512DQ and AVX512BW disabled; it did not silently test a fallback. The source
kernel, constructors, tables and query policies remained unchanged during these
checks. No candidate correction was needed.

The oracle covers complete bitmap equality, 2/3/5/7/31/257-line geometries,
both6/8-probe policies at the exact real-n density threshold, unsigned reducer
boundaries, duplicate insertion, all1024 cyclic codes and removal of every
required probe bit. Short0..131 and long4096/4097/4127 queries use offsets and
output guards. Sizes just below, at and above2MiB exercise both prefetch paths.
Empty explicit capacity, empty calls, minimum/cap boundaries and arithmetic
overflow are checked. All tests compare complete answers, not only a checksum.

`validation-v1/commands.json` and per-mode compile/macro/build/test logs retain
the exact commands. `validation-v1/validation.json` records all input/binary
hashes and mode features. The whole validation process ran pinned to CPU2 under
`/tmp/fastest-bf-socket0.lock`. Tiny-test elapsed times in CTest logs are not
filter performance results. Reproduce with the dedicated correctness script
under a granted lease:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-fast-pattern-range/validate.py --output NEW_VALIDATION_DIRECTORY
```

The new address map still requires independent FPR calibration and fair timing
before a speed/quality claim. No arbitrary-capacity parallel constructor, Rust
port or production promotion is included here.
