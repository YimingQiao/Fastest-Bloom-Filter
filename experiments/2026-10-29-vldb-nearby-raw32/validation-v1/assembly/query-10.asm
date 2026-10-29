
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b500 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39b500:	push   %r15
  39b502:	push   %r14
  39b504:	push   %r13
  39b506:	push   %r12
  39b508:	mov    %rcx,%r12
  39b50b:	push   %rbp
  39b50c:	mov    %rdi,%rbp
  39b50f:	push   %rbx
  39b510:	mov    %rdx,%rbx
  39b513:	sub    $0x18,%rsp
  39b517:	mov    %r8,0x8(%rsp)
  39b51c:	test   %esi,%esi
  39b51e:	je     39b588 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39b520:	cmp    $0x1,%esi
  39b523:	mov    $0x1000,%r14d
  39b529:	mov    $0x1,%eax
  39b52e:	cmove  %rax,%r14
  39b532:	test   %rdx,%rdx
  39b535:	je     39b574 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b537:	mov    %rdx,%r13
  39b53a:	xor    %r15d,%r15d
  39b53d:	nopl   (%rax)
  39b540:	mov    0x8(%rsp),%rax
  39b545:	lea    0x0(,%r15,4),%rdx
  39b54d:	lea    (%rax,%rdx,1),%rcx
  39b551:	add    %r12,%rdx
  39b554:	mov    %r14,%rax
  39b557:	cmp    %r14,%r13
  39b55a:	cmovbe %r13,%rax
  39b55e:	mov    %rbp,%rdi
  39b561:	mov    %rax,%rsi
  39b564:	add    %r14,%r15
  39b567:	call   39b480 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  39b56c:	sub    %r14,%r13
  39b56f:	cmp    %rbx,%r15
  39b572:	jb     39b540 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39b574:	add    $0x18,%rsp
  39b578:	pop    %rbx
  39b579:	pop    %rbp
  39b57a:	pop    %r12
  39b57c:	pop    %r13
  39b57e:	pop    %r14
  39b580:	pop    %r15
  39b582:	ret
  39b583:	nopl   0x0(%rax,%rax,1)
  39b588:	lea    0x8(%rdi),%r15
  39b58c:	xor    %r14d,%r14d
  39b58f:	test   %rdx,%rdx
  39b592:	je     39b574 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b594:	nopl   0x0(%rax)
  39b598:	mov    (%r12,%r14,4),%edx
  39b59c:	mov    0x18(%rbp),%rsi
  39b5a0:	mov    %r15,%rdi
  39b5a3:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39b5a8:	mov    0x8(%rsp),%rdi
  39b5ad:	movzbl %al,%eax
  39b5b0:	mov    %eax,(%rdi,%r14,4)
  39b5b4:	inc    %r14
  39b5b7:	cmp    %r14,%rbx
  39b5ba:	jne    39b598 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39b5bc:	add    $0x18,%rsp
  39b5c0:	pop    %rbx
  39b5c1:	pop    %rbp
  39b5c2:	pop    %r12
  39b5c4:	pop    %r13
  39b5c6:	pop    %r14
  39b5c8:	pop    %r15
  39b5ca:	ret
