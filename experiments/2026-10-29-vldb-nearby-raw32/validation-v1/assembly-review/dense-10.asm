
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b480 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39b480:	test   %esi,%esi
  39b482:	jne    39b488 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39b484:	ret
  39b485:	nopl   (%rax)
  39b488:	push   %r13
  39b48a:	add    $0x8,%rdi
  39b48e:	xor    %r9d,%r9d
  39b491:	push   %r12
  39b493:	mov    %esi,%r12d
  39b496:	push   %rbp
  39b497:	mov    %rcx,%rbp
  39b49a:	mov    %r12d,%ecx
  39b49d:	push   %rbx
  39b49e:	sub    $0x8,%rsp
  39b4a2:	mov    0x120(%rdi),%rbx
  39b4a9:	mov    0x10(%rdi),%rsi
  39b4ad:	mov    %rbx,%r8
  39b4b0:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39b4b5:	mov    %r12d,%edx
  39b4b8:	mov    %rax,%r13
  39b4bb:	shl    $0x2,%rdx
  39b4bf:	xor    %esi,%esi
  39b4c1:	mov    %rbp,%rdi
  39b4c4:	call   1906a10 <memset@plt>
  39b4c9:	test   %r13,%r13
  39b4cc:	je     39b4ec <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39b4ce:	mov    %rbx,%r8
  39b4d1:	lea    (%rbx,%r13,4),%rdx
  39b4d5:	nopl   (%rax)
  39b4d8:	mov    (%r8),%eax
  39b4db:	add    $0x4,%r8
  39b4df:	movl   $0x1,0x0(%rbp,%rax,4)
  39b4e7:	cmp    %r8,%rdx
  39b4ea:	jne    39b4d8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39b4ec:	add    $0x8,%rsp
  39b4f0:	pop    %rbx
  39b4f1:	pop    %rbp
  39b4f2:	pop    %r12
  39b4f4:	pop    %r13
  39b4f6:	ret
