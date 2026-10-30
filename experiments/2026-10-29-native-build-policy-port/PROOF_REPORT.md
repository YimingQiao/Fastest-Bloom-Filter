# Actual-native bounded-policy correctness and provenance

Normal and ASan checks passed for the exact native before/after snapshots:
`e8b89cd3c7c090287d1d4222db981ec7f8fb86ab` and
`2b3469f02c8dafc2219a132c681c14529e79995d`.
The actual caller source is frozen at
`26232ad9b1412e64346e09f40de15f8ef77c52f7`.

The complete proof contains24 paired caller records,48 native boundary
cases,768 pure helper cases,10 invalid CLI cases and4 injected output faults
across58 commands. All intended-success commands passed, all deliberate
rejections failed, and complete old/new membership plus guarded dense outputs
agree across language/backend. Eight binary hashes are retained; formal
performance will use only the two normal caller binaries. The compiler input
closure contains469 normal inputs and470 ASan inputs,470 in their union.

Two original driver attempts ended with status1 after functional checks had
passed. The first collector did not resolve a Rust test dep-info path relative
to its actual package. The additive V2 repair reused all normal results without
rebuilding, then completed ASan and stopped on nightly's relocated binary
path. Both failed metadata files, logs, outputs and binaries are preserved.
Neither failure was a filter correctness or sanitizer failure.

The final V3 audit is committed at
`fe7c80762ab2e0e3020b87626b9ab2ad53376cf7`. It executes no compiler or filter.
It requires structured Cargo package/manifest/target identity, exact actual
relative dep-info LHS, and full SHA equality between nightly's actual sibling
executable and its reported final executable. Unknown or ambiguous ownership
is rejected; it never resolves duplicate `src/...` files by first existence.
`provenance-v3/combined-proof.json` is the separate complete record and retains
both earlier incomplete attempts explicitly.

The actual public native policy is the only build change: insertion length
at most65536 and actual bitmap size at most256KiB use a single build worker;
all other requested workers, automatic-worker behavior and query requests
remain unchanged. Four/Byte helpers and all kernels remain unchanged.
Correctness approval does not establish a performance benefit. The completed
wrapper experiment contained repeated outside-gate regressions; the same96
cases must be measured with the actual native callers before any default
integration decision.

Binary-specific timing review and exact evidence windows are under
`assembly/`. The C++ review already verifies four candidate paths and four
old-control paths. The native methods remain actual calls, with originalT
loaded after the start clock; their inclusive size/length comparisons execute
inside the called native methods. Rust review verifies all four candidate intervals and traces raw crate
disambiguators through pinned Cargo artifacts, rlib symbols and GOT relocations.
Both languages therefore pass the actual-native inside-clock gate for these
exact normal artifacts. No compiler flags, inline hints, opaque wrapper or policy
threshold was changed in response to assembly inspection.
