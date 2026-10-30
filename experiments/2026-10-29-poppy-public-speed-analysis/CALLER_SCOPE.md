# Exact workspace and validation scope of the frozen Poppy caller

This note supplements the completed analysis at `13846756061ab78cbc8d9aa36b1983f6ecf38f08`; no measured row, calculation, leader or ratio changes.

The caller allocates and zeroes `Aligned(max(batch, insert_batch))` hash workspace before every clock, and retains it across the row's construction and query phases. Whole-input insertion sets `insert_batch = n`, so this workspace is **n × 8 bytes: 512 KiB at n=2^16 and 256 MiB at n=2^25**. It is separate from the charged filter bitmap/cache allocation and is resident during the timed work.

`allocate_hash_insert_ns` includes filter construction, project-hash computation and insertion. It excludes allocation/zeroing of this caller workspace. The four emitted construction contracts remain valid as named; they are not the newer Raw8 caller's full build, which explicitly includes required caller hash-scratch allocation. No subtraction or conversion equates these different lifecycles.

Every construction inserts the complete input. The outside-clock inserted-key check covers all n inserted keys on trial0 of each construction mode; later repetitions check `min(n, batch)` inserted keys. The canonical filter subsequently receives complete inserted-key validation. This is not full-n false-negative validation after every timed repetition. Query outputs are independently checked in full outside every query timer.

These details qualify the observed public caller and its working set. They do not justify a data rerun, a different quality denominator or a wider performance claim.
