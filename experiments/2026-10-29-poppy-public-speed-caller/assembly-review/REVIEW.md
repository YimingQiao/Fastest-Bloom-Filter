# Actual Poppy public caller: assembly gate passed

Reviewed the unchanged normal executable SHA637f176ddc93c486677dbe2a1ad70a77560336d03b4df92dc1f9eefc8316b40b. The additive capture recovers the same binary after V1's empty selector failure; it does not rebuild, rerun filters or replace the failed metadata. `extract.py` reproduces all excerpts from the complete captured disassembly and verifies the binary hash.

The actual selected workload is `run<PoppyPublic<44>>` at0x56060, with its own checked public constructor at0x17a680. LLVM shares identical generic hot bodies under symbols labelled `PoppyPublic<0>`: the run44 call sites explicitly target those addresses using the actual constructed44 object. The symbol's canonical type label does not change the object, public parameters or runtime probes. All constructor/body/output checks passed for the declared fixtures and actual rows. This is not a claim that all47 constructors were run through the tiny timed caller.

## Clock boundaries

ELF64 R_X86_64_RELATIVE entries bind GOT0x1d6100 to `std::time::Instant::now` at0x1afdb0 and GOT0x1d6110 to `Instant::elapsed` at0x1afdc0. `clock-relocations.json` and the extraction code retain that evidence; `_DYNAMIC` comments alone were not used as a clock identity.

| Contract | Actual start / ready | Actual public work | Actual stop |
|---|---|---|---|
| Allocation plus prehashed insertion |0x569d6 /0x56a66|constructor0x569f2→0x17a680; insertion0x56a9e→0xfcbe0|0x56ab0|
| Allocation plus common-hash insertion |0x56cec /0x56d81|constructor0x56d08→0x17a680; common hash/scratch loop0x56dde onward; insertion0x56dc5→0xfcbe0 on loop backedge|0x56fa0|
| Staged prehashed query |0x578e9|batch loop0x57a95→0xfdb50|0x57d51|
| Staged common-hash query |0x578e9|common hash/scratch loop, then backedge0x57b0d→0xfdb50|0x57d51|
| Visible prehashed public singleton loop |0x578e9|0x5796d→0x34430|0x57d51|
| Visible common-hash public singleton loop |0x578e9|0x5799f→0x344f0|0x57d51|

The source-seeded phase switch is inside the query interval, as for unchanged controls. Full output verification at0x57e1b→0x103e70 occurs after the elapsed call; allocation/destruction and construction-validation placements match the frozen source. The hash-loop insertion/query call sites appear earlier in address order than some hash instructions, but control first enters the hash body and then takes the backedge to the call. The complete excerpts retain those branches.

## Mandatory public work remains charged

`insert` at0xfcbe0 loads each eight-byte value, calls the actual public `BloomFilter::insert_bytes<[u8;8]>` at0xfefd0, and checks its Result tag at0xfcc2f before advancing. The upstream body includes xorshift preparation, bucket selection including ordinary modulo when needed, primary/secondary probe work, byte ORs, count bookkeeping and cache ORs. Constructor0x17a6f9 calls the upstream `BloomFilter::make` at0x196ec0 inside the allocation interval. No private kernel was substituted.

Dense lookup at0xfdb50 and both visible loops call the actual public `contains_bytes<[u8;8]>` at0xff3a0. The dense/visible loops convert AL to a dense u32 and store one answer per key. In particular, visible raw0x344f0 contains both common hash multiplies at0x3453c/0x3454a, then public lookup at0x3455b and dense store0x34563. Visible pure passes the prehashed value directly to the same public method. On this little-endian host the eight-byte array value is passed in a register; there is no requirement to invent a stack conversion that the compiler removed.

The public contains body retains cache testing at0xff3da–0xff40c, power-of-two versus ordinary bucket addressing at0xff40e–0xff43e, and secondary-hash multiplication at0xff4a5–0xff4c4 when required by the public probe sequence. Its early cache/probe failures are the genuine upstream public behavior and remain timed. The public contains call remains out of line per key in this actual binary. The report must not describe it as fully inlined, compare old-context times as if code generation were identical, or infer speed from assembly alone.

The proof is limited to correct placement and the actual representative caller code. It provides no formal throughput, new quality result or promotion decision. The four normal/ASan tests,24 tiny rows, four original-reference rows and12 invalid cases remain the bounded functional evidence; the fixed486 performance plan is a separate stage.
