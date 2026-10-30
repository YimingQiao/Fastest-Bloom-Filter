0000000000015c50 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)>:
   15c50:	push   %r14
   15c52:	push   %rbx
   15c53:	cmp    $0x1,%esi
   15c56:	jne    15caf <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x5f>
   15c58:	mov    (%rdx),%rax
   15c5b:	mov    %rax,%rdx
   15c5e:	shr    $0x20,%rdx
   15c62:	and    0x18(%rdi),%edx
   15c65:	vpbroadcastd %eax,%ymm0
   15c6b:	mov    (%rdi),%rax
   15c6e:	shl    $0x6,%rdx
   15c72:	vpmulld -0x13c1b(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   15c7b:	vmovdqa64 (%rax,%rdx,1),%zmm1
   15c82:	vpsrld $0x1a,%ymm0,%ymm0
   15c87:	vpmovzxdq %ymm0,%zmm0
   15c8d:	vpsrlvq %zmm0,%zmm1,%zmm0
   15c93:	vptestnmq -0x13bc5(%rip){1to8},%zmm0,%k0        # 20d8 <_IO_stdin_used+0x90>
   15c9d:	xor    %eax,%eax
   15c9f:	kortestb %k0,%k0
   15ca3:	sete   %al
   15ca6:	mov    %eax,(%rcx)
   15ca8:	pop    %rbx
   15ca9:	pop    %r14
   15cab:	vzeroupper
   15cae:	ret
   15caf:	mov    %esi,%eax
   15cb1:	cmp    $0x10,%esi
   15cb4:	jae    15cc6 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x76>
   15cb6:	test   %esi,%esi
   15cb8:	je     15ca8 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15cba:	cmp    $0x1,%eax
   15cbd:	jne    15ce9 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x99>
   15cbf:	xor    %eax,%eax
   15cc1:	jmp    15dc2 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x172>
   15cc6:	cmp    $0x21,%esi
   15cc9:	jb     15ce1 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x91>
   15ccb:	lea    -0x20(%rax),%r8
   15ccf:	cmp    $0x21,%rax
   15cd3:	jne    15e1a <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   15cd9:	xor    %r9d,%r9d
   15cdc:	jmp    15f18 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x2c8>
   15ce1:	xor    %r8d,%r8d
   15ce4:	jmp    15f80 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x330>
   15ce9:	mov    %esi,%r8d
   15cec:	and    $0xe,%r8d
   15cf0:	xor    %eax,%eax
   15cf2:	vmovdqa64 -0x1363c(%rip),%zmm0        # 26c0 <_IO_stdin_used+0x678>
   15cfc:	vpbroadcastq -0x13c2e(%rip),%zmm1        # 20d8 <_IO_stdin_used+0x90>
   15d06:	cs nopw 0x0(%rax,%rax,1)
   15d10:	mov    (%rdx,%rax,8),%r9
   15d14:	mov    %r9d,%r10d
   15d17:	shr    $0x20,%r9
   15d1b:	and    0x18(%rdi),%r9d
   15d1f:	mov    (%rdi),%r11
   15d22:	shl    $0x6,%r9
   15d26:	vmovdqa64 (%r11,%r9,1),%zmm2
   15d2d:	vpbroadcastq %r10,%zmm3
   15d33:	vpmulld %zmm0,%zmm3,%zmm3
   15d39:	vpsrlq $0x1a,%zmm3,%zmm3
   15d40:	vpsrlvq %zmm3,%zmm2,%zmm2
   15d46:	vptestnmq %zmm1,%zmm2,%k0
   15d4c:	xor    %r9d,%r9d
   15d4f:	kortestb %k0,%k0
   15d53:	sete   %r9b
   15d57:	mov    %r9d,(%rcx,%rax,4)
   15d5b:	mov    0x8(%rdx,%rax,8),%r9
   15d60:	mov    %r9,%r10
   15d63:	shr    $0x20,%r10
   15d67:	and    0x18(%rdi),%r10d
   15d6b:	mov    %r9d,%r9d
   15d6e:	mov    (%rdi),%r11
   15d71:	shl    $0x6,%r10
   15d75:	vpbroadcastq %r9,%zmm2
   15d7b:	vpmulld %zmm0,%zmm2,%zmm2
   15d81:	vmovdqa64 (%r11,%r10,1),%zmm3
   15d88:	vpsrlq $0x1a,%zmm2,%zmm2
   15d8f:	vpsrlvq %zmm2,%zmm3,%zmm2
   15d95:	vptestnmq %zmm1,%zmm2,%k0
   15d9b:	xor    %r9d,%r9d
   15d9e:	kortestb %k0,%k0
   15da2:	sete   %r9b
   15da6:	mov    %r9d,0x4(%rcx,%rax,4)
   15dab:	add    $0x2,%rax
   15daf:	cmp    %rax,%r8
   15db2:	jne    15d10 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0xc0>
   15db8:	test   $0x1,%sil
   15dbc:	je     15ca8 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15dc2:	mov    (%rdx,%rax,8),%rdx
   15dc6:	mov    %rdx,%rsi
   15dc9:	shr    $0x20,%rsi
   15dcd:	and    0x18(%rdi),%esi
   15dd0:	mov    %edx,%edx
   15dd2:	mov    (%rdi),%rdi
   15dd5:	vpbroadcastq %rdx,%zmm0
   15ddb:	vpmulld -0x13725(%rip),%zmm0,%zmm0        # 26c0 <_IO_stdin_used+0x678>
   15de5:	shl    $0x6,%rsi
   15de9:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   15df0:	vpsrlq $0x1a,%zmm0,%zmm0
   15df7:	vpsrlvq %zmm0,%zmm1,%zmm0
   15dfd:	vptestnmq -0x13d2f(%rip){1to8},%zmm0,%k0        # 20d8 <_IO_stdin_used+0x90>
   15e07:	xor    %edx,%edx
   15e09:	kortestb %k0,%k0
   15e0d:	sete   %dl
   15e10:	mov    %edx,(%rcx,%rax,4)
   15e13:	pop    %rbx
   15e14:	pop    %r14
   15e16:	vzeroupper
   15e19:	ret
   15e1a:	and    $0x1,%esi
   15e1d:	mov    %r8,%r10
   15e20:	sub    %rsi,%r10
   15e23:	xor    %r9d,%r9d
   15e26:	vmovdqa -0x13dce(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   15e2e:	vpbroadcastq -0x13d60(%rip),%zmm1        # 20d8 <_IO_stdin_used+0x90>
   15e38:	nopl   0x0(%rax,%rax,1)
   15e40:	mov    0x18(%rdi),%r11d
   15e44:	mov    0x104(%rdx,%r9,8),%ebx
   15e4c:	and    %r11d,%ebx
   15e4f:	mov    (%rdi),%r14
   15e52:	shl    $0x6,%rbx
   15e56:	prefetcht0 (%r14,%rbx,1)
   15e5b:	mov    (%rdx,%r9,8),%rbx
   15e5f:	vpbroadcastd %ebx,%ymm2
   15e65:	shr    $0x20,%rbx
   15e69:	and    %r11d,%ebx
   15e6c:	shl    $0x6,%rbx
   15e70:	vmovdqa64 (%r14,%rbx,1),%zmm3
   15e77:	vpmulld %ymm0,%ymm2,%ymm2
   15e7c:	vpsrld $0x1a,%ymm2,%ymm2
   15e81:	vpmovzxdq %ymm2,%zmm2
   15e87:	vpsrlvq %zmm2,%zmm3,%zmm2
   15e8d:	vptestnmq %zmm1,%zmm2,%k0
   15e93:	xor    %r11d,%r11d
   15e96:	kortestb %k0,%k0
   15e9a:	sete   %r11b
   15e9e:	mov    %r11d,(%rcx,%r9,4)
   15ea2:	mov    0x18(%rdi),%r11d
   15ea6:	mov    0x10c(%rdx,%r9,8),%ebx
   15eae:	and    %r11d,%ebx
   15eb1:	mov    (%rdi),%r14
   15eb4:	shl    $0x6,%rbx
   15eb8:	prefetcht0 (%r14,%rbx,1)
   15ebd:	mov    0x8(%rdx,%r9,8),%rbx
   15ec2:	vpbroadcastd %ebx,%ymm2
   15ec8:	shr    $0x20,%rbx
   15ecc:	and    %r11d,%ebx
   15ecf:	shl    $0x6,%rbx
   15ed3:	vmovdqa64 (%r14,%rbx,1),%zmm3
   15eda:	vpmulld %ymm0,%ymm2,%ymm2
   15edf:	vpsrld $0x1a,%ymm2,%ymm2
   15ee4:	vpmovzxdq %ymm2,%zmm2
   15eea:	vpsrlvq %zmm2,%zmm3,%zmm2
   15ef0:	vptestnmq %zmm1,%zmm2,%k0
   15ef6:	xor    %r11d,%r11d
   15ef9:	kortestb %k0,%k0
   15efd:	sete   %r11b
   15f01:	mov    %r11d,0x4(%rcx,%r9,4)
   15f06:	add    $0x2,%r9
   15f0a:	cmp    %r9,%r10
   15f0d:	jne    15e40 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   15f13:	test   %rsi,%rsi
   15f16:	je     15f80 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x330>
   15f18:	mov    0x18(%rdi),%esi
   15f1b:	mov    0x104(%rdx,%r9,8),%r10d
   15f23:	and    %esi,%r10d
   15f26:	mov    (%rdi),%r11
   15f29:	shl    $0x6,%r10
   15f2d:	prefetcht0 (%r11,%r10,1)
   15f32:	mov    (%rdx,%r9,8),%r10
   15f36:	vpbroadcastd %r10d,%ymm0
   15f3c:	shr    $0x20,%r10
   15f40:	and    %esi,%r10d
   15f43:	shl    $0x6,%r10
   15f47:	vpmulld -0x13ef0(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   15f50:	vmovdqa64 (%r11,%r10,1),%zmm1
   15f57:	vpsrld $0x1a,%ymm0,%ymm0
   15f5c:	vpmovzxdq %ymm0,%zmm0
   15f62:	vpsrlvq %zmm0,%zmm1,%zmm0
   15f68:	vptestnmq -0x13e9a(%rip){1to8},%zmm0,%k0        # 20d8 <_IO_stdin_used+0x90>
   15f72:	xor    %esi,%esi
   15f74:	kortestb %k0,%k0
   15f78:	sete   %sil
   15f7c:	mov    %esi,(%rcx,%r9,4)
   15f80:	cmp    %rax,%r8
   15f83:	jae    15ca8 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15f89:	vmovdqa -0x13f31(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   15f91:	vpbroadcastq -0x13ec3(%rip),%zmm1        # 20d8 <_IO_stdin_used+0x90>
   15f9b:	nopl   0x0(%rax,%rax,1)
   15fa0:	mov    (%rdx,%r8,8),%rsi
   15fa4:	vpbroadcastd %esi,%ymm2
   15faa:	shr    $0x20,%rsi
   15fae:	and    0x18(%rdi),%esi
   15fb1:	mov    (%rdi),%r9
   15fb4:	shl    $0x6,%rsi
   15fb8:	vpmulld %ymm0,%ymm2,%ymm2
   15fbd:	vmovdqa64 (%r9,%rsi,1),%zmm3
   15fc4:	vpsrld $0x1a,%ymm2,%ymm2
   15fc9:	vpmovzxdq %ymm2,%zmm2
   15fcf:	vpsrlvq %zmm2,%zmm3,%zmm2
   15fd5:	vptestnmq %zmm1,%zmm2,%k0
   15fdb:	xor    %esi,%esi
   15fdd:	kortestb %k0,%k0
   15fe1:	sete   %sil
   15fe5:	mov    %esi,(%rcx,%r8,4)
   15fe9:	inc    %r8
   15fec:	cmp    %r8,%rax
   15fef:	jne    15fa0 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x350>
   15ff1:	jmp    15ca8 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15ff6:	int3
   15ff7:	int3
   15ff8:	int3
   15ff9:	int3
   15ffa:	int3
   15ffb:	int3
   15ffc:	int3
   15ffd:	int3
   15ffe:	int3
   15fff:	int3

