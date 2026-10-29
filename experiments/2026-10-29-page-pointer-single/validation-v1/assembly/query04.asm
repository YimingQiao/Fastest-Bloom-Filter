
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000c1a0 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    c1a0:	push   %r15
    c1a2:	push   %r14
    c1a4:	push   %r13
    c1a6:	mov    %rdx,%r13
    c1a9:	push   %r12
    c1ab:	push   %rbp
    c1ac:	mov    %r8,%rbp
    c1af:	push   %rbx
    c1b0:	mov    %rcx,%rbx
    c1b3:	sub    $0x18,%rsp
    c1b7:	mov    %rdi,0x8(%rsp)
    c1bc:	test   %esi,%esi
    c1be:	je     c228 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    c1c0:	cmp    $0x1,%esi
    c1c3:	mov    $0x1000,%r14d
    c1c9:	mov    $0x1,%eax
    c1ce:	cmove  %rax,%r14
    c1d2:	test   %rdx,%rdx
    c1d5:	je     c212 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c1d7:	mov    %rdx,%r12
    c1da:	xor    %r15d,%r15d
    c1dd:	nopl   (%rax)
    c1e0:	lea    0x0(,%r15,4),%rdx
    c1e8:	lea    0x0(%rbp,%rdx,1),%rcx
    c1ed:	mov    %r14,%rax
    c1f0:	add    %rbx,%rdx
    c1f3:	cmp    %r14,%r12
    c1f6:	cmovbe %r12,%rax
    c1fa:	mov    0x8(%rsp),%rdi
    c1ff:	mov    %rax,%rsi
    c202:	add    %r14,%r15
    c205:	call   16160 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
    c20a:	sub    %r14,%r12
    c20d:	cmp    %r13,%r15
    c210:	jb     c1e0 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    c212:	add    $0x18,%rsp
    c216:	pop    %rbx
    c217:	pop    %rbp
    c218:	pop    %r12
    c21a:	pop    %r13
    c21c:	pop    %r14
    c21e:	pop    %r15
    c220:	ret
    c221:	nopl   0x0(%rax)
    c228:	test   %rdx,%rdx
    c22b:	je     c212 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c22d:	lea    (%rcx,%rdx,4),%r9
    c231:	nopl   0x0(%rax)
    c238:	mov    0x8(%rsp),%rdi
    c23d:	mov    %rbx,%rsi
    c240:	call   a2c0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    c245:	movzbl %al,%eax
    c248:	add    $0x4,%rbx
    c24c:	mov    %eax,0x0(%rbp)
    c24f:	add    $0x4,%rbp
    c253:	cmp    %r9,%rbx
    c256:	jne    c238 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<8u, false> >(raw32_stage3::RawPagePointer<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    c258:	add    $0x18,%rsp
    c25c:	pop    %rbx
    c25d:	pop    %rbp
    c25e:	pop    %r12
    c260:	pop    %r13
    c262:	pop    %r14
    c264:	pop    %r15
    c266:	ret
