00000000000bfda0 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bfda0:	test   %rsi,%rsi
   bfda3:	je     bff21 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   bfda9:	push   %rbp
   bfdaa:	push   %r15
   bfdac:	push   %r14
   bfdae:	push   %rbx
   bfdaf:	mov    %rdx,%rax
   bfdb2:	xor    %r8d,%r8d
   bfdb5:	movabs $0xdeadbeefdeadbeef,%r9
   bfdbf:	movabs $0xe6adbeefdeadbeef,%r10
   bfdc9:	mov    $0xffffffff,%r11d
   bfdcf:	vbroadcasti128 -0xbb1e8(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   bfdd8:	vpbroadcastd -0xbcb3d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   bfde1:	vpbroadcastd -0xbcb42(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   bfdea:	nopw   0x0(%rax,%rax,1)
   bfdf0:	mov    (%rax,%r8,8),%rdx
   bfdf4:	add    %r9,%rdx
   bfdf7:	rorx   $0x31,%rdx,%rbx
   bfdfd:	xor    %r10,%rdx
   bfe00:	add    %rbx,%rdx
   bfe03:	rorx   $0xc,%rdx,%r14
   bfe09:	add    %r14,%rdx
   bfe0c:	rorx   $0x26,%rdx,%r15
   bfe12:	add    %r15,%rdx
   bfe15:	xor    %rdx,%rbx
   bfe18:	rorx   $0xd,%rdx,%rdx
   bfe1e:	add    %rdx,%rbx
   bfe21:	xor    %rbx,%r14
   bfe24:	rorx   $0x24,%rbx,%rbx
   bfe2a:	add    %rbx,%r14
   bfe2d:	xor    %r14,%r15
   bfe30:	rorx   $0x37,%r14,%r14
   bfe36:	add    %r14,%r15
   bfe39:	xor    %r15,%rdx
   bfe3c:	rorx   $0x11,%r15,%r15
   bfe42:	add    %r15,%rdx
   bfe45:	xor    %rdx,%rbx
   bfe48:	rorx   $0xa,%rdx,%rdx
   bfe4e:	add    %rdx,%rbx
   bfe51:	xor    %rbx,%r14
   bfe54:	rorx   $0x20,%rbx,%rbx
   bfe5a:	add    %r14,%rbx
   bfe5d:	xor    %rbx,%r15
   bfe60:	rorx   $0x27,%rbx,%rbx
   bfe66:	add    %r15,%rbx
   bfe69:	xor    %rbx,%rdx
   bfe6c:	rorx   $0x1,%rbx,%rbx
   bfe72:	add    %rbx,%rdx
   bfe75:	rorx   $0x18,%ebx,%ebp
   bfe7b:	vmovq  %rbx,%xmm3
   bfe80:	shr    $0x20,%rbx
   bfe84:	rorx   $0x1c,%edx,%r14d
   bfe8a:	vmovq  %rdx,%xmm4
   bfe8f:	shr    $0x20,%rdx
   bfe93:	rorx   $0x1a,%ebx,%ebx
   bfe99:	xor    %ebp,%ebx
   bfe9b:	xor    %ebx,%r14d
   bfe9e:	rorx   $0x1e,%edx,%edx
   bfea4:	xor    %r14d,%edx
   bfea7:	mov    0x8(%rdi),%ebx
   bfeaa:	imul   0x10(%rdi),%rdx
   bfeaf:	mulx   %rbx,%rdx,%rdx
   bfeb4:	movzbl (%rdi),%ebx
   bfeb7:	shlx   %rbx,%rdx,%rdx
   bfebc:	add    0x20(%rdi),%rdx
   bfec0:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   bfec4:	add    $0x3,%bl
   bfec7:	shlx   %ebx,%r11d,%ebx
   bfecc:	vpbroadcastd %ebx,%ymm4
   bfed2:	vpsrld $0x10,%xmm3,%xmm5
   bfed7:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   bfedd:	vpandn %ymm3,%ymm4,%ymm3
   bfee1:	vpsrld $0x5,%ymm3,%ymm4
   bfee6:	vmovdqa %ymm0,%ymm5
   bfeea:	vpcmpeqd %ymm6,%ymm6,%ymm6
   bfeee:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   bfef4:	vpand  %ymm1,%ymm3,%ymm3
   bfef8:	vpsllvd %ymm3,%ymm2,%ymm3
   bfefd:	vpandn %ymm3,%ymm6,%ymm4
   bff01:	xor    %edx,%edx
   bff03:	vptest %ymm3,%ymm4
   bff08:	sete   %dl
   bff0b:	mov    %edx,(%rcx,%r8,4)
   bff0f:	inc    %r8
   bff12:	cmp    %r8,%rsi
   bff15:	jne    bfdf0 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bff1b:	pop    %rbx
   bff1c:	pop    %r14
   bff1e:	pop    %r15
   bff20:	pop    %rbp
   bff21:	vzeroupper
   bff24:	ret
   bff25:	int3
   bff26:	int3
   bff27:	int3
   bff28:	int3
   bff29:	int3
   bff2a:	int3
   bff2b:	int3
   bff2c:	int3
   bff2d:	int3
   bff2e:	int3
   bff2f:	int3

