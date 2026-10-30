# Bounded-build confirmation harness, source preparation

This additive harness implements the separately committed
[96-pair plan](../confirmation-plan/README.md). The native libraries and the
enabled/disabled public wrappers remain byte-identical to their prior freezes.
No compiler, filter or performance run has executed this harness yet.

One invocation measures one fixed family/scenario/request/seed pair in one
language and emits one JSON record containing control, candidate and a shared
serial-reference vector. The later runner will materialize the192 variant rows
and96 serial records without duplicating serial samples. Absolute nanoseconds
are retained; per-new-hash values are derived by dividing by the recorded batch
length. Both primary contracts have four trials in the committed schedule.
Populated cases have no allocation-inclusive samples; absence must be rendered
as unavailable, not zero time.

The native public wrapper receives the original requested T inside the clock.
Metadata calls independently observe effective request, actual workers and
the public scratch estimate, but never select the timed implementation. The
timed call includes native scratch allocation, partition passes, thread starts
and joins. Scratch is the existing public estimate, not total process peak
memory; thread stacks and allocator bookkeeping are not newly inferred.
Serial/control share a typed disabled wrapper; candidate differs only by the
already frozen const policy. No function-pointer or per-key type erasure is
introduced.

All three arms use a fresh filter for every trial/contract. The oracle dies
before timed construction, and each timed bitmap dies before the next arm.
Its expected dense answers, the new64K hashes, and mixed query inputs remain
live. Old histories are regenerated in4096-key blocks. Separate setup vectors
include streamed hash generation plus public serial prepopulation, outside the
incremental timer. Empty setup entries are zero because no setup is reported;
they are not measured constructor latencies.

Every lifetime checks actual bytes, all old/new inserted keys, and all32,771
mixed Boolean outputs with guards, through serial and unchanged-T parallel
query APIs. Full input fingerprints are checked before and after all trials.
Each executed phase is recorded and validated against the fixed schedule.
The deliberate bad-output CLI flips one expected bit after the oracle has
been destroyed, exercising the validation boundary without changing a kernel.

The source accepts a reviewed list of T distinct physical cores on one node,
with primary CPU2 or3. It restricts serial work to that primary CPU and expands
the caller mask outside parallel timers. The future whole-flock runner must
expand its child mask before `numactl`, bind memory to the granted node, and
record topology, environment and actual inherited lock evidence. A valid
CPU list is not itself an execution lease.

The proposed focused preflight reuses the prior48 native normal/sanitizer
proofs. It only needs both new harnesses in normal/ASan modes, representative
small empty/batch-boundary/populated cases, exact cross-language records
(excluding language-specific scratch/scheduler and all clocks), the bad-output
fault, a few malformed CLIs, and actual compiler-input capture. Large histories
and all threshold forwarding were already validated. The fixed formal ledger
must remain unchanged after those checks. Source/binary freeze and an explicit
socket lease are still required before formal performance.
