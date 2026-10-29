# Optional native C++ K12 integration

This source-only preparation packages the frozen K12 kernel at `e150be33b95a22dca9b75175e6174b9555c82393` into a separate worktree based on accepted native Range commit `81f40f16caa44586537d577f998c33fec4c22be8`. It does not bring the unpromoted Split64 bounded-worker policy into the integration.

`derive.py` reverses every serial-header edit and asserts exact original bytes: class names, sizing include, removal of the old generic parallel friendship and addition of the dedicated wrapper friendship. No insertion/query expression changes. The dedicated wrapper computes ownership from K12's actual top24 physical cache line, with floor ownership and ceil interval boundaries. The generic power-of-two wrapper intentionally cannot access this layout's private geometry.

The bounded correctness run builds the new CMake targets in native, AVX2, portable and native ASan/UBSan profiles. Compilers run on CPU2; test processes explicitly expand affinity to seven socket0 physical cores, `2,4,6,8,10,12,14`. This permits real T3/T7 execution without claiming individual worker pinning. Tests cover independent per-bit/full-bitmap output, required missing probe bits, physical partition boundaries, non-power-of-two capacities, distinct streamed batches, duplicates, full outputs/tails/guards and overflow. A separate tiny translation unit must fail when the unsafe old generic parallel wrapper requests K12 geometry. No performance comparison or new quality claim is made.

Run only under the authorized whole-operation lease, with fresh output/build paths and exact committed source hashes:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 experiments/2026-10-29-native-k12-cpp/validate.py --source-commit SOURCE_COMMIT --native-commit NATIVE_COMMIT --output /home/yiming/projects/fastest-bf-lab/experiments/2026-10-29-native-k12-cpp/validation-v1 --build /home/yiming/projects/fastest-bf-lab/build/native-k12-integration-v1
```

Compiler input files, actual commands, CMake flags, backend macro proofs, test output, topology and binary hashes are recorded. Failed attempts are retained, and subsequent corrections require new records. Executables are hashed in place rather than committed.
