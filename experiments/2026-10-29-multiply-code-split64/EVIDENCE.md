# Pre-accuracy validation

All six prescribed correctness configurations passed on CPU3 under one inherited socket1 flock. No candidate calibration or throughput measurement has run. The fixed multiplier and masks were unchanged between source review, compilation and these checks.

The command was:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 python3 experiments/2026-10-29-multiply-code-split64/validate.py --cpu 3
```

`validation/commands.json` retains all 21 compiler/configuration/check/guard/ASM/version command results and diagnostic elapsed durations. The durations describe validation overhead only, not filter speed. Native AVX512F, AVX2-only and scalar each passed both normal and ASan/UBSan checks, with identical full bitmap/output digests:

```text
16070742669251686098 16614519311275667143 1626430457292778148
```

The checks cover the unchanged Split64Range, pinned cyclic mapping and new multiply-code mapping. Mask checks include all 65,536 low16 values plus 16,384 full32 random values, high32 independence, and independent u128 multiplication/bit extraction. Full bitmaps use arbitrary line counts, range boundaries, duplicate and concentrated writes, all inserted-key no-false-negative checks, essential-sector-bit removals, output guards and tail lengths0..131 plus4096/4097/4127. All six backends produce the same oracle digest. No broad FPR claim follows from these correctness inputs.

The compiler was Debian Clang23.0.0 (cc613052fd6a). The six builds produced12 pinned binaries; the native accuracy executable SHA256 is `a25a9d1abbf7f4fcab8511d63fba440a625a3d3b582403ebda110a762850fcf4`. `validation/summary.json` records exact compiled source and binary hashes and the inherited lock descriptor. The six retained `*-compile_commands.json` files record selected backend and sanitizer flags. No C++ source changed after those checks.

The native candidate query body in the retained complete objdump contains the intended mask sequence at0x6b62: scalar `imul`, `vpbroadcastq`, `vpsrlvq`, `vprolvq`, followed by the bitmap test. A short extract is in `validation/candidate-query-snippet.asm`. The independent high32 line reduction has its own multiply. Compiler unrolling, constant materialization, load scheduling and the extra scalar multiply still affect runtime; this is codegen evidence, not speed evidence.

Six synthetic offline quality guards passed before any candidate calibration. Their initial log contained Python unclosed-reference-file ResourceWarnings; context managers were then added only to the Python reference readers and the six guards rerun with ResourceWarnings treated as errors. Both logs remain. The candidate fixture is explicitly synthetic: it copies an old control count and changes the name, never a measured candidate result.

`PREPARATION.json` preserves the original source-only proposal hashes. Final protocol metadata updates the completed correctness lease and accuracy CPU3; workload, capacities, seed, fixed multiplier and24-row contract remain fixed. Final source/binary hashes and all local evidence are covered by `FREEZE.json` and `manifest.json` after peer review. Accuracy must use the reviewed committed freeze, reproduce all16 old control rows exactly, and retain all8 new quality records without tuning or pooling.
