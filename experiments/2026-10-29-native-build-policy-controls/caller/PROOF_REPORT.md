# Four-arm actual caller proof

The focused correctness and assembly gates passed. No formal fresh-seed
performance workload has run. This proof establishes that the frozen caller
can test the already specified A0/A1, Clone and unchanged Policy comparison;
it does not establish a speed benefit or authorize default integration.

The source is commit `ec44c93cde22ea5c30ffd4d2bca5bc6e5eaaf63b`, with117 local
source artifacts plus its preparation manifest. Complete operation session
28809 ran under the inherited exclusive socket1 flock, parent CPU3. Children
used the first4(C++) or8(Rust) physical socket1 cores, explicit NUMA1 binding,
and the original requested thread count. The allowed mask is a core budget;
individual native workers are not pinned. CPU3/socket1 was explicitly
released after validation and read-only disassembly capture.

Normal and ASan builds passed24 old-seed records (both languages, both native
families, scenarios0/1/2),96 arm records,640 successful fresh timed bitmap
lifetimes, four intended output faults and14 CLI rejections. There were52
recorded commands. Every successful check used seed74381 and one four-row
Williams cycle. Both formal fresh seeds were rejected by check mode, and
old74381 was rejected by measure mode before workload construction.

Each arm checked all streamed history and new inserted keys, all guarded
mixed serial/parallel outputs against its serial oracle, unchanged input
digests, exact workers/scratch/spawn metadata and chronological arm/contract
order. All12 old geometry/language semantic records matched the committed
native96 references; six mapping/geometry records matched across languages
and backends. Populated allocation+insert remains unavailable. The incidental
four-trial durations are correctness evidence only and are not used as
training results, rankings or a reason to change the design.

Clang23 built C++; stable Rust1.92 built normal Rust, and nightly1.100 built
Rust ASan. The native sources/inline attributes were unchanged. Actual
compiler dep-info captured474 normal and475 ASan inputs (475 in the union),
including all three native snapshots. Structured Cargo package identities and
the previously validated nightly dep-info resolver passed on the first run.
Four executable hashes are in `COMPILED_PROOF.json`; executables are not
included in Git. Normal executables are:

|Language|SHA256|
|---|---|
|C++|`3eecc5a4e8d11b3ee6d66adace1deec94e9e5d1ed5238ea8c9df8d4a6aa2b93f`|
|Rust|`ff89a3d77e6cf6d82b019202448c56f6d4b2d9bb44c40e7bca0da735b8a16e8f`|

The C++ and Rust assembly reviews establish a single actual typed Trial
address for A0/A1 in each family. Clone has a distinct measured Trial and
public insertion entry in both binaries; folding of every internal helper
is not excluded. All six typed Trial specializations retain the same
noinline boundary outside their clocks. Original requested T is loaded
inside Policy's insert and allocation intervals and reaches the actual
native public method. Current batch length and actual bitmap byte gates run
inside that call; constructors/zero initialization are inside the allocation
boundary. There is no benchmark-side substitute policy. Exact addresses,
relocations, Cargo disambiguators and text excerpts are linked below:

- `assembly/cpp-review/REVIEW.md` and `REVIEW.json`: all12 typed C++ intervals,
  shared A0/A1 branch/callsites, two native gates.
- `assembly/rust-review/REVIEW.md` and `evidence.json`: all six typed Rust
  identities, common A0/A1 dispatch, four Policy intervals and native gates.
- `assembly/capture-v2/`: complete raw normal symbols/disassembly/relocations,
  all three Cargo rlib identities, tools and hashes.

The first read-only capture attempt found `llvm-objdump` absent and stopped
before any tool invocation. Its original source and discovery failure are
preserved. Additive capture-v2 used GNU objdump; no BF/compiler rerun or
binary change occurred. Correctness itself passed on its first attempt.

`proof_audit.py` independently revalidates committed source, all24 raw and
aggregate records, every command status, exact prior semantics, all live
binaries/dependency rules and both assembly artifact closures. The unified
proof archive retains all source, logs, failures and review artifacts.
The next stage must retain the fixed40 processes/72 contracts/32 repeats,
all negative controls and shared-sample dependence. Different code addresses
and eight-cycle descriptive intervals do not guarantee a general policy win.
