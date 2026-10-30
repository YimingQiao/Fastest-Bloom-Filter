
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000031d80 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   31d80:	push   %r15
   31d82:	push   %r14
   31d84:	push   %r13
   31d86:	mov    %r8,%r13
   31d89:	push   %r12
   31d8b:	mov    %rcx,%r12
   31d8e:	push   %rbp
   31d8f:	push   %rbx
   31d90:	mov    %rdx,%rbx
   31d93:	sub    $0x28,%rsp
   31d97:	mov    %rdi,0x8(%rsp)
   31d9c:	test   %esi,%esi
   31d9e:	je     31e08 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   31da0:	cmp    $0x1,%esi
   31da3:	mov    $0x1000,%r14d
   31da9:	mov    $0x1,%eax
   31dae:	cmove  %rax,%r14
   31db2:	test   %rdx,%rdx
   31db5:	je     31df2 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31db7:	mov    %rdx,%rbp
   31dba:	xor    %r15d,%r15d
   31dbd:	nopl   (%rax)
   31dc0:	lea    0x0(,%r15,4),%rdx
   31dc8:	lea    0x0(%r13,%rdx,1),%rcx
   31dcd:	mov    %r14,%rax
   31dd0:	add    %r12,%rdx
   31dd3:	cmp    %r14,%rbp
   31dd6:	cmovbe %rbp,%rax
   31dda:	mov    0x8(%rsp),%rdi
   31ddf:	mov    %rax,%rsi
   31de2:	add    %r14,%r15
   31de5:	call   31c20 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   31dea:	sub    %r14,%rbp
   31ded:	cmp    %rbx,%r15
   31df0:	jb     31dc0 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   31df2:	add    $0x28,%rsp
   31df6:	pop    %rbx
   31df7:	pop    %rbp
   31df8:	pop    %r12
   31dfa:	pop    %r13
   31dfc:	pop    %r14
   31dfe:	pop    %r15
   31e00:	ret
   31e01:	nopl   0x0(%rax)
   31e08:	xor    %r9d,%r9d
   31e0b:	lea    0x1c(%rsp),%r10
   31e10:	test   %rdx,%rdx
   31e13:	je     31df2 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31e15:	nopl   (%rax)
   31e18:	mov    (%r12,%r9,4),%eax
   31e1c:	mov    0x8(%rsp),%rdi
   31e21:	mov    %r10,%rsi
   31e24:	mov    %eax,0x1c(%rsp)
   31e28:	call   bfa0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   31e2d:	movzbl %al,%eax
   31e30:	mov    %eax,0x0(%r13,%r9,4)
   31e35:	inc    %r9
   31e38:	cmp    %r9,%rbx
   31e3b:	jne    31e18 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, true> >(raw32_stage3::RawPage<6u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   31e3d:	add    $0x28,%rsp
   31e41:	pop    %rbx
   31e42:	pop    %rbp
   31e43:	pop    %r12
   31e45:	pop    %r13
   31e47:	pop    %r14
   31e49:	pop    %r15
   31e4b:	ret
