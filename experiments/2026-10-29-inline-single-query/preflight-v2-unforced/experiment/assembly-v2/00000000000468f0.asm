00000000000468f0 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   468f0:	test   %rsi,%rsi
   468f3:	je     46a92 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   468f9:	push   %rbx
   468fa:	movabs $0xd6e8feb86659fd93,%r8
   46904:	cmp    $0x1,%rsi
   46908:	jne    46911 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   4690a:	xor    %eax,%eax
   4690c:	jmp    46a1d <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   46911:	mov    %rsi,%r9
   46914:	and    $0xfffffffffffffffe,%r9
   46918:	xor    %eax,%eax
   4691a:	vmovdqa -0x42002(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46922:	vpbroadcastd -0x43683(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4692b:	nopl   0x0(%rax,%rax,1)
   46930:	mov    (%rdx,%rax,8),%r10
   46934:	mov    %r10,%r11
   46937:	shr    $0x20,%r11
   4693b:	xor    %r10,%r11
   4693e:	imul   %r8,%r11
   46942:	mov    %r11,%r10
   46945:	shr    $0x20,%r10
   46949:	xor    %r11,%r10
   4694c:	imul   %r8,%r10
   46950:	mov    %r10,%r11
   46953:	shr    $0x20,%r11
   46957:	xor    %r10,%r11
   4695a:	mov    0x4(%rdi),%r10d
   4695e:	and    %r11d,%r10d
   46961:	movzbl (%rdi),%ebx
   46964:	shrx   %rbx,%r11,%r11
   46969:	vpbroadcastd %r11d,%ymm2
   4696f:	vpmulld %ymm0,%ymm2,%ymm2
   46974:	vpsrld $0x1b,%ymm2,%ymm2
   46979:	vpsllvd %ymm2,%ymm1,%ymm2
   4697e:	mov    0x8(%rdi),%r11
   46982:	shl    $0x5,%r10
   46986:	vmovdqa (%r11,%r10,1),%ymm3
   4698c:	xor    %r10d,%r10d
   4698f:	vptest %ymm2,%ymm3
   46994:	setb   %r10b
   46998:	mov    %r10d,(%rcx,%rax,4)
   4699c:	mov    0x8(%rdx,%rax,8),%r10
   469a1:	mov    %r10,%r11
   469a4:	shr    $0x20,%r11
   469a8:	xor    %r10,%r11
   469ab:	imul   %r8,%r11
   469af:	mov    %r11,%r10
   469b2:	shr    $0x20,%r10
   469b6:	xor    %r11,%r10
   469b9:	imul   %r8,%r10
   469bd:	mov    %r10,%r11
   469c0:	shr    $0x20,%r11
   469c4:	xor    %r10,%r11
   469c7:	mov    0x4(%rdi),%r10d
   469cb:	and    %r11d,%r10d
   469ce:	movzbl (%rdi),%ebx
   469d1:	shrx   %rbx,%r11,%r11
   469d6:	vpbroadcastd %r11d,%ymm2
   469dc:	vpmulld %ymm0,%ymm2,%ymm2
   469e1:	vpsrld $0x1b,%ymm2,%ymm2
   469e6:	vpsllvd %ymm2,%ymm1,%ymm2
   469eb:	mov    0x8(%rdi),%r11
   469ef:	shl    $0x5,%r10
   469f3:	vmovdqa (%r11,%r10,1),%ymm3
   469f9:	xor    %r10d,%r10d
   469fc:	vptest %ymm2,%ymm3
   46a01:	setb   %r10b
   46a05:	mov    %r10d,0x4(%rcx,%rax,4)
   46a0a:	add    $0x2,%rax
   46a0e:	cmp    %rax,%r9
   46a11:	jne    46930 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   46a17:	test   $0x1,%sil
   46a1b:	je     46a91 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   46a1d:	mov    (%rdx,%rax,8),%rdx
   46a21:	mov    %rdx,%rsi
   46a24:	shr    $0x20,%rsi
   46a28:	xor    %rdx,%rsi
   46a2b:	imul   %r8,%rsi
   46a2f:	mov    %rsi,%rdx
   46a32:	shr    $0x20,%rdx
   46a36:	xor    %rsi,%rdx
   46a39:	imul   %r8,%rdx
   46a3d:	mov    %rdx,%rsi
   46a40:	shr    $0x20,%rsi
   46a44:	xor    %rdx,%rsi
   46a47:	mov    0x4(%rdi),%edx
   46a4a:	and    %esi,%edx
   46a4c:	movzbl (%rdi),%r8d
   46a50:	shrx   %r8,%rsi,%rsi
   46a55:	vpbroadcastd %esi,%ymm0
   46a5b:	vpmulld -0x42144(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46a64:	vpsrld $0x1b,%ymm0,%ymm0
   46a69:	vpbroadcastd -0x437ca(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46a72:	vpsllvd %ymm0,%ymm1,%ymm0
   46a77:	mov    0x8(%rdi),%rsi
   46a7b:	shl    $0x5,%rdx
   46a7f:	vmovdqa (%rsi,%rdx,1),%ymm1
   46a84:	xor    %edx,%edx
   46a86:	vptest %ymm0,%ymm1
   46a8b:	setb   %dl
   46a8e:	mov    %edx,(%rcx,%rax,4)
   46a91:	pop    %rbx
   46a92:	vzeroupper
   46a95:	ret
   46a96:	int3
   46a97:	int3
   46a98:	int3
   46a99:	int3
   46a9a:	int3
   46a9b:	int3
   46a9c:	int3
   46a9d:	int3
   46a9e:	int3
   46a9f:	int3

