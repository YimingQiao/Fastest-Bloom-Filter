00000000000b7990 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b7990:	test   %rsi,%rsi
   b7993:	je     b7b11 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b7999:	push   %rbp
   b799a:	push   %r15
   b799c:	push   %r14
   b799e:	push   %rbx
   b799f:	mov    %rdx,%rax
   b79a2:	xor    %r8d,%r8d
   b79a5:	movabs $0xdeadbeefdeadbeef,%r9
   b79af:	movabs $0xe6adbeefdeadbeef,%r10
   b79b9:	mov    $0xffffffff,%r11d
   b79bf:	vpbroadcastd -0xb4724(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   b79c8:	vpbroadcastd -0xb4729(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   b79d1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   b79e0:	mov    (%rax,%r8,8),%rdx
   b79e4:	add    %r9,%rdx
   b79e7:	rorx   $0x31,%rdx,%rbx
   b79ed:	xor    %r10,%rdx
   b79f0:	add    %rbx,%rdx
   b79f3:	rorx   $0xc,%rdx,%r14
   b79f9:	add    %r14,%rdx
   b79fc:	rorx   $0x26,%rdx,%r15
   b7a02:	add    %r15,%rdx
   b7a05:	xor    %rdx,%rbx
   b7a08:	rorx   $0xd,%rdx,%rdx
   b7a0e:	add    %rdx,%rbx
   b7a11:	xor    %rbx,%r14
   b7a14:	rorx   $0x24,%rbx,%rbx
   b7a1a:	add    %rbx,%r14
   b7a1d:	xor    %r14,%r15
   b7a20:	rorx   $0x37,%r14,%r14
   b7a26:	add    %r14,%r15
   b7a29:	xor    %r15,%rdx
   b7a2c:	rorx   $0x11,%r15,%r15
   b7a32:	add    %r15,%rdx
   b7a35:	xor    %rdx,%rbx
   b7a38:	rorx   $0xa,%rdx,%rdx
   b7a3e:	add    %rdx,%rbx
   b7a41:	xor    %rbx,%r14
   b7a44:	rorx   $0x20,%rbx,%rbx
   b7a4a:	add    %r14,%rbx
   b7a4d:	xor    %rbx,%r15
   b7a50:	rorx   $0x27,%rbx,%rbx
   b7a56:	add    %r15,%rbx
   b7a59:	xor    %rbx,%rdx
   b7a5c:	rorx   $0x1,%rbx,%rbx
   b7a62:	add    %rbx,%rdx
   b7a65:	rorx   $0x18,%ebx,%ebp
   b7a6b:	vmovq  %rbx,%xmm2
   b7a70:	shr    $0x20,%rbx
   b7a74:	rorx   $0x1c,%edx,%r14d
   b7a7a:	vmovq  %rdx,%xmm3
   b7a7f:	shr    $0x20,%rdx
   b7a83:	rorx   $0x1a,%ebx,%ebx
   b7a89:	xor    %ebp,%ebx
   b7a8b:	xor    %ebx,%r14d
   b7a8e:	rorx   $0x1e,%edx,%edx
   b7a94:	xor    %r14d,%edx
   b7a97:	mov    0x8(%rdi),%ebx
   b7a9a:	imul   0x10(%rdi),%rdx
   b7a9f:	mulx   %rbx,%rdx,%rdx
   b7aa4:	movzbl (%rdi),%ebx
   b7aa7:	shlx   %rbx,%rdx,%rdx
   b7aac:	add    0x20(%rdi),%rdx
   b7ab0:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   b7ab4:	add    $0x3,%bl
   b7ab7:	shlx   %ebx,%r11d,%ebx
   b7abc:	vpbroadcastd %ebx,%ymm3
   b7ac2:	vpsrld $0x10,%xmm2,%xmm4
   b7ac7:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   b7acd:	vpandn %ymm2,%ymm3,%ymm2
   b7ad1:	vpsrld $0x5,%ymm2,%ymm3
   b7ad6:	vpcmpeqd %ymm4,%ymm4,%ymm4
   b7ada:	vpxor  %xmm5,%xmm5,%xmm5
   b7ade:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   b7ae4:	vpand  %ymm0,%ymm2,%ymm2
   b7ae8:	vpsllvd %ymm2,%ymm1,%ymm2
   b7aed:	vpandn %ymm2,%ymm5,%ymm3
   b7af1:	xor    %edx,%edx
   b7af3:	vptest %ymm2,%ymm3
   b7af8:	sete   %dl
   b7afb:	mov    %edx,(%rcx,%r8,4)
   b7aff:	inc    %r8
   b7b02:	cmp    %r8,%rsi
   b7b05:	jne    b79e0 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b7b0b:	pop    %rbx
   b7b0c:	pop    %r14
   b7b0e:	pop    %r15
   b7b10:	pop    %rbp
   b7b11:	vzeroupper
   b7b14:	ret
   b7b15:	int3
   b7b16:	int3
   b7b17:	int3
   b7b18:	int3
   b7b19:	int3
   b7b1a:	int3
   b7b1b:	int3
   b7b1c:	int3
   b7b1d:	int3
   b7b1e:	int3
   b7b1f:	int3

