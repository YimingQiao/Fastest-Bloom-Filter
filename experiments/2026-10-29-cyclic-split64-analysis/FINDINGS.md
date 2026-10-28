# Decision: no promotion from this screen

The cyclic mask shortens computation but its worse false-positive rate
requires more bitmap space. Across the measured shortlist and nested quality/
memory views, it does not beat the strongest eligible project implementation.
All eight cyclic allocations remain in the archive.

Against the fastest retained external allocation, cyclic loses all8 eligible
prehashed views and7 of8 common-hash views. These sixteen views reuse data
and are not sixteen independent experiments. The lone external win is the
large table's strict0.01%/cap32 common-hash view: cyclic28 measures5.9095ns,
versus approximately24-bpk BoostMulti64 at5.9674ns (ratio1.0098). However,
Split64Range at actual24bpk measures5.4769ns, making cyclic7.9% slower with
16.7% more bitmap space. That isolated external comparison does not establish
leadership or justify promotion.

The small strict case is also a loss against the stronger available filters:
cyclic's best pure/hash values are1.4502/1.9992ns, versus external
1.2639/1.7925ns and production FourSector1.1319/1.6307ns. Cyclic can beat the
small-table Split64Range control, but the other eligible implementations are
faster. All original/range/external choices are retained separately.

Quality costs persist at both tested key counts:

| Actual bpk | Wilson95 upper FPR range | Qualification |
| ---: | ---: | --- |
| 16 | 0.131367–0.132309% | fails0.1% |
| 24 | 0.016657–0.016742% | fails0.01% |
| 28 | 0.007532–0.007538% | passes0.01% in this training sample |
| 32 | 0.003992–0.004085% | passes0.01% in this training sample |

The prior FourSector16 failure remains explicit. Its n=65536 held-out upper
endpoint reached0.100111%, above0.1%, even though its current seed42 training
row qualifies. The current report flags that production selection; it does
not claim to repair the previous three-seed result. No confidence samples
or latencies are pooled with the historical screen.

All62 rows,13 exact source-derived orders, actual geometries, committed local
archive,214 source pins and27 binary pins passed verification. Eleven focused
offline tests and an independent read-only analysis review passed. Timing
scope remains seed42, CPU3/socket1, batch4096, q2^22,six balanced query repeats,
calibration2^24, one complete untimed build per filter. Case order is fixed;
one randomized within-case order is not pair-order balance. Trial ranges are
preserved and are not confidence intervals for speed.
