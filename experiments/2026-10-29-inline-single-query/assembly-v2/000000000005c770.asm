000000000005c770 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5c770:	test   %rsi,%rsi
   5c773:	je     5c87d <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c779:	cmp    $0x1,%rsi
   5c77d:	jne    5c786 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   5c77f:	xor    %eax,%eax
   5c781:	jmp    5c835 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   5c786:	mov    %rsi,%r8
   5c789:	and    $0xfffffffffffffffe,%r8
   5c78d:	xor    %eax,%eax
   5c78f:	vmovdqa -0x57b57(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c797:	vpbroadcastq -0x594b0(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c7a0:	mov    (%rdx,%rax,8),%r9
   5c7a4:	vpbroadcastd %r9d,%xmm2
   5c7aa:	shr    $0x20,%r9
   5c7ae:	mov    (%rdi),%r10d
   5c7b1:	imul   %r9,%r10
   5c7b5:	vpmulhw %xmm0,%xmm2,%xmm2
   5c7b9:	vpshufb %xmm2,%xmm1,%xmm2
   5c7be:	mov    0x8(%rdi),%r9
   5c7c2:	shr    $0x1c,%r10
   5c7c6:	and    $0xfffffffffffffff0,%r10
   5c7ca:	vmovdqu (%r9,%r10,1),%xmm3
   5c7d0:	xor    %r9d,%r9d
   5c7d3:	vptest %xmm2,%xmm3
   5c7d8:	setb   %r9b
   5c7dc:	mov    %r9d,(%rcx,%rax,4)
   5c7e0:	mov    0x8(%rdx,%rax,8),%r9
   5c7e5:	vpbroadcastd %r9d,%xmm2
   5c7eb:	shr    $0x20,%r9
   5c7ef:	mov    (%rdi),%r10d
   5c7f2:	imul   %r9,%r10
   5c7f6:	vpmulhw %xmm0,%xmm2,%xmm2
   5c7fa:	vpshufb %xmm2,%xmm1,%xmm2
   5c7ff:	mov    0x8(%rdi),%r9
   5c803:	shr    $0x1c,%r10
   5c807:	and    $0xfffffffffffffff0,%r10
   5c80b:	vmovdqu (%r9,%r10,1),%xmm3
   5c811:	xor    %r9d,%r9d
   5c814:	vptest %xmm2,%xmm3
   5c819:	setb   %r9b
   5c81d:	mov    %r9d,0x4(%rcx,%rax,4)
   5c822:	add    $0x2,%rax
   5c826:	cmp    %rax,%r8
   5c829:	jne    5c7a0 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   5c82f:	test   $0x1,%sil
   5c833:	je     5c87d <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c835:	mov    (%rdx,%rax,8),%rdx
   5c839:	vpbroadcastd %edx,%xmm0
   5c83f:	shr    $0x20,%rdx
   5c843:	mov    (%rdi),%esi
   5c845:	imul   %rdx,%rsi
   5c849:	vpmulhw -0x57c11(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c851:	vpbroadcastq -0x5956a(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c85a:	vpshufb %xmm0,%xmm1,%xmm0
   5c85f:	mov    0x8(%rdi),%rdx
   5c863:	shr    $0x1c,%rsi
   5c867:	and    $0xfffffffffffffff0,%rsi
   5c86b:	vmovdqu (%rdx,%rsi,1),%xmm1
   5c870:	xor    %edx,%edx
   5c872:	vptest %xmm0,%xmm1
   5c877:	setb   %dl
   5c87a:	mov    %edx,(%rcx,%rax,4)
   5c87d:	ret
   5c87e:	int3
   5c87f:	int3

