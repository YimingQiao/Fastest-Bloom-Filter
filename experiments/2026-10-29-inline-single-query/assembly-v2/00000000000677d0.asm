00000000000677d0 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   677d0:	test   %rsi,%rsi
   677d3:	je     678f1 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   677d9:	cmp    $0x1,%rsi
   677dd:	jne    677e6 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   677df:	xor    %eax,%eax
   677e1:	jmp    678a3 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   677e6:	mov    %rsi,%r8
   677e9:	and    $0xfffffffffffffffe,%r8
   677ed:	xor    %eax,%eax
   677ef:	vmovdqa -0x62ed7(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   677f7:	vpbroadcastd -0x64558(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67800:	mov    (%rdx,%rax,8),%r9
   67804:	mov    0x4(%rdi),%r10d
   67808:	and    %r9d,%r10d
   6780b:	movzbl (%rdi),%r11d
   6780f:	shrx   %r11,%r9,%r9
   67814:	vpbroadcastd %r9d,%ymm2
   6781a:	vpmulld %ymm0,%ymm2,%ymm2
   6781f:	vpsrld $0x1b,%ymm2,%ymm2
   67824:	vpsllvd %ymm2,%ymm1,%ymm2
   67829:	mov    0x8(%rdi),%r9
   6782d:	shl    $0x5,%r10
   67831:	vmovdqa (%r9,%r10,1),%ymm3
   67837:	xor    %r9d,%r9d
   6783a:	vptest %ymm2,%ymm3
   6783f:	setb   %r9b
   67843:	mov    %r9d,(%rcx,%rax,4)
   67847:	mov    0x8(%rdx,%rax,8),%r9
   6784c:	mov    0x4(%rdi),%r10d
   67850:	and    %r9d,%r10d
   67853:	movzbl (%rdi),%r11d
   67857:	shrx   %r11,%r9,%r9
   6785c:	vpbroadcastd %r9d,%ymm2
   67862:	vpmulld %ymm0,%ymm2,%ymm2
   67867:	vpsrld $0x1b,%ymm2,%ymm2
   6786c:	vpsllvd %ymm2,%ymm1,%ymm2
   67871:	mov    0x8(%rdi),%r9
   67875:	shl    $0x5,%r10
   67879:	vmovdqa (%r9,%r10,1),%ymm3
   6787f:	xor    %r9d,%r9d
   67882:	vptest %ymm2,%ymm3
   67887:	setb   %r9b
   6788b:	mov    %r9d,0x4(%rcx,%rax,4)
   67890:	add    $0x2,%rax
   67894:	cmp    %rax,%r8
   67897:	jne    67800 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6789d:	test   $0x1,%sil
   678a1:	je     678f1 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   678a3:	mov    (%rdx,%rax,8),%rdx
   678a7:	mov    0x4(%rdi),%esi
   678aa:	and    %edx,%esi
   678ac:	movzbl (%rdi),%r8d
   678b0:	shrx   %r8,%rdx,%rdx
   678b5:	vpbroadcastd %edx,%ymm0
   678bb:	vpmulld -0x62fa4(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   678c4:	vpsrld $0x1b,%ymm0,%ymm0
   678c9:	vpbroadcastd -0x6462a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   678d2:	vpsllvd %ymm0,%ymm1,%ymm0
   678d7:	mov    0x8(%rdi),%rdx
   678db:	shl    $0x5,%rsi
   678df:	vmovdqa (%rdx,%rsi,1),%ymm1
   678e4:	xor    %edx,%edx
   678e6:	vptest %ymm0,%ymm1
   678eb:	setb   %dl
   678ee:	mov    %edx,(%rcx,%rax,4)
   678f1:	vzeroupper
   678f4:	ret
   678f5:	int3
   678f6:	int3
   678f7:	int3
   678f8:	int3
   678f9:	int3
   678fa:	int3
   678fb:	int3
   678fc:	int3
   678fd:	int3
   678fe:	int3
   678ff:	int3

