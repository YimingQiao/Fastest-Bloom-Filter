
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a5c0 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a5c0:	push   %r15
   1a5c2:	push   %r14
   1a5c4:	push   %r13
   1a5c6:	mov    %r8,%r13
   1a5c9:	push   %r12
   1a5cb:	mov    %rcx,%r12
   1a5ce:	push   %rbp
   1a5cf:	push   %rbx
   1a5d0:	mov    %rdx,%rbx
   1a5d3:	sub    $0x28,%rsp
   1a5d7:	mov    %rdi,0x8(%rsp)
   1a5dc:	test   %esi,%esi
   1a5de:	je     1a648 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a5e0:	cmp    $0x1,%esi
   1a5e3:	mov    $0x1000,%r14d
   1a5e9:	mov    $0x1,%eax
   1a5ee:	cmove  %rax,%r14
   1a5f2:	test   %rdx,%rdx
   1a5f5:	je     1a632 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a5f7:	mov    %rdx,%rbp
   1a5fa:	xor    %r15d,%r15d
   1a5fd:	nopl   (%rax)
   1a600:	lea    0x0(,%r15,4),%rdx
   1a608:	lea    0x0(%r13,%rdx,1),%rcx
   1a60d:	mov    %r14,%rax
   1a610:	add    %r12,%rdx
   1a613:	cmp    %r14,%rbp
   1a616:	cmovbe %rbp,%rax
   1a61a:	mov    0x8(%rsp),%rdi
   1a61f:	mov    %rax,%rsi
   1a622:	add    %r14,%r15
   1a625:	call   15e80 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a62a:	sub    %r14,%rbp
   1a62d:	cmp    %rbx,%r15
   1a630:	jb     1a600 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a632:	add    $0x28,%rsp
   1a636:	pop    %rbx
   1a637:	pop    %rbp
   1a638:	pop    %r12
   1a63a:	pop    %r13
   1a63c:	pop    %r14
   1a63e:	pop    %r15
   1a640:	ret
   1a641:	nopl   0x0(%rax)
   1a648:	xor    %r9d,%r9d
   1a64b:	lea    0x1c(%rsp),%r10
   1a650:	test   %rdx,%rdx
   1a653:	je     1a632 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a655:	nopl   (%rax)
   1a658:	mov    (%r12,%r9,4),%eax
   1a65c:	mov    0x8(%rsp),%rdi
   1a661:	mov    %r10,%rsi
   1a664:	mov    %eax,0x1c(%rsp)
   1a668:	call   a1c0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a66d:	movzbl %al,%eax
   1a670:	mov    %eax,0x0(%r13,%r9,4)
   1a675:	inc    %r9
   1a678:	cmp    %r9,%rbx
   1a67b:	jne    1a658 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a67d:	add    $0x28,%rsp
   1a681:	pop    %rbx
   1a682:	pop    %rbp
   1a683:	pop    %r12
   1a685:	pop    %r13
   1a687:	pop    %r14
   1a689:	pop    %r15
   1a68b:	ret
