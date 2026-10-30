00000000000616e0 <compare_benchmark::lookup>:
   616e0:	48 83 ec 48          	sub    $0x48,%rsp
   616e4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   616e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   616ee:	4c 39 c2             	cmp    %r8,%rdx
   616f1:	0f 85 8c 00 00 00    	jne    61783 <compare_benchmark::lookup+0xa3>
   616f7:	48 83 fa 01          	cmp    $0x1,%rdx
   616fb:	75 79                	jne    61776 <compare_benchmark::lookup+0x96>
   616fd:	48 8b 16             	mov    (%rsi),%rdx
   61700:	48 89 d0             	mov    %rdx,%rax
   61703:	48 c1 e8 20          	shr    $0x20,%rax
   61707:	23 47 18             	and    0x18(%rdi),%eax
   6170a:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   6170e:	48 39 c6             	cmp    %rax,%rsi
   61711:	0f 86 b2 00 00 00    	jbe    617c9 <compare_benchmark::lookup+0xe9>
   61717:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   6171d:	62 f2 fd 48 40 05 19 	vpmullq -0x57fe7(%rip),%zmm0,%zmm0        # 9740 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x560>
   61724:	80 fa ff 
   61727:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   6172b:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   61732:	62 f1 fd 58 db 05 d4 	vpandq -0x58d2c(%rip){1to8},%zmm0,%zmm0        # 8a10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x40>
   61739:	72 fa ff 
   6173c:	48 c1 e0 06          	shl    $0x6,%rax
   61740:	62 f2 fd 48 59 0d 56 	vpbroadcastq -0x58daa(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   61747:	72 fa ff 
   6174a:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   61750:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   61757:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   6175d:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   61763:	31 c0                	xor    %eax,%eax
   61765:	c5 f8 98 c0          	kortestw %k0,%k0
   61769:	0f 94 c0             	sete   %al
   6176c:	89 01                	mov    %eax,(%rcx)
   6176e:	48 83 c4 48          	add    $0x48,%rsp
   61772:	c5 f8 77             	vzeroupper
   61775:	c3                   	ret
   61776:	49 89 d0             	mov    %rdx,%r8
   61779:	48 83 c4 48          	add    $0x48,%rsp
   6177d:	ff 25 7d 70 05 00    	jmp    *0x5707d(%rip)        # b8800 <_DYNAMIC+0x3e8>
   61783:	48 8d 05 36 32 05 00 	lea    0x53236(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   6178a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   6178f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61796:	00 00 
   61798:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   6179f:	00 00 
   617a1:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   617a5:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   617ab:	4c 8d 05 a6 3b 05 00 	lea    0x53ba6(%rip),%r8        # b5358 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb88>
   617b2:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   617b7:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   617bc:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   617c1:	31 ff                	xor    %edi,%edi
   617c3:	ff 15 27 70 05 00    	call   *0x57027(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   617c9:	48 8d 15 a0 3b 05 00 	lea    0x53ba0(%rip),%rdx        # b5370 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xba0>
   617d0:	48 89 c7             	mov    %rax,%rdi
   617d3:	ff 15 9f 6e 05 00    	call   *0x56e9f(%rip)        # b8678 <_DYNAMIC+0x260>
   617d9:	cc                   	int3
   617da:	cc                   	int3
   617db:	cc                   	int3
   617dc:	cc                   	int3
   617dd:	cc                   	int3
   617de:	cc                   	int3
   617df:	cc                   	int3

