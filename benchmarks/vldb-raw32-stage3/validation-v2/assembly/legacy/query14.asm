
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bd440 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bd440:	push   %r15
  4bd442:	push   %r14
  4bd444:	push   %r13
  4bd446:	push   %r12
  4bd448:	mov    %rcx,%r12
  4bd44b:	push   %rbp
  4bd44c:	mov    %rdx,%rbp
  4bd44f:	push   %rbx
  4bd450:	mov    %rdi,%rbx
  4bd453:	sub    $0x18,%rsp
  4bd457:	mov    %r8,0x8(%rsp)
  4bd45c:	test   %esi,%esi
  4bd45e:	je     4bd4c8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bd460:	cmp    $0x1,%esi
  4bd463:	mov    $0x1000,%r14d
  4bd469:	mov    $0x1,%eax
  4bd46e:	cmove  %rax,%r14
  4bd472:	test   %rdx,%rdx
  4bd475:	je     4bd4b4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bd477:	mov    %rdx,%r13
  4bd47a:	xor    %r15d,%r15d
  4bd47d:	nopl   (%rax)
  4bd480:	mov    0x8(%rsp),%rax
  4bd485:	lea    0x0(,%r15,4),%rdx
  4bd48d:	lea    (%rax,%rdx,1),%rcx
  4bd491:	add    %r12,%rdx
  4bd494:	mov    %r14,%rax
  4bd497:	cmp    %r14,%r13
  4bd49a:	cmovbe %r13,%rax
  4bd49e:	mov    %rbx,%rdi
  4bd4a1:	mov    %rax,%rsi
  4bd4a4:	add    %r14,%r15
  4bd4a7:	call   4bcfe0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bd4ac:	sub    %r14,%r13
  4bd4af:	cmp    %rbp,%r15
  4bd4b2:	jb     4bd480 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bd4b4:	add    $0x18,%rsp
  4bd4b8:	pop    %rbx
  4bd4b9:	pop    %rbp
  4bd4ba:	pop    %r12
  4bd4bc:	pop    %r13
  4bd4be:	pop    %r14
  4bd4c0:	pop    %r15
  4bd4c2:	ret
  4bd4c3:	nopl   0x0(%rax,%rax,1)
  4bd4c8:	xor    %esi,%esi
  4bd4ca:	mov    $0x1,%ecx
  4bd4cf:	mov    $0x20,%edi
  4bd4d4:	test   %rdx,%rdx
  4bd4d7:	je     4bd4b4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bd4d9:	nopl   0x0(%rax)
  4bd4e0:	mov    (%r12,%rsi,4),%edx
  4bd4e4:	imul   $0x16118b03,%edx,%r9d
  4bd4eb:	imul   $0x9e3779b9,%edx,%r8d
  4bd4f2:	imul   $0x238ef8e3,%edx,%edx
  4bd4f8:	mov    %r9d,%r10d
  4bd4fb:	mov    %r8d,%eax
  4bd4fe:	shr    $0x1a,%r10d
  4bd502:	shr    $0x1a,%eax
  4bd505:	shlx   %rax,%rcx,%rax
  4bd50a:	bts    %r10,%rax
  4bd50e:	mov    %r9d,%r10d
  4bd511:	shr    $0x14,%r10d
  4bd515:	shlx   %r10,%rcx,%r10
  4bd51a:	or     %r10,%rax
  4bd51d:	mov    %r9d,%r10d
  4bd520:	shr    $0xe,%r10d
  4bd524:	shlx   %r10,%rcx,%r10
  4bd529:	or     %r10,%rax
  4bd52c:	mov    %r9d,%r10d
  4bd52f:	shr    $0x8,%r10d
  4bd533:	shr    $0x2,%r9d
  4bd537:	shlx   %r10,%rcx,%r10
  4bd53c:	or     %r10,%rax
  4bd53f:	shlx   %r9,%rcx,%r9
  4bd544:	or     %r9,%rax
  4bd547:	mov    %r8d,%r9d
  4bd54a:	shr    $0x14,%r9d
  4bd54e:	shr    $0xe,%r8d
  4bd552:	shlx   %r9,%rcx,%r9
  4bd557:	or     %r9,%rax
  4bd55a:	shlx   %r8,%rcx,%r8
  4bd55f:	or     %r8,%rax
  4bd562:	mov    %edi,%r8d
  4bd565:	sub    0x4(%rbx),%r8d
  4bd569:	shrx   %r8d,%edx,%edx
  4bd56e:	mov    0x10(%rbx),%r8
  4bd572:	mov    (%r8,%rdx,8),%r11
  4bd576:	mov    0x8(%rsp),%rdx
  4bd57b:	and    %rax,%r11
  4bd57e:	cmp    %rax,%r11
  4bd581:	sete   %al
  4bd584:	movzbl %al,%eax
  4bd587:	mov    %eax,(%rdx,%rsi,4)
  4bd58a:	inc    %rsi
  4bd58d:	cmp    %rsi,%rbp
  4bd590:	jne    4bd4e0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  4bd596:	add    $0x18,%rsp
  4bd59a:	pop    %rbx
  4bd59b:	pop    %rbp
  4bd59c:	pop    %r12
  4bd59e:	pop    %r13
  4bd5a0:	pop    %r14
  4bd5a2:	pop    %r15
  4bd5a4:	ret
