
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390cf0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  390cf0:	test   %esi,%esi
  390cf2:	jne    390cf8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  390cf4:	ret
  390cf5:	nopl   (%rax)
  390cf8:	push   %r13
  390cfa:	add    $0x8,%rdi
  390cfe:	xor    %r9d,%r9d
  390d01:	push   %r12
  390d03:	mov    %esi,%r12d
  390d06:	push   %rbp
  390d07:	mov    %rcx,%rbp
  390d0a:	mov    %r12d,%ecx
  390d0d:	push   %rbx
  390d0e:	sub    $0x8,%rsp
  390d12:	mov    0x120(%rdi),%rbx
  390d19:	mov    0x10(%rdi),%rsi
  390d1d:	mov    %rbx,%r8
  390d20:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  390d25:	mov    %r12d,%edx
  390d28:	mov    %rax,%r13
  390d2b:	shl    $0x2,%rdx
  390d2f:	xor    %esi,%esi
  390d31:	mov    %rbp,%rdi
  390d34:	call   1906a10 <memset@plt>
  390d39:	test   %r13,%r13
  390d3c:	je     390d5c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  390d3e:	mov    %rbx,%r8
  390d41:	lea    (%rbx,%r13,4),%rdx
  390d45:	nopl   (%rax)
  390d48:	mov    (%r8),%eax
  390d4b:	add    $0x4,%r8
  390d4f:	movl   $0x1,0x0(%rbp,%rax,4)
  390d57:	cmp    %r8,%rdx
  390d5a:	jne    390d48 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  390d5c:	add    $0x8,%rsp
  390d60:	pop    %rbx
  390d61:	pop    %rbp
  390d62:	pop    %r12
  390d64:	pop    %r13
  390d66:	ret
