
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

0000000000023070 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   23070:	push   %r15
   23072:	push   %r14
   23074:	push   %r13
   23076:	mov    %r8,%r13
   23079:	push   %r12
   2307b:	push   %rbp
   2307c:	mov    %rdx,%rbp
   2307f:	push   %rbx
   23080:	mov    %rdi,%rbx
   23083:	sub    $0x18,%rsp
   23087:	mov    %rcx,0x8(%rsp)
   2308c:	test   %esi,%esi
   2308e:	je     230f8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   23090:	cmp    $0x1,%esi
   23093:	mov    $0x1000,%r14d
   23099:	mov    $0x1,%eax
   2309e:	cmove  %rax,%r14
   230a2:	test   %rdx,%rdx
   230a5:	je     230e5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   230a7:	mov    %rdx,%r12
   230aa:	xor    %r15d,%r15d
   230ad:	nopl   (%rax)
   230b0:	mov    0x8(%rsp),%rax
   230b5:	lea    0x0(,%r15,4),%rdx
   230bd:	lea    0x0(%r13,%rdx,1),%rcx
   230c2:	add    %rax,%rdx
   230c5:	cmp    %r12,%r14
   230c8:	mov    %r12,%rax
   230cb:	cmovbe %r14,%rax
   230cf:	mov    %rbx,%rdi
   230d2:	mov    %rax,%rsi
   230d5:	add    %r14,%r15
   230d8:	call   22f60 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)>
   230dd:	sub    %r14,%r12
   230e0:	cmp    %rbp,%r15
   230e3:	jb     230b0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   230e5:	add    $0x18,%rsp
   230e9:	pop    %rbx
   230ea:	pop    %rbp
   230eb:	pop    %r12
   230ed:	pop    %r13
   230ef:	pop    %r14
   230f1:	pop    %r15
   230f3:	ret
   230f4:	nopl   0x0(%rax)
   230f8:	test   %rdx,%rdx
   230fb:	je     230e5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   230fd:	vmovdqa -0x1ec95(%rip),%xmm3        # 4470 <bloom_filters::FastPatternBF::sparse_patterns_+0x190>
   23105:	vmovdqa -0x1ecad(%rip),%xmm2        # 4460 <bloom_filters::FastPatternBF::sparse_patterns_+0x180>
   2310d:	xor    %edx,%edx
   2310f:	movabs $0xd6e8feb86659fd93,%rcx
   23119:	nopl   0x0(%rax)
   23120:	mov    0x8(%rsp),%rax
   23125:	mov    (%rax,%rdx,4),%eax
   23128:	imul   %rcx,%rax
   2312c:	mov    %rax,%rsi
   2312f:	shr    $0x20,%rsi
   23133:	xor    %rsi,%rax
   23136:	imul   %rcx,%rax
   2313a:	mov    %rax,%rsi
   2313d:	shr    $0x20,%rsi
   23141:	xor    %rsi,%rax
   23144:	vpbroadcastd %eax,%xmm0
   2314a:	vpmulhw %xmm0,%xmm3,%xmm0
   2314e:	shr    $0x20,%rax
   23152:	and    0x18(%rbx),%eax
   23155:	shl    $0x4,%rax
   23159:	add    (%rbx),%rax
   2315c:	vmovdqa (%rax),%xmm1
   23160:	vpshufb %xmm0,%xmm2,%xmm0
   23165:	xor    %eax,%eax
   23167:	vptest %xmm0,%xmm1
   2316c:	setb   %al
   2316f:	mov    %eax,0x0(%r13,%rdx,4)
   23174:	inc    %rdx
   23177:	cmp    %rdx,%rbp
   2317a:	jne    23120 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
   2317c:	add    $0x18,%rsp
   23180:	pop    %rbx
   23181:	pop    %rbp
   23182:	pop    %r12
   23184:	pop    %r13
   23186:	pop    %r14
   23188:	pop    %r15
   2318a:	ret
