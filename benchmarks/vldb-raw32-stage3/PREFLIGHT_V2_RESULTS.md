# Stage3 v2 worker preflight — passed

The 158 native worker cases, 48 ASan/UBSan worker cases, and 18 representative
large-allocation accounting rows all passed. No throughput trial or statistical
FPR qualification was run. Build elapsed seconds in the logs are diagnostics,
not Bloom-filter performance.

V1 compiled the legacy worker, then rejected the modern worker's invalid
PageBloom boolean conversion. Its source and failure evidence remain sealed.
V2 changes only that constructor check to `data()!=nullptr`, reuses the native
legacy binary exactly, and preserves every measured query/build/timer body.
The proof source commit is `a8633e9bc230e2bca3d852f4c7783d8d1e0ee2bd`.

Every inserted key, dense output, guard, singleton/batch/alias equality, input
stream checksum, small tail/offset, and long batch boundary passed. The exact
public U/address/size metadata and raw4-byte Page contract are retained. All
correctness timing columns/trials are NaN. Fresh-process tuner fingerprints and
all before/after source/binary/input checks passed. The proof checks 76 unique
small-fixture API/stream identities; duplicate APIs are checked, not pooled.

Actual native dependencies show complete separate Boost1.83 and Boost1.92
contexts (510 inputs for legacy, 526 for modern). The combined five-binary proof
records 640 distinct consumed compiler inputs. Original archives were not
rebuilt. Typed query assembly is retained for32 legacy and23 modern functions.
RocksDB K8 Batch32's singleton branch retains a stack answer and an out-of-line
adapter `Lookup(1)` call. The K8 direct same-layout alias is also in the fixed
panel and inlines the public path. Rankings must retain both and use the fastest
eligible API shape, rather than claim Batch32 represents its best singleton.

The following are **new actual accounting observations**, reproduced across the
three original layout families. The fixed geometry is n=2^25; the correctness
fixture inserts65536 keys and queries4096. These are64/96MiB allocations, not a
full2^25-key memory-load or128MiB accounting measurement.

| Public surface | POW2 bitmap | MAGIC bitmap | Control heap POW2 / MAGIC | Public facade object POW2 / MAGIC |
|---|---:|---:|---:|---:|
| PImpl | 67108864 B | 100663296 B | 284 / 296 B | 48 / 48 B |
| Dynamic | 67108864 B | 100663296 B | 108 / 120 B | 216 / 216 B |
| Static | 67108864 B | 100663296 B | 0 / 0 B | 40 / 48 B |

PImpl shared setup retains39217 requested C++ heap bytes and incurs194575 bytes
of setup allocation traffic in each fresh process. Its configuration-metadata
check allocates346/353 bytes of temporary traffic for POW2/MAGIC. Every surface
reports zero API heap allocation and zero API mmap, exact16384-byte requested
position scratch, and complete release of owned control/bitmap allocations.
These counters cover requested C++ heap and wrapped mmap; they do not claim
allocator usable bytes, RSS, libc-internal allocations, or the benchmark
facade's metadata storage. The128MiB point has only the earlier Stage2
geometry/backing proof. No4096-byte fixture measurements were substituted.

`WORKER_FREEZE.json` seals642 proof artifacts,640 consumed inputs and5 binaries.
`screen-v2/` adds only exact retry-source/proof provenance guards to the unchanged
728-row runner. Its two offline negative tests pass. The successful proof,
freeze, and that guard must be reviewed and committed before a separate timing
lease. Two executables remain separate paired API/context observations: both
native controls and individual timings must be retained, with no context-shift
normalization and no duplicate calibration pooling.
