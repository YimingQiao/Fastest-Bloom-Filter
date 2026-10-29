# V1 preserved compile-closure failure

Source e0f44536beb147a4c8d1befd219715379b65009a ran 11 commands, all subprocesses exited0, then the dependency guard rejected the actual base.h path. No Rust build, Bloom test, insertion, query, FPR or performance execution occurred. Original metadata remains complete=false and is not rewritten.

The fixture compile used -I ROOT/include, while the exact old caller closure contains experiments/2026-10-29-split64-range-parallel-screen/snapshot/include/base.h. The two files are byte-identical, SHA256 c65e97e851c5381fba74fe035fe2022e21d764367ba412ac1be7295cf9bf75a0; every other actual dependency already matches the frozen closure. The complete actual depfile and all command output are preserved.

V2 will change only that include-root binding, assert the exact consumed base.h path, and use fresh build/output trees. Kernel and fixture sources are unchanged. No failed Bloom result is being retried.
