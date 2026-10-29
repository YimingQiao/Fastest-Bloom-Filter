# Native Range and external exact-capacity parallel query preparation

Source-only work. No executable has been built from this directory, and no
correctness or performance result is claimed. This implements the C++ source
portion of the [Range performance plan](../2026-10-29-split64-range-performance-plan/README.md).
The Rust stage proceeds independently; this preparation does not reuse its timings.

The 25 registrations are the prior 23-family multithreaded shortlist, native
Split64Range and the already-known Boost ClassicK11 rival. The proposed grid
measures the original23 plus Range at actual byte ceilings16/24/32, and also
replays all17 fixed external geometry points from the serial confirmation.
ClassicK11 is included at its two already-selected20-bpk points, not all grid
budgets. After duplicate geometries are removed,142 rows are expected. A new
allocation-only planner must confirm that count and every actual allocation
before any performance protocol is frozen. No timing-based selection occurs here.

All upstream insertion/query adapter bodies and exact-budget inverses are
copied from the reviewed exact-capacity stage. Native control headers are the
production snapshot at `ab9b66798940bbb99a39cf68fae9d521dcfc2a04`. The candidate
is the validated native C++ Range at `f3a9f4c6c6a4ed5f14e1d8e3145cdd3bbedadb10`,
with its class/constructor spelling changed to `Split64RangeNative` so it
can coexist with the earlier serial experiment. Its sizing include points to
the byte-identical shared `range-layouts/range_size.hpp` to avoid duplicate
definitions from separate `#pragma once` files. It retains the same public
batch API, mask, SIMD dispatch, prefetching and allocation-capacity accounting.
Its origin is still an experiment, not a promoted production layout.

`derivations.json` records all42 copied/derived artifacts, source commits and
exact text transformations. `verify_source.py` checks each against Git objects,
including the unchanged concurrent executor, topology checks and complete timed
query region. `benchmark.patch` shows the complete benchmark delta: exact-byte
factory, allocation check, appended geometry, explicit fixed phase order and
serial trial vectors. Both output prefixes set17-digit precision so the first
row has the same round-trip precision as later rows and trial vectors. No query
loop, thread lifecycle or timed interval changes.

The public query contract remains one serially built shared immutable bitmap,
the caller as worker0 plus T-1 spawned threads, and unchanged global batch
boundaries. End-to-end timing includes thread creation and cleanup; gated work,
launch and join are retained separately. Direct serial controls remain distinct
from a T=1 executor. PageBloom is raw-key-only and has no valid pure/prehashed
comparison. Serial build times remain allocation-inclusive or insertion-only
as labeled; they are not parallel-build measurements.

The initial performance proposal is n=2^16/2^25, T=8, batch4096, q=2^22,
50% hits, seed42, six trials and2^24 calibration negatives. Exact CPU/node
placement and the inherited whole-matrix socket lease must be added to the
reviewed runner. The fixed within-trial order is serial pure, serial hash,
parallel pure, parallel hash; this is a disclosed limitation of the retained
executor benchmark. Training results cannot be labeled held-out confirmation.

Before timing, a separate additive preflight must compile normal, AVX2 and
ASan/UBSan modes, exercise shared reads with TSan, run complete geometry/output
checks plus thread failure/cancellation tests, and compare all retained public
outputs with the frozen exact-capacity serial binary. The candidate's complete
bitmap must reproduce the validated native Range fixtures. Invalid selection,
geometry, CPU topology and malformed/partial output must fail closed. Dependency
headers actually consumed by the compiler and resulting binary hashes must be
recorded. The current CMake file is untested source preparation.

Every cap ranking must admit all smaller measured allocations, enforce the
pointwise Wilson95 upper FPR endpoint, preserve quality failures and losses,
and separate native/experimental/external ownership. API aliases, repeated
thread counts and repeated batches do not create independent quality samples.
The known FourSector16 held-out quality failure must remain visible. Native
parallel construction and native `LookupParallel` remain separate later tests.
