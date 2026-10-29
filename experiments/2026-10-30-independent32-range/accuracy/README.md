# Fixed Independent32Range accuracy pilot

This additive stage executes no timings and changes no filter source. Parent
source 944c1bae and its four-profile proof dcb6ef3a are immutable. The worker
uses the exact CPP616 SplitMix64, shuffle, digest and input-generation bodies
from ae6ab194, plus the parent's unchanged common64 HashVector implementation.
The generated input header contains no clock helper. The launcher has separate
proof and accuracy entry points; neither can launch a speed comparison.

The formal ledger has two processes, n=2^16 and 2^25, each constructing eight
filters sequentially: candidate actual 12/16/20/24/28/32 bpk, then old Independent32
actual 16/32 bpk through its unchanged requested 8/16 constructors. Exactly one
bitmap is alive at any point. The raw and hashed input arrays are shared across
that process's eight geometries; no second reference bitmap is retained.
Requested budget, actual backing, logical bytes, 32-byte buckets, 64-byte physical
lines, probe count and the public physical-line index digest are recorded.
Actual backing and logical bytes must equal the fixed grid's exact budget.

Seed 42 is seen data. Each process generates the complete shuffled real-n
insertion stream, inserts it in one public call, then checks every inserted key
through public bulk Lookup and ContainsHash, requiring every answer to be one.
It checks each positive key's public line index is within the actual allocation.
The 4096 mixed queries use the inherited i%100<50 selection pattern: 2050 actual
positives and 2046 negatives. Full bulk/singleton answers must agree; every output
block is poisoned and both boundary guards are checked. The worker checks input
digests and the complete bitmap digest after all queries.

Inserted raw values are in [base,base+n); mixed-negative raw values lie in
[base+n,base+n+4096). Calibration uses the separate half-open interval
[base+n+4096,base+n+4096+2^26), processed in 4096-key blocks. The common64 hash is
bijective, so these disjoint raw domains remain disjoint after hashing. Every
calibration bulk answer is checked against the public singleton answer. Raw
counts, checksums and one pointwise two-sided 95% Wilson upper endpoint are
reported per API/geometry. All 1%/0.1%/0.01% gates remain visible. Different
geometries, old/new mappings and sizes do not pool samples; cross-size input
independence is not claimed.

The launcher independently reconstructs each 4096-query stream with an O(1)
skip of the n-1 insertion-shuffle RNG draws. It validates exact row order,
geometry, domains, query digests, 2050/2046 ownership counts, Wilson endpoints
and gate flags. Shared insertion/input identities must agree within each size.
Old and new filters retain distinct bitmap/calibration identities even at equal
capacities. Every row is retained before the primary decision is made.
Candidate 12 must pass 1% at both sizes or the stage stops before timing. The
fixed 20/.1% and 28/.01% secondary targets cannot replace a failed primary point.
A passing pilot only permits proposing the already outlined separate speed
stage; it does not authorize it.

## Bounded worker proof and formal gate

The new worker gets only a native and a native ASan/UBSan build, with n=4096,
q=4096, cal1024, candidate 12 and old 16: four successful records total. Normal and
ASan records must match exactly. One deliberate dense-output corruption and two
invalid CLI calls must reject with exit 1, empty stdout and exact diagnostics.
This validates the new worker's lifecycle and guards without repeating the
parent's backend/kernel matrix or consuming formal cal26 inputs. The normal
binary is then reused unchanged for all 16 formal constructions.

Before any worker execution, the launcher closes its actual depfile against
the prepared local and parent source inventories, captures all system compiler
inputs, saves executable hashes, and checks source/tool/input identity. It
preserves every command stream and partial success on failure. No automatic
repair, fallback or retry exists. The proof directory must be sealed and committed
before the formal entry accepts it through --proof-commit. Fresh output/build
directories reject existing or dangling paths. A final closure check precedes
each complete archive.

The parent requires CPU3/socket1 and a matching already-exclusive inherited
flock descriptor. Each worker child uses explicit CPU3/NUMA1 placement and
inherits the same descriptor. Compiler/runtime overrides are rejected. The
copied lease helper describes correctness purpose; this stage's caller command
supplies the explicit NUMA1 memory binding. Neither proof nor formal accuracy
is authorized until root reviews and commits this source and grants the lease.

After that grant, the proof entry is:

    flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 python3 accuracy/run.py --source-commit FULL_SOURCE_COMMIT --prove-worker

The formal entry additionally requires a separately reviewed committed proof:

    flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 python3 accuracy/run.py --source-commit FULL_SOURCE_COMMIT --proof-commit FULL_PROOF_COMMIT --execute-accuracy

Run those paths from this experiment directory, and retain the complete outer
launcher streams and actual terminal result. Merely preparing these commands
does not grant a compile or calibration lease.
