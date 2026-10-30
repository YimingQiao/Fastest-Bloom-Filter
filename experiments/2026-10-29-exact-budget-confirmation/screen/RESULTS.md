# Fixed-capacity confirmation: mixed results retained

All 39 workloads / 162 rows completed, with unchanged committed sources, dependency hashes, and all 15 parent binaries. The fixed 54-configuration subset ran on CPU3/socket1; training ran on CPU2. No cross-run latency ratio is used. This is confirmation of training-selected comparisons, not a new exhaustive ranking.

- At 33,554,432 keys and a 32-bpk ceiling with 0.01% maximum FPR, the fixed production FastPattern32 hash+query comparison loses on two of three seeds. Candidate/external latency ratios are **0.9977, 1.0245, 1.0371**.
- RangeSplit64 at exactly 24 bpk wins that same fixed strict comparison on all three seeds: **0.9335, 0.9441, 0.9567** (4.33–6.65% lower latency). Its worst Wilson upper bound is **0.000099362116612808834**, only 0.000000637883387191166 below the 0.0001 ceiling. This narrow margin is not a universal quality guarantee.
- At the large loose 1% target, RangeSplit64 at 12 bpk wins hash+query on all seeds (**0.9263, 0.9599, 0.9465**), but loses pure prehashed lookup on all seeds (**1.0131, 1.0253, 1.0287**). The production FastPattern16 hash+query ratios are **0.9704, 1.0497, 1.0014**, including two losses.
- FourSector16 at 65,536 keys fails the fixed 0.1% quality gate on the first seed. Its fast timings remain descriptive; no alternate native filter replaces it. No other fixed training leader/target fails its all-seed quality gate.

Ratios throughout are **candidate latency / external latency**, so values below one favor the candidate. Each ratio uses the medians of six balanced query trials from the same confirmation seed. Range candidates remain project experiments.

## Strict large comparison: exact payload and calibration

Each calibration uses 16,777,216 absent keys. BoostMulti64K8 uses 100,663,295 charged bytes; RangeSplit64 uses 100,663,296 bytes; production FastPattern uses 134,217,728 bytes. All fit the 32-bpk cap.

| Seed | Configuration | False positives | Wilson upper | Hash+query ns/key |
|---|---|---:|---:|---:|
| 7562001474399208876 | Boost192Multi64K8 @ 23.9999998 bpk | 1570 | 9.832385555499458e-05 | 5.959133506 |
| 3054562362472030614 | Boost192Multi64K8 @ 23.9999998 bpk | 1497 | 9.3863871027945008e-05 | 5.813573837 |
| 6571923779321589834 | Boost192Multi64K8 @ 23.9999998 bpk | 1490 | 9.3436063224060215e-05 | 5.757128954 |
| 7562001474399208876 | FastPatternBF @ 32 bpk | 1504 | 9.4291654144458106e-05 | 5.945297122 |
| 3054562362472030614 | FastPatternBF @ 32 bpk | 1553 | 9.7285458917369575e-05 | 5.956159949 |
| 6571923779321589834 | FastPatternBF @ 32 bpk | 1518 | 9.5147147001491494e-05 | 5.971000075 |
| 7562001474399208876 | Split64RangeExperiment @ 24 bpk | 1469 | 9.2152489937373923e-05 | 5.562671065 |
| 3054562362472030614 | Split64RangeExperiment @ 24 bpk | 1537 | 9.630801858638925e-05 | 5.488861799 |
| 6571923779321589834 | Split64RangeExperiment @ 24 bpk | 1587 | 9.9362116612808834e-05 | 5.507926702 |

## Retained quality failure

| Seed | FourSector16 false positives / probes | Wilson upper | Meets 0.001? |
|---|---:|---:|---|
| 7562001474399208876 | 16542 / 16777216 | 0.001001112583453033 | **no** |
| 3054562362472030614 | 16422 / 16777216 | 0.0009939055120000114 | yes |
| 6571923779321589834 | 16163 / 16777216 | 0.0009783495644392784 | yes |

The single failing configuration/target appears in multiple main/frontier slots. Those repeated comparisons are not additional independent failures. API duplicates and seeds are never pooled: there are 144 distinct mapping/seed calibration records, each with its own 2^24 probes.

## Every main fixed comparison

