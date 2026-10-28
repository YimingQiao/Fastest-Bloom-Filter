0000000000180c50 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  180c50:	test   %rsi,%rsi
  180c53:	je     180de4 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  180c59:	push   %rbx
  180c5a:	movabs $0xd6e8feb86659fd93,%r8
  180c64:	cmp    $0x1,%rsi
  180c68:	jne    180c71 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  180c6a:	xor    %eax,%eax
  180c6c:	jmp    180d71 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  180c71:	mov    %rsi,%r9
  180c74:	and    $0xfffffffffffffffe,%r9
  180c78:	xor    %eax,%eax
  180c7a:	vpbroadcastq -0x17d98b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  180c83:	vpbroadcastd -0x17d9e4(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  180c8c:	nopl   0x0(%rax)
  180c90:	mov    (%rdx,%rax,8),%r10
  180c94:	mov    %r10,%r11
  180c97:	shr    $0x20,%r11
  180c9b:	xor    %r10,%r11
  180c9e:	imul   %r8,%r11
  180ca2:	mov    %r11,%r10
  180ca5:	shr    $0x20,%r10
  180ca9:	xor    %r11,%r10
  180cac:	imul   %r8,%r10
  180cb0:	mov    %r10,%r11
  180cb3:	shr    $0x20,%r11
  180cb7:	xor    %r10,%r11
  180cba:	shr    $0x29,%r10
  180cbe:	and    0x18(%rdi),%r10d
  180cc2:	mov    (%rdi),%rbx
  180cc5:	shl    $0x5,%r10d
  180cc9:	vmovdqa (%rbx,%r10,1),%ymm2
  180ccf:	vpbroadcastq %r11,%xmm3
  180cd5:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  180cdb:	vpmovzxbd %xmm3,%ymm3
  180ce0:	vprolvd %ymm3,%ymm1,%ymm3
  180ce6:	xor    %r10d,%r10d
  180ce9:	vptest %ymm3,%ymm2
  180cee:	setb   %r10b
  180cf2:	mov    %r10d,(%rcx,%rax,4)
  180cf6:	mov    0x8(%rdx,%rax,8),%r10
  180cfb:	mov    %r10,%r11
  180cfe:	shr    $0x20,%r11
  180d02:	xor    %r10,%r11
  180d05:	imul   %r8,%r11
  180d09:	mov    %r11,%r10
  180d0c:	shr    $0x20,%r10
  180d10:	xor    %r11,%r10
  180d13:	imul   %r8,%r10
  180d17:	mov    %r10,%r11
  180d1a:	shr    $0x20,%r11
  180d1e:	xor    %r10,%r11
  180d21:	shr    $0x29,%r10
  180d25:	and    0x18(%rdi),%r10d
  180d29:	mov    (%rdi),%rbx
  180d2c:	shl    $0x5,%r10d
  180d30:	vmovdqa (%rbx,%r10,1),%ymm2
  180d36:	vpbroadcastq %r11,%xmm3
  180d3c:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  180d42:	vpmovzxbd %xmm3,%ymm3
  180d47:	vprolvd %ymm3,%ymm1,%ymm3
  180d4d:	xor    %r10d,%r10d
  180d50:	vptest %ymm3,%ymm2
  180d55:	setb   %r10b
  180d59:	mov    %r10d,0x4(%rcx,%rax,4)
  180d5e:	add    $0x2,%rax
  180d62:	cmp    %rax,%r9
  180d65:	jne    180c90 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  180d6b:	test   $0x1,%sil
  180d6f:	je     180de3 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  180d71:	mov    (%rdx,%rax,8),%rdx
  180d75:	mov    %rdx,%rsi
  180d78:	shr    $0x20,%rsi
  180d7c:	xor    %rdx,%rsi
  180d7f:	imul   %r8,%rsi
  180d83:	mov    %rsi,%rdx
  180d86:	shr    $0x20,%rdx
  180d8a:	xor    %rsi,%rdx
  180d8d:	imul   %r8,%rdx
  180d91:	mov    %rdx,%rsi
  180d94:	shr    $0x20,%rsi
  180d98:	xor    %rdx,%rsi
  180d9b:	shr    $0x29,%rdx
  180d9f:	and    0x18(%rdi),%edx
  180da2:	mov    (%rdi),%rdi
  180da5:	shl    $0x5,%edx
  180da8:	vmovdqa (%rdi,%rdx,1),%ymm0
  180dad:	vpbroadcastq %rsi,%xmm1
  180db3:	vpbroadcastq -0x17dac4(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  180dbc:	vpmultishiftqb %xmm1,%xmm2,%xmm1
  180dc2:	vpmovzxbd %xmm1,%ymm1
  180dc7:	vpbroadcastd -0x17db28(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  180dd0:	vprolvd %ymm1,%ymm2,%ymm1
  180dd6:	xor    %edx,%edx
  180dd8:	vptest %ymm1,%ymm0
  180ddd:	setb   %dl
  180de0:	mov    %edx,(%rcx,%rax,4)
  180de3:	pop    %rbx
  180de4:	vzeroupper
  180de7:	ret
  180de8:	int3
  180de9:	int3
  180dea:	int3
  180deb:	int3
  180dec:	int3
  180ded:	int3
  180dee:	int3
  180def:	int3

