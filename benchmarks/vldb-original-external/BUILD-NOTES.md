# Preserved build stages

No query throughput or FPR calibration has run.

1. `validation-v1`: Clang23 rejected four original std::function declarations
   that place `__restrict` before scalar typedef word_t. Source snapshots and
   full diagnostics are retained. No upstream file was edited.
2. `compatibility-v1`: a minimal original-syntax probe passes GCC12 and fails
   Clang23. Both commands and outputs are retained.
3. `validation-v2-gcc`: all14 original upstream objects and the static library
   compiled. The correctness translation unit then redundantly instantiated the
   whole runtime dispatcher, reaching roughly5 minutes/8.5 GiB before an
   intentional stop. Only the verified compiler process was signaled; CMake
   and the driver retained the complete failing build logs and source snapshot.
4. The next source revision adds the same unchanged extern-instance declaration
   headers used by upstream bbf_32.cpp and bbf_64.cpp to the adapter. This is a
   build fix; it changes no public API, mask, addressing, upstream implementation
   or template configuration. The14 already built upstream objects are reused.

An independent read-only review found no concrete accounting blocker within the
serial correctness scope. Requested C++ heap and directly wrapped mmap are
reported, not libc-internal malloc, allocator usable size, RSS, or general
concurrent profiling. Original-owner headers preserve allocation ownership
across phases; normal ASan correctness remains a separate uninstrumented target.
This review preceded the completed V4/V5/V7 stages below.

## V3 runtime guard / V4 process isolation

V3 GCC built and linked both targets (548 seconds diagnostic wall time). The first two U=1 triplets passed; the later register U=0 metadata guard rejected the original library reporting U=1. The complete V3 sources/logs and both binaries are retained in `validation-v3-gcc-extern/`. `compatibility-v2/names.log` independently records unchanged public facade requests 1,1,0,2,4,2,4 reporting 1 for all. This is not a scalar naming convention: `calibration_data.cpp:450` uses `map.insert`, which never replaces an existing config.

V4 executes each U configuration in a fresh process of the same binary, keeps the metadata check in every process, and rejects retuning to a different U even after the prior adapter is destroyed. No upstream source, HOME, or tuner file is changed. Existing tuner files remain fingerprinted; unsupported metadata is a hard rejection. Per-process accounting no longer carries one process's setup footprint into another row group. No throughput is measured.

## V4 native result / remaining backend stages

`validation-v4-gcc-process/metadata.json` records successful native checks of seven U/layout cases in separate processes, four native controls, and nine allocation rows. The ordinary original API binary and separate accounting binary are retained and hashed. The exact compiler dependency records contain609 Boost1.83 headers among1153 consumed files and17 compile commands. No other Boost root was consumed.

For4096B bitmaps, observed owned control requests are108B for DirectDynamic,0B for StaticLogic,284B for original PImpl; the corresponding adapter stack objects are216B/40B/48B. Each fresh PImpl process observes39217B shared setup live heap,194575B setup allocation traffic,318B temporary metadata traffic, and no API C++ heap allocation. Compact scratch is16384B for4096 inputs and owned control/bitmap frees restore their exact prior live totals. Tracker overhead and startup/library allocations are reported separately. These values are not a total-process memory claim.

V5+ keeps ordinary code at-O3 and uses-O1 only for correctness-only sanitizer compilation to bound the large historical template compiler memory. Sanitizer binaries never become throughput targets. The driver has an explicit sanitizer-only option so the passed ordinary native stage need not be rerun. The V4 source snapshot remains immutable.

## V5/V6/V7 final backend evidence

V5 native GCC ASan/UBSan passed all8 separate-process checks with empty diagnostics and exact V4 output-digest parity. The ordinary allocator remains in this target; allocation-prefix instrumentation is excluded. Actual compiler flags include-O1, address+undefined sanitizers, no recovery and frame pointers. Build wall time1645.7s is diagnostic only.

V6 tried the unchanged full artifact at-march=x86-64 -mno-avx -mno-sse4.1 -mno-ssse3. The first explicit-instance source failed because `simd/vec.hpp:1166` calls an emulated `storeu<unsigned int,unsigned int,...>` with no implementation. The failure covers generated lengths4/8/16/32. No source fix, static-kernel substitution or non-AVX success is claimed. This is separate from the original U=0 scalar query policy, which passes in supported builds.

V7 uses-O3 -march=x86-64-v3. All8 process checks and9 allocation rows pass. Its output digests and complete accounting JSON exactly equal V4; macro proof contains AVX2 and no AVX512 feature macro. Both normal backends consumed609 Boost1.83 headers among1153 total files,17 compile commands each. The final native ASan binary hash is d03b8aa5955c49f132ee91598b89186c18efa96c464022a90256bafaee17b11d; all normal binary hashes are in their metadata. V7 build wall time1352.2s is diagnostic only.

Final documentation and the archive-only `freeze.py` were prepared after the validation source snapshots. They do not change a compiled source or a measured API. The validator default compiler is nowGCC to match the supported unchanged-source path; every recorded run already passed explicit--compiler g++. Source snapshots preserve the exact earlier runner and recipe bytes.