Values in each cell follow the three fixed seed order listed above. `quality failure` means a timing advantage cannot establish a qualifying win. Null training slots remain null.

| Keys | Mode | Cap bpk | FPR ceiling | Fixed external | Fixed production: ratios; status | Fixed experiment: ratios; status |
|---:|---|---:|---:|---|---|---|
| 65536 | prehashed | 16 | 1% | FastFilterFixed16SingleV1 @ 14 bpk | FastPatternBF @ 16 bpk: 0.5950, 0.6169, 0.5847; qualified | ByteSplitRangeExperiment @ 14 bpk: 0.9573, 0.9832, 0.9599; qualified |
| 65536 | prehashed | 16 | 0.1% | FastFilterFixed64 @ 16 bpk | FourSectorBloomFilter @ 16 bpk: 0.4985, 0.5000, 0.5003; **quality failure** | Split64RangeExperiment @ 16 bpk: 0.7831, 0.7889, 0.7826; qualified |
| 65536 | prehashed | 16 | 0.01% | — | —: —; no fixed pair | —: —; no fixed pair |
| 65536 | prehashed | 32 | 1% | FastFilterFixed16SingleV1 @ 14 bpk | FastPatternBF @ 16 bpk: 0.5950, 0.6169, 0.5847; qualified | ByteSplitRangeExperiment @ 14 bpk: 0.9573, 0.9832, 0.9599; qualified |
| 65536 | prehashed | 32 | 0.1% | FastFilterFixed16 @ 32 bpk | FastPatternBF @ 32 bpk: 0.6415, 0.6509, 0.6469; qualified | ByteSplitRangeExperiment @ 32 bpk: 0.9635, 0.9787, 1.0171; qualified |
| 65536 | prehashed | 32 | 0.01% | FastFilterSimdBlockSingleV1 @ 32 bpk | FourSectorBloomFilter @ 32 bpk: 0.8994, 0.9034, 0.9077; qualified | Split64RangeExperiment @ 28 bpk: 1.3506, 1.3313, 1.3558; qualified |
| 65536 | hash+query | 16 | 1% | FastFilterFixed16SingleV1 @ 14 bpk | FastPatternBF @ 16 bpk: 0.7350, 0.7270, 0.7128; qualified | ByteSplitRangeExperiment @ 14 bpk: 0.9816, 0.9693, 0.9715; qualified |
| 65536 | hash+query | 16 | 0.1% | FastFilterFixed64 @ 16 bpk | FourSectorBloomFilter @ 16 bpk: 0.5814, 0.5836, 0.5847; **quality failure** | Split64RangeExperiment @ 16 bpk: 0.8328, 0.8344, 0.8295; qualified |
| 65536 | hash+query | 16 | 0.01% | — | —: —; no fixed pair | —: —; no fixed pair |
| 65536 | hash+query | 32 | 1% | FastFilterFixed16SingleV1 @ 14 bpk | FastPatternBF @ 16 bpk: 0.7350, 0.7270, 0.7128; qualified | ByteSplitRangeExperiment @ 20 bpk: 0.9835, 1.0034, 0.9820; qualified |
| 65536 | hash+query | 32 | 0.1% | FastFilterFixed16 @ 32 bpk | FastPatternBF @ 32 bpk: 0.7470, 0.7491, 0.7525; qualified | ByteSplitRangeExperiment @ 28 bpk: 0.9596, 0.9880, 0.9688; qualified |
| 65536 | hash+query | 32 | 0.01% | FastFilterSimdBlock @ 32 bpk | FourSectorBloomFilter @ 32 bpk: 0.9180, 0.9257, 0.9224; qualified | Split64RangeExperiment @ 32 bpk: 1.2600, 1.2822, 1.2660; qualified |
| 33554432 | prehashed | 16 | 1% | Boost192Multi32K8 @ 11.9999998 bpk | FastPatternBF @ 16 bpk: 0.9102, 0.9203, 0.8948; qualified | Split64RangeExperiment @ 12 bpk: 1.0131, 1.0253, 1.0287; qualified |
| 33554432 | prehashed | 16 | 0.1% | Boost192Multi64K8 @ 15.9999998 bpk | Split64BloomFilter @ 16 bpk: 0.8543, 0.8569, 0.8705; qualified | Split64RangeExperiment @ 16 bpk: 0.9129, 0.9190, 0.9282; qualified |
| 33554432 | prehashed | 16 | 0.01% | — | —: —; no fixed pair | —: —; no fixed pair |
| 33554432 | prehashed | 32 | 1% | Boost192Multi32K8 @ 11.9999998 bpk | FastPatternBF @ 16 bpk: 0.9102, 0.9203, 0.8948; qualified | Split64RangeExperiment @ 12 bpk: 1.0131, 1.0253, 1.0287; qualified |
| 33554432 | prehashed | 32 | 0.1% | Boost192Multi32K8 @ 19.9999998 bpk | Split64BloomFilter @ 16 bpk: 0.9057, 0.9187, 0.9093; qualified | Split64RangeExperiment @ 16 bpk: 0.9678, 0.9852, 0.9695; qualified |
| 33554432 | prehashed | 32 | 0.01% | Boost192Multi32K8 @ 27.9999998 bpk | FastPatternBF @ 32 bpk: 0.9546, 0.9468, 0.9636; qualified | Split64RangeExperiment @ 24 bpk: 0.9942, 0.9721, 0.9866; qualified |
| 33554432 | hash+query | 16 | 1% | Boost192Multi32K8 @ 11.9999998 bpk | FastPatternBF @ 16 bpk: 0.9704, 1.0497, 1.0014; qualified | Split64RangeExperiment @ 12 bpk: 0.9263, 0.9599, 0.9465; qualified |
| 33554432 | hash+query | 16 | 0.1% | Boost192Multi64K8 @ 15.9999998 bpk | Split64BloomFilter @ 16 bpk: 0.8132, 0.8706, 0.9350; qualified | Split64RangeExperiment @ 16 bpk: 0.8230, 0.8866, 0.9468; qualified |
| 33554432 | hash+query | 16 | 0.01% | — | —: —; no fixed pair | —: —; no fixed pair |
| 33554432 | hash+query | 32 | 1% | Boost192Multi32K8 @ 11.9999998 bpk | FastPatternBF @ 16 bpk: 0.9704, 1.0497, 1.0014; qualified | Split64RangeExperiment @ 12 bpk: 0.9263, 0.9599, 0.9465; qualified |
| 33554432 | hash+query | 32 | 0.1% | Boost192Multi64K8 @ 15.9999998 bpk | Split64BloomFilter @ 16 bpk: 0.8132, 0.8706, 0.9350; qualified | Split64RangeExperiment @ 16 bpk: 0.8230, 0.8866, 0.9468; qualified |
| 33554432 | hash+query | 32 | 0.01% | Boost192Multi64K8 @ 23.9999998 bpk | FastPatternBF @ 32 bpk: 0.9977, 1.0245, 1.0371; qualified | Split64RangeExperiment @ 24 bpk: 0.9335, 0.9441, 0.9567; qualified |

