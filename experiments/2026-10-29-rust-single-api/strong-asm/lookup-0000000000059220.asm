0000000000059220 <compare_benchmark::lookup>:
   59220:	55                   	push   %rbp
   59221:	41 57                	push   %r15
   59223:	41 56                	push   %r14
   59225:	41 55                	push   %r13
   59227:	41 54                	push   %r12
   59229:	53                   	push   %rbx
   5922a:	48 83 ec 48          	sub    $0x48,%rsp
   5922e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   59233:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   59238:	4c 39 c2             	cmp    %r8,%rdx
   5923b:	0f 85 ca 04 00 00    	jne    5970b <compare_benchmark::lookup+0x4eb>
   59241:	48 89 cb             	mov    %rcx,%rbx
   59244:	49 89 d7             	mov    %rdx,%r15
   59247:	49 89 f6             	mov    %rsi,%r14
   5924a:	49 89 fc             	mov    %rdi,%r12
   5924d:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   59251:	48 83 fa 01          	cmp    $0x1,%rdx
   59255:	75 5e                	jne    592b5 <compare_benchmark::lookup+0x95>
   59257:	84 c0                	test   %al,%al
   59259:	0f 84 91 01 00 00    	je     593f0 <compare_benchmark::lookup+0x1d0>
   5925f:	49 8b 06             	mov    (%r14),%rax
   59262:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   59267:	62 f2 7d 28 7c c0    	vpbroadcastd %eax,%ymm0
   5926d:	48 c1 e8 20          	shr    $0x20,%rax
   59271:	41 23 44 24 18       	and    0x18(%r12),%eax
   59276:	48 c1 e0 06          	shl    $0x6,%rax
   5927a:	c4 e2 7d 40 05 dd f4 	vpmulld -0x50b23(%rip),%ymm0,%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   59281:	fa ff 
   59283:	62 f1 fd 48 6f 0c 01 	vmovdqa64 (%rcx,%rax,1),%zmm1
   5928a:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   5928f:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   59295:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   5929b:	62 f2 fe 58 27 05 7b 	vptestnmq -0x50c85(%rip){1to8},%zmm0,%k0        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   592a2:	f3 fa ff 
   592a5:	31 c0                	xor    %eax,%eax
   592a7:	c5 f9 98 c0          	kortestb %k0,%k0
   592ab:	0f 94 c0             	sete   %al
   592ae:	89 03                	mov    %eax,(%rbx)
   592b0:	e9 44 04 00 00       	jmp    596f9 <compare_benchmark::lookup+0x4d9>
   592b5:	84 c0                	test   %al,%al
   592b7:	0f 84 b0 01 00 00    	je     5946d <compare_benchmark::lookup+0x24d>
   592bd:	49 83 ff 10          	cmp    $0x10,%r15
   592c1:	0f 83 d5 01 00 00    	jae    5949c <compare_benchmark::lookup+0x27c>
   592c7:	4d 85 ff             	test   %r15,%r15
   592ca:	0f 84 29 04 00 00    	je     596f9 <compare_benchmark::lookup+0x4d9>
   592d0:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   592d5:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   592da:	42 8d 34 bd 00 00 00 	lea    0x0(,%r15,4),%esi
   592e1:	00 
   592e2:	83 e6 38             	and    $0x38,%esi
   592e5:	31 c0                	xor    %eax,%eax
   592e7:	62 f1 fd 48 6f 05 4f 	vmovdqa64 -0x500b1(%rip),%zmm0        # 9240 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x410>
   592ee:	ff fa ff 
   592f1:	62 f2 fd 48 59 0d 25 	vpbroadcastq -0x50cdb(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   592f8:	f3 fa ff 
   592fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   59300:	49 8b 3c 46          	mov    (%r14,%rax,2),%rdi
   59304:	41 89 f8             	mov    %edi,%r8d
   59307:	48 c1 ef 20          	shr    $0x20,%rdi
   5930b:	21 d7                	and    %edx,%edi
   5930d:	48 c1 e7 06          	shl    $0x6,%rdi
   59311:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   59317:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   5931d:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   59324:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   5932b:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59331:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59337:	31 ff                	xor    %edi,%edi
   59339:	c5 f9 98 c0          	kortestb %k0,%k0
   5933d:	40 0f 94 c7          	sete   %dil
   59341:	89 3c 03             	mov    %edi,(%rbx,%rax,1)
   59344:	49 8b 7c 46 08       	mov    0x8(%r14,%rax,2),%rdi
   59349:	41 89 f8             	mov    %edi,%r8d
   5934c:	48 c1 ef 20          	shr    $0x20,%rdi
   59350:	21 d7                	and    %edx,%edi
   59352:	48 c1 e7 06          	shl    $0x6,%rdi
   59356:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   5935c:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   59362:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   59369:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   59370:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59376:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   5937c:	31 ff                	xor    %edi,%edi
   5937e:	c5 f9 98 c0          	kortestb %k0,%k0
   59382:	40 0f 94 c7          	sete   %dil
   59386:	89 7c 03 04          	mov    %edi,0x4(%rbx,%rax,1)
   5938a:	48 83 c0 08          	add    $0x8,%rax
   5938e:	48 39 c6             	cmp    %rax,%rsi
   59391:	0f 85 69 ff ff ff    	jne    59300 <compare_benchmark::lookup+0xe0>
   59397:	41 f6 c7 01          	test   $0x1,%r15b
   5939b:	0f 84 58 03 00 00    	je     596f9 <compare_benchmark::lookup+0x4d9>
   593a1:	49 8b 34 46          	mov    (%r14,%rax,2),%rsi
   593a5:	89 f7                	mov    %esi,%edi
   593a7:	48 c1 ee 20          	shr    $0x20,%rsi
   593ab:	21 f2                	and    %esi,%edx
   593ad:	62 f2 fd 48 7c c7    	vpbroadcastq %rdi,%zmm0
   593b3:	62 f2 7d 48 40 05 83 	vpmulld -0x5017d(%rip),%zmm0,%zmm0        # 9240 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x410>
   593ba:	fe fa ff 
   593bd:	48 c1 e2 06          	shl    $0x6,%rdx
   593c1:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   593c8:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   593cf:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   593d5:	62 f2 fe 58 27 05 41 	vptestnmq -0x50dbf(%rip){1to8},%zmm0,%k0        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   593dc:	f2 fa ff 
   593df:	31 c9                	xor    %ecx,%ecx
   593e1:	c5 f9 98 c0          	kortestb %k0,%k0
   593e5:	0f 94 c1             	sete   %cl
   593e8:	89 0c 03             	mov    %ecx,(%rbx,%rax,1)
   593eb:	e9 09 03 00 00       	jmp    596f9 <compare_benchmark::lookup+0x4d9>
   593f0:	49 8b 36             	mov    (%r14),%rsi
   593f3:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   593f9:	0f 84 68 01 00 00    	je     59567 <compare_benchmark::lookup+0x347>
   593ff:	49 8b 44 24 08       	mov    0x8(%r12),%rax
   59404:	48 89 f1             	mov    %rsi,%rcx
   59407:	48 c1 e9 20          	shr    $0x20,%rcx
   5940b:	41 23 4c 24 18       	and    0x18(%r12),%ecx
   59410:	48 c1 e1 06          	shl    $0x6,%rcx
   59414:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   5941a:	c4 e2 7d 40 05 3d f3 	vpmulld -0x50cc3(%rip),%ymm0,%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   59421:	fa ff 
   59423:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   59428:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   5942d:	c4 e2 7d 59 15 ea f1 	vpbroadcastq -0x50e16(%rip),%ymm2        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   59434:	fa ff 
   59436:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   5943b:	c5 fd 6f 1c 08       	vmovdqa (%rax,%rcx,1),%ymm3
   59440:	c4 e2 7d 17 d9       	vptest %ymm1,%ymm3
   59445:	0f 92 c2             	setb   %dl
   59448:	c5 fd 6f 4c 08 20    	vmovdqa 0x20(%rax,%rcx,1),%ymm1
   5944e:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   59454:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   59459:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   5945e:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   59463:	0f 92 c0             	setb   %al
   59466:	20 d0                	and    %dl,%al
   59468:	e9 02 01 00 00       	jmp    5956f <compare_benchmark::lookup+0x34f>
   5946d:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   59473:	0f 84 00 01 00 00    	je     59579 <compare_benchmark::lookup+0x359>
   59479:	4c 89 e7             	mov    %r12,%rdi
   5947c:	4c 89 f6             	mov    %r14,%rsi
   5947f:	4c 89 fa             	mov    %r15,%rdx
   59482:	48 89 d9             	mov    %rbx,%rcx
   59485:	4d 89 f8             	mov    %r15,%r8
   59488:	48 83 c4 48          	add    $0x48,%rsp
   5948c:	5b                   	pop    %rbx
   5948d:	41 5c                	pop    %r12
   5948f:	41 5d                	pop    %r13
   59491:	41 5e                	pop    %r14
   59493:	41 5f                	pop    %r15
   59495:	5d                   	pop    %rbp
   59496:	ff 25 a4 60 05 00    	jmp    *0x560a4(%rip)        # af540 <_DYNAMIC+0x3b0>
   5949c:	31 c0                	xor    %eax,%eax
   5949e:	4c 89 f9             	mov    %r15,%rcx
   594a1:	48 83 e9 20          	sub    $0x20,%rcx
   594a5:	48 0f 43 c1          	cmovae %rcx,%rax
   594a9:	0f 86 94 00 00 00    	jbe    59543 <compare_benchmark::lookup+0x323>
   594af:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   594b4:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   594b9:	bf 20 00 00 00       	mov    $0x20,%edi
   594be:	c5 fd 6f 05 9a f2 fa 	vmovdqa -0x50d66(%rip),%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   594c5:	ff 
   594c6:	62 f2 fd 48 59 0d 50 	vpbroadcastq -0x50eb0(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   594cd:	f1 fa ff 
   594d0:	49 39 ff             	cmp    %rdi,%r15
   594d3:	0f 84 78 02 00 00    	je     59751 <compare_benchmark::lookup+0x531>
   594d9:	49 8b b4 fe 00 ff ff 	mov    -0x100(%r14,%rdi,8),%rsi
   594e0:	ff 
   594e1:	45 8b 44 fe 04       	mov    0x4(%r14,%rdi,8),%r8d
   594e6:	41 21 d0             	and    %edx,%r8d
   594e9:	49 c1 e0 06          	shl    $0x6,%r8
   594ed:	42 0f 18 0c 01       	prefetcht0 (%rcx,%r8,1)
   594f2:	62 f2 7d 28 7c d6    	vpbroadcastd %esi,%ymm2
   594f8:	48 c1 ee 20          	shr    $0x20,%rsi
   594fc:	21 d6                	and    %edx,%esi
   594fe:	48 c1 e6 06          	shl    $0x6,%rsi
   59502:	62 f1 fd 48 6f 1c 31 	vmovdqa64 (%rcx,%rsi,1),%zmm3
   59509:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   5950e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59513:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   59519:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   5951f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59525:	31 f6                	xor    %esi,%esi
   59527:	c5 f9 98 c0          	kortestb %k0,%k0
   5952b:	40 0f 94 c6          	sete   %sil
   5952f:	89 74 bb 80          	mov    %esi,-0x80(%rbx,%rdi,4)
   59533:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   59537:	48 83 c7 e1          	add    $0xffffffffffffffe1,%rdi
   5953b:	48 39 c7             	cmp    %rax,%rdi
   5953e:	48 89 f7             	mov    %rsi,%rdi
   59541:	72 8d                	jb     594d0 <compare_benchmark::lookup+0x2b0>
   59543:	4c 89 fe             	mov    %r15,%rsi
   59546:	48 29 c6             	sub    %rax,%rsi
   59549:	0f 84 aa 01 00 00    	je     596f9 <compare_benchmark::lookup+0x4d9>
   5954f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   59554:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   59559:	48 83 fe 01          	cmp    $0x1,%rsi
   5955d:	75 55                	jne    595b4 <compare_benchmark::lookup+0x394>
   5955f:	45 31 d2             	xor    %r10d,%r10d
   59562:	e9 38 01 00 00       	jmp    5969f <compare_benchmark::lookup+0x47f>
   59567:	4c 89 e7             	mov    %r12,%rdi
   5956a:	e8 11 22 00 00       	call   5b780 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   5956f:	0f b6 c0             	movzbl %al,%eax
   59572:	89 03                	mov    %eax,(%rbx)
   59574:	e9 80 01 00 00       	jmp    596f9 <compare_benchmark::lookup+0x4d9>
   59579:	4d 85 ff             	test   %r15,%r15
   5957c:	0f 84 77 01 00 00    	je     596f9 <compare_benchmark::lookup+0x4d9>
   59582:	45 31 ed             	xor    %r13d,%r13d
   59585:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   5958c:	00 00 00 00 
   59590:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   59594:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   59598:	4c 89 e7             	mov    %r12,%rdi
   5959b:	e8 e0 21 00 00       	call   5b780 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   595a0:	0f b6 c0             	movzbl %al,%eax
   595a3:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   595a7:	49 89 ed             	mov    %rbp,%r13
   595aa:	49 39 ef             	cmp    %rbp,%r15
   595ad:	75 e1                	jne    59590 <compare_benchmark::lookup+0x370>
   595af:	e9 45 01 00 00       	jmp    596f9 <compare_benchmark::lookup+0x4d9>
   595b4:	48 89 f7             	mov    %rsi,%rdi
   595b7:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
   595bb:	4c 8d 0c f5 00 00 00 	lea    0x0(,%rsi,8),%r9
   595c2:	00 
   595c3:	4f 8d 04 fe          	lea    (%r14,%r15,8),%r8
   595c7:	4d 29 c8             	sub    %r9,%r8
   595ca:	49 83 c0 08          	add    $0x8,%r8
   595ce:	4c 8d 14 b5 00 00 00 	lea    0x0(,%rsi,4),%r10
   595d5:	00 
   595d6:	4e 8d 0c bb          	lea    (%rbx,%r15,4),%r9
   595da:	4d 29 d1             	sub    %r10,%r9
   595dd:	49 83 c1 04          	add    $0x4,%r9
   595e1:	45 31 db             	xor    %r11d,%r11d
   595e4:	c5 fd 6f 05 74 f1 fa 	vmovdqa -0x50e8c(%rip),%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   595eb:	ff 
   595ec:	62 f2 fd 48 59 0d 2a 	vpbroadcastq -0x50fd6(%rip),%zmm1        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   595f3:	f0 fa ff 
   595f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   595fd:	00 00 00 
   59600:	4f 8b 54 d8 f8       	mov    -0x8(%r8,%r11,8),%r10
   59605:	62 d2 7d 28 7c d2    	vpbroadcastd %r10d,%ymm2
   5960b:	49 c1 ea 20          	shr    $0x20,%r10
   5960f:	41 21 d2             	and    %edx,%r10d
   59612:	49 c1 e2 06          	shl    $0x6,%r10
   59616:	62 b1 fd 48 6f 1c 11 	vmovdqa64 (%rcx,%r10,1),%zmm3
   5961d:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   59622:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59627:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   5962d:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   59633:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59639:	45 31 d2             	xor    %r10d,%r10d
   5963c:	c5 f9 98 c0          	kortestb %k0,%k0
   59640:	41 0f 94 c2          	sete   %r10b
   59644:	47 89 54 99 fc       	mov    %r10d,-0x4(%r9,%r11,4)
   59649:	4d 8d 53 02          	lea    0x2(%r11),%r10
   5964d:	4f 8b 3c d8          	mov    (%r8,%r11,8),%r15
   59651:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   59657:	49 c1 ef 20          	shr    $0x20,%r15
   5965b:	41 21 d7             	and    %edx,%r15d
   5965e:	49 c1 e7 06          	shl    $0x6,%r15
   59662:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   59667:	62 b1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%r15,1),%zmm3
   5966e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   59673:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   59679:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   5967f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   59685:	31 ed                	xor    %ebp,%ebp
   59687:	c5 f9 98 c0          	kortestb %k0,%k0
   5968b:	40 0f 94 c5          	sete   %bpl
   5968f:	43 89 2c 99          	mov    %ebp,(%r9,%r11,4)
   59693:	4d 89 d3             	mov    %r10,%r11
   59696:	4c 39 d7             	cmp    %r10,%rdi
   59699:	0f 85 61 ff ff ff    	jne    59600 <compare_benchmark::lookup+0x3e0>
   5969f:	40 f6 c6 01          	test   $0x1,%sil
   596a3:	74 54                	je     596f9 <compare_benchmark::lookup+0x4d9>
   596a5:	49 8d 34 c6          	lea    (%r14,%rax,8),%rsi
   596a9:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
   596ad:	4a 8b 34 d6          	mov    (%rsi,%r10,8),%rsi
   596b1:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   596b7:	48 c1 ee 20          	shr    $0x20,%rsi
   596bb:	21 f2                	and    %esi,%edx
   596bd:	48 c1 e2 06          	shl    $0x6,%rdx
   596c1:	c4 e2 7d 40 05 96 f0 	vpmulld -0x50f6a(%rip),%ymm0,%ymm0        # 8760 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   596c8:	fa ff 
   596ca:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   596d1:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   596d6:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   596dc:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   596e2:	62 f2 fe 58 27 05 34 	vptestnmq -0x510cc(%rip){1to8},%zmm0,%k0        # 8620 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a4>
   596e9:	ef fa ff 
   596ec:	31 c9                	xor    %ecx,%ecx
   596ee:	c5 f9 98 c0          	kortestb %k0,%k0
   596f2:	0f 94 c1             	sete   %cl
   596f5:	42 89 0c 90          	mov    %ecx,(%rax,%r10,4)
   596f9:	48 83 c4 48          	add    $0x48,%rsp
   596fd:	5b                   	pop    %rbx
   596fe:	41 5c                	pop    %r12
   59700:	41 5d                	pop    %r13
   59702:	41 5e                	pop    %r14
   59704:	41 5f                	pop    %r15
   59706:	5d                   	pop    %rbp
   59707:	c5 f8 77             	vzeroupper
   5970a:	c3                   	ret
   5970b:	48 8d 05 0e 22 05 00 	lea    0x5220e(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   59712:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   59717:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5971e:	00 00 
   59720:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   59727:	00 00 
   59729:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5972d:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   59733:	4c 8d 05 46 2b 05 00 	lea    0x52b46(%rip),%r8        # ac280 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb50>
   5973a:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5973f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   59744:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   59749:	31 ff                	xor    %edi,%edi
   5974b:	ff 15 e7 5d 05 00    	call   *0x55de7(%rip)        # af538 <_DYNAMIC+0x3a8>
   59751:	48 8d 15 38 39 05 00 	lea    0x53938(%rip),%rdx        # ad090 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749>
   59758:	4c 89 fe             	mov    %r15,%rsi
   5975b:	c5 f8 77             	vzeroupper
   5975e:	ff 15 5c 5c 05 00    	call   *0x55c5c(%rip)        # af3c0 <_DYNAMIC+0x230>
   59764:	cc                   	int3
   59765:	cc                   	int3
   59766:	cc                   	int3
   59767:	cc                   	int3
   59768:	cc                   	int3
   59769:	cc                   	int3
   5976a:	cc                   	int3
   5976b:	cc                   	int3
   5976c:	cc                   	int3
   5976d:	cc                   	int3
   5976e:	cc                   	int3
   5976f:	cc                   	int3

