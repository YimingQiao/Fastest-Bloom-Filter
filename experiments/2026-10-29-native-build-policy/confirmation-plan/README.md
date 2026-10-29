# Fixed bounded-build confirmation plan

This is source preparation, with no compiler, Bloom operation, or performance
run. The one policy was selected from native60's seed42 observation and is
already frozen and correctness-checked: only a current insertion of at most
65,536 hashes into at most256KiB uses build request1. Larger batches or bitmaps
retain the original requested workers. Query calls remain unchanged.

The fixed ledger has96 paired cases: six scenarios for each of Split64 and
Split64Range, requested4/8, C++/Rust, and fresh seeds74381/164321. It emits192
control/candidate rows plus96 shared serial-reference records. The second seed
reverses the complete case order. No thresholds, seeds or cases are selected
from these results. This confirms only the measured boundaries, states and
footprints; it cannot justify fallback on any bitmap above256KiB.

| Scenario | Actual bytes | New hashes | Previous hashes | New distribution |
|---|---:|---:|---:|---|
| Small empty |262144|65536|0|Uniform |
| Above batch threshold |262144|65537|0|Uniform |
| Small populated |262144|65536|131072|High32=0 hotspot |
| Above byte threshold |Split524288 / Range262208|65536|0|Uniform |
| Large empty |Split67108864 / Range100663296|65536|0|Uniform |
| Large populated |Same large bytes|65536|Actual bytes/2|High32=0 hotspot |

Every case measures incremental insertion. Empty cases additionally measure
fresh allocation plus the whole insertion call. Populated cases report the
allocation-inclusive metric as unavailable, never as a64K build that silently
includes prepopulation. Four trials per contract use `[S,C,P]`, `[P,C,S]`,
`[S,P,C]`, `[C,P,S]`: C/P pair order is ABBA and each occupies the same number
of first/middle/last positions. Serial is never middle; serial scaling is a
descriptive reference under that disclosed order. Empty cases alternate
contract order insert-first / allocation-first / allocation-first / insert-first.
The serial vector is stored once per case/contract, not counted twice because
both variants refer to it.

The timed candidate invokes the frozen public wrapper with the original T.
Its branch, native partition/scratch allocation, thread creation, insertion and
joins all remain inside the public call and timer. Effective requests and
scratch estimates may be observed outside timing for metadata; those values
must never choose the timed implementation. Both variants retain the same
allowed T physical cores, even when the candidate executes serially.

For insertion-only, allocation and any prepopulation occur on the primary CPU
before expanding affinity. For allocation-inclusive, expand affinity first,
then time constructor plus public insertion. Serial remains on the primary
CPU. Affinity changes, validation, destruction and streamed prepopulation are
outside all primary clocks. NUMA binding and the whole-socket lock are fixed
by the eventual reviewed runner. No individual worker pinning is claimed.
C++ caller-worker0 versus Rust scoped workers plus caller stays explicit.

Only one bitmap is live. Build the serial oracle, retain only its guarded dense
answers, and destroy it before timed instances. Every measured instance is
fresh, has identical history, and is destroyed before the next. Stream history
in4096-key blocks; do not retain a large history array or clone another live
bitmap. Check every old/new key for presence and compare all32,771 mixed
answers through serial and unchanged original-T parallel queries, outside the
timer. Record prepopulation setup time separately without deriving primary
latencies by subtraction. Retain input/output hashes, all trial vectors and
every control/candidate loss.

This is an implementation-policy comparison, with no new FPR qualification,
external ranking, query-speed claim or cross-language speed ranking. Mapping
and quality are unchanged only insofar as the immutable native-source proof
and full public semantics establish that. Automatic0 was already exercised
against each language's different native scheduler in correctness; performance
uses only explicit4/8. The existing48-case normal/sanitizer checks are reused.
Only new harness, clock-boundary, phase/order and result-guard checks are needed
before a separately reviewed source/binary freeze and execution lease.
