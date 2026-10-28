0000000000059980 <compare_benchmark::lookup>:
   59980:	55                   	push   %rbp
   59981:	41 57                	push   %r15
   59983:	41 56                	push   %r14
   59985:	53                   	push   %rbx
   59986:	48 83 ec 48          	sub    $0x48,%rsp
   5998a:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5998f:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   59994:	4c 39 c2             	cmp    %r8,%rdx
   59997:	0f 85 c6 02 00 00    	jne    59c63 <compare_benchmark::lookup+0x2e3>
   5999d:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   599a1:	0f 84 d2 00 00 00    	je     59a79 <compare_benchmark::lookup+0xf9>
   599a7:	45 31 c0             	xor    %r8d,%r8d
   599aa:	48 89 d0             	mov    %rdx,%rax
   599ad:	48 83 e8 20          	sub    $0x20,%rax
   599b1:	4c 0f 43 c0          	cmovae %rax,%r8
   599b5:	0f 86 9a 00 00 00    	jbe    59a55 <compare_benchmark::lookup+0xd5>
   599bb:	44 8b 4f 18          	mov    0x18(%rdi),%r9d
   599bf:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   599c3:	b8 20 00 00 00       	mov    $0x20,%eax
   599c8:	c5 fd 6f 05 90 ed fa 	vmovdqa -0x51270(%rip),%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   599cf:	ff 
   599d0:	62 f2 fd 48 59 0d 46 	vpbroadcastq -0x513ba(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   599d7:	ec fa ff 
   599da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   599e0:	48 39 c2             	cmp    %rax,%rdx
   599e3:	0f 84 d3 02 00 00    	je     59cbc <compare_benchmark::lookup+0x33c>
   599e9:	4c 8b 9c c6 00 ff ff 	mov    -0x100(%rsi,%rax,8),%r11
   599f0:	ff 
   599f1:	8b 5c c6 04          	mov    0x4(%rsi,%rax,8),%ebx
   599f5:	44 21 cb             	and    %r9d,%ebx
   599f8:	48 c1 e3 06          	shl    $0x6,%rbx
   599fc:	41 0f 18 0c 1a       	prefetcht0 (%r10,%rbx,1)
   59a01:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   59a07:	49 c1 eb 20          	shr    $0x20,%r11
   59a0b:	45 21 cb             	and    %r9d,%r11d
   59a0e:	49 c1 e3 06          	shl    $0x6,%r11
   59a12:	62 91 fd 48 6f 1c 1a 	vmovdqa64 (%r10,%r11,1),%zmm3
   59a19:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   59a1e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59a23:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   59a29:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59a2f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59a35:	45 31 db             	xor    %r11d,%r11d
   59a38:	c5 f9 98 c0          	kortestb %k0,%k0
   59a3c:	41 0f 94 c3          	sete   %r11b
   59a40:	44 89 5c 81 80       	mov    %r11d,-0x80(%rcx,%rax,4)
   59a45:	4c 8d 58 01          	lea    0x1(%rax),%r11
   59a49:	48 83 c0 e1          	add    $0xffffffffffffffe1,%rax
   59a4d:	4c 39 c0             	cmp    %r8,%rax
   59a50:	4c 89 d8             	mov    %r11,%rax
   59a53:	72 8b                	jb     599e0 <compare_benchmark::lookup+0x60>
   59a55:	49 89 d1             	mov    %rdx,%r9
   59a58:	4d 29 c1             	sub    %r8,%r9
   59a5b:	0f 84 f4 01 00 00    	je     59c55 <compare_benchmark::lookup+0x2d5>
   59a61:	48 8b 47 08          	mov    0x8(%rdi),%rax
   59a65:	8b 7f 18             	mov    0x18(%rdi),%edi
   59a68:	49 83 f9 01          	cmp    $0x1,%r9
   59a6c:	0f 85 a6 00 00 00    	jne    59b18 <compare_benchmark::lookup+0x198>
   59a72:	31 db                	xor    %ebx,%ebx
   59a74:	e9 83 01 00 00       	jmp    59bfc <compare_benchmark::lookup+0x27c>
   59a79:	48 85 d2             	test   %rdx,%rdx
   59a7c:	0f 84 d3 01 00 00    	je     59c55 <compare_benchmark::lookup+0x2d5>
   59a82:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   59a86:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   59a8a:	48 8b 47 10          	mov    0x10(%rdi),%rax
   59a8e:	45 31 d2             	xor    %r10d,%r10d
   59a91:	62 f1 fd 48 6f 05 e5 	vmovdqa64 -0x5081b(%rip),%zmm0        # 9280 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x450>
   59a98:	f7 fa ff 
   59a9b:	62 f2 fd 48 59 0d e3 	vpbroadcastq -0x5141d(%rip),%zmm1        # 8688 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x38>
   59aa2:	eb fa ff 
   59aa5:	62 f2 fd 48 59 15 71 	vpbroadcastq -0x5148f(%rip),%zmm2        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   59aac:	eb fa ff 
   59aaf:	90                   	nop
   59ab0:	4e 8b 1c d6          	mov    (%rsi,%r10,8),%r11
   59ab4:	4c 89 df             	mov    %r11,%rdi
   59ab7:	48 c1 ef 20          	shr    $0x20,%rdi
   59abb:	44 21 c7             	and    %r8d,%edi
   59abe:	48 39 f8             	cmp    %rdi,%rax
   59ac1:	0f 86 e2 01 00 00    	jbe    59ca9 <compare_benchmark::lookup+0x329>
   59ac7:	62 d2 fd 48 7c db    	vpbroadcastq %r11,%zmm3
   59acd:	62 f2 e5 48 40 d8    	vpmullq %zmm0,%zmm3,%zmm3
   59ad3:	48 c1 e7 06          	shl    $0x6,%rdi
   59ad7:	62 f1 e5 48 73 d3 1a 	vpsrlq $0x1a,%zmm3,%zmm3
   59ade:	62 f1 e5 48 db d9    	vpandq %zmm1,%zmm3,%zmm3
   59ae4:	62 f2 ed 48 47 db    	vpsllvq %zmm3,%zmm2,%zmm3
   59aea:	62 d1 fe 48 6f 24 39 	vmovdqu64 (%r9,%rdi,1),%zmm4
   59af1:	62 f1 dd 48 df db    	vpandnq %zmm3,%zmm4,%zmm3
   59af7:	62 f2 65 48 27 c3    	vptestmd %zmm3,%zmm3,%k0
   59afd:	31 ff                	xor    %edi,%edi
   59aff:	c5 f8 98 c0          	kortestw %k0,%k0
   59b03:	40 0f 94 c7          	sete   %dil
   59b07:	42 89 3c 91          	mov    %edi,(%rcx,%r10,4)
   59b0b:	49 ff c2             	inc    %r10
   59b0e:	4c 39 d2             	cmp    %r10,%rdx
   59b11:	75 9d                	jne    59ab0 <compare_benchmark::lookup+0x130>
   59b13:	e9 3d 01 00 00       	jmp    59c55 <compare_benchmark::lookup+0x2d5>
   59b18:	4d 89 ca             	mov    %r9,%r10
   59b1b:	49 83 e2 fe          	and    $0xfffffffffffffffe,%r10
   59b1f:	4a 8d 1c cd 00 00 00 	lea    0x0(,%r9,8),%rbx
   59b26:	00 
   59b27:	4c 8d 1c d6          	lea    (%rsi,%rdx,8),%r11
   59b2b:	49 29 db             	sub    %rbx,%r11
   59b2e:	49 83 c3 08          	add    $0x8,%r11
   59b32:	4a 8d 1c 8d 00 00 00 	lea    0x0(,%r9,4),%rbx
   59b39:	00 
   59b3a:	48 8d 14 91          	lea    (%rcx,%rdx,4),%rdx
   59b3e:	48 29 da             	sub    %rbx,%rdx
   59b41:	48 83 c2 04          	add    $0x4,%rdx
   59b45:	45 31 f6             	xor    %r14d,%r14d
   59b48:	c5 fd 6f 05 10 ec fa 	vmovdqa -0x513f0(%rip),%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   59b4f:	ff 
   59b50:	62 f2 fd 48 59 0d c6 	vpbroadcastq -0x5153a(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   59b57:	ea fa ff 
   59b5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   59b60:	4b 8b 5c f3 f8       	mov    -0x8(%r11,%r14,8),%rbx
   59b65:	62 f2 7d 28 7c d3    	vpbroadcastd %ebx,%ymm2
   59b6b:	48 c1 eb 20          	shr    $0x20,%rbx
   59b6f:	21 fb                	and    %edi,%ebx
   59b71:	48 c1 e3 06          	shl    $0x6,%rbx
   59b75:	62 f1 fd 48 6f 1c 18 	vmovdqa64 (%rax,%rbx,1),%zmm3
   59b7c:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   59b81:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59b86:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   59b8c:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59b92:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59b98:	31 db                	xor    %ebx,%ebx
   59b9a:	c5 f9 98 c0          	kortestb %k0,%k0
   59b9e:	0f 94 c3             	sete   %bl
   59ba1:	42 89 5c b2 fc       	mov    %ebx,-0x4(%rdx,%r14,4)
   59ba6:	49 8d 5e 02          	lea    0x2(%r14),%rbx
   59baa:	4f 8b 3c f3          	mov    (%r11,%r14,8),%r15
   59bae:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   59bb4:	49 c1 ef 20          	shr    $0x20,%r15
   59bb8:	41 21 ff             	and    %edi,%r15d
   59bbb:	49 c1 e7 06          	shl    $0x6,%r15
   59bbf:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   59bc4:	62 b1 fd 48 6f 1c 38 	vmovdqa64 (%rax,%r15,1),%zmm3
   59bcb:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59bd0:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   59bd6:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59bdc:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59be2:	31 ed                	xor    %ebp,%ebp
   59be4:	c5 f9 98 c0          	kortestb %k0,%k0
   59be8:	40 0f 94 c5          	sete   %bpl
   59bec:	42 89 2c b2          	mov    %ebp,(%rdx,%r14,4)
   59bf0:	49 89 de             	mov    %rbx,%r14
   59bf3:	49 39 da             	cmp    %rbx,%r10
   59bf6:	0f 85 64 ff ff ff    	jne    59b60 <compare_benchmark::lookup+0x1e0>
   59bfc:	41 f6 c1 01          	test   $0x1,%r9b
   59c00:	74 53                	je     59c55 <compare_benchmark::lookup+0x2d5>
   59c02:	4a 8d 14 c6          	lea    (%rsi,%r8,8),%rdx
   59c06:	4a 8d 0c 81          	lea    (%rcx,%r8,4),%rcx
   59c0a:	48 8b 14 da          	mov    (%rdx,%rbx,8),%rdx
   59c0e:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   59c14:	48 c1 ea 20          	shr    $0x20,%rdx
   59c18:	21 d7                	and    %edx,%edi
   59c1a:	48 c1 e7 06          	shl    $0x6,%rdi
   59c1e:	c4 e2 7d 40 05 39 eb 	vpmulld -0x514c7(%rip),%ymm0,%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   59c25:	fa ff 
   59c27:	62 f1 fd 48 6f 0c 38 	vmovdqa64 (%rax,%rdi,1),%zmm1
   59c2e:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   59c33:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   59c39:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   59c3f:	62 f2 fe 58 27 05 d7 	vptestnmq -0x51629(%rip){1to8},%zmm0,%k0        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   59c46:	e9 fa ff 
   59c49:	31 c0                	xor    %eax,%eax
   59c4b:	c5 f9 98 c0          	kortestb %k0,%k0
   59c4f:	0f 94 c0             	sete   %al
   59c52:	89 04 99             	mov    %eax,(%rcx,%rbx,4)
   59c55:	48 83 c4 48          	add    $0x48,%rsp
   59c59:	5b                   	pop    %rbx
   59c5a:	41 5e                	pop    %r14
   59c5c:	41 5f                	pop    %r15
   59c5e:	5d                   	pop    %rbp
   59c5f:	c5 f8 77             	vzeroupper
   59c62:	c3                   	ret
   59c63:	48 8d 05 b6 1c 05 00 	lea    0x51cb6(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   59c6a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   59c6f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   59c76:	00 00 
   59c78:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   59c7f:	00 00 
   59c81:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   59c85:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   59c8b:	4c 8d 05 6e 28 05 00 	lea    0x5286e(%rip),%r8        # ac500 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xdd0>
   59c92:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   59c97:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   59c9c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   59ca1:	31 ff                	xor    %edi,%edi
   59ca3:	ff 15 8f 58 05 00    	call   *0x5588f(%rip)        # af538 <_DYNAMIC+0x3a8>
   59ca9:	48 8d 15 08 24 05 00 	lea    0x52408(%rip),%rdx        # ac0b8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x988>
   59cb0:	48 89 c6             	mov    %rax,%rsi
   59cb3:	c5 f8 77             	vzeroupper
   59cb6:	ff 15 04 57 05 00    	call   *0x55704(%rip)        # af3c0 <_DYNAMIC+0x230>
   59cbc:	48 8d 0d dd 23 05 00 	lea    0x523dd(%rip),%rcx        # ac0a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x970>
   59cc3:	48 89 c7             	mov    %rax,%rdi
   59cc6:	48 89 d6             	mov    %rdx,%rsi
   59cc9:	48 89 ca             	mov    %rcx,%rdx
   59ccc:	c5 f8 77             	vzeroupper
   59ccf:	ff 15 eb 56 05 00    	call   *0x556eb(%rip)        # af3c0 <_DYNAMIC+0x230>
   59cd5:	cc                   	int3
   59cd6:	cc                   	int3
   59cd7:	cc                   	int3
   59cd8:	cc                   	int3
   59cd9:	cc                   	int3
   59cda:	cc                   	int3
   59cdb:	cc                   	int3
   59cdc:	cc                   	int3
   59cdd:	cc                   	int3
   59cde:	cc                   	int3
   59cdf:	cc                   	int3

