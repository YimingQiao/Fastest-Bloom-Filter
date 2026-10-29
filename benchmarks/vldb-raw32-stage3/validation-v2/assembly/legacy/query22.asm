
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000067e6b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  67e6b0:	push   %r15
  67e6b2:	push   %r14
  67e6b4:	mov    %rcx,%r14
  67e6b7:	push   %r13
  67e6b9:	mov    %rdx,%r13
  67e6bc:	push   %r12
  67e6be:	push   %rbp
  67e6bf:	push   %rbx
  67e6c0:	mov    %rdi,%rbx
  67e6c3:	sub    $0x18,%rsp
  67e6c7:	mov    %r8,0x8(%rsp)
  67e6cc:	test   %esi,%esi
  67e6ce:	je     67e740 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  67e6d0:	cmp    $0x1,%esi
  67e6d3:	mov    $0x1000,%ebp
  67e6d8:	mov    $0x1,%eax
  67e6dd:	cmove  %rax,%rbp
  67e6e1:	test   %rdx,%rdx
  67e6e4:	je     67e731 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67e6e6:	mov    %rdi,(%rsp)
  67e6ea:	mov    %rbp,%rbx
  67e6ed:	mov    0x8(%rsp),%rbp
  67e6f2:	mov    %rdx,%r15
  67e6f5:	xor    %r12d,%r12d
  67e6f8:	nopl   0x0(%rax,%rax,1)
  67e700:	lea    0x0(,%r12,4),%rdx
  67e708:	lea    0x0(%rbp,%rdx,1),%rcx
  67e70d:	mov    %rbx,%rax
  67e710:	add    %r14,%rdx
  67e713:	cmp    %rbx,%r15
  67e716:	cmovbe %r15,%rax
  67e71a:	mov    (%rsp),%rdi
  67e71e:	mov    %rax,%rsi
  67e721:	add    %rbx,%r12
  67e724:	call   67dfe0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  67e729:	sub    %rbx,%r15
  67e72c:	cmp    %r13,%r12
  67e72f:	jb     67e700 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  67e731:	add    $0x18,%rsp
  67e735:	pop    %rbx
  67e736:	pop    %rbp
  67e737:	pop    %r12
  67e739:	pop    %r13
  67e73b:	pop    %r14
  67e73d:	pop    %r15
  67e73f:	ret
  67e740:	xor    %edi,%edi
  67e742:	mov    $0x1,%esi
  67e747:	test   %rdx,%rdx
  67e74a:	je     67e731 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67e74c:	nopl   0x0(%rax)
  67e750:	mov    (%r14,%rdi,4),%eax
  67e754:	mov    $0x20,%ecx
  67e759:	imul   $0x238ef8e3,%eax,%edx
  67e75f:	sub    0x4(%rbx),%ecx
  67e762:	shrx   %ecx,%edx,%edx
  67e767:	lea    0x0(,%rdx,8),%ecx
  67e76e:	mov    0x10(%rbx),%rdx
  67e772:	lea    (%rdx,%rcx,8),%rcx
  67e776:	imul   $0x16118b03,%eax,%edx
  67e77c:	imul   $0x9e3779b9,%eax,%eax
  67e782:	mov    (%rcx),%r15
  67e785:	mov    %edx,%r12d
  67e788:	shr    $0x1a,%r12d
  67e78c:	shlx   %r12,%rsi,%r12
  67e791:	mov    %edx,%ebp
  67e793:	and    %r12,%r15
  67e796:	mov    %edx,%r11d
  67e799:	mov    %edx,%r10d
  67e79c:	mov    %eax,%r9d
  67e79f:	mov    %eax,%r8d
  67e7a2:	shr    $0x14,%ebp
  67e7a5:	shr    $0xe,%r11d
  67e7a9:	shr    $0x8,%r10d
  67e7ad:	shr    $0x2,%edx
  67e7b0:	shr    $0x1a,%r9d
  67e7b4:	shr    $0x14,%r8d
  67e7b8:	shr    $0xe,%eax
  67e7bb:	cmp    %r12,%r15
  67e7be:	mov    0x8(%rcx),%r12
  67e7c2:	sete   %r15b
  67e7c6:	shlx   %rbp,%rsi,%rbp
  67e7cb:	and    %rbp,%r12
  67e7ce:	cmp    %rbp,%r12
  67e7d1:	mov    0x10(%rcx),%r12
  67e7d5:	sete   %bpl
  67e7d9:	shlx   %r11,%rsi,%r11
  67e7de:	and    %r11,%r12
  67e7e1:	and    %r15d,%ebp
  67e7e4:	cmp    %r11,%r12
  67e7e7:	sete   %r11b
  67e7eb:	and    %ebp,%r11d
  67e7ee:	mov    0x18(%rcx),%rbp
  67e7f2:	shlx   %r10,%rsi,%r10
  67e7f7:	and    %r10,%rbp
  67e7fa:	cmp    %r10,%rbp
  67e7fd:	sete   %r10b
  67e801:	and    %r11d,%r10d
  67e804:	mov    0x20(%rcx),%r11
  67e808:	shlx   %rdx,%rsi,%rdx
  67e80d:	and    %rdx,%r11
  67e810:	cmp    %rdx,%r11
  67e813:	sete   %dl
  67e816:	and    %r10d,%edx
  67e819:	mov    0x28(%rcx),%r10
  67e81d:	shlx   %r9,%rsi,%r9
  67e822:	and    %r9,%r10
  67e825:	cmp    %r9,%r10
  67e828:	sete   %r9b
  67e82c:	and    %r9d,%edx
  67e82f:	mov    0x30(%rcx),%r9
  67e833:	shlx   %r8,%rsi,%r8
  67e838:	and    %r8,%r9
  67e83b:	cmp    %r8,%r9
  67e83e:	sete   %r8b
  67e842:	and    %r8d,%edx
  67e845:	mov    0x38(%rcx),%r8
  67e849:	shlx   %rax,%rsi,%rax
  67e84e:	and    %rax,%r8
  67e851:	cmp    %rax,%r8
  67e854:	sete   %al
  67e857:	mov    0x8(%rsp),%rcx
  67e85c:	movzbl %al,%eax
  67e85f:	and    %edx,%eax
  67e861:	mov    %eax,(%rcx,%rdi,4)
  67e864:	inc    %rdi
  67e867:	cmp    %rdi,%r13
  67e86a:	jne    67e750 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  67e870:	add    $0x18,%rsp
  67e874:	pop    %rbx
  67e875:	pop    %rbp
  67e876:	pop    %r12
  67e878:	pop    %r13
  67e87a:	pop    %r14
  67e87c:	pop    %r15
  67e87e:	ret
