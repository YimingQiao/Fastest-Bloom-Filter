
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000bf30 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    bf30:	push   %r15
    bf32:	push   %r14
    bf34:	push   %r13
    bf36:	mov    %rdx,%r13
    bf39:	push   %r12
    bf3b:	push   %rbp
    bf3c:	mov    %r8,%rbp
    bf3f:	push   %rbx
    bf40:	mov    %rcx,%rbx
    bf43:	sub    $0x18,%rsp
    bf47:	mov    %rdi,0x8(%rsp)
    bf4c:	test   %esi,%esi
    bf4e:	je     bfb8 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    bf50:	cmp    $0x1,%esi
    bf53:	mov    $0x1000,%r14d
    bf59:	mov    $0x1,%eax
    bf5e:	cmove  %rax,%r14
    bf62:	test   %rdx,%rdx
    bf65:	je     bfa2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    bf67:	mov    %rdx,%r12
    bf6a:	xor    %r15d,%r15d
    bf6d:	nopl   (%rax)
    bf70:	lea    0x0(,%r15,4),%rdx
    bf78:	lea    0x0(%rbp,%rdx,1),%rcx
    bf7d:	mov    %r14,%rax
    bf80:	add    %rbx,%rdx
    bf83:	cmp    %r14,%r12
    bf86:	cmovbe %r12,%rax
    bf8a:	mov    0x8(%rsp),%rdi
    bf8f:	mov    %rax,%rsi
    bf92:	add    %r14,%r15
    bf95:	call   15d40 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
    bf9a:	sub    %r14,%r12
    bf9d:	cmp    %r13,%r15
    bfa0:	jb     bf70 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    bfa2:	add    $0x18,%rsp
    bfa6:	pop    %rbx
    bfa7:	pop    %rbp
    bfa8:	pop    %r12
    bfaa:	pop    %r13
    bfac:	pop    %r14
    bfae:	pop    %r15
    bfb0:	ret
    bfb1:	nopl   0x0(%rax)
    bfb8:	test   %rdx,%rdx
    bfbb:	je     bfa2 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    bfbd:	lea    (%rcx,%rdx,4),%r13
    bfc1:	nopl   0x0(%rax)
    bfc8:	mov    0x8(%rsp),%rdi
    bfcd:	mov    %rbx,%rsi
    bfd0:	call   a0c0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    bfd5:	movzbl %al,%eax
    bfd8:	add    $0x4,%rbx
    bfdc:	mov    %eax,0x0(%rbp)
    bfdf:	add    $0x4,%rbp
    bfe3:	cmp    %r13,%rbx
    bfe6:	jne    bfc8 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<4u, true> >(raw32_stage3::RawPagePointer<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    bfe8:	add    $0x18,%rsp
    bfec:	pop    %rbx
    bfed:	pop    %rbp
    bfee:	pop    %r12
    bff0:	pop    %r13
    bff2:	pop    %r14
    bff4:	pop    %r15
    bff6:	ret
