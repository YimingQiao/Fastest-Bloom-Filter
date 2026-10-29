# Scalar range probe pilot correctness

Committed source `685782fa446deda8129c0bfb09fce8bdc069cfb9` passed the first
optimized and ASan/UBSan attempts: 56 fixtures, 30,688 full offset/tail checks,
all inserted keys, complete independent bitmaps, and all 14 old-K8 bitmap replays.
The fixed calibration executable was compiled but has not run at this stage.

The seven compiler/build/check commands exited zero. Three binary hashes and
all actual compiler dependencies are recorded in validation-v1/metadata.json;
validation-v1/archive.json seals the original evidence. The entire operation
held the CPU2/socket0 lock, with the caller pinned to CPU2. No throughput was
measured and no mask, gate, sample size, or dictionary changed.
