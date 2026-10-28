0000000000022c30 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)>:
   22c30:	push   %rbp
   22c31:	push   %r15
   22c33:	push   %r14
   22c35:	push   %r12
   22c37:	push   %rbx
   22c38:	cmp    $0x1,%esi
   22c3b:	jne    22c9d <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x6d>
   22c3d:	mov    (%rdx),%rax
   22c40:	mov    %eax,%edx
   22c42:	shr    $0x20,%rax
   22c46:	and    0x18(%rdi),%eax
   22c49:	mov    (%rdi),%rsi
   22c4c:	shl    $0x6,%rax
   22c50:	vpbroadcastq %rdx,%zmm0
   22c56:	vpmulld -0x204e0(%rip),%zmm0,%zmm0        # 2780 <_IO_stdin_used+0x778>
   22c60:	vpsrlq $0x1a,%zmm0,%zmm0
   22c67:	vmovdqa64 (%rsi,%rax,1),%zmm1
   22c6e:	vpshufbitqmb %zmm0,%zmm1,%k0
   22c74:	kmovq  %k0,%rax
   22c79:	movabs $0x101010101010101,%rdx
   22c83:	and    %rdx,%rax
   22c86:	xor    %esi,%esi
   22c88:	cmp    %rdx,%rax
   22c8b:	sete   %sil
   22c8f:	mov    %esi,(%rcx)
   22c91:	pop    %rbx
   22c92:	pop    %r12
   22c94:	pop    %r14
   22c96:	pop    %r15
   22c98:	pop    %rbp
   22c99:	vzeroupper
   22c9c:	ret
   22c9d:	mov    %esi,%eax
   22c9f:	cmp    $0x10,%esi
   22ca2:	jae    22cbe <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x8e>
   22ca4:	test   %esi,%esi
   22ca6:	je     22c91 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   22ca8:	movabs $0x101010101010101,%r8
   22cb2:	cmp    $0x1,%eax
   22cb5:	jne    22ceb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xbb>
   22cb7:	xor    %eax,%eax
   22cb9:	jmp    22db1 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   22cbe:	movabs $0x101010101010101,%r8
   22cc8:	cmp    $0x21,%esi
   22ccb:	jb     22ce3 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xb3>
   22ccd:	lea    -0x20(%rax),%r9
   22cd1:	cmp    $0x21,%rax
   22cd5:	jne    22e05 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
   22cdb:	xor    %r10d,%r10d
   22cde:	jmp    22ef5 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   22ce3:	xor    %r9d,%r9d
   22ce6:	jmp    22f5b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   22ceb:	mov    %esi,%r9d
   22cee:	and    $0xe,%r9d
   22cf2:	xor    %eax,%eax
   22cf4:	vmovdqa64 -0x2057e(%rip),%zmm0        # 2780 <_IO_stdin_used+0x778>
   22cfe:	xchg   %ax,%ax
   22d00:	mov    (%rdx,%rax,8),%r10
   22d04:	mov    %r10d,%r11d
   22d07:	shr    $0x20,%r10
   22d0b:	and    0x18(%rdi),%r10d
   22d0f:	mov    (%rdi),%rbx
   22d12:	vpbroadcastq %r11,%zmm1
   22d18:	vpmulld %zmm0,%zmm1,%zmm1
   22d1e:	shl    $0x6,%r10
   22d22:	vpsrlq $0x1a,%zmm1,%zmm1
   22d29:	vmovaps (%rbx,%r10,1),%zmm2
   22d30:	vpshufbitqmb %zmm1,%zmm2,%k0
   22d36:	kmovq  %k0,%r10
   22d3b:	and    %r8,%r10
   22d3e:	xor    %r11d,%r11d
   22d41:	cmp    %r8,%r10
   22d44:	sete   %r11b
   22d48:	mov    %r11d,(%rcx,%rax,4)
   22d4c:	mov    0x8(%rdx,%rax,8),%r10
   22d51:	mov    %r10d,%r11d
   22d54:	shr    $0x20,%r10
   22d58:	and    0x18(%rdi),%r10d
   22d5c:	mov    (%rdi),%rbx
   22d5f:	shl    $0x6,%r10
   22d63:	vpbroadcastq %r11,%zmm1
   22d69:	vpmulld %zmm0,%zmm1,%zmm1
   22d6f:	vpsrlq $0x1a,%zmm1,%zmm1
   22d76:	vmovaps (%rbx,%r10,1),%zmm2
   22d7d:	vpshufbitqmb %zmm1,%zmm2,%k0
   22d83:	kmovq  %k0,%r10
   22d88:	and    %r8,%r10
   22d8b:	xor    %r11d,%r11d
   22d8e:	cmp    %r8,%r10
   22d91:	sete   %r11b
   22d95:	mov    %r11d,0x4(%rcx,%rax,4)
   22d9a:	add    $0x2,%rax
   22d9e:	cmp    %rax,%r9
   22da1:	jne    22d00 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   22da7:	test   $0x1,%sil
   22dab:	je     22c91 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   22db1:	mov    (%rdx,%rax,8),%rdx
   22db5:	mov    %rdx,%rsi
   22db8:	shr    $0x20,%rsi
   22dbc:	and    0x18(%rdi),%esi
   22dbf:	mov    %edx,%edx
   22dc1:	mov    (%rdi),%rdi
   22dc4:	vpbroadcastq %rdx,%zmm0
   22dca:	vpmulld -0x20654(%rip),%zmm0,%zmm0        # 2780 <_IO_stdin_used+0x778>
   22dd4:	shl    $0x6,%rsi
   22dd8:	vpsrlq $0x1a,%zmm0,%zmm0
   22ddf:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   22de6:	vpshufbitqmb %zmm0,%zmm1,%k0
   22dec:	kmovq  %k0,%rdx
   22df1:	and    %r8,%rdx
   22df4:	xor    %esi,%esi
   22df6:	cmp    %r8,%rdx
   22df9:	sete   %sil
   22dfd:	mov    %esi,(%rcx,%rax,4)
   22e00:	jmp    22c91 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   22e05:	and    $0x1,%esi
   22e08:	mov    %r9,%r11
   22e0b:	sub    %rsi,%r11
   22e0e:	xor    %r10d,%r10d
   22e11:	vmovdqa64 -0x2069b(%rip),%zmm0        # 2780 <_IO_stdin_used+0x778>
   22e1b:	nopl   0x0(%rax,%rax,1)
   22e20:	mov    0x18(%rdi),%ebp
   22e23:	mov    0x104(%rdx,%r10,8),%ebx
   22e2b:	and    %ebp,%ebx
   22e2d:	mov    (%rdx,%r10,8),%r14
   22e31:	mov    %r14d,%r15d
   22e34:	shr    $0x20,%r14
   22e38:	and    %ebp,%r14d
   22e3b:	mov    (%rdi),%r12
   22e3e:	shl    $0x6,%r14
   22e42:	vpbroadcastq %r15,%zmm1
   22e48:	vpmulld %zmm0,%zmm1,%zmm1
   22e4e:	vpsrlq $0x1a,%zmm1,%zmm1
   22e55:	vmovaps (%r12,%r14,1),%zmm2
   22e5c:	vpshufbitqmb %zmm1,%zmm2,%k0
   22e62:	shl    $0x6,%rbx
   22e66:	kmovq  %k0,%r14
   22e6b:	and    %r8,%r14
   22e6e:	xor    %ebp,%ebp
   22e70:	cmp    %r8,%r14
   22e73:	sete   %bpl
   22e77:	prefetcht0 (%r12,%rbx,1)
   22e7c:	mov    %ebp,(%rcx,%r10,4)
   22e80:	mov    0x18(%rdi),%ebx
   22e83:	mov    0x10c(%rdx,%r10,8),%r14d
   22e8b:	and    %ebx,%r14d
   22e8e:	mov    (%rdi),%r15
   22e91:	shl    $0x6,%r14
   22e95:	prefetcht0 (%r15,%r14,1)
   22e9a:	mov    0x8(%rdx,%r10,8),%r14
   22e9f:	mov    %r14d,%r12d
   22ea2:	shr    $0x20,%r14
   22ea6:	and    %ebx,%r14d
   22ea9:	shl    $0x6,%r14
   22ead:	vpbroadcastq %r12,%zmm1
   22eb3:	vpmulld %zmm0,%zmm1,%zmm1
   22eb9:	vpsrlq $0x1a,%zmm1,%zmm1
   22ec0:	vmovaps (%r15,%r14,1),%zmm2
   22ec7:	vpshufbitqmb %zmm1,%zmm2,%k0
   22ecd:	kmovq  %k0,%rbx
   22ed2:	and    %r8,%rbx
   22ed5:	xor    %ebp,%ebp
   22ed7:	cmp    %r8,%rbx
   22eda:	sete   %bpl
   22ede:	mov    %ebp,0x4(%rcx,%r10,4)
   22ee3:	add    $0x2,%r10
   22ee7:	cmp    %r10,%r11
   22eea:	jne    22e20 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   22ef0:	test   %rsi,%rsi
   22ef3:	je     22f5b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   22ef5:	mov    0x18(%rdi),%esi
   22ef8:	mov    0x104(%rdx,%r10,8),%r11d
   22f00:	and    %esi,%r11d
   22f03:	mov    (%rdi),%rbx
   22f06:	shl    $0x6,%r11
   22f0a:	prefetcht0 (%rbx,%r11,1)
   22f0f:	mov    (%rdx,%r10,8),%r11
   22f13:	mov    %r11d,%r14d
   22f16:	shr    $0x20,%r11
   22f1a:	and    %esi,%r11d
   22f1d:	vpbroadcastq %r14,%zmm0
   22f23:	vpmulld -0x207ad(%rip),%zmm0,%zmm0        # 2780 <_IO_stdin_used+0x778>
   22f2d:	shl    $0x6,%r11
   22f31:	vpsrlq $0x1a,%zmm0,%zmm0
   22f38:	vmovdqa64 (%rbx,%r11,1),%zmm1
   22f3f:	vpshufbitqmb %zmm0,%zmm1,%k0
   22f45:	kmovq  %k0,%rsi
   22f4a:	and    %r8,%rsi
   22f4d:	xor    %r11d,%r11d
   22f50:	cmp    %r8,%rsi
   22f53:	sete   %r11b
   22f57:	mov    %r11d,(%rcx,%r10,4)
   22f5b:	cmp    %rax,%r9
   22f5e:	jae    22c91 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   22f64:	vmovdqa64 -0x207ee(%rip),%zmm0        # 2780 <_IO_stdin_used+0x778>
   22f6e:	xchg   %ax,%ax
   22f70:	mov    (%rdx,%r9,8),%rsi
   22f74:	mov    %rsi,%r10
   22f77:	shr    $0x20,%r10
   22f7b:	and    0x18(%rdi),%r10d
   22f7f:	mov    %esi,%esi
   22f81:	mov    (%rdi),%r11
   22f84:	shl    $0x6,%r10
   22f88:	vpbroadcastq %rsi,%zmm1
   22f8e:	vpmulld %zmm0,%zmm1,%zmm1
   22f94:	vpsrlq $0x1a,%zmm1,%zmm1
   22f9b:	vmovaps (%r11,%r10,1),%zmm2
   22fa2:	vpshufbitqmb %zmm1,%zmm2,%k0
   22fa8:	kmovq  %k0,%rsi
   22fad:	and    %r8,%rsi
   22fb0:	xor    %r10d,%r10d
   22fb3:	cmp    %r8,%rsi
   22fb6:	sete   %r10b
   22fba:	mov    %r10d,(%rcx,%r9,4)
   22fbe:	inc    %r9
   22fc1:	cmp    %r9,%rax
   22fc4:	jne    22f70 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   22fc6:	jmp    22c91 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   22fcb:	int3
   22fcc:	int3
   22fcd:	int3
   22fce:	int3
   22fcf:	int3

