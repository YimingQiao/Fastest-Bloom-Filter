# Untimed calibration driver

This additive source is not yet compiled or executed. The initial25-file
proposal remains byte-identical to `bbc3474cdd15b2e3301384dff4afdc12505cbfe9`.

`src/main.rs` is a mechanically derived copy of the committed public benchmark:
only module/include paths and its unused entry-point name change. All adapters,
constructors, workload helpers and old timer functions remain exact. The new
reachable entry is `src/driver.rs`; it never calls those timers, creates exactly
one bitmap per API/geometry, inserts the full input once, validates every
inserted key, checks every mixed-query and calibration answer against the same
library's public singleton, and emits only counts/checksums/geometry metadata.
The bitmap is dropped before the next API.

Its raw workload and selected-API permutation use the same SplitMix/shuffle
sequence as the parent. Inserted keys are hashed in place after workload
generation; this changes temporary storage only. The q2^22 query and calibration
interval are unchanged, so all40 retained geometry records must reproduce the
sealed Rust120 semantics. No FPR sample is pooled. FixedK11/default16 equality
is checked separately and both API rows stay in the raw archive.

Proposed CLI: `accuracy POWER BPK QUERY_POWER SEED CALIBRATION_POWER FILTERS`.
Exactly six arguments are required; `FILTERS` uses the inherited exact selection
validation, with an empty overall string meaning all20. Invalid arguments and
unknown/duplicate/empty tokens reject before workload allocation and CSV. The
formal proposal fixes hit50%, batch4096, full insertion, n2^16/2^25, actual
16/24/32 bpk, q2^22, calibration2^24 and seed42. Smaller q/calibration powers
exist only for correctness fixtures, whose outputs cannot qualify formal rows.

Before calibration, a separately committed preflight will compile the normal
and `disable-avx512` paths and ASan, execute the new fixed-K bitmap/output and
allocation tests, prove the one-constructor lifecycle, deliberately corrupt the
last answer of all three streams, and check exact default/K11 aliases. An empty
constructor test explicitly measures all72 formal fixed-K geometries through
public `num_bits`/`num_hashes` plus the allocation counter. This test generates
no formal inserted or negative stream. Preflight also compares small full
semantic rows with the retained benchmark and exercises malformed CLI input.

The broad old native implementation and external kernel suites are not being
repeated: their source and dependencies are unchanged and already pinned. The
accuracy executable, consumed dependencies, source commit and raw-row guard
will be frozen after the focused checks pass. This source proposal does not
authorize compilation, formal accuracy or timing.
