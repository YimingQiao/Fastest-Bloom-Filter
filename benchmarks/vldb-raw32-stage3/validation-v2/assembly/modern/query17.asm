
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000030f70 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   30f70:	push   %r15
   30f72:	push   %r14
   30f74:	push   %r13
   30f76:	mov    %r8,%r13
   30f79:	push   %r12
   30f7b:	mov    %rcx,%r12
   30f7e:	push   %rbp
   30f7f:	push   %rbx
   30f80:	mov    %rdx,%rbx
   30f83:	sub    $0x28,%rsp
   30f87:	mov    %rdi,0x8(%rsp)
   30f8c:	test   %esi,%esi
   30f8e:	je     30ff8 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   30f90:	cmp    $0x1,%esi
   30f93:	mov    $0x1000,%r14d
   30f99:	mov    $0x1,%eax
   30f9e:	cmove  %rax,%r14
   30fa2:	test   %rdx,%rdx
   30fa5:	je     30fe2 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   30fa7:	mov    %rdx,%rbp
   30faa:	xor    %r15d,%r15d
   30fad:	nopl   (%rax)
   30fb0:	lea    0x0(,%r15,4),%rdx
   30fb8:	lea    0x0(%r13,%rdx,1),%rcx
   30fbd:	mov    %r14,%rax
   30fc0:	add    %r12,%rdx
   30fc3:	cmp    %r14,%rbp
   30fc6:	cmovbe %rbp,%rax
   30fca:	mov    0x8(%rsp),%rdi
   30fcf:	mov    %rax,%rsi
   30fd2:	add    %r14,%r15
   30fd5:	call   30e40 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   30fda:	sub    %r14,%rbp
   30fdd:	cmp    %rbx,%r15
   30fe0:	jb     30fb0 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   30fe2:	add    $0x28,%rsp
   30fe6:	pop    %rbx
   30fe7:	pop    %rbp
   30fe8:	pop    %r12
   30fea:	pop    %r13
   30fec:	pop    %r14
   30fee:	pop    %r15
   30ff0:	ret
   30ff1:	nopl   0x0(%rax)
   30ff8:	xor    %r14d,%r14d
   30ffb:	lea    0x1c(%rsp),%r15
   31000:	test   %rdx,%rdx
   31003:	je     30fe2 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31005:	nopl   (%rax)
   31008:	mov    (%r12,%r14,4),%eax
   3100c:	mov    0x8(%rsp),%rdi
   31011:	mov    %r15,%rsi
   31014:	mov    %eax,0x1c(%rsp)
   31018:	call   bea0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   3101d:	movzbl %al,%eax
   31020:	mov    %eax,0x0(%r13,%r14,4)
   31025:	inc    %r14
   31028:	cmp    %r14,%rbx
   3102b:	jne    31008 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, false> >(raw32_stage3::RawPage<4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   3102d:	add    $0x28,%rsp
   31031:	pop    %rbx
   31032:	pop    %rbp
   31033:	pop    %r12
   31035:	pop    %r13
   31037:	pop    %r14
   31039:	pop    %r15
   3103b:	ret
