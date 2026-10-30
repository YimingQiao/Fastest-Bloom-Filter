00000000000606b0 <compare_benchmark::lookup>:
   606b0:	48 83 ec 48          	sub    $0x48,%rsp
   606b4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   606b9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   606be:	4c 39 c2             	cmp    %r8,%rdx
   606c1:	75 77                	jne    6073a <compare_benchmark::lookup+0x8a>
   606c3:	48 83 fa 01          	cmp    $0x1,%rdx
   606c7:	75 65                	jne    6072e <compare_benchmark::lookup+0x7e>
   606c9:	48 8b 16             	mov    (%rsi),%rdx
   606cc:	48 89 d6             	mov    %rdx,%rsi
   606cf:	48 c1 ee 20          	shr    $0x20,%rsi
   606d3:	8b 47 20             	mov    0x20(%rdi),%eax
   606d6:	48 0f af c6          	imul   %rsi,%rax
   606da:	48 c1 e8 20          	shr    $0x20,%rax
   606de:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   606e2:	48 39 f0             	cmp    %rsi,%rax
   606e5:	0f 83 95 00 00 00    	jae    60780 <compare_benchmark::lookup+0xd0>
   606eb:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   606ef:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   606f5:	c4 e2 7d 40 05 e2 83 	vpmulld -0x57c1e(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   606fc:	fa ff 
   606fe:	48 c1 e0 05          	shl    $0x5,%rax
   60702:	c5 fe 6f 0c 06       	vmovdqu (%rsi,%rax,1),%ymm1
   60707:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   6070c:	c4 e2 7d 58 15 73 81 	vpbroadcastd -0x57e8d(%rip),%ymm2        # 8888 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x173>
   60713:	fa ff 
   60715:	c4 e2 6d 47 c0       	vpsllvd %ymm0,%ymm2,%ymm0
   6071a:	31 c0                	xor    %eax,%eax
   6071c:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   60721:	0f 92 c0             	setb   %al
   60724:	89 01                	mov    %eax,(%rcx)
   60726:	48 83 c4 48          	add    $0x48,%rsp
   6072a:	c5 f8 77             	vzeroupper
   6072d:	c3                   	ret
   6072e:	49 89 d0             	mov    %rdx,%r8
   60731:	48 83 c4 48          	add    $0x48,%rsp
   60735:	e9 b6 5d 00 00       	jmp    664f0 <<compare_benchmark::BloomsdayPinned as compare_benchmark::Filter>::lookup_hashes>
   6073a:	48 8d 05 7f 42 05 00 	lea    0x5427f(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   60741:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   60746:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   6074d:	00 00 
   6074f:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   60756:	00 00 
   60758:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   6075c:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   60762:	4c 8d 05 cf 4e 05 00 	lea    0x54ecf(%rip),%r8        # b5638 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe68>
   60769:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   6076e:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   60773:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   60778:	31 ff                	xor    %edi,%edi
   6077a:	ff 15 70 80 05 00    	call   *0x58070(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   60780:	48 8d 15 41 4f 05 00 	lea    0x54f41(%rip),%rdx        # b56c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xef8>
   60787:	48 89 c7             	mov    %rax,%rdi
   6078a:	ff 15 e8 7e 05 00    	call   *0x57ee8(%rip)        # b8678 <_DYNAMIC+0x260>

