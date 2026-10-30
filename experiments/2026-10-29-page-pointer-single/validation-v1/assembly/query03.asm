
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000c0d0 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
    c0d0:	push   %r15
    c0d2:	push   %r14
    c0d4:	push   %r13
    c0d6:	mov    %rdx,%r13
    c0d9:	push   %r12
    c0db:	push   %rbp
    c0dc:	mov    %r8,%rbp
    c0df:	push   %rbx
    c0e0:	mov    %rcx,%rbx
    c0e3:	sub    $0x18,%rsp
    c0e7:	mov    %rdi,0x8(%rsp)
    c0ec:	test   %esi,%esi
    c0ee:	je     c158 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
    c0f0:	cmp    $0x1,%esi
    c0f3:	mov    $0x1000,%r14d
    c0f9:	mov    $0x1,%eax
    c0fe:	cmove  %rax,%r14
    c102:	test   %rdx,%rdx
    c105:	je     c142 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c107:	mov    %rdx,%r12
    c10a:	xor    %r15d,%r15d
    c10d:	nopl   (%rax)
    c110:	lea    0x0(,%r15,4),%rdx
    c118:	lea    0x0(%rbp,%rdx,1),%rcx
    c11d:	mov    %r14,%rax
    c120:	add    %rbx,%rdx
    c123:	cmp    %r14,%r12
    c126:	cmovbe %r12,%rax
    c12a:	mov    0x8(%rsp),%rdi
    c12f:	mov    %rax,%rsi
    c132:	add    %r14,%r15
    c135:	call   15ff0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
    c13a:	sub    %r14,%r12
    c13d:	cmp    %r13,%r15
    c140:	jb     c110 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
    c142:	add    $0x18,%rsp
    c146:	pop    %rbx
    c147:	pop    %rbp
    c148:	pop    %r12
    c14a:	pop    %r13
    c14c:	pop    %r14
    c14e:	pop    %r15
    c150:	ret
    c151:	nopl   0x0(%rax)
    c158:	test   %rdx,%rdx
    c15b:	je     c142 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
    c15d:	lea    (%rcx,%rdx,4),%r9
    c161:	nopl   0x0(%rax)
    c168:	mov    0x8(%rsp),%rdi
    c16d:	mov    %rbx,%rsi
    c170:	call   a1c0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
    c175:	movzbl %al,%eax
    c178:	add    $0x4,%rbx
    c17c:	mov    %eax,0x0(%rbp)
    c17f:	add    $0x4,%rbp
    c183:	cmp    %r9,%rbx
    c186:	jne    c168 <void vldb_stage2::Query<raw32_stage3::RawPagePointer<6u, true> >(raw32_stage3::RawPagePointer<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
    c188:	add    $0x18,%rsp
    c18c:	pop    %rbx
    c18d:	pop    %rbp
    c18e:	pop    %r12
    c190:	pop    %r13
    c192:	pop    %r14
    c194:	pop    %r15
    c196:	ret
