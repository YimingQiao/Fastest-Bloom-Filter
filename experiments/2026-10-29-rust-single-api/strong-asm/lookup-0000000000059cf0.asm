0000000000059cf0 <compare_benchmark::lookup>:
   59cf0:	48 83 ec 48          	sub    $0x48,%rsp
   59cf4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   59cf9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   59cfe:	4c 39 c2             	cmp    %r8,%rdx
   59d01:	0f 85 bc 01 00 00    	jne    59ec3 <compare_benchmark::lookup+0x1d3>
   59d07:	48 83 fa 01          	cmp    $0x1,%rdx
   59d0b:	75 46                	jne    59d53 <compare_benchmark::lookup+0x63>
   59d0d:	48 8b 16             	mov    (%rsi),%rdx
   59d10:	48 89 d0             	mov    %rdx,%rax
   59d13:	48 c1 e8 20          	shr    $0x20,%rax
   59d17:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   59d1b:	74 43                	je     59d60 <compare_benchmark::lookup+0x70>
   59d1d:	23 47 18             	and    0x18(%rdi),%eax
   59d20:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   59d24:	48 c1 e0 04          	shl    $0x4,%rax
   59d28:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   59d2d:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   59d33:	c5 f1 e5 0d 65 ef fa 	vpmulhw -0x5109b(%rip),%xmm1,%xmm1        # 8ca0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1b0>
   59d3a:	ff 
   59d3b:	c4 e2 79 59 15 84 e8 	vpbroadcastq -0x5177c(%rip),%xmm2        # 85c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x24c>
   59d42:	fa ff 
   59d44:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   59d49:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   59d4e:	e9 60 01 00 00       	jmp    59eb3 <compare_benchmark::lookup+0x1c3>
   59d53:	49 89 d0             	mov    %rdx,%r8
   59d56:	48 83 c4 48          	add    $0x48,%rsp
   59d5a:	ff 25 f0 57 05 00    	jmp    *0x557f0(%rip)        # af550 <_DYNAMIC+0x3c0>
   59d60:	23 47 18             	and    0x18(%rdi),%eax
   59d63:	48 89 fe             	mov    %rdi,%rsi
   59d66:	89 c7                	mov    %eax,%edi
   59d68:	c1 ef 02             	shr    $0x2,%edi
   59d6b:	49 89 f0             	mov    %rsi,%r8
   59d6e:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   59d72:	48 39 f7             	cmp    %rsi,%rdi
   59d75:	0f 83 8e 01 00 00    	jae    59f09 <compare_benchmark::lookup+0x219>
   59d7b:	48 c1 e7 06          	shl    $0x6,%rdi
   59d7f:	49 03 78 08          	add    0x8(%r8),%rdi
   59d83:	c1 e0 04             	shl    $0x4,%eax
   59d86:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   59d8a:	c1 e2 10             	shl    $0x10,%edx
   59d8d:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   59d93:	83 e0 30             	and    $0x30,%eax
   59d96:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   59d9b:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   59da0:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   59da4:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   59daa:	85 d2                	test   %edx,%edx
   59dac:	0f 9f c2             	setg   %dl
   59daf:	41 0f 98 c0          	sets   %r8b
   59db3:	85 f6                	test   %esi,%esi
   59db5:	41 0f 98 c1          	sets   %r9b
   59db9:	c5 f5 f5 05 bf e9 fa 	vpmaddwd -0x51641(%rip),%ymm1,%ymm0        # 8780 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   59dc0:	ff 
   59dc1:	62 f1 fd 48 6f 0d f5 	vmovdqa64 -0x50b0b(%rip),%zmm1        # 92c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x490>
   59dc8:	f4 fa ff 
   59dcb:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   59dd1:	62 f2 7d 48 45 05 25 	vpsrlvd -0x50adb(%rip),%zmm0,%zmm0        # 9300 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x4d0>
   59dd8:	f5 fa ff 
   59ddb:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   59de1:	40 0f 9f c6          	setg   %sil
   59de5:	62 f1 7d 18 db 0d dd 	vpandd -0x51923(%rip){1to4},%xmm0,%xmm1        # 84cc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x150>
   59dec:	e6 fa ff 
   59def:	c5 fa 7e 15 e9 ed fa 	vmovq  -0x51217(%rip),%xmm2        # 8be0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0xf0>
   59df6:	ff 
   59df7:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   59dfb:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   59e00:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   59e05:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   59e0b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   59e10:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   59e16:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   59e1c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   59e20:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   59e25:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   59e2a:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   59e2e:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   59e33:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   59e39:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   59e3f:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   59e43:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   59e48:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   59e4d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   59e51:	c5 fb 92 ca          	kmovd  %edx,%k1
   59e55:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   59e5b:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   59e61:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   59e65:	66 ba 7f ff          	mov    $0xff7f,%dx
   59e69:	c5 fb 92 ca          	kmovd  %edx,%k1
   59e6d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   59e71:	c5 fb 92 ce          	kmovd  %esi,%k1
   59e75:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   59e7b:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   59e81:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   59e85:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   59e8b:	c5 fd 6f 1d ad e8 fa 	vmovdqa -0x51753(%rip),%ymm3        # 8740 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   59e92:	ff 
   59e93:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   59e99:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   59e9f:	c5 f8 44 c8          	knotw  %k0,%k1
   59ea3:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   59ea9:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   59eae:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   59eb3:	0f 92 c0             	setb   %al
   59eb6:	0f b6 c0             	movzbl %al,%eax
   59eb9:	89 01                	mov    %eax,(%rcx)
   59ebb:	48 83 c4 48          	add    $0x48,%rsp
   59ebf:	c5 f8 77             	vzeroupper
   59ec2:	c3                   	ret
   59ec3:	48 8d 05 56 1a 05 00 	lea    0x51a56(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   59eca:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   59ecf:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   59ed6:	00 00 
   59ed8:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   59edf:	00 00 
   59ee1:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   59ee5:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   59eeb:	4c 8d 05 fe 22 05 00 	lea    0x522fe(%rip),%r8        # ac1f0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xac0>
   59ef2:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   59ef7:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   59efc:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   59f01:	31 ff                	xor    %edi,%edi
   59f03:	ff 15 2f 56 05 00    	call   *0x5562f(%rip)        # af538 <_DYNAMIC+0x3a8>
   59f09:	48 8d 15 f8 22 05 00 	lea    0x522f8(%rip),%rdx        # ac208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xad8>
   59f10:	ff 15 aa 54 05 00    	call   *0x554aa(%rip)        # af3c0 <_DYNAMIC+0x230>
   59f16:	cc                   	int3
   59f17:	cc                   	int3
   59f18:	cc                   	int3
   59f19:	cc                   	int3
   59f1a:	cc                   	int3
   59f1b:	cc                   	int3
   59f1c:	cc                   	int3
   59f1d:	cc                   	int3
   59f1e:	cc                   	int3
   59f1f:	cc                   	int3

