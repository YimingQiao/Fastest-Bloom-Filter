
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000006776d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  6776d0:	push   %r15
  6776d2:	push   %r14
  6776d4:	mov    %rcx,%r14
  6776d7:	push   %r13
  6776d9:	mov    %rdx,%r13
  6776dc:	push   %r12
  6776de:	push   %rbp
  6776df:	push   %rbx
  6776e0:	mov    %rdi,%rbx
  6776e3:	sub    $0x18,%rsp
  6776e7:	mov    %r8,0x8(%rsp)
  6776ec:	test   %esi,%esi
  6776ee:	je     677760 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  6776f0:	cmp    $0x1,%esi
  6776f3:	mov    $0x1000,%ebp
  6776f8:	mov    $0x1,%eax
  6776fd:	cmove  %rax,%rbp
  677701:	test   %rdx,%rdx
  677704:	je     677751 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  677706:	mov    %rdi,(%rsp)
  67770a:	mov    %rbp,%rbx
  67770d:	mov    0x8(%rsp),%rbp
  677712:	mov    %rdx,%r15
  677715:	xor    %r12d,%r12d
  677718:	nopl   0x0(%rax,%rax,1)
  677720:	lea    0x0(,%r12,4),%rdx
  677728:	lea    0x0(%rbp,%rdx,1),%rcx
  67772d:	mov    %rbx,%rax
  677730:	add    %r14,%rdx
  677733:	cmp    %rbx,%r15
  677736:	cmovbe %r15,%rax
  67773a:	mov    (%rsp),%rdi
  67773e:	mov    %rax,%rsi
  677741:	add    %rbx,%r12
  677744:	call   676f90 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  677749:	sub    %rbx,%r15
  67774c:	cmp    %r13,%r12
  67774f:	jb     677720 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  677751:	add    $0x18,%rsp
  677755:	pop    %rbx
  677756:	pop    %rbp
  677757:	pop    %r12
  677759:	pop    %r13
  67775b:	pop    %r14
  67775d:	pop    %r15
  67775f:	ret
  677760:	xor    %edi,%edi
  677762:	mov    $0x1,%esi
  677767:	test   %rdx,%rdx
  67776a:	je     677751 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67776c:	nopl   0x0(%rax)
  677770:	mov    (%r14,%rdi,4),%eax
  677774:	mov    0xc(%rbx),%edx
  677777:	imul   $0x238ef8e3,%eax,%r8d
  67777e:	imul   %r8,%rdx
  677782:	mov    %r8,%rcx
  677785:	mov    0x10(%rbx),%r8d
  677789:	shr    $0x20,%rdx
  67778d:	shrx   %r8d,%edx,%edx
  677792:	imul   0x14(%rbx),%edx
  677796:	sub    %edx,%ecx
  677798:	mov    0x18(%rbx),%rdx
  67779c:	lea    0x0(,%rcx,8),%ecx
  6777a3:	lea    (%rdx,%rcx,8),%rcx
  6777a7:	imul   $0x16118b03,%eax,%edx
  6777ad:	imul   $0x9e3779b9,%eax,%eax
  6777b3:	mov    (%rcx),%r15
  6777b6:	mov    %edx,%r12d
  6777b9:	shr    $0x1a,%r12d
  6777bd:	shlx   %r12,%rsi,%r12
  6777c2:	mov    %edx,%ebp
  6777c4:	and    %r12,%r15
  6777c7:	mov    %edx,%r11d
  6777ca:	mov    %edx,%r10d
  6777cd:	mov    %eax,%r9d
  6777d0:	mov    %eax,%r8d
  6777d3:	shr    $0x14,%ebp
  6777d6:	shr    $0xe,%r11d
  6777da:	shr    $0x8,%r10d
  6777de:	shr    $0x2,%edx
  6777e1:	shr    $0x1a,%r9d
  6777e5:	shr    $0x14,%r8d
  6777e9:	shr    $0xe,%eax
  6777ec:	cmp    %r12,%r15
  6777ef:	mov    0x8(%rcx),%r12
  6777f3:	sete   %r15b
  6777f7:	shlx   %rbp,%rsi,%rbp
  6777fc:	and    %rbp,%r12
  6777ff:	cmp    %rbp,%r12
  677802:	mov    0x10(%rcx),%r12
  677806:	sete   %bpl
  67780a:	shlx   %r11,%rsi,%r11
  67780f:	and    %r11,%r12
  677812:	and    %r15d,%ebp
  677815:	cmp    %r11,%r12
  677818:	sete   %r11b
  67781c:	and    %ebp,%r11d
  67781f:	mov    0x18(%rcx),%rbp
  677823:	shlx   %r10,%rsi,%r10
  677828:	and    %r10,%rbp
  67782b:	cmp    %r10,%rbp
  67782e:	sete   %r10b
  677832:	and    %r11d,%r10d
  677835:	mov    0x20(%rcx),%r11
  677839:	shlx   %rdx,%rsi,%rdx
  67783e:	and    %rdx,%r11
  677841:	cmp    %rdx,%r11
  677844:	sete   %dl
  677847:	and    %r10d,%edx
  67784a:	mov    0x28(%rcx),%r10
  67784e:	shlx   %r9,%rsi,%r9
  677853:	and    %r9,%r10
  677856:	cmp    %r9,%r10
  677859:	sete   %r9b
  67785d:	and    %r9d,%edx
  677860:	mov    0x30(%rcx),%r9
  677864:	mov    0x38(%rcx),%r15
  677868:	shlx   %r8,%rsi,%r8
  67786d:	and    %r8,%r9
  677870:	cmp    %r8,%r9
  677873:	sete   %r8b
  677877:	shlx   %rax,%rsi,%rax
  67787c:	and    %rax,%r15
  67787f:	and    %r8d,%edx
  677882:	cmp    %rax,%r15
  677885:	sete   %al
  677888:	mov    0x8(%rsp),%rcx
  67788d:	movzbl %al,%eax
  677890:	and    %edx,%eax
  677892:	mov    %eax,(%rcx,%rdi,4)
  677895:	inc    %rdi
  677898:	cmp    %rdi,%r13
  67789b:	jne    677770 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  6778a1:	add    $0x18,%rsp
  6778a5:	pop    %rbx
  6778a6:	pop    %rbp
  6778a7:	pop    %r12
  6778a9:	pop    %r13
  6778ab:	pop    %r14
  6778ad:	pop    %r15
  6778af:	ret
