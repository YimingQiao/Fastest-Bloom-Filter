0000000000063070 <compare_benchmark::lookup>:
   63070:	48 83 ec 48          	sub    $0x48,%rsp
   63074:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   63079:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   6307e:	4c 39 c2             	cmp    %r8,%rdx
   63081:	0f 85 bc 01 00 00    	jne    63243 <compare_benchmark::lookup+0x1d3>
   63087:	48 83 fa 01          	cmp    $0x1,%rdx
   6308b:	75 46                	jne    630d3 <compare_benchmark::lookup+0x63>
   6308d:	48 8b 16             	mov    (%rsi),%rdx
   63090:	48 89 d0             	mov    %rdx,%rax
   63093:	48 c1 e8 20          	shr    $0x20,%rax
   63097:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   6309b:	74 43                	je     630e0 <compare_benchmark::lookup+0x70>
   6309d:	23 47 18             	and    0x18(%rdi),%eax
   630a0:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   630a4:	48 c1 e0 04          	shl    $0x4,%rax
   630a8:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   630ad:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   630b3:	c5 f1 e5 0d 85 5f fa 	vpmulhw -0x5a07b(%rip),%xmm1,%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   630ba:	ff 
   630bb:	c4 e2 79 59 15 84 58 	vpbroadcastq -0x5a77c(%rip),%xmm2        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   630c2:	fa ff 
   630c4:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   630c9:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   630ce:	e9 60 01 00 00       	jmp    63233 <compare_benchmark::lookup+0x1c3>
   630d3:	49 89 d0             	mov    %rdx,%r8
   630d6:	48 83 c4 48          	add    $0x48,%rsp
   630da:	ff 25 38 57 05 00    	jmp    *0x55738(%rip)        # b8818 <_DYNAMIC+0x400>
   630e0:	23 47 18             	and    0x18(%rdi),%eax
   630e3:	48 89 fe             	mov    %rdi,%rsi
   630e6:	89 c7                	mov    %eax,%edi
   630e8:	c1 ef 02             	shr    $0x2,%edi
   630eb:	49 89 f0             	mov    %rsi,%r8
   630ee:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   630f2:	48 39 f7             	cmp    %rsi,%rdi
   630f5:	0f 83 8e 01 00 00    	jae    63289 <compare_benchmark::lookup+0x219>
   630fb:	48 c1 e7 06          	shl    $0x6,%rdi
   630ff:	49 03 78 08          	add    0x8(%r8),%rdi
   63103:	c1 e0 04             	shl    $0x4,%eax
   63106:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   6310a:	c1 e2 10             	shl    $0x10,%edx
   6310d:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   63113:	83 e0 30             	and    $0x30,%eax
   63116:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   6311b:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   63120:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   63124:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   6312a:	85 d2                	test   %edx,%edx
   6312c:	0f 9f c2             	setg   %dl
   6312f:	41 0f 98 c0          	sets   %r8b
   63133:	85 f6                	test   %esi,%esi
   63135:	41 0f 98 c1          	sets   %r9b
   63139:	c5 f5 f5 05 bf 59 fa 	vpmaddwd -0x5a641(%rip),%ymm1,%ymm0        # 8b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   63140:	ff 
   63141:	62 f1 fd 48 6f 0d 75 	vmovdqa64 -0x5978b(%rip),%zmm1        # 99c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x7e0>
   63148:	68 fa ff 
   6314b:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   63151:	62 f2 7d 48 45 05 a5 	vpsrlvd -0x5975b(%rip),%zmm0,%zmm0        # 9a00 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x820>
   63158:	68 fa ff 
   6315b:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   63161:	40 0f 9f c6          	setg   %sil
   63165:	62 f1 7d 18 db 0d f5 	vpandd -0x5a90b(%rip){1to4},%xmm0,%xmm1        # 8864 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x14f>
   6316c:	56 fa ff 
   6316f:	c5 fa 7e 15 09 5e fa 	vmovq  -0x5a1f7(%rip),%xmm2        # 8f80 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x110>
   63176:	ff 
   63177:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   6317b:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   63180:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   63185:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   6318b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   63190:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   63196:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   6319c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   631a0:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   631a5:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   631aa:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   631ae:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   631b3:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   631b9:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   631bf:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   631c3:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   631c8:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   631cd:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   631d1:	c5 fb 92 ca          	kmovd  %edx,%k1
   631d5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   631db:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   631e1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   631e5:	66 ba 7f ff          	mov    $0xff7f,%dx
   631e9:	c5 fb 92 ca          	kmovd  %edx,%k1
   631ed:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   631f1:	c5 fb 92 ce          	kmovd  %esi,%k1
   631f5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   631fb:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   63201:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   63205:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   6320b:	c5 fd 6f 1d ad 58 fa 	vmovdqa -0x5a753(%rip),%ymm3        # 8ac0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   63212:	ff 
   63213:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   63219:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   6321f:	c5 f8 44 c8          	knotw  %k0,%k1
   63223:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   63229:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   6322e:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   63233:	0f 92 c0             	setb   %al
   63236:	0f b6 c0             	movzbl %al,%eax
   63239:	89 01                	mov    %eax,(%rcx)
   6323b:	48 83 c4 48          	add    $0x48,%rsp
   6323f:	c5 f8 77             	vzeroupper
   63242:	c3                   	ret
   63243:	48 8d 05 76 17 05 00 	lea    0x51776(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   6324a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   6324f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   63256:	00 00 
   63258:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   6325f:	00 00 
   63261:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   63265:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   6326b:	4c 8d 05 f6 23 05 00 	lea    0x523f6(%rip),%r8        # b5668 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe98>
   63272:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   63277:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   6327c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   63281:	31 ff                	xor    %edi,%edi
   63283:	ff 15 67 55 05 00    	call   *0x55567(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   63289:	48 8d 15 78 1f 05 00 	lea    0x51f78(%rip),%rdx        # b5208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa38>
   63290:	ff 15 e2 53 05 00    	call   *0x553e2(%rip)        # b8678 <_DYNAMIC+0x260>
   63296:	cc                   	int3
   63297:	cc                   	int3
   63298:	cc                   	int3
   63299:	cc                   	int3
   6329a:	cc                   	int3
   6329b:	cc                   	int3
   6329c:	cc                   	int3
   6329d:	cc                   	int3
   6329e:	cc                   	int3
   6329f:	cc                   	int3

