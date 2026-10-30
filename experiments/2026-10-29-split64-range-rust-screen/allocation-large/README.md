# Actual large-grid allocation audit

Source-only additive follow-up to the successful main preflight. Its allocator
tests covered smaller fixtures; this program observes all eight APIs at both
planned item counts2^16/2^25 and16/24/32-bpk ceilings. It performs no insertion,
lookup, calibration or timing. All48 constructors must request exactly the
reported backing bytes in one retained heap allocation, then free that
allocation completely before creating the next filter.

The program includes the exact frozen current public adapter prefix and native
crate. `src/allocation.rs` is the unchanged test allocator module. No old
source, algorithm, compiler-facing filter hint or passed test is modified.
The backing contract counts requested Rust heap bytes, including explicit
padding; it does not claim allocator usable-size, process RSS or object-stack
bytes. Native cap24 aliases allocate16bpk; Range and the external families
allocate24bpk. Fastbloom retains its real-item-count probe policy.

After review/commit and a separately assigned CPU3 lease, run `run.py` with
`--source-commit FULL_COMMIT` under the same inherited socket1 flock, taskset3
and `BF_SOCKET_LEASE=socket1-cpu3` environment. It checks every committed input
before and after, rejects Python -O, retains failed logs and emits a complete
allocation-only report. This addition does not authorize the120-row speed run.
