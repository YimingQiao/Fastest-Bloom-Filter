# Compiler-driver repair, no filter change

The first preflight at `dd13d1e829d4482d70093497b8d470bd09be22ac` failed while linking the normal caller. The object compiled, but the driver used `Path('/usr/bin/clang++').resolve()` as its invocation name. On this installation that resolves to `clang`; calling it by that name does not add the C++ runtime at link time. The preserved linker errors are undefined standard-library/exception symbols. No filter executable or correctness workload ran in the failed attempt.

This additive V2 preserves the `/usr/bin/clang++` invocation spelling and records its resolved target separately for hashing. All C++ sources, compiler flags, three profiles, checker cases, tiny caller inputs and ASM capture are unchanged. New build and output paths preserve V1. `derive.py` proves the exact driver delta in `DRIVER.patch`; `repair_guard.py` binds every original source at the original commit, every failure artifact and the new committed repair. This is a tool invocation repair, not an algorithm or performance variant.

After review and commit, use the same granted whole-socket lease with `preflight-v2/validate.py --source-commit FULL_V2_COMMIT --cpu 3 --execute-correctness`. No formal performance is enabled.
