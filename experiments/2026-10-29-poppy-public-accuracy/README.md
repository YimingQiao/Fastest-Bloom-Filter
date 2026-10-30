# Fixed Poppy public accuracy calibration

This stage adds full-load independent accuracy evidence for all86 existing
public constructor choices. It retains the exact real capacities, arguments,
policies and allocations from the completed constructor and semantic proofs.
There is no further geometry, K or requested-FPR search. Ordinary controls
that exceed the bitmap ceilings remain in the output. No timer is present.

The formal dataset is the existing Rust comparison's seed42 construction:
65,536 or33,554,432 distinct raw keys, the same common64-bit hash, shuffled
insertion order,2^22 mixed queries with the same50% source-hit rule and shuffle,
then2^26 separate negative keys. The calibration interval starts at
`key_base + real_n + 2^22` and does not intersect inserted or mixed-query keys.
All supplied hashes enter Poppy through its public eight-byte little-endian
slice API. Public insertion errors fail the row; every inserted key is checked
for a false negative before calibration. The optional cache remains charged.

Seed42 is training data already used elsewhere. This is not a fresh-seed
confirmation. Each API/constructor row keeps its own denominator and pointwise
two-sided95% Wilson interval; aliases, policies and sizes are never pooled.
The17 already-proved same-parameter None/Space pairs must reproduce full-load
counts and checksums. Other source-derived mapping aliases may be labelled,
but repeated observations do not add independent negative samples. No failing
choice is dropped or recalibrated with a larger sample.

Quality summaries use actual bytes under12/16/24/32 bits/key and the1%,0.1%,
0.01% ceilings, retaining every qualifying and failed alternative. Requested
FPP is sizing input, not measured quality. No latency ranking or superiority
claim follows from this calibration; the later timed caller must preserve the
public work and compare retained controls in one declared execution context.

Before the86 formal rows, normal and nightly ASan builds each execute eight
bounded checks (one per size/policy). They retain the real public constructor
capacity but use only1031 inserts,8193 mixed queries and4096 calibration keys.
The checker compares every mixed/calibration answer with the public prepared
iterator path. An independent Python oracle verifies base, shuffles, input
digests and denominators. Both build profiles must agree on every output field.
This tests the actual counter/range code without repeating the86 full semantic
matrix or using a formal full-load output as a tuning observation.

The immutable worker supports only `--check ID` or `--accuracy ID` for one of
the86 compiled-in constructor IDs. A later leased runner executes every formal
ID once in ledger order, in separate fresh processes, and seals raw data before
analysis. Inputs, executables, dependency metadata and failures are retained.
No default filter, constructor formula, dictionary or existing benchmark is changed.
