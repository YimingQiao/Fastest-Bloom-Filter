# Resume the completed tests after Cargo artifact discovery

The first attempt ran all new fixed-K and driver tests successfully in normal,
disabled-AVX512 and ASan modes, observed all72 empty formal constructors, and
completed normal/disabled tiny CLI and malformed-input checks. The script then
rejected its own assumption that every test executable lives in `release/deps`.
Nightly Cargo reported the ASan executable under its newer nested build path.
The original source, successful output and failed guard are preserved in V1.

This additive runner changes no Rust or previous driver source. It pins the
exact executable printed by Cargo, including its SHA and dependency file, and
reuses the successful test/normal/disabled evidence only after checking every
committed source, dependency, binary, command flag and output artifact. It then
builds the ASan standalone accuracy executable with the same flags, discovers
it from Cargo's structured compiler-artifact output, and performs only the
remaining three tiny CLI fixtures and ten invalid-CLI cases. Formal112-row
accuracy and timing remain unexecuted.

All old targets and records remain available. No passed suite is rerun. The
ASan build uses the same package/cache so it can reuse its compiled dependencies;
previous test and normal/disabled executable hashes must remain unchanged.
An explicit CPU3 lease and complete socket1 flock are required. The final
compiled calibration freeze will be separate and committed before any formal
accuracy run.
