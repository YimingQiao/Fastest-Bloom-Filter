# All-eight-API accuracy resolution

All eight APIs pass the0.1% upper-endpoint gate on all six constructions using the fixed fresh suffix. The original calibration observations and144-row confirmation policy remain unchanged. This is an accuracy audit, with no new throughput claim.

Each API/seed first reproduced its original2^24-negative prefix exactly, then ran a fixed2^27 total. Subtracting the prefix gives117,440,512 fresh disjoint negatives. The48 API/seed results are36 distinct mapping/seed samples; aliases, seeds and old prefixes are never pooled. The two-sided95% Wilson bounds are pointwise, not simultaneous guarantees.

| API | Fresh suffix passes | Worst upper FPR (%) |
|---|---:|---:|
| MultiplyCodeSplit64RangeExperiment | 6/6 | 0.09254374 |
| Split64BloomFilter | 6/6 | 0.09459338 |
| Split64RangeExperiment | 6/6 | 0.09305616 |
| FourSectorBloomFilter | 6/6 | 0.09952591 |
| FastFilterFixed64 | 6/6 | 0.09305616 |
| Boost192Multi64K8 | 6/6 | 0.09385552 |
| RocksDBFastLocalBloom64K8 | 6/6 | 0.09272053 |
| RocksDBFastLocalBloom64K8Batch32 | 6/6 | 0.09272053 |

## The borderline FourSector construction

The seed1262581121544068856 originally had16,803 positives in16,777,216 negatives, with a0.10167873% upper endpoint. The new disjoint suffix has116,214 positives in117,440,512 negatives: estimate0.09895563%, interval0.09838861%–0.09952591%. It passes the new gate. The other five constructions also pass. This does not erase the earlier inconclusive interval or prove a universal bound over constructions.

## Separate interpretation of the original timings

The following is a new quality-conditioned reading of the already archived144 timings, not a rerun or a rewrite of their prespecified gate. With all eight APIs now passing on every fresh suffix, Multiply loses all36 comparisons against the fastest rival at the same16-bpk ceiling. Its bulk gain versus Split64 remains real within that comparison, but does not beat FourSector. No promotion follows.

Ratios are fastest rival latency / Multiply latency; below1 means Multiply is slower. Geometric means and ranges cover the same six constructions.

| Batch | Contract | Fastest rival | Ratio GM | Range | Multiply W/L |
|---:|---|---|---:|---:|---:|
| 1 | lookup_ns | Split64BloomFilter | 0.8410 | 0.8375–0.8445 | 0/6 |
| 1 | hash_lookup_ns | Split64BloomFilter | 0.8927 | 0.8902–0.8955 | 0/6 |
| 31 | lookup_ns | FourSectorBloomFilter | 0.8784 | 0.8692–0.8838 | 0/6 |
| 31 | hash_lookup_ns | FourSectorBloomFilter | 0.9419 | 0.9380–0.9474 | 0/6 |
| 4096 | lookup_ns | FourSectorBloomFilter | 0.6928 | 0.6863–0.6976 | 0/6 |
| 4096 | hash_lookup_ns | FourSectorBloomFilter | 0.7539 | 0.7490–0.7566 | 0/6 |

The original confirmation used six seeds selected only for candidate-relative execution-order balance; it is not an unconditional random-seed sample. This reinterpretation covers65,536 keys,50% hits,batches1/31/4096 and the eight fixed APIs. It does not establish behavior for larger filters, other hit rates, builds or Rust.

## Evidence

[Raw metadata](results/metadata.json) retains all12 commands, stdout/stderr hashes and the exact CPU2/socket0 inherited exclusive lease. Every prefix checksum, complete geometry, source-derived API order and all321 inherited inputs/39 binaries verified. The run used source commit`e6ac12cebff4a94205bc52b737900a3ccee2b066` and the unchanged frozen76 binary. CPU affinity only was applied, without explicit NUMA memory binding.

[Quality records](results/quality.json) retain all48 individual old/new intervals. [Verification](VERIFICATION.json) independently checks96 raw rows and records every timing ratio used above; the original timing CSV hash is pinned there. [The original fixed144 report](../2026-10-29-multiply-code-small-confirmation-analysis/report-final/REPORT.md) remains immutable.

The pre-execution driver peer review found no blocker; four synthetic tests cover suffix-only subtraction, historical drift, invalid totals and alias equality. No algorithm or compiled source changed.
