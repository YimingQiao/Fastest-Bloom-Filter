# Final offline provenance closure

Both normal and ASan functional suites have passed:24 paired native caller
records,48 incremental boundary cases,768 pure helper boundary cases,10 invalid
CLI cases and4 injected-output failures. All8 actual binaries remain frozen.
Neither collector attempt returned success, so both exit1 records and their
original complete=false metadata remain untouched; this stage does not relabel
them. The new final audit constructs an explicitly combined correctness proof.

The second collector stopped on nightly Cargo's relocated caller dep-info at
`release/build/native-build-policy-port-proof/<16hex>/out/policy_confirmation.d`.
Cargo reported the final `release/policy_confirmation` executable. The actual
sibling executable and reported executable are byte-identical (and were observed
to share an inode). The new mapping requires exact dependency-rule LHS, structured
Cargo package/manifest/target identity, exact directory/16-hex/target shape and
matching full executable SHA. It never selects a directory by source-file
existence. Unknown or ambiguous identities and unequal binaries reject.

Original normal provenance stays tied to its34 commands/12records/4binaries and
469 compiler inputs. The second24-command attempt supplied the missing ASan
checks and470 inputs. All raw outputs, structured Cargo JSON, actual dependency
text and compile databases are retained with original absolute paths. The final
audit checks both immutable source commits and their archived evidence, all full
caller semantics and live hashes. It performs no compilation or Bloom execution.

Only after this additive source and the49-file second failed attempt are committed
may `audit.py --source-commit ... --output combined-proof.json` emit complete=true.
Actual native caller assembly inspection and a separate binary/performance freeze
remain required before any formal96 timing. No native/caller/algorithm/threshold
source changed during either collector repair; no successful filter work is rerun.
