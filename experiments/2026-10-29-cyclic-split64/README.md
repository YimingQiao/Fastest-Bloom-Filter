# Cyclic Split64 mask hypothesis

Source preparation only. This experiment changes the mask distribution and must
pass accuracy gates before any speed comparison or native-language promotion.

Eight 64-bit sectors keep the range-addressed cache-line layout. Sector `j`
selects the six cyclic bits starting at bit `4*j` of the low32 hash. Adjacent
positions share two input bits. Each position is marginally uniform, but the
eight positions are correlated; this is deliberately **not** assumed equivalent
in FPR to Split64's multiply/shift masks. The high32 line index stays disjoint.

On AVX512F, the proposed mask uses broadcast, variable right shift and variable
rotate of one. Rotate semantics supply the modulo64 operation, avoiding an AND.
This could shorten the mask calculation, following the fewer-instructions lesson
from bbtree. Generated assembly and actual measurements must establish any gain;
the source instruction count is only a hypothesis. AVX2/scalar retain the exact
same new mask mapping using explicit modulo64 positions.

The predeclared first gate compares this new mapping with unchanged Split64 range
at 65,536 and 33,554,432 inserted keys, 16/24/28/32 actual bits/key, seed42, and
2^24 disjoint negative probes per configuration. Both use the same bijective
common64 hash over unique counter domains. This is an accuracy pilot, with no
speed metric, no table selection and no global claim. Report all false positives,
exact backing bytes and pointwise95% Wilson upper endpoints. Repeated probes of
the same stream must never be counted as additional calibration samples.

Correctness must first cover independent bit extraction, full bitmaps, required
bits, duplicate/collision behavior, dense tails/guards and all three C++ backends
with and without ASan/UBSan. Production and all previously frozen experiments
are unchanged. A losing quality result is retained rather than retuning masks
after looking at this pilot.
