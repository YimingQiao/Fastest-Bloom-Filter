# Both fixed FourSector16 constructions pass the new disjoint quality sample

The fresh Wilson95 upper FPR endpoints are **0.099056% and0.098160%**, both
below0.1%. The earlier failed endpoints reflected insufficient evidence to
qualify those samples; they did not prove that the true FPR exceeded0.1%.
Keep FourSector's stronger speed results visible when assessing Multiply.

The four prescribed public-harness runs completed from the unchanged binary
`cc316deee30c6738bdd8a2bbfec5a7d2c2be020397fc888dbaa0bc0e7a1a6615`,
source `9e4362f1068d37d134ef8447a44146b52c1edc9f`. The accuracy protocol and
runner were committed before execution at
`17f37f8b55baabb1d741d72d872f6b6e5074fc87`. CPU3/socket1 was held under an
inherited exclusive flock; only CPU affinity was applied, with no explicit
NUMA memory binding. No reported latency is used or ranked.

Both runs retain seed7562001474399208876, actual16 bits/key, q=2^22,
50% hits, batch4096 and the same complete inserted set. The old calibration
prefix counts, complete mixed-output checksums and actual geometry reproduce
exactly. All inserted keys and every dense output are checked by the public
harness. Source/dependency/binary hashes passed before and after every case.

| Inserted keys | Bitmap bytes | Old FP /2^24 | Old upper FPR | Nested total FP /2^27 | New suffix FP /117,440,512 | New point FPR | New upper FPR |
|---:|---:|---:|---:|---:|---:|---:|---:|
|65,536|131,072|16,542|0.100111%|132,206|115,664|0.098487%|0.099056%|
|33,554,432|67,108,864|16,569|0.100273%|131,183|114,614|0.097593%|0.098160%|

Only the new suffix is used for the new pointwise two-sided95% Wilson
interval. Its negatives follow the reproduced old prefix and are disjoint from
that prefix, the inserted keys and timed queries. The total134,217,728 count
is nested evidence, not an additional independent sample. No outcomes were
used to extend the fixed endpoint, pick another seed or repeat a failed case.

This qualifies the two particular constructions on a larger new sample. It
does not erase the original failed qualification or guarantee0.1% for every
input. The already fixed144-row Multiply confirmation retains its prescribed
FourSector diagnostic exclusion in the restricted table. That table must be
read alongside these results and its separate current-eligibility comparison;
it cannot establish an overall win by ignoring the newly qualifying FourSector
evidence.

All raw stdout/stderr and exact commands are in [results](results/metadata.json).
The raw archive binds nine files. [VERIFICATION.json](VERIFICATION.json)
records independent raw-hash, subtraction and Wilson-interval recomputation.
