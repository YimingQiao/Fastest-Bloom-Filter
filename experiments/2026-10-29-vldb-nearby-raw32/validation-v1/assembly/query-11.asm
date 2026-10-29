
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b320 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39b320:	push   %r15
  39b322:	push   %r14
  39b324:	push   %r13
  39b326:	push   %r12
  39b328:	mov    %rcx,%r12
  39b32b:	push   %rbp
  39b32c:	mov    %rdi,%rbp
  39b32f:	push   %rbx
  39b330:	mov    %rdx,%rbx
  39b333:	sub    $0x18,%rsp
  39b337:	mov    %r8,0x8(%rsp)
  39b33c:	test   %esi,%esi
  39b33e:	je     39b3a8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39b340:	cmp    $0x1,%esi
  39b343:	mov    $0x1000,%r14d
  39b349:	mov    $0x1,%eax
  39b34e:	cmove  %rax,%r14
  39b352:	test   %rdx,%rdx
  39b355:	je     39b394 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b357:	mov    %rdx,%r13
  39b35a:	xor    %r15d,%r15d
  39b35d:	nopl   (%rax)
  39b360:	mov    0x8(%rsp),%rax
  39b365:	lea    0x0(,%r15,4),%rdx
  39b36d:	lea    (%rax,%rdx,1),%rcx
  39b371:	add    %r12,%rdx
  39b374:	mov    %r14,%rax
  39b377:	cmp    %r14,%r13
  39b37a:	cmovbe %r13,%rax
  39b37e:	mov    %rbp,%rdi
  39b381:	mov    %rax,%rsi
  39b384:	add    %r14,%r15
  39b387:	call   39b2a0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39b38c:	sub    %r14,%r13
  39b38f:	cmp    %rbx,%r15
  39b392:	jb     39b360 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39b394:	add    $0x18,%rsp
  39b398:	pop    %rbx
  39b399:	pop    %rbp
  39b39a:	pop    %r12
  39b39c:	pop    %r13
  39b39e:	pop    %r14
  39b3a0:	pop    %r15
  39b3a2:	ret
  39b3a3:	nopl   0x0(%rax,%rax,1)
  39b3a8:	lea    0x8(%rdi),%r15
  39b3ac:	xor    %r14d,%r14d
  39b3af:	test   %rdx,%rdx
  39b3b2:	je     39b394 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b3b4:	nopl   0x0(%rax)
  39b3b8:	mov    (%r12,%r14,4),%edx
  39b3bc:	mov    0x18(%rbp),%rsi
  39b3c0:	mov    %r15,%rdi
  39b3c3:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39b3c8:	mov    0x8(%rsp),%rdi
  39b3cd:	movzbl %al,%eax
  39b3d0:	mov    %eax,(%rdi,%r14,4)
  39b3d4:	inc    %r14
  39b3d7:	cmp    %r14,%rbx
  39b3da:	jne    39b3b8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39b3dc:	add    $0x18,%rsp
  39b3e0:	pop    %rbx
  39b3e1:	pop    %rbp
  39b3e2:	pop    %r12
  39b3e4:	pop    %r13
  39b3e6:	pop    %r14
  39b3e8:	pop    %r15
  39b3ea:	ret
