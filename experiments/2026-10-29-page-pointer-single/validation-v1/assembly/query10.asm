
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000001a400 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   1a400:	push   %r15
   1a402:	push   %r14
   1a404:	push   %r13
   1a406:	mov    %r8,%r13
   1a409:	push   %r12
   1a40b:	mov    %rcx,%r12
   1a40e:	push   %rbp
   1a40f:	push   %rbx
   1a410:	mov    %rdx,%rbx
   1a413:	sub    $0x28,%rsp
   1a417:	mov    %rdi,0x8(%rsp)
   1a41c:	test   %esi,%esi
   1a41e:	je     1a488 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   1a420:	cmp    $0x1,%esi
   1a423:	mov    $0x1000,%r14d
   1a429:	mov    $0x1,%eax
   1a42e:	cmove  %rax,%r14
   1a432:	test   %rdx,%rdx
   1a435:	je     1a472 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a437:	mov    %rdx,%rbp
   1a43a:	xor    %r15d,%r15d
   1a43d:	nopl   (%rax)
   1a440:	lea    0x0(,%r15,4),%rdx
   1a448:	lea    0x0(%r13,%rdx,1),%rcx
   1a44d:	mov    %r14,%rax
   1a450:	add    %r12,%rdx
   1a453:	cmp    %r14,%rbp
   1a456:	cmovbe %rbp,%rax
   1a45a:	mov    0x8(%rsp),%rdi
   1a45f:	mov    %rax,%rsi
   1a462:	add    %r14,%r15
   1a465:	call   15c00 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   1a46a:	sub    %r14,%rbp
   1a46d:	cmp    %rbx,%r15
   1a470:	jb     1a440 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   1a472:	add    $0x28,%rsp
   1a476:	pop    %rbx
   1a477:	pop    %rbp
   1a478:	pop    %r12
   1a47a:	pop    %r13
   1a47c:	pop    %r14
   1a47e:	pop    %r15
   1a480:	ret
   1a481:	nopl   0x0(%rax)
   1a488:	xor    %r14d,%r14d
   1a48b:	lea    0x1c(%rsp),%r15
   1a490:	test   %rdx,%rdx
   1a493:	je     1a472 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   1a495:	nopl   (%rax)
   1a498:	mov    (%r12,%r14,4),%eax
   1a49c:	mov    0x8(%rsp),%rdi
   1a4a1:	mov    %r15,%rsi
   1a4a4:	mov    %eax,0x1c(%rsp)
   1a4a8:	call   a0c0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   1a4ad:	movzbl %al,%eax
   1a4b0:	mov    %eax,0x0(%r13,%r14,4)
   1a4b5:	inc    %r14
   1a4b8:	cmp    %r14,%rbx
   1a4bb:	jne    1a498 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   1a4bd:	add    $0x28,%rsp
   1a4c1:	pop    %rbx
   1a4c2:	pop    %rbp
   1a4c3:	pop    %r12
   1a4c5:	pop    %r13
   1a4c7:	pop    %r14
   1a4c9:	pop    %r15
   1a4cb:	ret
