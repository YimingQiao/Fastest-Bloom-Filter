0000000000051810 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   51810:	test   %rsi,%rsi
   51813:	je     519a5 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x195>
   51819:	push   %rbx
   5181a:	movabs $0xd6e8feb86659fd93,%r8
   51824:	cmp    $0x1,%rsi
   51828:	jne    51831 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   5182a:	xor    %eax,%eax
   5182c:	jmp    51933 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x123>
   51831:	mov    %rsi,%r9
   51834:	and    $0xfffffffffffffffe,%r9
   51838:	xor    %eax,%eax
   5183a:	vmovdqa -0x4cf22(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   51842:	vpbroadcastd -0x4e5a3(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   5184b:	nopl   0x0(%rax,%rax,1)
   51850:	mov    (%rdx,%rax,8),%r10
   51854:	mov    %r10,%r11
   51857:	shr    $0x20,%r11
   5185b:	xor    %r10,%r11
   5185e:	imul   %r8,%r11
   51862:	mov    %r11,%r10
   51865:	shr    $0x20,%r10
   51869:	xor    %r11,%r10
   5186c:	imul   %r8,%r10
   51870:	mov    %r10,%r11
   51873:	shr    $0x20,%r11
   51877:	xor    %r11d,%r10d
   5187a:	mov    (%rdi),%ebx
   5187c:	imul   %r11,%rbx
   51880:	vpbroadcastd %r10d,%ymm2
   51886:	vpmulld %ymm0,%ymm2,%ymm2
   5188b:	vpsrld $0x1b,%ymm2,%ymm2
   51890:	vpsllvd %ymm2,%ymm1,%ymm2
   51895:	mov    0x8(%rdi),%r10
   51899:	shr    $0x1b,%rbx
   5189d:	and    $0xffffffffffffffe0,%rbx
   518a1:	vmovdqa (%r10,%rbx,1),%ymm3
   518a7:	xor    %r10d,%r10d
   518aa:	vptest %ymm2,%ymm3
   518af:	setb   %r10b
   518b3:	mov    %r10d,(%rcx,%rax,4)
   518b7:	mov    0x8(%rdx,%rax,8),%r10
   518bc:	mov    %r10,%r11
   518bf:	shr    $0x20,%r11
   518c3:	xor    %r10,%r11
   518c6:	imul   %r8,%r11
   518ca:	mov    %r11,%r10
   518cd:	shr    $0x20,%r10
   518d1:	xor    %r11,%r10
   518d4:	imul   %r8,%r10
   518d8:	mov    %r10,%r11
   518db:	shr    $0x20,%r11
   518df:	xor    %r11d,%r10d
   518e2:	mov    (%rdi),%ebx
   518e4:	imul   %r11,%rbx
   518e8:	vpbroadcastd %r10d,%ymm2
   518ee:	vpmulld %ymm0,%ymm2,%ymm2
   518f3:	vpsrld $0x1b,%ymm2,%ymm2
   518f8:	vpsllvd %ymm2,%ymm1,%ymm2
   518fd:	mov    0x8(%rdi),%r10
   51901:	shr    $0x1b,%rbx
   51905:	and    $0xffffffffffffffe0,%rbx
   51909:	vmovdqa (%r10,%rbx,1),%ymm3
   5190f:	xor    %r10d,%r10d
   51912:	vptest %ymm2,%ymm3
   51917:	setb   %r10b
   5191b:	mov    %r10d,0x4(%rcx,%rax,4)
   51920:	add    $0x2,%rax
   51924:	cmp    %rax,%r9
   51927:	jne    51850 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   5192d:	test   $0x1,%sil
   51931:	je     519a4 <void inline_single_kernel<true, external_bloom::Fixed32<true>, unsigned long>(external_bloom::Fixed32<true> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
   51933:	mov    (%rdx,%rax,8),%rdx
   51937:	mov    %rdx,%rsi
   5193a:	shr    $0x20,%rsi
   5193e:	xor    %rdx,%rsi
   51941:	imul   %r8,%rsi
   51945:	mov    %rsi,%rdx
   51948:	shr    $0x20,%rdx
   5194c:	xor    %rsi,%rdx
   5194f:	imul   %r8,%rdx
   51953:	mov    %rdx,%rsi
   51956:	shr    $0x20,%rsi
   5195a:	xor    %esi,%edx
   5195c:	mov    (%rdi),%r8d
   5195f:	imul   %rsi,%r8
   51963:	vpbroadcastd %edx,%ymm0
   51969:	vpmulld -0x4d052(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   51972:	vpsrld $0x1b,%ymm0,%ymm0
   51977:	vpbroadcastd -0x4e6d8(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   51980:	vpsllvd %ymm0,%ymm1,%ymm0
   51985:	mov    0x8(%rdi),%rdx
   51989:	shr    $0x1b,%r8
   5198d:	and    $0xffffffffffffffe0,%r8
   51991:	vmovdqa (%rdx,%r8,1),%ymm1
   51997:	xor    %edx,%edx
   51999:	vptest %ymm0,%ymm1
   5199e:	setb   %dl
   519a1:	mov    %edx,(%rcx,%rax,4)
   519a4:	pop    %rbx
   519a5:	vzeroupper
   519a8:	ret
   519a9:	int3
   519aa:	int3
   519ab:	int3
   519ac:	int3
   519ad:	int3
   519ae:	int3
   519af:	int3

