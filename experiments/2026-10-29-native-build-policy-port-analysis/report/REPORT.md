# Actual-native fixed bounded-build confirmation

The one unchanged policy uses one build worker only when the current batch has at most65,536 hashes and the actual bitmap has at most256KiB. This report retains each family/scenario/request/seed separately. Query code and query performance are outside this comparison.

Both languages retain seen seeds74381/164321 from the wrapper stage, requested4/8 and the six fixed scenarios. Each comparison is paired within one process with C/P ABBA positions; serial is first/last only. Serial-reference overhead is in serial-overhead.csv, not silently included twice. Populated allocation+build remains unavailable. Setup costs are separate diagnostics.

The following ranges contain the two individual seed ratios for exactly the indicated language/family/scenario/T/contract. They are not confidence intervals, pooled scenarios or independent statistical wins. Ratio is control/candidate: above1 favors the bounded candidate. Every individual loss and all trial vectors remain in the CSV files.

## Inside the fixed policy gate

| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |
|---|---|---|---:|---|---:|---:|
| cpp | Split64 | small_empty_uniform | 4 | allocate_insert | 2.9848× | 2.6106× |
| cpp | Split64 | small_empty_uniform | 4 | insert | 3.3493× | 2.9309× |
| cpp | Split64 | small_empty_uniform | 8 | allocate_insert | 4.2052× | 4.5366× |
| cpp | Split64 | small_empty_uniform | 8 | insert | 5.0577× | 4.7484× |
| cpp | Split64 | small_prefilled_hotspot | 4 | insert | 2.7148× | 2.6585× |
| cpp | Split64 | small_prefilled_hotspot | 8 | insert | 4.0875× | 4.0751× |
| cpp | Split64Range | small_empty_uniform | 4 | allocate_insert | 2.8054× | 2.6062× |
| cpp | Split64Range | small_empty_uniform | 4 | insert | 2.9681× | 2.8591× |
| cpp | Split64Range | small_empty_uniform | 8 | allocate_insert | 4.3306× | 4.0413× |
| cpp | Split64Range | small_empty_uniform | 8 | insert | 4.5612× | 4.6937× |
| cpp | Split64Range | small_prefilled_hotspot | 4 | insert | 2.6634× | 2.8788× |
| cpp | Split64Range | small_prefilled_hotspot | 8 | insert | 4.1515× | 5.7384× |
| rust | Split64 | small_empty_uniform | 4 | allocate_insert | 2.5903× | 2.4626× |
| rust | Split64 | small_empty_uniform | 4 | insert | 4.0068× | 3.6996× |
| rust | Split64 | small_empty_uniform | 8 | allocate_insert | 4.1280× | 4.3045× |
| rust | Split64 | small_empty_uniform | 8 | insert | 5.2085× | 5.3611× |
| rust | Split64 | small_prefilled_hotspot | 4 | insert | 3.1373× | 2.8920× |
| rust | Split64 | small_prefilled_hotspot | 8 | insert | 3.8263× | 3.6509× |
| rust | Split64Range | small_empty_uniform | 4 | allocate_insert | 2.5401× | 2.3325× |
| rust | Split64Range | small_empty_uniform | 4 | insert | 3.3573× | 3.5890× |
| rust | Split64Range | small_empty_uniform | 8 | allocate_insert | 3.8874× | 3.4468× |
| rust | Split64Range | small_empty_uniform | 8 | insert | 4.3727× | 4.9750× |
| rust | Split64Range | small_prefilled_hotspot | 4 | insert | 3.2210× | 3.3180× |
| rust | Split64Range | small_prefilled_hotspot | 8 | insert | 4.0479× | 4.4887× |

## Unchanged-policy controls outside the gate

