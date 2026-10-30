# Pre-data source/capture notes

The initial formal-runner offline test failed while importing its `contract.py`:
putting the reused caller/preflight directory first in `sys.path` selected that
directory's different module with the same name. `offline-v1.stderr` retains the
traceback. The helper path now appends after the formal runner directory; all
8offline guards pass in `offline-v2`. This was source preparation only, before
any formal BF process, and changed no producer or planned workload.

Independent read-only review of corrected linked ASM confirms both visible
caller loops' direct per-key calls to `contains_scalar` at0x8dc40, six saved
registers plus72-byte caller frame, and five saved registers in that helper.
The common hash appears before the call in the fused visible loop. Batch
`lookup_hashes` also has a separately emitted `contains_scalar` at0xa0210 for
its scalar/remainder paths; its YMM/ZMM gather paths and backend/size branches
remain. The formal108 binary is unchanged. These are codegen observations,
not a speed estimate, correctness failure or justification for quietly altering
a hint before measurement.

Before formal execution, review added MALLOC_ARENA_MAX/ASAN_OPTIONS/UBSAN_OPTIONS
to rejected environment overrides and requested that successful stderr contain
no diagnostic. Checking the seven archived normal fixtures showed that the
unchanged caller always prints its SBBF backend information, even when SBBF is
not selected. The final guard therefore requires exact byte equality with those
seven identical, committed informational outputs; empty or additional stderr is
rejected. The earlier empty-stderr source guard never executed a formal workload.
`offline-v4` includes the actual archived-byte and added-diagnostic regression.
