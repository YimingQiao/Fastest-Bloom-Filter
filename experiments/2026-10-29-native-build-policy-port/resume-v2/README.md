# Collector-only correctness resumption

Original source `26232ad9` compiled both normal C++/Rust callers and both native
boundary executables successfully. All 12 paired caller records, both focused
native checks, deliberate output faults and 10 invalid CLI cases passed. The
subsequent dependency audit stopped because it interpreted the after-native
Rust test's relative `src/lib.rs` paths against the benchmark crate. ASan had not
started. Session73654 exited1; the complete76-file failed attempt remains intact.

This additive repair reuses all four normal binaries and all original normal
outputs at their original paths. It binds the exact126 consumed-source inputs,
34 commands, structured Cargo JSON, build database and seven actual dep-info
files. Recovered normal dependency closure has469 entries. Cargo dep-info bases
come from exact package/manifest/executable identities. For the caller's hashed
bin dep-info, the structured target name plus the exact16-hex rustc artifact
stem must identify one package. There is no search for whichever `src/lib.rs`
happens to exist. Ambiguous or missing ownership rejects.

`resume.py` preserves the normal records verbatim and executes only the pending
ASan C++/Rust build, native boundary checks,12 caller records and two injected
output failures. The before/after snapshots, native algorithms, both caller
sources, flags and finite workload remain unchanged. The existing normal and
new ASan logs remain explicitly separate sessions. Recomputed dependency
identity and all file/binary hashes are checked before and after resumption.
No normal compilation or successful normal Bloom work is repeated.

Run only after this additive source and failed evidence are committed/reviewed
and CPU2/socket0 is explicitly available. The inherited whole-socket flock and
parentCPU2 guard remain; only test/caller children expand their affinity before
NUMA binding. This stage provides correctness and provenance, not a performance
claim. Formal96 timing still requires actual-caller assembly review and a
separate reviewed binary/source freeze.
