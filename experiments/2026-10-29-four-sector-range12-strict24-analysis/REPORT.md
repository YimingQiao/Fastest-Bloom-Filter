# Three-seed K12 strict24 confirmation

K12@24 wins every measured primary comparison against the fastest selected external and retained project:24/24 per-seed size/batch/query-contract views. It also wins12/12 prespecified large-table cap32 secondary views while still using24 bits/key. All13 API geometries pass all three independent quality gates, so these wins do not rely on excluding a rival. All180 named rival pairs are wins; no tie, loss, quality exclusion or missing comparator occurred in this finite confirmation.

The primary niche is two sizes (65,536 and33,554,432 inserted keys), batches31/4096, actual at-most24 bits/key and false-positive ceiling0.01%. Each fixed API/seed uses2^26 independent negatives and six balanced query trials. Three seeds were selected solely for disjoint raw input domains and K12 first/middle/last position among the primary five. Ratios below are rival latency / K12 latency, hence throughput ratios; ranges show all three seeds, not confidence intervals.

## Primary actual24 results

|Keys|Batch|Query contract|K12 ns/query range|Best external / K12|Range / K12|External winners across seeds|
|---:|---:|---|---:|---:|---:|---|
|65,536|31|Prehashed|1.3998–1.4055|1.6252–1.6356×|1.1893–1.2020×|FastFilterFixed64|
|65,536|31|Common hash + query|2.1761–2.2124|1.3085–1.3250×|1.0196–1.0325×|FastFilterFixed64|
|65,536|4096|Prehashed|1.1923–1.1980|1.8222–1.8279×|1.4140–1.4220×|FastFilterFixed64|
|65,536|4096|Common hash + query|1.6864–1.7288|1.5788–1.6346×|1.3077–1.3527×|FastFilterFixed64|
|33,554,432|31|Prehashed|6.7170–6.8009|1.1911–1.2103×|1.2268–1.2418×|RocksDBFastLocalBloom64K8Batch32|
|33,554,432|31|Common hash + query|7.4366–7.4686|1.2118–1.2180×|1.0936–1.1016×|RocksDBFastLocalBloom64K8Batch32|
|33,554,432|4096|Prehashed|5.5885–5.6442|1.1465–1.1681×|1.0717–1.0959×|Boost192Multi64K8|
|33,554,432|4096|Common hash + query|5.2420–5.2500|1.0920–1.1306×|1.0363–1.0499×|Boost192Multi64K8|

The narrowest primary margin is the small-table batch31 common-hash path:1.01964–1.03253× over the optional native Range control. Large-table batch4096 common-hash gains are1.03628–1.04991×. These small margins remain explicit; the experiment does not provide a timing significance test.

## Prespecified large-table cap32 secondary

These views include all primary24 allocations plus BoostMulti32K8@28, FastPattern@32 and FourSector@32. The extra geometries ran in separate processes. Primary K12 measurements are reused; this is not an additional independent experiment or a claim that every allocation shared a process.

|Batch|Query contract|Best external / K12|Best retained project / K12|Retained winners across seeds|
|---:|---|---:|---:|---|
|31|Prehashed|1.1911–1.2103×|1.0257–1.0671×|FastPatternBF|
|31|Common hash + query|1.1129–1.1230×|1.0163–1.0256×|FourSectorBloomFilter|
|4096|Prehashed|1.1053–1.1137×|1.0599–1.0632×|FastPatternBF|
|4096|Common hash + query|1.0920–1.1306×|1.0363–1.0499×|Split64RangeNative|

The smallest secondary margin is1.01628–1.02557× versus FourSector@32 on the large batch31 common-hash path.

## Independent quality gates

Every API/allocation passes all three separately calculated two-sided95% Wilson upper endpoints at0.01%. No calibration extension occurred. The39 API/geometry/seed records reduce only to33 proven mapping records: Range/Fixed64 aliases and repeated batches are not pooled or counted as new negatives. The table retains each API and its actual backing allocation.

|API|Keys|Requested bpk|Actual backing bytes|Worst three-seed Wilson upper, %|All3 pass|
|---|---:|---:|---:|---:|---|
|Boost192Multi32K8|33,554,432|28|117,440,511|0.00764486|True|
|Boost192Multi64K8|65,536|24|196,607|0.00954699|True|
|Boost192Multi64K8|33,554,432|24|100,663,295|0.00937198|True|
|FastFilterFixed64|65,536|24|196,608|0.00945647|True|
|FastFilterFixed64|33,554,432|24|100,663,296|0.00936896|True|
|FastPatternBF|33,554,432|32|134,217,728|0.00943384|True|
|FourSectorBloomFilter|33,554,432|32|134,217,728|0.00214634|True|
|FourSectorRange12Experiment|65,536|24|196,608|0.00929051|True|
|FourSectorRange12Experiment|33,554,432|24|100,663,296|0.00952436|True|
|RocksDBFastLocalBloom64K8Batch32|65,536|24|196,608|0.00937802|True|
|RocksDBFastLocalBloom64K8Batch32|33,554,432|24|100,663,296|0.00923920|True|
|Split64RangeNative|65,536|24|196,608|0.00945647|True|
|Split64RangeNative|33,554,432|24|100,663,296|0.00936896|True|

K12 worst upper bounds are0.00929051% (small) and0.00952436% (large). These are finite-sample, pointwise intervals, not simultaneous guarantees across all filters and constructions. All-seed, current-seed and unconditional-speed leader views coincide in this run because every gate passes.

## Limits and next step

The result supports an isolated Rust port and a possible optional strict24 bulk configuration. It does not change the default layout and does not establish singleton, construction, multithreaded, every-capacity or global leadership. Rivals are the prespecified union of leaders from the complete earlier296-row training screen, not every unmeasured external configuration.

The earlier training failures remain: K12@16 failed the0.1% and0.01% quality gates, and across the wider training views K12 had30 external losses and44 retained-project losses. Those results are not overwritten by this narrower successful confirmation. See [the original interpretation](../2026-10-29-four-sector-range12-analysis/INTERPRETATION.md).

First/middle/last strata and every named pair are retained in `report/named-pairs.csv` and `report/paired-conditions.json`. Each stratum contains one seed; order and seed effects cannot be separated causally. Primary views share one same-process five-API workload, but no absolute five-position or all-rival pairwise balance is claimed.

## Reproduction and evidence

- Fixed source: `e278444c70ac3f9e513dea0395490ad34a39c214`; native binary `9aceea39f8f57564409806f911ddcf2ec6c17ff623a5132acbb609b11ad05149`.
- Complete raw51-file archive committed before analysis: `9513c57903cfa0fc71039fa21999e51667e8279e`; descriptor SHA `695b832dd90c1fbfe5720cc222988f71c5185b9bada962e456102d5f58913299`.
- All24 commands/78 rows were replay-audited for exact order, geometry, source/binary identity, balanced phases, six-trial medians/extrema and raw/aggregate equality. CPU3/socket1 whole flock held; no explicit NUMA memory binding claim.
- Separate analysis emits108 views (36 conditions × three eligibility policies),648 alternatives,180 named pairs and60 three-seed pair conditions; six synthetic guards pass. Initial analysis-only syntax failure is retained in `offline-v1.txt` and corrected before reading fresh measurements.
- No compiler or filter was executed by the analysis. The full numerical records and all quality identities are in `report/`.
