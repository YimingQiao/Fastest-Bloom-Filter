
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000391330 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  391330:	push   %r15
  391332:	push   %r14
  391334:	push   %r13
  391336:	push   %r12
  391338:	mov    %rcx,%r12
  39133b:	push   %rbp
  39133c:	mov    %rdi,%rbp
  39133f:	push   %rbx
  391340:	mov    %rdx,%rbx
  391343:	sub    $0x18,%rsp
  391347:	mov    %r8,0x8(%rsp)
  39134c:	test   %esi,%esi
  39134e:	je     3913b8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  391350:	cmp    $0x1,%esi
  391353:	mov    $0x1000,%r14d
  391359:	mov    $0x1,%eax
  39135e:	cmove  %rax,%r14
  391362:	test   %rdx,%rdx
  391365:	je     3913a4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  391367:	mov    %rdx,%r13
  39136a:	xor    %r15d,%r15d
  39136d:	nopl   (%rax)
  391370:	mov    0x8(%rsp),%rax
  391375:	lea    0x0(,%r15,4),%rdx
  39137d:	lea    (%rax,%rdx,1),%rcx
  391381:	add    %r12,%rdx
  391384:	mov    %r14,%rax
  391387:	cmp    %r14,%r13
  39138a:	cmovbe %r13,%rax
  39138e:	mov    %rbp,%rdi
  391391:	mov    %rax,%rsi
  391394:	add    %r14,%r15
  391397:	call   3912b0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39139c:	sub    %r14,%r13
  39139f:	cmp    %rbx,%r15
  3913a2:	jb     391370 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  3913a4:	add    $0x18,%rsp
  3913a8:	pop    %rbx
  3913a9:	pop    %rbp
  3913aa:	pop    %r12
  3913ac:	pop    %r13
  3913ae:	pop    %r14
  3913b0:	pop    %r15
  3913b2:	ret
  3913b3:	nopl   0x0(%rax,%rax,1)
  3913b8:	lea    0x8(%rdi),%r15
  3913bc:	xor    %r14d,%r14d
  3913bf:	test   %rdx,%rdx
  3913c2:	je     3913a4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  3913c4:	nopl   0x0(%rax)
  3913c8:	mov    (%r12,%r14,4),%edx
  3913cc:	mov    0x18(%rbp),%rsi
  3913d0:	mov    %r15,%rdi
  3913d3:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  3913d8:	mov    0x8(%rsp),%rdi
  3913dd:	movzbl %al,%eax
  3913e0:	mov    %eax,(%rdi,%r14,4)
  3913e4:	inc    %r14
  3913e7:	cmp    %r14,%rbx
  3913ea:	jne    3913c8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  3913ec:	add    $0x18,%rsp
  3913f0:	pop    %rbx
  3913f1:	pop    %rbp
  3913f2:	pop    %r12
  3913f4:	pop    %r13
  3913f6:	pop    %r14
  3913f8:	pop    %r15
  3913fa:	ret
