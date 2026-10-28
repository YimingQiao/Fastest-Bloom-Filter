00000000000628d0 <compare_benchmark::lookup>:
   628d0:	55                   	push   %rbp
   628d1:	41 57                	push   %r15
   628d3:	41 56                	push   %r14
   628d5:	53                   	push   %rbx
   628d6:	48 83 ec 48          	sub    $0x48,%rsp
   628da:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   628df:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   628e4:	4c 39 c2             	cmp    %r8,%rdx
   628e7:	0f 85 c6 02 00 00    	jne    62bb3 <compare_benchmark::lookup+0x2e3>
   628ed:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   628f1:	0f 84 d2 00 00 00    	je     629c9 <compare_benchmark::lookup+0xf9>
   628f7:	45 31 c0             	xor    %r8d,%r8d
   628fa:	48 89 d0             	mov    %rdx,%rax
   628fd:	48 83 e8 20          	sub    $0x20,%rax
   62901:	4c 0f 43 c0          	cmovae %rax,%r8
   62905:	0f 86 9a 00 00 00    	jbe    629a5 <compare_benchmark::lookup+0xd5>
   6290b:	44 8b 4f 18          	mov    0x18(%rdi),%r9d
   6290f:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   62913:	b8 20 00 00 00       	mov    $0x20,%eax
   62918:	c5 fd 6f 05 c0 61 fa 	vmovdqa -0x59e40(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   6291f:	ff 
   62920:	62 f2 fd 48 59 0d 76 	vpbroadcastq -0x59f8a(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   62927:	60 fa ff 
   6292a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   62930:	48 39 c2             	cmp    %rax,%rdx
   62933:	0f 84 d3 02 00 00    	je     62c0c <compare_benchmark::lookup+0x33c>
   62939:	4c 8b 9c c6 00 ff ff 	mov    -0x100(%rsi,%rax,8),%r11
   62940:	ff 
   62941:	8b 5c c6 04          	mov    0x4(%rsi,%rax,8),%ebx
   62945:	44 21 cb             	and    %r9d,%ebx
   62948:	48 c1 e3 06          	shl    $0x6,%rbx
   6294c:	41 0f 18 0c 1a       	prefetcht0 (%r10,%rbx,1)
   62951:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   62957:	49 c1 eb 20          	shr    $0x20,%r11
   6295b:	45 21 cb             	and    %r9d,%r11d
   6295e:	49 c1 e3 06          	shl    $0x6,%r11
   62962:	62 91 fd 48 6f 1c 1a 	vmovdqa64 (%r10,%r11,1),%zmm3
   62969:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   6296e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   62973:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   62979:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   6297f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   62985:	45 31 db             	xor    %r11d,%r11d
   62988:	c5 f9 98 c0          	kortestb %k0,%k0
   6298c:	41 0f 94 c3          	sete   %r11b
   62990:	44 89 5c 81 80       	mov    %r11d,-0x80(%rcx,%rax,4)
   62995:	4c 8d 58 01          	lea    0x1(%rax),%r11
   62999:	48 83 c0 e1          	add    $0xffffffffffffffe1,%rax
   6299d:	4c 39 c0             	cmp    %r8,%rax
   629a0:	4c 89 d8             	mov    %r11,%rax
   629a3:	72 8b                	jb     62930 <compare_benchmark::lookup+0x60>
   629a5:	49 89 d1             	mov    %rdx,%r9
   629a8:	4d 29 c1             	sub    %r8,%r9
   629ab:	0f 84 f4 01 00 00    	je     62ba5 <compare_benchmark::lookup+0x2d5>
   629b1:	48 8b 47 08          	mov    0x8(%rdi),%rax
   629b5:	8b 7f 18             	mov    0x18(%rdi),%edi
   629b8:	49 83 f9 01          	cmp    $0x1,%r9
   629bc:	0f 85 a6 00 00 00    	jne    62a68 <compare_benchmark::lookup+0x198>
   629c2:	31 db                	xor    %ebx,%ebx
   629c4:	e9 83 01 00 00       	jmp    62b4c <compare_benchmark::lookup+0x27c>
   629c9:	48 85 d2             	test   %rdx,%rdx
   629cc:	0f 84 d3 01 00 00    	je     62ba5 <compare_benchmark::lookup+0x2d5>
   629d2:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   629d6:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   629da:	48 8b 47 10          	mov    0x10(%rdi),%rax
   629de:	45 31 d2             	xor    %r10d,%r10d
   629e1:	62 f1 fd 48 6f 05 15 	vmovdqa64 -0x590eb(%rip),%zmm0        # 9900 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x720>
   629e8:	6f fa ff 
   629eb:	62 f2 fd 48 59 0d 1b 	vpbroadcastq -0x59fe5(%rip),%zmm1        # 8a10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x40>
   629f2:	60 fa ff 
   629f5:	62 f2 fd 48 59 15 a1 	vpbroadcastq -0x5a05f(%rip),%zmm2        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   629fc:	5f fa ff 
   629ff:	90                   	nop
   62a00:	4e 8b 1c d6          	mov    (%rsi,%r10,8),%r11
   62a04:	4c 89 df             	mov    %r11,%rdi
   62a07:	48 c1 ef 20          	shr    $0x20,%rdi
   62a0b:	44 21 c7             	and    %r8d,%edi
   62a0e:	48 39 f8             	cmp    %rdi,%rax
   62a11:	0f 86 e2 01 00 00    	jbe    62bf9 <compare_benchmark::lookup+0x329>
   62a17:	62 d2 fd 48 7c db    	vpbroadcastq %r11,%zmm3
   62a1d:	62 f2 e5 48 40 d8    	vpmullq %zmm0,%zmm3,%zmm3
   62a23:	48 c1 e7 06          	shl    $0x6,%rdi
   62a27:	62 f1 e5 48 73 d3 1a 	vpsrlq $0x1a,%zmm3,%zmm3
   62a2e:	62 f1 e5 48 db d9    	vpandq %zmm1,%zmm3,%zmm3
   62a34:	62 f2 ed 48 47 db    	vpsllvq %zmm3,%zmm2,%zmm3
   62a3a:	62 d1 fe 48 6f 24 39 	vmovdqu64 (%r9,%rdi,1),%zmm4
   62a41:	62 f1 dd 48 df db    	vpandnq %zmm3,%zmm4,%zmm3
   62a47:	62 f2 65 48 27 c3    	vptestmd %zmm3,%zmm3,%k0
   62a4d:	31 ff                	xor    %edi,%edi
   62a4f:	c5 f8 98 c0          	kortestw %k0,%k0
   62a53:	40 0f 94 c7          	sete   %dil
   62a57:	42 89 3c 91          	mov    %edi,(%rcx,%r10,4)
   62a5b:	49 ff c2             	inc    %r10
   62a5e:	4c 39 d2             	cmp    %r10,%rdx
   62a61:	75 9d                	jne    62a00 <compare_benchmark::lookup+0x130>
   62a63:	e9 3d 01 00 00       	jmp    62ba5 <compare_benchmark::lookup+0x2d5>
   62a68:	4d 89 ca             	mov    %r9,%r10
   62a6b:	49 83 e2 fe          	and    $0xfffffffffffffffe,%r10
   62a6f:	4a 8d 1c cd 00 00 00 	lea    0x0(,%r9,8),%rbx
   62a76:	00 
   62a77:	4c 8d 1c d6          	lea    (%rsi,%rdx,8),%r11
   62a7b:	49 29 db             	sub    %rbx,%r11
   62a7e:	49 83 c3 08          	add    $0x8,%r11
   62a82:	4a 8d 1c 8d 00 00 00 	lea    0x0(,%r9,4),%rbx
   62a89:	00 
   62a8a:	48 8d 14 91          	lea    (%rcx,%rdx,4),%rdx
   62a8e:	48 29 da             	sub    %rbx,%rdx
   62a91:	48 83 c2 04          	add    $0x4,%rdx
   62a95:	45 31 f6             	xor    %r14d,%r14d
   62a98:	c5 fd 6f 05 40 60 fa 	vmovdqa -0x59fc0(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   62a9f:	ff 
   62aa0:	62 f2 fd 48 59 0d f6 	vpbroadcastq -0x5a10a(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   62aa7:	5e fa ff 
   62aaa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   62ab0:	4b 8b 5c f3 f8       	mov    -0x8(%r11,%r14,8),%rbx
   62ab5:	62 f2 7d 28 7c d3    	vpbroadcastd %ebx,%ymm2
   62abb:	48 c1 eb 20          	shr    $0x20,%rbx
   62abf:	21 fb                	and    %edi,%ebx
   62ac1:	48 c1 e3 06          	shl    $0x6,%rbx
   62ac5:	62 f1 fd 48 6f 1c 18 	vmovdqa64 (%rax,%rbx,1),%zmm3
   62acc:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   62ad1:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   62ad6:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   62adc:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   62ae2:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   62ae8:	31 db                	xor    %ebx,%ebx
   62aea:	c5 f9 98 c0          	kortestb %k0,%k0
   62aee:	0f 94 c3             	sete   %bl
   62af1:	42 89 5c b2 fc       	mov    %ebx,-0x4(%rdx,%r14,4)
   62af6:	49 8d 5e 02          	lea    0x2(%r14),%rbx
   62afa:	4f 8b 3c f3          	mov    (%r11,%r14,8),%r15
   62afe:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   62b04:	49 c1 ef 20          	shr    $0x20,%r15
   62b08:	41 21 ff             	and    %edi,%r15d
   62b0b:	49 c1 e7 06          	shl    $0x6,%r15
   62b0f:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   62b14:	62 b1 fd 48 6f 1c 38 	vmovdqa64 (%rax,%r15,1),%zmm3
   62b1b:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   62b20:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   62b26:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   62b2c:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   62b32:	31 ed                	xor    %ebp,%ebp
   62b34:	c5 f9 98 c0          	kortestb %k0,%k0
   62b38:	40 0f 94 c5          	sete   %bpl
   62b3c:	42 89 2c b2          	mov    %ebp,(%rdx,%r14,4)
   62b40:	49 89 de             	mov    %rbx,%r14
   62b43:	49 39 da             	cmp    %rbx,%r10
   62b46:	0f 85 64 ff ff ff    	jne    62ab0 <compare_benchmark::lookup+0x1e0>
   62b4c:	41 f6 c1 01          	test   $0x1,%r9b
   62b50:	74 53                	je     62ba5 <compare_benchmark::lookup+0x2d5>
   62b52:	4a 8d 14 c6          	lea    (%rsi,%r8,8),%rdx
   62b56:	4a 8d 0c 81          	lea    (%rcx,%r8,4),%rcx
   62b5a:	48 8b 14 da          	mov    (%rdx,%rbx,8),%rdx
   62b5e:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   62b64:	48 c1 ea 20          	shr    $0x20,%rdx
   62b68:	21 d7                	and    %edx,%edi
   62b6a:	48 c1 e7 06          	shl    $0x6,%rdi
   62b6e:	c4 e2 7d 40 05 69 5f 	vpmulld -0x5a097(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   62b75:	fa ff 
   62b77:	62 f1 fd 48 6f 0c 38 	vmovdqa64 (%rax,%rdi,1),%zmm1
   62b7e:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   62b83:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   62b89:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   62b8f:	62 f2 fe 58 27 05 07 	vptestnmq -0x5a1f9(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   62b96:	5e fa ff 
   62b99:	31 c0                	xor    %eax,%eax
   62b9b:	c5 f9 98 c0          	kortestb %k0,%k0
   62b9f:	0f 94 c0             	sete   %al
   62ba2:	89 04 99             	mov    %eax,(%rcx,%rbx,4)
   62ba5:	48 83 c4 48          	add    $0x48,%rsp
   62ba9:	5b                   	pop    %rbx
   62baa:	41 5e                	pop    %r14
   62bac:	41 5f                	pop    %r15
   62bae:	5d                   	pop    %rbp
   62baf:	c5 f8 77             	vzeroupper
   62bb2:	c3                   	ret
   62bb3:	48 8d 05 06 1e 05 00 	lea    0x51e06(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   62bba:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   62bbf:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   62bc6:	00 00 
   62bc8:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   62bcf:	00 00 
   62bd1:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   62bd5:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   62bdb:	4c 8d 05 b6 2a 05 00 	lea    0x52ab6(%rip),%r8        # b5698 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xec8>
   62be2:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   62be7:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   62bec:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   62bf1:	31 ff                	xor    %edi,%edi
   62bf3:	ff 15 f7 5b 05 00    	call   *0x55bf7(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   62bf9:	48 8d 15 f0 25 05 00 	lea    0x525f0(%rip),%rdx        # b51f0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa20>
   62c00:	48 89 c6             	mov    %rax,%rsi
   62c03:	c5 f8 77             	vzeroupper
   62c06:	ff 15 6c 5a 05 00    	call   *0x55a6c(%rip)        # b8678 <_DYNAMIC+0x260>
   62c0c:	48 8d 0d c5 25 05 00 	lea    0x525c5(%rip),%rcx        # b51d8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa08>
   62c13:	48 89 c7             	mov    %rax,%rdi
   62c16:	48 89 d6             	mov    %rdx,%rsi
   62c19:	48 89 ca             	mov    %rcx,%rdx
   62c1c:	c5 f8 77             	vzeroupper
   62c1f:	ff 15 53 5a 05 00    	call   *0x55a53(%rip)        # b8678 <_DYNAMIC+0x260>
   62c25:	cc                   	int3
   62c26:	cc                   	int3
   62c27:	cc                   	int3
   62c28:	cc                   	int3
   62c29:	cc                   	int3
   62c2a:	cc                   	int3
   62c2b:	cc                   	int3
   62c2c:	cc                   	int3
   62c2d:	cc                   	int3
   62c2e:	cc                   	int3
   62c2f:	cc                   	int3

