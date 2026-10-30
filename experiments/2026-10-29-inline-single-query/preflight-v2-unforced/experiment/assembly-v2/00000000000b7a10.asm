00000000000b7a10 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b7a10:	test   %rsi,%rsi
   b7a13:	je     b7b91 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b7a19:	push   %rbp
   b7a1a:	push   %r15
   b7a1c:	push   %r14
   b7a1e:	push   %rbx
   b7a1f:	mov    %rdx,%rax
   b7a22:	xor    %r8d,%r8d
   b7a25:	movabs $0xdeadbeefdeadbeef,%r9
   b7a2f:	movabs $0xe6adbeefdeadbeef,%r10
   b7a39:	mov    $0xffffffff,%r11d
   b7a3f:	vpbroadcastd -0xb47a4(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   b7a48:	vpbroadcastd -0xb47a9(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   b7a51:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   b7a60:	mov    (%rax,%r8,8),%rdx
   b7a64:	add    %r9,%rdx
   b7a67:	rorx   $0x31,%rdx,%rbx
   b7a6d:	xor    %r10,%rdx
   b7a70:	add    %rbx,%rdx
   b7a73:	rorx   $0xc,%rdx,%r14
   b7a79:	add    %r14,%rdx
   b7a7c:	rorx   $0x26,%rdx,%r15
   b7a82:	add    %r15,%rdx
   b7a85:	xor    %rdx,%rbx
   b7a88:	rorx   $0xd,%rdx,%rdx
   b7a8e:	add    %rdx,%rbx
   b7a91:	xor    %rbx,%r14
   b7a94:	rorx   $0x24,%rbx,%rbx
   b7a9a:	add    %rbx,%r14
   b7a9d:	xor    %r14,%r15
   b7aa0:	rorx   $0x37,%r14,%r14
   b7aa6:	add    %r14,%r15
   b7aa9:	xor    %r15,%rdx
   b7aac:	rorx   $0x11,%r15,%r15
   b7ab2:	add    %r15,%rdx
   b7ab5:	xor    %rdx,%rbx
   b7ab8:	rorx   $0xa,%rdx,%rdx
   b7abe:	add    %rdx,%rbx
   b7ac1:	xor    %rbx,%r14
   b7ac4:	rorx   $0x20,%rbx,%rbx
   b7aca:	add    %r14,%rbx
   b7acd:	xor    %rbx,%r15
   b7ad0:	rorx   $0x27,%rbx,%rbx
   b7ad6:	add    %r15,%rbx
   b7ad9:	xor    %rbx,%rdx
   b7adc:	rorx   $0x1,%rbx,%rbx
   b7ae2:	add    %rbx,%rdx
   b7ae5:	rorx   $0x18,%ebx,%ebp
   b7aeb:	vmovq  %rbx,%xmm2
   b7af0:	shr    $0x20,%rbx
   b7af4:	rorx   $0x1c,%edx,%r14d
   b7afa:	vmovq  %rdx,%xmm3
   b7aff:	shr    $0x20,%rdx
   b7b03:	rorx   $0x1a,%ebx,%ebx
   b7b09:	xor    %ebp,%ebx
   b7b0b:	xor    %ebx,%r14d
   b7b0e:	rorx   $0x1e,%edx,%edx
   b7b14:	xor    %r14d,%edx
   b7b17:	mov    0x8(%rdi),%ebx
   b7b1a:	imul   0x10(%rdi),%rdx
   b7b1f:	mulx   %rbx,%rdx,%rdx
   b7b24:	movzbl (%rdi),%ebx
   b7b27:	shlx   %rbx,%rdx,%rdx
   b7b2c:	add    0x20(%rdi),%rdx
   b7b30:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   b7b34:	add    $0x3,%bl
   b7b37:	shlx   %ebx,%r11d,%ebx
   b7b3c:	vpbroadcastd %ebx,%ymm3
   b7b42:	vpsrld $0x10,%xmm2,%xmm4
   b7b47:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   b7b4d:	vpandn %ymm2,%ymm3,%ymm2
   b7b51:	vpsrld $0x5,%ymm2,%ymm3
   b7b56:	vpcmpeqd %ymm4,%ymm4,%ymm4
   b7b5a:	vpxor  %xmm5,%xmm5,%xmm5
   b7b5e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   b7b64:	vpand  %ymm0,%ymm2,%ymm2
   b7b68:	vpsllvd %ymm2,%ymm1,%ymm2
   b7b6d:	vpandn %ymm2,%ymm5,%ymm3
   b7b71:	xor    %edx,%edx
   b7b73:	vptest %ymm2,%ymm3
   b7b78:	sete   %dl
   b7b7b:	mov    %edx,(%rcx,%r8,4)
   b7b7f:	inc    %r8
   b7b82:	cmp    %r8,%rsi
   b7b85:	jne    b7a60 <void inline_single_kernel<true, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b7b8b:	pop    %rbx
   b7b8c:	pop    %r14
   b7b8e:	pop    %r15
   b7b90:	pop    %rbp
   b7b91:	vzeroupper
   b7b94:	ret
   b7b95:	int3
   b7b96:	int3
   b7b97:	int3
   b7b98:	int3
   b7b99:	int3
   b7b9a:	int3
   b7b9b:	int3
   b7b9c:	int3
   b7b9d:	int3
   b7b9e:	int3
   b7b9f:	int3

