# Internal Rust singleton caller: bounded proof passed

The newly derived native-host and portable-runtime callers passed on the first attempt under source commit `23e9b075a295deb11c3073cc3b4182b5810a9057`. Both executed AVX512 on CPU3/socket1 with explicit NUMA1 child binding. The whole operation held the inherited exclusive socket lock, and it was explicitly released after completion.

- 2 rebuilt caller executables; 24 unique actual source-input files.
- 20 tiny public rows, including opposite API order in both profiles.
- 8 invalid CLI rejections and 4 injected post-warmup output failures, each exact exit 1 with empty stdout and the expected diagnostic.
- 43 retained commands: 31 successful and 12 expected rejections.
- Native/portable actual ELF captures and manual public/clock-boundary review.

All rows use only the seen seed74381, n256, q4096, actual24bpk and four query repetitions. Their complete semantic fields match the committed original native/portable reference fixtures from proof `d5049cdc15661bccbfbc875e21b3c8696be46036`; cross-profile and opposite-arm identities also match. Every timed query is poisoned and fully validated outside clocks, with full bitmap/no-false-negative/input guards retained. Incidental check timings were not ranked.

The derivative preserves both complete native module closures, `query.rs` and the literal clock/work/full-output-validation block. CLI, dynamic workload bounds, metadata and whole/API order are the only caller changes. Local runtime N/Q/REPEATS preserve the original block spelling, but do not preserve compilation decisions: the rebuilt `timed_work` is outlined in both arms/profiles. Native visible SIMD remains inlined; portable retains a per-key public facade call and target-feature jump. [Actual assembly review](../assembly-review/REVIEW.md) records all new symbol sizes, clock windows and GOT resolutions. Later performance must compare within each profile; no old C++/Rust latency is imported.

This stage reused the completed unchanged-kernel proof. It did not rerun the kernel/tail/ASan matrix, execute a valid formal command, collect calibration, or run the proposed 192-row experiment. No throughput, FPR, build, multithreaded, external or promotion conclusion is made. The earlier V1 collector failure and V2 recovery remain preserved in the referenced prior proof; this new caller had no failed runtime attempt.

`COMPILED_PROOF.json` records final closure separately from original capture metadata's historical pending-review flags. `COMPLETE_PROOF_ARCHIVE.json` binds all command/dependency/assembly records, the complete launcher log, this report and offline audit. Executables are retained and SHA-bound but not committed. The final formal runner, complete-data loader and lease still require their own source gate.
