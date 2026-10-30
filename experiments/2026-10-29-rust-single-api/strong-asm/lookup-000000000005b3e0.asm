000000000005b3e0 <compare_benchmark::lookup>:
   5b3e0:	48 83 ec 48          	sub    $0x48,%rsp
   5b3e4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5b3e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   5b3ee:	4c 39 c2             	cmp    %r8,%rdx
   5b3f1:	75 77                	jne    5b46a <compare_benchmark::lookup+0x8a>
   5b3f3:	48 83 fa 01          	cmp    $0x1,%rdx
   5b3f7:	75 65                	jne    5b45e <compare_benchmark::lookup+0x7e>
   5b3f9:	48 8b 16             	mov    (%rsi),%rdx
   5b3fc:	48 89 d6             	mov    %rdx,%rsi
   5b3ff:	48 c1 ee 20          	shr    $0x20,%rsi
   5b403:	8b 47 20             	mov    0x20(%rdi),%eax
   5b406:	48 0f af c6          	imul   %rsi,%rax
   5b40a:	48 c1 e8 20          	shr    $0x20,%rax
   5b40e:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   5b412:	48 39 f0             	cmp    %rsi,%rax
   5b415:	0f 83 95 00 00 00    	jae    5b4b0 <compare_benchmark::lookup+0xd0>
   5b41b:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   5b41f:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   5b425:	c4 e2 7d 40 05 32 d3 	vpmulld -0x52cce(%rip),%ymm0,%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   5b42c:	fa ff 
   5b42e:	48 c1 e0 05          	shl    $0x5,%rax
   5b432:	c5 fe 6f 0c 06       	vmovdqu (%rsi,%rax,1),%ymm1
   5b437:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   5b43c:	c4 e2 7d 58 15 ab d0 	vpbroadcastd -0x52f55(%rip),%ymm2        # 84f0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x174>
   5b443:	fa ff 
   5b445:	c4 e2 6d 47 c0       	vpsllvd %ymm0,%ymm2,%ymm0
   5b44a:	31 c0                	xor    %eax,%eax
   5b44c:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   5b451:	0f 92 c0             	setb   %al
   5b454:	89 01                	mov    %eax,(%rcx)
   5b456:	48 83 c4 48          	add    $0x48,%rsp
   5b45a:	c5 f8 77             	vzeroupper
   5b45d:	c3                   	ret
   5b45e:	49 89 d0             	mov    %rdx,%r8
   5b461:	48 83 c4 48          	add    $0x48,%rsp
   5b465:	e9 a6 32 00 00       	jmp    5e710 <<compare_benchmark::BloomsdayPinned as compare_benchmark::Filter>::lookup_hashes>
   5b46a:	48 8d 05 af 04 05 00 	lea    0x504af(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5b471:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5b476:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5b47d:	00 00 
   5b47f:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5b486:	00 00 
   5b488:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5b48c:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5b492:	4c 8d 05 07 10 05 00 	lea    0x51007(%rip),%r8        # ac4a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xd70>
   5b499:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5b49e:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5b4a3:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5b4a8:	31 ff                	xor    %edi,%edi
   5b4aa:	ff 15 88 40 05 00    	call   *0x54088(%rip)        # af538 <_DYNAMIC+0x3a8>
   5b4b0:	48 8d 15 79 10 05 00 	lea    0x51079(%rip),%rdx        # ac530 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe00>
   5b4b7:	48 89 c7             	mov    %rax,%rdi
   5b4ba:	ff 15 00 3f 05 00    	call   *0x53f00(%rip)        # af3c0 <_DYNAMIC+0x230>