## Reproduction and scope

- Source/plan commit: `25272f61682518513e4b3d59ae390ea45e5bde5e`; unchanged parent binary source: `d70077b28fb3cd5821ae471f185e98393423ec64`.
- Recorded UTC interval: `2026-10-28T22:25:16Z` to `2026-10-28T22:27:07Z`.
- 2^22 mixed queries, 50% intended hits, batch4096, six balanced phase repetitions; one validated complete build, zero ranked build repetitions.
- Worst pointwise two-sided95 Wilson upper bound across all three seeds determines quality. Bounds are not simultaneous guarantees over the selected grid.
- [summary.json](summary.json) retains all fixed main/frontier slots, trial vectors, nulls, seed losses, and calibration identities. [fixed-comparisons.csv](fixed-comparisons.csv) expands every fixed comparison per seed; overlapping main/frontier/project slots are labeled and must not be counted as independent trials.
- [configuration-seeds.csv](configuration-seeds.csv) retains all 162 configuration/seed records, including native controls; [quality-failures.json](quality-failures.json) deduplicates failed fixed leader/target gates.
- Frozen `../summarize.py` validated exact commands, merged/raw output equality, complete geometry/seed sets, committed source blobs and live dependencies/binaries. No seed, configuration, or failed leader was replaced.
- No global fastest-filter, untested workload, cross-language, or construction-performance claim follows from this subset.
