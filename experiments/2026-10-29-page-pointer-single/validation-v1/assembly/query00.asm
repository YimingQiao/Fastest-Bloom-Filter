
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000be60 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    be60:	push   %r15
    be62:	push   %r14
    be64:	push   %r13
    be66:	mov    %rdx,%r13
    be69:	push   %r12
    be6b:	push   %rbp
    be6c:	mov    %r8,%rbp
    be6f:	push   %rbx
    be70:	mov    %rcx,%rbx
    be73:	sub    $0x18,%rsp
    be77:	mov    %rdi,0x8(%rsp)
    be7c:	test   %esi,%esi
    be7e:	je     bee8 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    be80:	cmp    $0x1,%esi
    be83:	mov    $0x1000,%r14d
    be89:	mov    $0x1,%eax
    be8e:	cmove  %rax,%r14
    be92:	test   %rdx,%rdx
    be95:	je     bed2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    be97:	mov    %rdx,%r12
    be9a:	xor    %r15d,%r15d
    be9d:	nopl   (%rax)
    bea0:	lea    0x0(,%r15,4),%rdx
    bea8:	lea    0x0(%rbp,%rdx,1),%rcx
    bead:	mov    %r14,%rax
    beb0:	add    %rbx,%rdx
    beb3:	cmp    %r14,%r12
    beb6:	cmovbe %r12,%rax
    beba:	mov    0x8(%rsp),%rdi
    bebf:	mov    %rax,%rsi
    bec2:	add    %r14,%r15
    bec5:	call   15c00 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
    beca:	sub    %r14,%r12
    becd:	cmp    %r13,%r15
    bed0:	jb     bea0 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    bed2:	add    $0x18,%rsp
    bed6:	pop    %rbx
    bed7:	pop    %rbp
    bed8:	pop    %r12
    beda:	pop    %r13
    bedc:	pop    %r14
    bede:	pop    %r15
    bee0:	ret
    bee1:	nopl   0x0(%rax)
    bee8:	test   %rdx,%rdx
    beeb:	je     bed2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    beed:	lea    (%rcx,%rdx,4),%r13
    bef1:	nopl   0x0(%rax)
    bef8:	mov    0x8(%rsp),%rdi
    befd:	mov    %rbx,%rsi
    bf00:	call   a0c0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    bf05:	movzbl %al,%eax
    bf08:	add    $0x4,%rbx
    bf0c:	mov    %eax,0x0(%rbp)
    bf0f:	add    $0x4,%rbp
    bf13:	cmp    %r13,%rbx
    bf16:	jne    bef8 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, false> >(raw32_stage3::RawPagePointer<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    bf18:	add    $0x18,%rsp
    bf1c:	pop    %rbx
    bf1d:	pop    %rbp
    bf1e:	pop    %r12
    bf20:	pop    %r13
    bf22:	pop    %r14
    bf24:	pop    %r15
    bf26:	ret
