0000000000067ce0 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   67ce0:	test   %rsi,%rsi
   67ce3:	je     67e82 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   67ce9:	push   %rbx
   67cea:	movabs $0xd6e8feb86659fd93,%r8
   67cf4:	cmp    $0x1,%rsi
   67cf8:	jne    67d01 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   67cfa:	xor    %eax,%eax
   67cfc:	jmp    67e0d <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   67d01:	mov    %rsi,%r9
   67d04:	and    $0xfffffffffffffffe,%r9
   67d08:	xor    %eax,%eax
   67d0a:	vmovdqa -0x633f2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67d12:	vpbroadcastd -0x64a73(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67d1b:	nopl   0x0(%rax,%rax,1)
   67d20:	mov    (%rdx,%rax,8),%r10
   67d24:	mov    %r10,%r11
   67d27:	shr    $0x20,%r11
   67d2b:	xor    %r10,%r11
   67d2e:	imul   %r8,%r11
   67d32:	mov    %r11,%r10
   67d35:	shr    $0x20,%r10
   67d39:	xor    %r11,%r10
   67d3c:	imul   %r8,%r10
   67d40:	mov    %r10,%r11
   67d43:	shr    $0x20,%r11
   67d47:	xor    %r10,%r11
   67d4a:	mov    0x4(%rdi),%r10d
   67d4e:	and    %r11d,%r10d
   67d51:	movzbl (%rdi),%ebx
   67d54:	shrx   %rbx,%r11,%r11
   67d59:	vpbroadcastd %r11d,%ymm2
   67d5f:	vpmulld %ymm0,%ymm2,%ymm2
   67d64:	vpsrld $0x1b,%ymm2,%ymm2
   67d69:	vpsllvd %ymm2,%ymm1,%ymm2
   67d6e:	mov    0x8(%rdi),%r11
   67d72:	shl    $0x5,%r10
   67d76:	vmovdqa (%r11,%r10,1),%ymm3
   67d7c:	xor    %r10d,%r10d
   67d7f:	vptest %ymm2,%ymm3
   67d84:	setb   %r10b
   67d88:	mov    %r10d,(%rcx,%rax,4)
   67d8c:	mov    0x8(%rdx,%rax,8),%r10
   67d91:	mov    %r10,%r11
   67d94:	shr    $0x20,%r11
   67d98:	xor    %r10,%r11
   67d9b:	imul   %r8,%r11
   67d9f:	mov    %r11,%r10
   67da2:	shr    $0x20,%r10
   67da6:	xor    %r11,%r10
   67da9:	imul   %r8,%r10
   67dad:	mov    %r10,%r11
   67db0:	shr    $0x20,%r11
   67db4:	xor    %r10,%r11
   67db7:	mov    0x4(%rdi),%r10d
   67dbb:	and    %r11d,%r10d
   67dbe:	movzbl (%rdi),%ebx
   67dc1:	shrx   %rbx,%r11,%r11
   67dc6:	vpbroadcastd %r11d,%ymm2
   67dcc:	vpmulld %ymm0,%ymm2,%ymm2
   67dd1:	vpsrld $0x1b,%ymm2,%ymm2
   67dd6:	vpsllvd %ymm2,%ymm1,%ymm2
   67ddb:	mov    0x8(%rdi),%r11
   67ddf:	shl    $0x5,%r10
   67de3:	vmovdqa (%r11,%r10,1),%ymm3
   67de9:	xor    %r10d,%r10d
   67dec:	vptest %ymm2,%ymm3
   67df1:	setb   %r10b
   67df5:	mov    %r10d,0x4(%rcx,%rax,4)
   67dfa:	add    $0x2,%rax
   67dfe:	cmp    %rax,%r9
   67e01:	jne    67d20 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   67e07:	test   $0x1,%sil
   67e0b:	je     67e81 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   67e0d:	mov    (%rdx,%rax,8),%rdx
   67e11:	mov    %rdx,%rsi
   67e14:	shr    $0x20,%rsi
   67e18:	xor    %rdx,%rsi
   67e1b:	imul   %r8,%rsi
   67e1f:	mov    %rsi,%rdx
   67e22:	shr    $0x20,%rdx
   67e26:	xor    %rsi,%rdx
   67e29:	imul   %r8,%rdx
   67e2d:	mov    %rdx,%rsi
   67e30:	shr    $0x20,%rsi
   67e34:	xor    %rdx,%rsi
   67e37:	mov    0x4(%rdi),%edx
   67e3a:	and    %esi,%edx
   67e3c:	movzbl (%rdi),%r8d
   67e40:	shrx   %r8,%rsi,%rsi
   67e45:	vpbroadcastd %esi,%ymm0
   67e4b:	vpmulld -0x63534(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67e54:	vpsrld $0x1b,%ymm0,%ymm0
   67e59:	vpbroadcastd -0x64bba(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67e62:	vpsllvd %ymm0,%ymm1,%ymm0
   67e67:	mov    0x8(%rdi),%rsi
   67e6b:	shl    $0x5,%rdx
   67e6f:	vmovdqa (%rsi,%rdx,1),%ymm1
   67e74:	xor    %edx,%edx
   67e76:	vptest %ymm0,%ymm1
   67e7b:	setb   %dl
   67e7e:	mov    %edx,(%rcx,%rax,4)
   67e81:	pop    %rbx
   67e82:	vzeroupper
   67e85:	ret
   67e86:	int3
   67e87:	int3
   67e88:	int3
   67e89:	int3
   67e8a:	int3
   67e8b:	int3
   67e8c:	int3
   67e8d:	int3
   67e8e:	int3
   67e8f:	int3

