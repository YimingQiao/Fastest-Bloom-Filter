000000000017a9b0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17a9b0:	48 85 f6             	test   %rsi,%rsi
  17a9b3:	0f 84 97 01 00 00    	je     17ab50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17a9b9:	89 f0                	mov    %esi,%eax
  17a9bb:	83 e0 03             	and    $0x3,%eax
  17a9be:	48 83 fe 04          	cmp    $0x4,%rsi
  17a9c2:	73 08                	jae    17a9cc <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  17a9c4:	45 31 c0             	xor    %r8d,%r8d
  17a9c7:	e9 1c 01 00 00       	jmp    17aae8 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
  17a9cc:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  17a9d0:	45 31 c0             	xor    %r8d,%r8d
  17a9d3:	c5 f9 6f 05 65 a2 e8 	vmovdqa -0x175d9b(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17a9da:	ff
  17a9db:	c4 e2 79 59 0d 0c 89 	vpbroadcastq -0x1776f4(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17a9e2:	e8 ff
  17a9e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  17a9eb:	00 00 00 00 00
  17a9f0:	4e 8b 0c c2          	mov    (%rdx,%r8,8),%r9
  17a9f4:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
  17a9fa:	49 c1 e9 20          	shr    $0x20,%r9
  17a9fe:	44 23 4f 18          	and    0x18(%rdi),%r9d
  17aa02:	4c 8b 17             	mov    (%rdi),%r10
  17aa05:	49 c1 e1 04          	shl    $0x4,%r9
  17aa09:	c4 81 79 6f 1c 0a    	vmovdqa (%r10,%r9,1),%xmm3
  17aa0f:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
  17aa13:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
  17aa18:	45 31 c9             	xor    %r9d,%r9d
  17aa1b:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
  17aa20:	41 0f 92 c1          	setb   %r9b
  17aa24:	46 89 0c 81          	mov    %r9d,(%rcx,%r8,4)
  17aa28:	4e 8b 4c c2 08       	mov    0x8(%rdx,%r8,8),%r9
  17aa2d:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
  17aa33:	49 c1 e9 20          	shr    $0x20,%r9
  17aa37:	44 23 4f 18          	and    0x18(%rdi),%r9d
  17aa3b:	4c 8b 17             	mov    (%rdi),%r10
  17aa3e:	49 c1 e1 04          	shl    $0x4,%r9
  17aa42:	c4 81 79 6f 1c 0a    	vmovdqa (%r10,%r9,1),%xmm3
  17aa48:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
  17aa4c:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
  17aa51:	45 31 c9             	xor    %r9d,%r9d
  17aa54:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
  17aa59:	41 0f 92 c1          	setb   %r9b
  17aa5d:	46 89 4c 81 04       	mov    %r9d,0x4(%rcx,%r8,4)
  17aa62:	4e 8b 4c c2 10       	mov    0x10(%rdx,%r8,8),%r9
  17aa67:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
  17aa6d:	49 c1 e9 20          	shr    $0x20,%r9
  17aa71:	44 23 4f 18          	and    0x18(%rdi),%r9d
  17aa75:	4c 8b 17             	mov    (%rdi),%r10
  17aa78:	49 c1 e1 04          	shl    $0x4,%r9
  17aa7c:	c4 81 79 6f 1c 0a    	vmovdqa (%r10,%r9,1),%xmm3
  17aa82:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
  17aa86:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
  17aa8b:	45 31 c9             	xor    %r9d,%r9d
  17aa8e:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
  17aa93:	41 0f 92 c1          	setb   %r9b
  17aa97:	46 89 4c 81 08       	mov    %r9d,0x8(%rcx,%r8,4)
  17aa9c:	4e 8b 4c c2 18       	mov    0x18(%rdx,%r8,8),%r9
  17aaa1:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
  17aaa7:	49 c1 e9 20          	shr    $0x20,%r9
  17aaab:	44 23 4f 18          	and    0x18(%rdi),%r9d
  17aaaf:	4c 8b 17             	mov    (%rdi),%r10
  17aab2:	49 c1 e1 04          	shl    $0x4,%r9
  17aab6:	c4 81 79 6f 1c 0a    	vmovdqa (%r10,%r9,1),%xmm3
  17aabc:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
  17aac0:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
  17aac5:	45 31 c9             	xor    %r9d,%r9d
  17aac8:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
  17aacd:	41 0f 92 c1          	setb   %r9b
  17aad1:	46 89 4c 81 0c       	mov    %r9d,0xc(%rcx,%r8,4)
  17aad6:	49 83 c0 04          	add    $0x4,%r8
  17aada:	4c 39 c6             	cmp    %r8,%rsi
  17aadd:	0f 85 0d ff ff ff    	jne    17a9f0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17aae3:	48 85 c0             	test   %rax,%rax
  17aae6:	74 68                	je     17ab50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17aae8:	4a 8d 0c 81          	lea    (%rcx,%r8,4),%rcx
  17aaec:	4a 8d 14 c2          	lea    (%rdx,%r8,8),%rdx
  17aaf0:	31 f6                	xor    %esi,%esi
  17aaf2:	c5 f9 6f 05 46 a1 e8 	vmovdqa -0x175eba(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17aaf9:	ff
  17aafa:	c4 e2 79 59 0d ed 87 	vpbroadcastq -0x177813(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17ab01:	e8 ff
  17ab03:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  17ab0a:	84 00 00 00 00 00
  17ab10:	4c 8b 04 f2          	mov    (%rdx,%rsi,8),%r8
  17ab14:	62 d2 7d 08 7c d0    	vpbroadcastd %r8d,%xmm2
  17ab1a:	49 c1 e8 20          	shr    $0x20,%r8
  17ab1e:	44 23 47 18          	and    0x18(%rdi),%r8d
  17ab22:	4c 8b 0f             	mov    (%rdi),%r9
  17ab25:	49 c1 e0 04          	shl    $0x4,%r8
  17ab29:	c4 81 79 6f 1c 01    	vmovdqa (%r9,%r8,1),%xmm3
  17ab2f:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
  17ab33:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
  17ab38:	45 31 c0             	xor    %r8d,%r8d
  17ab3b:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
  17ab40:	41 0f 92 c0          	setb   %r8b
  17ab44:	44 89 04 b1          	mov    %r8d,(%rcx,%rsi,4)
  17ab48:	48 ff c6             	inc    %rsi
  17ab4b:	48 39 f0             	cmp    %rsi,%rax
  17ab4e:	75 c0                	jne    17ab10 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x160>
  17ab50:	c3                   	ret
  17ab51:	cc                   	int3
  17ab52:	cc                   	int3
  17ab53:	cc                   	int3
  17ab54:	cc                   	int3
  17ab55:	cc                   	int3
  17ab56:	cc                   	int3
  17ab57:	cc                   	int3
  17ab58:	cc                   	int3
  17ab59:	cc                   	int3
  17ab5a:	cc                   	int3
  17ab5b:	cc                   	int3
  17ab5c:	cc                   	int3
  17ab5d:	cc                   	int3
  17ab5e:	cc                   	int3
  17ab5f:	cc                   	int3
