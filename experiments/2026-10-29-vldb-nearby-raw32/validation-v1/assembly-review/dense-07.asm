
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039bac0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39bac0:	test   %esi,%esi
  39bac2:	jne    39bac8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39bac4:	ret
  39bac5:	nopl   (%rax)
  39bac8:	push   %r13
  39baca:	add    $0x8,%rdi
  39bace:	xor    %r9d,%r9d
  39bad1:	push   %r12
  39bad3:	mov    %esi,%r12d
  39bad6:	push   %rbp
  39bad7:	mov    %rcx,%rbp
  39bada:	mov    %r12d,%ecx
  39badd:	push   %rbx
  39bade:	sub    $0x8,%rsp
  39bae2:	mov    0x120(%rdi),%rbx
  39bae9:	mov    0x10(%rdi),%rsi
  39baed:	mov    %rbx,%r8
  39baf0:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39baf5:	mov    %r12d,%edx
  39baf8:	mov    %rax,%r13
  39bafb:	shl    $0x2,%rdx
  39baff:	xor    %esi,%esi
  39bb01:	mov    %rbp,%rdi
  39bb04:	call   1906a10 <memset@plt>
  39bb09:	test   %r13,%r13
  39bb0c:	je     39bb2c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39bb0e:	mov    %rbx,%r8
  39bb11:	lea    (%rbx,%r13,4),%rdx
  39bb15:	nopl   (%rax)
  39bb18:	mov    (%r8),%eax
  39bb1b:	add    $0x4,%r8
  39bb1f:	movl   $0x1,0x0(%rbp,%rax,4)
  39bb27:	cmp    %r8,%rdx
  39bb2a:	jne    39bb18 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39bb2c:	add    $0x8,%rsp
  39bb30:	pop    %rbx
  39bb31:	pop    %rbp
  39bb32:	pop    %r12
  39bb34:	pop    %r13
  39bb36:	ret
