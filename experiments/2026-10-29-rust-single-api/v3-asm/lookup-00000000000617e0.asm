00000000000617e0 <compare_benchmark::lookup>:
   617e0:	48 83 ec 48          	sub    $0x48,%rsp
   617e4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   617e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   617ee:	4c 39 c2             	cmp    %r8,%rdx
   617f1:	0f 85 8c 00 00 00    	jne    61883 <compare_benchmark::lookup+0xa3>
   617f7:	48 83 fa 01          	cmp    $0x1,%rdx
   617fb:	75 79                	jne    61876 <compare_benchmark::lookup+0x96>
   617fd:	48 8b 16             	mov    (%rsi),%rdx
   61800:	48 89 d0             	mov    %rdx,%rax
   61803:	48 c1 e8 20          	shr    $0x20,%rax
   61807:	23 47 18             	and    0x18(%rdi),%eax
   6180a:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   6180e:	48 39 c6             	cmp    %rax,%rsi
   61811:	0f 86 b2 00 00 00    	jbe    618c9 <compare_benchmark::lookup+0xe9>
   61817:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   6181d:	62 f2 fd 48 40 05 59 	vpmullq -0x580a7(%rip),%zmm0,%zmm0        # 9780 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x5a0>
   61824:	7f fa ff 
   61827:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   6182b:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   61832:	62 f1 fd 58 db 05 d4 	vpandq -0x58e2c(%rip){1to8},%zmm0,%zmm0        # 8a10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x40>
   61839:	71 fa ff 
   6183c:	48 c1 e0 06          	shl    $0x6,%rax
   61840:	62 f2 fd 48 59 0d 56 	vpbroadcastq -0x58eaa(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   61847:	71 fa ff 
   6184a:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   61850:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   61857:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   6185d:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   61863:	31 c0                	xor    %eax,%eax
   61865:	c5 f8 98 c0          	kortestw %k0,%k0
   61869:	0f 94 c0             	sete   %al
   6186c:	89 01                	mov    %eax,(%rcx)
   6186e:	48 83 c4 48          	add    $0x48,%rsp
   61872:	c5 f8 77             	vzeroupper
   61875:	c3                   	ret
   61876:	49 89 d0             	mov    %rdx,%r8
   61879:	48 83 c4 48          	add    $0x48,%rsp
   6187d:	ff 25 85 6f 05 00    	jmp    *0x56f85(%rip)        # b8808 <_DYNAMIC+0x3f0>
   61883:	48 8d 05 36 31 05 00 	lea    0x53136(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   6188a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   6188f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61896:	00 00 
   61898:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   6189f:	00 00 
   618a1:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   618a5:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   618ab:	4c 8d 05 66 3b 05 00 	lea    0x53b66(%rip),%r8        # b5418 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc48>
   618b2:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   618b7:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   618bc:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   618c1:	31 ff                	xor    %edi,%edi
   618c3:	ff 15 27 6f 05 00    	call   *0x56f27(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   618c9:	48 8d 15 60 3b 05 00 	lea    0x53b60(%rip),%rdx        # b5430 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc60>
   618d0:	48 89 c7             	mov    %rax,%rdi
   618d3:	ff 15 9f 6d 05 00    	call   *0x56d9f(%rip)        # b8678 <_DYNAMIC+0x260>
   618d9:	cc                   	int3
   618da:	cc                   	int3
   618db:	cc                   	int3
   618dc:	cc                   	int3
   618dd:	cc                   	int3
   618de:	cc                   	int3
   618df:	cc                   	int3

