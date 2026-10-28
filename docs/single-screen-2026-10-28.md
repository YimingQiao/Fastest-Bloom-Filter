# Single-key external screening — 2026-10-28

This is a new exploratory screen, not held-out confirmation of a single-key win.
It runs all **47 configurations** in the frozen unified executable: the original
43 plus the two wider dictionaries, FourSector and Split64. Four cases × 47 yield
188 rows. All candidates use the same compiler, input, CPU, shuffled order and
validation. These queries call the shared batch API with a batch size of one.

Xeon Platinum 8474C CPU 2; Clang 23 native; seed 42; 2^20 timed queries; 50% hits;
three timing repetitions; whole-input construction; and separate 2^24-negative
calibration probes. The largest bitmap is 128MiB, but the smaller timed query
working set can reuse LLC; allocation size alone does not establish cold-cache
single-key latency. Values below are median hash+query ns/key, a throughput metric.

The upper-FPR-bound and resident-allocation rules are the same as the large-batch
comparison. Memory ceilings use zero byte slack. Single-key performance changes
the ranking: external FastFilter variants win the 1% and 0.01% bands shown below.
Our Split64 wins the 0.1% band at 16 bits/key, but this one-seed screen still requires
confirmation. No large-batch victory is presented as a single-key victory.

| Keys | Memory ceiling, bits/key | FPR ceiling | Screening leader | ns/key | Our fastest eligible candidate | ns/key |
| --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 | 1.00% | FastFilterFixed16 | 4.285 | Split64P32 | 4.700 |
| 33,554,432 | 16 | 1.00% | FastFilterSimdBlock | 9.882 | Split64P32 | 10.140 |
| 65,536 | 16 | 0.10% | Split64P32 | 4.700 | Split64P32 | 4.700 |
| 33,554,432 | 16 | 0.10% | Split64P32 | 10.140 | Split64P32 | 10.140 |
| 65,536 | 32 | 0.01% | FastFilterSimdBlock | 4.459 | Split64P32 | 4.739 |
| 33,554,432 | 32 | 0.01% | FastFilterSimdBlock | 10.437 | Split64P32 | 10.723 |

The smaller sample is shown at 16 bits/key for the 0.1% target to make the resource
contract explicit. Allowing 32 bits/key makes FastFilterFixed16 (4.331 ns/key) the
65K-key leader for that target; it uses the extra memory to meet the accuracy cap.
Exact bytes, FPR counts, pointwise 95% bounds and all ranks are retained in the CSV.

Next optimization targets are the scalar/dispatch cost for one-key native queries
and short-batch memory-level parallelism. Any new kernel must preserve full output
parity and receive a separately recorded confirmation before claiming an improvement.

[Raw data/provenance](../results/2026-10-28-single-screen/),
[16-bit ranking](../results/2026-10-28-single-screen/ranking-16.csv),
[32-bit ranking](../results/2026-10-28-single-screen/ranking-32.csv),
[large-batch confirmation](modern-confirmation-2026-10-28.md).
