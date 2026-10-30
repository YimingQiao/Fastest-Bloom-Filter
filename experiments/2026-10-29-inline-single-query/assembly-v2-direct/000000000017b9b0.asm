000000000017b9b0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17b9b0:	test   %rsi,%rsi
  17b9b3:	je     17bb50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17b9b9:	mov    %esi,%eax
  17b9bb:	and    $0x3,%eax
  17b9be:	cmp    $0x4,%rsi
  17b9c2:	jae    17b9cc <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  17b9c4:	xor    %r8d,%r8d
  17b9c7:	jmp    17bae8 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
  17b9cc:	and    $0xfffffffffffffffc,%rsi
  17b9d0:	xor    %r8d,%r8d
  17b9d3:	vmovdqa -0x176d9b(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17b9db:	vpbroadcastq -0x1786f4(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17b9e4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  17b9f0:	mov    (%rdx,%r8,8),%r9
  17b9f4:	vpbroadcastd %r9d,%xmm2
  17b9fa:	shr    $0x20,%r9
  17b9fe:	and    0x18(%rdi),%r9d
  17ba02:	mov    (%rdi),%r10
  17ba05:	shl    $0x4,%r9
  17ba09:	vmovdqa (%r10,%r9,1),%xmm3
  17ba0f:	vpmulhw %xmm0,%xmm2,%xmm2
  17ba13:	vpshufb %xmm2,%xmm1,%xmm2
  17ba18:	xor    %r9d,%r9d
  17ba1b:	vptest %xmm2,%xmm3
  17ba20:	setb   %r9b
  17ba24:	mov    %r9d,(%rcx,%r8,4)
  17ba28:	mov    0x8(%rdx,%r8,8),%r9
  17ba2d:	vpbroadcastd %r9d,%xmm2
  17ba33:	shr    $0x20,%r9
  17ba37:	and    0x18(%rdi),%r9d
  17ba3b:	mov    (%rdi),%r10
  17ba3e:	shl    $0x4,%r9
  17ba42:	vmovdqa (%r10,%r9,1),%xmm3
  17ba48:	vpmulhw %xmm0,%xmm2,%xmm2
  17ba4c:	vpshufb %xmm2,%xmm1,%xmm2
  17ba51:	xor    %r9d,%r9d
  17ba54:	vptest %xmm2,%xmm3
  17ba59:	setb   %r9b
  17ba5d:	mov    %r9d,0x4(%rcx,%r8,4)
  17ba62:	mov    0x10(%rdx,%r8,8),%r9
  17ba67:	vpbroadcastd %r9d,%xmm2
  17ba6d:	shr    $0x20,%r9
  17ba71:	and    0x18(%rdi),%r9d
  17ba75:	mov    (%rdi),%r10
  17ba78:	shl    $0x4,%r9
  17ba7c:	vmovdqa (%r10,%r9,1),%xmm3
  17ba82:	vpmulhw %xmm0,%xmm2,%xmm2
  17ba86:	vpshufb %xmm2,%xmm1,%xmm2
  17ba8b:	xor    %r9d,%r9d
  17ba8e:	vptest %xmm2,%xmm3
  17ba93:	setb   %r9b
  17ba97:	mov    %r9d,0x8(%rcx,%r8,4)
  17ba9c:	mov    0x18(%rdx,%r8,8),%r9
  17baa1:	vpbroadcastd %r9d,%xmm2
  17baa7:	shr    $0x20,%r9
  17baab:	and    0x18(%rdi),%r9d
  17baaf:	mov    (%rdi),%r10
  17bab2:	shl    $0x4,%r9
  17bab6:	vmovdqa (%r10,%r9,1),%xmm3
  17babc:	vpmulhw %xmm0,%xmm2,%xmm2
  17bac0:	vpshufb %xmm2,%xmm1,%xmm2
  17bac5:	xor    %r9d,%r9d
  17bac8:	vptest %xmm2,%xmm3
  17bacd:	setb   %r9b
  17bad1:	mov    %r9d,0xc(%rcx,%r8,4)
  17bad6:	add    $0x4,%r8
  17bada:	cmp    %r8,%rsi
  17badd:	jne    17b9f0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17bae3:	test   %rax,%rax
  17bae6:	je     17bb50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17bae8:	lea    (%rcx,%r8,4),%rcx
  17baec:	lea    (%rdx,%r8,8),%rdx
  17baf0:	xor    %esi,%esi
  17baf2:	vmovdqa -0x176eba(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17bafa:	vpbroadcastq -0x178813(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17bb03:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  17bb10:	mov    (%rdx,%rsi,8),%r8
  17bb14:	vpbroadcastd %r8d,%xmm2
  17bb1a:	shr    $0x20,%r8
  17bb1e:	and    0x18(%rdi),%r8d
  17bb22:	mov    (%rdi),%r9
  17bb25:	shl    $0x4,%r8
  17bb29:	vmovdqa (%r9,%r8,1),%xmm3
  17bb2f:	vpmulhw %xmm0,%xmm2,%xmm2
  17bb33:	vpshufb %xmm2,%xmm1,%xmm2
  17bb38:	xor    %r8d,%r8d
  17bb3b:	vptest %xmm2,%xmm3
  17bb40:	setb   %r8b
  17bb44:	mov    %r8d,(%rcx,%rsi,4)
  17bb48:	inc    %rsi
  17bb4b:	cmp    %rsi,%rax
  17bb4e:	jne    17bb10 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x160>
  17bb50:	ret
  17bb51:	int3
  17bb52:	int3
  17bb53:	int3
  17bb54:	int3
  17bb55:	int3
  17bb56:	int3
  17bb57:	int3
  17bb58:	int3
  17bb59:	int3
  17bb5a:	int3
  17bb5b:	int3
  17bb5c:	int3
  17bb5d:	int3
  17bb5e:	int3
  17bb5f:	int3

