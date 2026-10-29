
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a4e0 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a4e0:	push   %r15
   1a4e2:	push   %r14
   1a4e4:	push   %r13
   1a4e6:	mov    %r8,%r13
   1a4e9:	push   %r12
   1a4eb:	mov    %rcx,%r12
   1a4ee:	push   %rbp
   1a4ef:	push   %rbx
   1a4f0:	mov    %rdx,%rbx
   1a4f3:	sub    $0x28,%rsp
   1a4f7:	mov    %rdi,0x8(%rsp)
   1a4fc:	test   %esi,%esi
   1a4fe:	je     1a568 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a500:	cmp    $0x1,%esi
   1a503:	mov    $0x1000,%r14d
   1a509:	mov    $0x1,%eax
   1a50e:	cmove  %rax,%r14
   1a512:	test   %rdx,%rdx
   1a515:	je     1a552 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a517:	mov    %rdx,%rbp
   1a51a:	xor    %r15d,%r15d
   1a51d:	nopl   (%rax)
   1a520:	lea    0x0(,%r15,4),%rdx
   1a528:	lea    0x0(%r13,%rdx,1),%rcx
   1a52d:	mov    %r14,%rax
   1a530:	add    %r12,%rdx
   1a533:	cmp    %r14,%rbp
   1a536:	cmovbe %rbp,%rax
   1a53a:	mov    0x8(%rsp),%rdi
   1a53f:	mov    %rax,%rsi
   1a542:	add    %r14,%r15
   1a545:	call   15d40 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a54a:	sub    %r14,%rbp
   1a54d:	cmp    %rbx,%r15
   1a550:	jb     1a520 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a552:	add    $0x28,%rsp
   1a556:	pop    %rbx
   1a557:	pop    %rbp
   1a558:	pop    %r12
   1a55a:	pop    %r13
   1a55c:	pop    %r14
   1a55e:	pop    %r15
   1a560:	ret
   1a561:	nopl   0x0(%rax)
   1a568:	xor    %r14d,%r14d
   1a56b:	lea    0x1c(%rsp),%r15
   1a570:	test   %rdx,%rdx
   1a573:	je     1a552 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a575:	nopl   (%rax)
   1a578:	mov    (%r12,%r14,4),%eax
   1a57c:	mov    0x8(%rsp),%rdi
   1a581:	mov    %r15,%rsi
   1a584:	mov    %eax,0x1c(%rsp)
   1a588:	call   a0c0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a58d:	movzbl %al,%eax
   1a590:	mov    %eax,0x0(%r13,%r14,4)
   1a595:	inc    %r14
   1a598:	cmp    %r14,%rbx
   1a59b:	jne    1a578 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a59d:	add    $0x28,%rsp
   1a5a1:	pop    %rbx
   1a5a2:	pop    %rbp
   1a5a3:	pop    %r12
   1a5a5:	pop    %r13
   1a5a7:	pop    %r14
   1a5a9:	pop    %r15
   1a5ab:	ret
