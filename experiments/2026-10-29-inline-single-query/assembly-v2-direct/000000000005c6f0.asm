000000000005c6f0 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5c6f0:	test   %rsi,%rsi
   5c6f3:	je     5c7fd <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c6f9:	cmp    $0x1,%rsi
   5c6fd:	jne    5c706 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   5c6ff:	xor    %eax,%eax
   5c701:	jmp    5c7b5 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   5c706:	mov    %rsi,%r8
   5c709:	and    $0xfffffffffffffffe,%r8
   5c70d:	xor    %eax,%eax
   5c70f:	vmovdqa -0x57ad7(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c717:	vpbroadcastq -0x59430(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c720:	mov    (%rdx,%rax,8),%r9
   5c724:	vpbroadcastd %r9d,%xmm2
   5c72a:	shr    $0x20,%r9
   5c72e:	mov    (%rdi),%r10d
   5c731:	imul   %r9,%r10
   5c735:	vpmulhw %xmm0,%xmm2,%xmm2
   5c739:	vpshufb %xmm2,%xmm1,%xmm2
   5c73e:	mov    0x8(%rdi),%r9
   5c742:	shr    $0x1c,%r10
   5c746:	and    $0xfffffffffffffff0,%r10
   5c74a:	vmovdqu (%r9,%r10,1),%xmm3
   5c750:	xor    %r9d,%r9d
   5c753:	vptest %xmm2,%xmm3
   5c758:	setb   %r9b
   5c75c:	mov    %r9d,(%rcx,%rax,4)
   5c760:	mov    0x8(%rdx,%rax,8),%r9
   5c765:	vpbroadcastd %r9d,%xmm2
   5c76b:	shr    $0x20,%r9
   5c76f:	mov    (%rdi),%r10d
   5c772:	imul   %r9,%r10
   5c776:	vpmulhw %xmm0,%xmm2,%xmm2
   5c77a:	vpshufb %xmm2,%xmm1,%xmm2
   5c77f:	mov    0x8(%rdi),%r9
   5c783:	shr    $0x1c,%r10
   5c787:	and    $0xfffffffffffffff0,%r10
   5c78b:	vmovdqu (%r9,%r10,1),%xmm3
   5c791:	xor    %r9d,%r9d
   5c794:	vptest %xmm2,%xmm3
   5c799:	setb   %r9b
   5c79d:	mov    %r9d,0x4(%rcx,%rax,4)
   5c7a2:	add    $0x2,%rax
   5c7a6:	cmp    %rax,%r8
   5c7a9:	jne    5c720 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   5c7af:	test   $0x1,%sil
   5c7b3:	je     5c7fd <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c7b5:	mov    (%rdx,%rax,8),%rdx
   5c7b9:	vpbroadcastd %edx,%xmm0
   5c7bf:	shr    $0x20,%rdx
   5c7c3:	mov    (%rdi),%esi
   5c7c5:	imul   %rdx,%rsi
   5c7c9:	vpmulhw -0x57b91(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c7d1:	vpbroadcastq -0x594ea(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c7da:	vpshufb %xmm0,%xmm1,%xmm0
   5c7df:	mov    0x8(%rdi),%rdx
   5c7e3:	shr    $0x1c,%rsi
   5c7e7:	and    $0xfffffffffffffff0,%rsi
   5c7eb:	vmovdqu (%rdx,%rsi,1),%xmm1
   5c7f0:	xor    %edx,%edx
   5c7f2:	vptest %xmm0,%xmm1
   5c7f7:	setb   %dl
   5c7fa:	mov    %edx,(%rcx,%rax,4)
   5c7fd:	ret
   5c7fe:	int3
   5c7ff:	int3

