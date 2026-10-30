# K12 range vector bulk-query screen preparation

This prepares a fixed single-thread comparison for the validated K12 mapping.
It makes no throughput claim and has not been compiled or executed. The
[vector proof](../2026-10-29-four-sector-range12-vector/VALIDATION.md) covers
native/AVX2/scalar plus sanitizers, while the preceding scalar quality pilot
selected K12 after retaining all K8/K9/K10/K12 outcomes. No masks are retuned.

The complete serial benchmark translation unit is byte-identical to the
reviewed exact-capacity screen. Workload generation, public batch APIs, hash
work, timed loops, balanced pure/hash phases, full output checks, guards,
negative calibration and CSV precision are unchanged. This is batch API
throughput, not a compiler-visible singleton experiment. Page remains raw-key
only; its invalid prehashed metric must not be ranked.

The registry keeps all 25 entries of the earlier native-Range parallel-query
screen, and appends K12 as the 26th. That contains four production natives,
validated native Split64Range, public FastFilter shapes, Boost, RocksDB and
Page. It also retains the earlier 17 extra geometry points, already selected
before this candidate existed; duplicates are not repeated. This is a known
strong shortlist, not a new claim to have tested every available public
configuration. The prior 68-external-configuration screen and its losses remain
separate. No result is normalized against a different executable context.

The fixed ledger has 26 commands / 296 rows: the parent's 142-row selection
plus K12 at all six n/cap combinations, for batch31 and4096. Main n are
65536/33554432, caps16/24/32 actual bits/key, q2^22,50% hits, seed42, six query
trials and2^24 disjoint calibration negatives. Each row has a complete untimed
build and all-insert verification. Build repeat count is zero in query-only
mode; no construction or multithreaded speed claim follows. Raw key hashing is
inside the hash+query timer. Query phase alternates by seed+trial exactly as in
the frozen serial parent. The previous fixed serial/parallel phase order is not
used here because this is the serial harness, without an executor.

K12's allocation trait records 12 probes and a distinct range24 mapping kind.
Its public header differs from the six-backend proof only by the sizing-include
path: the existing shortlist's sizing file is byte-identical, but including the
same file identity avoids duplicate RangeBytes declarations. All algorithm,
prefetch and dispatch bytes stay unchanged. Existing rival adapters and native
headers are inherited directly from pinned sources. The adapter registry delta,
geometry trait and include rebinding are the complete integration changes.

The timed workload's negative domain differs from the standalone scalar pilot;
its K12 qualification must be measured again alongside every rival and cannot
be assumed from the earlier count. Each cap view admits all smaller measured
allocations and enforces the pointwise Wilson upper FPR bound. All K12 failures,
all equal-byte losses to production, and all external advantages must remain.
Repeated batches and API aliases do not add independent calibration samples.

Before timing, the exact compiled caller needs bounded normal/AVX2/sanitizer
checks, actual allocation observations and full K12 scalar parity using this
workload. Existing native/vector backend proofs are reused rather than repeated
as unrelated tests. Capture actual compiler dependencies, verify every inherited
source and preserve invalid-CLI/late-output-fault behavior from the original
harness. A separate frozen runner and explicit whole-socket lease follow that
proof. No performance execution is authorized by this source preparation alone.
