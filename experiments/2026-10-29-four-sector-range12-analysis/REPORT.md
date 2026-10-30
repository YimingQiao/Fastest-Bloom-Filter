# K12 initial bulk training screen

This is the complete fixed seed 42 screen: 26 cases, 296 rows, two public query contracts, and every planned allocation. It is not a held-out or global-fastest result. The following counts select the fastest currently eligible K12 allocation in each of the 72 prespecified size/batch/cap/FPR/metric views; ties and unavailable comparisons remain explicit.

| Comparison | Wins | Losses | Ties | K12 ineligible | No eligible comparable rival |
|---|---:|---:|---:|---:|---:|
| K12_vs_external | 26 | 30 | 0 | 16 | 0 |
| K12_vs_retained | 12 | 44 | 0 | 16 | 0 |

[The frozen registry](../2026-10-29-four-sector-range12-screen/registry.json) contains20 retained external API configurations, four production layouts, optional Range and K12. It is a previously selected strong shortlist, not every external configuration investigated in this project. [All raw commands and hashes](../2026-10-29-four-sector-range12-screen/screening/results-v1/metadata.json) and the [predata analysis rules](../2026-10-29-four-sector-range12-screen/screening/ANALYSIS_RULES.json) remain available.

K12 quality is reported once per new size/allocation bitmap, with each 2^24-negative sample kept separate. Reusing the bitmap across two batch sizes does not increase sample size. Wilson 95% upper endpoints determine the three current-seed gates; they are finite-sample evidence rather than universal true-FPR guarantees.

| Keys | Actual bpk | Backing bytes | False positives / negatives | Upper, percent | Pass1% /0.1% /0.01% |
|---:|---:|---:|---:|---:|---|
| 33554432 | 24.0 | 100663296 | 1490 / 16777216 | 0.00934361% | True / True / True |
| 33554432 | 32.0 | 134217728 | 224 / 16777216 | 0.00152181% | True / True / True |
| 33554432 | 16.0 | 67108864 | 21336 / 16777216 | 0.12888926% | True / False / False |
| 65536 | 16.0 | 131072 | 21250 / 16777216 | 0.12837322% | True / False / False |
| 65536 | 24.0 | 196608 | 1454 / 16777216 | 0.00912355% | True / True / True |
| 65536 | 32.0 | 262144 | 211 / 16777216 | 0.00143919% | True / True / True |

Every view below includes all smaller actual allocations under the cap. The existing optional Range API and K12 experimental mapping are separate from production and from external libraries. The best retained-project column compares the faster eligible production or optional-Range configuration. No old throughput is imported.

