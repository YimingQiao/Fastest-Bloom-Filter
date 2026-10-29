
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000386960 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  386960:	push   %r15
  386962:	push   %r14
  386964:	push   %r13
  386966:	mov    %r8,%r13
  386969:	push   %r12
  38696b:	push   %rbp
  38696c:	mov    %rdx,%rbp
  38696f:	push   %rbx
  386970:	mov    %rdi,%rbx
  386973:	sub    $0x18,%rsp
  386977:	mov    %rcx,0x8(%rsp)
  38697c:	test   %esi,%esi
  38697e:	je     3869e8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  386980:	cmp    $0x1,%esi
  386983:	mov    $0x1000,%r14d
  386989:	mov    $0x1,%eax
  38698e:	cmove  %rax,%r14
  386992:	test   %rdx,%rdx
  386995:	je     3869d5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  386997:	mov    %rdx,%r12
  38699a:	xor    %r15d,%r15d
  38699d:	nopl   (%rax)
  3869a0:	mov    0x8(%rsp),%rax
  3869a5:	lea    0x0(,%r15,4),%rdx
  3869ad:	lea    0x0(%r13,%rdx,1),%rcx
  3869b2:	add    %rax,%rdx
  3869b5:	cmp    %r12,%r14
  3869b8:	mov    %r12,%rax
  3869bb:	cmovbe %r14,%rax
  3869bf:	mov    %rbx,%rdi
  3869c2:	mov    %rax,%rsi
  3869c5:	add    %r14,%r15
  3869c8:	call   386850 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)>
  3869cd:	sub    %r14,%r12
  3869d0:	cmp    %rbp,%r15
  3869d3:	jb     3869a0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  3869d5:	add    $0x18,%rsp
  3869d9:	pop    %rbx
  3869da:	pop    %rbp
  3869db:	pop    %r12
  3869dd:	pop    %r13
  3869df:	pop    %r14
  3869e1:	pop    %r15
  3869e3:	ret
  3869e4:	nopl   0x0(%rax)
  3869e8:	test   %rdx,%rdx
  3869eb:	je     3869d5 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  3869ed:	vmovdqa -0x30c415(%rip),%xmm3        # 7a5e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1180>
  3869f5:	vmovdqa -0x30c4bd(%rip),%xmm2        # 7a540 <bloom_filters::FastPatternBF::sparse_patterns_+0x10e0>
  3869fd:	xor    %edx,%edx
  3869ff:	movabs $0xd6e8feb86659fd93,%rcx
  386a09:	nopl   0x0(%rax)
  386a10:	mov    0x8(%rsp),%rax
  386a15:	mov    (%rax,%rdx,4),%eax
  386a18:	imul   %rcx,%rax
  386a1c:	mov    %rax,%rsi
  386a1f:	shr    $0x20,%rsi
  386a23:	xor    %rsi,%rax
  386a26:	imul   %rcx,%rax
  386a2a:	mov    %rax,%rsi
  386a2d:	shr    $0x20,%rsi
  386a31:	xor    %rsi,%rax
  386a34:	vpbroadcastd %eax,%xmm0
  386a3a:	vpmulhw %xmm0,%xmm3,%xmm0
  386a3e:	shr    $0x20,%rax
  386a42:	and    0x18(%rbx),%eax
  386a45:	shl    $0x4,%rax
  386a49:	add    (%rbx),%rax
  386a4c:	vmovdqa (%rax),%xmm1
  386a50:	vpshufb %xmm0,%xmm2,%xmm0
  386a55:	xor    %eax,%eax
  386a57:	vptest %xmm0,%xmm1
  386a5c:	setb   %al
  386a5f:	mov    %eax,0x0(%r13,%rdx,4)
  386a64:	inc    %rdx
  386a67:	cmp    %rdx,%rbp
  386a6a:	jne    386a10 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xb0>
  386a6c:	add    $0x18,%rsp
  386a70:	pop    %rbx
  386a71:	pop    %rbp
  386a72:	pop    %r12
  386a74:	pop    %r13
  386a76:	pop    %r14
  386a78:	pop    %r15
  386a7a:	ret
