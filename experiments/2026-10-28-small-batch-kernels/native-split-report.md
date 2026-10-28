# Production Split64 short-query confirmation

The conservative candidate improves short query batches while retaining the
original insertion path and masks for single queries and batches of at least 16.
The candidate is [native_split_after.h](native_split_after.h), SHA-256
`7769c0fa82453e6d57421dde6d16d9d4a1d4eb788dc24ec194ead5ec2b77f3e2`.
The actual production before snapshot is [native_split_before.h](native_split_before.h).
Class names are changed so all controls run in the same executable.

`Lookup` returns directly through the original `LookupOne` for one key. On
AVX-512, batches 2–15 use the zero-extended salt representation: 32-bit products
in each 64-bit lane have zero high halves, so a 64-bit shift produces the same
positions without an explicit widening instruction. Zero-length lookup returns
without touching the pointers. Larger batches use the existing prefetch loop.
The constructor, allocation, bitmap, insertion, AVX2 mask kernel, and scalar mask
formula are unchanged.

## Exact validation

[check_native_split.cpp](check_native_split.cpp) compares every bitmap word after
insertion, complete query outputs, output guards, and absence of query mutations
for the before, single-only, and final candidates. Coverage includes capacity
0/1024/65539/1048576, requested 4/8/16 bits/key, uniform and same-line inputs,
lengths 0–145, and input offsets 0–7. All three configurations in
[native-split-validation.json](native-split-validation.json) pass with checksum
`11781676180046210976`:

- GCC baseline x86-64, AVX/AVX2/AVX-512 disabled.
- GCC AVX2, AVX-512 disabled.
- Clang AVX-512F+AVX2 with ASan and UBSan.

All inserted keys are additionally checked by the shared performance harness.
Every one of the 24 final workloads has identical allocation, result checksum,
and false-positive count across the three variants. This is a bitmap-preserving
optimization, not an improvement in FPR. Only the native AVX-512 host was timed;
portable and AVX2 validation does not imply measured speed gains there.

## Final held-out timings

The [final CSV](native-confirmation/timing.csv) contains 72 rows: three candidates
for each combination of 65,536/16,777,216 keys; batches 1/4/8/15/31/4096; and new
seeds 12289/65537. Requested 8 bits/key allocates 16 actual bits/key, or 128 KiB
and 32 MiB respectively. All cases use 50% hits, 2^22 queries, five repetitions,
full-size construction batches, CPU 3, and shuffled same-process candidate order.
[Metadata](native-confirmation/metadata.json) records exact commands and hashes;
no source changed during the run.

Values are median candidate/before time ratios across the two seeds; lower is
faster. `Single` adds only the one-key return and retains the original mask
everywhere. `Final` also uses the wide mask for 2–15 keys.

| Keys | Batch | Single: prehashed | Single: hash + lookup | Final: prehashed | Final: hash + lookup |
| --- | --- | --- | --- | --- | --- |
| 65,536 | 1 | 0.925 | 0.945 | 0.925 | 0.945 |
| 65,536 | 4 | 1.030 | 0.959 | 0.985 | 0.942 |
| 65,536 | 8 | 1.019 | 0.953 | 0.979 | 0.891 |
| 65,536 | 15 | 1.008 | 1.003 | 0.955 | 0.971 |
| 65,536 | 31 | 0.997 | 1.001 | 0.997 | 1.002 |
| 65,536 | 4096 | 0.989 | 1.006 | 0.993 | 1.006 |
| 16,777,216 | 1 | 0.949 | 0.941 | 0.943 | 0.942 |
| 16,777,216 | 4 | 0.985 | 0.470 | 0.983 | 0.473 |
| 16,777,216 | 8 | 1.058 | 0.684 | 0.973 | 0.690 |
| 16,777,216 | 15 | 1.002 | 0.905 | 0.946 | 0.911 |
| 16,777,216 | 31 | 1.008 | 1.006 | 1.011 | 1.020 |
| 16,777,216 | 4096 | 1.007 | 0.999 | 1.004 | 1.000 |

The unchanged-mask control reproduces most of the dramatic large-bitmap gains
for hashing plus lookup at batches 4 and 8. Those gains therefore cannot be
credited solely to eliminating the widening intrinsic; compiler decisions in
the caller and dispatcher materially affect this benchmark. The wide mask adds
a more consistent improvement for prehashed batches 4/8/15 compared with that
control. Large-bitmap batch 31 has a measured 2% hashing-plus-lookup regression.
This is a measured tradeoff on this host, not a universal speed claim.

The unconditional wide candidate was screened earlier and rejected as the
default because its small-bitmap single queries regress. External FastFilter
controls are retained in those earlier stages; the final native confirmation
isolates the production code change and makes no new external leaderboard claim.

## Actual 32 bits/key confirmation

A further [72-row confirmation](native-confirmation-32bpk/timing.csv) repeats the
same workloads with requested 16 bits/key, which allocates 32 actual bits/key
(256 KiB/64 MiB). Source hashes stayed unchanged and all three variants again
match allocation, complete result checksum, and false-positive count. This checks
the budget used for stricter FPR comparisons without claiming any FPR change.

| Keys | Batch | Final: prehashed | Final: hash + lookup |
| --- | --- | --- | --- |
| 65,536 | 1 | 0.925 | 0.933 |
| 65,536 | 4 | 0.982 | 0.949 |
| 65,536 | 8 | 0.982 | 0.894 |
| 65,536 | 15 | 0.956 | 0.971 |
| 65,536 | 31 | 0.997 | 1.001 |
| 65,536 | 4096 | 0.991 | 1.005 |
| 16,777,216 | 1 | 0.969 | 0.936 |
| 16,777,216 | 4 | 0.982 | 0.460 |
| 16,777,216 | 8 | 0.969 | 0.712 |
| 16,777,216 | 15 | 0.944 | 0.942 |
| 16,777,216 | 31 | 1.013 | 1.016 |
| 16,777,216 | 4096 | 0.998 | 1.000 |

The single-only control again explains most of the dramatic hashing-plus-lookup
gains: its large-bitmap ratios are 0.463/0.716 at batches 4/8. The final hybrid
has a 1.6% hashing-plus-lookup regression at large-bitmap batch 31. Full per-seed
ratios for both controls are in
[native-split-confirmation-32bpk-summary.json](native-split-confirmation-32bpk-summary.json).

## Reproduction

Build the executable using the parent [README](README.md), then run into a new
output directory:

```sh
python3 experiments/2026-10-28-small-batch-kernels/run_speed.py \
  --output-dir build/native-split-confirmation-reproduction --cpu 3 \
  --key-powers 16,24 --requested-bpk 8 --hits 50 --seeds 12289,65537 \
  --batches 1,4,8,15,31,4096 --query-power 22 --repeats 5 \
  --filters NativeSplitBeforeBF,NativeSplitSingleBF,NativeSplitAfterBF
```

The exact scalar/AVX2/sanitizer compilation commands are recorded in the
validation JSON. For the second budget, change `--requested-bpk 8` to
`--requested-bpk 16` and select another new output directory. The applyable
production diff and Rust mapping are in [native-split-integration.md](native-split-integration.md).
A further possible variant broadcasts the entire 64-bit hash,
because each high 32-bit salt is zero; it is mathematically equivalent and may
remove a zero extension. It was not included in this frozen candidate and has
no measured speed claim here.
