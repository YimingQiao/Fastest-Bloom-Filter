
/tmp/fastest-bf-rust-single-api/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

00000000000493e0 <compare_benchmark::lookup>:
   493e0:	55                   	push   %rbp
   493e1:	41 57                	push   %r15
   493e3:	41 56                	push   %r14
   493e5:	41 55                	push   %r13
   493e7:	41 54                	push   %r12
   493e9:	53                   	push   %rbx
   493ea:	48 83 ec 48          	sub    $0x48,%rsp
   493ee:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   493f3:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   493f8:	4c 39 c2             	cmp    %r8,%rdx
   493fb:	0f 85 ca 04 00 00    	jne    498cb <compare_benchmark::lookup+0x4eb>
   49401:	48 89 cb             	mov    %rcx,%rbx
   49404:	49 89 d7             	mov    %rdx,%r15
   49407:	49 89 f6             	mov    %rsi,%r14
   4940a:	49 89 fc             	mov    %rdi,%r12
   4940d:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   49411:	48 83 fa 01          	cmp    $0x1,%rdx
   49415:	75 5e                	jne    49475 <compare_benchmark::lookup+0x95>
   49417:	84 c0                	test   %al,%al
   49419:	0f 84 91 01 00 00    	je     495b0 <compare_benchmark::lookup+0x1d0>
   4941f:	49 8b 06             	mov    (%r14),%rax
   49422:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   49427:	62 f2 7d 28 7c c0    	vpbroadcastd %eax,%ymm0
   4942d:	48 c1 e8 20          	shr    $0x20,%rax
   49431:	41 23 44 24 18       	and    0x18(%r12),%eax
   49436:	48 c1 e0 06          	shl    $0x6,%rax
   4943a:	c4 e2 7d 40 05 5d ef 	vpmulld -0x410a3(%rip),%ymm0,%ymm0        # 83a0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   49441:	fb ff 
   49443:	62 f1 fd 48 6f 0c 01 	vmovdqa64 (%rcx,%rax,1),%zmm1
   4944a:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   4944f:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   49455:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   4945b:	62 f2 fe 58 27 05 fb 	vptestnmq -0x41205(%rip){1to8},%zmm0,%k0        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   49462:	ed fb ff 
   49465:	31 c0                	xor    %eax,%eax
   49467:	c5 f9 98 c0          	kortestb %k0,%k0
   4946b:	0f 94 c0             	sete   %al
   4946e:	89 03                	mov    %eax,(%rbx)
   49470:	e9 44 04 00 00       	jmp    498b9 <compare_benchmark::lookup+0x4d9>
   49475:	84 c0                	test   %al,%al
   49477:	0f 84 b0 01 00 00    	je     4962d <compare_benchmark::lookup+0x24d>
   4947d:	49 83 ff 10          	cmp    $0x10,%r15
   49481:	0f 83 d5 01 00 00    	jae    4965c <compare_benchmark::lookup+0x27c>
   49487:	4d 85 ff             	test   %r15,%r15
   4948a:	0f 84 29 04 00 00    	je     498b9 <compare_benchmark::lookup+0x4d9>
   49490:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   49495:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4949a:	42 8d 34 bd 00 00 00 	lea    0x0(,%r15,4),%esi
   494a1:	00 
   494a2:	83 e6 38             	and    $0x38,%esi
   494a5:	31 c0                	xor    %eax,%eax
   494a7:	62 f1 fd 48 6f 05 cf 	vmovdqa64 -0x40731(%rip),%zmm0        # 8d80 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x370>
   494ae:	f8 fb ff 
   494b1:	62 f2 fd 48 59 0d a5 	vpbroadcastq -0x4125b(%rip),%zmm1        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   494b8:	ed fb ff 
   494bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   494c0:	49 8b 3c 46          	mov    (%r14,%rax,2),%rdi
   494c4:	41 89 f8             	mov    %edi,%r8d
   494c7:	48 c1 ef 20          	shr    $0x20,%rdi
   494cb:	21 d7                	and    %edx,%edi
   494cd:	48 c1 e7 06          	shl    $0x6,%rdi
   494d1:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   494d7:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   494dd:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   494e4:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   494eb:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   494f1:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   494f7:	31 ff                	xor    %edi,%edi
   494f9:	c5 f9 98 c0          	kortestb %k0,%k0
   494fd:	40 0f 94 c7          	sete   %dil
   49501:	89 3c 03             	mov    %edi,(%rbx,%rax,1)
   49504:	49 8b 7c 46 08       	mov    0x8(%r14,%rax,2),%rdi
   49509:	41 89 f8             	mov    %edi,%r8d
   4950c:	48 c1 ef 20          	shr    $0x20,%rdi
   49510:	21 d7                	and    %edx,%edi
   49512:	48 c1 e7 06          	shl    $0x6,%rdi
   49516:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   4951c:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   49522:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   49529:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   49530:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   49536:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4953c:	31 ff                	xor    %edi,%edi
   4953e:	c5 f9 98 c0          	kortestb %k0,%k0
   49542:	40 0f 94 c7          	sete   %dil
   49546:	89 7c 03 04          	mov    %edi,0x4(%rbx,%rax,1)
   4954a:	48 83 c0 08          	add    $0x8,%rax
   4954e:	48 39 c6             	cmp    %rax,%rsi
   49551:	0f 85 69 ff ff ff    	jne    494c0 <compare_benchmark::lookup+0xe0>
   49557:	41 f6 c7 01          	test   $0x1,%r15b
   4955b:	0f 84 58 03 00 00    	je     498b9 <compare_benchmark::lookup+0x4d9>
   49561:	49 8b 34 46          	mov    (%r14,%rax,2),%rsi
   49565:	89 f7                	mov    %esi,%edi
   49567:	48 c1 ee 20          	shr    $0x20,%rsi
   4956b:	21 f2                	and    %esi,%edx
   4956d:	62 f2 fd 48 7c c7    	vpbroadcastq %rdi,%zmm0
   49573:	62 f2 7d 48 40 05 03 	vpmulld -0x407fd(%rip),%zmm0,%zmm0        # 8d80 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x370>
   4957a:	f8 fb ff 
   4957d:	48 c1 e2 06          	shl    $0x6,%rdx
   49581:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   49588:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   4958f:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   49595:	62 f2 fe 58 27 05 c1 	vptestnmq -0x4133f(%rip){1to8},%zmm0,%k0        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   4959c:	ec fb ff 
   4959f:	31 c9                	xor    %ecx,%ecx
   495a1:	c5 f9 98 c0          	kortestb %k0,%k0
   495a5:	0f 94 c1             	sete   %cl
   495a8:	89 0c 03             	mov    %ecx,(%rbx,%rax,1)
   495ab:	e9 09 03 00 00       	jmp    498b9 <compare_benchmark::lookup+0x4d9>
   495b0:	49 8b 36             	mov    (%r14),%rsi
   495b3:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   495b9:	0f 84 68 01 00 00    	je     49727 <compare_benchmark::lookup+0x347>
   495bf:	49 8b 44 24 08       	mov    0x8(%r12),%rax
   495c4:	48 89 f1             	mov    %rsi,%rcx
   495c7:	48 c1 e9 20          	shr    $0x20,%rcx
   495cb:	41 23 4c 24 18       	and    0x18(%r12),%ecx
   495d0:	48 c1 e1 06          	shl    $0x6,%rcx
   495d4:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   495da:	c4 e2 7d 40 05 bd ed 	vpmulld -0x41243(%rip),%ymm0,%ymm0        # 83a0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   495e1:	fb ff 
   495e3:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   495e8:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   495ed:	c4 e2 7d 59 15 6a ec 	vpbroadcastq -0x41396(%rip),%ymm2        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   495f4:	fb ff 
   495f6:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   495fb:	c5 fd 6f 1c 08       	vmovdqa (%rax,%rcx,1),%ymm3
   49600:	c4 e2 7d 17 d9       	vptest %ymm1,%ymm3
   49605:	0f 92 c2             	setb   %dl
   49608:	c5 fd 6f 4c 08 20    	vmovdqa 0x20(%rax,%rcx,1),%ymm1
   4960e:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   49614:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   49619:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   4961e:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   49623:	0f 92 c0             	setb   %al
   49626:	20 d0                	and    %dl,%al
   49628:	e9 02 01 00 00       	jmp    4972f <compare_benchmark::lookup+0x34f>
   4962d:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   49633:	0f 84 00 01 00 00    	je     49739 <compare_benchmark::lookup+0x359>
   49639:	4c 89 e7             	mov    %r12,%rdi
   4963c:	4c 89 f6             	mov    %r14,%rsi
   4963f:	4c 89 fa             	mov    %r15,%rdx
   49642:	48 89 d9             	mov    %rbx,%rcx
   49645:	4d 89 f8             	mov    %r15,%r8
   49648:	48 83 c4 48          	add    $0x48,%rsp
   4964c:	5b                   	pop    %rbx
   4964d:	41 5c                	pop    %r12
   4964f:	41 5d                	pop    %r13
   49651:	41 5e                	pop    %r14
   49653:	41 5f                	pop    %r15
   49655:	5d                   	pop    %rbp
   49656:	ff 25 64 4b 05 00    	jmp    *0x54b64(%rip)        # 9e1c0 <_DYNAMIC+0x3a8>
   4965c:	31 c0                	xor    %eax,%eax
   4965e:	4c 89 f9             	mov    %r15,%rcx
   49661:	48 83 e9 20          	sub    $0x20,%rcx
   49665:	48 0f 43 c1          	cmovae %rcx,%rax
   49669:	0f 86 94 00 00 00    	jbe    49703 <compare_benchmark::lookup+0x323>
   4966f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   49674:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   49679:	bf 20 00 00 00       	mov    $0x20,%edi
   4967e:	c5 fd 6f 05 1a ed fb 	vmovdqa -0x412e6(%rip),%ymm0        # 83a0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   49685:	ff 
   49686:	62 f2 fd 48 59 0d d0 	vpbroadcastq -0x41430(%rip),%zmm1        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   4968d:	eb fb ff 
   49690:	49 39 ff             	cmp    %rdi,%r15
   49693:	0f 84 78 02 00 00    	je     49911 <compare_benchmark::lookup+0x531>
   49699:	49 8b b4 fe 00 ff ff 	mov    -0x100(%r14,%rdi,8),%rsi
   496a0:	ff 
   496a1:	45 8b 44 fe 04       	mov    0x4(%r14,%rdi,8),%r8d
   496a6:	41 21 d0             	and    %edx,%r8d
   496a9:	49 c1 e0 06          	shl    $0x6,%r8
   496ad:	42 0f 18 0c 01       	prefetcht0 (%rcx,%r8,1)
   496b2:	62 f2 7d 28 7c d6    	vpbroadcastd %esi,%ymm2
   496b8:	48 c1 ee 20          	shr    $0x20,%rsi
   496bc:	21 d6                	and    %edx,%esi
   496be:	48 c1 e6 06          	shl    $0x6,%rsi
   496c2:	62 f1 fd 48 6f 1c 31 	vmovdqa64 (%rcx,%rsi,1),%zmm3
   496c9:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   496ce:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   496d3:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   496d9:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   496df:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   496e5:	31 f6                	xor    %esi,%esi
   496e7:	c5 f9 98 c0          	kortestb %k0,%k0
   496eb:	40 0f 94 c6          	sete   %sil
   496ef:	89 74 bb 80          	mov    %esi,-0x80(%rbx,%rdi,4)
   496f3:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   496f7:	48 83 c7 e1          	add    $0xffffffffffffffe1,%rdi
   496fb:	48 39 c7             	cmp    %rax,%rdi
   496fe:	48 89 f7             	mov    %rsi,%rdi
   49701:	72 8d                	jb     49690 <compare_benchmark::lookup+0x2b0>
   49703:	4c 89 fe             	mov    %r15,%rsi
   49706:	48 29 c6             	sub    %rax,%rsi
   49709:	0f 84 aa 01 00 00    	je     498b9 <compare_benchmark::lookup+0x4d9>
   4970f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   49714:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   49719:	48 83 fe 01          	cmp    $0x1,%rsi
   4971d:	75 55                	jne    49774 <compare_benchmark::lookup+0x394>
   4971f:	45 31 d2             	xor    %r10d,%r10d
   49722:	e9 38 01 00 00       	jmp    4985f <compare_benchmark::lookup+0x47f>
   49727:	4c 89 e7             	mov    %r12,%rdi
   4972a:	e8 41 2a 00 00       	call   4c170 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   4972f:	0f b6 c0             	movzbl %al,%eax
   49732:	89 03                	mov    %eax,(%rbx)
   49734:	e9 80 01 00 00       	jmp    498b9 <compare_benchmark::lookup+0x4d9>
   49739:	4d 85 ff             	test   %r15,%r15
   4973c:	0f 84 77 01 00 00    	je     498b9 <compare_benchmark::lookup+0x4d9>
   49742:	45 31 ed             	xor    %r13d,%r13d
   49745:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   4974c:	00 00 00 00 
   49750:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   49754:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   49758:	4c 89 e7             	mov    %r12,%rdi
   4975b:	e8 10 2a 00 00       	call   4c170 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   49760:	0f b6 c0             	movzbl %al,%eax
   49763:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   49767:	49 89 ed             	mov    %rbp,%r13
   4976a:	49 39 ef             	cmp    %rbp,%r15
   4976d:	75 e1                	jne    49750 <compare_benchmark::lookup+0x370>
   4976f:	e9 45 01 00 00       	jmp    498b9 <compare_benchmark::lookup+0x4d9>
   49774:	48 89 f7             	mov    %rsi,%rdi
   49777:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
   4977b:	4c 8d 0c f5 00 00 00 	lea    0x0(,%rsi,8),%r9
   49782:	00 
   49783:	4f 8d 04 fe          	lea    (%r14,%r15,8),%r8
   49787:	4d 29 c8             	sub    %r9,%r8
   4978a:	49 83 c0 08          	add    $0x8,%r8
   4978e:	4c 8d 14 b5 00 00 00 	lea    0x0(,%rsi,4),%r10
   49795:	00 
   49796:	4e 8d 0c bb          	lea    (%rbx,%r15,4),%r9
   4979a:	4d 29 d1             	sub    %r10,%r9
   4979d:	49 83 c1 04          	add    $0x4,%r9
   497a1:	45 31 db             	xor    %r11d,%r11d
   497a4:	c5 fd 6f 05 f4 eb fb 	vmovdqa -0x4140c(%rip),%ymm0        # 83a0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   497ab:	ff 
   497ac:	62 f2 fd 48 59 0d aa 	vpbroadcastq -0x41556(%rip),%zmm1        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   497b3:	ea fb ff 
   497b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   497bd:	00 00 00 
   497c0:	4f 8b 54 d8 f8       	mov    -0x8(%r8,%r11,8),%r10
   497c5:	62 d2 7d 28 7c d2    	vpbroadcastd %r10d,%ymm2
   497cb:	49 c1 ea 20          	shr    $0x20,%r10
   497cf:	41 21 d2             	and    %edx,%r10d
   497d2:	49 c1 e2 06          	shl    $0x6,%r10
   497d6:	62 b1 fd 48 6f 1c 11 	vmovdqa64 (%rcx,%r10,1),%zmm3
   497dd:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   497e2:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   497e7:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   497ed:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   497f3:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   497f9:	45 31 d2             	xor    %r10d,%r10d
   497fc:	c5 f9 98 c0          	kortestb %k0,%k0
   49800:	41 0f 94 c2          	sete   %r10b
   49804:	47 89 54 99 fc       	mov    %r10d,-0x4(%r9,%r11,4)
   49809:	4d 8d 53 02          	lea    0x2(%r11),%r10
   4980d:	4f 8b 3c d8          	mov    (%r8,%r11,8),%r15
   49811:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   49817:	49 c1 ef 20          	shr    $0x20,%r15
   4981b:	41 21 d7             	and    %edx,%r15d
   4981e:	49 c1 e7 06          	shl    $0x6,%r15
   49822:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   49827:	62 b1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%r15,1),%zmm3
   4982e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   49833:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   49839:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4983f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   49845:	31 ed                	xor    %ebp,%ebp
   49847:	c5 f9 98 c0          	kortestb %k0,%k0
   4984b:	40 0f 94 c5          	sete   %bpl
   4984f:	43 89 2c 99          	mov    %ebp,(%r9,%r11,4)
   49853:	4d 89 d3             	mov    %r10,%r11
   49856:	4c 39 d7             	cmp    %r10,%rdi
   49859:	0f 85 61 ff ff ff    	jne    497c0 <compare_benchmark::lookup+0x3e0>
   4985f:	40 f6 c6 01          	test   $0x1,%sil
   49863:	74 54                	je     498b9 <compare_benchmark::lookup+0x4d9>
   49865:	49 8d 34 c6          	lea    (%r14,%rax,8),%rsi
   49869:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
   4986d:	4a 8b 34 d6          	mov    (%rsi,%r10,8),%rsi
   49871:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   49877:	48 c1 ee 20          	shr    $0x20,%rsi
   4987b:	21 f2                	and    %esi,%edx
   4987d:	48 c1 e2 06          	shl    $0x6,%rdx
   49881:	c4 e2 7d 40 05 16 eb 	vpmulld -0x414ea(%rip),%ymm0,%ymm0        # 83a0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   49888:	fb ff 
   4988a:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   49891:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   49896:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   4989c:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   498a2:	62 f2 fe 58 27 05 b4 	vptestnmq -0x4164c(%rip){1to8},%zmm0,%k0        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   498a9:	e9 fb ff 
   498ac:	31 c9                	xor    %ecx,%ecx
   498ae:	c5 f9 98 c0          	kortestb %k0,%k0
   498b2:	0f 94 c1             	sete   %cl
   498b5:	42 89 0c 90          	mov    %ecx,(%rax,%r10,4)
   498b9:	48 83 c4 48          	add    $0x48,%rsp
   498bd:	5b                   	pop    %rbx
   498be:	41 5c                	pop    %r12
   498c0:	41 5d                	pop    %r13
   498c2:	41 5e                	pop    %r14
   498c4:	41 5f                	pop    %r15
   498c6:	5d                   	pop    %rbp
   498c7:	c5 f8 77             	vzeroupper
   498ca:	c3                   	ret
   498cb:	48 8d 05 a6 0e 05 00 	lea    0x50ea6(%rip),%rax        # 9a778 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x178>
   498d2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   498d7:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   498de:	00 00 
   498e0:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   498e7:	00 00 
   498e9:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   498ed:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   498f3:	4c 8d 05 3e 17 05 00 	lea    0x5173e(%rip),%r8        # 9b038 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa38>
   498fa:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   498ff:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   49904:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   49909:	31 ff                	xor    %edi,%edi
   4990b:	ff 15 b7 48 05 00    	call   *0x548b7(%rip)        # 9e1c8 <_DYNAMIC+0x3b0>
   49911:	48 8d 15 00 25 05 00 	lea    0x52500(%rip),%rdx        # 9be18 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749>
   49918:	4c 89 fe             	mov    %r15,%rsi
   4991b:	c5 f8 77             	vzeroupper
   4991e:	ff 15 54 47 05 00    	call   *0x54754(%rip)        # 9e078 <_DYNAMIC+0x260>
   49924:	cc                   	int3
   49925:	cc                   	int3
   49926:	cc                   	int3
   49927:	cc                   	int3
   49928:	cc                   	int3
   49929:	cc                   	int3
   4992a:	cc                   	int3
   4992b:	cc                   	int3
   4992c:	cc                   	int3
   4992d:	cc                   	int3
   4992e:	cc                   	int3
   4992f:	cc                   	int3
