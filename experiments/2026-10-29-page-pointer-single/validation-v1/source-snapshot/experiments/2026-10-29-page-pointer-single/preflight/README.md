# Page pointer caller preflight preparation

This additive driver leaves all nine caller/protocol files at
`e4f0455b4354ef5d06840cc226ede4b3a5ca4e60` unchanged. No compiler, filter, timing,
assembly capture or test has been executed for this preparation. Source AST
inspection is not execution. The source and complete preparation inventory
must be committed before a separately granted CPU2/socket0 correctness lease.

The bounded work is native and ASan/UBSan builds of the unchanged16-name worker,
48 correctness cases per backend, and one small extra caller-check target. The
worker reuses frozen `common.hpp`: all inserted keys, all query outputs, three
public/dense modes, short Dense tails0..131 at offsets0..3, long4095/4096/4097/4127
tails, input/output guards, all-miss/mixed/all-hit workloads and independent
calibration parity. Seven invalid CLI cases and three output-corruption faults
must fail before emitting CSV in each backend.

The extra target covers the only new caller path directly. For all six pointer
facades it checks null/zero Query, all three modes at offsets0..3 and the same
short/long lengths, exact outputs against inherited by-value Single, inserted
presence, zero Page scratch and unchanged input. This is9810 guarded queries
per backend,19620 total. It adds no field or change to the measured worker.

The strict parent schema is reused after explicit pointer-name/surface
canonicalization in the validator only. Every one of96 raw worker rows must
match the parent's successful native small-fixture output/checksum/geometry/
scratch/object-size evidence. The six pointer/value aliases and backend copies
reuse30 fixture identities; their calibration denominators are never pooled.
No calibration gate or timing conclusion is made from these small fixtures.

Both targets use the original worker's exact GCC12.2/backend flags and one
complete Boost1.92 root. Actual per-target compile commands/dependency hashes,
compiler macros, all logs and retained binaries are captured. No VLDB original
archive or earlier worker is rebuilt. Parent source/proof inventories and
actual dependencies are verified before and after execution. A fresh build
root and a real inherited `FLOCK ADVISORY WRITE` descriptor are mandatory;
matching an unlocked open file is insufficient.

The original typed-query assembly capture records all value/pointer/native
functions and out-of-line calls. Its existence is not automatic approval:
manual review must establish that each pointer-single branch passes the input
array element address to the unchanged public `test(ptr,4)`, without by-value
four-byte stack materialization. Out-of-line Page test is permitted. Dense
specializations call the same original `DenseCall<Base>`; actual code-layout
differences remain visible. `assembly_review_complete` remains false and
`timing_authorized` false until separately reviewed evidence is frozen.

After exact source commit and an explicit correctness lease, use new paths:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 \
  python3 experiments/2026-10-29-page-pointer-single/preflight/validate.py \
  --source-commit FULL_PREPARATION_COMMIT --cpu 2 --lease socket0 \
  --build build/page-pointer-preflight-v1 \
  --output experiments/2026-10-29-page-pointer-single/validation-v1 \
  > experiments/2026-10-29-page-pointer-single/validation-v1.log 2>&1
```

Failures retain the complete partial logs/source snapshot; do not reuse the
build/output paths or revise a committed source in place. The future240-row
caller comparison is not launched by this driver. Its frozen protocol retains
both rounds, all modes and all native/dense controls; there is no comparison of
latency against the old23-name executable context.
