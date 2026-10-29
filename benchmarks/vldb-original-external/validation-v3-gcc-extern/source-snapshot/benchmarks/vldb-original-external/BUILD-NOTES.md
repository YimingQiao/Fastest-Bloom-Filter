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
