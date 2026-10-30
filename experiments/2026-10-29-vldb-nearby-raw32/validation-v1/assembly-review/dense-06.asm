
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039afe0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39afe0:	test   %esi,%esi
  39afe2:	jne    39afe8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39afe4:	ret
  39afe5:	nopl   (%rax)
  39afe8:	push   %r13
  39afea:	add    $0x8,%rdi
  39afee:	xor    %r9d,%r9d
  39aff1:	push   %r12
  39aff3:	mov    %esi,%r12d
  39aff6:	push   %rbp
  39aff7:	mov    %rcx,%rbp
  39affa:	mov    %r12d,%ecx
  39affd:	push   %rbx
  39affe:	sub    $0x8,%rsp
  39b002:	mov    0x120(%rdi),%rbx
  39b009:	mov    0x10(%rdi),%rsi
  39b00d:	mov    %rbx,%r8
  39b010:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39b015:	mov    %r12d,%edx
  39b018:	mov    %rax,%r13
  39b01b:	shl    $0x2,%rdx
  39b01f:	xor    %esi,%esi
  39b021:	mov    %rbp,%rdi
  39b024:	call   1906a10 <memset@plt>
  39b029:	test   %r13,%r13
  39b02c:	je     39b04c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39b02e:	mov    %rbx,%r8
  39b031:	lea    (%rbx,%r13,4),%rdx
  39b035:	nopl   (%rax)
  39b038:	mov    (%r8),%eax
  39b03b:	add    $0x4,%r8
  39b03f:	movl   $0x1,0x0(%rbp,%rax,4)
  39b047:	cmp    %r8,%rdx
  39b04a:	jne    39b038 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39b04c:	add    $0x8,%rsp
  39b050:	pop    %rbx
  39b051:	pop    %rbp
  39b052:	pop    %r12
  39b054:	pop    %r13
  39b056:	ret
