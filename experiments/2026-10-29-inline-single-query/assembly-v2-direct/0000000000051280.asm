0000000000051280 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   51280:	test   %rsi,%rsi
   51283:	je     5139f <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   51289:	cmp    $0x1,%rsi
   5128d:	jne    51296 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   5128f:	xor    %eax,%eax
   51291:	jmp    51351 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0xd1>
   51296:	mov    %rsi,%r8
   51299:	and    $0xfffffffffffffffe,%r8
   5129d:	xor    %eax,%eax
   5129f:	vmovdqa -0x4c987(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   512a7:	vpbroadcastd -0x4e008(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   512b0:	mov    (%rdx,%rax,8),%r9
   512b4:	vpbroadcastd %r9d,%ymm2
   512ba:	shr    $0x20,%r9
   512be:	mov    (%rdi),%r10d
   512c1:	vpmulld %ymm0,%ymm2,%ymm2
   512c6:	imul   %r9,%r10
   512ca:	vpsrld $0x1b,%ymm2,%ymm2
   512cf:	vpsllvd %ymm2,%ymm1,%ymm2
   512d4:	mov    0x8(%rdi),%r9
   512d8:	shr    $0x1b,%r10
   512dc:	and    $0xffffffffffffffe0,%r10
   512e0:	vmovdqa (%r9,%r10,1),%ymm3
   512e6:	xor    %r9d,%r9d
   512e9:	vptest %ymm2,%ymm3
   512ee:	setb   %r9b
   512f2:	mov    %r9d,(%rcx,%rax,4)
   512f6:	mov    0x8(%rdx,%rax,8),%r9
   512fb:	vpbroadcastd %r9d,%ymm2
   51301:	shr    $0x20,%r9
   51305:	mov    (%rdi),%r10d
   51308:	imul   %r9,%r10
   5130c:	vpmulld %ymm0,%ymm2,%ymm2
   51311:	vpsrld $0x1b,%ymm2,%ymm2
   51316:	vpsllvd %ymm2,%ymm1,%ymm2
   5131b:	mov    0x8(%rdi),%r9
   5131f:	shr    $0x1b,%r10
   51323:	and    $0xffffffffffffffe0,%r10
   51327:	vmovdqa (%r9,%r10,1),%ymm3
   5132d:	xor    %r9d,%r9d
   51330:	vptest %ymm2,%ymm3
   51335:	setb   %r9b
   51339:	mov    %r9d,0x4(%rcx,%rax,4)
   5133e:	add    $0x2,%rax
   51342:	cmp    %rax,%r8
   51345:	jne    512b0 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   5134b:	test   $0x1,%sil
   5134f:	je     5139f <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   51351:	mov    (%rdx,%rax,8),%rdx
   51355:	vpbroadcastd %edx,%ymm0
   5135b:	shr    $0x20,%rdx
   5135f:	mov    (%rdi),%esi
   51361:	imul   %rdx,%rsi
   51365:	vpmulld -0x4ca4e(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   5136e:	vpsrld $0x1b,%ymm0,%ymm0
   51373:	vpbroadcastd -0x4e0d4(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   5137c:	vpsllvd %ymm0,%ymm1,%ymm0
   51381:	mov    0x8(%rdi),%rdx
   51385:	shr    $0x1b,%rsi
   51389:	and    $0xffffffffffffffe0,%rsi
   5138d:	vmovdqa (%rdx,%rsi,1),%ymm1
   51392:	xor    %edx,%edx
   51394:	vptest %ymm0,%ymm1
   51399:	setb   %dl
   5139c:	mov    %edx,(%rcx,%rax,4)
   5139f:	vzeroupper
   513a2:	ret
   513a3:	int3
   513a4:	int3
   513a5:	int3
   513a6:	int3
   513a7:	int3
   513a8:	int3
   513a9:	int3
   513aa:	int3
   513ab:	int3
   513ac:	int3
   513ad:	int3
   513ae:	int3
   513af:	int3

