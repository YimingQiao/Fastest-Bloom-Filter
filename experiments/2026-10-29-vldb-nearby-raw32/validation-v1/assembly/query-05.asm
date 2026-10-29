
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003915f0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  3915f0:	push   %r15
  3915f2:	push   %r14
  3915f4:	push   %r13
  3915f6:	push   %r12
  3915f8:	mov    %rcx,%r12
  3915fb:	push   %rbp
  3915fc:	mov    %rdi,%rbp
  3915ff:	push   %rbx
  391600:	mov    %rdx,%rbx
  391603:	sub    $0x18,%rsp
  391607:	mov    %r8,0x8(%rsp)
  39160c:	test   %esi,%esi
  39160e:	je     391678 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  391610:	cmp    $0x1,%esi
  391613:	mov    $0x1000,%r14d
  391619:	mov    $0x1,%eax
  39161e:	cmove  %rax,%r14
  391622:	test   %rdx,%rdx
  391625:	je     391664 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  391627:	mov    %rdx,%r13
  39162a:	xor    %r15d,%r15d
  39162d:	nopl   (%rax)
  391630:	mov    0x8(%rsp),%rax
  391635:	lea    0x0(,%r15,4),%rdx
  39163d:	lea    (%rax,%rdx,1),%rcx
  391641:	add    %r12,%rdx
  391644:	mov    %r14,%rax
  391647:	cmp    %r14,%r13
  39164a:	cmovbe %r13,%rax
  39164e:	mov    %rbp,%rdi
  391651:	mov    %rax,%rsi
  391654:	add    %r14,%r15
  391657:	call   391570 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39165c:	sub    %r14,%r13
  39165f:	cmp    %rbx,%r15
  391662:	jb     391630 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  391664:	add    $0x18,%rsp
  391668:	pop    %rbx
  391669:	pop    %rbp
  39166a:	pop    %r12
  39166c:	pop    %r13
  39166e:	pop    %r14
  391670:	pop    %r15
  391672:	ret
  391673:	nopl   0x0(%rax,%rax,1)
  391678:	lea    0x8(%rdi),%r15
  39167c:	xor    %r14d,%r14d
  39167f:	test   %rdx,%rdx
  391682:	je     391664 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  391684:	nopl   0x0(%rax)
  391688:	mov    (%r12,%r14,4),%edx
  39168c:	mov    0x18(%rbp),%rsi
  391690:	mov    %r15,%rdi
  391693:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  391698:	mov    0x8(%rsp),%rdi
  39169d:	movzbl %al,%eax
  3916a0:	mov    %eax,(%rdi,%r14,4)
  3916a4:	inc    %r14
  3916a7:	cmp    %r14,%rbx
  3916aa:	jne    391688 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  3916ac:	add    $0x18,%rsp
  3916b0:	pop    %rbx
  3916b1:	pop    %rbp
  3916b2:	pop    %r12
  3916b4:	pop    %r13
  3916b6:	pop    %r14
  3916b8:	pop    %r15
  3916ba:	ret
