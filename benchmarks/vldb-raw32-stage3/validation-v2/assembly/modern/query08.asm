
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002f5f0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2f5f0:	push   %r15
   2f5f2:	push   %r14
   2f5f4:	push   %r13
   2f5f6:	mov    %r8,%r13
   2f5f9:	push   %r12
   2f5fb:	push   %rbp
   2f5fc:	mov    %rdx,%rbp
   2f5ff:	push   %rbx
   2f600:	mov    %rdi,%rbx
   2f603:	sub    $0x18,%rsp
   2f607:	mov    %rcx,0x8(%rsp)
   2f60c:	test   %esi,%esi
   2f60e:	je     2f678 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   2f610:	cmp    $0x1,%esi
   2f613:	mov    $0x1000,%r14d
   2f619:	mov    $0x1,%eax
   2f61e:	cmove  %rax,%r14
   2f622:	test   %rdx,%rdx
   2f625:	je     2f665 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2f627:	mov    %rdx,%r12
   2f62a:	xor    %r15d,%r15d
   2f62d:	nopl   (%rax)
   2f630:	mov    0x8(%rsp),%rax
   2f635:	lea    0x0(,%r15,4),%rdx
   2f63d:	lea    0x0(%r13,%rdx,1),%rcx
   2f642:	add    %rax,%rdx
   2f645:	cmp    %r12,%r14
   2f648:	mov    %r12,%rax
   2f64b:	cmovbe %r14,%rax
   2f64f:	mov    %rbx,%rdi
   2f652:	mov    %rax,%rsi
   2f655:	add    %r14,%r15
   2f658:	call   2f4d0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2f65d:	sub    %r14,%r12
   2f660:	cmp    %rbp,%r15
   2f663:	jb     2f630 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   2f665:	add    $0x18,%rsp
   2f669:	pop    %rbx
   2f66a:	pop    %rbp
   2f66b:	pop    %r12
   2f66d:	pop    %r13
   2f66f:	pop    %r14
   2f671:	pop    %r15
   2f673:	ret
   2f674:	nopl   0x0(%rax)
   2f678:	test   %rdx,%rdx
   2f67b:	je     2f665 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2f67d:	vmovdqa -0x2aed5(%rip),%xmm3        # 47b0 <bloom_filters::FastPatternBF::sparse_patterns_+0x210>
   2f685:	vmovdqa -0x2aeed(%rip),%xmm2        # 47a0 <bloom_filters::FastPatternBF::sparse_patterns_+0x200>
   2f68d:	xor    %edx,%edx
   2f68f:	movabs $0xd6e8feb86659fd93,%rcx
   2f699:	nopl   0x0(%rax)
   2f6a0:	mov    0x8(%rsp),%rax
   2f6a5:	mov    (%rax,%rdx,4),%eax
   2f6a8:	imul   %rcx,%rax
   2f6ac:	mov    %rax,%rsi
   2f6af:	shr    $0x20,%rsi
   2f6b3:	xor    %rsi,%rax
   2f6b6:	imul   %rcx,%rax
   2f6ba:	mov    %rax,%rsi
   2f6bd:	shr    $0x20,%rsi
   2f6c1:	xor    %rsi,%rax
   2f6c4:	mov    (%rbx),%esi
   2f6c6:	vpbroadcastd %eax,%xmm0
   2f6cc:	shr    $0x20,%rax
   2f6d0:	imul   %rsi,%rax
   2f6d4:	vpmulhw %xmm0,%xmm3,%xmm0
   2f6d8:	shr    $0x20,%rax
   2f6dc:	shl    $0x4,%rax
   2f6e0:	add    0x8(%rbx),%rax
   2f6e4:	vmovdqu (%rax),%xmm1
   2f6e8:	vpshufb %xmm0,%xmm2,%xmm0
   2f6ed:	xor    %eax,%eax
   2f6ef:	vptest %xmm0,%xmm1
   2f6f4:	setb   %al
   2f6f7:	mov    %eax,0x0(%r13,%rdx,4)
   2f6fc:	inc    %rdx
   2f6ff:	cmp    %rdx,%rbp
   2f702:	jne    2f6a0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::Fixed16>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::Fixed16> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
   2f704:	add    $0x18,%rsp
   2f708:	pop    %rbx
   2f709:	pop    %rbp
   2f70a:	pop    %r12
   2f70c:	pop    %r13
   2f70e:	pop    %r14
   2f710:	pop    %r15
   2f712:	ret
