
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390b90 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  390b90:	test   %esi,%esi
  390b92:	jne    390b98 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  390b94:	ret
  390b95:	nopl   (%rax)
  390b98:	push   %r13
  390b9a:	add    $0x8,%rdi
  390b9e:	xor    %r9d,%r9d
  390ba1:	push   %r12
  390ba3:	mov    %esi,%r12d
  390ba6:	push   %rbp
  390ba7:	mov    %rcx,%rbp
  390baa:	mov    %r12d,%ecx
  390bad:	push   %rbx
  390bae:	sub    $0x8,%rsp
  390bb2:	mov    0x120(%rdi),%rbx
  390bb9:	mov    0x10(%rdi),%rsi
  390bbd:	mov    %rbx,%r8
  390bc0:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  390bc5:	mov    %r12d,%edx
  390bc8:	mov    %rax,%r13
  390bcb:	shl    $0x2,%rdx
  390bcf:	xor    %esi,%esi
  390bd1:	mov    %rbp,%rdi
  390bd4:	call   1906a10 <memset@plt>
  390bd9:	test   %r13,%r13
  390bdc:	je     390bfc <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  390bde:	mov    %rbx,%r8
  390be1:	lea    (%rbx,%r13,4),%rdx
  390be5:	nopl   (%rax)
  390be8:	mov    (%r8),%eax
  390beb:	add    $0x4,%r8
  390bef:	movl   $0x1,0x0(%rbp,%rax,4)
  390bf7:	cmp    %r8,%rdx
  390bfa:	jne    390be8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  390bfc:	add    $0x8,%rsp
  390c00:	pop    %rbx
  390c01:	pop    %rbp
  390c02:	pop    %r12
  390c04:	pop    %r13
  390c06:	ret
