
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000691430 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  691430:	push   %r15
  691432:	push   %r14
  691434:	push   %r13
  691436:	push   %r12
  691438:	mov    %rcx,%r12
  69143b:	push   %rbp
  69143c:	mov    %rdi,%rbp
  69143f:	push   %rbx
  691440:	mov    %rdx,%rbx
  691443:	sub    $0x18,%rsp
  691447:	mov    %r8,0x8(%rsp)
  69144c:	test   %esi,%esi
  69144e:	je     6914b8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  691450:	cmp    $0x1,%esi
  691453:	mov    $0x1000,%r14d
  691459:	mov    $0x1,%eax
  69145e:	cmove  %rax,%r14
  691462:	test   %rdx,%rdx
  691465:	je     6914a4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  691467:	mov    %rdx,%r13
  69146a:	xor    %r15d,%r15d
  69146d:	nopl   (%rax)
  691470:	mov    0x8(%rsp),%rax
  691475:	lea    0x0(,%r15,4),%rdx
  69147d:	lea    (%rax,%rdx,1),%rcx
  691481:	add    %r12,%rdx
  691484:	mov    %r14,%rax
  691487:	cmp    %r14,%r13
  69148a:	cmovbe %r13,%rax
  69148e:	mov    %rbp,%rdi
  691491:	mov    %rax,%rsi
  691494:	add    %r14,%r15
  691497:	call   6913b0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  69149c:	sub    %r14,%r13
  69149f:	cmp    %rbx,%r15
  6914a2:	jb     691470 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  6914a4:	add    $0x18,%rsp
  6914a8:	pop    %rbx
  6914a9:	pop    %rbp
  6914aa:	pop    %r12
  6914ac:	pop    %r13
  6914ae:	pop    %r14
  6914b0:	pop    %r15
  6914b2:	ret
  6914b3:	nopl   0x0(%rax,%rax,1)
  6914b8:	lea    0x8(%rdi),%r15
  6914bc:	xor    %r14d,%r14d
  6914bf:	test   %rdx,%rdx
  6914c2:	je     6914a4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  6914c4:	nopl   0x0(%rax)
  6914c8:	mov    (%r12,%r14,4),%edx
  6914cc:	mov    0x18(%rbp),%rsi
  6914d0:	mov    %r15,%rdi
  6914d3:	call   69c930 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  6914d8:	mov    0x8(%rsp),%rdi
  6914dd:	movzbl %al,%eax
  6914e0:	mov    %eax,(%rdi,%r14,4)
  6914e4:	inc    %r14
  6914e7:	cmp    %r14,%rbx
  6914ea:	jne    6914c8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  6914ec:	add    $0x18,%rsp
  6914f0:	pop    %rbx
  6914f1:	pop    %rbp
  6914f2:	pop    %r12
  6914f4:	pop    %r13
  6914f6:	pop    %r14
  6914f8:	pop    %r15
  6914fa:	ret
