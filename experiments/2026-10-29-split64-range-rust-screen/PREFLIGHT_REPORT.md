# Rust exact-capacity Range preflight

Correctness and allocation checks passed. No performance matrix has run in this archive. The original `protocol.json` and initial README remain historical source-only documents; `screening/protocol.json` is the later proposed 120-row timing protocol.

The initial 37-file package is committed at `d93d45c6cf09e8da687981fa77bb01b5fecbda70`; the additive preflight at `381238bba3cceae72d80bb2be59710021940d1c4`; the large allocation audit at `daceeb8c51fc322da9e3adb51153b3df82f3d553`. No original kernel, adapter, constructor, timer or validation source changed during these checks.

## Executed validation

`validation-v1/commands.json` records 69 successful commands, exact flags and toolchains. Normal, native AVX512-dispatch-disabled and Rust AddressSanitizer configurations each passed all 34 native library tests and 14 harness tests. The native tests explicitly force scalar paths; the disabled build still permits upstream SBBF's public AVX2 backend. These are runtime-dispatch tests, not a claim that every external algorithm supports a scalar ISA.

All three modes matched the 12 complete C++ Range bitmap/output fixtures. Each mode also emitted 72 current full-output fixtures and 42 retained old-seven-API fixtures, covering n=64/1024/65536 and current ceilings16/24/32. The 42 equal-allocation old/current comparisons checked 344,106 individual answers per mode, including every mixed and calibration output; actual bytes, input fingerprints, false positives and inserted-key checks matched. Native cap24 geometry correctly aliases actual16. This is correctness evidence with small query samples, not a quality qualification.

The optimized executable passed 27 small CLI cases / 216 rows, 126 retained old-seven semantic comparisons, all four phase/trial checks and eight malformed-argument rejections before CSV. Both primary crates passed Clippy. Small timing fields emitted during these correctness runs are unclaimed and must not be ranked.

`allocation-large/validation/metadata.json` records a separate 48-case, allocation-only execution across all eight public constructors, n=2^16/2^25 and cap16/24/32. Each case observed exactly one retained requested heap allocation, no temporary constructor frees, exact declared backing size and one matching free before the next case. No insertions, queries or clocks were involved. Fastbloom uses the real item count and its public hash-count check:11/17/22 at16/24/32. Allocation accounting describes requested bitmap backing; allocator usable-size, RSS and stack/object storage are separate.

All heavy checks held the inherited `/tmp/fastest-bf-socket1.lock` and CPU3 affinity. Affinity did not impose an explicit NUMA memory policy. Stable Rust was1.92.0 / LLVM21.1.3; the sanitizer nightly and every command are recorded verbatim.

## Actual public API code generation

The optimized benchmark SHA is `448ca811711c2ea29654208b18bc8d9f58ed876555f371aac147d787257a7a23`. Its flags were `-C target-cpu=native -C symbol-mangling-version=v0`, ThinLTO and one codegen unit. `validation-v1/assembly/` contains 16 distinct typed visible loops, symbols, relocations and the direct callee bodies.

Range's visible pure loop at0x1ea50 and fused common-hash loop at0x1eb10 each call the private `contains_scalar` at0x4d070 for every key. They save six registers and reserve72 stack bytes. The existing production Split64 visible loops also retain their scalar helper call. Range's public singleton API is the scalar-source path; native-target optimization emits qword multiplication, shifts and vector bit tests inside its helper. The line index uses high32×line_count followed by a32-bit shift; the lane-mask bits match the validated u32-wrapping semantics. No additional inline hint or private adapter shortcut was introduced.

The generic noinline Range wrapper at0x20e50 tail-jumps through GOT0x9e4e8; the relocation resolves to public `lookup_hashes` at0x591a0. That body retains runtime AVX512/AVX2/scalar dispatch, its singleton branch, widened-u32-product short path and large-batch prefetch. Cold assertion/bounds relocations resolve separately to panic handlers. Per-key helper calls and generic dispatch remain part of the measured public contracts. These observations predict no speed outcome.

## Dependency descriptor provenance

The original preflight read the prior singleton freeze's dependency list live without separately pinning the descriptor file itself. An additive retrospective check now proves that the live descriptor equals the committed blob at `aad7dda8b473be5020b34505cf3faad2bda9fc02`, SHA `6973e9b25e5983635aabf394126f6368e1bd616321649b7db671d3558e9e98a1`. The saved preflight list exactly matches those11 committed dependency sets; all251 actual dependency files and the initial committed Cargo.lock agree. See `validation-v1/descriptor-check.json` and its unchanged descriptor copy. No compilation rerun was needed. The later timing freeze explicitly binds this descriptor path, revision, SHA and literal dependency list before and after execution.

## Timing scope and limits

The proposed screen uses current production native snapshots, including the promoted minimal Byte public-inline hint, plus unchanged native Range. It keeps public SBBF dispatch and seven unchanged hot API bodies. Exact ceiling24 adds real geometries for Range and all three upstream families; native cap24 duplicates are omitted from timing. Four query modes stay separate. Smaller eligible allocations compete under cap32. Repeated batches/modes do not create independent calibration samples; calibration remains per family/size/seed, with no pooling across different implementations. The historical FourSector actual16 held-out quality failure remains relevant even if seed42 passes here. One input seed and deterministic ordered case groups make this a training screen, not a fresh-seed superiority confirmation.
