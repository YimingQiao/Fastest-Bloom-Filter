# V2 improves batch-one calls, but is not ready to promote

The private scalar-helper inline hint fixes V1's expensive public-method
prologue. In the completed same-process208-row screen, generic batch-one
prehashed throughput improves by10.2–20.0% over unchanged Independent32 in
all four size/allocation conditions. Staged hash+query improves1.9–10.8% in
all four. This is a useful result, with remaining regressions.

At batch2, small-table prehashed times rise from2.435 to2.839ns/query at
actual32bpk:16.6% slower. Both small allocations lose by about that amount;
the large16bpk case wins and large32bpk loses2.1%. At batch31, staged
hash+query loses all four comparisons, by0.05–2.95% in latency. Batch4096
is mixed and close to parity. Across all64 reused original/V2 query-mode
comparisons there are37 wins and27 losses; this is a descriptive count,
not64 independent experiments. Every loss and trial range is retained.

Strict0.01% FPR at the32bpk cap is now a narrow generic batch-one win over
the retained Rust external leader, Bloomsday:

| Keys | V2 pure / staged ns | Bloomsday pure / staged ns | External/V2 |
| ---: | --- | --- | --- |
| 65,536 | 3.242 / 5.621 | 3.257 / 6.014 | 1.005 / 1.070 |
| 33,554,432 | 14.123 / 27.022 | 14.463 / 27.568 | 1.024 / 1.020 |

The compiler-visible singleton path retains the original layout's clearer
external advantage (roughly16% pure and6–22% fused at batch tag1), but the
V2 annotation does not consistently improve that path over the original.
Generic batch2 pure queries still lose to Bloomsday at both sizes. Existing
native large-batch leaders remain in all constrained rankings; beating these
three external families does not establish dominance over other native or
external configurations.

Actual32bpk Independent32 has pointwise Wilson95 upper FPR0.003986%/0.003899%.
Actual16bpk has0.129867%/0.132747%, failing0.1%. Original, V1 and V2 have
identical bitmaps and quality records. These seed42 streams reproduce the
earlier q22/cal24 mapping observations; they are not new held-out evidence.
No quality samples are pooled across aliases, modes or batches.

V2 is last in both source-derived filter orders. Original/V1 occupy positions
0/1 at n64K and6/7 at n32M. Four-mode phase balancing does not remove this
between-filter order limitation. A fresh confirmation must preserve both
pair-order strata and all regression cases before promotion. The128
construction comparisons also stay visible; insertion source is unchanged,
and allocator/code-placement differences cannot be attributed to a faster
insertion algorithm.

Decision: keep V2 isolated. The single-key improvement is promising, but its
batch2 regression prevents treating this as a general replacement. No
production implementation changes as a result of this screen.
