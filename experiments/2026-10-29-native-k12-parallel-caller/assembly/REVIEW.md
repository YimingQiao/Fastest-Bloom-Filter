# Actual native caller and timer review

This review uses only the captured normal binaries: query SHA256 `51c190beb2cdf6ae42fcaa6e040c0e3c3ad13a60d61396b4decea7c0bb5e761f` and public API SHA256 `993e152c3919bc12c47dd82cdcc85e7233cf8c26b5e8d5c4ad635e10deb17e38`. `capture.json` records the two objdump commands, tool identity and binary hashes. `extract.py` verifies and retains 18 nonempty excerpts from those captures. No additional compiler or BF execution was used.

For actual public construction, the allocation start, post-constructor clock, real `InsertParallel` call and final clock are respectively:

| Family | Allocation start | Ready clock | Public insertion call | End clock |
|---|---:|---:|---:|---:|
| Split64 | `ba50` | `ba69` | `ba83` → `14ad0` | `ba92` |
| Range | `e730` | `e777` | `e796` → `1a210` | `e7a3` |
| K12 | `112b0` | `112f7` | `11316` → `1dc10` | `11323` |

The runtime requested worker value is passed to the actual native member call inside these intervals. Constructor overflow/geometry checks also remain charged in allocation-plus-insertion. The outer caller does not replace the native partition or ownership algorithm with a benchmark policy.

Public `LookupParallel` is naturally inlined through its worker-count calculation, then invokes its actual native `parallel_detail::For` specialization. Both generated pair positions are retained. Split windows are `beef` → call `bf60` → `bf65` and `c0bf` → call `c138` → `c13d`. Range uses `ec05` → `ec79` → `ec7e` and `edd9` → `ee55` → `ee5a`. K12 uses `11795` → `11809` → `11813` and `11979` → `119f5` → `119fe`. The requested T1/T8 choice precedes each start clock, while the native effective-worker logic, per-call thread creation, native query work and joins are inside it. The retained native query bodies contain their real `std::thread` starts and joins. Output checking and sample storage follow the stop clock.

For the common executor, the Range lookup wrapper at `464c8` tail-jumps to actual public `Lookup` at `47c30`; the K12 wrapper at `4dc10` tail-jumps to actual public `Lookup` at `4fa70`. The typed worker bodies at `48850` and `51260` contain the same common hash multiplier `d6e8feb86659fd93`, scalar/vector hash operations and the corresponding wrapper call. Hashing is therefore charged in the hash branch of the timed worker, while pure query uses the supplied prepared hashes. These are compiler-generated native hash implementations, not a claim of identical instruction scheduling across types.

The Range executor's four clocks are `48047`, `48333`, `483e8`, `484d4`; the K12 executor's are `50a57`, `50d43`, `50df8`, `50ee4`. Worker-zero calls lie inside the gated interval and joins occur before the final end-to-end clock. The unchanged executor's ready/start/done synchronization and the bounded cancellation tests separately establish the worker completion contract. Both pure and hash phases use the same typed executor and lookup kernel; full output validation follows the returned timing record.

The manual boundary gate passes. This evidence establishes the actual APIs and charged work, not speed. Track B still has the disclosed Range/K12 reference-bitmap copy and an eight-core allowed mask instead of Track A's individual worker pinning. No cross-track normalization, per-key latency claim or performance ranking is inferred.
