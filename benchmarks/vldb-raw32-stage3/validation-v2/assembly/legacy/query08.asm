
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000689670 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  689670:	push   %r15
  689672:	push   %r14
  689674:	push   %r13
  689676:	push   %r12
  689678:	mov    %rcx,%r12
  68967b:	push   %rbp
  68967c:	mov    %rdi,%rbp
  68967f:	push   %rbx
  689680:	mov    %rdx,%rbx
  689683:	sub    $0x18,%rsp
  689687:	mov    %r8,0x8(%rsp)
  68968c:	test   %esi,%esi
  68968e:	je     6896f8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  689690:	cmp    $0x1,%esi
  689693:	mov    $0x1000,%r14d
  689699:	mov    $0x1,%eax
  68969e:	cmove  %rax,%r14
  6896a2:	test   %rdx,%rdx
  6896a5:	je     6896e4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  6896a7:	mov    %rdx,%r13
  6896aa:	xor    %r15d,%r15d
  6896ad:	nopl   (%rax)
  6896b0:	mov    0x8(%rsp),%rax
  6896b5:	lea    0x0(,%r15,4),%rdx
  6896bd:	lea    (%rax,%rdx,1),%rcx
  6896c1:	add    %r12,%rdx
  6896c4:	mov    %r14,%rax
  6896c7:	cmp    %r14,%r13
  6896ca:	cmovbe %r13,%rax
  6896ce:	mov    %rbp,%rdi
  6896d1:	mov    %rax,%rsi
  6896d4:	add    %r14,%r15
  6896d7:	call   6895f0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  6896dc:	sub    %r14,%r13
  6896df:	cmp    %rbx,%r15
  6896e2:	jb     6896b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  6896e4:	add    $0x18,%rsp
  6896e8:	pop    %rbx
  6896e9:	pop    %rbp
  6896ea:	pop    %r12
  6896ec:	pop    %r13
  6896ee:	pop    %r14
  6896f0:	pop    %r15
  6896f2:	ret
  6896f3:	nopl   0x0(%rax,%rax,1)
  6896f8:	lea    0x8(%rdi),%r15
  6896fc:	xor    %r14d,%r14d
  6896ff:	test   %rdx,%rdx
  689702:	je     6896e4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  689704:	nopl   0x0(%rax)
  689708:	mov    (%r12,%r14,4),%edx
  68970c:	mov    0x18(%rbp),%rsi
  689710:	mov    %r15,%rdi
  689713:	call   6917a0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  689718:	mov    0x8(%rsp),%rdi
  68971d:	movzbl %al,%eax
  689720:	mov    %eax,(%rdi,%r14,4)
  689724:	inc    %r14
  689727:	cmp    %r14,%rbx
  68972a:	jne    689708 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  68972c:	add    $0x18,%rsp
  689730:	pop    %rbx
  689731:	pop    %rbp
  689732:	pop    %r12
  689734:	pop    %r13
  689736:	pop    %r14
  689738:	pop    %r15
  68973a:	ret
