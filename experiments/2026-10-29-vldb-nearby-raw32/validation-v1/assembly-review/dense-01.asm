
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000391410 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  391410:	test   %esi,%esi
  391412:	jne    391418 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  391414:	ret
  391415:	nopl   (%rax)
  391418:	push   %r13
  39141a:	add    $0x8,%rdi
  39141e:	xor    %r9d,%r9d
  391421:	push   %r12
  391423:	mov    %esi,%r12d
  391426:	push   %rbp
  391427:	mov    %rcx,%rbp
  39142a:	mov    %r12d,%ecx
  39142d:	push   %rbx
  39142e:	sub    $0x8,%rsp
  391432:	mov    0x120(%rdi),%rbx
  391439:	mov    0x10(%rdi),%rsi
  39143d:	mov    %rbx,%r8
  391440:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  391445:	mov    %r12d,%edx
  391448:	mov    %rax,%r13
  39144b:	shl    $0x2,%rdx
  39144f:	xor    %esi,%esi
  391451:	mov    %rbp,%rdi
  391454:	call   1906a10 <memset@plt>
  391459:	test   %r13,%r13
  39145c:	je     39147c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39145e:	mov    %rbx,%r8
  391461:	lea    (%rbx,%r13,4),%rdx
  391465:	nopl   (%rax)
  391468:	mov    (%r8),%eax
  39146b:	add    $0x4,%r8
  39146f:	movl   $0x1,0x0(%rbp,%rax,4)
  391477:	cmp    %r8,%rdx
  39147a:	jne    391468 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39147c:	add    $0x8,%rsp
  391480:	pop    %rbx
  391481:	pop    %rbp
  391482:	pop    %r12
  391484:	pop    %r13
  391486:	ret
