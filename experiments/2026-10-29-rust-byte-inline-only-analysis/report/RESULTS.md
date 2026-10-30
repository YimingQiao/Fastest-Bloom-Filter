# Byte-only annotation comparison

Same-process native annotation/placement comparison only; no external leadership, no global fastest claim, no cross-CPU/binary timing comparison. Two seeds and repeated four-mode/batch views are not independent replicated algorithms or pooled quality samples.

All96 rows and source/binary pins pass. Pair orders reverse between seeds; absolute middle position is not balanced. The one-hint and triple-hint active visible code is identical, as are all three active batch3 AVX2 regions; addresses differ. These are descriptive measurements, not a causal alignment result or statistical superiority test.

## Batch1 pair ratios

Values above1 favor the row named after. Every individual loss and min/max remains in CSV/JSON.

| Keys | Actual bpk | Metric | Original / one hint | Original / triple | Triple / one hint |
|---:|---:|---|---:|---:|---:|
| 65536 | 16 | lookup_ns | 1.0266 | 1.0025 | 1.0240 |
| 65536 | 16 | hash_lookup_ns | 0.9999 | 0.9999 | 1.0000 |
| 65536 | 16 | inline_lookup_ns | 1.5146 | 1.5150 | 0.9998 |
| 65536 | 16 | inline_hash_lookup_ns | 1.3779 | 1.3749 | 1.0022 |
| 65536 | 32 | lookup_ns | 1.0234 | 1.0032 | 1.0202 |
| 65536 | 32 | hash_lookup_ns | 0.9999 | 1.0001 | 0.9998 |
| 65536 | 32 | inline_lookup_ns | 1.4911 | 1.4969 | 0.9961 |
| 65536 | 32 | inline_hash_lookup_ns | 1.3835 | 1.3837 | 0.9999 |
| 33554432 | 16 | lookup_ns | 1.0121 | 1.0337 | 0.9791 |
| 33554432 | 16 | hash_lookup_ns | 1.0081 | 1.0211 | 0.9873 |
| 33554432 | 16 | inline_lookup_ns | 1.2418 | 1.2497 | 0.9936 |
| 33554432 | 16 | inline_hash_lookup_ns | 1.1569 | 1.1710 | 0.9880 |
| 33554432 | 32 | lookup_ns | 1.0054 | 1.0031 | 1.0023 |
| 33554432 | 32 | hash_lookup_ns | 1.0024 | 1.0006 | 1.0018 |
| 33554432 | 32 | inline_lookup_ns | 1.2626 | 1.2601 | 1.0020 |
| 33554432 | 32 | inline_hash_lookup_ns | 1.2356 | 1.2306 | 1.0040 |

## All retained losses

- ByteSplitBloomFilter / ByteOnlyInlineV1: after wins98/128, loses30, ties0; minimum ratio0.968118. These views reuse data and are not independent significance trials.
- ByteSplitBloomFilter / ByteTripleHintControl: after wins98/128, loses30, ties0; minimum ratio0.956353. These views reuse data and are not independent significance trials.
- ByteTripleHintControl / ByteOnlyInlineV1: after wins69/128, loses59, ties0; minimum ratio0.965633. These views reuse data and are not independent significance trials.

Quality consists of8 size/budget/seed records, each with its own two-sided95% Wilson interval; clone, batch and mode repeats are discarded. Worst endpoints across the two seeds are reported without pooling. No allocation or candidate is selected by this report.
