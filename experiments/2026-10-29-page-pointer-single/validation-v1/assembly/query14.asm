
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a780 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a780:	push   %r15
   1a782:	push   %r14
   1a784:	push   %r13
   1a786:	mov    %r8,%r13
   1a789:	push   %r12
   1a78b:	mov    %rcx,%r12
   1a78e:	push   %rbp
   1a78f:	push   %rbx
   1a790:	mov    %rdx,%rbx
   1a793:	sub    $0x28,%rsp
   1a797:	mov    %rdi,0x8(%rsp)
   1a79c:	test   %esi,%esi
   1a79e:	je     1a808 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a7a0:	cmp    $0x1,%esi
   1a7a3:	mov    $0x1000,%r14d
   1a7a9:	mov    $0x1,%eax
   1a7ae:	cmove  %rax,%r14
   1a7b2:	test   %rdx,%rdx
   1a7b5:	je     1a7f2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a7b7:	mov    %rdx,%rbp
   1a7ba:	xor    %r15d,%r15d
   1a7bd:	nopl   (%rax)
   1a7c0:	lea    0x0(,%r15,4),%rdx
   1a7c8:	lea    0x0(%r13,%rdx,1),%rcx
   1a7cd:	mov    %r14,%rax
   1a7d0:	add    %r12,%rdx
   1a7d3:	cmp    %r14,%rbp
   1a7d6:	cmovbe %rbp,%rax
   1a7da:	mov    0x8(%rsp),%rdi
   1a7df:	mov    %rax,%rsi
   1a7e2:	add    %r14,%r15
   1a7e5:	call   16160 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a7ea:	sub    %r14,%rbp
   1a7ed:	cmp    %rbx,%r15
   1a7f0:	jb     1a7c0 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a7f2:	add    $0x28,%rsp
   1a7f6:	pop    %rbx
   1a7f7:	pop    %rbp
   1a7f8:	pop    %r12
   1a7fa:	pop    %r13
   1a7fc:	pop    %r14
   1a7fe:	pop    %r15
   1a800:	ret
   1a801:	nopl   0x0(%rax)
   1a808:	xor    %r9d,%r9d
   1a80b:	lea    0x1c(%rsp),%r10
   1a810:	test   %rdx,%rdx
   1a813:	je     1a7f2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a815:	nopl   (%rax)
   1a818:	mov    (%r12,%r9,4),%eax
   1a81c:	mov    0x8(%rsp),%rdi
   1a821:	mov    %r10,%rsi
   1a824:	mov    %eax,0x1c(%rsp)
   1a828:	call   a2c0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a82d:	movzbl %al,%eax
   1a830:	mov    %eax,0x0(%r13,%r9,4)
   1a835:	inc    %r9
   1a838:	cmp    %r9,%rbx
   1a83b:	jne    1a818 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a83d:	add    $0x28,%rsp
   1a841:	pop    %rbx
   1a842:	pop    %rbp
   1a843:	pop    %r12
   1a845:	pop    %r13
   1a847:	pop    %r14
   1a849:	pop    %r15
   1a84b:	ret
