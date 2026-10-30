# V1: compiled successfully, rejected before runtime

Source1f409288 completed source derivation, synthetic guards, native metadata,
both native library-test builds and the native actual-caller build. The driver
then rejected a dep-info mapping before executing any focused test or Bloom
filter case. All three native executables remain at their original paths with
hashes in metadata.json; no executable is committed.

The reused collector interpreted relative member paths against the member
manifest directory. Cargo's workspace build emits `control/src/lib.rs` and
`candidate/src/lib.rs` relative to its structured `workspace_root`, so joining
against the member directory duplicates that component. The exact target
source is consequently absent, and the fail-closed check worked as intended.

Six original dep-info files, original Cargo metadata/artifact output and an
explicit target/workspace observation are retained. V1 remains incomplete.
A later additive collector may select a base only by unique equality with the
structured Cargo target source, never by trying existing files. It should reuse
these successful native binaries, not rebuild them.
