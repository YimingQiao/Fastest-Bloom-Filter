
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002f390 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2f390:	push   %r15
   2f392:	push   %r14
   2f394:	push   %r13
   2f396:	mov    %r8,%r13
   2f399:	push   %r12
   2f39b:	push   %rbp
   2f39c:	mov    %rdx,%rbp
   2f39f:	push   %rbx
   2f3a0:	mov    %rdi,%rbx
   2f3a3:	sub    $0x18,%rsp
   2f3a7:	mov    %rcx,0x8(%rsp)
   2f3ac:	test   %esi,%esi
   2f3ae:	je     2f418 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   2f3b0:	cmp    $0x1,%esi
   2f3b3:	mov    $0x1000,%r14d
   2f3b9:	mov    $0x1,%eax
   2f3be:	cmove  %rax,%r14
   2f3c2:	test   %rdx,%rdx
   2f3c5:	je     2f405 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2f3c7:	mov    %rdx,%r12
   2f3ca:	xor    %r15d,%r15d
   2f3cd:	nopl   (%rax)
   2f3d0:	mov    0x8(%rsp),%rax
   2f3d5:	lea    0x0(,%r15,4),%rdx
   2f3dd:	lea    0x0(%r13,%rdx,1),%rcx
   2f3e2:	add    %rax,%rdx
   2f3e5:	cmp    %r12,%r14
   2f3e8:	mov    %r12,%rax
   2f3eb:	cmovbe %r14,%rax
   2f3ef:	mov    %rbx,%rdi
   2f3f2:	mov    %rax,%rsi
   2f3f5:	add    %r14,%r15
   2f3f8:	call   2f2d0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2f3fd:	sub    %r14,%r12
   2f400:	cmp    %rbp,%r15
   2f403:	jb     2f3d0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   2f405:	add    $0x18,%rsp
   2f409:	pop    %rbx
   2f40a:	pop    %rbp
   2f40b:	pop    %r12
   2f40d:	pop    %r13
   2f40f:	pop    %r14
   2f411:	pop    %r15
   2f413:	ret
   2f414:	nopl   0x0(%rax)
   2f418:	test   %rdx,%rdx
   2f41b:	je     2f405 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2f41d:	vmovdqa -0x2ac75(%rip),%xmm3        # 47b0 <bloom_filters::FastPatternBF::sparse_patterns_+0x210>
   2f425:	vmovdqa -0x2ac8d(%rip),%xmm2        # 47a0 <bloom_filters::FastPatternBF::sparse_patterns_+0x200>
   2f42d:	xor    %edx,%edx
   2f42f:	movabs $0xd6e8feb86659fd93,%rcx
   2f439:	nopl   0x0(%rax)
   2f440:	mov    0x8(%rsp),%rax
   2f445:	mov    (%rax,%rdx,4),%eax
   2f448:	imul   %rcx,%rax
   2f44c:	mov    %rax,%rsi
   2f44f:	shr    $0x20,%rsi
   2f453:	xor    %rsi,%rax
   2f456:	imul   %rcx,%rax
   2f45a:	mov    %rax,%rsi
   2f45d:	shr    $0x20,%rsi
   2f461:	xor    %rsi,%rax
   2f464:	mov    (%rbx),%esi
   2f466:	vpbroadcastd %eax,%xmm0
   2f46c:	shr    $0x20,%rax
   2f470:	imul   %rsi,%rax
   2f474:	vpmulhw %xmm0,%xmm3,%xmm0
   2f478:	shr    $0x20,%rax
   2f47c:	shl    $0x4,%rax
   2f480:	add    0x8(%rbx),%rax
   2f484:	vmovdqu (%rax),%xmm1
   2f488:	vpshufb %xmm0,%xmm2,%xmm0
   2f48d:	xor    %eax,%eax
   2f48f:	vptest %xmm0,%xmm1
   2f494:	setb   %al
   2f497:	mov    %eax,0x0(%r13,%rdx,4)
   2f49c:	inc    %rdx
   2f49f:	cmp    %rdx,%rbp
   2f4a2:	jne    2f440 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > >(raw32_stage3::RawHash<external_bloom::Fixed16, raw32_stage3::ModernPolicy<external_bloom::Fixed16> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
   2f4a4:	add    $0x18,%rsp
   2f4a8:	pop    %rbx
   2f4a9:	pop    %rbp
   2f4aa:	pop    %r12
   2f4ac:	pop    %r13
   2f4ae:	pop    %r14
   2f4b0:	pop    %r15
   2f4b2:	ret
