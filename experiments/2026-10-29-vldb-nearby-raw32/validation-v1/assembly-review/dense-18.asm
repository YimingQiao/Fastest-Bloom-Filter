
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000386850 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)>:
  386850:	mov    %esi,%r11d
  386853:	mov    %rcx,%rsi
  386856:	mov    %r11d,%ecx
  386859:	test   %rcx,%rcx
  38685c:	je     386950 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)+0x100>
  386862:	push   %rbx
  386863:	movabs $0xd6e8feb86659fd93,%r8
  38686d:	mov    %rdx,%rbx
  386870:	xor    %edx,%edx
  386872:	nopw   0x0(%rax,%rax,1)
  386878:	mov    (%rbx,%rdx,4),%eax
  38687b:	imul   %r8,%rax
  38687f:	mov    %rax,%r9
  386882:	shr    $0x20,%r9
  386886:	xor    %r9,%rax
  386889:	imul   %r8,%rax
  38688d:	mov    0x120(%rdi),%r9
  386894:	mov    %rax,%r10
  386897:	shr    $0x20,%r10
  38689b:	xor    %r10,%rax
  38689e:	mov    %rax,(%r9,%rdx,8)
  3868a2:	inc    %rdx
  3868a5:	cmp    %rcx,%rdx
  3868a8:	jne    386878 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)+0x28>
  3868aa:	mov    0x120(%rdi),%r9
  3868b1:	cmp    $0x1,%r11d
  3868b5:	je     386910 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)+0xc0>
  3868b7:	vmovdqa -0x30c2df(%rip),%xmm3        # 7a5e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1180>
  3868bf:	vmovdqa -0x30c387(%rip),%xmm2        # 7a540 <bloom_filters::FastPatternBF::sparse_patterns_+0x10e0>
  3868c7:	xor    %edx,%edx
  3868c9:	nopl   0x0(%rax)
  3868d0:	mov    (%r9,%rdx,8),%rax
  3868d4:	xor    %r8d,%r8d
  3868d7:	vpbroadcastd %eax,%xmm0
  3868dd:	vpmulhw %xmm0,%xmm3,%xmm0
  3868e1:	shr    $0x20,%rax
  3868e5:	and    0x18(%rdi),%eax
  3868e8:	shl    $0x4,%rax
  3868ec:	add    (%rdi),%rax
  3868ef:	vmovdqa (%rax),%xmm1
  3868f3:	vpshufb %xmm0,%xmm2,%xmm0
  3868f8:	vptest %xmm0,%xmm1
  3868fd:	setb   %r8b
  386901:	mov    %r8d,(%rsi,%rdx,4)
  386905:	inc    %rdx
  386908:	cmp    %rcx,%rdx
  38690b:	jne    3868d0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > >(raw32_stage3::RawHash<bloom_filters::ByteSplitBloomFilter, raw32_stage3::NativePolicy<bloom_filters::ByteSplitBloomFilter, -1> > const&, unsigned int, unsigned int const*, unsigned int*)+0x80>
  38690d:	pop    %rbx
  38690e:	ret
  38690f:	nop
  386910:	mov    (%r9),%rax
  386913:	vmovdqa -0x30c3db(%rip),%xmm0        # 7a540 <bloom_filters::FastPatternBF::sparse_patterns_+0x10e0>
  38691b:	vpbroadcastd %eax,%xmm1
  386921:	shr    $0x20,%rax
  386925:	and    0x18(%rdi),%eax
  386928:	shl    $0x4,%rax
  38692c:	add    (%rdi),%rax
  38692f:	vpmulhw -0x30c357(%rip),%xmm1,%xmm1        # 7a5e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1180>
  386937:	vpshufb %xmm1,%xmm0,%xmm0
  38693c:	vmovdqa (%rax),%xmm1
  386940:	xor    %edx,%edx
  386942:	vptest %xmm0,%xmm1
  386947:	pop    %rbx
  386948:	setb   %dl
  38694b:	mov    %edx,(%rsi)
  38694d:	ret
  38694e:	xchg   %ax,%ax
  386950:	ret
