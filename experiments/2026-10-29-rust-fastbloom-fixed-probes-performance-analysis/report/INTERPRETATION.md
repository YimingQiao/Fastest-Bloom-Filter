# Interpretation of the complete bounded public-K screen

The public K1…12 controls improve the best eligible external latency in 48/216 nested query views relative to the original three external configurations measured in this same screen. The largest improvement is 1.970×: Fastbloom K7 versus automatic K17, large-size cap24/0.01%, visible prehashed query. This replaces default-only baseline claims; all automatic configurations remain in the tables.

Range retains a specific opportunity at an actual24-bpk ceiling and0.01% FPR upper-bound target. Fastbloom K7 is the strongest eligible measured external allocation in all24 such query views. The following ratios compare those measured medians; they are not confidence intervals or independent replications.

| Keys | Query contract | Batch1 | Batch31 | Batch4096 |
|---:|---|---:|---:|---:|
| 65536 | lookup_ns | 3.437× | 7.491× | 6.872× |
| 65536 | hash_lookup_ns | 2.821× | 5.824× | 5.495× |
| 65536 | inline_lookup_ns | 4.363× | 4.351× | 4.346× |
| 65536 | inline_hash_lookup_ns | 4.513× | 4.526× | 4.513× |
| 33554432 | lookup_ns | 2.614× | 4.307× | 5.834× |
| 33554432 | hash_lookup_ns | 2.011× | 4.150× | 6.073× |
| 33554432 | inline_lookup_ns | 3.523× | 3.450× | 3.564× |
| 33554432 | inline_hash_lookup_ns | 3.087× | 3.033× | 3.131× |

This is a capacity/quality niche among the three measured Rust external families and their bounded public configurations. It is not a claim against every published Bloom filter. At cap24 the power-of-two production layouts cannot use an intermediate24-bpk allocation, and their measured smaller layouts do not qualify for0.01%; the absence of a production winner in that view is not a latency loss. Fresh seeds are still needed before a production decision.

Equal16/32-byte controls are unfavorable to Range: it loses 46/48 query and 47/48 build comparisons against production Split64; all 2 query and 1 build wins remain too. These controls do not assume identical address mapping or equal false-positive rates.

For batch1 at the larger32-bpk ceiling and0.01% target, Bloomsday remains faster for staged prehashed, visible prehashed and fused visible queries at both tested sizes. The large batch1 staged hash+query contract differs: Range takes23.743ns versus27.452ns for Bloomsday. Bulk results also differ: at large batch4096, Range24 takes5.896ns for staged prehashed queries versus8.428ns for Bloomsday32. Its extra capacity can change the eligible winner, so the24-bpk result must not be generalized to32 bpk. The full tables also retain every low-K failure, native loss and empty eligibility view.

FourSector actual16-bpk passes the current small-size0.1% Wilson gate but misses it at the large size. The large sample has16,563 false positives in16,777,216 negatives and an upper bound0.10023738%; this is a finite-sample gate miss, not proof that true FPR exceeds0.1%. Earlier higher-resolution studies concerned separately identified constructions; their timings and counts are not imported or pooled here.

All four construction boundaries are reported independently. Each has36 production wins/6 losses/12 missing views against the expanded external set, and30 Range wins/18 losses/6 missing views. These repeated nested counts share measurements and are descriptive; build ordering is fixed and only build medians are available.

The complete evidence spans two measurement sessions. The first17 cases/316 rows are untouched after an unknown exit143; only the unfinished20-row case was restarted with the same frozen executable and parameters. Within-case public API comparisons share a process. Nested-cap alternatives can span case processes, and the final large/cap32/batch4096 case is from the resumed session. No earlier completed case was rerun or discarded.
