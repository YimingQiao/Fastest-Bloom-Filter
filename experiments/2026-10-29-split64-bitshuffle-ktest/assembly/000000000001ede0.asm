000000000001ede0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)>:
   1ede0:	push   %rbp
   1ede1:	push   %r15
   1ede3:	push   %r14
   1ede5:	push   %rbx
   1ede6:	cmp    $0x1,%esi
   1ede9:	jne    1ee4a <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x6a>
   1edeb:	mov    (%rdx),%rax
   1edee:	vpbroadcastd %eax,%ymm0
   1edf4:	shr    $0x20,%rax
   1edf8:	and    0x18(%rdi),%eax
   1edfb:	mov    (%rdi),%rdx
   1edfe:	shl    $0x6,%rax
   1ee02:	vpmulld -0x1cdab(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   1ee0b:	vpsrld $0x1a,%ymm0,%ymm0
   1ee10:	vpmovzxdq %ymm0,%zmm0
   1ee16:	vmovdqa64 (%rdx,%rax,1),%zmm1
   1ee1d:	vpshufbitqmb %zmm0,%zmm1,%k0
   1ee23:	kmovq  %k0,%rax
   1ee28:	movabs $0x101010101010101,%rdx
   1ee32:	and    %rdx,%rax
   1ee35:	xor    %esi,%esi
   1ee37:	cmp    %rdx,%rax
   1ee3a:	sete   %sil
   1ee3e:	mov    %esi,(%rcx)
   1ee40:	pop    %rbx
   1ee41:	pop    %r14
   1ee43:	pop    %r15
   1ee45:	pop    %rbp
   1ee46:	vzeroupper
   1ee49:	ret
   1ee4a:	mov    %esi,%eax
   1ee4c:	cmp    $0x10,%esi
   1ee4f:	jae    1ee6b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x8b>
   1ee51:	test   %esi,%esi
   1ee53:	je     1ee40 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1ee55:	movabs $0x101010101010101,%r8
   1ee5f:	cmp    $0x1,%eax
   1ee62:	jne    1ee98 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xb8>
   1ee64:	xor    %eax,%eax
   1ee66:	jmp    1ef61 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   1ee6b:	movabs $0x101010101010101,%r8
   1ee75:	cmp    $0x21,%esi
   1ee78:	jb     1ee90 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
   1ee7a:	lea    -0x20(%rax),%r9
   1ee7e:	cmp    $0x21,%rax
   1ee82:	jne    1efb6 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x1d6>
   1ee88:	xor    %r10d,%r10d
   1ee8b:	jmp    1f0a5 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   1ee90:	xor    %r9d,%r9d
   1ee93:	jmp    1f10b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1ee98:	mov    %esi,%r9d
   1ee9b:	and    $0xe,%r9d
   1ee9f:	xor    %eax,%eax
   1eea1:	vmovdqa -0x1ce49(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   1eea9:	nopl   0x0(%rax)
   1eeb0:	mov    (%rdx,%rax,8),%r10
   1eeb4:	vpbroadcastd %r10d,%ymm1
   1eeba:	shr    $0x20,%r10
   1eebe:	and    0x18(%rdi),%r10d
   1eec2:	mov    (%rdi),%r11
   1eec5:	shl    $0x6,%r10
   1eec9:	vpmulld %ymm0,%ymm1,%ymm1
   1eece:	vpsrld $0x1a,%ymm1,%ymm1
   1eed3:	vpmovzxdq %ymm1,%zmm1
   1eed9:	vmovaps (%r11,%r10,1),%zmm2
   1eee0:	vpshufbitqmb %zmm1,%zmm2,%k0
   1eee6:	kmovq  %k0,%r10
   1eeeb:	and    %r8,%r10
   1eeee:	xor    %r11d,%r11d
   1eef1:	cmp    %r8,%r10
   1eef4:	sete   %r11b
   1eef8:	mov    %r11d,(%rcx,%rax,4)
   1eefc:	mov    0x8(%rdx,%rax,8),%r10
   1ef01:	vpbroadcastd %r10d,%ymm1
   1ef07:	shr    $0x20,%r10
   1ef0b:	and    0x18(%rdi),%r10d
   1ef0f:	mov    (%rdi),%r11
   1ef12:	shl    $0x6,%r10
   1ef16:	vpmulld %ymm0,%ymm1,%ymm1
   1ef1b:	vpsrld $0x1a,%ymm1,%ymm1
   1ef20:	vpmovzxdq %ymm1,%zmm1
   1ef26:	vmovaps (%r11,%r10,1),%zmm2
   1ef2d:	vpshufbitqmb %zmm1,%zmm2,%k0
   1ef33:	kmovq  %k0,%r10
   1ef38:	and    %r8,%r10
   1ef3b:	xor    %r11d,%r11d
   1ef3e:	cmp    %r8,%r10
   1ef41:	sete   %r11b
   1ef45:	mov    %r11d,0x4(%rcx,%rax,4)
   1ef4a:	add    $0x2,%rax
   1ef4e:	cmp    %rax,%r9
   1ef51:	jne    1eeb0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   1ef57:	test   $0x1,%sil
   1ef5b:	je     1ee40 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1ef61:	mov    (%rdx,%rax,8),%rdx
   1ef65:	mov    %rdx,%rsi
   1ef68:	shr    $0x20,%rsi
   1ef6c:	and    0x18(%rdi),%esi
   1ef6f:	vpbroadcastd %edx,%ymm0
   1ef75:	mov    (%rdi),%rdx
   1ef78:	shl    $0x6,%rsi
   1ef7c:	vpmulld -0x1cf25(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   1ef85:	vpsrld $0x1a,%ymm0,%ymm0
   1ef8a:	vpmovzxdq %ymm0,%zmm0
   1ef90:	vmovdqa64 (%rdx,%rsi,1),%zmm1
   1ef97:	vpshufbitqmb %zmm0,%zmm1,%k0
   1ef9d:	kmovq  %k0,%rdx
   1efa2:	and    %r8,%rdx
   1efa5:	xor    %esi,%esi
   1efa7:	cmp    %r8,%rdx
   1efaa:	sete   %sil
   1efae:	mov    %esi,(%rcx,%rax,4)
   1efb1:	jmp    1ee40 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1efb6:	and    $0x1,%esi
   1efb9:	mov    %r9,%r11
   1efbc:	sub    %rsi,%r11
   1efbf:	xor    %r10d,%r10d
   1efc2:	vmovdqa -0x1cf6a(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   1efca:	nopw   0x0(%rax,%rax,1)
   1efd0:	mov    0x18(%rdi),%ebp
   1efd3:	mov    0x104(%rdx,%r10,8),%ebx
   1efdb:	and    %ebp,%ebx
   1efdd:	mov    (%rdi),%r14
   1efe0:	mov    (%rdx,%r10,8),%r15
   1efe4:	vpbroadcastd %r15d,%ymm1
   1efea:	shr    $0x20,%r15
   1efee:	and    %ebp,%r15d
   1eff1:	vpmulld %ymm0,%ymm1,%ymm1
   1eff6:	shl    $0x6,%r15
   1effa:	vpsrld $0x1a,%ymm1,%ymm1
   1efff:	vpmovzxdq %ymm1,%zmm1
   1f005:	vmovaps (%r14,%r15,1),%zmm2
   1f00c:	vpshufbitqmb %zmm1,%zmm2,%k0
   1f012:	shl    $0x6,%rbx
   1f016:	kmovq  %k0,%r15
   1f01b:	and    %r8,%r15
   1f01e:	xor    %ebp,%ebp
   1f020:	cmp    %r8,%r15
   1f023:	sete   %bpl
   1f027:	prefetcht0 (%r14,%rbx,1)
   1f02c:	mov    %ebp,(%rcx,%r10,4)
   1f030:	mov    0x18(%rdi),%ebx
   1f033:	mov    0x10c(%rdx,%r10,8),%r14d
   1f03b:	and    %ebx,%r14d
   1f03e:	mov    (%rdi),%r15
   1f041:	shl    $0x6,%r14
   1f045:	prefetcht0 (%r15,%r14,1)
   1f04a:	mov    0x8(%rdx,%r10,8),%r14
   1f04f:	vpbroadcastd %r14d,%ymm1
   1f055:	shr    $0x20,%r14
   1f059:	and    %ebx,%r14d
   1f05c:	shl    $0x6,%r14
   1f060:	vpmulld %ymm0,%ymm1,%ymm1
   1f065:	vpsrld $0x1a,%ymm1,%ymm1
   1f06a:	vpmovzxdq %ymm1,%zmm1
   1f070:	vmovaps (%r15,%r14,1),%zmm2
   1f077:	vpshufbitqmb %zmm1,%zmm2,%k0
   1f07d:	kmovq  %k0,%rbx
   1f082:	and    %r8,%rbx
   1f085:	xor    %ebp,%ebp
   1f087:	cmp    %r8,%rbx
   1f08a:	sete   %bpl
   1f08e:	mov    %ebp,0x4(%rcx,%r10,4)
   1f093:	add    $0x2,%r10
   1f097:	cmp    %r10,%r11
   1f09a:	jne    1efd0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   1f0a0:	test   %rsi,%rsi
   1f0a3:	je     1f10b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1f0a5:	mov    0x18(%rdi),%esi
   1f0a8:	mov    0x104(%rdx,%r10,8),%r11d
   1f0b0:	and    %esi,%r11d
   1f0b3:	mov    (%rdi),%rbx
   1f0b6:	shl    $0x6,%r11
   1f0ba:	prefetcht0 (%rbx,%r11,1)
   1f0bf:	mov    (%rdx,%r10,8),%r11
   1f0c3:	vpbroadcastd %r11d,%ymm0
   1f0c9:	shr    $0x20,%r11
   1f0cd:	and    %esi,%r11d
   1f0d0:	shl    $0x6,%r11
   1f0d4:	vpmulld -0x1d07d(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   1f0dd:	vpsrld $0x1a,%ymm0,%ymm0
   1f0e2:	vpmovzxdq %ymm0,%zmm0
   1f0e8:	vmovdqa64 (%rbx,%r11,1),%zmm1
   1f0ef:	vpshufbitqmb %zmm0,%zmm1,%k0
   1f0f5:	kmovq  %k0,%rsi
   1f0fa:	and    %r8,%rsi
   1f0fd:	xor    %r11d,%r11d
   1f100:	cmp    %r8,%rsi
   1f103:	sete   %r11b
   1f107:	mov    %r11d,(%rcx,%r10,4)
   1f10b:	cmp    %rax,%r9
   1f10e:	jae    1ee40 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1f114:	vmovdqa -0x1d0bc(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   1f11c:	nopl   0x0(%rax)
   1f120:	mov    (%rdx,%r9,8),%rsi
   1f124:	mov    %rsi,%r10
   1f127:	shr    $0x20,%r10
   1f12b:	and    0x18(%rdi),%r10d
   1f12f:	vpbroadcastd %esi,%ymm1
   1f135:	mov    (%rdi),%rsi
   1f138:	shl    $0x6,%r10
   1f13c:	vpmulld %ymm0,%ymm1,%ymm1
   1f141:	vpsrld $0x1a,%ymm1,%ymm1
   1f146:	vpmovzxdq %ymm1,%zmm1
   1f14c:	vmovaps (%rsi,%r10,1),%zmm2
   1f153:	vpshufbitqmb %zmm1,%zmm2,%k0
   1f159:	kmovq  %k0,%rsi
   1f15e:	and    %r8,%rsi
   1f161:	xor    %r10d,%r10d
   1f164:	cmp    %r8,%rsi
   1f167:	sete   %r10b
   1f16b:	mov    %r10d,(%rcx,%r9,4)
   1f16f:	inc    %r9
   1f172:	cmp    %r9,%rax
   1f175:	jne    1f120 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   1f177:	jmp    1ee40 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1f17c:	int3
   1f17d:	int3
   1f17e:	int3
   1f17f:	int3

