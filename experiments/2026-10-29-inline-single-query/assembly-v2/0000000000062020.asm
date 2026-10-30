0000000000062020 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   62020:	test   %rsi,%rsi
   62023:	je     6212d <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   62029:	cmp    $0x1,%rsi
   6202d:	jne    62036 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   6202f:	xor    %eax,%eax
   62031:	jmp    620e5 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   62036:	mov    %rsi,%r8
   62039:	and    $0xfffffffffffffffe,%r8
   6203d:	xor    %eax,%eax
   6203f:	vmovdqa -0x5d407(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62047:	vpbroadcastq -0x5ed60(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   62050:	mov    (%rdx,%rax,8),%r9
   62054:	vpbroadcastd %r9d,%xmm2
   6205a:	shr    $0x20,%r9
   6205e:	mov    (%rdi),%r10d
   62061:	imul   %r9,%r10
   62065:	vpmulhw %xmm0,%xmm2,%xmm2
   62069:	vpshufb %xmm2,%xmm1,%xmm2
   6206e:	mov    0x8(%rdi),%r9
   62072:	shr    $0x1c,%r10
   62076:	and    $0xfffffffffffffff0,%r10
   6207a:	vmovdqu (%r9,%r10,1),%xmm3
   62080:	xor    %r9d,%r9d
   62083:	vptest %xmm2,%xmm3
   62088:	setb   %r9b
   6208c:	mov    %r9d,(%rcx,%rax,4)
   62090:	mov    0x8(%rdx,%rax,8),%r9
   62095:	vpbroadcastd %r9d,%xmm2
   6209b:	shr    $0x20,%r9
   6209f:	mov    (%rdi),%r10d
   620a2:	imul   %r9,%r10
   620a6:	vpmulhw %xmm0,%xmm2,%xmm2
   620aa:	vpshufb %xmm2,%xmm1,%xmm2
   620af:	mov    0x8(%rdi),%r9
   620b3:	shr    $0x1c,%r10
   620b7:	and    $0xfffffffffffffff0,%r10
   620bb:	vmovdqu (%r9,%r10,1),%xmm3
   620c1:	xor    %r9d,%r9d
   620c4:	vptest %xmm2,%xmm3
   620c9:	setb   %r9b
   620cd:	mov    %r9d,0x4(%rcx,%rax,4)
   620d2:	add    $0x2,%rax
   620d6:	cmp    %rax,%r8
   620d9:	jne    62050 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   620df:	test   $0x1,%sil
   620e3:	je     6212d <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   620e5:	mov    (%rdx,%rax,8),%rdx
   620e9:	vpbroadcastd %edx,%xmm0
   620ef:	shr    $0x20,%rdx
   620f3:	mov    (%rdi),%esi
   620f5:	imul   %rdx,%rsi
   620f9:	vpmulhw -0x5d4c1(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62101:	vpbroadcastq -0x5ee1a(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6210a:	vpshufb %xmm0,%xmm1,%xmm0
   6210f:	mov    0x8(%rdi),%rdx
   62113:	shr    $0x1c,%rsi
   62117:	and    $0xfffffffffffffff0,%rsi
   6211b:	vmovdqu (%rdx,%rsi,1),%xmm1
   62120:	xor    %edx,%edx
   62122:	vptest %xmm0,%xmm1
   62127:	setb   %dl
   6212a:	mov    %edx,(%rcx,%rax,4)
   6212d:	ret
   6212e:	int3
   6212f:	int3

