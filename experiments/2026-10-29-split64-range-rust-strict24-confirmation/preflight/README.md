# No-rebuild subset preflight

This additive stage preserves all initial87300b66 proposal bytes. It reuses the actual frozen full336 native and ASan executables; it builds nothing and does not run either held-out seed.

The initial proposal's predicted job order used q/2 positive draws instead of the producer's exact `i%100<hit` count. [The additive pre-data correction](ORDER_CORRECTION.md) preserves the initial ledger and all seeds/commands while fixing only predicted API order. Both seeds still balance the pair at every size/batch. `corrected-selection.json` is the future execution order authority.

The subset guard is the exact frozen336 guard except two functions: selecting the training-derived Range/K7 pair at cap24, and validating the fixed12-case/24-row protocol. Registry parsing, source-derived row order, geometry/probe accounting, four-phase balance, complete trial/median/range checks, checksum/FPR fields and cross-batch no-pooling checks are unchanged. `subset_guard.py.patch` and derivation checks make that scope explicit. The complete20-name underlying public registry remains pinned; no private API replaces a measured call.

The bounded execution is four tiny valid commands: native and retained ASan, n1024/q4096, cap24, hit50%, batches31/4096, repeats4, seed101, full insertion and calibration4096. The resulting8 rows must pass every unchanged per-row guard and match across ISA/sanitizer artifact and batch by full checksum, FPR and geometry. The frozen producer already compares full timed outputs with its warm reference and checks every inserted key. Its fault/phase suites and broader fixed-K bitmap tests are reused rather than rerun. Three native malformed-subset commands must reject before printing CSV.

Actual whole-socket flock ownership, explicit CPU2 orCPU3 affinity and matching environment are required for this short correctness-only run after a source commit and explicit grant. Every original592 source/dependency/binary pin is rechecked; the new proposal/derivation/runtime protocol are bound to committed bytes. Capture all actual command outputs and exit codes, refuse existing output directories, preserve failures and verify all pins again at completion. No tiny timing is used for candidate selection or a performance claim.

The formal fresh24-row runner is a later committed stage. It must preserve the full seed ledger, exact source-derived orders, raw/aggregate equality, all8 unpooled quality records and both query/build limitations already specified in the initial proposal. This preflight does not authorize that run.
