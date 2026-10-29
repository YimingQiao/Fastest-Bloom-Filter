# Engineering decision

Keep the current default build-worker selection unchanged. Close this fixed
policy investigation without more repetitions or threshold tuning. The
correctness proof remains useful, and large small-workload reductions were
observed consistently; the current data do not establish a generally harmless
default change outside that workload.

The prescribed result is unchanged: among36 exact language/family/scenario/
contract groups, one is consistently faster under the full negative-control
gate, four are practically within the±3% engineering band, and31 remain
unresolved because the negative controls do not meet that gate at both seeds.
The sole passing faster group is C++ Split64's prefilled small hotspot
insertion. The four within-band groups are large allocation+build, one per
language/family. No group qualifies as consistently slower. These labels do
not convert all other observed effects into zero or prove no regression.

In all24 active-gate contracts across both fresh seeds, Policy beats both
A0 and A1:48 individual comparisons, with all corresponding Policy intervals
below0.97. Across those observations the C++ latency ratio is0.320–0.439
(about2.28–3.13× build speedup), and Rust0.210–0.301
(about3.32–4.76×). These are build-duration comparisons within each language,
not cross-language or external claims. Most active groups remain formally
unresolved because the conservative classification also requires stable
unchanged-code negative controls. This does not erase the large observed
benefit from avoiding parallel setup on the measured256KiB/small-batch cases.

Outside the gate, all96 Policy/A0 and Policy/A1 comparisons are retained:
46 are point-slower and50 point-faster. Their latency ratios span0.946–1.068.
The unchanged-path A1/A0 point ratios span0.935–1.062, and the clone controls
also vary. This is evidence that caller/layout/order/thread-launch variation
is material at these durations; it does not identify a single causal source
or justify subtracting a noise correction from the policy results.

The two predeclared targets remain unresolved:

- C++ Split64, n65537,256KiB,T4, insert: Policy/A0 is1.0568 and1.0040 at
  the two seeds; Policy/A1 is1.0682 and0.9703. The full intervals are in
  `report/REPORT.md` and cross the engineering boundaries.
- Rust Split64, n65537,256KiB,T8, allocation+insert: Policy/A0 is0.9884
  and1.0168; Policy/A1 is1.0107 and0.9961. The earlier repeated losses are
  not reproduced as a stable effect under this fixed control design, but
  the experiment also does not demonstrate a universally negligible cost.

An explicit opt-in adaptive-build policy is a reasonable product proposal
for applications that knowingly target small bitmap/build batches. It must
retain exactly the tested inclusive gate (current insertion length<=65536
and actual bitmap<=256KiB), run its decision inside the actual public method,
forward the original requested count elsewhere, and leave query selection
unchanged. It should be described as an optional tradeoff with measured
small-case gains and unresolved outside-case latency—not as a safe universal
default. This report does not introduce or validate a second public API.
Callers can already request one build worker explicitly when that is their
known workload; the existing native API needs no default change to do so.

Leave the bounded-policy commit isolated for now. Move engineering effort to
the separate K12 insertion hypothesis and the already validated native filter
integration. No new same-policy A/A runs, fresh seeds, narrowed classification
criteria or unmeasured default behavior are proposed. The full432 contrasts,
all166 individual point-slower outcomes across the six named directions,
3,456 cycle records and9,216 raw sample references remain archived.
