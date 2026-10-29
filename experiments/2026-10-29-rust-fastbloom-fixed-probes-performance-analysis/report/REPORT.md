# Complete public Fastbloom probe-count performance screen

This is the complete seed42 training screen of production4, Range, and the three public external families, including every Fastbloom K1…12 plus its original automatic11/17/22-probe controls. All336 rows are retained. It is not held-out confirmation or a global fastest claim.

Each of216 query views fixes key count, batch tag, actual-byte ceiling16/24/32, Wilson95 upper-bound FPR ceiling1%/0.1%/0.01%, and one of four API contracts. Every view sees all56 measured allocations for that size/batch. Smaller allocations compete under larger caps; all12096 alternatives retain failures, losses and exact ties. No diagnostic minimum-K selection removes a timing row.

| Query contract | Best production vs expanded external W/L/T | Missing | Range vs expanded external W/L/T | Missing |
|---|---:|---:|---:|---:|
| lookup_ns | 32/10/0 | 12 | 23/25/0 | 6 |
| hash_lookup_ns | 40/2/0 | 12 | 27/21/0 | 6 |
| inline_lookup_ns | 31/11/0 | 12 | 14/34/0 | 6 |
| inline_hash_lookup_ns | 33/9/0 | 12 | 14/34/0 | 6 |

These are descriptive nested comparisons of measured medians. They are not independent statistical victories. Ownership classes remain explicit; the native experimental Range is never counted as an external baseline. Each mode selects its own fastest eligible allocation.

## What the public K grid changes

The earlier default constructor selected11/17/22 probes at actual16/24/32 bpk. This screen calls the pinned public `.hashes(K)` builder for every K1…12 without changing upstream storage, hashing or query kernels. Every configuration uses real n and the same exact allocated byte ceiling. All mixed and independent calibration counts reproduce the previously frozen112-row accuracy matrix.

baseline-expansion.csv compares the original three external configurations against their expanded set in this same screen. Each exact size/cap/batch executes all its APIs in one process; nested-cap choices can span separate case processes. It imports no older latency and retains all216 views. The fixed/default table additionally keeps1728 equal-byte query/build pairs, including unqualified fixed-K settings and losses; equal bytes are not assumed to mean equal FPR.

| Keys | Contract | Batch | Cap | FPR ceiling | Best expanded external | External ns/key | Best production | Production ns/key | Range ns/key |
|---:|---|---:|---:|---:|---|---:|---|---:|---:|
| 65536 | lookup_ns | 1 | 16 | 0.001 | Fastbloom017K6@16 | 13.9113 | Split64BloomFilter@16 | 4.0923 | 4.2239 |
| 65536 | lookup_ns | 1 | 24 | 0.0001 | Fastbloom017K7@24 | 14.5280 | none | — | 4.2273 |
| 65536 | lookup_ns | 1 | 32 | 0.0001 | BloomsdayPinned@32 | 3.2603 | Split64BloomFilter@32 | 4.1002 | 4.2270 |
| 65536 | lookup_ns | 4096 | 16 | 0.001 | Fastbloom017K6@16 | 11.0624 | FourSectorBloomFilter@16 | 1.1014 | 1.6924 |
| 65536 | lookup_ns | 4096 | 24 | 0.0001 | Fastbloom017K7@24 | 11.6229 | none | — | 1.6914 |
| 65536 | lookup_ns | 4096 | 32 | 0.0001 | BloomsdayPinned@32 | 1.5108 | FourSectorBloomFilter@32 | 1.1617 | 1.6861 |
| 65536 | inline_hash_lookup_ns | 1 | 16 | 0.001 | Fastbloom017K6@16 | 13.4645 | Split64BloomFilter@16 | 3.0909 | 3.1360 |
| 65536 | inline_hash_lookup_ns | 1 | 24 | 0.0001 | Fastbloom017K7@24 | 14.1596 | none | — | 3.1377 |
| 65536 | inline_hash_lookup_ns | 1 | 32 | 0.0001 | BloomsdayPinned@32 | 2.1470 | Split64BloomFilter@32 | 3.1093 | 3.1377 |
| 33554432 | lookup_ns | 1 | 16 | 0.001 | Fastbloom017K6@16 | 30.2242 | Split64BloomFilter@16 | 11.9346 | 11.7789 |
| 33554432 | lookup_ns | 1 | 24 | 0.0001 | Fastbloom017K7@24 | 39.6952 | none | — | 15.1873 |
| 33554432 | lookup_ns | 1 | 32 | 0.0001 | BloomsdayPinned@32 | 14.3141 | Split64BloomFilter@32 | 17.1187 | 15.1873 |
| 33554432 | lookup_ns | 4096 | 16 | 0.001 | Fastbloom017K6@16 | 25.5490 | Split64BloomFilter@16 | 4.7909 | 4.9237 |
| 33554432 | lookup_ns | 4096 | 24 | 0.0001 | Fastbloom017K7@24 | 34.3988 | none | — | 5.8962 |
| 33554432 | lookup_ns | 4096 | 32 | 0.0001 | BloomsdayPinned@32 | 8.4278 | FastPatternBF@32 | 6.0683 | 5.8962 |
| 33554432 | inline_hash_lookup_ns | 1 | 16 | 0.001 | Fastbloom017K6@16 | 28.6831 | Split64BloomFilter@16 | 9.0602 | 9.2963 |
| 33554432 | inline_hash_lookup_ns | 1 | 24 | 0.0001 | Fastbloom017K7@24 | 36.9404 | none | — | 11.9672 |
| 33554432 | inline_hash_lookup_ns | 1 | 32 | 0.0001 | BloomsdayPinned@32 | 10.4282 | Split64BloomFilter@32 | 12.6345 | 11.9672 |

