0000000000051790 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   51790:	test   %rsi,%rsi
   51793:	je     51925 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x195>
   51799:	push   %rbx
   5179a:	movabs $0xd6e8feb86659fd93,%r8
   517a4:	cmp    $0x1,%rsi
   517a8:	jne    517b1 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   517aa:	xor    %eax,%eax
   517ac:	jmp    518b3 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x123>
   517b1:	mov    %rsi,%r9
   517b4:	and    $0xfffffffffffffffe,%r9
   517b8:	xor    %eax,%eax
   517ba:	vmovdqa -0x4cea2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   517c2:	vpbroadcastd -0x4e523(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   517cb:	nopl   0x0(%rax,%rax,1)
   517d0:	mov    (%rdx,%rax,8),%r10
   517d4:	mov    %r10,%r11
   517d7:	shr    $0x20,%r11
   517db:	xor    %r10,%r11
   517de:	imul   %r8,%r11
   517e2:	mov    %r11,%r10
   517e5:	shr    $0x20,%r10
   517e9:	xor    %r11,%r10
   517ec:	imul   %r8,%r10
   517f0:	mov    %r10,%r11
   517f3:	shr    $0x20,%r11
   517f7:	xor    %r11d,%r10d
   517fa:	mov    (%rdi),%ebx
   517fc:	imul   %r11,%rbx
   51800:	vpbroadcastd %r10d,%ymm2
   51806:	vpmulld %ymm0,%ymm2,%ymm2
   5180b:	vpsrld $0x1b,%ymm2,%ymm2
   51810:	vpsllvd %ymm2,%ymm1,%ymm2
   51815:	mov    0x8(%rdi),%r10
   51819:	shr    $0x1b,%rbx
   5181d:	and    $0xffffffffffffffe0,%rbx
   51821:	vmovdqa (%r10,%rbx,1),%ymm3
   51827:	xor    %r10d,%r10d
   5182a:	vptest %ymm2,%ymm3
   5182f:	setb   %r10b
   51833:	mov    %r10d,(%rcx,%rax,4)
   51837:	mov    0x8(%rdx,%rax,8),%r10
   5183c:	mov    %r10,%r11
   5183f:	shr    $0x20,%r11
   51843:	xor    %r10,%r11
   51846:	imul   %r8,%r11
   5184a:	mov    %r11,%r10
   5184d:	shr    $0x20,%r10
   51851:	xor    %r11,%r10
   51854:	imul   %r8,%r10
   51858:	mov    %r10,%r11
   5185b:	shr    $0x20,%r11
   5185f:	xor    %r11d,%r10d
   51862:	mov    (%rdi),%ebx
   51864:	imul   %r11,%rbx
   51868:	vpbroadcastd %r10d,%ymm2
   5186e:	vpmulld %ymm0,%ymm2,%ymm2
   51873:	vpsrld $0x1b,%ymm2,%ymm2
   51878:	vpsllvd %ymm2,%ymm1,%ymm2
   5187d:	mov    0x8(%rdi),%r10
   51881:	shr    $0x1b,%rbx
   51885:	and    $0xffffffffffffffe0,%rbx
   51889:	vmovdqa (%r10,%rbx,1),%ymm3
   5188f:	xor    %r10d,%r10d
   51892:	vptest %ymm2,%ymm3
   51897:	setb   %r10b
   5189b:	mov    %r10d,0x4(%rcx,%rax,4)
   518a0:	add    $0x2,%rax
   518a4:	cmp    %rax,%r9
   518a7:	jne    517d0 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   518ad:	test   $0x1,%sil
   518b1:	je     51924 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
   518b3:	mov    (%rdx,%rax,8),%rdx
   518b7:	mov    %rdx,%rsi
   518ba:	shr    $0x20,%rsi
   518be:	xor    %rdx,%rsi
   518c1:	imul   %r8,%rsi
   518c5:	mov    %rsi,%rdx
   518c8:	shr    $0x20,%rdx
   518cc:	xor    %rsi,%rdx
   518cf:	imul   %r8,%rdx
   518d3:	mov    %rdx,%rsi
   518d6:	shr    $0x20,%rsi
   518da:	xor    %esi,%edx
   518dc:	mov    (%rdi),%r8d
   518df:	imul   %rsi,%r8
   518e3:	vpbroadcastd %edx,%ymm0
   518e9:	vpmulld -0x4cfd2(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   518f2:	vpsrld $0x1b,%ymm0,%ymm0
   518f7:	vpbroadcastd -0x4e658(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   51900:	vpsllvd %ymm0,%ymm1,%ymm0
   51905:	mov    0x8(%rdi),%rdx
   51909:	shr    $0x1b,%r8
   5190d:	and    $0xffffffffffffffe0,%r8
   51911:	vmovdqa (%rdx,%r8,1),%ymm1
   51917:	xor    %edx,%edx
   51919:	vptest %ymm0,%ymm1
   5191e:	setb   %dl
   51921:	mov    %edx,(%rcx,%rax,4)
   51924:	pop    %rbx
   51925:	vzeroupper
   51928:	ret
   51929:	int3
   5192a:	int3
   5192b:	int3
   5192c:	int3
   5192d:	int3
   5192e:	int3
   5192f:	int3

