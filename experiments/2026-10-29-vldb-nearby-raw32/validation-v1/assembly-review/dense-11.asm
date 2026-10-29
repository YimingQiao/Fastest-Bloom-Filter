
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b2a0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39b2a0:	test   %esi,%esi
  39b2a2:	jne    39b2a8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39b2a4:	ret
  39b2a5:	nopl   (%rax)
  39b2a8:	push   %r13
  39b2aa:	add    $0x8,%rdi
  39b2ae:	xor    %r9d,%r9d
  39b2b1:	push   %r12
  39b2b3:	mov    %esi,%r12d
  39b2b6:	push   %rbp
  39b2b7:	mov    %rcx,%rbp
  39b2ba:	mov    %r12d,%ecx
  39b2bd:	push   %rbx
  39b2be:	sub    $0x8,%rsp
  39b2c2:	mov    0x120(%rdi),%rbx
  39b2c9:	mov    0x10(%rdi),%rsi
  39b2cd:	mov    %rbx,%r8
  39b2d0:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39b2d5:	mov    %r12d,%edx
  39b2d8:	mov    %rax,%r13
  39b2db:	shl    $0x2,%rdx
  39b2df:	xor    %esi,%esi
  39b2e1:	mov    %rbp,%rdi
  39b2e4:	call   1906a10 <memset@plt>
  39b2e9:	test   %r13,%r13
  39b2ec:	je     39b30c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39b2ee:	mov    %rbx,%r8
  39b2f1:	lea    (%rbx,%r13,4),%rdx
  39b2f5:	nopl   (%rax)
  39b2f8:	mov    (%r8),%eax
  39b2fb:	add    $0x4,%r8
  39b2ff:	movl   $0x1,0x0(%rbp,%rax,4)
  39b307:	cmp    %r8,%rdx
  39b30a:	jne    39b2f8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39b30c:	add    $0x8,%rsp
  39b310:	pop    %rbx
  39b311:	pop    %rbp
  39b312:	pop    %r12
  39b314:	pop    %r13
  39b316:	ret
