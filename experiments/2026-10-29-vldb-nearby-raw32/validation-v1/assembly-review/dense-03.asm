
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003912b0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  3912b0:	test   %esi,%esi
  3912b2:	jne    3912b8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  3912b4:	ret
  3912b5:	nopl   (%rax)
  3912b8:	push   %r13
  3912ba:	add    $0x8,%rdi
  3912be:	xor    %r9d,%r9d
  3912c1:	push   %r12
  3912c3:	mov    %esi,%r12d
  3912c6:	push   %rbp
  3912c7:	mov    %rcx,%rbp
  3912ca:	mov    %r12d,%ecx
  3912cd:	push   %rbx
  3912ce:	sub    $0x8,%rsp
  3912d2:	mov    0x120(%rdi),%rbx
  3912d9:	mov    0x10(%rdi),%rsi
  3912dd:	mov    %rbx,%r8
  3912e0:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  3912e5:	mov    %r12d,%edx
  3912e8:	mov    %rax,%r13
  3912eb:	shl    $0x2,%rdx
  3912ef:	xor    %esi,%esi
  3912f1:	mov    %rbp,%rdi
  3912f4:	call   1906a10 <memset@plt>
  3912f9:	test   %r13,%r13
  3912fc:	je     39131c <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  3912fe:	mov    %rbx,%r8
  391301:	lea    (%rbx,%r13,4),%rdx
  391305:	nopl   (%rax)
  391308:	mov    (%r8),%eax
  39130b:	add    $0x4,%r8
  39130f:	movl   $0x1,0x0(%rbp,%rax,4)
  391317:	cmp    %r8,%rdx
  39131a:	jne    391308 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39131c:	add    $0x8,%rsp
  391320:	pop    %rbx
  391321:	pop    %rbp
  391322:	pop    %r12
  391324:	pop    %r13
  391326:	ret
