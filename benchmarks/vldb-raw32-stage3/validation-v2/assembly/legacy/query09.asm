
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bb580 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bb580:	push   %r15
  4bb582:	push   %r14
  4bb584:	push   %r13
  4bb586:	push   %r12
  4bb588:	mov    %rcx,%r12
  4bb58b:	push   %rbp
  4bb58c:	mov    %rdx,%rbp
  4bb58f:	push   %rbx
  4bb590:	mov    %rdi,%rbx
  4bb593:	sub    $0x28,%rsp
  4bb597:	mov    %r8,0x8(%rsp)
  4bb59c:	test   %esi,%esi
  4bb59e:	je     4bb608 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bb5a0:	cmp    $0x1,%esi
  4bb5a3:	mov    $0x1000,%r14d
  4bb5a9:	mov    $0x1,%eax
  4bb5ae:	cmove  %rax,%r14
  4bb5b2:	test   %rdx,%rdx
  4bb5b5:	je     4bb5f4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bb5b7:	mov    %rdx,%r13
  4bb5ba:	xor    %r15d,%r15d
  4bb5bd:	nopl   (%rax)
  4bb5c0:	mov    0x8(%rsp),%rax
  4bb5c5:	lea    0x0(,%r15,4),%rdx
  4bb5cd:	lea    (%rax,%rdx,1),%rcx
  4bb5d1:	add    %r12,%rdx
  4bb5d4:	mov    %r14,%rax
  4bb5d7:	cmp    %r14,%r13
  4bb5da:	cmovbe %r13,%rax
  4bb5de:	mov    %rbx,%rdi
  4bb5e1:	mov    %rax,%rsi
  4bb5e4:	add    %r14,%r15
  4bb5e7:	call   4bb4c0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bb5ec:	sub    %r14,%r13
  4bb5ef:	cmp    %rbp,%r15
  4bb5f2:	jb     4bb5c0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bb5f4:	add    $0x28,%rsp
  4bb5f8:	pop    %rbx
  4bb5f9:	pop    %rbp
  4bb5fa:	pop    %r12
  4bb5fc:	pop    %r13
  4bb5fe:	pop    %r14
  4bb600:	pop    %r15
  4bb602:	ret
  4bb603:	nopl   0x0(%rax,%rax,1)
  4bb608:	xor    %r14d,%r14d
  4bb60b:	lea    0x14(%rsp),%r15
  4bb610:	test   %rdx,%rdx
  4bb613:	je     4bb5f4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bb615:	nopl   (%rax)
  4bb618:	mov    (%r12,%r14,4),%eax
  4bb61c:	mov    0xc0(%rbx),%rdx
  4bb623:	cmpq   $0x0,0x90(%rbx)
  4bb62b:	mov    %rdx,0x18(%rsp)
  4bb630:	mov    %eax,0x14(%rsp)
  4bb634:	je     4bb66e <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bb636:	lea    0x80(%rbx),%rdi
  4bb63d:	lea    0x18(%rsp),%rsi
  4bb642:	mov    %r15,%rdx
  4bb645:	call   *0x98(%rbx)
  4bb64b:	mov    0x8(%rsp),%rdi
  4bb650:	movzbl %al,%eax
  4bb653:	mov    %eax,(%rdi,%r14,4)
  4bb657:	inc    %r14
  4bb65a:	cmp    %r14,%rbp
  4bb65d:	jne    4bb618 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bb65f:	add    $0x28,%rsp
  4bb663:	pop    %rbx
  4bb664:	pop    %rbp
  4bb665:	pop    %r12
  4bb667:	pop    %r13
  4bb669:	pop    %r14
  4bb66b:	pop    %r15
  4bb66d:	ret
  4bb66e:	call   1948ca0 <std::__throw_bad_function_call()@plt>
