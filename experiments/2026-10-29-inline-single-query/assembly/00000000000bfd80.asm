00000000000bfd80 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bfd80:	48 85 f6             	test   %rsi,%rsi
   bfd83:	0f 84 78 01 00 00    	je     bff01 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   bfd89:	55                   	push   %rbp
   bfd8a:	41 57                	push   %r15
   bfd8c:	41 56                	push   %r14
   bfd8e:	53                   	push   %rbx
   bfd8f:	48 89 d0             	mov    %rdx,%rax
   bfd92:	45 31 c0             	xor    %r8d,%r8d
   bfd95:	49 b9 ef be ad de ef 	movabs $0xdeadbeefdeadbeef,%r9
   bfd9c:	be ad de
   bfd9f:	49 ba ef be ad de ef 	movabs $0xe6adbeefdeadbeef,%r10
   bfda6:	be ad e6
   bfda9:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
   bfdaf:	c4 e2 7d 5a 05 38 4e 	vbroadcasti128 -0xbb1c8(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   bfdb6:	f4 ff
   bfdb8:	c4 e2 7d 58 0d e3 34 	vpbroadcastd -0xbcb1d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   bfdbf:	f4 ff
   bfdc1:	c4 e2 7d 58 15 de 34 	vpbroadcastd -0xbcb22(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   bfdc8:	f4 ff
   bfdca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   bfdd0:	4a 8b 14 c0          	mov    (%rax,%r8,8),%rdx
   bfdd4:	4c 01 ca             	add    %r9,%rdx
   bfdd7:	c4 e3 fb f0 da 31    	rorx   $0x31,%rdx,%rbx
   bfddd:	4c 31 d2             	xor    %r10,%rdx
   bfde0:	48 01 da             	add    %rbx,%rdx
   bfde3:	c4 63 fb f0 f2 0c    	rorx   $0xc,%rdx,%r14
   bfde9:	4c 01 f2             	add    %r14,%rdx
   bfdec:	c4 63 fb f0 fa 26    	rorx   $0x26,%rdx,%r15
   bfdf2:	4c 01 fa             	add    %r15,%rdx
   bfdf5:	48 31 d3             	xor    %rdx,%rbx
   bfdf8:	c4 e3 fb f0 d2 0d    	rorx   $0xd,%rdx,%rdx
   bfdfe:	48 01 d3             	add    %rdx,%rbx
   bfe01:	49 31 de             	xor    %rbx,%r14
   bfe04:	c4 e3 fb f0 db 24    	rorx   $0x24,%rbx,%rbx
   bfe0a:	49 01 de             	add    %rbx,%r14
   bfe0d:	4d 31 f7             	xor    %r14,%r15
   bfe10:	c4 43 fb f0 f6 37    	rorx   $0x37,%r14,%r14
   bfe16:	4d 01 f7             	add    %r14,%r15
   bfe19:	4c 31 fa             	xor    %r15,%rdx
   bfe1c:	c4 43 fb f0 ff 11    	rorx   $0x11,%r15,%r15
   bfe22:	4c 01 fa             	add    %r15,%rdx
   bfe25:	48 31 d3             	xor    %rdx,%rbx
   bfe28:	c4 e3 fb f0 d2 0a    	rorx   $0xa,%rdx,%rdx
   bfe2e:	48 01 d3             	add    %rdx,%rbx
   bfe31:	49 31 de             	xor    %rbx,%r14
   bfe34:	c4 e3 fb f0 db 20    	rorx   $0x20,%rbx,%rbx
   bfe3a:	4c 01 f3             	add    %r14,%rbx
   bfe3d:	49 31 df             	xor    %rbx,%r15
   bfe40:	c4 e3 fb f0 db 27    	rorx   $0x27,%rbx,%rbx
   bfe46:	4c 01 fb             	add    %r15,%rbx
   bfe49:	48 31 da             	xor    %rbx,%rdx
   bfe4c:	c4 e3 fb f0 db 01    	rorx   $0x1,%rbx,%rbx
   bfe52:	48 01 da             	add    %rbx,%rdx
   bfe55:	c4 e3 7b f0 eb 18    	rorx   $0x18,%ebx,%ebp
   bfe5b:	c4 e1 f9 6e db       	vmovq  %rbx,%xmm3
   bfe60:	48 c1 eb 20          	shr    $0x20,%rbx
   bfe64:	c4 63 7b f0 f2 1c    	rorx   $0x1c,%edx,%r14d
   bfe6a:	c4 e1 f9 6e e2       	vmovq  %rdx,%xmm4
   bfe6f:	48 c1 ea 20          	shr    $0x20,%rdx
   bfe73:	c4 e3 7b f0 db 1a    	rorx   $0x1a,%ebx,%ebx
   bfe79:	31 eb                	xor    %ebp,%ebx
   bfe7b:	41 31 de             	xor    %ebx,%r14d
   bfe7e:	c4 e3 7b f0 d2 1e    	rorx   $0x1e,%edx,%edx
   bfe84:	44 31 f2             	xor    %r14d,%edx
   bfe87:	8b 5f 08             	mov    0x8(%rdi),%ebx
   bfe8a:	48 0f af 57 10       	imul   0x10(%rdi),%rdx
   bfe8f:	c4 e2 eb f6 d3       	mulx   %rbx,%rdx,%rdx
   bfe94:	0f b6 1f             	movzbl (%rdi),%ebx
   bfe97:	c4 e2 e1 f7 d2       	shlx   %rbx,%rdx,%rdx
   bfe9c:	48 03 57 20          	add    0x20(%rdi),%rdx
   bfea0:	c5 e1 6c dc          	vpunpcklqdq %xmm4,%xmm3,%xmm3
   bfea4:	80 c3 03             	add    $0x3,%bl
   bfea7:	c4 c2 61 f7 db       	shlx   %ebx,%r11d,%ebx
   bfeac:	62 f2 7d 28 7c e3    	vpbroadcastd %ebx,%ymm4
   bfeb2:	c5 d1 72 d3 10       	vpsrld $0x10,%xmm3,%xmm5
   bfeb7:	c4 e3 65 38 dd 01    	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   bfebd:	c5 dd df db          	vpandn %ymm3,%ymm4,%ymm3
   bfec1:	c5 dd 72 d3 05       	vpsrld $0x5,%ymm3,%ymm4
   bfec6:	c5 fd 6f e8          	vmovdqa %ymm0,%ymm5
   bfeca:	c5 cd 76 f6          	vpcmpeqd %ymm6,%ymm6,%ymm6
   bfece:	c4 e2 55 90 34 a2    	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   bfed4:	c5 e5 db d9          	vpand  %ymm1,%ymm3,%ymm3
   bfed8:	c4 e2 6d 47 db       	vpsllvd %ymm3,%ymm2,%ymm3
   bfedd:	c5 cd df e3          	vpandn %ymm3,%ymm6,%ymm4
   bfee1:	31 d2                	xor    %edx,%edx
   bfee3:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   bfee8:	0f 94 c2             	sete   %dl
   bfeeb:	42 89 14 81          	mov    %edx,(%rcx,%r8,4)
   bfeef:	49 ff c0             	inc    %r8
   bfef2:	4c 39 c6             	cmp    %r8,%rsi
   bfef5:	0f 85 d5 fe ff ff    	jne    bfdd0 <void inline_single_kernel<false, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bfefb:	5b                   	pop    %rbx
   bfefc:	41 5e                	pop    %r14
   bfefe:	41 5f                	pop    %r15
   bff00:	5d                   	pop    %rbp
   bff01:	c5 f8 77             	vzeroupper
   bff04:	c3                   	ret
   bff05:	cc                   	int3
   bff06:	cc                   	int3
   bff07:	cc                   	int3
   bff08:	cc                   	int3
   bff09:	cc                   	int3
   bff0a:	cc                   	int3
   bff0b:	cc                   	int3
   bff0c:	cc                   	int3
   bff0d:	cc                   	int3
   bff0e:	cc                   	int3
   bff0f:	cc                   	int3
