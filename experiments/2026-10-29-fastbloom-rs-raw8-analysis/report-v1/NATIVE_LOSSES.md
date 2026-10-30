# All combined-native losses to the external envelope

These 25 rows preserve all 16 query and 9 build losses. Ratio is external/native, so less than 1 means native is slower. No cap 16/0.01% no-comparable view is relabeled as a loss.

| n | batch | cap bpk | FPR % | metric | Native IDs | Native ns | External IDs | External ns | External/native |
|---:|---:|---:|---:|---|---|---:|---|---:|---:|
| 65536 | 1 | 16 | 1 | raw_batched_public | ByteSplitBloomFilter-n65536-b16 | 5.528659 | BloomsdayPinned-n65536-b16 | 4.552005 | 0.823347 |
| 65536 | 1 | 24 | 1 | raw_batched_public | ByteSplitBloomFilter-n65536-b16 | 5.528659 | BloomsdayPinned-n65536-b16 | 4.552005 | 0.823347 |
| 65536 | 1 | 24 | 0.1 | raw_batched_public | Split64BloomFilter-n65536-b16 | 5.538251 | BloomsdayPinned-n65536-b24 | 4.570138 | 0.825195 |
| 65536 | 1 | 24 | 0.1 | raw_visible_public | Split64BloomFilter-n65536-b16 | 3.093509 | BloomsdayPinned-n65536-b24 | 2.166684 | 0.700397 |
| 65536 | 1 | 24 | 0.1 | raw_insert | Split64BloomFilter-n65536-b16 | 2.248665 | BloomsdayPinned-n65536-b24 | 1.669861 | 0.742601 |
| 65536 | 1 | 24 | 0.1 | allocate_filter_and_scratch_raw_insert | Split64BloomFilter-n65536-b16 | 2.318855 | BloomsdayPinned-n65536-b24 | 1.738197 | 0.749593 |
| 65536 | 1 | 32 | 1 | raw_batched_public | ByteSplitBloomFilter-n65536-b16 | 5.528659 | BloomsdayPinned-n65536-b16 | 4.552005 | 0.823347 |
| 65536 | 1 | 32 | 0.1 | raw_batched_public | Split64BloomFilter-n65536-b16 | 5.538251 | BloomsdayPinned-n65536-b32 | 4.557024 | 0.822827 |
| 65536 | 1 | 32 | 0.01 | raw_batched_public | Split64BloomFilter-n65536-b32 | 5.547740 | BloomsdayPinned-n65536-b32 | 4.557024 | 0.821420 |
| 65536 | 1 | 32 | 0.01 | raw_visible_public | Split64BloomFilter-n65536-b32 | 3.117797 | BloomsdayPinned-n65536-b32 | 2.146949 | 0.688611 |
| 65536 | 1 | 32 | 0.01 | raw_insert | Split64BloomFilter-n65536-b32 | 2.265007 | BloomsdayPinned-n65536-b32 | 1.738800 | 0.767680 |
| 65536 | 31 | 24 | 0.1 | raw_visible_public | Split64BloomFilter-n65536-b16 | 3.094688 | BloomsdayPinned-n65536-b24 | 2.144416 | 0.692935 |
| 65536 | 31 | 24 | 0.1 | raw_insert | Split64BloomFilter-n65536-b16 | 2.205940 | BloomsdayPinned-n65536-b24 | 1.676781 | 0.760121 |
| 65536 | 31 | 24 | 0.1 | allocate_filter_and_scratch_raw_insert | Split64BloomFilter-n65536-b16 | 2.272636 | BloomsdayPinned-n65536-b24 | 1.790504 | 0.787853 |
| 65536 | 31 | 32 | 0.01 | raw_visible_public | Split64BloomFilter-n65536-b32 | 3.115058 | BloomsdayPinned-n65536-b32 | 2.160516 | 0.693572 |
| 65536 | 31 | 32 | 0.01 | raw_insert | Split64BloomFilter-n65536-b32 | 2.243484 | BloomsdayPinned-n65536-b32 | 1.699684 | 0.757609 |
| 65536 | 4096 | 24 | 0.1 | raw_visible_public | Split64BloomFilter-n65536-b16 | 3.089831 | BloomsdayPinned-n65536-b24 | 2.146630 | 0.694740 |
| 65536 | 4096 | 24 | 0.1 | raw_insert | Split64RangeBloomFilter-n65536-b16 | 2.234848 | BloomsdayPinned-n65536-b24 | 1.637436 | 0.732683 |
| 65536 | 4096 | 24 | 0.1 | allocate_filter_and_scratch_raw_insert | Split64RangeBloomFilter-n65536-b16 | 2.282776 | BloomsdayPinned-n65536-b24 | 1.707138 | 0.747834 |
| 65536 | 4096 | 32 | 0.01 | raw_visible_public | Split64BloomFilter-n65536-b32 | 3.112384 | BloomsdayPinned-n65536-b32 | 2.159405 | 0.693811 |
| 65536 | 4096 | 32 | 0.01 | raw_insert | Split64RangeBloomFilter-n65536-b32 | 2.305466 | BloomsdayPinned-n65536-b32 | 1.693230 | 0.734441 |
| 33554432 | 1 | 32 | 0.01 | raw_batched_public | Split64RangeBloomFilter-n33554432-b24 | 20.399520 | BloomsdayPinned-n33554432-b32 | 19.753179 | 0.968316 |
| 33554432 | 1 | 32 | 0.01 | raw_visible_public | Split64RangeBloomFilter-n33554432-b24 | 12.268450 | BloomsdayPinned-n33554432-b32 | 10.391776 | 0.847033 |
| 33554432 | 31 | 32 | 0.01 | raw_visible_public | Split64RangeBloomFilter-n33554432-b24 | 12.016544 | BloomsdayPinned-n33554432-b32 | 10.426584 | 0.867686 |
| 33554432 | 4096 | 32 | 0.01 | raw_visible_public | Split64RangeBloomFilter-n33554432-b24 | 11.961193 | BloomsdayPinned-n33554432-b32 | 10.480719 | 0.876227 |
