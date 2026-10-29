
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000689510 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  689510:	push   %r15
  689512:	push   %r14
  689514:	push   %r13
  689516:	push   %r12
  689518:	mov    %rcx,%r12
  68951b:	push   %rbp
  68951c:	mov    %rdi,%rbp
  68951f:	push   %rbx
  689520:	mov    %rdx,%rbx
  689523:	sub    $0x18,%rsp
  689527:	mov    %r8,0x8(%rsp)
  68952c:	test   %esi,%esi
  68952e:	je     689598 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  689530:	cmp    $0x1,%esi
  689533:	mov    $0x1000,%r14d
  689539:	mov    $0x1,%eax
  68953e:	cmove  %rax,%r14
  689542:	test   %rdx,%rdx
  689545:	je     689584 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  689547:	mov    %rdx,%r13
  68954a:	xor    %r15d,%r15d
  68954d:	nopl   (%rax)
  689550:	mov    0x8(%rsp),%rax
  689555:	lea    0x0(,%r15,4),%rdx
  68955d:	lea    (%rax,%rdx,1),%rcx
  689561:	add    %r12,%rdx
  689564:	mov    %r14,%rax
  689567:	cmp    %r14,%r13
  68956a:	cmovbe %r13,%rax
  68956e:	mov    %rbp,%rdi
  689571:	mov    %rax,%rsi
  689574:	add    %r14,%r15
  689577:	call   689490 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  68957c:	sub    %r14,%r13
  68957f:	cmp    %rbx,%r15
  689582:	jb     689550 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  689584:	add    $0x18,%rsp
  689588:	pop    %rbx
  689589:	pop    %rbp
  68958a:	pop    %r12
  68958c:	pop    %r13
  68958e:	pop    %r14
  689590:	pop    %r15
  689592:	ret
  689593:	nopl   0x0(%rax,%rax,1)
  689598:	lea    0x8(%rdi),%r15
  68959c:	xor    %r14d,%r14d
  68959f:	test   %rdx,%rdx
  6895a2:	je     689584 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  6895a4:	nopl   0x0(%rax)
  6895a8:	mov    (%r12,%r14,4),%edx
  6895ac:	mov    0x18(%rbp),%rsi
  6895b0:	mov    %r15,%rdi
  6895b3:	call   6917a0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  6895b8:	mov    0x8(%rsp),%rdi
  6895bd:	movzbl %al,%eax
  6895c0:	mov    %eax,(%rdi,%r14,4)
  6895c4:	inc    %r14
  6895c7:	cmp    %r14,%rbx
  6895ca:	jne    6895a8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  6895cc:	add    $0x18,%rsp
  6895d0:	pop    %rbx
  6895d1:	pop    %rbp
  6895d2:	pop    %r12
  6895d4:	pop    %r13
  6895d6:	pop    %r14
  6895d8:	pop    %r15
  6895da:	ret
