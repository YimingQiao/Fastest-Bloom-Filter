
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000049b280 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  49b280:	push   %r15
  49b282:	push   %r14
  49b284:	push   %r13
  49b286:	mov    %r8,%r13
  49b289:	push   %r12
  49b28b:	push   %rbp
  49b28c:	mov    %rdx,%rbp
  49b28f:	push   %rbx
  49b290:	mov    %rdi,%rbx
  49b293:	sub    $0x18,%rsp
  49b297:	mov    %rcx,0x8(%rsp)
  49b29c:	test   %esi,%esi
  49b29e:	je     49b308 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  49b2a0:	cmp    $0x1,%esi
  49b2a3:	mov    $0x1000,%r14d
  49b2a9:	mov    $0x1,%eax
  49b2ae:	cmove  %rax,%r14
  49b2b2:	test   %rdx,%rdx
  49b2b5:	je     49b2f5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  49b2b7:	mov    %rdx,%r12
  49b2ba:	xor    %r15d,%r15d
  49b2bd:	nopl   (%rax)
  49b2c0:	mov    0x8(%rsp),%rax
  49b2c5:	lea    0x0(,%r15,4),%rdx
  49b2cd:	lea    0x0(%r13,%rdx,1),%rcx
  49b2d2:	add    %rax,%rdx
  49b2d5:	cmp    %r12,%r14
  49b2d8:	mov    %r12,%rax
  49b2db:	cmovbe %r14,%rax
  49b2df:	mov    %rbx,%rdi
  49b2e2:	mov    %rax,%rsi
  49b2e5:	add    %r14,%r15
  49b2e8:	call   49b170 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)>
  49b2ed:	sub    %r14,%r12
  49b2f0:	cmp    %rbp,%r15
  49b2f3:	jb     49b2c0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  49b2f5:	add    $0x18,%rsp
  49b2f9:	pop    %rbx
  49b2fa:	pop    %rbp
  49b2fb:	pop    %r12
  49b2fd:	pop    %r13
  49b2ff:	pop    %r14
  49b301:	pop    %r15
  49b303:	ret
  49b304:	nopl   0x0(%rax)
  49b308:	test   %rdx,%rdx
  49b30b:	je     49b2f5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  49b30d:	vmovdqa -0x29f1c5(%rip),%xmm3        # 1fc150 <bloom_filters::FastPatternBF::sparse_patterns_+0xbd0>
  49b315:	vmovdqa -0x29f26d(%rip),%xmm2        # 1fc0b0 <bloom_filters::FastPatternBF::sparse_patterns_+0xb30>
  49b31d:	xor    %edx,%edx
  49b31f:	movabs $0xd6e8feb86659fd93,%rcx
  49b329:	nopl   0x0(%rax)
  49b330:	mov    0x8(%rsp),%rax
  49b335:	mov    (%rax,%rdx,4),%eax
  49b338:	imul   %rcx,%rax
  49b33c:	mov    %rax,%rsi
  49b33f:	shr    $0x20,%rsi
  49b343:	xor    %rsi,%rax
  49b346:	imul   %rcx,%rax
  49b34a:	mov    %rax,%rsi
  49b34d:	shr    $0x20,%rsi
  49b351:	xor    %rsi,%rax
  49b354:	vpbroadcastd %eax,%xmm0
  49b35a:	vpmulhw %xmm0,%xmm3,%xmm0
  49b35e:	shr    $0x20,%rax
  49b362:	and    0x18(%rbx),%eax
  49b365:	shl    $0x4,%rax
  49b369:	add    (%rbx),%rax
  49b36c:	vmovdqa (%rax),%xmm1
  49b370:	vpshufb %xmm0,%xmm2,%xmm0
  49b375:	xor    %eax,%eax
  49b377:	vptest %xmm0,%xmm1
  49b37c:	setb   %al
  49b37f:	mov    %eax,0x0(%r13,%rdx,4)
  49b384:	inc    %rdx
  49b387:	cmp    %rdx,%rbp
  49b38a:	jne    49b330 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
  49b38c:	add    $0x18,%rsp
  49b390:	pop    %rbx
  49b391:	pop    %rbp
  49b392:	pop    %r12
  49b394:	pop    %r13
  49b396:	pop    %r14
  49b398:	pop    %r15
  49b39a:	ret
