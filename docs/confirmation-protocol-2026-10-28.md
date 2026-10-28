# Frozen confirmation protocol — 2026-10-28

This protocol is written before running the confirmation matrix. The completed
[43-configuration screen](modern-screen-2026-10-28.md) and separate layout
experiments select candidates. Confirmation seeds **307, 509, 1021** were not used
in that selection. No candidate is selected by its confirmation result and then
described as independently confirmed on those same inputs.

The C++ shortlist is FastPatternBF, FastPattern64Experiment, FourSector16K8,
Split64P32, FastFilterSimdBlock, FastFilterFixed16, FastFilterFixed32,
FastFilterFixed32Bulk, FastFilterFixed64, Boost192Multi32K7, Boost192Multi32K8,
Boost192Multi64K8, and PageBloom6Compact. It includes the original screen's
leading configurations and new accuracy/speed candidates. The whole-input bulk
FastFilter alias preserves its construction tradeoff even when queries match
the scalar-build alias. PageBloom retains its default public raw-key hashing;
the separately recorded AES screen is not silently mixed into these rows.

All C++ candidates run in one process, with the common shuffled order, Clang 23
`-O3 -march=native`, and CPU 2 on the Xeon Platinum 8474C. The native Rust
comparison uses the same input contract and CPU, serially after C++: FastPattern,
FourSector16K8Experimental, Split64Experimental, Bloomsday, and fastbloom. Rust
results retain their own series and compiler provenance.

The first stage uses 2^16, 2^24, and 2^25 inserted keys; requested 8/16 bits/key
(native actual allocations 16/32 bits/key); 50% hits; query batch 4096; whole-input
construction; 2^22 timed queries; five repetitions; and all three new seeds.
Independent 2^24 negative calibration probes run after timing for each case.
The largest native bitmap is 128 MiB, above one socket's 97.5 MiB LLC. Allocation
size alone does not establish a cold-cache workload: repeated queries can reuse
cache, and input/output arrays are also part of the working set.

Later stages add single-key and batch-31 queries plus 0% and 100% hit rates.
Their completion and scope must be visible; a completed large-batch stage is not
evidence for unmeasured single-key cases. Any code optimization prompted by these
results needs a new version and new confirmation inputs.

Ranking uses separate **16 and 32 bits/key resident-allocation ceilings**, zero
extra allowance, and FPR ceilings 1%, 0.1%, 0.01%. Eligibility requires a pointwise
one-sided 95% Wilson upper bound on pooled independent negatives to meet the
target. The three insertion seeds remain distinct timed cases, and repeated hit
rates/batches do not multiply the number of negative samples. Bounds describe
this uniform-hash generator, not arbitrary adversarial input distributions or
simultaneous guarantees over all candidates.

Report median hash+query and hash+insert nanoseconds/key across seeds, exact
allocation, observed FPR and upper bound, build scratch, and losses. Pure lookup
is a second metric only for implementations that accept prehashed input. Actual
allocations can differ below one ceiling; this is a constrained comparison, not
a claim of identical space and accuracy. Raw rows, per-case trial spread, binary
hashes, source revision/patch, dependency pins, and commands remain in results.

No finite CPU benchmark proves an unrestricted global-fastest Bloom filter.
Success means an explicit, reproducible lead in the measured contract, followed
by further work on the remaining losses and native multithreaded integration.
