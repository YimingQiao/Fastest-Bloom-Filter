# Rust Range24 fixed fresh confirmation

The complete 12-workload/24-row confirmation gives Range query wins/losses/ties **48/0/0** and build wins/losses/ties **48/0/0** against the prespecified public Fastbloom 0.17 K7 control at equal actual 24 bits/key. All 96 paired outcomes and 48 two-seed conditions are retained; ratio below1 means a Range loss.

All four API/size gates pass both fixed fresh seeds: True. Each gate uses separate 2^24-negative Wilson 95% upper endpoints at 0.01%; no seeds, aliases, batches or modes are pooled.

| Keys | API | Seed | False positives / negatives | Wilson95% upper, percent | Pass |
|---:|---|---:|---:|---:|---|
| 65536 | Fastbloom017K7 | 32452843 | 1098 / 16777216 | 0.00694330% | True |
| 65536 | Fastbloom017K7 | 49979687 | 1135 / 16777216 | 0.00717030% | True |
| 33554432 | Fastbloom017K7 | 32452843 | 1151 / 16777216 | 0.00726843% | True |
| 33554432 | Fastbloom017K7 | 49979687 | 1086 / 16777216 | 0.00686965% | True |
| 65536 | Split64RangeBloomFilter | 32452843 | 1553 / 16777216 | 0.00972855% | True |
| 65536 | Split64RangeBloomFilter | 49979687 | 1514 / 16777216 | 0.00949027% | True |
| 33554432 | Split64RangeBloomFilter | 32452843 | 1462 / 16777216 | 0.00917246% | True |
| 33554432 | Split64RangeBloomFilter | 49979687 | 1557 / 16777216 | 0.00975298% | True |

Query contracts and build boundaries remain separate. The table shows the smaller and larger external/Range ratios across the two seeds for each fixed workload; this is a descriptive range of paired medians, not a confidence interval.

| Keys | Batch | Metric | Min–max ratio | W/L/T |
|---:|---:|---|---:|---:|
| 65536 | 1 | `lookup_ns` | 3.3922–3.4495× | 2/0/0 |
| 65536 | 1 | `hash_lookup_ns` | 2.8169–2.8207× | 2/0/0 |
| 65536 | 1 | `inline_lookup_ns` | 4.3482–4.3565× | 2/0/0 |
| 65536 | 1 | `inline_hash_lookup_ns` | 4.5125–4.5179× | 2/0/0 |
| 65536 | 1 | `insert_ns` | 3.6251–3.6515× | 2/0/0 |
| 65536 | 1 | `allocate_insert_ns` | 2.2118–2.2575× | 2/0/0 |
| 65536 | 1 | `hash_insert_ns` | 3.0871–3.1895× | 2/0/0 |
| 65536 | 1 | `allocate_hash_insert_ns` | 2.0731–2.1360× | 2/0/0 |
| 65536 | 31 | `lookup_ns` | 7.2706–7.4635× | 2/0/0 |
| 65536 | 31 | `hash_lookup_ns` | 5.7836–5.7922× | 2/0/0 |
| 65536 | 31 | `inline_lookup_ns` | 4.3441–4.3470× | 2/0/0 |
| 65536 | 31 | `inline_hash_lookup_ns` | 4.5098–4.5167× | 2/0/0 |
| 65536 | 31 | `insert_ns` | 3.6261–3.6454× | 2/0/0 |
| 65536 | 31 | `allocate_insert_ns` | 2.3197–2.3942× | 2/0/0 |
| 65536 | 31 | `hash_insert_ns` | 3.1109–3.1519× | 2/0/0 |
| 65536 | 31 | `allocate_hash_insert_ns` | 2.0944–2.1947× | 2/0/0 |
| 65536 | 4096 | `lookup_ns` | 6.6824–6.8034× | 2/0/0 |
| 65536 | 4096 | `hash_lookup_ns` | 5.4391–5.4934× | 2/0/0 |
| 65536 | 4096 | `inline_lookup_ns` | 4.3520–4.3630× | 2/0/0 |
| 65536 | 4096 | `inline_hash_lookup_ns` | 4.5141–4.5213× | 2/0/0 |
| 65536 | 4096 | `insert_ns` | 3.6441–3.6739× | 2/0/0 |
| 65536 | 4096 | `allocate_insert_ns` | 2.2130–2.4251× | 2/0/0 |
| 65536 | 4096 | `hash_insert_ns` | 3.1144–3.1850× | 2/0/0 |
| 65536 | 4096 | `allocate_hash_insert_ns` | 2.0838–2.2304× | 2/0/0 |
| 33554432 | 1 | `lookup_ns` | 2.6545–2.6602× | 2/0/0 |
| 33554432 | 1 | `hash_lookup_ns` | 2.0379–2.0404× | 2/0/0 |
| 33554432 | 1 | `inline_lookup_ns` | 3.5730–3.5833× | 2/0/0 |
| 33554432 | 1 | `inline_hash_lookup_ns` | 3.1278–3.1439× | 2/0/0 |
| 33554432 | 1 | `insert_ns` | 6.8795–7.1303× | 2/0/0 |
| 33554432 | 1 | `allocate_insert_ns` | 6.4694–6.7017× | 2/0/0 |
| 33554432 | 1 | `hash_insert_ns` | 5.9123–6.1480× | 2/0/0 |
| 33554432 | 1 | `allocate_hash_insert_ns` | 5.6096–5.8340× | 2/0/0 |
| 33554432 | 31 | `lookup_ns` | 4.3731–4.4530× | 2/0/0 |
| 33554432 | 31 | `hash_lookup_ns` | 4.2196–4.3084× | 2/0/0 |
| 33554432 | 31 | `inline_lookup_ns` | 3.4896–3.5766× | 2/0/0 |
| 33554432 | 31 | `inline_hash_lookup_ns` | 3.0669–3.1436× | 2/0/0 |
| 33554432 | 31 | `insert_ns` | 6.8751–7.1464× | 2/0/0 |
| 33554432 | 31 | `allocate_insert_ns` | 6.4622–6.7197× | 2/0/0 |
| 33554432 | 31 | `hash_insert_ns` | 5.8999–6.1805× | 2/0/0 |
| 33554432 | 31 | `allocate_hash_insert_ns` | 5.6017–5.8678× | 2/0/0 |
| 33554432 | 4096 | `lookup_ns` | 5.8470–5.8529× | 2/0/0 |
| 33554432 | 4096 | `hash_lookup_ns` | 6.0850–6.0893× | 2/0/0 |
| 33554432 | 4096 | `inline_lookup_ns` | 3.5731–3.5827× | 2/0/0 |
| 33554432 | 4096 | `inline_hash_lookup_ns` | 3.1204–3.1391× | 2/0/0 |
| 33554432 | 4096 | `insert_ns` | 7.1192–7.1638× | 2/0/0 |
| 33554432 | 4096 | `allocate_insert_ns` | 6.6924–6.7342× | 2/0/0 |
| 33554432 | 4096 | `hash_insert_ns` | 6.1716–6.1997× | 2/0/0 |
| 33554432 | 4096 | `allocate_hash_insert_ns` | 5.8518–5.8806× | 2/0/0 |

