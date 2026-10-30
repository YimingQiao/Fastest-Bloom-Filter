# Finite actual Rust port correctness driver

Source only, pending review/commit/lease. The driver binds the full prepared local crate/fixtures, its own code, and exact prior C++ consumed-header closure from `e150be33`. No mutable production Rust path is a dependency. A fresh `/tmp/fastest-bf-k12-rust-port-v1-cpu3` tree and `validation-v1` preserve attempts, including failures; dangling target symlinks are rejected. Use CPU3 and an actual inherited exclusive socket1 flock throughout.

One normal C++ fixture is compiled against the exact frozen K12 public header. Rust uses three separate target trees: generic x86-64 optimized normal, `disable-avx512`, and nightly ASan. Each executes only the five new focused library tests and builds the public fixture. Structured Cargo compiler-artifact events identify exact executables; no guessed test executable globs. All Rust `*.d` and the C++ `-MD` depfile must resolve to prepared/frozen bytes, with representative Rust modules and exact C++ K12 header required. Final checks repeat all consumed-input and binary hashes.

Six C++ reference streams (3/17/32769 lines × ordinary/hotspot) and12 Rust streams per mode (same cases × T3/T7) produce complete logical bitmap bytes plus8193 dense little-endian u32 answers. Every Rust stream is compared byte-for-byte with C++; actual backend, backing allocation, worker count and total payload length are checked. Expected runtime backends on this fixed host are normal/ASan AVX512, disabled AVX2. Unit tests additionally force scalar and AVX2 internal paths. Full input/query clones guard accidental writes.

Large raw correctness payloads are compared in memory and not duplicated into Git. Each command retains payload byte length and SHA256, complete stderr metadata, reference identity and an explicit full-byte equality result. Compiler/test stdout, stderr, command/environment ledger, source/depfile/binary hashes and all failures are retained. These payload digests do not replace the actual byte comparison. No performance or accuracy sweep runs, and the prior42 C++ backend proofs are reused.

Five offline guard tests cover structured artifacts, target boundaries/dangling links, full payload/backend validation, Rust phony/continuation depfile parsing and early `-O` rejection. After review and exact source commit:

```sh
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 preflight/validate.py --source-commit FULL_COMMIT
```
