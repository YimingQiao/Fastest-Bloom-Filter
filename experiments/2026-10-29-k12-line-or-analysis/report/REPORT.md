# K12 whole-line insertion screen

Fixed n=65,536 and33,554,432; actual24bpk; insertion chunks4 and whole input; seeds5011/6011. Each of8 processes runs both actual public types, with relative filter order reversed for6011. Five fresh construction trials per pure/common-hash contract; q18/hit50/batch4096 queries validate semantics only. CPU3, NUMA1, Clang23 native binary.

All ratios are **candidate latency / control latency**: below1 is faster. The two seed values are descriptive ranges, not confidence intervals. Allocation-plus-build contains the corresponding insertion interval; those measurements are dependent. Build phase order remains pure then common hash. No query, accuracy or external leadership ranking is made.

| Keys | Insertion chunk | Metric | Minimum ratio | Maximum ratio | Seed5011 /6011 |
|---:|---:|---|---:|---:|---|
| 65536 | 4 | insert_ns | 0.992399 | 0.995294 | faster / faster |
| 65536 | 4 | allocate_insert_ns | 0.991402 | 1.007356 | slower / faster |
| 65536 | 4 | hash_insert_ns | 0.791029 | 0.829296 | faster / faster |
| 65536 | 4 | allocate_hash_insert_ns | 0.810518 | 0.816865 | faster / faster |
| 65536 | 65536 | insert_ns | 1.039279 | 1.040843 | slower / slower |
| 65536 | 65536 | allocate_insert_ns | 1.043947 | 1.090790 | slower / slower |
| 65536 | 65536 | hash_insert_ns | 1.028184 | 1.061210 | slower / slower |
| 65536 | 65536 | allocate_hash_insert_ns | 1.048088 | 1.094954 | slower / slower |
| 33554432 | 4 | insert_ns | 0.773026 | 0.780843 | faster / faster |
| 33554432 | 4 | allocate_insert_ns | 0.775621 | 0.786457 | faster / faster |
| 33554432 | 4 | hash_insert_ns | 0.762935 | 0.767474 | faster / faster |
| 33554432 | 4 | allocate_hash_insert_ns | 0.769191 | 0.773075 | faster / faster |
| 33554432 | 33554432 | insert_ns | 0.830449 | 0.833941 | faster / faster |
| 33554432 | 33554432 | allocate_insert_ns | 0.843885 | 0.849469 | faster / faster |
| 33554432 | 33554432 | hash_insert_ns | 0.847189 | 0.854637 | faster / faster |
| 33554432 | 33554432 | allocate_hash_insert_ns | 0.855449 | 0.862646 | faster / faster |

## Every slower outcome

| Keys | Chunk | Seed | Metric | Control ns/key | Candidate ns/key | Latency ratio |
|---:|---:|---:|---|---:|---:|---:|
| 65536 | 4 | 5011 | allocate_insert_ns | 5.430679 | 5.470627 | 1.007356 |
| 65536 | 65536 | 5011 | insert_ns | 3.725876 | 3.878052 | 1.040843 |
| 65536 | 65536 | 5011 | allocate_insert_ns | 4.748413 | 4.957092 | 1.043947 |
| 65536 | 65536 | 5011 | hash_insert_ns | 4.212097 | 4.330811 | 1.028184 |
| 65536 | 65536 | 5011 | allocate_hash_insert_ns | 5.170532 | 5.419174 | 1.048088 |
| 65536 | 65536 | 6011 | insert_ns | 3.751495 | 3.898849 | 1.039279 |
| 65536 | 65536 | 6011 | allocate_insert_ns | 4.742844 | 5.173447 | 1.090790 |
| 65536 | 65536 | 6011 | hash_insert_ns | 4.185730 | 4.441940 | 1.061210 |
| 65536 | 65536 | 6011 | allocate_hash_insert_ns | 5.193878 | 5.687057 | 1.094954 |

All32 comparisons and64 original vectors are retained in paired.csv and trials.csv. Whole allocation-plus-build outcomes must be considered before any recommendation. The screen alone does not authorize production promotion or further parameter search.
