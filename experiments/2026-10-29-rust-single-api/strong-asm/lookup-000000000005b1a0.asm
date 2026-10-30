000000000005b1a0 <compare_benchmark::lookup>:
   5b1a0:	48 83 ec 48          	sub    $0x48,%rsp
   5b1a4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5b1a9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   5b1ae:	4c 39 c2             	cmp    %r8,%rdx
   5b1b1:	0f 85 8c 00 00 00    	jne    5b243 <compare_benchmark::lookup+0xa3>
   5b1b7:	48 83 fa 01          	cmp    $0x1,%rdx
   5b1bb:	75 79                	jne    5b236 <compare_benchmark::lookup+0x96>
   5b1bd:	48 8b 16             	mov    (%rsi),%rdx
   5b1c0:	48 89 d0             	mov    %rdx,%rax
   5b1c3:	48 c1 e8 20          	shr    $0x20,%rax
   5b1c7:	23 47 18             	and    0x18(%rdi),%eax
   5b1ca:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   5b1ce:	48 39 c6             	cmp    %rax,%rsi
   5b1d1:	0f 86 b2 00 00 00    	jbe    5b289 <compare_benchmark::lookup+0xe9>
   5b1d7:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   5b1dd:	62 f2 fd 48 40 05 99 	vpmullq -0x51c67(%rip),%zmm0,%zmm0        # 9580 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x750>
   5b1e4:	e3 fa ff 
   5b1e7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   5b1eb:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   5b1f2:	62 f1 fd 58 db 05 8c 	vpandq -0x52b74(%rip){1to8},%zmm0,%zmm0        # 8688 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x38>
   5b1f9:	d4 fa ff 
   5b1fc:	48 c1 e0 06          	shl    $0x6,%rax
   5b200:	62 f2 fd 48 59 0d 16 	vpbroadcastq -0x52bea(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   5b207:	d4 fa ff 
   5b20a:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   5b210:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   5b217:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   5b21d:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   5b223:	31 c0                	xor    %eax,%eax
   5b225:	c5 f8 98 c0          	kortestw %k0,%k0
   5b229:	0f 94 c0             	sete   %al
   5b22c:	89 01                	mov    %eax,(%rcx)
   5b22e:	48 83 c4 48          	add    $0x48,%rsp
   5b232:	c5 f8 77             	vzeroupper
   5b235:	c3                   	ret
   5b236:	49 89 d0             	mov    %rdx,%r8
   5b239:	48 83 c4 48          	add    $0x48,%rsp
   5b23d:	ff 25 05 43 05 00    	jmp    *0x54305(%rip)        # af548 <_DYNAMIC+0x3b8>
   5b243:	48 8d 05 d6 06 05 00 	lea    0x506d6(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5b24a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5b24f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5b256:	00 00 
   5b258:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5b25f:	00 00 
   5b261:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5b265:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5b26b:	4c 8d 05 76 12 05 00 	lea    0x51276(%rip),%r8        # ac4e8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xdb8>
   5b272:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5b277:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5b27c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5b281:	31 ff                	xor    %edi,%edi
   5b283:	ff 15 af 42 05 00    	call   *0x542af(%rip)        # af538 <_DYNAMIC+0x3a8>
   5b289:	48 8d 15 48 0f 05 00 	lea    0x50f48(%rip),%rdx        # ac1d8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xaa8>
   5b290:	48 89 c7             	mov    %rax,%rdi
   5b293:	ff 15 27 41 05 00    	call   *0x54127(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b299:	cc                   	int3
   5b29a:	cc                   	int3
   5b29b:	cc                   	int3
   5b29c:	cc                   	int3
   5b29d:	cc                   	int3
   5b29e:	cc                   	int3
   5b29f:	cc                   	int3

