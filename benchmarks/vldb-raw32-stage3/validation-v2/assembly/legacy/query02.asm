
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004ba740 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4ba740:	push   %r15
  4ba742:	push   %r14
  4ba744:	mov    %rcx,%r14
  4ba747:	push   %r13
  4ba749:	mov    %rdx,%r13
  4ba74c:	push   %r12
  4ba74e:	push   %rbp
  4ba74f:	push   %rbx
  4ba750:	mov    %rdi,%rbx
  4ba753:	sub    $0x18,%rsp
  4ba757:	mov    %r8,0x8(%rsp)
  4ba75c:	test   %esi,%esi
  4ba75e:	je     4ba7d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  4ba760:	cmp    $0x1,%esi
  4ba763:	mov    $0x1000,%ebp
  4ba768:	mov    $0x1,%eax
  4ba76d:	cmove  %rax,%rbp
  4ba771:	test   %rdx,%rdx
  4ba774:	je     4ba7c1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  4ba776:	mov    %rdi,(%rsp)
  4ba77a:	mov    %rbp,%rbx
  4ba77d:	mov    0x8(%rsp),%rbp
  4ba782:	mov    %rdx,%r15
  4ba785:	xor    %r12d,%r12d
  4ba788:	nopl   0x0(%rax,%rax,1)
  4ba790:	lea    0x0(,%r12,4),%rdx
  4ba798:	lea    0x0(%rbp,%rdx,1),%rcx
  4ba79d:	mov    %rbx,%rax
  4ba7a0:	add    %r14,%rdx
  4ba7a3:	cmp    %rbx,%r15
  4ba7a6:	cmovbe %r15,%rax
  4ba7aa:	mov    (%rsp),%rdi
  4ba7ae:	mov    %rax,%rsi
  4ba7b1:	add    %rbx,%r12
  4ba7b4:	call   4b9fb0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  4ba7b9:	sub    %rbx,%r15
  4ba7bc:	cmp    %r13,%r12
  4ba7bf:	jb     4ba790 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  4ba7c1:	add    $0x18,%rsp
  4ba7c5:	pop    %rbx
  4ba7c6:	pop    %rbp
  4ba7c7:	pop    %r12
  4ba7c9:	pop    %r13
  4ba7cb:	pop    %r14
  4ba7cd:	pop    %r15
  4ba7cf:	ret
  4ba7d0:	xor    %edi,%edi
  4ba7d2:	mov    $0x1,%esi
  4ba7d7:	test   %rdx,%rdx
  4ba7da:	je     4ba7c1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  4ba7dc:	nopl   0x0(%rax)
  4ba7e0:	mov    (%r14,%rdi,4),%eax
  4ba7e4:	mov    $0x20,%ecx
  4ba7e9:	imul   $0x238ef8e3,%eax,%edx
  4ba7ef:	sub    0x4(%rbx),%ecx
  4ba7f2:	shrx   %ecx,%edx,%edx
  4ba7f7:	lea    0x0(,%rdx,8),%ecx
  4ba7fe:	mov    0x10(%rbx),%rdx
  4ba802:	lea    (%rdx,%rcx,4),%rcx
  4ba806:	imul   $0x16118b03,%eax,%edx
  4ba80c:	imul   $0x9e3779b9,%eax,%eax
  4ba812:	mov    (%rcx),%r15d
  4ba815:	mov    %edx,%r12d
  4ba818:	shr    $0x1b,%r12d
  4ba81c:	shlx   %r12d,%esi,%r12d
  4ba821:	mov    %edx,%ebp
  4ba823:	and    %r12d,%r15d
  4ba826:	mov    %edx,%r11d
  4ba829:	mov    %edx,%r10d
  4ba82c:	mov    %edx,%r9d
  4ba82f:	mov    %eax,%r8d
  4ba832:	shr    $0x16,%ebp
  4ba835:	shr    $0x11,%r11d
  4ba839:	shr    $0xc,%r10d
  4ba83d:	shr    $0x7,%r9d
  4ba841:	shr    $0x2,%edx
  4ba844:	shr    $0x1b,%r8d
  4ba848:	shr    $0x16,%eax
  4ba84b:	cmp    %r12d,%r15d
  4ba84e:	mov    0x4(%rcx),%r12d
  4ba852:	sete   %r15b
  4ba856:	shlx   %ebp,%esi,%ebp
  4ba85b:	and    %ebp,%r12d
  4ba85e:	cmp    %ebp,%r12d
  4ba861:	mov    0x8(%rcx),%r12d
  4ba865:	sete   %bpl
  4ba869:	shlx   %r11d,%esi,%r11d
  4ba86e:	and    %r11d,%r12d
  4ba871:	and    %r15d,%ebp
  4ba874:	cmp    %r11d,%r12d
  4ba877:	sete   %r11b
  4ba87b:	and    %ebp,%r11d
  4ba87e:	mov    0xc(%rcx),%ebp
  4ba881:	shlx   %r10d,%esi,%r10d
  4ba886:	and    %r10d,%ebp
  4ba889:	cmp    %r10d,%ebp
  4ba88c:	sete   %r10b
  4ba890:	and    %r11d,%r10d
  4ba893:	mov    0x10(%rcx),%r11d
  4ba897:	shlx   %r9d,%esi,%r9d
  4ba89c:	and    %r9d,%r11d
  4ba89f:	cmp    %r9d,%r11d
  4ba8a2:	sete   %r9b
  4ba8a6:	and    %r10d,%r9d
  4ba8a9:	mov    0x14(%rcx),%r10d
  4ba8ad:	shlx   %edx,%esi,%edx
  4ba8b2:	and    %edx,%r10d
  4ba8b5:	cmp    %edx,%r10d
  4ba8b8:	sete   %dl
  4ba8bb:	and    %r9d,%edx
  4ba8be:	mov    0x18(%rcx),%r9d
  4ba8c2:	shlx   %r8d,%esi,%r8d
  4ba8c7:	and    %r8d,%r9d
  4ba8ca:	cmp    %r8d,%r9d
  4ba8cd:	sete   %r8b
  4ba8d1:	and    %r8d,%edx
  4ba8d4:	mov    0x1c(%rcx),%r8d
  4ba8d8:	shlx   %eax,%esi,%eax
  4ba8dd:	and    %eax,%r8d
  4ba8e0:	cmp    %eax,%r8d
  4ba8e3:	sete   %al
  4ba8e6:	mov    0x8(%rsp),%rcx
  4ba8eb:	movzbl %al,%eax
  4ba8ee:	and    %edx,%eax
  4ba8f0:	mov    %eax,(%rcx,%rdi,4)
  4ba8f3:	inc    %rdi
  4ba8f6:	cmp    %rdi,%r13
  4ba8f9:	jne    4ba7e0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  4ba8ff:	add    $0x18,%rsp
  4ba903:	pop    %rbx
  4ba904:	pop    %rbp
  4ba905:	pop    %r12
  4ba907:	pop    %r13
  4ba909:	pop    %r14
  4ba90b:	pop    %r15
  4ba90d:	ret
