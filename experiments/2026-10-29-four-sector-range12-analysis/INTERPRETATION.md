# Interpretation and next decision

K12 has a specific initial bulk opportunity at the 24-bpk/0.01% quality gate. It wins against both the strongest eligible measured external and the strongest eligible retained project in all eight size×batch×query-contract views at that cap. The full 72-view result is mixed: 26 wins and 30 losses versus externals, 12 wins and 44 losses versus retained projects, with 16 views where K12 is ineligible. These view counts reuse measurements across nested caps and are not independent experiments.

| Keys | Batch | Query contract | Best external / K12 | Best retained / K12 |
|---:|---:|---|---:|---:|
| 65536 | 31 | lookup_ns | 1.63244× | 1.19266× |
| 65536 | 31 | hash_lookup_ns | 1.32032× | 1.02840× |
| 65536 | 4096 | lookup_ns | 1.82298× | 1.41713× |
| 65536 | 4096 | hash_lookup_ns | 1.57398× | 1.31279× |
| 33554432 | 31 | lookup_ns | 1.20112× | 1.23606× |
| 33554432 | 31 | hash_lookup_ns | 1.21041× | 1.11443× |
| 33554432 | 4096 | lookup_ns | 1.15353× | 1.07380× |
| 33554432 | 4096 | hash_lookup_ns | 1.10713× | 1.03469× |

At cap 24 the best retained project is optional Split64Range at the same actual allocation. The strongest external depends on size and batch: FastFilterFixed64 at small size, RocksDB K8Batch32 at large batch31, and BoostMulti64K8 at large batch4096. All these controls remain in the complete new screen. No older latency is used in these ratios.

Four additional combined wins occur at cap 32 for the large-size strict gate, where K12 still uses 24 bpk. These are broader-cap interpretations of the same measurements, not four new workloads. K12 at 32 bpk is selected as its own best allocation in three small-size/batch 4096/hash views, but loses the retained-project leader there; it must not be described as never selected.

Quality limits matter: K12 at 16 bpk has upper bounds about 0.1284%/0.1289%, so it fails the 0.1% and 0.01% gates at both sizes. K12 at 24 bpk passes the strict gate with upper bounds 0.00912355%/0.00934361%; 32 bpk has wider margin. These finite samples do not prove an all-input guarantee. The complete six candidate records and all 92 reused control records are retained without pooling.

Recommendation: keep the algorithm experimental pending a fixed fresh-seed confirmation of the 24-bpk strict bulk niche. Preserve both batches and both query contracts, equal-size optional Range and the training-derived external leader union; retain other eligible production/baseline evidence when fixing that union. Balance candidate/filter order before any new outcomes. The weakest raw-query advantages versus Range are only 2.84% small/batch31 and 3.47% large/batch4096, so this single training seed does not justify unconditional promotion or replacing the existing default. No new test, baseline exclusion or parameter tuning was performed for this recommendation.
