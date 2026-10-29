# Page pointer-single preflight result

The first worker preflight passed48 native and48 ASan/UBSan cases,19620 direct
caller checks,14 invalid CLI checks,6 expected output-corruption failures and8
source/contract tests. All96 rows reproduce the corresponding successful
Stage3 geometry, outputs, checksums, false-positive counts, scratch and object
size exactly. The pointer/value/backend aliases reuse30 fixture identities;
no negative samples are pooled. No performance or quality gate was run.

All16 registry entries remain: four native controls, six original Page value
facades, six pointer-direct Page facades. The source is committed at
`a4262bf21adfea64dc604f8a4b506ffebdcdfa93`; the original nine caller/protocol files
at `e4f0455b4354ef5d06840cc226ede4b3a5ca4e60` were unchanged. Four new binaries
were built with GCC12.2, native/ASan flags and one complete Boost1.92 root.
Actual commands, dependency hashes and binary digests are retained. No original
VLDB archive or previous worker was rebuilt. CPU2/socket0 was released after
the complete whole-flock run; all later assembly inspection was onCPU4.

Manual assembly review of all six pairs confirms the caller change: pointer
Query initializes `rbx` from incoming keys (`rcx`), passes `rsi=rbx` to public
Page test, and advances it4 bytes per key. Value Query still loads the key,
writes it to `0x1c(rsp)`, and passes that stack-slot address. Every pair targets
the identical constprop public `test(ptr,4)` and the identical frozen Base
DenseCall address. The public test itself remains out of line. Pointer/value
outer stack reservations are24/40 bytes; prologue/register/code layout differs,
so unchanged Dense semantics does not promise unchanged Dense performance.

The automatic run metadata intentionally still says manual ASM review was
pending at process completion. The subsequent separate
`assembly-review-v2/review.json` records the completed review; no old run
metadata was overwritten. The first extra callee collector matched weak
methods and GNU-unique empty-key data as well as the three called methods and
failed its expected-count assertion. Its nine outputs and diagnostic remain in
`assembly-review-v1`. The additive second collector selects only the three
actually called text symbols and passes all six pair observations. No measured
query source, executable or correctness run was revised for this collector fix.

`WORKER_FREEZE.json` pins all proof artifacts, four retained binary hashes and
actual consumed source files. Binary payloads remain local and are represented
by exact hashes in the committed archive, following the parent proof format.
The frozen240-row two-round caller protocol remains unmeasured; performance
requires a separate committed entry guard and explicit lease. All native and
Dense controls must stay in that comparison, with no old-executable context
normalization.
