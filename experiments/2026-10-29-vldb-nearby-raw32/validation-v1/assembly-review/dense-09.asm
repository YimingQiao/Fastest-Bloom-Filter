
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039bc20 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39bc20:	test   %esi,%esi
  39bc22:	jne    39bc28 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39bc24:	ret
  39bc25:	nopl   (%rax)
  39bc28:	push   %r13
  39bc2a:	add    $0x8,%rdi
  39bc2e:	xor    %r9d,%r9d
  39bc31:	push   %r12
  39bc33:	mov    %esi,%r12d
  39bc36:	push   %rbp
  39bc37:	mov    %rcx,%rbp
  39bc3a:	mov    %r12d,%ecx
  39bc3d:	push   %rbx
  39bc3e:	sub    $0x8,%rsp
  39bc42:	mov    0x120(%rdi),%rbx
  39bc49:	mov    0x10(%rdi),%rsi
  39bc4d:	mov    %rbx,%r8
  39bc50:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39bc55:	mov    %r12d,%edx
  39bc58:	mov    %rax,%r13
  39bc5b:	shl    $0x2,%rdx
  39bc5f:	xor    %esi,%esi
  39bc61:	mov    %rbp,%rdi
  39bc64:	call   1906a10 <memset@plt>
  39bc69:	test   %r13,%r13
  39bc6c:	je     39bc8c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39bc6e:	mov    %rbx,%r8
  39bc71:	lea    (%rbx,%r13,4),%rdx
  39bc75:	nopl   (%rax)
  39bc78:	mov    (%r8),%eax
  39bc7b:	add    $0x4,%r8
  39bc7f:	movl   $0x1,0x0(%rbp,%rax,4)
  39bc87:	cmp    %r8,%rdx
  39bc8a:	jne    39bc78 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39bc8c:	add    $0x8,%rsp
  39bc90:	pop    %rbx
  39bc91:	pop    %rbp
  39bc92:	pop    %r12
  39bc94:	pop    %r13
  39bc96:	ret
