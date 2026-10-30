# Fixed fresh-seed confirmation proposal: small16-bpk/0.1% gap

Source-only protocol. No candidate or baseline has run on these seeds, and no
fresh correctness, quality or performance result is claimed. Use the unchanged
76-registration executable frozen at
`9e4362f1068d37d134ef8447a44146b52c1edc9f`; do not rebuild or tune its mask,
prefetching, insertion, timers or public query APIs for this confirmation.

The seed42 Multiply70 screen exposes a qualification distinction. FourSector16
is faster on that seed, but its earlier held-out Wilson95 endpoint exceeded the
0.1% target. After that known failure is respected, Multiply16 is faster than
the remaining production Split64, original Range16 and external Fixed64 on
small data. This narrow gap motivates a new test; it does not make Multiply a
general replacement for the existing layouts.

Fix n=65,536, actual ceiling16 bits/key, target FPR0.1%, batches1/31/4096,
q=2^22,50% intended hits, six query repeats and2^24 separate calibration
negatives. Whole-input build occurs once outside timing; build columns remain
NaN. The frozen alternating prehashed/common-hash schedule is unchanged.

Eight public APIs are fixed in every case:

- Multiply-code16, production Split64, original Split64Range and FourSector;
- FastFilter Fixed64, Boost Multi64K8, RocksDB K8 direct and K8 Batch32.

The four external APIs were the four fastest qualifying APIs in both query
contracts of the earlier988-row small-data16-bpk/0.1% screen. Including the
second RocksDB call shape matters for the new short-batch comparisons. All
are charged their actual allocation; Boost's alignment/tail byte accounting
remains unchanged. Fixed64/Range and RocksDB direct/batch quality aliases do
not constitute independent calibration samples.

`mint_seeds.py` creates fresh random64-bit candidates without executing a BF.
It computes only the frozen source's exact job permutation, then takes the
first three candidates placing Multiply first and the first three placing it
last. The complete random candidate ledger, including unselected entries, is
retained. These six data seeds balance Multiply's before/after position against
every fixed rival. This is an explicitly conditioned order design, not six
unconditional random seeds or a test of every possible placement. Batch size
does not change that binary's job permutation. Interleave first/last strata
and rotate the three batch case orders as recorded in the protocol.

The fixed matrix contains6 seeds ×3 batches ×8 APIs =144 rows. The six seeds
are the units for reporting repeated data/order observations; three batches
reuse each mapping's same calibration interval and must not be pooled.
All rows, every trial, all losses and all quality failures must be retained.
Rank prehashed and common-hash contracts separately. Freeze comparisons
against each named rival and the fastest eligible rival within each seed;
do not pick a favorable subset after measurement.

FourSector16 remains a diagnostic with a known held-out failure in the robust
comparison even if every new seed passes. Show its current-seed eligibility
in a separate descriptive table. A candidate or rival that exceeds the fixed
quality ceiling in any new seed fails the across-seed quality gate; retain its
timings but do not present it as a robust0.1% winner. Passing every observed
seed is evidence over this workload, not a probabilistic guarantee for all keys.
The candidate must pass all six fresh per-mapping Wilson95 upper endpoints.

Before execution, add and review a fail-closed runner/analysis contract that
checks the committed source/binary, complete8-API geometry, exact source-derived
row order, all commands and raw/aggregate equality. Every row retains both
six-element phase/trial vectors. Use an inherited whole-matrix socket lock,
CPU affinity and explicitly recorded NUMA policy. The actual measured run must
start only after that additive runner and its protocol are committed. No CPU
lease, measurement or promotion is authorized by this source-only status.
