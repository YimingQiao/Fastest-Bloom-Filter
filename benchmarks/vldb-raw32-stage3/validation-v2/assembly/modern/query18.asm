
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000031180 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   31180:	push   %r15
   31182:	push   %r14
   31184:	push   %r13
   31186:	mov    %r8,%r13
   31189:	push   %r12
   3118b:	mov    %rcx,%r12
   3118e:	push   %rbp
   3118f:	push   %rbx
   31190:	mov    %rdx,%rbx
   31193:	sub    $0x28,%rsp
   31197:	mov    %rdi,0x8(%rsp)
   3119c:	test   %esi,%esi
   3119e:	je     31208 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   311a0:	cmp    $0x1,%esi
   311a3:	mov    $0x1000,%r14d
   311a9:	mov    $0x1,%eax
   311ae:	cmove  %rax,%r14
   311b2:	test   %rdx,%rdx
   311b5:	je     311f2 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   311b7:	mov    %rdx,%rbp
   311ba:	xor    %r15d,%r15d
   311bd:	nopl   (%rax)
   311c0:	lea    0x0(,%r15,4),%rdx
   311c8:	lea    0x0(%r13,%rdx,1),%rcx
   311cd:	mov    %r14,%rax
   311d0:	add    %r12,%rdx
   311d3:	cmp    %r14,%rbp
   311d6:	cmovbe %rbp,%rax
   311da:	mov    0x8(%rsp),%rdi
   311df:	mov    %rax,%rsi
   311e2:	add    %r14,%r15
   311e5:	call   31050 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   311ea:	sub    %r14,%rbp
   311ed:	cmp    %rbx,%r15
   311f0:	jb     311c0 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   311f2:	add    $0x28,%rsp
   311f6:	pop    %rbx
   311f7:	pop    %rbp
   311f8:	pop    %r12
   311fa:	pop    %r13
   311fc:	pop    %r14
   311fe:	pop    %r15
   31200:	ret
   31201:	nopl   0x0(%rax)
   31208:	xor    %r14d,%r14d
   3120b:	lea    0x1c(%rsp),%r15
   31210:	test   %rdx,%rdx
   31213:	je     311f2 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31215:	nopl   (%rax)
   31218:	mov    (%r12,%r14,4),%eax
   3121c:	mov    0x8(%rsp),%rdi
   31221:	mov    %r15,%rsi
   31224:	mov    %eax,0x1c(%rsp)
   31228:	call   bea0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   3122d:	movzbl %al,%eax
   31230:	mov    %eax,0x0(%r13,%r14,4)
   31235:	inc    %r14
   31238:	cmp    %r14,%rbx
   3123b:	jne    31218 <void vldb_stage2::Query<raw32_stage3::RawPage<4u, true> >(raw32_stage3::RawPage<4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   3123d:	add    $0x28,%rsp
   31241:	pop    %rbx
   31242:	pop    %rbp
   31243:	pop    %r12
   31245:	pop    %r13
   31247:	pop    %r14
   31249:	pop    %r15
   3124b:	ret
