0000000000059f20 <compare_benchmark::lookup>:
   59f20:	48 83 ec 48          	sub    $0x48,%rsp
   59f24:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   59f29:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   59f2e:	4c 39 c2             	cmp    %r8,%rdx
   59f31:	0f 85 bc 01 00 00    	jne    5a0f3 <compare_benchmark::lookup+0x1d3>
   59f37:	48 83 fa 01          	cmp    $0x1,%rdx
   59f3b:	75 46                	jne    59f83 <compare_benchmark::lookup+0x63>
   59f3d:	48 8b 16             	mov    (%rsi),%rdx
   59f40:	48 89 d0             	mov    %rdx,%rax
   59f43:	48 c1 e8 20          	shr    $0x20,%rax
   59f47:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   59f4b:	74 43                	je     59f90 <compare_benchmark::lookup+0x70>
   59f4d:	23 47 18             	and    0x18(%rdi),%eax
   59f50:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   59f54:	48 c1 e0 04          	shl    $0x4,%rax
   59f58:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   59f5d:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   59f63:	c5 f1 e5 0d 35 ed fa 	vpmulhw -0x512cb(%rip),%xmm1,%xmm1        # 8ca0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1b0>
   59f6a:	ff 
   59f6b:	c4 e2 79 59 15 54 e6 	vpbroadcastq -0x519ac(%rip),%xmm2        # 85c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x24c>
   59f72:	fa ff 
   59f74:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   59f79:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   59f7e:	e9 60 01 00 00       	jmp    5a0e3 <compare_benchmark::lookup+0x1c3>
   59f83:	49 89 d0             	mov    %rdx,%r8
   59f86:	48 83 c4 48          	add    $0x48,%rsp
   59f8a:	ff 25 c8 55 05 00    	jmp    *0x555c8(%rip)        # af558 <_DYNAMIC+0x3c8>
   59f90:	23 47 18             	and    0x18(%rdi),%eax
   59f93:	48 89 fe             	mov    %rdi,%rsi
   59f96:	89 c7                	mov    %eax,%edi
   59f98:	c1 ef 02             	shr    $0x2,%edi
   59f9b:	49 89 f0             	mov    %rsi,%r8
   59f9e:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   59fa2:	48 39 f7             	cmp    %rsi,%rdi
   59fa5:	0f 83 8e 01 00 00    	jae    5a139 <compare_benchmark::lookup+0x219>
   59fab:	48 c1 e7 06          	shl    $0x6,%rdi
   59faf:	49 03 78 08          	add    0x8(%r8),%rdi
   59fb3:	c1 e0 04             	shl    $0x4,%eax
   59fb6:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   59fba:	c1 e2 10             	shl    $0x10,%edx
   59fbd:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   59fc3:	83 e0 30             	and    $0x30,%eax
   59fc6:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   59fcb:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   59fd0:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   59fd4:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   59fda:	85 d2                	test   %edx,%edx
   59fdc:	0f 9f c2             	setg   %dl
   59fdf:	41 0f 98 c0          	sets   %r8b
   59fe3:	85 f6                	test   %esi,%esi
   59fe5:	41 0f 98 c1          	sets   %r9b
   59fe9:	c5 f5 f5 05 8f e7 fa 	vpmaddwd -0x51871(%rip),%ymm1,%ymm0        # 8780 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   59ff0:	ff 
   59ff1:	62 f1 fd 48 6f 0d 45 	vmovdqa64 -0x50cbb(%rip),%zmm1        # 9340 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x510>
   59ff8:	f3 fa ff 
   59ffb:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   5a001:	62 f2 7d 48 45 05 75 	vpsrlvd -0x50c8b(%rip),%zmm0,%zmm0        # 9380 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x550>
   5a008:	f3 fa ff 
   5a00b:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   5a011:	40 0f 9f c6          	setg   %sil
   5a015:	62 f1 7d 18 db 0d ad 	vpandd -0x51b53(%rip){1to4},%xmm0,%xmm1        # 84cc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x150>
   5a01c:	e4 fa ff 
   5a01f:	c5 fa 7e 15 b9 eb fa 	vmovq  -0x51447(%rip),%xmm2        # 8be0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0xf0>
   5a026:	ff 
   5a027:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   5a02b:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   5a030:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   5a035:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   5a03b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   5a040:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   5a046:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   5a04c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   5a050:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   5a055:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   5a05a:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   5a05e:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   5a063:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   5a069:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   5a06f:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   5a073:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   5a078:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   5a07d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   5a081:	c5 fb 92 ca          	kmovd  %edx,%k1
   5a085:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   5a08b:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   5a091:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   5a095:	66 ba 7f ff          	mov    $0xff7f,%dx
   5a099:	c5 fb 92 ca          	kmovd  %edx,%k1
   5a09d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   5a0a1:	c5 fb 92 ce          	kmovd  %esi,%k1
   5a0a5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   5a0ab:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   5a0b1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   5a0b5:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   5a0bb:	c5 fd 6f 1d 7d e6 fa 	vmovdqa -0x51983(%rip),%ymm3        # 8740 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   5a0c2:	ff 
   5a0c3:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   5a0c9:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   5a0cf:	c5 f8 44 c8          	knotw  %k0,%k1
   5a0d3:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   5a0d9:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   5a0de:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   5a0e3:	0f 92 c0             	setb   %al
   5a0e6:	0f b6 c0             	movzbl %al,%eax
   5a0e9:	89 01                	mov    %eax,(%rcx)
   5a0eb:	48 83 c4 48          	add    $0x48,%rsp
   5a0ef:	c5 f8 77             	vzeroupper
   5a0f2:	c3                   	ret
   5a0f3:	48 8d 05 26 18 05 00 	lea    0x51826(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5a0fa:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5a0ff:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5a106:	00 00 
   5a108:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5a10f:	00 00 
   5a111:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5a115:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5a11b:	4c 8d 05 ae 23 05 00 	lea    0x523ae(%rip),%r8        # ac4d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xda0>
   5a122:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5a127:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5a12c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5a131:	31 ff                	xor    %edi,%edi
   5a133:	ff 15 ff 53 05 00    	call   *0x553ff(%rip)        # af538 <_DYNAMIC+0x3a8>
   5a139:	48 8d 15 90 1f 05 00 	lea    0x51f90(%rip),%rdx        # ac0d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x9a0>
   5a140:	ff 15 7a 52 05 00    	call   *0x5527a(%rip)        # af3c0 <_DYNAMIC+0x230>
   5a146:	cc                   	int3
   5a147:	cc                   	int3
   5a148:	cc                   	int3
   5a149:	cc                   	int3
   5a14a:	cc                   	int3
   5a14b:	cc                   	int3
   5a14c:	cc                   	int3
   5a14d:	cc                   	int3
   5a14e:	cc                   	int3
   5a14f:	cc                   	int3

