
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000c000 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    c000:	push   %r15
    c002:	push   %r14
    c004:	push   %r13
    c006:	mov    %rdx,%r13
    c009:	push   %r12
    c00b:	push   %rbp
    c00c:	mov    %r8,%rbp
    c00f:	push   %rbx
    c010:	mov    %rcx,%rbx
    c013:	sub    $0x18,%rsp
    c017:	mov    %rdi,0x8(%rsp)
    c01c:	test   %esi,%esi
    c01e:	je     c088 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    c020:	cmp    $0x1,%esi
    c023:	mov    $0x1000,%r14d
    c029:	mov    $0x1,%eax
    c02e:	cmove  %rax,%r14
    c032:	test   %rdx,%rdx
    c035:	je     c072 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c037:	mov    %rdx,%r12
    c03a:	xor    %r15d,%r15d
    c03d:	nopl   (%rax)
    c040:	lea    0x0(,%r15,4),%rdx
    c048:	lea    0x0(%rbp,%rdx,1),%rcx
    c04d:	mov    %r14,%rax
    c050:	add    %rbx,%rdx
    c053:	cmp    %r14,%r12
    c056:	cmovbe %r12,%rax
    c05a:	mov    0x8(%rsp),%rdi
    c05f:	mov    %rax,%rsi
    c062:	add    %r14,%r15
    c065:	call   15e80 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
    c06a:	sub    %r14,%r12
    c06d:	cmp    %r13,%r15
    c070:	jb     c040 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    c072:	add    $0x18,%rsp
    c076:	pop    %rbx
    c077:	pop    %rbp
    c078:	pop    %r12
    c07a:	pop    %r13
    c07c:	pop    %r14
    c07e:	pop    %r15
    c080:	ret
    c081:	nopl   0x0(%rax)
    c088:	test   %rdx,%rdx
    c08b:	je     c072 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c08d:	lea    (%rcx,%rdx,4),%r9
    c091:	nopl   0x0(%rax)
    c098:	mov    0x8(%rsp),%rdi
    c09d:	mov    %rbx,%rsi
    c0a0:	call   a1c0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    c0a5:	movzbl %al,%eax
    c0a8:	add    $0x4,%rbx
    c0ac:	mov    %eax,0x0(%rbp)
    c0af:	add    $0x4,%rbp
    c0b3:	cmp    %r9,%rbx
    c0b6:	jne    c098 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, false> >(raw32_stage3::RawPagePointer<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    c0b8:	add    $0x18,%rsp
    c0bc:	pop    %rbx
    c0bd:	pop    %rbp
    c0be:	pop    %r12
    c0c0:	pop    %r13
    c0c2:	pop    %r14
    c0c4:	pop    %r15
    c0c6:	ret
