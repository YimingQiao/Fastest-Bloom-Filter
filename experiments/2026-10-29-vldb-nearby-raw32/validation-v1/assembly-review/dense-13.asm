
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b660 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39b660:	test   %esi,%esi
  39b662:	jne    39b668 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39b664:	ret
  39b665:	nopl   (%rax)
  39b668:	push   %r13
  39b66a:	add    $0x8,%rdi
  39b66e:	xor    %r9d,%r9d
  39b671:	push   %r12
  39b673:	mov    %esi,%r12d
  39b676:	push   %rbp
  39b677:	mov    %rcx,%rbp
  39b67a:	mov    %r12d,%ecx
  39b67d:	push   %rbx
  39b67e:	sub    $0x8,%rsp
  39b682:	mov    0x120(%rdi),%rbx
  39b689:	mov    0x10(%rdi),%rsi
  39b68d:	mov    %rbx,%r8
  39b690:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39b695:	mov    %r12d,%edx
  39b698:	mov    %rax,%r13
  39b69b:	shl    $0x2,%rdx
  39b69f:	xor    %esi,%esi
  39b6a1:	mov    %rbp,%rdi
  39b6a4:	call   1906a10 <memset@plt>
  39b6a9:	test   %r13,%r13
  39b6ac:	je     39b6cc <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39b6ae:	mov    %rbx,%r8
  39b6b1:	lea    (%rbx,%r13,4),%rdx
  39b6b5:	nopl   (%rax)
  39b6b8:	mov    (%r8),%eax
  39b6bb:	add    $0x4,%r8
  39b6bf:	movl   $0x1,0x0(%rbp,%rax,4)
  39b6c7:	cmp    %r8,%rdx
  39b6ca:	jne    39b6b8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39b6cc:	add    $0x8,%rsp
  39b6d0:	pop    %rbx
  39b6d1:	pop    %rbp
  39b6d2:	pop    %r12
  39b6d4:	pop    %r13
  39b6d6:	ret
