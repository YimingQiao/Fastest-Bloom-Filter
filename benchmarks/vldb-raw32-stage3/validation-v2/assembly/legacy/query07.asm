
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000067a670 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  67a670:	push   %r15
  67a672:	push   %r14
  67a674:	mov    %rcx,%r14
  67a677:	push   %r13
  67a679:	mov    %rdx,%r13
  67a67c:	push   %r12
  67a67e:	push   %rbp
  67a67f:	push   %rbx
  67a680:	mov    %rdi,%rbx
  67a683:	sub    $0x18,%rsp
  67a687:	mov    %r8,0x8(%rsp)
  67a68c:	test   %esi,%esi
  67a68e:	je     67a700 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  67a690:	cmp    $0x1,%esi
  67a693:	mov    $0x1000,%ebp
  67a698:	mov    $0x1,%eax
  67a69d:	cmove  %rax,%rbp
  67a6a1:	test   %rdx,%rdx
  67a6a4:	je     67a6f1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67a6a6:	mov    %rdi,(%rsp)
  67a6aa:	mov    %rbp,%rbx
  67a6ad:	mov    0x8(%rsp),%rbp
  67a6b2:	mov    %rdx,%r15
  67a6b5:	xor    %r12d,%r12d
  67a6b8:	nopl   0x0(%rax,%rax,1)
  67a6c0:	lea    0x0(,%r12,4),%rdx
  67a6c8:	lea    0x0(%rbp,%rdx,1),%rcx
  67a6cd:	mov    %rbx,%rax
  67a6d0:	add    %r14,%rdx
  67a6d3:	cmp    %rbx,%r15
  67a6d6:	cmovbe %r15,%rax
  67a6da:	mov    (%rsp),%rdi
  67a6de:	mov    %rax,%rsi
  67a6e1:	add    %rbx,%r12
  67a6e4:	call   67a0c0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  67a6e9:	sub    %rbx,%r15
  67a6ec:	cmp    %r13,%r12
  67a6ef:	jb     67a6c0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  67a6f1:	add    $0x18,%rsp
  67a6f5:	pop    %rbx
  67a6f6:	pop    %rbp
  67a6f7:	pop    %r12
  67a6f9:	pop    %r13
  67a6fb:	pop    %r14
  67a6fd:	pop    %r15
  67a6ff:	ret
  67a700:	xor    %edi,%edi
  67a702:	mov    $0x1,%esi
  67a707:	test   %rdx,%rdx
  67a70a:	je     67a6f1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67a70c:	nopl   0x0(%rax)
  67a710:	mov    (%r14,%rdi,4),%eax
  67a714:	mov    0xc(%rbx),%edx
  67a717:	imul   $0x238ef8e3,%eax,%r8d
  67a71e:	imul   %r8,%rdx
  67a722:	mov    %r8,%rcx
  67a725:	mov    0x10(%rbx),%r8d
  67a729:	shr    $0x20,%rdx
  67a72d:	shrx   %r8d,%edx,%edx
  67a732:	imul   0x14(%rbx),%edx
  67a736:	sub    %edx,%ecx
  67a738:	mov    0x18(%rbx),%rdx
  67a73c:	lea    0x0(,%rcx,8),%ecx
  67a743:	lea    (%rdx,%rcx,4),%rcx
  67a747:	imul   $0x16118b03,%eax,%edx
  67a74d:	imul   $0x9e3779b9,%eax,%eax
  67a753:	mov    (%rcx),%r15d
  67a756:	mov    %edx,%r12d
  67a759:	shr    $0x1b,%r12d
  67a75d:	shlx   %r12d,%esi,%r12d
  67a762:	mov    %edx,%ebp
  67a764:	and    %r12d,%r15d
  67a767:	mov    %edx,%r11d
  67a76a:	mov    %edx,%r10d
  67a76d:	mov    %edx,%r9d
  67a770:	mov    %eax,%r8d
  67a773:	shr    $0x16,%ebp
  67a776:	shr    $0x11,%r11d
  67a77a:	shr    $0xc,%r10d
  67a77e:	shr    $0x7,%r9d
  67a782:	shr    $0x2,%edx
  67a785:	shr    $0x1b,%r8d
  67a789:	shr    $0x16,%eax
  67a78c:	cmp    %r12d,%r15d
  67a78f:	mov    0x4(%rcx),%r12d
  67a793:	sete   %r15b
  67a797:	shlx   %ebp,%esi,%ebp
  67a79c:	and    %ebp,%r12d
  67a79f:	cmp    %ebp,%r12d
  67a7a2:	mov    0x8(%rcx),%r12d
  67a7a6:	sete   %bpl
  67a7aa:	shlx   %r11d,%esi,%r11d
  67a7af:	and    %r11d,%r12d
  67a7b2:	and    %r15d,%ebp
  67a7b5:	cmp    %r11d,%r12d
  67a7b8:	sete   %r11b
  67a7bc:	and    %ebp,%r11d
  67a7bf:	mov    0xc(%rcx),%ebp
  67a7c2:	shlx   %r10d,%esi,%r10d
  67a7c7:	and    %r10d,%ebp
  67a7ca:	cmp    %r10d,%ebp
  67a7cd:	sete   %r10b
  67a7d1:	and    %r11d,%r10d
  67a7d4:	mov    0x10(%rcx),%r11d
  67a7d8:	shlx   %r9d,%esi,%r9d
  67a7dd:	and    %r9d,%r11d
  67a7e0:	cmp    %r9d,%r11d
  67a7e3:	sete   %r9b
  67a7e7:	and    %r10d,%r9d
  67a7ea:	mov    0x14(%rcx),%r10d
  67a7ee:	shlx   %edx,%esi,%edx
  67a7f3:	and    %edx,%r10d
  67a7f6:	cmp    %edx,%r10d
  67a7f9:	sete   %dl
  67a7fc:	and    %r9d,%edx
  67a7ff:	mov    0x18(%rcx),%r9d
  67a803:	mov    0x1c(%rcx),%r15d
  67a807:	shlx   %r8d,%esi,%r8d
  67a80c:	and    %r8d,%r9d
  67a80f:	cmp    %r8d,%r9d
  67a812:	sete   %r8b
  67a816:	shlx   %eax,%esi,%eax
  67a81b:	and    %eax,%r15d
  67a81e:	and    %r8d,%edx
  67a821:	cmp    %eax,%r15d
  67a824:	sete   %al
  67a827:	mov    0x8(%rsp),%rcx
  67a82c:	movzbl %al,%eax
  67a82f:	and    %edx,%eax
  67a831:	mov    %eax,(%rcx,%rdi,4)
  67a834:	inc    %rdi
  67a837:	cmp    %rdi,%r13
  67a83a:	jne    67a710 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  67a840:	add    $0x18,%rsp
  67a844:	pop    %rbx
  67a845:	pop    %rbp
  67a846:	pop    %r12
  67a848:	pop    %r13
  67a84a:	pop    %r14
  67a84c:	pop    %r15
  67a84e:	ret
