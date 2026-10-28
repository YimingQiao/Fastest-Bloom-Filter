# Independent32 scalar-inline V2: thirteen-way preflight

This isolated harness adds the one-annotation V2 candidate from commit3b575a3
to all twelve configurations in the rejected V1 screen. Its four timed
contracts and public adapters are unchanged. Original Independent32, V1 and
V2 remain separate registrations. The original and leaf controls resolve to
their frozen experiment crates, so the later production Byte hint does not
silently alter a retained control.

The candidate changes only `#[inline]` to `#[inline(always)]` on the private
scalar helper. The intended effect is removing scalar helper calls and their
shared register-save cost from the public batch method. Actual code generation
must establish whether this happens before any performance matrix runs.

The preflight uses CPU3 under the exclusive socket1 flock. It requires all
native tests, three backend/sanitizer modes, full C++ bitmap/output parity,
thirteen public API guards,216 retained-reference semantic comparisons and
the26 typed public loops plus three generic/public batch pairs (six entries). The original
MIT/Apache licenses are retained. Preflight CLI timings are unclaimed.

Correctness and codegen checks have passed; see `EVIDENCE.md`. The proposed
208-row protocol retains sixteen size/allocation/batch cases and all thirteen
configurations, with query power22 so the large input stream matches the earlier Rust132 screen.
All before/V1/V2 ratios must come from that new same-process execution;
absolute timings from V1's smaller query-power20 matrix are not comparable.
No fresh held-out seeds, production changes or promotion are implied.
