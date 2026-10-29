
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000006817d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  6817d0:	push   %r15
  6817d2:	push   %r14
  6817d4:	mov    %rcx,%r14
  6817d7:	push   %r13
  6817d9:	mov    %rdx,%r13
  6817dc:	push   %r12
  6817de:	push   %rbp
  6817df:	push   %rbx
  6817e0:	mov    %rdi,%rbx
  6817e3:	sub    $0x18,%rsp
  6817e7:	mov    %r8,0x8(%rsp)
  6817ec:	test   %esi,%esi
  6817ee:	je     681860 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  6817f0:	cmp    $0x1,%esi
  6817f3:	mov    $0x1000,%ebp
  6817f8:	mov    $0x1,%eax
  6817fd:	cmove  %rax,%rbp
  681801:	test   %rdx,%rdx
  681804:	je     681851 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  681806:	mov    %rdi,(%rsp)
  68180a:	mov    %rbp,%rbx
  68180d:	mov    0x8(%rsp),%rbp
  681812:	mov    %rdx,%r15
  681815:	xor    %r12d,%r12d
  681818:	nopl   0x0(%rax,%rax,1)
  681820:	lea    0x0(,%r12,4),%rdx
  681828:	lea    0x0(%rbp,%rdx,1),%rcx
  68182d:	mov    %rbx,%rax
  681830:	add    %r14,%rdx
  681833:	cmp    %rbx,%r15
  681836:	cmovbe %r15,%rax
  68183a:	mov    (%rsp),%rdi
  68183e:	mov    %rax,%rsi
  681841:	add    %rbx,%r12
  681844:	call   680ea0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  681849:	sub    %rbx,%r15
  68184c:	cmp    %r13,%r12
  68184f:	jb     681820 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  681851:	add    $0x18,%rsp
  681855:	pop    %rbx
  681856:	pop    %rbp
  681857:	pop    %r12
  681859:	pop    %r13
  68185b:	pop    %r14
  68185d:	pop    %r15
  68185f:	ret
  681860:	xor    %edi,%edi
  681862:	mov    $0x1,%esi
  681867:	test   %rdx,%rdx
  68186a:	je     681851 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  68186c:	nopl   0x0(%rax)
  681870:	mov    (%r14,%rdi,4),%eax
  681874:	mov    $0x20,%ecx
  681879:	imul   $0x238ef8e3,%eax,%edx
  68187f:	sub    0x4(%rbx),%ecx
  681882:	shrx   %ecx,%edx,%edx
  681887:	lea    0x0(,%rdx,8),%ecx
  68188e:	mov    0x10(%rbx),%rdx
  681892:	lea    (%rdx,%rcx,8),%rcx
  681896:	imul   $0x16118b03,%eax,%edx
  68189c:	imul   $0x9e3779b9,%eax,%eax
  6818a2:	mov    (%rcx),%r15
  6818a5:	mov    %edx,%r12d
  6818a8:	shr    $0x1a,%r12d
  6818ac:	shlx   %r12,%rsi,%r12
  6818b1:	mov    %edx,%ebp
  6818b3:	and    %r12,%r15
  6818b6:	mov    %edx,%r11d
  6818b9:	mov    %edx,%r10d
  6818bc:	mov    %eax,%r9d
  6818bf:	mov    %eax,%r8d
  6818c2:	shr    $0x14,%ebp
  6818c5:	shr    $0xe,%r11d
  6818c9:	shr    $0x8,%r10d
  6818cd:	shr    $0x2,%edx
  6818d0:	shr    $0x1a,%r9d
  6818d4:	shr    $0x14,%r8d
  6818d8:	shr    $0xe,%eax
  6818db:	cmp    %r12,%r15
  6818de:	mov    0x8(%rcx),%r12
  6818e2:	sete   %r15b
  6818e6:	shlx   %rbp,%rsi,%rbp
  6818eb:	and    %rbp,%r12
  6818ee:	cmp    %rbp,%r12
  6818f1:	mov    0x10(%rcx),%r12
  6818f5:	sete   %bpl
  6818f9:	shlx   %r11,%rsi,%r11
  6818fe:	and    %r11,%r12
  681901:	and    %r15d,%ebp
  681904:	cmp    %r11,%r12
  681907:	sete   %r11b
  68190b:	and    %ebp,%r11d
  68190e:	mov    0x18(%rcx),%rbp
  681912:	shlx   %r10,%rsi,%r10
  681917:	and    %r10,%rbp
  68191a:	cmp    %r10,%rbp
  68191d:	sete   %r10b
  681921:	and    %r11d,%r10d
  681924:	mov    0x20(%rcx),%r11
  681928:	shlx   %rdx,%rsi,%rdx
  68192d:	and    %rdx,%r11
  681930:	cmp    %rdx,%r11
  681933:	sete   %dl
  681936:	and    %r10d,%edx
  681939:	mov    0x28(%rcx),%r10
  68193d:	shlx   %r9,%rsi,%r9
  681942:	and    %r9,%r10
  681945:	cmp    %r9,%r10
  681948:	sete   %r9b
  68194c:	and    %r9d,%edx
  68194f:	mov    0x30(%rcx),%r9
  681953:	shlx   %r8,%rsi,%r8
  681958:	and    %r8,%r9
  68195b:	cmp    %r8,%r9
  68195e:	sete   %r8b
  681962:	and    %r8d,%edx
  681965:	mov    0x38(%rcx),%r8
  681969:	shlx   %rax,%rsi,%rax
  68196e:	and    %rax,%r8
  681971:	cmp    %rax,%r8
  681974:	sete   %al
  681977:	mov    0x8(%rsp),%rcx
  68197c:	movzbl %al,%eax
  68197f:	and    %edx,%eax
  681981:	mov    %eax,(%rcx,%rdi,4)
  681984:	inc    %rdi
  681987:	cmp    %rdi,%r13
  68198a:	jne    681870 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  681990:	add    $0x18,%rsp
  681994:	pop    %rbx
  681995:	pop    %rbp
  681996:	pop    %r12
  681998:	pop    %r13
  68199a:	pop    %r14
  68199c:	pop    %r15
  68199e:	ret
