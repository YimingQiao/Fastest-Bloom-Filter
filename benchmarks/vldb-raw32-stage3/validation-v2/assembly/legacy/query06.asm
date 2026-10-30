
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000679880 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  679880:	push   %r15
  679882:	push   %r14
  679884:	mov    %rcx,%r14
  679887:	push   %r13
  679889:	mov    %rdx,%r13
  67988c:	push   %r12
  67988e:	push   %rbp
  67988f:	push   %rbx
  679890:	mov    %rdi,%rbx
  679893:	sub    $0x18,%rsp
  679897:	mov    %r8,0x8(%rsp)
  67989c:	test   %esi,%esi
  67989e:	je     679910 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  6798a0:	cmp    $0x1,%esi
  6798a3:	mov    $0x1000,%ebp
  6798a8:	mov    $0x1,%eax
  6798ad:	cmove  %rax,%rbp
  6798b1:	test   %rdx,%rdx
  6798b4:	je     679901 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  6798b6:	mov    %rdi,(%rsp)
  6798ba:	mov    %rbp,%rbx
  6798bd:	mov    0x8(%rsp),%rbp
  6798c2:	mov    %rdx,%r15
  6798c5:	xor    %r12d,%r12d
  6798c8:	nopl   0x0(%rax,%rax,1)
  6798d0:	lea    0x0(,%r12,4),%rdx
  6798d8:	lea    0x0(%rbp,%rdx,1),%rcx
  6798dd:	mov    %rbx,%rax
  6798e0:	add    %r14,%rdx
  6798e3:	cmp    %rbx,%r15
  6798e6:	cmovbe %r15,%rax
  6798ea:	mov    (%rsp),%rdi
  6798ee:	mov    %rax,%rsi
  6798f1:	add    %rbx,%r12
  6798f4:	call   679300 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  6798f9:	sub    %rbx,%r15
  6798fc:	cmp    %r13,%r12
  6798ff:	jb     6798d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  679901:	add    $0x18,%rsp
  679905:	pop    %rbx
  679906:	pop    %rbp
  679907:	pop    %r12
  679909:	pop    %r13
  67990b:	pop    %r14
  67990d:	pop    %r15
  67990f:	ret
  679910:	xor    %edi,%edi
  679912:	mov    $0x1,%esi
  679917:	test   %rdx,%rdx
  67991a:	je     679901 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67991c:	nopl   0x0(%rax)
  679920:	mov    (%r14,%rdi,4),%eax
  679924:	mov    $0x20,%ecx
  679929:	imul   $0x238ef8e3,%eax,%edx
  67992f:	sub    0x4(%rbx),%ecx
  679932:	shrx   %ecx,%edx,%edx
  679937:	lea    0x0(,%rdx,8),%ecx
  67993e:	mov    0x10(%rbx),%rdx
  679942:	lea    (%rdx,%rcx,4),%rcx
  679946:	imul   $0x16118b03,%eax,%edx
  67994c:	imul   $0x9e3779b9,%eax,%eax
  679952:	mov    (%rcx),%r15d
  679955:	mov    %edx,%r12d
  679958:	shr    $0x1b,%r12d
  67995c:	shlx   %r12d,%esi,%r12d
  679961:	mov    %edx,%ebp
  679963:	and    %r12d,%r15d
  679966:	mov    %edx,%r11d
  679969:	mov    %edx,%r10d
  67996c:	mov    %edx,%r9d
  67996f:	mov    %eax,%r8d
  679972:	shr    $0x16,%ebp
  679975:	shr    $0x11,%r11d
  679979:	shr    $0xc,%r10d
  67997d:	shr    $0x7,%r9d
  679981:	shr    $0x2,%edx
  679984:	shr    $0x1b,%r8d
  679988:	shr    $0x16,%eax
  67998b:	cmp    %r12d,%r15d
  67998e:	mov    0x4(%rcx),%r12d
  679992:	sete   %r15b
  679996:	shlx   %ebp,%esi,%ebp
  67999b:	and    %ebp,%r12d
  67999e:	cmp    %ebp,%r12d
  6799a1:	mov    0x8(%rcx),%r12d
  6799a5:	sete   %bpl
  6799a9:	shlx   %r11d,%esi,%r11d
  6799ae:	and    %r11d,%r12d
  6799b1:	and    %r15d,%ebp
  6799b4:	cmp    %r11d,%r12d
  6799b7:	sete   %r11b
  6799bb:	and    %ebp,%r11d
  6799be:	mov    0xc(%rcx),%ebp
  6799c1:	shlx   %r10d,%esi,%r10d
  6799c6:	and    %r10d,%ebp
  6799c9:	cmp    %r10d,%ebp
  6799cc:	sete   %r10b
  6799d0:	and    %r11d,%r10d
  6799d3:	mov    0x10(%rcx),%r11d
  6799d7:	shlx   %r9d,%esi,%r9d
  6799dc:	and    %r9d,%r11d
  6799df:	cmp    %r9d,%r11d
  6799e2:	sete   %r9b
  6799e6:	and    %r10d,%r9d
  6799e9:	mov    0x14(%rcx),%r10d
  6799ed:	shlx   %edx,%esi,%edx
  6799f2:	and    %edx,%r10d
  6799f5:	cmp    %edx,%r10d
  6799f8:	sete   %dl
  6799fb:	and    %r9d,%edx
  6799fe:	mov    0x18(%rcx),%r9d
  679a02:	shlx   %r8d,%esi,%r8d
  679a07:	and    %r8d,%r9d
  679a0a:	cmp    %r8d,%r9d
  679a0d:	sete   %r8b
  679a11:	and    %r8d,%edx
  679a14:	mov    0x1c(%rcx),%r8d
  679a18:	shlx   %eax,%esi,%eax
  679a1d:	and    %eax,%r8d
  679a20:	cmp    %eax,%r8d
  679a23:	sete   %al
  679a26:	mov    0x8(%rsp),%rcx
  679a2b:	movzbl %al,%eax
  679a2e:	and    %edx,%eax
  679a30:	mov    %eax,(%rcx,%rdi,4)
  679a33:	inc    %rdi
  679a36:	cmp    %rdi,%r13
  679a39:	jne    679920 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  679a3f:	add    $0x18,%rsp
  679a43:	pop    %rbx
  679a44:	pop    %rbp
  679a45:	pop    %r12
  679a47:	pop    %r13
  679a49:	pop    %r14
  679a4b:	pop    %r15
  679a4d:	ret
