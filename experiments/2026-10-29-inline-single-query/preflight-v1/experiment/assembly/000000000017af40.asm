000000000017af40 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17af40:	48 85 f6             	test   %rsi,%rsi
  17af43:	0f 84 62 01 00 00    	je     17b0ab <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16b>
  17af49:	53                   	push   %rbx
  17af4a:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
  17af51:	fe e8 d6
  17af54:	48 83 fe 01          	cmp    $0x1,%rsi
  17af58:	75 07                	jne    17af61 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  17af5a:	31 c0                	xor    %eax,%eax
  17af5c:	e9 e8 00 00 00       	jmp    17b049 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x109>
  17af61:	49 89 f1             	mov    %rsi,%r9
  17af64:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
  17af68:	31 c0                	xor    %eax,%eax
  17af6a:	c5 f9 6f 05 ce 9c e8 	vmovdqa -0x176332(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17af71:	ff
  17af72:	c4 e2 79 59 0d 75 83 	vpbroadcastq -0x177c8b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17af79:	e8 ff
  17af7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  17af80:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
  17af84:	4d 89 d3             	mov    %r10,%r11
  17af87:	49 c1 eb 20          	shr    $0x20,%r11
  17af8b:	4d 31 d3             	xor    %r10,%r11
  17af8e:	4d 0f af d8          	imul   %r8,%r11
  17af92:	4d 89 da             	mov    %r11,%r10
  17af95:	49 c1 ea 20          	shr    $0x20,%r10
  17af99:	4d 31 da             	xor    %r11,%r10
  17af9c:	4d 0f af d0          	imul   %r8,%r10
  17afa0:	4d 89 d3             	mov    %r10,%r11
  17afa3:	49 c1 eb 20          	shr    $0x20,%r11
  17afa7:	45 31 da             	xor    %r11d,%r10d
  17afaa:	44 23 5f 18          	and    0x18(%rdi),%r11d
  17afae:	48 8b 1f             	mov    (%rdi),%rbx
  17afb1:	49 c1 e3 04          	shl    $0x4,%r11
  17afb5:	c4 a1 79 6f 14 1b    	vmovdqa (%rbx,%r11,1),%xmm2
  17afbb:	62 d2 7d 08 7c da    	vpbroadcastd %r10d,%xmm3
  17afc1:	c5 e1 e5 d8          	vpmulhw %xmm0,%xmm3,%xmm3
  17afc5:	c4 e2 71 00 db       	vpshufb %xmm3,%xmm1,%xmm3
  17afca:	45 31 d2             	xor    %r10d,%r10d
  17afcd:	c4 e2 79 17 d3       	vptest %xmm3,%xmm2
  17afd2:	41 0f 92 c2          	setb   %r10b
  17afd6:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  17afda:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
  17afdf:	4d 89 d3             	mov    %r10,%r11
  17afe2:	49 c1 eb 20          	shr    $0x20,%r11
  17afe6:	4d 31 d3             	xor    %r10,%r11
  17afe9:	4d 0f af d8          	imul   %r8,%r11
  17afed:	4d 89 da             	mov    %r11,%r10
  17aff0:	49 c1 ea 20          	shr    $0x20,%r10
  17aff4:	4d 31 da             	xor    %r11,%r10
  17aff7:	4d 0f af d0          	imul   %r8,%r10
  17affb:	4d 89 d3             	mov    %r10,%r11
  17affe:	49 c1 eb 20          	shr    $0x20,%r11
  17b002:	45 31 da             	xor    %r11d,%r10d
  17b005:	44 23 5f 18          	and    0x18(%rdi),%r11d
  17b009:	48 8b 1f             	mov    (%rdi),%rbx
  17b00c:	49 c1 e3 04          	shl    $0x4,%r11
  17b010:	c4 a1 79 6f 14 1b    	vmovdqa (%rbx,%r11,1),%xmm2
  17b016:	62 d2 7d 08 7c da    	vpbroadcastd %r10d,%xmm3
  17b01c:	c5 e1 e5 d8          	vpmulhw %xmm0,%xmm3,%xmm3
  17b020:	c4 e2 71 00 db       	vpshufb %xmm3,%xmm1,%xmm3
  17b025:	45 31 d2             	xor    %r10d,%r10d
  17b028:	c4 e2 79 17 d3       	vptest %xmm3,%xmm2
  17b02d:	41 0f 92 c2          	setb   %r10b
  17b031:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
  17b036:	48 83 c0 02          	add    $0x2,%rax
  17b03a:	49 39 c1             	cmp    %rax,%r9
  17b03d:	0f 85 3d ff ff ff    	jne    17af80 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17b043:	40 f6 c6 01          	test   $0x1,%sil
  17b047:	74 61                	je     17b0aa <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16a>
  17b049:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  17b04d:	48 89 d6             	mov    %rdx,%rsi
  17b050:	48 c1 ee 20          	shr    $0x20,%rsi
  17b054:	48 31 d6             	xor    %rdx,%rsi
  17b057:	49 0f af f0          	imul   %r8,%rsi
  17b05b:	48 89 f2             	mov    %rsi,%rdx
  17b05e:	48 c1 ea 20          	shr    $0x20,%rdx
  17b062:	48 31 f2             	xor    %rsi,%rdx
  17b065:	49 0f af d0          	imul   %r8,%rdx
  17b069:	48 89 d6             	mov    %rdx,%rsi
  17b06c:	48 c1 ee 20          	shr    $0x20,%rsi
  17b070:	31 f2                	xor    %esi,%edx
  17b072:	23 77 18             	and    0x18(%rdi),%esi
  17b075:	48 8b 3f             	mov    (%rdi),%rdi
  17b078:	48 c1 e6 04          	shl    $0x4,%rsi
  17b07c:	c5 f9 6f 04 37       	vmovdqa (%rdi,%rsi,1),%xmm0
  17b081:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
  17b087:	c5 f1 e5 0d b1 9b e8 	vpmulhw -0x17644f(%rip),%xmm1,%xmm1        # 4c40 <typeinfo name for main::$_60+0x470>
  17b08e:	ff
  17b08f:	c4 e2 79 59 15 58 82 	vpbroadcastq -0x177da8(%rip),%xmm2        # 32f0 <_IO_stdin_used+0x3c>
  17b096:	e8 ff
  17b098:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
  17b09d:	31 d2                	xor    %edx,%edx
  17b09f:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
  17b0a4:	0f 92 c2             	setb   %dl
  17b0a7:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  17b0aa:	5b                   	pop    %rbx
  17b0ab:	c3                   	ret
  17b0ac:	cc                   	int3
  17b0ad:	cc                   	int3
  17b0ae:	cc                   	int3
  17b0af:	cc                   	int3
