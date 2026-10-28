0000000000061fa0 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   61fa0:	test   %rsi,%rsi
   61fa3:	je     620ad <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   61fa9:	cmp    $0x1,%rsi
   61fad:	jne    61fb6 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   61faf:	xor    %eax,%eax
   61fb1:	jmp    62065 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   61fb6:	mov    %rsi,%r8
   61fb9:	and    $0xfffffffffffffffe,%r8
   61fbd:	xor    %eax,%eax
   61fbf:	vmovdqa -0x5d387(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   61fc7:	vpbroadcastq -0x5ece0(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   61fd0:	mov    (%rdx,%rax,8),%r9
   61fd4:	vpbroadcastd %r9d,%xmm2
   61fda:	shr    $0x20,%r9
   61fde:	mov    (%rdi),%r10d
   61fe1:	imul   %r9,%r10
   61fe5:	vpmulhw %xmm0,%xmm2,%xmm2
   61fe9:	vpshufb %xmm2,%xmm1,%xmm2
   61fee:	mov    0x8(%rdi),%r9
   61ff2:	shr    $0x1c,%r10
   61ff6:	and    $0xfffffffffffffff0,%r10
   61ffa:	vmovdqu (%r9,%r10,1),%xmm3
   62000:	xor    %r9d,%r9d
   62003:	vptest %xmm2,%xmm3
   62008:	setb   %r9b
   6200c:	mov    %r9d,(%rcx,%rax,4)
   62010:	mov    0x8(%rdx,%rax,8),%r9
   62015:	vpbroadcastd %r9d,%xmm2
   6201b:	shr    $0x20,%r9
   6201f:	mov    (%rdi),%r10d
   62022:	imul   %r9,%r10
   62026:	vpmulhw %xmm0,%xmm2,%xmm2
   6202a:	vpshufb %xmm2,%xmm1,%xmm2
   6202f:	mov    0x8(%rdi),%r9
   62033:	shr    $0x1c,%r10
   62037:	and    $0xfffffffffffffff0,%r10
   6203b:	vmovdqu (%r9,%r10,1),%xmm3
   62041:	xor    %r9d,%r9d
   62044:	vptest %xmm2,%xmm3
   62049:	setb   %r9b
   6204d:	mov    %r9d,0x4(%rcx,%rax,4)
   62052:	add    $0x2,%rax
   62056:	cmp    %rax,%r8
   62059:	jne    61fd0 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6205f:	test   $0x1,%sil
   62063:	je     620ad <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   62065:	mov    (%rdx,%rax,8),%rdx
   62069:	vpbroadcastd %edx,%xmm0
   6206f:	shr    $0x20,%rdx
   62073:	mov    (%rdi),%esi
   62075:	imul   %rdx,%rsi
   62079:	vpmulhw -0x5d441(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62081:	vpbroadcastq -0x5ed9a(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6208a:	vpshufb %xmm0,%xmm1,%xmm0
   6208f:	mov    0x8(%rdi),%rdx
   62093:	shr    $0x1c,%rsi
   62097:	and    $0xfffffffffffffff0,%rsi
   6209b:	vmovdqu (%rdx,%rsi,1),%xmm1
   620a0:	xor    %edx,%edx
   620a2:	vptest %xmm0,%xmm1
   620a7:	setb   %dl
   620aa:	mov    %edx,(%rcx,%rax,4)
   620ad:	ret
   620ae:	int3
   620af:	int3

