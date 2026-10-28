0000000000051300 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   51300:	test   %rsi,%rsi
   51303:	je     5141f <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   51309:	cmp    $0x1,%rsi
   5130d:	jne    51316 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   5130f:	xor    %eax,%eax
   51311:	jmp    513d1 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0xd1>
   51316:	mov    %rsi,%r8
   51319:	and    $0xfffffffffffffffe,%r8
   5131d:	xor    %eax,%eax
   5131f:	vmovdqa -0x4ca07(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   51327:	vpbroadcastd -0x4e088(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   51330:	mov    (%rdx,%rax,8),%r9
   51334:	vpbroadcastd %r9d,%ymm2
   5133a:	shr    $0x20,%r9
   5133e:	mov    (%rdi),%r10d
   51341:	vpmulld %ymm0,%ymm2,%ymm2
   51346:	imul   %r9,%r10
   5134a:	vpsrld $0x1b,%ymm2,%ymm2
   5134f:	vpsllvd %ymm2,%ymm1,%ymm2
   51354:	mov    0x8(%rdi),%r9
   51358:	shr    $0x1b,%r10
   5135c:	and    $0xffffffffffffffe0,%r10
   51360:	vmovdqa (%r9,%r10,1),%ymm3
   51366:	xor    %r9d,%r9d
   51369:	vptest %ymm2,%ymm3
   5136e:	setb   %r9b
   51372:	mov    %r9d,(%rcx,%rax,4)
   51376:	mov    0x8(%rdx,%rax,8),%r9
   5137b:	vpbroadcastd %r9d,%ymm2
   51381:	shr    $0x20,%r9
   51385:	mov    (%rdi),%r10d
   51388:	imul   %r9,%r10
   5138c:	vpmulld %ymm0,%ymm2,%ymm2
   51391:	vpsrld $0x1b,%ymm2,%ymm2
   51396:	vpsllvd %ymm2,%ymm1,%ymm2
   5139b:	mov    0x8(%rdi),%r9
   5139f:	shr    $0x1b,%r10
   513a3:	and    $0xffffffffffffffe0,%r10
   513a7:	vmovdqa (%r9,%r10,1),%ymm3
   513ad:	xor    %r9d,%r9d
   513b0:	vptest %ymm2,%ymm3
   513b5:	setb   %r9b
   513b9:	mov    %r9d,0x4(%rcx,%rax,4)
   513be:	add    $0x2,%rax
   513c2:	cmp    %rax,%r8
   513c5:	jne    51330 <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   513cb:	test   $0x1,%sil
   513cf:	je     5141f <void inline_single_kernel<false, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   513d1:	mov    (%rdx,%rax,8),%rdx
   513d5:	vpbroadcastd %edx,%ymm0
   513db:	shr    $0x20,%rdx
   513df:	mov    (%rdi),%esi
   513e1:	imul   %rdx,%rsi
   513e5:	vpmulld -0x4cace(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   513ee:	vpsrld $0x1b,%ymm0,%ymm0
   513f3:	vpbroadcastd -0x4e154(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   513fc:	vpsllvd %ymm0,%ymm1,%ymm0
   51401:	mov    0x8(%rdi),%rdx
   51405:	shr    $0x1b,%rsi
   51409:	and    $0xffffffffffffffe0,%rsi
   5140d:	vmovdqa (%rdx,%rsi,1),%ymm1
   51412:	xor    %edx,%edx
   51414:	vptest %ymm0,%ymm1
   51419:	setb   %dl
   5141c:	mov    %edx,(%rcx,%rax,4)
   5141f:	vzeroupper
   51422:	ret
   51423:	int3
   51424:	int3
   51425:	int3
   51426:	int3
   51427:	int3
   51428:	int3
   51429:	int3
   5142a:	int3
   5142b:	int3
   5142c:	int3
   5142d:	int3
   5142e:	int3
   5142f:	int3

