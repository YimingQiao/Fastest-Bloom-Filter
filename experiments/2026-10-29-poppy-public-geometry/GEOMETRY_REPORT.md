# Completed public constructor and allocation proof

All 86 frozen Poppy public constructor rows passed on the first attempt, using
the exact source committed as `82636d04e038d53c11cc96e5ce7f82cc7dc1ebb3`.
The whole operation held socket1's exclusive lock on CPU3; the lease has ended.
Eight commands completed successfully, including seven offline tests and two
streaming-parser tests. No keys were inserted, no membership workload ran, and
no throughput samples were collected.

Actual constructor-owned requested heap sizes range from 73,728 to 138,412,032
bytes. Every public getter, serialized bucket count, probe count, cache size,
real input capacity and exact requested-FPR bit pattern matches the source-only
ledger. Constructor peak allocation equals final owned allocation in every row,
and dropping each filter releases exactly that allocation. The inline object
is 128 bytes; allocator bookkeeping is not included in requested heap bytes.

The streaming inspector retained only 56 metadata bytes. Public serialization
temporarily allocated 8,192 bytes in every row and released it completely. This
inspection scratch is recorded separately from the retained filter allocation.
All 24 ordinary controls and 62 selected public-K configurations remain in the
raw output, including configurations above every tested memory cap.

The archive contains all eight raw command pairs, structured Cargo metadata and
compiler artifacts, the exact dependency lock and 66 actual dep-info files.
Those dep-info files retain their original text and absolute paths; this stage
does not claim to resolve every relative compiler dependency into a consumed
source closure. Both tested binary hashes are retained; binaries are not committed.
The counting executable is for allocation proof and will not be used for timing.

This establishes constructor geometry and byte accounting only. Public byte
insertion/query semantics, full input presence, error handling, independent
false-positive calibration and performance comparisons are still pending.
