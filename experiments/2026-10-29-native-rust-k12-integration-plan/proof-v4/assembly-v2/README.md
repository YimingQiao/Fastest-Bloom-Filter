# Archive-only ELF-sized capture

All52 tests and36 exact public parity fixtures passed before V4's assembly-only guard stopped. Its broad substring match included a folded standard-library thread trampoline at0x1e100: `nm` and `objdump` display different legitimate aliases at that address. The original capture and incomplete metadata remain in commit b0d2d06491ffd9c5c24e945e03ed21a108044535.

This additive capture uses the same unchanged normal binary, no compilation or Bloom-filter execution. It selects only three explicit native caller wrappers and two direct public class methods, then binds address and size to defined ELF FUNC entries and raw `nm -S`. Every same-address ELF alias is retained. Disassembly uses `[address,address+size)` and must contain actual instructions starting at that address; objdump's preferred alias label is descriptive only. This avoids both empty demangled-symbol capture and false rejection of folded aliases.

The source/native/failed-functional archives and every preserved compiler input are reverified before and after capture under the CPU3/socket1 flock. Manual hot-path interpretation follows the actual captured instructions, not symbol naming or source intent. No timing conclusion is inferred.
