0000000000046870 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   46870:	test   %rsi,%rsi
   46873:	je     46a12 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   46879:	push   %rbx
   4687a:	movabs $0xd6e8feb86659fd93,%r8
   46884:	cmp    $0x1,%rsi
   46888:	jne    46891 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   4688a:	xor    %eax,%eax
   4688c:	jmp    4699d <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   46891:	mov    %rsi,%r9
   46894:	and    $0xfffffffffffffffe,%r9
   46898:	xor    %eax,%eax
   4689a:	vmovdqa -0x41f82(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   468a2:	vpbroadcastd -0x43603(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   468ab:	nopl   0x0(%rax,%rax,1)
   468b0:	mov    (%rdx,%rax,8),%r10
   468b4:	mov    %r10,%r11
   468b7:	shr    $0x20,%r11
   468bb:	xor    %r10,%r11
   468be:	imul   %r8,%r11
   468c2:	mov    %r11,%r10
   468c5:	shr    $0x20,%r10
   468c9:	xor    %r11,%r10
   468cc:	imul   %r8,%r10
   468d0:	mov    %r10,%r11
   468d3:	shr    $0x20,%r11
   468d7:	xor    %r10,%r11
   468da:	mov    0x4(%rdi),%r10d
   468de:	and    %r11d,%r10d
   468e1:	movzbl (%rdi),%ebx
   468e4:	shrx   %rbx,%r11,%r11
   468e9:	vpbroadcastd %r11d,%ymm2
   468ef:	vpmulld %ymm0,%ymm2,%ymm2
   468f4:	vpsrld $0x1b,%ymm2,%ymm2
   468f9:	vpsllvd %ymm2,%ymm1,%ymm2
   468fe:	mov    0x8(%rdi),%r11
   46902:	shl    $0x5,%r10
   46906:	vmovdqa (%r11,%r10,1),%ymm3
   4690c:	xor    %r10d,%r10d
   4690f:	vptest %ymm2,%ymm3
   46914:	setb   %r10b
   46918:	mov    %r10d,(%rcx,%rax,4)
   4691c:	mov    0x8(%rdx,%rax,8),%r10
   46921:	mov    %r10,%r11
   46924:	shr    $0x20,%r11
   46928:	xor    %r10,%r11
   4692b:	imul   %r8,%r11
   4692f:	mov    %r11,%r10
   46932:	shr    $0x20,%r10
   46936:	xor    %r11,%r10
   46939:	imul   %r8,%r10
   4693d:	mov    %r10,%r11
   46940:	shr    $0x20,%r11
   46944:	xor    %r10,%r11
   46947:	mov    0x4(%rdi),%r10d
   4694b:	and    %r11d,%r10d
   4694e:	movzbl (%rdi),%ebx
   46951:	shrx   %rbx,%r11,%r11
   46956:	vpbroadcastd %r11d,%ymm2
   4695c:	vpmulld %ymm0,%ymm2,%ymm2
   46961:	vpsrld $0x1b,%ymm2,%ymm2
   46966:	vpsllvd %ymm2,%ymm1,%ymm2
   4696b:	mov    0x8(%rdi),%r11
   4696f:	shl    $0x5,%r10
   46973:	vmovdqa (%r11,%r10,1),%ymm3
   46979:	xor    %r10d,%r10d
   4697c:	vptest %ymm2,%ymm3
   46981:	setb   %r10b
   46985:	mov    %r10d,0x4(%rcx,%rax,4)
   4698a:	add    $0x2,%rax
   4698e:	cmp    %rax,%r9
   46991:	jne    468b0 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   46997:	test   $0x1,%sil
   4699b:	je     46a11 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   4699d:	mov    (%rdx,%rax,8),%rdx
   469a1:	mov    %rdx,%rsi
   469a4:	shr    $0x20,%rsi
   469a8:	xor    %rdx,%rsi
   469ab:	imul   %r8,%rsi
   469af:	mov    %rsi,%rdx
   469b2:	shr    $0x20,%rdx
   469b6:	xor    %rsi,%rdx
   469b9:	imul   %r8,%rdx
   469bd:	mov    %rdx,%rsi
   469c0:	shr    $0x20,%rsi
   469c4:	xor    %rdx,%rsi
   469c7:	mov    0x4(%rdi),%edx
   469ca:	and    %esi,%edx
   469cc:	movzbl (%rdi),%r8d
   469d0:	shrx   %r8,%rsi,%rsi
   469d5:	vpbroadcastd %esi,%ymm0
   469db:	vpmulld -0x420c4(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   469e4:	vpsrld $0x1b,%ymm0,%ymm0
   469e9:	vpbroadcastd -0x4374a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   469f2:	vpsllvd %ymm0,%ymm1,%ymm0
   469f7:	mov    0x8(%rdi),%rsi
   469fb:	shl    $0x5,%rdx
   469ff:	vmovdqa (%rsi,%rdx,1),%ymm1
   46a04:	xor    %edx,%edx
   46a06:	vptest %ymm0,%ymm1
   46a0b:	setb   %dl
   46a0e:	mov    %edx,(%rcx,%rax,4)
   46a11:	pop    %rbx
   46a12:	vzeroupper
   46a15:	ret
   46a16:	int3
   46a17:	int3
   46a18:	int3
   46a19:	int3
   46a1a:	int3
   46a1b:	int3
   46a1c:	int3
   46a1d:	int3
   46a1e:	int3
   46a1f:	int3

