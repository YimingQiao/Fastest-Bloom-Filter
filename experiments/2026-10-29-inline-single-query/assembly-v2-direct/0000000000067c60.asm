0000000000067c60 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   67c60:	test   %rsi,%rsi
   67c63:	je     67e02 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   67c69:	push   %rbx
   67c6a:	movabs $0xd6e8feb86659fd93,%r8
   67c74:	cmp    $0x1,%rsi
   67c78:	jne    67c81 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   67c7a:	xor    %eax,%eax
   67c7c:	jmp    67d8d <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   67c81:	mov    %rsi,%r9
   67c84:	and    $0xfffffffffffffffe,%r9
   67c88:	xor    %eax,%eax
   67c8a:	vmovdqa -0x63372(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67c92:	vpbroadcastd -0x649f3(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67c9b:	nopl   0x0(%rax,%rax,1)
   67ca0:	mov    (%rdx,%rax,8),%r10
   67ca4:	mov    %r10,%r11
   67ca7:	shr    $0x20,%r11
   67cab:	xor    %r10,%r11
   67cae:	imul   %r8,%r11
   67cb2:	mov    %r11,%r10
   67cb5:	shr    $0x20,%r10
   67cb9:	xor    %r11,%r10
   67cbc:	imul   %r8,%r10
   67cc0:	mov    %r10,%r11
   67cc3:	shr    $0x20,%r11
   67cc7:	xor    %r10,%r11
   67cca:	mov    0x4(%rdi),%r10d
   67cce:	and    %r11d,%r10d
   67cd1:	movzbl (%rdi),%ebx
   67cd4:	shrx   %rbx,%r11,%r11
   67cd9:	vpbroadcastd %r11d,%ymm2
   67cdf:	vpmulld %ymm0,%ymm2,%ymm2
   67ce4:	vpsrld $0x1b,%ymm2,%ymm2
   67ce9:	vpsllvd %ymm2,%ymm1,%ymm2
   67cee:	mov    0x8(%rdi),%r11
   67cf2:	shl    $0x5,%r10
   67cf6:	vmovdqa (%r11,%r10,1),%ymm3
   67cfc:	xor    %r10d,%r10d
   67cff:	vptest %ymm2,%ymm3
   67d04:	setb   %r10b
   67d08:	mov    %r10d,(%rcx,%rax,4)
   67d0c:	mov    0x8(%rdx,%rax,8),%r10
   67d11:	mov    %r10,%r11
   67d14:	shr    $0x20,%r11
   67d18:	xor    %r10,%r11
   67d1b:	imul   %r8,%r11
   67d1f:	mov    %r11,%r10
   67d22:	shr    $0x20,%r10
   67d26:	xor    %r11,%r10
   67d29:	imul   %r8,%r10
   67d2d:	mov    %r10,%r11
   67d30:	shr    $0x20,%r11
   67d34:	xor    %r10,%r11
   67d37:	mov    0x4(%rdi),%r10d
   67d3b:	and    %r11d,%r10d
   67d3e:	movzbl (%rdi),%ebx
   67d41:	shrx   %rbx,%r11,%r11
   67d46:	vpbroadcastd %r11d,%ymm2
   67d4c:	vpmulld %ymm0,%ymm2,%ymm2
   67d51:	vpsrld $0x1b,%ymm2,%ymm2
   67d56:	vpsllvd %ymm2,%ymm1,%ymm2
   67d5b:	mov    0x8(%rdi),%r11
   67d5f:	shl    $0x5,%r10
   67d63:	vmovdqa (%r11,%r10,1),%ymm3
   67d69:	xor    %r10d,%r10d
   67d6c:	vptest %ymm2,%ymm3
   67d71:	setb   %r10b
   67d75:	mov    %r10d,0x4(%rcx,%rax,4)
   67d7a:	add    $0x2,%rax
   67d7e:	cmp    %rax,%r9
   67d81:	jne    67ca0 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   67d87:	test   $0x1,%sil
   67d8b:	je     67e01 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   67d8d:	mov    (%rdx,%rax,8),%rdx
   67d91:	mov    %rdx,%rsi
   67d94:	shr    $0x20,%rsi
   67d98:	xor    %rdx,%rsi
   67d9b:	imul   %r8,%rsi
   67d9f:	mov    %rsi,%rdx
   67da2:	shr    $0x20,%rdx
   67da6:	xor    %rsi,%rdx
   67da9:	imul   %r8,%rdx
   67dad:	mov    %rdx,%rsi
   67db0:	shr    $0x20,%rsi
   67db4:	xor    %rdx,%rsi
   67db7:	mov    0x4(%rdi),%edx
   67dba:	and    %esi,%edx
   67dbc:	movzbl (%rdi),%r8d
   67dc0:	shrx   %r8,%rsi,%rsi
   67dc5:	vpbroadcastd %esi,%ymm0
   67dcb:	vpmulld -0x634b4(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67dd4:	vpsrld $0x1b,%ymm0,%ymm0
   67dd9:	vpbroadcastd -0x64b3a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67de2:	vpsllvd %ymm0,%ymm1,%ymm0
   67de7:	mov    0x8(%rdi),%rsi
   67deb:	shl    $0x5,%rdx
   67def:	vmovdqa (%rsi,%rdx,1),%ymm1
   67df4:	xor    %edx,%edx
   67df6:	vptest %ymm0,%ymm1
   67dfb:	setb   %dl
   67dfe:	mov    %edx,(%rcx,%rax,4)
   67e01:	pop    %rbx
   67e02:	vzeroupper
   67e05:	ret
   67e06:	int3
   67e07:	int3
   67e08:	int3
   67e09:	int3
   67e0a:	int3
   67e0b:	int3
   67e0c:	int3
   67e0d:	int3
   67e0e:	int3
   67e0f:	int3

