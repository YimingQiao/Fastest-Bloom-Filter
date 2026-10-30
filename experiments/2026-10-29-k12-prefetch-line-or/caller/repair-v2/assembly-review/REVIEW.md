# Actual conditional insertion assembly gate

Normal executable SHA25699af7d855138f462a6c71229b514967f8505b07844c639845af5945a85808bb7. This review reads the successful captured normal nm/objdump text; it runs no new compiler, disassembler or filter.

All8 K12 public/scalar/vector insertion bodies match their intended earlier compiled references after address/relocation/class-name normalization. The control's4 bodies remain old control. The conditional public dispatch and scalar tail also match old control; its `false` vector body is the old120-instruction word-OR body, and its `true` body is the previously measured170-instruction whole-line body. Register/opcode/immediate/relative-offset text is retained in the comparison; binary layout itself is not claimed equal.

The actual candidate helper at0x156b0 tests n==0, obtains current backing bytes, compares against0x200001 and jumps to0x16420 for true or0x167c0 for false. This is precisely the existing strict greater-than2MiB dispatch, with no new runtime decision. The false kernel retains sixteen scalar memory ORs. The true kernel has four VPEXPANDD/memory-VPORQ/aligned512-bit stores at0x16597,0x165fd,0x1666a and0x166d3. Each store instruction precedes the next key's line read, retaining duplicate/shared-line sequential semantics. The scalar remainder at0x16a50 is unchanged.

| Actual contract | Allocate clock | Ready clock | Actual public helper call | Stop clock |
|---|---:|---:|---:|---:|
| Control prehashed | 0xaf99 | 0xafb8 | 0xaffd →0xe220 | 0xb017 |
| Control common hash | 0xb249 | 0xb267 | 0xb47e →0xe220 | 0xb670 |
| Conditional prehashed | 0x12429 | 0x12448 | 0x1248d →0x156b0 | 0x124a7 |
| Conditional common hash | 0x126d9 | 0x126f7 | 0x1290e →0x156b0 | 0x12b00 |
| Range prehashed | 0x188a9 | 0x188c8 | 0x1890d →0x1bb30 | 0x18927 |
| Range common hash | 0x18b59 | 0x18b77 | 0x18d8e →0x1bb30 | 0x18f80 |

Each excerpt retains construction between allocation/ready and public insertion between ready/stop. For example, conditional construction calls make_filter at0x12443 before the ready clock0x12448; its original chunk length/pointer are passed to helper0x156b0 at0x1248d, so public size dispatch is within both measured boundaries. Common hashing remains inside the corresponding loop interval. Range uses its actual compiled public insertion helper, not the K12 kernel or private surrogate.

The native build may use host instruction subsets; the separately passed minimal-F build excludes VL/DQ/BW/BITALG/VBMI. Source and bitmap checks establish that minimum target, not assumptions about the native assembly. No timings, performance claims or new input seeds are introduced by this review.
