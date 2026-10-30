# Completed paired raw-u32 public API observations

The fixed 728-row matrix completed without a rejected row. Native filters have lower observed median latency in all 72 eligible same-context comparisons against the original VLDB public APIs. The modern context exposes remaining losses: native leaders win 55 and lose 29 of 84 comparable views. This is seed42 training on this host, with two fixed launch rounds; repeated caps, API aliases and rounds are correlated observations, not independent confirmations. No universal fastest claim follows.

The frozen analysis rules at `75dbe5c350035767bab775168a3298b716818934` passed all ten synthetic tests without correction. The loader verified the complete raw archive at `23b1ffe7216a693e31a2c3086299e94837fe42ad`, measured producer `6baeaeb88c89b9a4eed71f0a0aa1263c613289bd`, every raw stdout/stderr, exact command ledger, phase/trial/guard fields, source inventories and worker proof. Root independently rechecked all 1458 archive entries, 728 raw rows and 2184 six-trial summaries.

| Context | Query contract | Native wins | Native losses | No comparison |
|---|---|---:|---:|---:|
| Original public APIs | Compiler-visible singleton | 24 | 0 | 24 |
| Original public APIs | Dense batch1 | 24 | 0 | 24 |
| Original public APIs | Dense batch4096 | 24 | 0 | 24 |
| Modern public APIs | Compiler-visible singleton | 19 | 9 | 20 |
| Modern public APIs | Dense batch1 | 13 | 15 | 20 |
| Modern public APIs | Dense batch4096 | 23 | 5 | 20 |

No-comparison views are excluded from win/loss denominators. In the original context, 60 views have neither eligible side and 12 have only an eligible native. In the modern context, 36 have neither eligible side and 24 have only an eligible external. The latter include cap12 at1% and cap24 at0.01%: production natives have only smaller power-of-two allocations available under those caps and none qualifies there. A missing qualifier is not a timing win.

The important large strict loss remains under the **cap32 nested allocation** comparison: Boost192Multi64K8 uses 100663295 bytes (just below24 actual bits/key), whereas the native leader uses134217728 bytes (32 bits/key). In round0 the batch4096 observations are FastPattern6.127324ns versus Boost5.797687ns; round1 is Split646.163982ns versus Boost5.794602ns. Boost/native latency is0.946202 and0.940074. Under cap24 there is no qualifying production native at0.01%; that separate absence is retained and is not counted as a timed loss.

The large loose batch4096 result is not stable across launch rounds: at cap16/1%, round0 FastPattern4.361494ns beats Boost4.529950ns, while round1 FourSector4.330752ns loses to Boost4.210528ns. Both use the fastest eligible alias and fitting allocation in their own round. Singleton strict-large and batch1 large0.1% also change observed winner between rounds. No rounds were averaged to conceal these changes.

Each row below is an independently retained launch-round median, in ns/query. Names carry their measured actual bits/key; near-integer Boost capacities are rounded only in this display. Complete exact bytes, all trials, all qualification failures and all alternatives remain in the linked CSVs.

| n | Cap | FPR ceiling | Mode | Round | Native leader@actual bpk | Native ns | External leader@actual bpk | External ns | External/native latency |
|---:|---:|---:|---|---:|---|---:|---|---:|---:|
| 65536 | 16 | 1% | raw_single | 0 | ByteSplitBloomFilter@16 | 1.825825 | FastFilterFixed16SingleV1@16 | 1.966842 | 1.077235 |
| 65536 | 16 | 1% | raw_single | 1 | ByteSplitBloomFilter@16 | 1.825215 | FastFilterFixed16SingleV1@16 | 1.968109 | 1.078289 |
| 65536 | 16 | 0.1% | raw_single | 0 | Split64BloomFilter@16 | 2.170039 | FastFilterFixed64@16 | 3.212162 | 1.480232 |
| 65536 | 16 | 0.1% | raw_single | 1 | Split64BloomFilter@16 | 2.171966 | FastFilterFixed64@16 | 3.218549 | 1.481859 |
| 65536 | 32 | 0.01% | raw_single | 0 | Split64BloomFilter@32 | 2.172904 | FastFilterSimdBlockSingleV1@32 | 1.979832 | 0.911146 |
| 65536 | 32 | 0.01% | raw_single | 1 | Split64BloomFilter@32 | 2.175286 | FastFilterSimdBlockSingleV1@32 | 1.978129 | 0.909365 |
| 33554432 | 16 | 1% | raw_single | 0 | ByteSplitBloomFilter@16 | 6.744988 | FastFilterFixed32@12 | 6.382418 | 0.946246 |
| 33554432 | 16 | 1% | raw_single | 1 | ByteSplitBloomFilter@16 | 6.567603 | FastFilterFixed32Bulk@12 | 5.717088 | 0.870498 |
| 33554432 | 16 | 0.1% | raw_single | 0 | Split64BloomFilter@16 | 7.645341 | FastFilterFixed64@16 | 7.934356 | 1.037803 |
| 33554432 | 16 | 0.1% | raw_single | 1 | Split64BloomFilter@16 | 7.249892 | RocksDBFastLocalBloom64K8@16 | 8.427168 | 1.162385 |
| 33554432 | 32 | 0.01% | raw_single | 0 | Split64BloomFilter@32 | 10.541962 | FastFilterSimdBlock@32 | 10.525348 | 0.998424 |
| 33554432 | 32 | 0.01% | raw_single | 1 | Split64BloomFilter@32 | 10.324233 | FastFilterSimdBlock@32 | 10.775126 | 1.043673 |
| 33554432 | 16 | 0.1% | raw_batch1 | 0 | Split64BloomFilter@16 | 13.603165 | FastFilterFixed64@16 | 12.067258 | 0.887092 |
| 33554432 | 16 | 0.1% | raw_batch1 | 1 | Split64BloomFilter@16 | 12.838795 | FastFilterFixed64@16 | 13.129714 | 1.022659 |
| 33554432 | 16 | 1% | raw_batch4096 | 0 | FastPatternBF@16 | 4.361494 | Boost192Multi64K8@12 | 4.529950 | 1.038623 |
| 33554432 | 16 | 1% | raw_batch4096 | 1 | FourSectorBloomFilter@16 | 4.330752 | Boost192Multi64K8@12 | 4.210528 | 0.972240 |
| 33554432 | 16 | 0.1% | raw_batch4096 | 0 | FourSectorBloomFilter@16 | 4.514794 | Boost192Multi64K8@16 | 4.712526 | 1.043796 |
| 33554432 | 16 | 0.1% | raw_batch4096 | 1 | FourSectorBloomFilter@16 | 4.330752 | Boost192Multi64K8@16 | 4.635606 | 1.070393 |
| 33554432 | 32 | 0.01% | raw_batch4096 | 0 | FastPatternBF@32 | 6.127324 | Boost192Multi64K8@24 | 5.797687 | 0.946202 |
| 33554432 | 32 | 0.01% | raw_batch4096 | 1 | Split64BloomFilter@32 | 6.163982 | Boost192Multi64K8@24 | 5.794602 | 0.940074 |

