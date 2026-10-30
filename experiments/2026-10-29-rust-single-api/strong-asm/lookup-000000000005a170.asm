000000000005a170 <compare_benchmark::lookup>:
   5a170:	48 83 ec 48          	sub    $0x48,%rsp
   5a174:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5a179:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   5a17e:	4c 39 c2             	cmp    %r8,%rdx
   5a181:	0f 85 8c 00 00 00    	jne    5a213 <compare_benchmark::lookup+0xa3>
   5a187:	48 83 fa 01          	cmp    $0x1,%rdx
   5a18b:	75 79                	jne    5a206 <compare_benchmark::lookup+0x96>
   5a18d:	48 8b 16             	mov    (%rsi),%rdx
   5a190:	48 89 d0             	mov    %rdx,%rax
   5a193:	48 c1 e8 20          	shr    $0x20,%rax
   5a197:	23 47 18             	and    0x18(%rdi),%eax
   5a19a:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   5a19e:	48 39 c6             	cmp    %rax,%rsi
   5a1a1:	0f 86 b2 00 00 00    	jbe    5a259 <compare_benchmark::lookup+0xe9>
   5a1a7:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   5a1ad:	62 f2 fd 48 40 05 09 	vpmullq -0x50df7(%rip),%zmm0,%zmm0        # 93c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x590>
   5a1b4:	f2 fa ff 
   5a1b7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   5a1bb:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   5a1c2:	62 f1 fd 58 db 05 bc 	vpandq -0x51b44(%rip){1to8},%zmm0,%zmm0        # 8688 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x38>
   5a1c9:	e4 fa ff 
   5a1cc:	48 c1 e0 06          	shl    $0x6,%rax
   5a1d0:	62 f2 fd 48 59 0d 46 	vpbroadcastq -0x51bba(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   5a1d7:	e4 fa ff 
   5a1da:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   5a1e0:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   5a1e7:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   5a1ed:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   5a1f3:	31 c0                	xor    %eax,%eax
   5a1f5:	c5 f8 98 c0          	kortestw %k0,%k0
   5a1f9:	0f 94 c0             	sete   %al
   5a1fc:	89 01                	mov    %eax,(%rcx)
   5a1fe:	48 83 c4 48          	add    $0x48,%rsp
   5a202:	c5 f8 77             	vzeroupper
   5a205:	c3                   	ret
   5a206:	49 89 d0             	mov    %rdx,%r8
   5a209:	48 83 c4 48          	add    $0x48,%rsp
   5a20d:	ff 25 4d 53 05 00    	jmp    *0x5534d(%rip)        # af560 <_DYNAMIC+0x3d0>
   5a213:	48 8d 05 06 17 05 00 	lea    0x51706(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5a21a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5a21f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5a226:	00 00 
   5a228:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5a22f:	00 00 
   5a231:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5a235:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5a23b:	4c 8d 05 de 1f 05 00 	lea    0x51fde(%rip),%r8        # ac220 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xaf0>
   5a242:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5a247:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5a24c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5a251:	31 ff                	xor    %edi,%edi
   5a253:	ff 15 df 52 05 00    	call   *0x552df(%rip)        # af538 <_DYNAMIC+0x3a8>
   5a259:	48 8d 15 d8 1f 05 00 	lea    0x51fd8(%rip),%rdx        # ac238 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb08>
   5a260:	48 89 c7             	mov    %rax,%rdi
   5a263:	ff 15 57 51 05 00    	call   *0x55157(%rip)        # af3c0 <_DYNAMIC+0x230>
   5a269:	cc                   	int3
   5a26a:	cc                   	int3
   5a26b:	cc                   	int3
   5a26c:	cc                   	int3
   5a26d:	cc                   	int3
   5a26e:	cc                   	int3
   5a26f:	cc                   	int3

