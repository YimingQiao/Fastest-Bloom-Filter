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
Runtime results remain pending until a complete recorded stage passes.

## V3 runtime guard / V4 process isolation

V3 GCC built and linked both targets (548 seconds diagnostic wall time). The first two U=1 triplets passed; the later register U=0 metadata guard rejected the original library reporting U=1. The complete V3 sources/logs and both binaries are retained in `validation-v3-gcc-extern/`. `compatibility-v2/names.log` independently records unchanged public facade requests 1,1,0,2,4,2,4 reporting 1 for all. This is not a scalar naming convention: `calibration_data.cpp:450` uses `map.insert`, which never replaces an existing config.

V4 executes each U configuration in a fresh process of the same binary, keeps the metadata check in every process, and rejects retuning to a different U even after the prior adapter is destroyed. No upstream source, HOME, or tuner file is changed. Existing tuner files remain fingerprinted; unsupported metadata is a hard rejection. Per-process accounting no longer carries one process's setup footprint into another row group. No throughput is measured.
