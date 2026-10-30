# Fixed bounded-build confirmation

The one unchanged policy uses one build worker only when the current batch has at most65,536 hashes and the actual bitmap has at most256KiB. This report retains each family/scenario/request/seed separately. Query code and query performance are outside this comparison.

Both languages used fresh seeds74381/164321, requested4/8 and the six fixed scenarios. Each comparison is paired within one process with C/P ABBA positions; serial is first/last only. Serial-reference overhead is in serial-overhead.csv, not silently included twice. Populated allocation+build remains unavailable. Setup costs are separate diagnostics.

The following ranges contain the two individual seed ratios for exactly the indicated language/family/scenario/T/contract. They are not confidence intervals, pooled scenarios or independent statistical wins. Ratio is control/candidate: above1 favors the bounded candidate. Every individual loss and all trial vectors remain in the CSV files.

## Inside the fixed policy gate

| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |
|---|---|---|---:|---|---:|---:|
| cpp | Split64 | small_empty_uniform | 4 | allocate_insert | 2.9227× | 2.8522× |
| cpp | Split64 | small_empty_uniform | 4 | insert | 3.3458× | 3.1465× |
| cpp | Split64 | small_empty_uniform | 8 | allocate_insert | 6.9158× | 4.2323× |
| cpp | Split64 | small_empty_uniform | 8 | insert | 8.4673× | 5.6045× |
| cpp | Split64 | small_prefilled_hotspot | 4 | insert | 2.8442× | 2.6747× |
| cpp | Split64 | small_prefilled_hotspot | 8 | insert | 4.0735× | 4.2127× |
| cpp | Split64Range | small_empty_uniform | 4 | allocate_insert | 2.7160× | 2.6201× |
| cpp | Split64Range | small_empty_uniform | 4 | insert | 2.9859× | 2.8025× |
| cpp | Split64Range | small_empty_uniform | 8 | allocate_insert | 4.2213× | 6.4533× |
| cpp | Split64Range | small_empty_uniform | 8 | insert | 4.9931× | 7.3318× |
| cpp | Split64Range | small_prefilled_hotspot | 4 | insert | 2.8162× | 2.7246× |
| cpp | Split64Range | small_prefilled_hotspot | 8 | insert | 5.7260× | 3.9482× |
| rust | Split64 | small_empty_uniform | 4 | allocate_insert | 2.7806× | 2.3943× |
| rust | Split64 | small_empty_uniform | 4 | insert | 4.2464× | 3.4670× |
| rust | Split64 | small_empty_uniform | 8 | allocate_insert | 5.0639× | 4.6125× |
| rust | Split64 | small_empty_uniform | 8 | insert | 4.7302× | 5.0224× |
| rust | Split64 | small_prefilled_hotspot | 4 | insert | 2.8874× | 2.9789× |
| rust | Split64 | small_prefilled_hotspot | 8 | insert | 3.9665× | 3.6382× |
| rust | Split64Range | small_empty_uniform | 4 | allocate_insert | 2.5791× | 2.2493× |
| rust | Split64Range | small_empty_uniform | 4 | insert | 3.3386× | 3.0910× |
| rust | Split64Range | small_empty_uniform | 8 | allocate_insert | 4.3607× | 3.6055× |
| rust | Split64Range | small_empty_uniform | 8 | insert | 4.8997× | 5.0269× |
| rust | Split64Range | small_prefilled_hotspot | 4 | insert | 3.3617× | 3.0638× |
| rust | Split64Range | small_prefilled_hotspot | 8 | insert | 4.0458× | 3.7895× |

## Unchanged-policy controls outside the gate

| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |
|---|---|---|---:|---|---:|---:|
| cpp | Split64 | above_batch_empty_uniform | 4 | allocate_insert | 1.0045× | 0.9796× |
| cpp | Split64 | above_batch_empty_uniform | 4 | insert | 0.9315× | 0.9726× |
| cpp | Split64 | above_batch_empty_uniform | 8 | allocate_insert | 1.0326× | 1.0360× |
| cpp | Split64 | above_batch_empty_uniform | 8 | insert | 1.0157× | 1.0395× |
| cpp | Split64 | above_bytes_empty_uniform | 4 | allocate_insert | 1.2190× | 1.1773× |
| cpp | Split64 | above_bytes_empty_uniform | 4 | insert | 0.9977× | 1.0403× |
| cpp | Split64 | above_bytes_empty_uniform | 8 | allocate_insert | 0.9158× | 1.1192× |
| cpp | Split64 | above_bytes_empty_uniform | 8 | insert | 1.0016× | 1.0133× |
| cpp | Split64 | large_empty_uniform | 4 | allocate_insert | 0.9987× | 1.0038× |
| cpp | Split64 | large_empty_uniform | 4 | insert | 1.0322× | 1.0033× |
| cpp | Split64 | large_empty_uniform | 8 | allocate_insert | 0.9979× | 0.9992× |
| cpp | Split64 | large_empty_uniform | 8 | insert | 0.9689× | 1.0039× |
| cpp | Split64 | large_prefilled_hotspot | 4 | insert | 1.0021× | 0.9719× |
| cpp | Split64 | large_prefilled_hotspot | 8 | insert | 0.9801× | 0.9925× |
| cpp | Split64Range | above_batch_empty_uniform | 4 | allocate_insert | 0.9902× | 1.0611× |
| cpp | Split64Range | above_batch_empty_uniform | 4 | insert | 1.0008× | 0.9529× |
| cpp | Split64Range | above_batch_empty_uniform | 8 | allocate_insert | 1.0282× | 1.0392× |
| cpp | Split64Range | above_batch_empty_uniform | 8 | insert | 1.0389× | 0.9865× |
| cpp | Split64Range | above_bytes_empty_uniform | 4 | allocate_insert | 0.9976× | 0.9686× |
| cpp | Split64Range | above_bytes_empty_uniform | 4 | insert | 0.9454× | 0.9999× |
| cpp | Split64Range | above_bytes_empty_uniform | 8 | allocate_insert | 0.9780× | 1.0312× |
| cpp | Split64Range | above_bytes_empty_uniform | 8 | insert | 1.0575× | 1.0040× |
| cpp | Split64Range | large_empty_uniform | 4 | allocate_insert | 1.0006× | 0.9944× |
| cpp | Split64Range | large_empty_uniform | 4 | insert | 0.9519× | 1.0075× |
| cpp | Split64Range | large_empty_uniform | 8 | allocate_insert | 0.9982× | 0.9991× |
| cpp | Split64Range | large_empty_uniform | 8 | insert | 0.9859× | 0.9775× |
| cpp | Split64Range | large_prefilled_hotspot | 4 | insert | 1.0299× | 0.9894× |
| cpp | Split64Range | large_prefilled_hotspot | 8 | insert | 0.9840× | 0.9774× |
| rust | Split64 | above_batch_empty_uniform | 4 | allocate_insert | 1.0159× | 1.0193× |
| rust | Split64 | above_batch_empty_uniform | 4 | insert | 0.9946× | 0.9203× |
| rust | Split64 | above_batch_empty_uniform | 8 | allocate_insert | 0.8777× | 0.8244× |
| rust | Split64 | above_batch_empty_uniform | 8 | insert | 1.0147× | 1.1106× |
| rust | Split64 | above_bytes_empty_uniform | 4 | allocate_insert | 0.9628× | 0.9130× |
| rust | Split64 | above_bytes_empty_uniform | 4 | insert | 1.0443× | 1.0087× |
| rust | Split64 | above_bytes_empty_uniform | 8 | allocate_insert | 0.9719× | 0.8855× |
| rust | Split64 | above_bytes_empty_uniform | 8 | insert | 1.1924× | 0.9992× |
| rust | Split64 | large_empty_uniform | 4 | allocate_insert | 1.0012× | 0.9733× |
| rust | Split64 | large_empty_uniform | 4 | insert | 0.9543× | 0.9952× |
| rust | Split64 | large_empty_uniform | 8 | allocate_insert | 1.0028× | 0.9985× |
| rust | Split64 | large_empty_uniform | 8 | insert | 0.9939× | 0.9830× |
| rust | Split64 | large_prefilled_hotspot | 4 | insert | 0.9996× | 1.0806× |
| rust | Split64 | large_prefilled_hotspot | 8 | insert | 1.0075× | 0.9819× |
| rust | Split64Range | above_batch_empty_uniform | 4 | allocate_insert | 0.9630× | 0.9617× |
| rust | Split64Range | above_batch_empty_uniform | 4 | insert | 0.9923× | 1.0826× |
| rust | Split64Range | above_batch_empty_uniform | 8 | allocate_insert | 0.9166× | 0.9377× |
| rust | Split64Range | above_batch_empty_uniform | 8 | insert | 0.9436× | 1.1103× |
| rust | Split64Range | above_bytes_empty_uniform | 4 | allocate_insert | 0.9975× | 1.0704× |
| rust | Split64Range | above_bytes_empty_uniform | 4 | insert | 1.1194× | 0.9470× |
| rust | Split64Range | above_bytes_empty_uniform | 8 | allocate_insert | 0.9320× | 0.9771× |
| rust | Split64Range | above_bytes_empty_uniform | 8 | insert | 0.9916× | 0.8927× |
| rust | Split64Range | large_empty_uniform | 4 | allocate_insert | 1.0012× | 1.0018× |
| rust | Split64Range | large_empty_uniform | 4 | insert | 0.9913× | 0.9786× |
| rust | Split64Range | large_empty_uniform | 8 | allocate_insert | 0.9970× | 1.0028× |
| rust | Split64Range | large_empty_uniform | 8 | insert | 0.9780× | 0.9297× |
| rust | Split64Range | large_prefilled_hotspot | 4 | insert | 1.0158× | 0.9711× |
| rust | Split64Range | large_prefilled_hotspot | 8 | insert | 0.9464× | 0.9898× |

## Interpretation boundary

This archive does not automatically promote a policy. Inside-gate benefit and all outside-gate regressions must be considered together, including direct-serial overhead. Outside-gate calls have the same native worker request, so any measured differences there are caller/code-generation or measurement effects, not a newly different partition algorithm. No threshold or extra case is chosen from these results.

Only Split64 and Split64Range were tested. Integration must leave Four/Byte shared helpers and every query request unchanged, use current insertion length rather than constructor realN, keep build-worker/scratch getters consistent, and preserve each language's automatic0 behavior outside the gate. A production port can change code generation and still requires an appropriately scoped native check.

Raw commit `5677deaed887db9066f773526388e56d48f3b4de`; timed source `22617d4ea12e93b8f4fd1c3501bf82a25a12e9de`. Complete196-file raw/source audit precedes analysis. No additional compiler or Bloom run occurred.
