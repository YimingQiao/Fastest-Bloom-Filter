
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000676710 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  676710:	push   %r15
  676712:	push   %r14
  676714:	mov    %rcx,%r14
  676717:	push   %r13
  676719:	mov    %rdx,%r13
  67671c:	push   %r12
  67671e:	push   %rbp
  67671f:	push   %rbx
  676720:	mov    %rdi,%rbx
  676723:	sub    $0x18,%rsp
  676727:	mov    %r8,0x8(%rsp)
  67672c:	test   %esi,%esi
  67672e:	je     6767a0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  676730:	cmp    $0x1,%esi
  676733:	mov    $0x1000,%ebp
  676738:	mov    $0x1,%eax
  67673d:	cmove  %rax,%rbp
  676741:	test   %rdx,%rdx
  676744:	je     676791 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  676746:	mov    %rdi,(%rsp)
  67674a:	mov    %rbp,%rbx
  67674d:	mov    0x8(%rsp),%rbp
  676752:	mov    %rdx,%r15
  676755:	xor    %r12d,%r12d
  676758:	nopl   0x0(%rax,%rax,1)
  676760:	lea    0x0(,%r12,4),%rdx
  676768:	lea    0x0(%rbp,%rdx,1),%rcx
  67676d:	mov    %rbx,%rax
  676770:	add    %r14,%rdx
  676773:	cmp    %rbx,%r15
  676776:	cmovbe %r15,%rax
  67677a:	mov    (%rsp),%rdi
  67677e:	mov    %rax,%rsi
  676781:	add    %rbx,%r12
  676784:	call   676070 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  676789:	sub    %rbx,%r15
  67678c:	cmp    %r13,%r12
  67678f:	jb     676760 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  676791:	add    $0x18,%rsp
  676795:	pop    %rbx
  676796:	pop    %rbp
  676797:	pop    %r12
  676799:	pop    %r13
  67679b:	pop    %r14
  67679d:	pop    %r15
  67679f:	ret
  6767a0:	xor    %edi,%edi
  6767a2:	mov    $0x1,%esi
  6767a7:	test   %rdx,%rdx
  6767aa:	je     676791 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  6767ac:	nopl   0x0(%rax)
  6767b0:	mov    (%r14,%rdi,4),%eax
  6767b4:	mov    $0x20,%ecx
  6767b9:	imul   $0x238ef8e3,%eax,%edx
  6767bf:	sub    0x4(%rbx),%ecx
  6767c2:	shrx   %ecx,%edx,%edx
  6767c7:	lea    0x0(,%rdx,8),%ecx
  6767ce:	mov    0x10(%rbx),%rdx
  6767d2:	lea    (%rdx,%rcx,8),%rcx
  6767d6:	imul   $0x16118b03,%eax,%edx
  6767dc:	imul   $0x9e3779b9,%eax,%eax
  6767e2:	mov    (%rcx),%r15
  6767e5:	mov    %edx,%r12d
  6767e8:	shr    $0x1a,%r12d
  6767ec:	shlx   %r12,%rsi,%r12
  6767f1:	mov    %edx,%ebp
  6767f3:	and    %r12,%r15
  6767f6:	mov    %edx,%r11d
  6767f9:	mov    %edx,%r10d
  6767fc:	mov    %eax,%r9d
  6767ff:	mov    %eax,%r8d
  676802:	shr    $0x14,%ebp
  676805:	shr    $0xe,%r11d
  676809:	shr    $0x8,%r10d
  67680d:	shr    $0x2,%edx
  676810:	shr    $0x1a,%r9d
  676814:	shr    $0x14,%r8d
  676818:	shr    $0xe,%eax
  67681b:	cmp    %r12,%r15
  67681e:	mov    0x8(%rcx),%r12
  676822:	sete   %r15b
  676826:	shlx   %rbp,%rsi,%rbp
  67682b:	and    %rbp,%r12
  67682e:	cmp    %rbp,%r12
  676831:	mov    0x10(%rcx),%r12
  676835:	sete   %bpl
  676839:	shlx   %r11,%rsi,%r11
  67683e:	and    %r11,%r12
  676841:	and    %r15d,%ebp
  676844:	cmp    %r11,%r12
  676847:	sete   %r11b
  67684b:	and    %ebp,%r11d
  67684e:	mov    0x18(%rcx),%rbp
  676852:	shlx   %r10,%rsi,%r10
  676857:	and    %r10,%rbp
  67685a:	cmp    %r10,%rbp
  67685d:	sete   %r10b
  676861:	and    %r11d,%r10d
  676864:	mov    0x20(%rcx),%r11
  676868:	shlx   %rdx,%rsi,%rdx
  67686d:	and    %rdx,%r11
  676870:	cmp    %rdx,%r11
  676873:	sete   %dl
  676876:	and    %r10d,%edx
  676879:	mov    0x28(%rcx),%r10
  67687d:	shlx   %r9,%rsi,%r9
  676882:	and    %r9,%r10
  676885:	cmp    %r9,%r10
  676888:	sete   %r9b
  67688c:	and    %r9d,%edx
  67688f:	mov    0x30(%rcx),%r9
  676893:	shlx   %r8,%rsi,%r8
  676898:	and    %r8,%r9
  67689b:	cmp    %r8,%r9
  67689e:	sete   %r8b
  6768a2:	and    %r8d,%edx
  6768a5:	mov    0x38(%rcx),%r8
  6768a9:	shlx   %rax,%rsi,%rax
  6768ae:	and    %rax,%r8
  6768b1:	cmp    %rax,%r8
  6768b4:	sete   %al
  6768b7:	mov    0x8(%rsp),%rcx
  6768bc:	movzbl %al,%eax
  6768bf:	and    %edx,%eax
  6768c1:	mov    %eax,(%rcx,%rdi,4)
  6768c4:	inc    %rdi
  6768c7:	cmp    %rdi,%r13
  6768ca:	jne    6767b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  6768d0:	add    $0x18,%rsp
  6768d4:	pop    %rbx
  6768d5:	pop    %rbp
  6768d6:	pop    %r12
  6768d8:	pop    %r13
  6768da:	pop    %r14
  6768dc:	pop    %r15
  6768de:	ret
