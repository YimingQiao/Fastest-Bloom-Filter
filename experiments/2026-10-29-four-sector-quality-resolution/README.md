# Fixed higher-resolution check of the two FourSector16 quality gates

This is an accuracy-only protocol, fixed before new probes. The two historical
failures were **Wilson95 upper endpoints** above0.1%; their point estimates
were below0.1%. Those observations do not establish that the true FPR exceeds
the target. A small candidate must not gain an unqualified speed claim merely
because a faster rival's earlier quality estimate was imprecise.

Use the unchanged76-family executable at source commit
`9e4362f1068d37d134ef8447a44146b52c1edc9f`. Fix FourSector, actual16bpk,
n=2^16/2^25 and the original seed7562001474399208876. Keep q=2^22, batch4096,
50% hits and the original full-input serial build. The binary runs two query
repeats only as an existing correctness path; none of its latency is analyzed.
No constructor, bitmap, hashing, lookup or timer code is changed or rebuilt.

For each n, first reproduce exactly the old2^24-negative calibration count
and mixed-output checksum. Then run the same construction with cal27. Its
calibration stream contains the same old prefix followed by **117,440,512 new
disjoint negative keys**. Subtract the independently reproduced prefix count
and compute a pointwise two-sided95% Wilson interval using only the new suffix.
The complete prefix and total counts remain visible; do not pool them into a
new independent sample or replace the old report. Different n values are also
kept separate.

There are exactly four fixed runs. No further interval extension, seed change
or parameter selection is allowed based on the observed result. All inserted
keys and all timed dense outputs are still checked by the frozen public harness.
The runner checks committed source and binary hashes before and after every
case, validates the exact geometry/phase vectors and refuses output reuse.

This addresses statistical resolution for two particular built filters. It
does not establish an all-input FPR guarantee or erase the historical failed
gate. The separately fixed144-row Multiply confirmation keeps FourSector16
diagnostic under its preregistered rule. Interpret that restricted comparison
alongside this new accuracy evidence and the current-seed table, not as proof
that Multiply beats every valid FourSector deployment.
