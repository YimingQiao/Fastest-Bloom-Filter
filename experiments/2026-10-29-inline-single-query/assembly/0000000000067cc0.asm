0000000000067cc0 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   67cc0:	48 85 f6             	test   %rsi,%rsi
   67cc3:	0f 84 99 01 00 00    	je     67e62 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   67cc9:	53                   	push   %rbx
   67cca:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
   67cd1:	fe e8 d6
   67cd4:	48 83 fe 01          	cmp    $0x1,%rsi
   67cd8:	75 07                	jne    67ce1 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   67cda:	31 c0                	xor    %eax,%eax
   67cdc:	e9 0c 01 00 00       	jmp    67ded <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   67ce1:	49 89 f1             	mov    %rsi,%r9
   67ce4:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
   67ce8:	31 c0                	xor    %eax,%eax
   67cea:	c5 fd 6f 05 2e cc f9 	vmovdqa -0x633d2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67cf1:	ff
   67cf2:	c4 e2 7d 58 0d ad b5 	vpbroadcastd -0x64a53(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67cf9:	f9 ff
   67cfb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   67d00:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
   67d04:	4d 89 d3             	mov    %r10,%r11
   67d07:	49 c1 eb 20          	shr    $0x20,%r11
   67d0b:	4d 31 d3             	xor    %r10,%r11
   67d0e:	4d 0f af d8          	imul   %r8,%r11
   67d12:	4d 89 da             	mov    %r11,%r10
   67d15:	49 c1 ea 20          	shr    $0x20,%r10
   67d19:	4d 31 da             	xor    %r11,%r10
   67d1c:	4d 0f af d0          	imul   %r8,%r10
   67d20:	4d 89 d3             	mov    %r10,%r11
   67d23:	49 c1 eb 20          	shr    $0x20,%r11
   67d27:	4d 31 d3             	xor    %r10,%r11
   67d2a:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   67d2e:	45 21 da             	and    %r11d,%r10d
   67d31:	0f b6 1f             	movzbl (%rdi),%ebx
   67d34:	c4 42 e3 f7 db       	shrx   %rbx,%r11,%r11
   67d39:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   67d3f:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   67d44:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   67d49:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   67d4e:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   67d52:	49 c1 e2 05          	shl    $0x5,%r10
   67d56:	c4 81 7d 6f 1c 13    	vmovdqa (%r11,%r10,1),%ymm3
   67d5c:	45 31 d2             	xor    %r10d,%r10d
   67d5f:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   67d64:	41 0f 92 c2          	setb   %r10b
   67d68:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
   67d6c:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
   67d71:	4d 89 d3             	mov    %r10,%r11
   67d74:	49 c1 eb 20          	shr    $0x20,%r11
   67d78:	4d 31 d3             	xor    %r10,%r11
   67d7b:	4d 0f af d8          	imul   %r8,%r11
   67d7f:	4d 89 da             	mov    %r11,%r10
   67d82:	49 c1 ea 20          	shr    $0x20,%r10
   67d86:	4d 31 da             	xor    %r11,%r10
   67d89:	4d 0f af d0          	imul   %r8,%r10
   67d8d:	4d 89 d3             	mov    %r10,%r11
   67d90:	49 c1 eb 20          	shr    $0x20,%r11
   67d94:	4d 31 d3             	xor    %r10,%r11
   67d97:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   67d9b:	45 21 da             	and    %r11d,%r10d
   67d9e:	0f b6 1f             	movzbl (%rdi),%ebx
   67da1:	c4 42 e3 f7 db       	shrx   %rbx,%r11,%r11
   67da6:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   67dac:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   67db1:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   67db6:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   67dbb:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   67dbf:	49 c1 e2 05          	shl    $0x5,%r10
   67dc3:	c4 81 7d 6f 1c 13    	vmovdqa (%r11,%r10,1),%ymm3
   67dc9:	45 31 d2             	xor    %r10d,%r10d
   67dcc:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   67dd1:	41 0f 92 c2          	setb   %r10b
   67dd5:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
   67dda:	48 83 c0 02          	add    $0x2,%rax
   67dde:	49 39 c1             	cmp    %rax,%r9
   67de1:	0f 85 19 ff ff ff    	jne    67d00 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   67de7:	40 f6 c6 01          	test   $0x1,%sil
   67deb:	74 74                	je     67e61 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   67ded:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   67df1:	48 89 d6             	mov    %rdx,%rsi
   67df4:	48 c1 ee 20          	shr    $0x20,%rsi
   67df8:	48 31 d6             	xor    %rdx,%rsi
   67dfb:	49 0f af f0          	imul   %r8,%rsi
   67dff:	48 89 f2             	mov    %rsi,%rdx
   67e02:	48 c1 ea 20          	shr    $0x20,%rdx
   67e06:	48 31 f2             	xor    %rsi,%rdx
   67e09:	49 0f af d0          	imul   %r8,%rdx
   67e0d:	48 89 d6             	mov    %rdx,%rsi
   67e10:	48 c1 ee 20          	shr    $0x20,%rsi
   67e14:	48 31 d6             	xor    %rdx,%rsi
   67e17:	8b 57 04             	mov    0x4(%rdi),%edx
   67e1a:	21 f2                	and    %esi,%edx
   67e1c:	44 0f b6 07          	movzbl (%rdi),%r8d
   67e20:	c4 e2 bb f7 f6       	shrx   %r8,%rsi,%rsi
   67e25:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   67e2b:	c4 e2 7d 40 05 ec ca 	vpmulld -0x63514(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67e32:	f9 ff
   67e34:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   67e39:	c4 e2 7d 58 0d 66 b4 	vpbroadcastd -0x64b9a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67e40:	f9 ff
   67e42:	c4 e2 75 47 c0       	vpsllvd %ymm0,%ymm1,%ymm0
   67e47:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   67e4b:	48 c1 e2 05          	shl    $0x5,%rdx
   67e4f:	c5 fd 6f 0c 16       	vmovdqa (%rsi,%rdx,1),%ymm1
   67e54:	31 d2                	xor    %edx,%edx
   67e56:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   67e5b:	0f 92 c2             	setb   %dl
   67e5e:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   67e61:	5b                   	pop    %rbx
   67e62:	c5 f8 77             	vzeroupper
   67e65:	c3                   	ret
   67e66:	cc                   	int3
   67e67:	cc                   	int3
   67e68:	cc                   	int3
   67e69:	cc                   	int3
   67e6a:	cc                   	int3
   67e6b:	cc                   	int3
   67e6c:	cc                   	int3
   67e6d:	cc                   	int3
   67e6e:	cc                   	int3
   67e6f:	cc                   	int3