Original public PImpl, dynamic and static APIs all remain measured. The fastest eligible original singleton and batch1 shapes are static in all24 comparable views of each mode; batch4096 leaders are PImpl in12, static in10 and dynamic in2. The native/original comparisons therefore use the strongest observed eligible surface, not PImpl alone. Original/native latency ratios range1.637927–2.845929 for singleton,2.240361–4.489069 for batch1 and1.410163–2.104643 for batch4096. These ranges cover correlated nested views, not independent speedup samples.

All72 comparable original-versus-modern external cross-context observations favor the modern external median, but these remain separate-executable observations. Both native control sets and both external times are retained. Native modern/legacy context ratios vary0.972089–1.070602 for singleton,0.960143–1.087422 for batch1 and0.958623–1.057406 for batch4096. No native ratio or context correction was subtracted, divided out or applied to any result.

Quality uses one2^24 disjoint raw-u32 negative stream per identity and a pointwise two-sidedWilson95 upper endpoint. Of166 deduplicated identities,145 pass1%,89 pass0.1%,44 pass0.01%; the remaining21/77/122 failures stay in the archive. Repeated API surfaces, U values with proven equal mapping, launch rounds and duplicated native contexts are checked for identical outputs/counts, never pooled into a larger denominator.

FourSector16 passes the0.1% gate in this seed, with little margin: n65536 has16428 false positives and upper0.0994265870%; n33554432 has16516 and upper0.0999551068%. Prior u64 or fresh-seed quality evidence is not imported into this raw-u32 stream. ByteSplit32 does not pass0.01% at either n. No8bpk production allocation passes1% here.

The original large MAGIC24bpk results are material quality failures, despite all no-false-negative/output guards passing:

| Original bitmap family, n33554432 | False positives /16777216 | Wilson95 upper | Verified identical API/round rows |
|---|---:|---:|---:|
| sector32,24bpk,MAGIC | 173410 | 1.0384549656% | 18 (3 U values ×3 surfaces ×2 rounds) |
| sector64,24bpk,MAGIC | 229475 | 1.3733465622% | 18 (3 U values ×3 surfaces ×2 rounds) |
| register64,24bpk,MAGIC | 170798 | 1.0228500272% | 6 (U0 ×3 surfaces ×2 rounds) |

These are unchanged original public automatic-addressing configurations with requested/observed geometry verified. Their higher FPR is not silently normalized, repaired, relabeled or attributed to a cause without further evidence. At32bpk the original sector families qualify0.01% at both n; register64 does not. The complete24 original quality identities, including12/16/24/32bpk failures, are present in `report/summary.json`.

This protocol uses uniform unique raw-u32 keys,50% hits, n65536/33554432, q4194304, seed42, caps12/16/24/32, a complete untimed build and six balanced query trials. Original public hashing, common Murmur64 of zero-extended u32 for modern/native, Page raw4-byte hashing, and original compact-to-dense conversion all remain inside the appropriate query clock. Scratch preparation is outside. No build-throughput conclusion follows. The cap is actual bitmap backing bytes; persistent control/setup/scratch accounting is separately reported in the preflight and is not claimed to be zero or included in bitmap cap.

Legacy Boost1.83 and modern Boost1.92 remain in separate executables with all four native controls. GCC12/native optimization matches for new harness TUs; the reused original archive retains its recorded original build flags. Compiler-visible singleton is independent-query throughput with optimizer freedom, not a dependent pointer-chain latency experiment. Dense batch1 is a separate noinline API contract.

Known caller boundaries are retained: Rocks K8 Batch32 singleton is out of line, while its same-layout direct K8 alias is present and eligible. The six Page value-single facades materialize4-byte stack arguments; dense Page uses input-array addresses. The separately committed pointer-direct caller experiment (`e4f0455b4354ef5d06840cc226ede4b3a5ca4e60`) was specified before these results were inspected and has not been compiled or timed. Thus this screen is not a claim that Page value-single is its strongest possible caller contract.

Artifacts: [all288 rankings](report/same-context-rankings.csv), [all26208 alternatives](report/all-alternatives.csv), [144 cross-context observations](report/cross-context-observations.csv), [144 native context controls](report/native-context-controls.csv), [full quality/provenance](report/summary.json), [all29 native modern losses](modern-native-losses.csv), [166 pointwise quality records](quality.csv). The full raw source archive and analysis inventories remain linked by exact commits and hashes.