[Raw data and completed identity ledger](../2026-10-29-split64-range-rust-strict24-confirmation/screening/results-v1/metadata.json), [prespecified training leader union](../2026-10-29-split64-range-rust-strict24-confirmation/selection.json), and [complete preceding public-K training report](../2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/REPORT.md) retain the underlying scope and failures.

The original row-order reversal is exact at both sizes and every batch: seed 32452843 puts K7 first, seed 49979687 puts Range first. `paired.csv` retains each seed/order separately. Four query phases are balanced over 8 repetitions and retain their complete trial vectors and min/max; the four build metrics retain producer medians only. Build order is not a balanced causal experiment, and allocator/address variation is not isolated.

The visible scalar whole-array loops still call each public singleton API and, for fused raw queries, the common hash inside that loop. Their batch tag identifies a repeated surrounding workload, not a change in their per-key API contract. Staged prehashed and staged hash+query retain their separate bulk API boundaries.

Scope: the two APIs were fixed before new filter outputs. K7 at 24 bpk is the exact union of all 48 strongest qualifying external query/build leaders selected from the preceding complete K1..12, default, SBBF and Bloomsday training table. This confirms that finite capacity niche against the training-derived shortlist; it does not show that K7 is the fastest external configuration on every fresh seed, nor global leadership. The broader training eligibility/failure table and all fixed-K support remain in the immutable proposal. No new allocation, K, seed or baseline was selected here.

The payloads are 196,608 bytes for 65,536 keys and 100,663,296 bytes for 33,554,432 keys. Range has less quality margin than K7; these finite uniform-hash samples do not impose a universal true-FPR guarantee. Existing equal 16/32-bpk Range-vs-Split losses in the training archive remain relevant: an optional 24-bpk API is a distinct capacity choice, not evidence to replace the existing default everywhere.

Source `87f662b00f853780003731c3dd35ec746d0a7e2c`, completed raw `e1b06581872c18fde71a02dd0bb7eacbba0a2259`, frozen native binary `f499f5daa354f3db31c5cfa1e84640c890f96c81e2724456aa64bf7b6bc7ef05`. Single completed measurement session 92333, CPU3/socket1 affinity only; no explicit NUMA memory binding. There was no rebuild or algorithm change, no partial-results selection, and no discarded failed formal run. Raw evidence was committed before this analysis.
