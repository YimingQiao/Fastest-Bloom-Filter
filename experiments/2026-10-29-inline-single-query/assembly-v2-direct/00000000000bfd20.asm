00000000000bfd20 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bfd20:	test   %rsi,%rsi
   bfd23:	je     bfea1 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   bfd29:	push   %rbp
   bfd2a:	push   %r15
   bfd2c:	push   %r14
   bfd2e:	push   %rbx
   bfd2f:	mov    %rdx,%rax
   bfd32:	xor    %r8d,%r8d
   bfd35:	movabs $0xdeadbeefdeadbeef,%r9
   bfd3f:	movabs $0xe6adbeefdeadbeef,%r10
   bfd49:	mov    $0xffffffff,%r11d
   bfd4f:	vbroadcasti128 -0xbb168(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   bfd58:	vpbroadcastd -0xbcabd(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   bfd61:	vpbroadcastd -0xbcac2(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   bfd6a:	nopw   0x0(%rax,%rax,1)
   bfd70:	mov    (%rax,%r8,8),%rdx
   bfd74:	add    %r9,%rdx
   bfd77:	rorx   $0x31,%rdx,%rbx
   bfd7d:	xor    %r10,%rdx
   bfd80:	add    %rbx,%rdx
   bfd83:	rorx   $0xc,%rdx,%r14
   bfd89:	add    %r14,%rdx
   bfd8c:	rorx   $0x26,%rdx,%r15
   bfd92:	add    %r15,%rdx
   bfd95:	xor    %rdx,%rbx
   bfd98:	rorx   $0xd,%rdx,%rdx
   bfd9e:	add    %rdx,%rbx
   bfda1:	xor    %rbx,%r14
   bfda4:	rorx   $0x24,%rbx,%rbx
   bfdaa:	add    %rbx,%r14
   bfdad:	xor    %r14,%r15
   bfdb0:	rorx   $0x37,%r14,%r14
   bfdb6:	add    %r14,%r15
   bfdb9:	xor    %r15,%rdx
   bfdbc:	rorx   $0x11,%r15,%r15
   bfdc2:	add    %r15,%rdx
   bfdc5:	xor    %rdx,%rbx
   bfdc8:	rorx   $0xa,%rdx,%rdx
   bfdce:	add    %rdx,%rbx
   bfdd1:	xor    %rbx,%r14
   bfdd4:	rorx   $0x20,%rbx,%rbx
   bfdda:	add    %r14,%rbx
   bfddd:	xor    %rbx,%r15
   bfde0:	rorx   $0x27,%rbx,%rbx
   bfde6:	add    %r15,%rbx
   bfde9:	xor    %rbx,%rdx
   bfdec:	rorx   $0x1,%rbx,%rbx
   bfdf2:	add    %rbx,%rdx
   bfdf5:	rorx   $0x18,%ebx,%ebp
   bfdfb:	vmovq  %rbx,%xmm3
   bfe00:	shr    $0x20,%rbx
   bfe04:	rorx   $0x1c,%edx,%r14d
   bfe0a:	vmovq  %rdx,%xmm4
   bfe0f:	shr    $0x20,%rdx
   bfe13:	rorx   $0x1a,%ebx,%ebx
   bfe19:	xor    %ebp,%ebx
   bfe1b:	xor    %ebx,%r14d
   bfe1e:	rorx   $0x1e,%edx,%edx
   bfe24:	xor    %r14d,%edx
   bfe27:	mov    0x8(%rdi),%ebx
   bfe2a:	imul   0x10(%rdi),%rdx
   bfe2f:	mulx   %rbx,%rdx,%rdx
   bfe34:	movzbl (%rdi),%ebx
   bfe37:	shlx   %rbx,%rdx,%rdx
   bfe3c:	add    0x20(%rdi),%rdx
   bfe40:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   bfe44:	add    $0x3,%bl
   bfe47:	shlx   %ebx,%r11d,%ebx
   bfe4c:	vpbroadcastd %ebx,%ymm4
   bfe52:	vpsrld $0x10,%xmm3,%xmm5
   bfe57:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   bfe5d:	vpandn %ymm3,%ymm4,%ymm3
   bfe61:	vpsrld $0x5,%ymm3,%ymm4
   bfe66:	vmovdqa %ymm0,%ymm5
   bfe6a:	vpcmpeqd %ymm6,%ymm6,%ymm6
   bfe6e:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   bfe74:	vpand  %ymm1,%ymm3,%ymm3
   bfe78:	vpsllvd %ymm3,%ymm2,%ymm3
   bfe7d:	vpandn %ymm3,%ymm6,%ymm4
   bfe81:	xor    %edx,%edx
   bfe83:	vptest %ymm3,%ymm4
   bfe88:	sete   %dl
   bfe8b:	mov    %edx,(%rcx,%r8,4)
   bfe8f:	inc    %r8
   bfe92:	cmp    %r8,%rsi
   bfe95:	jne    bfd70 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bfe9b:	pop    %rbx
   bfe9c:	pop    %r14
   bfe9e:	pop    %r15
   bfea0:	pop    %rbp
   bfea1:	vzeroupper
   bfea4:	ret
   bfea5:	int3
   bfea6:	int3
   bfea7:	int3
   bfea8:	int3
   bfea9:	int3
   bfeaa:	int3
   bfeab:	int3
   bfeac:	int3
   bfead:	int3
   bfeae:	int3
   bfeaf:	int3

