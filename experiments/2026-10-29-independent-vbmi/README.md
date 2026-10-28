# Independent split-block mask with VBMI

Unpromoted experiment. The existing IndependentSplit32 uses eight disjoint
five-bit probe fields from hash bits 0..39 and bucket bits 41..63. This variant
preserves that exact bitmap, allocation and API; only its mask construction changes.
On AVX512VBMI+VL, `VPMULTISHIFTQB` extracts eight overlapping bytes beginning at
bits 0,5,...,35. Widening those bytes and rotating a 32-bit one by each value
uses the low five bits of each count, producing the original eight probes.
AVX2 and scalar builds retain the original mapping.

The instruction semantics are documented in the
[Intel instruction-set reference](https://cdrdv2-public.intel.com/774492/325383-sdm-vol-2abcd.pdf).
This is a hardware-specific code-generation hypothesis, not a measured speed claim.
The control is the frozen IndependentSplit32, plus both versions' explicit
single-key shortcuts. Native ByteSplit/Split64 and pinned FastFilter single-call
controls remain in the same shuffled benchmark.

Correctness must precede timing: full bitmap against an independent byte-addressed
scalar oracle, every inserted key, duplicates, boundary sizes, query lengths and
offsets, output guards, native/scalar and ASan/UBSan. The existing independent
layout's accuracy is not inferred from instruction semantics; calibration remains
in every shared-harness run. No salt or layout parameters will be tuned.

Initial screen, once validation passes: CPU2, seed42, sizes2^16/2^25,
requested8/16bits per key (actual16/32),50%hits,batches1/31/4096,
2^22queries,five repetitions,whole-input insertion and2^24 independent calibration
negatives. This is exploratory. Any candidate for promotion needs held-out seeds
and tail/control batches before a native-library change.

Native, AVX2-only, scalar and Clang ASan+UBSan correctness checks passed before
timing; complete commands/logs are retained in `validation.json` and `*.log`.
`freeze.json` records source and executable digests. `query-assembly.txt` retains
all four old/new query kernels, confirming `vpmultishiftqb` in the new native
path. The validation was performed with
`flock /tmp/fastest-bf-socket0.lock python3 experiments/2026-10-29-independent-vbmi/validate.py`.
