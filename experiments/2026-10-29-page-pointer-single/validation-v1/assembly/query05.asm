
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000c270 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    c270:	push   %r15
    c272:	push   %r14
    c274:	push   %r13
    c276:	mov    %rdx,%r13
    c279:	push   %r12
    c27b:	push   %rbp
    c27c:	mov    %r8,%rbp
    c27f:	push   %rbx
    c280:	mov    %rcx,%rbx
    c283:	sub    $0x18,%rsp
    c287:	mov    %rdi,0x8(%rsp)
    c28c:	test   %esi,%esi
    c28e:	je     c2f8 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    c290:	cmp    $0x1,%esi
    c293:	mov    $0x1000,%r14d
    c299:	mov    $0x1,%eax
    c29e:	cmove  %rax,%r14
    c2a2:	test   %rdx,%rdx
    c2a5:	je     c2e2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c2a7:	mov    %rdx,%r12
    c2aa:	xor    %r15d,%r15d
    c2ad:	nopl   (%rax)
    c2b0:	lea    0x0(,%r15,4),%rdx
    c2b8:	lea    0x0(%rbp,%rdx,1),%rcx
    c2bd:	mov    %r14,%rax
    c2c0:	add    %rbx,%rdx
    c2c3:	cmp    %r14,%r12
    c2c6:	cmovbe %r12,%rax
    c2ca:	mov    0x8(%rsp),%rdi
    c2cf:	mov    %rax,%rsi
    c2d2:	add    %r14,%r15
    c2d5:	call   162d0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
    c2da:	sub    %r14,%r12
    c2dd:	cmp    %r13,%r15
    c2e0:	jb     c2b0 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    c2e2:	add    $0x18,%rsp
    c2e6:	pop    %rbx
    c2e7:	pop    %rbp
    c2e8:	pop    %r12
    c2ea:	pop    %r13
    c2ec:	pop    %r14
    c2ee:	pop    %r15
    c2f0:	ret
    c2f1:	nopl   0x0(%rax)
    c2f8:	test   %rdx,%rdx
    c2fb:	je     c2e2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c2fd:	lea    (%rcx,%rdx,4),%r9
    c301:	nopl   0x0(%rax)
    c308:	mov    0x8(%rsp),%rdi
    c30d:	mov    %rbx,%rsi
    c310:	call   a2c0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    c315:	movzbl %al,%eax
    c318:	add    $0x4,%rbx
    c31c:	mov    %eax,0x0(%rbp)
    c31f:	add    $0x4,%rbp
    c323:	cmp    %r9,%rbx
    c326:	jne    c308 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, true> >(raw32_stage3::RawPagePointer<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    c328:	add    $0x18,%rsp
    c32c:	pop    %rbx
    c32d:	pop    %rbp
    c32e:	pop    %r12
    c330:	pop    %r13
    c332:	pop    %r14
    c334:	pop    %r15
    c336:	ret
