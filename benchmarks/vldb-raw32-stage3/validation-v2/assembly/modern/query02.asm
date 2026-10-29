
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002e340 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2e340:	push   %r15
   2e342:	push   %r14
   2e344:	push   %r13
   2e346:	mov    %r8,%r13
   2e349:	push   %r12
   2e34b:	push   %rbp
   2e34c:	mov    %rdx,%rbp
   2e34f:	push   %rbx
   2e350:	mov    %rdi,%rbx
   2e353:	sub    $0x18,%rsp
   2e357:	mov    %rcx,0x8(%rsp)
   2e35c:	test   %esi,%esi
   2e35e:	je     2e3c8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   2e360:	cmp    $0x1,%esi
   2e363:	mov    $0x1000,%r14d
   2e369:	mov    $0x1,%eax
   2e36e:	cmove  %rax,%r14
   2e372:	test   %rdx,%rdx
   2e375:	je     2e3b5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2e377:	mov    %rdx,%r12
   2e37a:	xor    %r15d,%r15d
   2e37d:	nopl   (%rax)
   2e380:	mov    0x8(%rsp),%rax
   2e385:	lea    0x0(,%r15,4),%rdx
   2e38d:	lea    0x0(%r13,%rdx,1),%rcx
   2e392:	add    %rax,%rdx
   2e395:	cmp    %r12,%r14
   2e398:	mov    %r12,%rax
   2e39b:	cmovbe %r14,%rax
   2e39f:	mov    %rbx,%rdi
   2e3a2:	mov    %rax,%rsi
   2e3a5:	add    %r14,%r15
   2e3a8:	call   2e230 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2e3ad:	sub    %r14,%r12
   2e3b0:	cmp    %rbp,%r15
   2e3b3:	jb     2e380 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   2e3b5:	add    $0x18,%rsp
   2e3b9:	pop    %rbx
   2e3ba:	pop    %rbp
   2e3bb:	pop    %r12
   2e3bd:	pop    %r13
   2e3bf:	pop    %r14
   2e3c1:	pop    %r15
   2e3c3:	ret
   2e3c4:	nopl   0x0(%rax)
   2e3c8:	test   %rdx,%rdx
   2e3cb:	je     2e3b5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2e3cd:	vmovdqa -0x29c25(%rip),%xmm3        # 47b0 <bloom_filters::FastPatternBF::sparse_patterns_+0x210>
   2e3d5:	vmovdqa -0x29c3d(%rip),%xmm2        # 47a0 <bloom_filters::FastPatternBF::sparse_patterns_+0x200>
   2e3dd:	xor    %edx,%edx
   2e3df:	movabs $0xd6e8feb86659fd93,%rcx
   2e3e9:	nopl   0x0(%rax)
   2e3f0:	mov    0x8(%rsp),%rax
   2e3f5:	mov    (%rax,%rdx,4),%eax
   2e3f8:	imul   %rcx,%rax
   2e3fc:	mov    %rax,%rsi
   2e3ff:	shr    $0x20,%rsi
   2e403:	xor    %rsi,%rax
   2e406:	imul   %rcx,%rax
   2e40a:	mov    %rax,%rsi
   2e40d:	shr    $0x20,%rsi
   2e411:	xor    %rsi,%rax
   2e414:	vpbroadcastd %eax,%xmm0
   2e41a:	vpmulhw %xmm0,%xmm3,%xmm0
   2e41e:	shr    $0x20,%rax
   2e422:	and    0x18(%rbx),%eax
   2e425:	shl    $0x4,%rax
   2e429:	add    (%rbx),%rax
   2e42c:	vmovdqa (%rax),%xmm1
   2e430:	vpshufb %xmm0,%xmm2,%xmm0
   2e435:	xor    %eax,%eax
   2e437:	vptest %xmm0,%xmm1
   2e43c:	setb   %al
   2e43f:	mov    %eax,0x0(%r13,%rdx,4)
   2e444:	inc    %rdx
   2e447:	cmp    %rdx,%rbp
   2e44a:	jne    2e3f0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
   2e44c:	add    $0x18,%rsp
   2e450:	pop    %rbx
   2e451:	pop    %rbp
   2e452:	pop    %r12
   2e454:	pop    %r13
   2e456:	pop    %r14
   2e458:	pop    %r15
   2e45a:	ret
