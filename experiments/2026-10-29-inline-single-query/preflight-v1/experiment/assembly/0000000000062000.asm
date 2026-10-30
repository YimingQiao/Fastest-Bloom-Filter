0000000000062000 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   62000:	48 85 f6             	test   %rsi,%rsi
   62003:	0f 84 04 01 00 00    	je     6210d <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   62009:	48 83 fe 01          	cmp    $0x1,%rsi
   6200d:	75 07                	jne    62016 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   6200f:	31 c0                	xor    %eax,%eax
   62011:	e9 af 00 00 00       	jmp    620c5 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   62016:	49 89 f0             	mov    %rsi,%r8
   62019:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
   6201d:	31 c0                	xor    %eax,%eax
   6201f:	c5 f9 6f 05 19 2c fa 	vmovdqa -0x5d3e7(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62026:	ff
   62027:	c4 e2 79 59 0d c0 12 	vpbroadcastq -0x5ed40(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6202e:	fa ff
   62030:	4c 8b 0c c2          	mov    (%rdx,%rax,8),%r9
   62034:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
   6203a:	49 c1 e9 20          	shr    $0x20,%r9
   6203e:	44 8b 17             	mov    (%rdi),%r10d
   62041:	4d 0f af d1          	imul   %r9,%r10
   62045:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   62049:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   6204e:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   62052:	49 c1 ea 1c          	shr    $0x1c,%r10
   62056:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
   6205a:	c4 81 7a 6f 1c 11    	vmovdqu (%r9,%r10,1),%xmm3
   62060:	45 31 c9             	xor    %r9d,%r9d
   62063:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   62068:	41 0f 92 c1          	setb   %r9b
   6206c:	44 89 0c 81          	mov    %r9d,(%rcx,%rax,4)
   62070:	4c 8b 4c c2 08       	mov    0x8(%rdx,%rax,8),%r9
   62075:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
   6207b:	49 c1 e9 20          	shr    $0x20,%r9
   6207f:	44 8b 17             	mov    (%rdi),%r10d
   62082:	4d 0f af d1          	imul   %r9,%r10
   62086:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   6208a:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   6208f:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   62093:	49 c1 ea 1c          	shr    $0x1c,%r10
   62097:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
   6209b:	c4 81 7a 6f 1c 11    	vmovdqu (%r9,%r10,1),%xmm3
   620a1:	45 31 c9             	xor    %r9d,%r9d
   620a4:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   620a9:	41 0f 92 c1          	setb   %r9b
   620ad:	44 89 4c 81 04       	mov    %r9d,0x4(%rcx,%rax,4)
   620b2:	48 83 c0 02          	add    $0x2,%rax
   620b6:	49 39 c0             	cmp    %rax,%r8
   620b9:	0f 85 71 ff ff ff    	jne    62030 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   620bf:	40 f6 c6 01          	test   $0x1,%sil
   620c3:	74 48                	je     6210d <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   620c5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   620c9:	62 f2 7d 08 7c c2    	vpbroadcastd %edx,%xmm0
   620cf:	48 c1 ea 20          	shr    $0x20,%rdx
   620d3:	8b 37                	mov    (%rdi),%esi
   620d5:	48 0f af f2          	imul   %rdx,%rsi
   620d9:	c5 f9 e5 05 5f 2b fa 	vpmulhw -0x5d4a1(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   620e0:	ff
   620e1:	c4 e2 79 59 0d 06 12 	vpbroadcastq -0x5edfa(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   620e8:	fa ff
   620ea:	c4 e2 71 00 c0       	vpshufb %xmm0,%xmm1,%xmm0
   620ef:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   620f3:	48 c1 ee 1c          	shr    $0x1c,%rsi
   620f7:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
   620fb:	c5 fa 6f 0c 32       	vmovdqu (%rdx,%rsi,1),%xmm1
   62100:	31 d2                	xor    %edx,%edx
   62102:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   62107:	0f 92 c2             	setb   %dl
   6210a:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   6210d:	c3                   	ret
   6210e:	cc                   	int3
   6210f:	cc                   	int3
