000000000000f820 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const>:
    f820:	push   %rbp
    f821:	push   %r15
    f823:	push   %r14
    f825:	push   %r12
    f827:	push   %rbx
    f828:	mov    %rcx,%r8
    f82b:	mov    %esi,%eax
    f82d:	cmp    $0x3,%esi
    f830:	ja     f97e <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x15e>
    f836:	test   %eax,%eax
    f838:	je     fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    f83e:	mov    (%rdx),%rsi
    f841:	mov    %rsi,%r9
    f844:	shr    $0x20,%r9
    f848:	and    0x8(%rdi),%r9d
    f84c:	mov    %esi,%ecx
    f84e:	and    $0x1f,%ecx
    f851:	mov    (%rdi),%r11
    f854:	mov    0x10(%rdi),%r10
    f858:	mov    (%r11,%rcx,4),%ebx
    f85c:	mov    %esi,%ecx
    f85e:	shr    $0x5,%ecx
    f861:	rol    %cl,%ebx
    f863:	mov    %esi,%ecx
    f865:	shr    $0x8,%ecx
    f868:	and    $0x7c,%ecx
    f86b:	mov    (%r11,%rcx,1),%r11d
    f86f:	mov    %esi,%ecx
    f871:	shr    $0xf,%ecx
    f874:	rol    %cl,%r11d
    f877:	mov    (%r10,%r9,4),%ecx
    f87b:	andn   %ebx,%ecx,%ecx
    f880:	shr    $0x14,%esi
    f883:	and    $0x7,%esi
    f886:	or     $0x8,%esi
    f889:	xor    %r9d,%esi
    f88c:	mov    (%r10,%rsi,4),%esi
    f890:	andn   %r11d,%esi,%esi
    f895:	xor    %r9d,%r9d
    f898:	or     %ecx,%esi
    f89a:	sete   %r9b
    f89e:	mov    %r9d,(%r8)
    f8a1:	cmp    $0x1,%eax
    f8a4:	je     fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    f8aa:	mov    0x8(%rdx),%rsi
    f8ae:	mov    %rsi,%r9
    f8b1:	shr    $0x20,%r9
    f8b5:	and    0x8(%rdi),%r9d
    f8b9:	mov    %esi,%ecx
    f8bb:	and    $0x1f,%ecx
    f8be:	mov    (%rdi),%r11
    f8c1:	mov    0x10(%rdi),%r10
    f8c5:	mov    (%r11,%rcx,4),%ebx
    f8c9:	mov    %esi,%ecx
    f8cb:	shr    $0x5,%ecx
    f8ce:	rol    %cl,%ebx
    f8d0:	mov    %esi,%ecx
    f8d2:	shr    $0x8,%ecx
    f8d5:	and    $0x7c,%ecx
    f8d8:	mov    (%r11,%rcx,1),%r11d
    f8dc:	mov    %esi,%ecx
    f8de:	shr    $0xf,%ecx
    f8e1:	rol    %cl,%r11d
    f8e4:	mov    (%r10,%r9,4),%ecx
    f8e8:	andn   %ebx,%ecx,%ecx
    f8ed:	shr    $0x14,%esi
    f8f0:	and    $0x7,%esi
    f8f3:	or     $0x8,%esi
    f8f6:	xor    %r9d,%esi
    f8f9:	mov    (%r10,%rsi,4),%esi
    f8fd:	andn   %r11d,%esi,%esi
    f902:	xor    %r9d,%r9d
    f905:	or     %ecx,%esi
    f907:	sete   %r9b
    f90b:	mov    %r9d,0x4(%r8)
    f90f:	cmp    $0x2,%eax
    f912:	je     fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    f918:	mov    0x10(%rdx),%rdx
    f91c:	mov    %rdx,%rsi
    f91f:	shr    $0x20,%rsi
    f923:	and    0x8(%rdi),%esi
    f926:	mov    %edx,%ecx
    f928:	and    $0x1f,%ecx
    f92b:	mov    (%rdi),%r9
    f92e:	mov    0x10(%rdi),%rdi
    f932:	mov    (%r9,%rcx,4),%r10d
    f936:	mov    %edx,%ecx
    f938:	shr    $0x5,%ecx
    f93b:	rol    %cl,%r10d
    f93e:	mov    %edx,%ecx
    f940:	shr    $0x8,%ecx
    f943:	and    $0x7c,%ecx
    f946:	mov    (%r9,%rcx,1),%r9d
    f94a:	mov    %edx,%ecx
    f94c:	shr    $0xf,%ecx
    f94f:	rol    %cl,%r9d
    f952:	mov    (%rdi,%rsi,4),%ecx
    f955:	andn   %r10d,%ecx,%ecx
    f95a:	shr    $0x14,%edx
    f95d:	and    $0x7,%edx
    f960:	or     $0x8,%edx
    f963:	xor    %esi,%edx
    f965:	mov    (%rdi,%rdx,4),%edx
    f968:	andn   %r9d,%edx,%edx
    f96d:	xor    %esi,%esi
    f96f:	or     %ecx,%edx
    f971:	sete   %sil
    f975:	mov    %esi,0x8(%r8)
    f979:	jmp    fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    f97e:	mov    0x10(%rdi),%rsi
    f982:	mov    0x18(%rdi),%rcx
    f986:	sub    %rsi,%rcx
    f989:	cmp    $0x200001,%rcx
    f990:	jb     f9a5 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x185>
    f992:	mov    %eax,%ebx
    f994:	mov    %eax,%esi
    f996:	mov    %r8,%rcx
    f999:	call   fee0 <void bloom_filters::FastPatternBF::LookupImpl<true>(unsigned int, unsigned long const*, unsigned int*) const>
    f99e:	mov    %ebx,%eax
    f9a0:	jmp    fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    f9a5:	mov    (%rdi),%r9
    f9a8:	vmovdqu64 (%r9),%zmm0
    f9ae:	vmovdqu64 0x40(%r9),%zmm1
    f9b5:	mov    %eax,%r10d
    f9b8:	cmp    $0x10,%eax
    f9bb:	jae    f9d2 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x1b2>
    f9bd:	xor    %r14d,%r14d
    f9c0:	lea    0x8(%r14),%r15
    f9c4:	cmp    %r10,%r15
    f9c7:	ja     fbc8 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3a8>
    f9cd:	jmp    fcc2 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x4a2>
    f9d2:	vpbroadcastd 0x8(%rdi),%zmm2
    f9d9:	mov    0x10(%rdi),%r11
    f9dd:	lea    -0x10(%r10),%rbx
    f9e1:	mov    %rbx,%r14
    f9e4:	shr    $0x4,%r14
    f9e8:	je     fbdc <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3bc>
    f9ee:	inc    %r14
    f9f1:	and    $0xfffffffffffffffe,%r14
    f9f5:	mov    $0x10,%ecx
    f9fa:	vmovdqa64 -0xd6c4(%rip),%zmm3        # 2340 <_IO_stdin_used+0x338>
    fa04:	vmovdqa64 -0xd68e(%rip),%zmm4        # 2380 <_IO_stdin_used+0x378>
    fa0e:	vpbroadcastd -0xda18(%rip),%zmm5        # 2000 <__abi_tag+0x1d3c>
    fa18:	vpbroadcastd -0xda1e(%rip),%zmm6        # 2004 <__abi_tag+0x1d40>
    fa22:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fa30:	vmovdqu64 -0x80(%rdx,%rcx,8),%zmm7
    fa38:	vmovdqu64 -0x40(%rdx,%rcx,8),%zmm8
    fa40:	vmovdqa64 %zmm7,%zmm9
    fa46:	vpermt2d %zmm8,%zmm3,%zmm9
    fa4c:	vpermt2d %zmm8,%zmm4,%zmm7
    fa52:	vpandd %zmm2,%zmm7,%zmm7
    fa58:	kxnorw %k0,%k0,%k1
    fa5c:	vpxor  %xmm8,%xmm8,%xmm8
    fa61:	vpgatherdd (%r11,%zmm7,4),%zmm8{%k1}
    fa68:	vpsrld $0x14,%zmm9,%zmm10
    fa6f:	vpandd %zmm5,%zmm10,%zmm10
    fa75:	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
    fa7c:	kxnorw %k0,%k0,%k1
    fa80:	vpxor  %xmm7,%xmm7,%xmm7
    fa84:	vpgatherdd (%r11,%zmm10,4),%zmm7{%k1}
    fa8b:	vmovdqa64 %zmm0,%zmm10
    fa91:	vpermt2d %zmm1,%zmm9,%zmm10
    fa97:	vpsrld $0x5,%zmm9,%zmm11
    fa9e:	vprolvd %zmm11,%zmm10,%zmm10
    faa4:	vpsrld $0xa,%zmm9,%zmm11
    faab:	vpermi2d %zmm1,%zmm0,%zmm11
    fab1:	vpsrld $0xf,%zmm9,%zmm9
    fab8:	vprolvd %zmm9,%zmm11,%zmm9
    fabe:	vpandd %zmm10,%zmm8,%zmm8
    fac4:	vpcmpeqd %zmm10,%zmm8,%k1
    faca:	vpandd %zmm9,%zmm7,%zmm7
    fad0:	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
    fad6:	vpmovm2d %k0,%zmm7
    fadc:	vpsrld $0x1f,%zmm7,%zmm7
    fae3:	vmovdqu64 %zmm7,-0x40(%r8,%rcx,4)
    faeb:	vmovdqu64 (%rdx,%rcx,8),%zmm7
    faf2:	vmovdqu64 0x40(%rdx,%rcx,8),%zmm8
    fafa:	vmovdqa64 %zmm7,%zmm9
    fb00:	vpermt2d %zmm8,%zmm3,%zmm9
    fb06:	vpermt2d %zmm8,%zmm4,%zmm7
    fb0c:	vpandd %zmm2,%zmm7,%zmm7
    fb12:	kxnorw %k0,%k0,%k1
    fb16:	vpxor  %xmm8,%xmm8,%xmm8
    fb1b:	vpgatherdd (%r11,%zmm7,4),%zmm8{%k1}
    fb22:	vpsrld $0x14,%zmm9,%zmm10
    fb29:	vpandd %zmm5,%zmm10,%zmm10
    fb2f:	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
    fb36:	kxnorw %k0,%k0,%k1
    fb3a:	vpxor  %xmm7,%xmm7,%xmm7
    fb3e:	vpgatherdd (%r11,%zmm10,4),%zmm7{%k1}
    fb45:	vmovdqa64 %zmm0,%zmm10
    fb4b:	vpermt2d %zmm1,%zmm9,%zmm10
    fb51:	vpsrld $0x5,%zmm9,%zmm11
    fb58:	vprolvd %zmm11,%zmm10,%zmm10
    fb5e:	vpsrld $0xa,%zmm9,%zmm11
    fb65:	vpermi2d %zmm1,%zmm0,%zmm11
    fb6b:	vpsrld $0xf,%zmm9,%zmm9
    fb72:	vprolvd %zmm9,%zmm11,%zmm9
    fb78:	vpandd %zmm10,%zmm8,%zmm8
    fb7e:	vpcmpeqd %zmm10,%zmm8,%k1
    fb84:	vpandd %zmm9,%zmm7,%zmm7
    fb8a:	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
    fb90:	vpmovm2d %k0,%zmm7
    fb96:	vpsrld $0x1f,%zmm7,%zmm7
    fb9d:	vmovdqu64 %zmm7,(%r8,%rcx,4)
    fba4:	add    $0x20,%rcx
    fba8:	add    $0xfffffffffffffffe,%r14
    fbac:	jne    fa30 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x210>
    fbb2:	lea    -0x10(%rcx),%r14
    fbb6:	test   $0x10,%bl
    fbb9:	je     fbe4 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3c4>
    fbbb:	lea    0x8(%r14),%r15
    fbbf:	cmp    %r10,%r15
    fbc2:	jbe    fcc2 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x4a2>
    fbc8:	mov    %r14,%r15
    fbcb:	mov    %r10,%rcx
    fbce:	sub    %r15,%rcx
    fbd1:	ja     fd57 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x537>
    fbd7:	jmp    fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    fbdc:	mov    $0x10,%ecx
    fbe1:	xor    %r14d,%r14d
    fbe4:	vmovdqu64 (%rdx,%r14,8),%zmm3
    fbeb:	vmovdqu64 0x40(%rdx,%r14,8),%zmm4
    fbf3:	vmovdqa64 -0xd8bd(%rip),%zmm5        # 2340 <_IO_stdin_used+0x338>
    fbfd:	vpermi2d %zmm4,%zmm3,%zmm5
    fc03:	vmovdqa64 -0xd88d(%rip),%zmm6        # 2380 <_IO_stdin_used+0x378>
    fc0d:	vpermi2d %zmm4,%zmm3,%zmm6
    fc13:	vpandd %zmm2,%zmm6,%zmm2
    fc19:	vpsrld $0x14,%zmm5,%zmm3
    fc20:	vmovdqa64 %zmm0,%zmm4
    fc26:	vpermt2d %zmm1,%zmm5,%zmm4
    fc2c:	vpsrld $0x5,%zmm5,%zmm6
    fc33:	vprolvd %zmm6,%zmm4,%zmm4
    fc39:	kxnorw %k0,%k0,%k1
    fc3d:	kxnorw %k0,%k0,%k2
    fc41:	vpxor  %xmm6,%xmm6,%xmm6
    fc45:	vpgatherdd (%r11,%zmm2,4),%zmm6{%k2}
    fc4c:	vpxor  %xmm7,%xmm7,%xmm7
    fc50:	vpandd -0xdc5a(%rip){1to16},%zmm3,%zmm3        # 2000 <__abi_tag+0x1d3c>
    fc5a:	vpternlogd $0x36,-0xdc61(%rip){1to16},%zmm2,%zmm3        # 2004 <__abi_tag+0x1d40>
    fc65:	vpgatherdd (%r11,%zmm3,4),%zmm7{%k1}
    fc6c:	vpsrld $0xa,%zmm5,%zmm2
    fc73:	vpermi2d %zmm1,%zmm0,%zmm2
    fc79:	vpsrld $0xf,%zmm5,%zmm3
    fc80:	vprolvd %zmm3,%zmm2,%zmm2
    fc86:	vpandd %zmm4,%zmm6,%zmm3
    fc8c:	vpcmpeqd %zmm4,%zmm3,%k1
    fc92:	vpandd %zmm2,%zmm7,%zmm3
    fc98:	vpcmpeqd %zmm2,%zmm3,%k0{%k1}
    fc9e:	vpmovm2d %k0,%zmm2
    fca4:	vpsrld $0x1f,%zmm2,%zmm2
    fcab:	vmovdqu64 %zmm2,(%r8,%r14,4)
    fcb2:	mov    %rcx,%r14
    fcb5:	lea    0x8(%r14),%r15
    fcb9:	cmp    %r10,%r15
    fcbc:	ja     fbc8 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3a8>
    fcc2:	vmovdqu64 (%rdx,%r14,8),%zmm2
    fcc9:	vpshufd $0xf5,%zmm2,%zmm3
    fcd0:	vpsllq $0xc,%zmm2,%zmm4
    fcd7:	vpshufd $0xa0,%zmm2,%zmm2
    fcde:	vpsrlvd -0xd928(%rip),%zmm2,%zmm5        # 23c0 <_IO_stdin_used+0x3b8>
    fce8:	vpermt2d %zmm1,%zmm5,%zmm0
    fcee:	vpsrlvd -0xd8f8(%rip),%zmm2,%zmm1        # 2400 <_IO_stdin_used+0x3f8>
    fcf8:	vprolvd %zmm1,%zmm0,%zmm0
    fcfe:	vpbroadcastq -0xdc48(%rip),%zmm1        # 20c0 <_IO_stdin_used+0xb8>
    fd08:	vpternlogq $0xf8,-0xdc8b(%rip){1to8},%zmm4,%zmm1        # 2088 <_IO_stdin_used+0x80>
    fd13:	mov    0x10(%rdi),%rcx
    fd17:	vpternlogd $0x78,0x8(%rdi){1to16},%zmm3,%zmm1
    fd1f:	kxnorw %k0,%k0,%k1
    fd23:	vpxor  %xmm2,%xmm2,%xmm2
    fd27:	vpgatherdd (%rcx,%zmm1,4),%zmm2{%k1}
    fd2e:	vpandd %zmm2,%zmm0,%zmm1
    fd34:	vpcmpeqq %zmm0,%zmm1,%k0
    fd3a:	vpmovm2d %k0,%zmm0
    fd40:	vpsrld $0x1f,%ymm0,%ymm0
    fd45:	vmovdqu %ymm0,(%r8,%r14,4)
    fd4b:	mov    %r10,%rcx
    fd4e:	sub    %r15,%rcx
    fd51:	jbe    fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    fd57:	mov    0x8(%rdi),%edi
    fd5a:	cmp    $0x4,%rcx
    fd5e:	jae    fd68 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x548>
    fd60:	mov    %r15,%r11
    fd63:	jmp    fe70 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x650>
    fd68:	mov    %ecx,%ebx
    fd6a:	and    $0xfffffffc,%ebx
    fd6d:	lea    (%r15,%rbx,1),%r11
    fd71:	vpbroadcastd %edi,%xmm0
    fd77:	lea    (%r8,%r15,4),%r14
    fd7b:	lea    (%rdx,%r15,8),%r15
    fd7f:	xor    %r12d,%r12d
    fd82:	vpbroadcastq -0xdcd3(%rip),%ymm1        # 20b8 <_IO_stdin_used+0xb0>
    fd8b:	vpbroadcastd -0xdd94(%rip),%xmm2        # 2000 <__abi_tag+0x1d3c>
    fd94:	vpbroadcastd -0xdd99(%rip),%xmm3        # 2004 <__abi_tag+0x1d40>
    fd9d:	nopl   (%rax)
    fda0:	vmovdqu (%r15,%r12,8),%ymm4
    fda6:	vpand  %ymm1,%ymm4,%ymm5
    fdaa:	kxnorw %k0,%k0,%k1
    fdae:	vpxor  %xmm6,%xmm6,%xmm6
    fdb2:	vpgatherqd (%r9,%ymm5,4),%xmm6{%k1}
    fdb9:	vpsrlq $0x20,%ymm4,%ymm5
    fdbe:	vpsrlq $0xa,%ymm4,%ymm7
    fdc3:	vpand  %ymm1,%ymm7,%ymm7
    fdc7:	kxnorw %k0,%k0,%k1
    fdcb:	vpxor  %xmm8,%xmm8,%xmm8
    fdd0:	vpgatherqd (%r9,%ymm7,4),%xmm8{%k1}
    fdd7:	vpmovqd %ymm5,%xmm5
    fddd:	vpand  %xmm5,%xmm0,%xmm5
    fde1:	vpmovzxdq %xmm5,%ymm7
    fde6:	kxnorw %k0,%k0,%k1
    fdea:	vpxor  %xmm9,%xmm9,%xmm9
    fdef:	vpgatherqd (%rsi,%ymm7,4),%xmm9{%k1}
    fdf6:	vpmovqd %ymm4,%xmm4
    fdfc:	vpsrld $0x5,%xmm4,%xmm7
    fe01:	vprolvd %xmm7,%xmm6,%xmm6
    fe07:	vpsrld $0x14,%xmm4,%xmm7
    fe0c:	vpand  %xmm2,%xmm7,%xmm7
    fe10:	vpternlogd $0x36,%xmm3,%xmm5,%xmm7
    fe17:	vpmovzxdq %xmm7,%ymm5
    fe1c:	kxnorw %k0,%k0,%k1
    fe20:	vpxor  %xmm7,%xmm7,%xmm7
    fe24:	vpgatherqd (%rsi,%ymm5,4),%xmm7{%k1}
    fe2b:	vpsrld $0xf,%xmm4,%xmm4
    fe30:	vprolvd %xmm4,%xmm8,%xmm4
    fe36:	vpand  %xmm6,%xmm9,%xmm5
    fe3a:	vpcmpeqd %xmm6,%xmm5,%k1
    fe40:	vpand  %xmm4,%xmm7,%xmm5
    fe44:	vpcmpeqd %xmm4,%xmm5,%k0{%k1}
    fe4a:	vpmovm2d %k0,%xmm4
    fe50:	vpsrld $0x1f,%xmm4,%xmm4
    fe55:	vmovdqu %xmm4,(%r14,%r12,4)
    fe5b:	add    $0x4,%r12
    fe5f:	cmp    %r12,%rbx
    fe62:	jne    fda0 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x580>
    fe68:	cmp    %ebx,%ecx
    fe6a:	je     fed3 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
    fe6c:	nopl   0x0(%rax)
    fe70:	mov    (%rdx,%r11,8),%rbx
    fe74:	mov    %rbx,%r14
    fe77:	shr    $0x20,%r14
    fe7b:	and    %edi,%r14d
    fe7e:	mov    %ebx,%ecx
    fe80:	and    $0x1f,%ecx
    fe83:	mov    (%r9,%rcx,4),%ebp
    fe87:	mov    %ebx,%ecx
    fe89:	shr    $0x5,%ecx
    fe8c:	rol    %cl,%ebp
    fe8e:	mov    %ebx,%ecx
    fe90:	shr    $0x8,%ecx
    fe93:	and    $0x7c,%ecx
    fe96:	mov    (%r9,%rcx,1),%r15d
    fe9a:	mov    %ebx,%ecx
    fe9c:	shr    $0xf,%ecx
    fe9f:	rol    %cl,%r15d
    fea2:	mov    (%rsi,%r14,4),%ecx
    fea6:	andn   %ebp,%ecx,%ecx
    feab:	shr    $0x14,%ebx
    feae:	and    $0x7,%ebx
    feb1:	or     $0x8,%ebx
    feb4:	xor    %r14d,%ebx
    feb7:	mov    (%rsi,%rbx,4),%ebx
    feba:	andn   %r15d,%ebx,%ebx
    febf:	xor    %ebp,%ebp
    fec1:	or     %ecx,%ebx
    fec3:	sete   %bpl
    fec7:	mov    %ebp,(%r8,%r11,4)
    fecb:	inc    %r11
    fece:	cmp    %r11,%r10
    fed1:	jne    fe70 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x650>
    fed3:	pop    %rbx
    fed4:	pop    %r12
    fed6:	pop    %r14
    fed8:	pop    %r15
    feda:	pop    %rbp
    fedb:	vzeroupper
    fede:	ret
    fedf:	int3

