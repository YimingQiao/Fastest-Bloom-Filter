
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000391490 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  391490:	push   %r15
  391492:	push   %r14
  391494:	push   %r13
  391496:	push   %r12
  391498:	mov    %rcx,%r12
  39149b:	push   %rbp
  39149c:	mov    %rdi,%rbp
  39149f:	push   %rbx
  3914a0:	mov    %rdx,%rbx
  3914a3:	sub    $0x18,%rsp
  3914a7:	mov    %r8,0x8(%rsp)
  3914ac:	test   %esi,%esi
  3914ae:	je     391518 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  3914b0:	cmp    $0x1,%esi
  3914b3:	mov    $0x1000,%r14d
  3914b9:	mov    $0x1,%eax
  3914be:	cmove  %rax,%r14
  3914c2:	test   %rdx,%rdx
  3914c5:	je     391504 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  3914c7:	mov    %rdx,%r13
  3914ca:	xor    %r15d,%r15d
  3914cd:	nopl   (%rax)
  3914d0:	mov    0x8(%rsp),%rax
  3914d5:	lea    0x0(,%r15,4),%rdx
  3914dd:	lea    (%rax,%rdx,1),%rcx
  3914e1:	add    %r12,%rdx
  3914e4:	mov    %r14,%rax
  3914e7:	cmp    %r14,%r13
  3914ea:	cmovbe %r13,%rax
  3914ee:	mov    %rbp,%rdi
  3914f1:	mov    %rax,%rsi
  3914f4:	add    %r14,%r15
  3914f7:	call   391410 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  3914fc:	sub    %r14,%r13
  3914ff:	cmp    %rbx,%r15
  391502:	jb     3914d0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  391504:	add    $0x18,%rsp
  391508:	pop    %rbx
  391509:	pop    %rbp
  39150a:	pop    %r12
  39150c:	pop    %r13
  39150e:	pop    %r14
  391510:	pop    %r15
  391512:	ret
  391513:	nopl   0x0(%rax,%rax,1)
  391518:	lea    0x8(%rdi),%r15
  39151c:	xor    %r14d,%r14d
  39151f:	test   %rdx,%rdx
  391522:	je     391504 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  391524:	nopl   0x0(%rax)
  391528:	mov    (%r12,%r14,4),%edx
  39152c:	mov    0x18(%rbp),%rsi
  391530:	mov    %r15,%rdi
  391533:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  391538:	mov    0x8(%rsp),%rdi
  39153d:	movzbl %al,%eax
  391540:	mov    %eax,(%rdi,%r14,4)
  391544:	inc    %r14
  391547:	cmp    %r14,%rbx
  39154a:	jne    391528 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39154c:	add    $0x18,%rsp
  391550:	pop    %rbx
  391551:	pop    %rbp
  391552:	pop    %r12
  391554:	pop    %r13
  391556:	pop    %r14
  391558:	pop    %r15
  39155a:	ret
