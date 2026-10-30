# K12 vector correctness

The first attempt from `aac72c2adb450ce491368932de20e8e0d28308e5` passes native
AVX-512, AVX2-only and scalar, each optimized and ASan/UBSan. All 42 fixtures
match the independent bit-position oracle and the already calibrated scalar-K12
full bitmap. Every inserted key, incremental/colliding insertion, all 23,016
offset/tail cases, null/zero lookup, invalid-size checks and input guards pass.

Six backend outputs are identical. Source hashes, actual compiler dependencies,
command logs and all six local executable hashes are recorded in
[validation-v1/metadata.json](validation-v1/metadata.json). The entire run held
the CPU2/socket0 lock and has released it. No throughput or new accuracy
calibration was run, and no production API was changed.

The AVX2 path's extra table-selection work remains a performance question.
Matching the scalar mapping preserves the fixed pilot's observed K12 counts;
that one-seed result still requires fresh-seed confirmation before promotion.