| Language | Family | Scenario | T | Contract | Seed74381 | Seed164321 |
|---|---|---|---:|---|---:|---:|
| cpp | Split64 | above_batch_empty_uniform | 4 | allocate_insert | 1.1336× | 1.0676× |
| cpp | Split64 | above_batch_empty_uniform | 4 | insert | 0.8196× | 0.9708× |
| cpp | Split64 | above_batch_empty_uniform | 8 | allocate_insert | 1.0397× | 0.9968× |
| cpp | Split64 | above_batch_empty_uniform | 8 | insert | 0.9780× | 0.9758× |
| cpp | Split64 | above_bytes_empty_uniform | 4 | allocate_insert | 1.2133× | 1.0914× |
| cpp | Split64 | above_bytes_empty_uniform | 4 | insert | 1.0438× | 1.0290× |
| cpp | Split64 | above_bytes_empty_uniform | 8 | allocate_insert | 0.9066× | 0.9751× |
| cpp | Split64 | above_bytes_empty_uniform | 8 | insert | 1.0095× | 1.0780× |
| cpp | Split64 | large_empty_uniform | 4 | allocate_insert | 1.0041× | 1.0053× |
| cpp | Split64 | large_empty_uniform | 4 | insert | 0.9071× | 1.0689× |
| cpp | Split64 | large_empty_uniform | 8 | allocate_insert | 1.0019× | 0.9969× |
| cpp | Split64 | large_empty_uniform | 8 | insert | 1.0137× | 0.9366× |
| cpp | Split64 | large_prefilled_hotspot | 4 | insert | 1.1707× | 0.9651× |
| cpp | Split64 | large_prefilled_hotspot | 8 | insert | 1.0340× | 0.9677× |
| cpp | Split64Range | above_batch_empty_uniform | 4 | allocate_insert | 1.2214× | 0.9976× |
| cpp | Split64Range | above_batch_empty_uniform | 4 | insert | 0.8722× | 1.0733× |
| cpp | Split64Range | above_batch_empty_uniform | 8 | allocate_insert | 1.0184× | 1.0120× |
| cpp | Split64Range | above_batch_empty_uniform | 8 | insert | 1.0147× | 0.9915× |
| cpp | Split64Range | above_bytes_empty_uniform | 4 | allocate_insert | 1.0204× | 0.9481× |
| cpp | Split64Range | above_bytes_empty_uniform | 4 | insert | 0.9770× | 0.8655× |
| cpp | Split64Range | above_bytes_empty_uniform | 8 | allocate_insert | 1.0048× | 1.1501× |
| cpp | Split64Range | above_bytes_empty_uniform | 8 | insert | 0.9357× | 0.9787× |
| cpp | Split64Range | large_empty_uniform | 4 | allocate_insert | 1.0004× | 1.0055× |
| cpp | Split64Range | large_empty_uniform | 4 | insert | 1.0210× | 0.9122× |
| cpp | Split64Range | large_empty_uniform | 8 | allocate_insert | 1.0028× | 1.0028× |
| cpp | Split64Range | large_empty_uniform | 8 | insert | 1.0293× | 0.9864× |
| cpp | Split64Range | large_prefilled_hotspot | 4 | insert | 1.1066× | 0.9859× |
| cpp | Split64Range | large_prefilled_hotspot | 8 | insert | 0.9872× | 0.9807× |
| rust | Split64 | above_batch_empty_uniform | 4 | allocate_insert | 0.8781× | 0.9704× |
| rust | Split64 | above_batch_empty_uniform | 4 | insert | 0.9230× | 0.9852× |
| rust | Split64 | above_batch_empty_uniform | 8 | allocate_insert | 0.9870× | 0.8805× |
| rust | Split64 | above_batch_empty_uniform | 8 | insert | 1.0476× | 0.9201× |
| rust | Split64 | above_bytes_empty_uniform | 4 | allocate_insert | 0.9012× | 1.0304× |
| rust | Split64 | above_bytes_empty_uniform | 4 | insert | 1.0888× | 1.0323× |
| rust | Split64 | above_bytes_empty_uniform | 8 | allocate_insert | 1.0325× | 1.0019× |
| rust | Split64 | above_bytes_empty_uniform | 8 | insert | 1.1260× | 0.8761× |
| rust | Split64 | large_empty_uniform | 4 | allocate_insert | 1.0072× | 1.0016× |
| rust | Split64 | large_empty_uniform | 4 | insert | 0.8905× | 1.0290× |
| rust | Split64 | large_empty_uniform | 8 | allocate_insert | 0.9913× | 1.0042× |
| rust | Split64 | large_empty_uniform | 8 | insert | 0.9806× | 0.9997× |
| rust | Split64 | large_prefilled_hotspot | 4 | insert | 0.9220× | 1.1257× |
| rust | Split64 | large_prefilled_hotspot | 8 | insert | 0.9335× | 0.9765× |
| rust | Split64Range | above_batch_empty_uniform | 4 | allocate_insert | 0.9584× | 0.9821× |
| rust | Split64Range | above_batch_empty_uniform | 4 | insert | 0.9944× | 0.9722× |
| rust | Split64Range | above_batch_empty_uniform | 8 | allocate_insert | 1.1146× | 0.9322× |
| rust | Split64Range | above_batch_empty_uniform | 8 | insert | 1.0698× | 1.0114× |
| rust | Split64Range | above_bytes_empty_uniform | 4 | allocate_insert | 1.0557× | 1.0226× |
| rust | Split64Range | above_bytes_empty_uniform | 4 | insert | 0.9233× | 1.0058× |
| rust | Split64Range | above_bytes_empty_uniform | 8 | allocate_insert | 1.0376× | 0.9467× |
| rust | Split64Range | above_bytes_empty_uniform | 8 | insert | 0.9830× | 0.9229× |
| rust | Split64Range | large_empty_uniform | 4 | allocate_insert | 0.9979× | 1.0003× |
| rust | Split64Range | large_empty_uniform | 4 | insert | 1.0134× | 0.9583× |
| rust | Split64Range | large_empty_uniform | 8 | allocate_insert | 0.9929× | 0.9955× |
| rust | Split64Range | large_empty_uniform | 8 | insert | 0.9966× | 1.0020× |
| rust | Split64Range | large_prefilled_hotspot | 4 | insert | 0.9777× | 1.1004× |
| rust | Split64Range | large_prefilled_hotspot | 8 | insert | 1.0077× | 1.0766× |

## Interpretation boundary

This archive does not automatically promote a policy. Inside-gate benefit and all outside-gate regressions must be considered together, including direct-serial overhead. Outside-gate calls retain the same worker request and partition algorithm, but the actual public entrypoint now contains a gate and can change code generation. Any repeated slowdown remains a measured cost requiring review; equal worker counts are not evidence of equal speed. No threshold or extra case is chosen from these results.

Only Split64 and Split64Range were tested. Integration must leave Four/Byte shared helpers and every query request unchanged, use current insertion length rather than constructor realN, keep build-worker/scratch getters consistent, and preserve each language's automatic0 behavior outside the gate. This archive compares the actual native before/after entrypoints; any default integration decision must retain all boundary regressions and this seen-seed scope.

Raw commit `df0d132515d63f141d5de2b47dbabfcf0f7fb845`; timed source `c9be15418ae8268b26d8fb36e90f2095500cc77d`. Complete196-file raw/source audit precedes analysis. No additional compiler or Bloom run occurred.
