0000000000019ab0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)>:
   19ab0:	push   %rbp
   19ab1:	push   %r15
   19ab3:	push   %r14
   19ab5:	push   %rbx
   19ab6:	cmp    $0x1,%esi
   19ab9:	jne    19b1a <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x6a>
   19abb:	mov    (%rdx),%rax
   19abe:	vpbroadcastd %eax,%ymm0
   19ac4:	shr    $0x20,%rax
   19ac8:	and    0x18(%rdi),%eax
   19acb:	mov    (%rdi),%rdx
   19ace:	shl    $0x6,%rax
   19ad2:	vpmulld -0x17abb(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   19adb:	vpsrld $0x1a,%ymm0,%ymm0
   19ae0:	vpmovzxdq %ymm0,%zmm0
   19ae6:	vmovdqa64 (%rdx,%rax,1),%zmm1
   19aed:	vpshufbitqmb %zmm0,%zmm1,%k0
   19af3:	kmovq  %k0,%rax
   19af8:	movabs $0x101010101010101,%rdx
   19b02:	and    %rdx,%rax
   19b05:	xor    %esi,%esi
   19b07:	cmp    %rdx,%rax
   19b0a:	sete   %sil
   19b0e:	mov    %esi,(%rcx)
   19b10:	pop    %rbx
   19b11:	pop    %r14
   19b13:	pop    %r15
   19b15:	pop    %rbp
   19b16:	vzeroupper
   19b19:	ret
   19b1a:	mov    %esi,%eax
   19b1c:	cmp    $0x10,%esi
   19b1f:	jae    19b3b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x8b>
   19b21:	test   %esi,%esi
   19b23:	je     19b10 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   19b25:	movabs $0x101010101010101,%r8
   19b2f:	cmp    $0x1,%eax
   19b32:	jne    19b68 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xb8>
   19b34:	xor    %eax,%eax
   19b36:	jmp    19c31 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   19b3b:	movabs $0x101010101010101,%r8
   19b45:	cmp    $0x21,%esi
   19b48:	jb     19b60 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
   19b4a:	lea    -0x20(%rax),%r9
   19b4e:	cmp    $0x21,%rax
   19b52:	jne    19c85 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
   19b58:	xor    %r10d,%r10d
   19b5b:	jmp    19d75 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   19b60:	xor    %r9d,%r9d
   19b63:	jmp    19ddb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   19b68:	mov    %esi,%r9d
   19b6b:	and    $0xe,%r9d
   19b6f:	xor    %eax,%eax
   19b71:	vmovdqa64 -0x1747b(%rip),%zmm0        # 2700 <_IO_stdin_used+0x6f8>
   19b7b:	nopl   0x0(%rax,%rax,1)
   19b80:	mov    (%rdx,%rax,8),%r10
   19b84:	mov    %r10d,%r11d
   19b87:	shr    $0x20,%r10
   19b8b:	and    0x18(%rdi),%r10d
   19b8f:	mov    (%rdi),%rbx
   19b92:	vpbroadcastq %r11,%zmm1
   19b98:	vpmulld %zmm0,%zmm1,%zmm1
   19b9e:	shl    $0x6,%r10
   19ba2:	vpsrlq $0x1a,%zmm1,%zmm1
   19ba9:	vmovaps (%rbx,%r10,1),%zmm2
   19bb0:	vpshufbitqmb %zmm1,%zmm2,%k0
   19bb6:	kmovq  %k0,%r10
   19bbb:	and    %r8,%r10
   19bbe:	xor    %r11d,%r11d
   19bc1:	cmp    %r8,%r10
   19bc4:	sete   %r11b
   19bc8:	mov    %r11d,(%rcx,%rax,4)
   19bcc:	mov    0x8(%rdx,%rax,8),%r10
   19bd1:	mov    %r10d,%r11d
   19bd4:	shr    $0x20,%r10
   19bd8:	and    0x18(%rdi),%r10d
   19bdc:	mov    (%rdi),%rbx
   19bdf:	shl    $0x6,%r10
   19be3:	vpbroadcastq %r11,%zmm1
   19be9:	vpmulld %zmm0,%zmm1,%zmm1
   19bef:	vpsrlq $0x1a,%zmm1,%zmm1
   19bf6:	vmovaps (%rbx,%r10,1),%zmm2
   19bfd:	vpshufbitqmb %zmm1,%zmm2,%k0
   19c03:	kmovq  %k0,%r10
   19c08:	and    %r8,%r10
   19c0b:	xor    %r11d,%r11d
   19c0e:	cmp    %r8,%r10
   19c11:	sete   %r11b
   19c15:	mov    %r11d,0x4(%rcx,%rax,4)
   19c1a:	add    $0x2,%rax
   19c1e:	cmp    %rax,%r9
   19c21:	jne    19b80 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   19c27:	test   $0x1,%sil
   19c2b:	je     19b10 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   19c31:	mov    (%rdx,%rax,8),%rdx
   19c35:	mov    %rdx,%rsi
   19c38:	shr    $0x20,%rsi
   19c3c:	and    0x18(%rdi),%esi
   19c3f:	mov    %edx,%edx
   19c41:	mov    (%rdi),%rdi
   19c44:	vpbroadcastq %rdx,%zmm0
   19c4a:	vpmulld -0x17554(%rip),%zmm0,%zmm0        # 2700 <_IO_stdin_used+0x6f8>
   19c54:	shl    $0x6,%rsi
   19c58:	vpsrlq $0x1a,%zmm0,%zmm0
   19c5f:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   19c66:	vpshufbitqmb %zmm0,%zmm1,%k0
   19c6c:	kmovq  %k0,%rdx
   19c71:	and    %r8,%rdx
   19c74:	xor    %esi,%esi
   19c76:	cmp    %r8,%rdx
   19c79:	sete   %sil
   19c7d:	mov    %esi,(%rcx,%rax,4)
   19c80:	jmp    19b10 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   19c85:	and    $0x1,%esi
   19c88:	mov    %r9,%r11
   19c8b:	sub    %rsi,%r11
   19c8e:	xor    %r10d,%r10d
   19c91:	vmovdqa -0x17c79(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   19c99:	nopl   0x0(%rax)
   19ca0:	mov    0x18(%rdi),%ebp
   19ca3:	mov    0x104(%rdx,%r10,8),%ebx
   19cab:	and    %ebp,%ebx
   19cad:	mov    (%rdi),%r14
   19cb0:	mov    (%rdx,%r10,8),%r15
   19cb4:	vpbroadcastd %r15d,%ymm1
   19cba:	shr    $0x20,%r15
   19cbe:	and    %ebp,%r15d
   19cc1:	vpmulld %ymm0,%ymm1,%ymm1
   19cc6:	shl    $0x6,%r15
   19cca:	vpsrld $0x1a,%ymm1,%ymm1
   19ccf:	vpmovzxdq %ymm1,%zmm1
   19cd5:	vmovaps (%r14,%r15,1),%zmm2
   19cdc:	vpshufbitqmb %zmm1,%zmm2,%k0
   19ce2:	shl    $0x6,%rbx
   19ce6:	kmovq  %k0,%r15
   19ceb:	and    %r8,%r15
   19cee:	xor    %ebp,%ebp
   19cf0:	cmp    %r8,%r15
   19cf3:	sete   %bpl
   19cf7:	prefetcht0 (%r14,%rbx,1)
   19cfc:	mov    %ebp,(%rcx,%r10,4)
   19d00:	mov    0x18(%rdi),%ebx
   19d03:	mov    0x10c(%rdx,%r10,8),%r14d
   19d0b:	and    %ebx,%r14d
   19d0e:	mov    (%rdi),%r15
   19d11:	shl    $0x6,%r14
   19d15:	prefetcht0 (%r15,%r14,1)
   19d1a:	mov    0x8(%rdx,%r10,8),%r14
   19d1f:	vpbroadcastd %r14d,%ymm1
   19d25:	shr    $0x20,%r14
   19d29:	and    %ebx,%r14d
   19d2c:	shl    $0x6,%r14
   19d30:	vpmulld %ymm0,%ymm1,%ymm1
   19d35:	vpsrld $0x1a,%ymm1,%ymm1
   19d3a:	vpmovzxdq %ymm1,%zmm1
   19d40:	vmovaps (%r15,%r14,1),%zmm2
   19d47:	vpshufbitqmb %zmm1,%zmm2,%k0
   19d4d:	kmovq  %k0,%rbx
   19d52:	and    %r8,%rbx
   19d55:	xor    %ebp,%ebp
   19d57:	cmp    %r8,%rbx
   19d5a:	sete   %bpl
   19d5e:	mov    %ebp,0x4(%rcx,%r10,4)
   19d63:	add    $0x2,%r10
   19d67:	cmp    %r10,%r11
   19d6a:	jne    19ca0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   19d70:	test   %rsi,%rsi
   19d73:	je     19ddb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   19d75:	mov    0x18(%rdi),%esi
   19d78:	mov    0x104(%rdx,%r10,8),%r11d
   19d80:	and    %esi,%r11d
   19d83:	mov    (%rdi),%rbx
   19d86:	shl    $0x6,%r11
   19d8a:	prefetcht0 (%rbx,%r11,1)
   19d8f:	mov    (%rdx,%r10,8),%r11
   19d93:	vpbroadcastd %r11d,%ymm0
   19d99:	shr    $0x20,%r11
   19d9d:	and    %esi,%r11d
   19da0:	shl    $0x6,%r11
   19da4:	vpmulld -0x17d8d(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   19dad:	vpsrld $0x1a,%ymm0,%ymm0
   19db2:	vpmovzxdq %ymm0,%zmm0
   19db8:	vmovdqa64 (%rbx,%r11,1),%zmm1
   19dbf:	vpshufbitqmb %zmm0,%zmm1,%k0
   19dc5:	kmovq  %k0,%rsi
   19dca:	and    %r8,%rsi
   19dcd:	xor    %r11d,%r11d
   19dd0:	cmp    %r8,%rsi
   19dd3:	sete   %r11b
   19dd7:	mov    %r11d,(%rcx,%r10,4)
   19ddb:	cmp    %rax,%r9
   19dde:	jae    19b10 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   19de4:	vmovdqa -0x17dcc(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   19dec:	nopl   0x0(%rax)
   19df0:	mov    (%rdx,%r9,8),%rsi
   19df4:	mov    %rsi,%r10
   19df7:	shr    $0x20,%r10
   19dfb:	and    0x18(%rdi),%r10d
   19dff:	vpbroadcastd %esi,%ymm1
   19e05:	mov    (%rdi),%rsi
   19e08:	shl    $0x6,%r10
   19e0c:	vpmulld %ymm0,%ymm1,%ymm1
   19e11:	vpsrld $0x1a,%ymm1,%ymm1
   19e16:	vpmovzxdq %ymm1,%zmm1
   19e1c:	vmovaps (%rsi,%r10,1),%zmm2
   19e23:	vpshufbitqmb %zmm1,%zmm2,%k0
   19e29:	kmovq  %k0,%rsi
   19e2e:	and    %r8,%rsi
   19e31:	xor    %r10d,%r10d
   19e34:	cmp    %r8,%rsi
   19e37:	sete   %r10b
   19e3b:	mov    %r10d,(%rcx,%r9,4)
   19e3f:	inc    %r9
   19e42:	cmp    %r9,%rax
   19e45:	jne    19df0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   19e47:	jmp    19b10 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   19e4c:	int3
   19e4d:	int3
   19e4e:	int3
   19e4f:	int3