The complete tables retain the other thresholds, batch31, visible prehashed and staged common-hash modes. Visible public singleton loops remain whole-array calls: the batch tag does not change those loops. SBBF public dispatch and each library’s public method remain intact. No private external kernel is substituted.

## Quality, construction and controls

The112 API/geometry/size/seed observations each use the same2^24 independent negative keys as frozen calibration. Repeated batch tags and four query modes do not increase the denominator. Only the proven default16/K11 constructor aliases are collapsed, yielding110 known mapping records; other public families are not pooled even if counts happen to match. Every point rate and two-sided95% Wilson bound remains in the quality files.

The minimum qualified fixed K for1%/0.1%/0.01% is3/6/none at16 bpk,2/4/7 at24 bpk, and2/3/5 at32 bpk, at both tested sizes. These are quality outcomes, not assumptions about the fastest K. A Wilson upper bound crossing a target is a precision gate failure, not proof that the true rate exceeds that target. Current seed42 gates govern this training ranking; historical FourSector precision studies are separate context and do not silently exclude current rows.

All four build metrics have their own216 views and12096 alternatives: insertion, allocation+insertion, common-hash insertion and allocation+common-hash insertion. Original fixed build ordering is retained. Only build medians are recorded by the frozen CSV; no per-trial dispersion is invented. Query trial vectors, minimum/maximum and exact phase order are retained in every query alternative.

same-allocation-controls.csv retains96 Range versus production Split64 query/build pairs at actual16/32 bpk. Equal allocation does not imply identical address mapping. api-ratios.csv retains672 original-staged versus visible-public comparisons. All individual losses remain in these tables and the full alternatives; this is a serial benchmark, not a parallel-build comparison.

## Provenance and interrupted-workload completion

Measured source `571186b420bf7e5fc08269ed4a65feab42ac8400`; real timed executable SHA `f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05`. The new executable comes from the original committed timed package, not the untimed accuracy entry. Complete preflight passed native/ASan actual timed-output fault checks, phase checks,336 tiny semantic rows and14 malformed CLIs; fixed-K bitmap/allocation validation was reused from the prior pinned evidence.

The original matrix was interrupted during its last workload: the process tool returned143, with an unknown termination cause. Its first17 cases/316 rows and original complete=false metadata are retained at commit ab98c241. A source-review issue in the future finalizer would have overwritten the command ledger, but that overwrite never occurred. The read-only observer retained25 exact inotify checkpoints; none contained18 completed cases. Only the unfinished final20-row workload was restarted under the separately committed504e1a27 driver, using the identical f499 executable and full original arguments. The first17 completed cases were not rerun. The derived336 archive copies their raw bytes exactly and explicitly records the interrupted and resumed sessions, while leaving the original metadata unchanged. A separate case_count avoids the future finalization bug. Every command, order, raw hash, trial, interval and semantic count is checked with the frozen producer audit before analysis.

The source audit verifies592 frozen input hashes and committed blobs, exact compiled anchors, all dependency trees and executable hashes. Each session held an exclusive CPU3/socket1 inherited flock; CPU affinity was applied without explicit NUMA memory binding. Case/filter ordering, allocator placement and one training seed remain practical limits. The four query phases are balanced within each row; unrelated rows and build phases do not acquire extra statistical independence from that schedule.