| Keys | Batch | Cap bpk | FPR ceiling | Contract | Best K12 | Best external | K12/ext outcome (ext/K12) | Best retained project | K12/project outcome (project/K12) |
|---:|---:|---:|---:|---|---|---|---|---|---|
| 65536 | 31 | 16 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.3739 ns | FastFilterFixed16@16 bpk, 1.2615 ns | loss (0.9182×) | FastPatternBF@16 bpk, 0.99705 ns | loss (0.72573×) |
| 65536 | 31 | 16 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 2.1437 ns | FastFilterFixed16SingleV1@14 bpk, 1.7164 ns | loss (0.8007×) | ByteSplitBloomFilter@16 bpk, 1.5775 ns | loss (0.73587×) |
| 65536 | 31 | 16 | 0.1% | lookup_ns | none | FastFilterFixed64@16 bpk, 2.269 ns | candidate_ineligible | FourSectorBloomFilter@16 bpk, 1.3001 ns | candidate_ineligible |
| 65536 | 31 | 16 | 0.1% | hash_lookup_ns | none | FastFilterFixed64@16 bpk, 2.874 ns | candidate_ineligible | FourSectorBloomFilter@16 bpk, 2.0751 ns | candidate_ineligible |
| 65536 | 31 | 16 | 0.01% | lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 65536 | 31 | 16 | 0.01% | hash_lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 65536 | 31 | 24 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.3739 ns | FastFilterFixed16@16 bpk, 1.2615 ns | loss (0.9182×) | FastPatternBF@16 bpk, 0.99705 ns | loss (0.72573×) |
| 65536 | 31 | 24 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 2.1437 ns | FastFilterFixed16SingleV1@14 bpk, 1.7164 ns | loss (0.8007×) | ByteSplitBloomFilter@16 bpk, 1.5775 ns | loss (0.73587×) |
| 65536 | 31 | 24 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.3984 ns | Boost192Multi32K8@24 bpk, 1.5134 ns | win (1.0823×) | FourSectorBloomFilter@16 bpk, 1.3001 ns | loss (0.92972×) |
| 65536 | 31 | 24 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 2.1836 ns | FastFilterFixed32@20 bpk, 1.9619 ns | loss (0.89847×) | FourSectorBloomFilter@16 bpk, 2.0751 ns | loss (0.95027×) |
| 65536 | 31 | 24 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.3984 ns | FastFilterFixed64@24 bpk, 2.2828 ns | win (1.6324×) | Split64RangeNative@24 bpk, 1.6678 ns | win (1.1927×) |
| 65536 | 31 | 24 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 2.1836 ns | FastFilterFixed64@24 bpk, 2.8831 ns | win (1.3203×) | Split64RangeNative@24 bpk, 2.2456 ns | win (1.0284×) |
| 65536 | 31 | 32 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.3739 ns | FastFilterFixed16@16 bpk, 1.2615 ns | loss (0.9182×) | FastPatternBF@16 bpk, 0.99705 ns | loss (0.72573×) |
| 65536 | 31 | 32 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 2.1437 ns | FastFilterFixed16SingleV1@14 bpk, 1.7164 ns | loss (0.8007×) | ByteSplitBloomFilter@16 bpk, 1.5775 ns | loss (0.73587×) |
| 65536 | 31 | 32 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.3984 ns | FastFilterFixed16@28 bpk, 1.3065 ns | loss (0.9343×) | FastPatternBF@32 bpk, 1.0583 ns | loss (0.75678×) |
| 65536 | 31 | 32 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 2.1836 ns | FastFilterFixed16@28 bpk, 1.7373 ns | loss (0.79561×) | ByteSplitBloomFilter@32 bpk, 1.6347 ns | loss (0.74861×) |
| 65536 | 31 | 32 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.3984 ns | FastFilterSimdBlockSingleV1@32 bpk, 1.4249 ns | win (1.0189×) | FourSectorBloomFilter@32 bpk, 1.3776 ns | loss (0.98514×) |
| 65536 | 31 | 32 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 2.1836 ns | FastFilterFixed32@28 bpk, 1.9724 ns | loss (0.90328×) | FourSectorBloomFilter@32 bpk, 2.1762 ns | loss (0.99659×) |
| 65536 | 4096 | 16 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.1691 ns | FastFilterFixed16SingleV1@16 bpk, 1.1278 ns | loss (0.9647×) | FastPatternBF@16 bpk, 0.68113 ns | loss (0.58261×) |
| 65536 | 4096 | 16 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 1.7649 ns | FastFilterFixed16SingleV1@14 bpk, 1.6152 ns | loss (0.91518×) | FastPatternBF@16 bpk, 1.1807 ns | loss (0.66899×) |
| 65536 | 4096 | 16 | 0.1% | lookup_ns | none | FastFilterFixed64@16 bpk, 2.161 ns | candidate_ineligible | FourSectorBloomFilter@16 bpk, 1.0689 ns | candidate_ineligible |
| 65536 | 4096 | 16 | 0.1% | hash_lookup_ns | none | FastFilterFixed64@16 bpk, 2.7076 ns | candidate_ineligible | FourSectorBloomFilter@16 bpk, 1.5556 ns | candidate_ineligible |
| 65536 | 4096 | 16 | 0.01% | lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 65536 | 4096 | 16 | 0.01% | hash_lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 65536 | 4096 | 24 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.1691 ns | FastFilterFixed16SingleV1@16 bpk, 1.1278 ns | loss (0.9647×) | FastPatternBF@16 bpk, 0.68113 ns | loss (0.58261×) |
| 65536 | 4096 | 24 | 1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 1.7341 ns | FastFilterFixed16SingleV1@14 bpk, 1.6152 ns | loss (0.93146×) | FastPatternBF@16 bpk, 1.1807 ns | loss (0.68089×) |
| 65536 | 4096 | 24 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.1974 ns | FastFilterFixed32Bulk@24 bpk, 1.3487 ns | win (1.1264×) | FourSectorBloomFilter@16 bpk, 1.0689 ns | loss (0.89272×) |
| 65536 | 4096 | 24 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 1.7341 ns | FastFilterFixed32Bulk@24 bpk, 1.8817 ns | win (1.0851×) | FourSectorBloomFilter@16 bpk, 1.5556 ns | loss (0.89708×) |
| 65536 | 4096 | 24 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.1974 ns | FastFilterFixed64@24 bpk, 2.1828 ns | win (1.823×) | Split64RangeNative@24 bpk, 1.6968 ns | win (1.4171×) |
| 65536 | 4096 | 24 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 1.7341 ns | FastFilterFixed64@24 bpk, 2.7294 ns | win (1.574×) | Split64RangeNative@24 bpk, 2.2765 ns | win (1.3128×) |
| 65536 | 4096 | 32 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 1.1691 ns | FastFilterFixed16SingleV1@16 bpk, 1.1278 ns | loss (0.9647×) | FastPatternBF@16 bpk, 0.68113 ns | loss (0.58261×) |
| 65536 | 4096 | 32 | 1% | hash_lookup_ns | FourSectorRange12Experiment@32 bpk, 1.7141 ns | FastFilterFixed16SingleV1@14 bpk, 1.6152 ns | loss (0.94229×) | FastPatternBF@16 bpk, 1.1807 ns | loss (0.68881×) |
| 65536 | 4096 | 32 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.1974 ns | FastFilterFixed16@32 bpk, 1.1493 ns | loss (0.95986×) | FastPatternBF@32 bpk, 0.75439 ns | loss (0.63004×) |
| 65536 | 4096 | 32 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@32 bpk, 1.7141 ns | FastFilterFixed16@32 bpk, 1.6378 ns | loss (0.95549×) | FastPatternBF@32 bpk, 1.2745 ns | loss (0.7435×) |
| 65536 | 4096 | 32 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 1.1974 ns | FastFilterSimdBlockSingleV1@32 bpk, 1.2728 ns | win (1.063×) | FourSectorBloomFilter@32 bpk, 1.1362 ns | loss (0.94892×) |
| 65536 | 4096 | 32 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@32 bpk, 1.7141 ns | FastFilterSimdBlock@32 bpk, 1.8061 ns | win (1.0536×) | FourSectorBloomFilter@32 bpk, 1.6193 ns | loss (0.94469×) |
| 33554432 | 31 | 16 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 5.7717 ns | Boost192Multi32K8@12 bpk, 5.9094 ns | win (1.0239×) | FastPatternBF@16 bpk, 5.4219 ns | loss (0.9394×) |
| 33554432 | 31 | 16 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 6.5556 ns | Boost192Multi32K8@12 bpk, 5.7718 ns | loss (0.88043×) | FourSectorBloomFilter@16 bpk, 5.8689 ns | loss (0.89525×) |
| 33554432 | 31 | 16 | 0.1% | lookup_ns | none | RocksDBFastLocalBloom64K8Batch32@16 bpk, 7.0735 ns | candidate_ineligible | Split64BloomFilter@16 bpk, 6.6544 ns | candidate_ineligible |
| 33554432 | 31 | 16 | 0.1% | hash_lookup_ns | none | RocksDBFastLocalBloom64K8Batch32@16 bpk, 7.7626 ns | candidate_ineligible | Split64BloomFilter@16 bpk, 6.5153 ns | candidate_ineligible |
| 33554432 | 31 | 16 | 0.01% | lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 33554432 | 31 | 16 | 0.01% | hash_lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 33554432 | 31 | 24 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 5.7717 ns | Boost192Multi32K8@12 bpk, 5.9094 ns | win (1.0239×) | FastPatternBF@16 bpk, 5.4219 ns | loss (0.9394×) |
| 33554432 | 31 | 24 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 6.5556 ns | Boost192Multi32K8@12 bpk, 5.7718 ns | loss (0.88043×) | FourSectorBloomFilter@16 bpk, 5.8689 ns | loss (0.89525×) |
| 33554432 | 31 | 24 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 6.7211 ns | RocksDBFastLocalBloom64K8Batch32@16 bpk, 7.0735 ns | win (1.0524×) | Split64BloomFilter@16 bpk, 6.6544 ns | loss (0.99008×) |
| 33554432 | 31 | 24 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 7.4258 ns | Boost192Multi32K8@20 bpk, 7.1542 ns | loss (0.96342×) | Split64BloomFilter@16 bpk, 6.5153 ns | loss (0.87739×) |
| 33554432 | 31 | 24 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 6.7211 ns | RocksDBFastLocalBloom64K8Batch32@24 bpk, 8.0728 ns | win (1.2011×) | Split64RangeNative@24 bpk, 8.3077 ns | win (1.2361×) |
| 33554432 | 31 | 24 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 7.4258 ns | RocksDBFastLocalBloom64K8Batch32@24 bpk, 8.9883 ns | win (1.2104×) | Split64RangeNative@24 bpk, 8.2756 ns | win (1.1144×) |
| 33554432 | 31 | 32 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 5.7717 ns | Boost192Multi32K8@12 bpk, 5.9094 ns | win (1.0239×) | FastPatternBF@16 bpk, 5.4219 ns | loss (0.9394×) |
| 33554432 | 31 | 32 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 6.5556 ns | Boost192Multi32K8@12 bpk, 5.7718 ns | loss (0.88043×) | FourSectorBloomFilter@16 bpk, 5.8689 ns | loss (0.89525×) |
| 33554432 | 31 | 32 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 6.7211 ns | RocksDBFastLocalBloom64K8Batch32@16 bpk, 7.0735 ns | win (1.0524×) | Split64BloomFilter@16 bpk, 6.6544 ns | loss (0.99008×) |
| 33554432 | 31 | 32 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 7.4258 ns | Boost192Multi32K8@20 bpk, 7.1542 ns | loss (0.96342×) | Split64BloomFilter@16 bpk, 6.5153 ns | loss (0.87739×) |
| 33554432 | 31 | 32 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 6.7211 ns | RocksDBFastLocalBloom64K8Batch32@24 bpk, 8.0728 ns | win (1.2011×) | FastPatternBF@32 bpk, 6.9688 ns | win (1.0369×) |
| 33554432 | 31 | 32 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 7.4258 ns | Boost192Multi32K8@28 bpk, 8.4867 ns | win (1.1429×) | FourSectorBloomFilter@32 bpk, 7.668 ns | win (1.0326×) |
| 33554432 | 4096 | 16 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 4.7014 ns | Boost192Multi32K8@12 bpk, 4.7512 ns | win (1.0106×) | FastPatternBF@16 bpk, 4.1632 ns | loss (0.88553×) |
| 33554432 | 4096 | 16 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 4.1777 ns | Boost192Multi32K8@12 bpk, 4.1721 ns | loss (0.99865×) | FastPatternBF@16 bpk, 4.099 ns | loss (0.98116×) |
| 33554432 | 4096 | 16 | 0.1% | lookup_ns | none | Boost192Multi64K8@16 bpk, 5.617 ns | candidate_ineligible | Split64BloomFilter@16 bpk, 4.8901 ns | candidate_ineligible |
| 33554432 | 4096 | 16 | 0.1% | hash_lookup_ns | none | Boost192Multi64K8@16 bpk, 4.6622 ns | candidate_ineligible | Split64BloomFilter@16 bpk, 4.2864 ns | candidate_ineligible |
| 33554432 | 4096 | 16 | 0.01% | lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 33554432 | 4096 | 16 | 0.01% | hash_lookup_ns | none | none | candidate_ineligible | none | candidate_ineligible |
| 33554432 | 4096 | 24 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 4.7014 ns | Boost192Multi32K8@12 bpk, 4.7512 ns | win (1.0106×) | FastPatternBF@16 bpk, 4.1632 ns | loss (0.88553×) |
| 33554432 | 4096 | 24 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 4.1777 ns | Boost192Multi32K8@12 bpk, 4.1721 ns | loss (0.99865×) | FastPatternBF@16 bpk, 4.099 ns | loss (0.98116×) |
| 33554432 | 4096 | 24 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 5.6655 ns | Boost192Multi32K8@20 bpk, 5.4397 ns | loss (0.96015×) | Split64BloomFilter@16 bpk, 4.8901 ns | loss (0.86314×) |
| 33554432 | 4096 | 24 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 5.2838 ns | Boost192Multi64K8@16 bpk, 4.6622 ns | loss (0.88237×) | Split64BloomFilter@16 bpk, 4.2864 ns | loss (0.81124×) |
| 33554432 | 4096 | 24 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 5.6655 ns | Boost192Multi64K8@24 bpk, 6.5353 ns | win (1.1535×) | Split64RangeNative@24 bpk, 6.0836 ns | win (1.0738×) |
| 33554432 | 4096 | 24 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 5.2838 ns | Boost192Multi64K8@24 bpk, 5.8498 ns | win (1.1071×) | Split64RangeNative@24 bpk, 5.4671 ns | win (1.0347×) |
| 33554432 | 4096 | 32 | 1% | lookup_ns | FourSectorRange12Experiment@16 bpk, 4.7014 ns | Boost192Multi32K8@12 bpk, 4.7512 ns | win (1.0106×) | FastPatternBF@16 bpk, 4.1632 ns | loss (0.88553×) |
| 33554432 | 4096 | 32 | 1% | hash_lookup_ns | FourSectorRange12Experiment@16 bpk, 4.1777 ns | Boost192Multi32K8@12 bpk, 4.1721 ns | loss (0.99865×) | FastPatternBF@16 bpk, 4.099 ns | loss (0.98116×) |
| 33554432 | 4096 | 32 | 0.1% | lookup_ns | FourSectorRange12Experiment@24 bpk, 5.6655 ns | Boost192Multi32K8@20 bpk, 5.4397 ns | loss (0.96015×) | Split64BloomFilter@16 bpk, 4.8901 ns | loss (0.86314×) |
| 33554432 | 4096 | 32 | 0.1% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 5.2838 ns | Boost192Multi64K8@16 bpk, 4.6622 ns | loss (0.88237×) | Split64BloomFilter@16 bpk, 4.2864 ns | loss (0.81124×) |
| 33554432 | 4096 | 32 | 0.01% | lookup_ns | FourSectorRange12Experiment@24 bpk, 5.6655 ns | Boost192Multi32K8@28 bpk, 6.1838 ns | win (1.0915×) | FastPatternBF@32 bpk, 5.9832 ns | win (1.0561×) |
| 33554432 | 4096 | 32 | 0.01% | hash_lookup_ns | FourSectorRange12Experiment@24 bpk, 5.2838 ns | Boost192Multi64K8@24 bpk, 5.8498 ns | win (1.1071×) | Split64RangeNative@24 bpk, 5.4671 ns | win (1.0347×) |

