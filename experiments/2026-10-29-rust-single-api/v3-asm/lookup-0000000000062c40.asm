0000000000062c40 <compare_benchmark::lookup>:
   62c40:	48 83 ec 48          	sub    $0x48,%rsp
   62c44:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   62c49:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   62c4e:	4c 39 c2             	cmp    %r8,%rdx
   62c51:	0f 85 bc 01 00 00    	jne    62e13 <compare_benchmark::lookup+0x1d3>
   62c57:	48 83 fa 01          	cmp    $0x1,%rdx
   62c5b:	75 46                	jne    62ca3 <compare_benchmark::lookup+0x63>
   62c5d:	48 8b 16             	mov    (%rsi),%rdx
   62c60:	48 89 d0             	mov    %rdx,%rax
   62c63:	48 c1 e8 20          	shr    $0x20,%rax
   62c67:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   62c6b:	74 43                	je     62cb0 <compare_benchmark::lookup+0x70>
   62c6d:	23 47 18             	and    0x18(%rdi),%eax
   62c70:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   62c74:	48 c1 e0 04          	shl    $0x4,%rax
   62c78:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   62c7d:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   62c83:	c5 f1 e5 0d b5 63 fa 	vpmulhw -0x59c4b(%rip),%xmm1,%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   62c8a:	ff 
   62c8b:	c4 e2 79 59 15 b4 5c 	vpbroadcastq -0x5a34c(%rip),%xmm2        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   62c92:	fa ff 
   62c94:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   62c99:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   62c9e:	e9 60 01 00 00       	jmp    62e03 <compare_benchmark::lookup+0x1c3>
   62ca3:	49 89 d0             	mov    %rdx,%r8
   62ca6:	48 83 c4 48          	add    $0x48,%rsp
   62caa:	ff 25 70 5b 05 00    	jmp    *0x55b70(%rip)        # b8820 <_DYNAMIC+0x408>
   62cb0:	23 47 18             	and    0x18(%rdi),%eax
   62cb3:	48 89 fe             	mov    %rdi,%rsi
   62cb6:	89 c7                	mov    %eax,%edi
   62cb8:	c1 ef 02             	shr    $0x2,%edi
   62cbb:	49 89 f0             	mov    %rsi,%r8
   62cbe:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   62cc2:	48 39 f7             	cmp    %rsi,%rdi
   62cc5:	0f 83 8e 01 00 00    	jae    62e59 <compare_benchmark::lookup+0x219>
   62ccb:	48 c1 e7 06          	shl    $0x6,%rdi
   62ccf:	49 03 78 08          	add    0x8(%r8),%rdi
   62cd3:	c1 e0 04             	shl    $0x4,%eax
   62cd6:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   62cda:	c1 e2 10             	shl    $0x10,%edx
   62cdd:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   62ce3:	83 e0 30             	and    $0x30,%eax
   62ce6:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   62ceb:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   62cf0:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   62cf4:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   62cfa:	85 d2                	test   %edx,%edx
   62cfc:	0f 9f c2             	setg   %dl
   62cff:	41 0f 98 c0          	sets   %r8b
   62d03:	85 f6                	test   %esi,%esi
   62d05:	41 0f 98 c1          	sets   %r9b
   62d09:	c5 f5 f5 05 ef 5d fa 	vpmaddwd -0x5a211(%rip),%ymm1,%ymm0        # 8b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   62d10:	ff 
   62d11:	62 f1 fd 48 6f 0d 25 	vmovdqa64 -0x593db(%rip),%zmm1        # 9940 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x760>
   62d18:	6c fa ff 
   62d1b:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   62d21:	62 f2 7d 48 45 05 55 	vpsrlvd -0x593ab(%rip),%zmm0,%zmm0        # 9980 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x7a0>
   62d28:	6c fa ff 
   62d2b:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   62d31:	40 0f 9f c6          	setg   %sil
   62d35:	62 f1 7d 18 db 0d 25 	vpandd -0x5a4db(%rip){1to4},%xmm0,%xmm1        # 8864 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x14f>
   62d3c:	5b fa ff 
   62d3f:	c5 fa 7e 15 39 62 fa 	vmovq  -0x59dc7(%rip),%xmm2        # 8f80 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x110>
   62d46:	ff 
   62d47:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   62d4b:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   62d50:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   62d55:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   62d5b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   62d60:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   62d66:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   62d6c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   62d70:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   62d75:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   62d7a:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   62d7e:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   62d83:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   62d89:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   62d8f:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   62d93:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   62d98:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   62d9d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   62da1:	c5 fb 92 ca          	kmovd  %edx,%k1
   62da5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   62dab:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   62db1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   62db5:	66 ba 7f ff          	mov    $0xff7f,%dx
   62db9:	c5 fb 92 ca          	kmovd  %edx,%k1
   62dbd:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   62dc1:	c5 fb 92 ce          	kmovd  %esi,%k1
   62dc5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   62dcb:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   62dd1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   62dd5:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   62ddb:	c5 fd 6f 1d dd 5c fa 	vmovdqa -0x5a323(%rip),%ymm3        # 8ac0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   62de2:	ff 
   62de3:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   62de9:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   62def:	c5 f8 44 c8          	knotw  %k0,%k1
   62df3:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   62df9:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   62dfe:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   62e03:	0f 92 c0             	setb   %al
   62e06:	0f b6 c0             	movzbl %al,%eax
   62e09:	89 01                	mov    %eax,(%rcx)
   62e0b:	48 83 c4 48          	add    $0x48,%rsp
   62e0f:	c5 f8 77             	vzeroupper
   62e12:	c3                   	ret
   62e13:	48 8d 05 a6 1b 05 00 	lea    0x51ba6(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   62e1a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   62e1f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   62e26:	00 00 
   62e28:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   62e2f:	00 00 
   62e31:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   62e35:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   62e3b:	4c 8d 05 a6 25 05 00 	lea    0x525a6(%rip),%r8        # b53e8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc18>
   62e42:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   62e47:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   62e4c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   62e51:	31 ff                	xor    %edi,%edi
   62e53:	ff 15 97 59 05 00    	call   *0x55997(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   62e59:	48 8d 15 a0 25 05 00 	lea    0x525a0(%rip),%rdx        # b5400 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc30>
   62e60:	ff 15 12 58 05 00    	call   *0x55812(%rip)        # b8678 <_DYNAMIC+0x260>
   62e66:	cc                   	int3
   62e67:	cc                   	int3
   62e68:	cc                   	int3
   62e69:	cc                   	int3
   62e6a:	cc                   	int3
   62e6b:	cc                   	int3
   62e6c:	cc                   	int3
   62e6d:	cc                   	int3
   62e6e:	cc                   	int3
   62e6f:	cc                   	int3

