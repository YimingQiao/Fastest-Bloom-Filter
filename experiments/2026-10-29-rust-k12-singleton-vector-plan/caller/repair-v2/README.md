# V2: structured workspace-relative dep-info, native binaries reused

V1 source1f409288 compiled both native library-test executables and the caller,
then rejected dep-info before any test or filter ran. Failure archive4f7e558
retains26 exact artifacts, six actual dependency files, the Cargo package/target
metadata and all three executable hashes. Original V1 remains incomplete.

The actual dependency RHS contains `control/src/lib.rs` and
`candidate/src/lib.rs`. Those names are relative to Cargo's explicit
`workspace_root`, while the original collector assumed the member manifest
directory. The selected artifact/package/target identity was already correct.

The isolated collector adds the verified workspace root to that identity. It
admits only the member manifest directory or the structured workspace root,
and accepts a base only when joining the dependency tokens yields the exact
structured `target.src_path`. Zero or multiple matches reject. No test of file
existence chooses a base. The usual exact dep-info LHS, frozen source hashes,
normalized target names and nightly actual/final executable equality remain.
Six synthetic cases cover workspace-relative, member-relative, shared-root,
absent, ambiguous and wrong-workspace inputs. Offline collection recovered all
30 native input files and six rules, without compiler or filter execution.

The continuation imports the unchanged public caller, kernel and test sources
from1f409288. Native metadata/build output and all three executables are reused,
with their original command and environment records preserved. It does not
rerun native Cargo metadata or compilation. Native tests/cases have never run
and remain pending; portable, disabled and ASan profiles likewise remain fully
pending. Their original compiler flags, finite workload and output/ASM checks
are unchanged. No formal measurement or calibration is added.

Only new target `/tmp/fastest-bf-rust-k12-simd-caller-v2-cpu3` and new output
`repair-v2/validation-v1/` may be created. The reused native target remains at
its V1 path. Every actual dep-info/input/tool/executable and both committed
source archives are checked before execution; failures are retained.

After exact source review/commit and an explicit continuation lease:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 \
  python3 experiments/2026-10-29-rust-k12-singleton-vector-plan/caller/repair-v2/validate.py \
  --source-commit FULL_V2_COMMIT
```

The pending total remains16 focused test executions,96 tiny public rows,
24 invalid CLI cases and eight output faults across twelve binaries. Three
binaries are already compiled and unchanged. Manual native/portable ELF
address/size and public-call-boundary review is still mandatory after capture.