The full tables retain 5,328 individual allocation alternatives and 216 K12 alternatives, including byte/quality failures, every loss, exact tie and no-comparable case. `leaders.json` retains four ownership-class leaders and every exact tie. PageBloom is a public raw-byte API; its prehashed timing is invalid and excluded only from that query contract. Common-hash-plus-bulk measures the common hash for prehash APIs and the public raw-key API for Page, with that upstream distinction preserved.

The actual backing-byte cap includes reported allocation padding, while explicit filter-build and harness scratch are retained separately. Construction metrics are NaN: one full bitmap build precedes the query timers, so this screen makes no build-speed claim. Pure and hash+query phases use six balanced repetitions; each full trial vector/min/max remains in raw rows. The one seed-derived filter order per case and allocation/address placement are not independent causal controls.

All 284 retained control rows reproduce the 142 committed prior geometries at both batches, including checksums and mixed/calibration counts. The six K12 quality streams are new; their earlier accuracy pilot used a different input interval and is not an exact-count reproduction. Relevant older borderline quality outcomes remain context only and do not replace the current-seed ranking gates.

Source `a433e307c73b46e0c1e6f011cf6b6e0d8b2c2ef3`, complete raw `fd50847f2a4f414be8962f6e6a19039d9966ee6c`. The actual caller binary and compiler dependency closure passed native, AVX2 and ASan preflight before this screen. Measurement uses CPU3/socket1 affinity with a whole-matrix lock and no explicit NUMA memory binding. No source, allocation, filter or quality rule changed after the screen began.
