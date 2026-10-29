# Bounded build-request wrapper correctness

The first committed attempt at3251b2cdc38d6ba2e2d0c79664516c1424caa2e6 passed
all21 commands with their expected outcomes. This is correctness evidence only;
no throughput or quality calibration was run and no production code changed.

- Four binaries: normal C++/Rust, C++ ASan+UBSan, Rust ASan.
-48 real configurations: six cases per layout × two languages × two modes.
-144 sequential filter lifetimes with the same history for serial reference,
 disabled wrapper and bounded candidate. Only one native bitmap lives at once.
-1,344 cheap spy cases verify8,064 method forwards, exact slices/pointers,
 delegated return values, effective build request and untouched query request.
-All1,009,778,688 streamed old-key and9,437,208 new-key presence checks pass.
 These are repeated correctness operations, not independent negative samples.
-Every variant verifies all32,771 mixed dense answers with both serial and
 original-request parallel lookup, plus prefix/suffix guards.
-12 semantic geometries match exactly across languages and sanitizer modes;
 each language's worker/scratch accounting also matches its normal/ASan pair.
-Two invalid CLI modes are rejected without stdout; C++ exit1 and Rust panic101
 are the expected negative-test outcomes, not failed attempts.

At the real small-table populated/hotspot boundary, requested4 changes from
nativeW4 to candidateW1 and scratch becomes0. At65,537 inputs and at the first
representable footprint above256KiB, native worker selection remains unchanged.
The large populated filters retain requested8. The256KiB explicit1 case remains1.

The large-table automatic case observes C++W16 and RustW3, as expected from
their existing different native automatic policies. Neither is rewritten. Both
getters and insertion run under the same allowed CPU mask2,4,6 and node0 memory
binding; the parent holds CPU2 and the inherited exclusive socket0 flock.
Requested workers may exceed the three allowed correctness cores. Query requests
are forwarded unchanged; this does not claim identical query worker counts or
individual worker pinning across languages.

All65 prepared local inputs remained byte-exact. Compiler dependency records
bind407 distinct actual headers/sources, including representative wrappers and
native modules. Original dependency paths and compiler commands are retained.
The four executable hashes and selected normal paths are in COMPILED_FREEZE.json;
no executable is committed. All original13 wrapper artifacts and36 native source
pins remain unchanged. The path-only Cargo.lock passed --locked --offline.

No compiler or runtime failure occurred. The next step, if authorized, is a
separately fixed finite performance ledger that preserves incremental/history
semantics and reports actualW/scratch; these tests are not performance evidence.
