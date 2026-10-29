# Offline analysis validation

The frozen112-row producer completed all six cases without an execution failure.
The separate sidecar verifies its exact source commit, every input and binary
pin, raw command/row order, geometry, counts, checksums,40 old semantic
reproductions and110 known mapping records before reporting any quality result.
It neither executes a filter nor reads a performance column.

The first sidecar audit stopped before writing a report because the diagnostic
selector uses integer K dictionary keys in memory while JSON object keys are
strings. `validation/` preserves the failure and its four passing synthetic
tests. The final guard compares the explicit JSON data model; no filter result,
eligibility rule, raw artifact or producer source changed. The first sidecar
source was not separately frozen; the retained traceback and this described
one-expression correction are the available attempt evidence.

`validation-v2/` contains the final five passing synthetic tests and successful
complete-data audit. The extra test covers that integer-key serialization
contract. Other tests require all72 fixed-K records, preserve all failures,
accept nonmonotonic quality and reject a changed proven alias. The unchanged
producer separately checks exact112 coverage and source-derived order, every
full public dense answer, byte/probe metadata, actual lease and all40 old
count/checksum reproductions.

No correctness suite, accuracy run or benchmark was repeated for this sidecar.
The preserved output has112 API records and110 unpooled mapping records; all
two-size/three-budget fixed-K rows remain available. Min-K values describe
quality qualification only and are not latency selections.
