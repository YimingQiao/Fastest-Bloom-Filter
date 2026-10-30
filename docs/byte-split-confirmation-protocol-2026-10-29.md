# Native ByteSplit confirmation protocol — 2026-10-29

This protocol is written before the native-port performance measurements. The
preceding direct-split experiments found a small-filter, one-key advantage for
ByteSplit128 and no broad case for promoting IndependentSplit32. Only ByteSplit
is being integrated. It is an additional accuracy/throughput choice; native
Split64 can be faster while using less memory at the 0.1% FPR ceiling.

First validate the C++ and Rust ports against independent scalar bitmap oracles,
the frozen prototype and each other. Preserve exact mask, address, allocation,
result and calibration semantics. Exercise scalar/SIMD, empty inputs, collisions,
unaligned input offsets, tails, exclusive parallel builds and immutable queries.
Use fresh build directories; preserve previous confirmation executables.

The primary timing matrix uses n=2^16 and 2^25, requested 8/16 bits per key
(actual 16/32 for the native layouts), batch 1, 50% hits, seeds 2309/6311/10007,
2^22 timed queries, seven repetitions and independent 2^24-negative calibration
per insertion seed. Full-input construction is independent of query batch size.
These seeds are not used to tune the native implementation. All CPU 2 measurements
run serially; no compiler, tests or other benchmark may occupy its socket.

C++ uses one shuffled process containing native FastPattern, FourSector, Split64,
ByteSplit; FastFilter Fixed16, Fixed32, Fixed32Bulk, Fixed64 and SimdBlock plus
both single-entry shortcut controls; Boost Multi32K7/Multi32K8/Multi64K8;
PageBloom6Compact; and all eight RocksDB FastLocalBloom configurations. Every
implementation receives the same compiler/ISA flags. The frozen prototype is a
separate port-regression control, not an external baseline.

Rust uses the updated external suite: current native FastPattern, FourSector,
Split64 and ByteSplit, the frozen FourSector/Split64 prototypes, fastbloom 0.17.0
and pinned Bloomsday. Keep the Rust matrix separate from C++ medians; two Rust
external families do not replace the broader C++ set.

Rank median hash+query and prehashed query separately at caps 16/32 bits per key,
zero allocation slack, and FPR ceilings 1%/0.1%/0.01%. Eligibility uses the
pointwise one-sided 95% Wilson upper bound from disjoint independent calibration.
For each cap, consider every tested allocation at or below it. Report both
median-of-seed medians and paired-seed speedup range; do not select the fastest
repetition. Construction time, allocation-inclusive construction and scratch
remain separate metrics, including losses. A win at a looser FPR ceiling is not
evidence of a win at a stricter ceiling or a universal fastest Bloom filter.

Batch 31/4096, 0%/100% hits and parallel scaling are additional characterization
screens, not silently pooled into the primary one-key confirmation. If the native
port loses the prototype's benefit, retain the failed measurements and investigate
before presenting the new type as an improvement. Further tuning requires new
confirmation seeds and an explicitly separate cohort.
