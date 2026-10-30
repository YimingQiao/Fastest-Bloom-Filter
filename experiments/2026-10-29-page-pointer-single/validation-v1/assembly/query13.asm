
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a6a0 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a6a0:	push   %r15
   1a6a2:	push   %r14
   1a6a4:	push   %r13
   1a6a6:	mov    %r8,%r13
   1a6a9:	push   %r12
   1a6ab:	mov    %rcx,%r12
   1a6ae:	push   %rbp
   1a6af:	push   %rbx
   1a6b0:	mov    %rdx,%rbx
   1a6b3:	sub    $0x28,%rsp
   1a6b7:	mov    %rdi,0x8(%rsp)
   1a6bc:	test   %esi,%esi
   1a6be:	je     1a728 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a6c0:	cmp    $0x1,%esi
   1a6c3:	mov    $0x1000,%r14d
   1a6c9:	mov    $0x1,%eax
   1a6ce:	cmove  %rax,%r14
   1a6d2:	test   %rdx,%rdx
   1a6d5:	je     1a712 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a6d7:	mov    %rdx,%rbp
   1a6da:	xor    %r15d,%r15d
   1a6dd:	nopl   (%rax)
   1a6e0:	lea    0x0(,%r15,4),%rdx
   1a6e8:	lea    0x0(%r13,%rdx,1),%rcx
   1a6ed:	mov    %r14,%rax
   1a6f0:	add    %r12,%rdx
   1a6f3:	cmp    %r14,%rbp
   1a6f6:	cmovbe %rbp,%rax
   1a6fa:	mov    0x8(%rsp),%rdi
   1a6ff:	mov    %rax,%rsi
   1a702:	add    %r14,%r15
   1a705:	call   15ff0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a70a:	sub    %r14,%rbp
   1a70d:	cmp    %rbx,%r15
   1a710:	jb     1a6e0 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a712:	add    $0x28,%rsp
   1a716:	pop    %rbx
   1a717:	pop    %rbp
   1a718:	pop    %r12
   1a71a:	pop    %r13
   1a71c:	pop    %r14
   1a71e:	pop    %r15
   1a720:	ret
   1a721:	nopl   0x0(%rax)
   1a728:	xor    %r9d,%r9d
   1a72b:	lea    0x1c(%rsp),%r10
   1a730:	test   %rdx,%rdx
   1a733:	je     1a712 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a735:	nopl   (%rax)
   1a738:	mov    (%r12,%r9,4),%eax
   1a73c:	mov    0x8(%rsp),%rdi
   1a741:	mov    %r10,%rsi
   1a744:	mov    %eax,0x1c(%rsp)
   1a748:	call   a1c0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a74d:	movzbl %al,%eax
   1a750:	mov    %eax,0x0(%r13,%r9,4)
   1a755:	inc    %r9
   1a758:	cmp    %r9,%rbx
   1a75b:	jne    1a738 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a75d:	add    $0x28,%rsp
   1a761:	pop    %rbx
   1a762:	pop    %rbp
   1a763:	pop    %r12
   1a765:	pop    %r13
   1a767:	pop    %r14
   1a769:	pop    %r15
   1a76b:	ret
