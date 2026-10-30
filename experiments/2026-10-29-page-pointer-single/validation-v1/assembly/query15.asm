
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a860 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a860:	push   %r15
   1a862:	push   %r14
   1a864:	push   %r13
   1a866:	mov    %r8,%r13
   1a869:	push   %r12
   1a86b:	mov    %rcx,%r12
   1a86e:	push   %rbp
   1a86f:	push   %rbx
   1a870:	mov    %rdx,%rbx
   1a873:	sub    $0x28,%rsp
   1a877:	mov    %rdi,0x8(%rsp)
   1a87c:	test   %esi,%esi
   1a87e:	je     1a8e8 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a880:	cmp    $0x1,%esi
   1a883:	mov    $0x1000,%r14d
   1a889:	mov    $0x1,%eax
   1a88e:	cmove  %rax,%r14
   1a892:	test   %rdx,%rdx
   1a895:	je     1a8d2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a897:	mov    %rdx,%rbp
   1a89a:	xor    %r15d,%r15d
   1a89d:	nopl   (%rax)
   1a8a0:	lea    0x0(,%r15,4),%rdx
   1a8a8:	lea    0x0(%r13,%rdx,1),%rcx
   1a8ad:	mov    %r14,%rax
   1a8b0:	add    %r12,%rdx
   1a8b3:	cmp    %r14,%rbp
   1a8b6:	cmovbe %rbp,%rax
   1a8ba:	mov    0x8(%rsp),%rdi
   1a8bf:	mov    %rax,%rsi
   1a8c2:	add    %r14,%r15
   1a8c5:	call   162d0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a8ca:	sub    %r14,%rbp
   1a8cd:	cmp    %rbx,%r15
   1a8d0:	jb     1a8a0 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a8d2:	add    $0x28,%rsp
   1a8d6:	pop    %rbx
   1a8d7:	pop    %rbp
   1a8d8:	pop    %r12
   1a8da:	pop    %r13
   1a8dc:	pop    %r14
   1a8de:	pop    %r15
   1a8e0:	ret
   1a8e1:	nopl   0x0(%rax)
   1a8e8:	xor    %r9d,%r9d
   1a8eb:	lea    0x1c(%rsp),%r10
   1a8f0:	test   %rdx,%rdx
   1a8f3:	je     1a8d2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a8f5:	nopl   (%rax)
   1a8f8:	mov    (%r12,%r9,4),%eax
   1a8fc:	mov    0x8(%rsp),%rdi
   1a901:	mov    %r10,%rsi
   1a904:	mov    %eax,0x1c(%rsp)
   1a908:	call   a2c0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a90d:	movzbl %al,%eax
   1a910:	mov    %eax,0x0(%r13,%r9,4)
   1a915:	inc    %r9
   1a918:	cmp    %r9,%rbx
   1a91b:	jne    1a8f8 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a91d:	add    $0x28,%rsp
   1a921:	pop    %rbx
   1a922:	pop    %rbp
   1a923:	pop    %r12
   1a925:	pop    %r13
   1a927:	pop    %r14
   1a929:	pop    %r15
   1a92b:	ret
