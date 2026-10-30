0000000000060160 <compare_benchmark::lookup>:
   60160:	55                   	push   %rbp
   60161:	41 57                	push   %r15
   60163:	41 56                	push   %r14
   60165:	41 55                	push   %r13
   60167:	41 54                	push   %r12
   60169:	53                   	push   %rbx
   6016a:	48 83 ec 48          	sub    $0x48,%rsp
   6016e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   60173:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   60178:	4c 39 c2             	cmp    %r8,%rdx
   6017b:	0f 85 ca 04 00 00    	jne    6064b <compare_benchmark::lookup+0x4eb>
   60181:	48 89 cb             	mov    %rcx,%rbx
   60184:	49 89 d7             	mov    %rdx,%r15
   60187:	49 89 f6             	mov    %rsi,%r14
   6018a:	49 89 fc             	mov    %rdi,%r12
   6018d:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   60191:	48 83 fa 01          	cmp    $0x1,%rdx
   60195:	75 5e                	jne    601f5 <compare_benchmark::lookup+0x95>
   60197:	84 c0                	test   %al,%al
   60199:	0f 84 91 01 00 00    	je     60330 <compare_benchmark::lookup+0x1d0>
   6019f:	49 8b 06             	mov    (%r14),%rax
   601a2:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   601a7:	62 f2 7d 28 7c c0    	vpbroadcastd %eax,%ymm0
   601ad:	48 c1 e8 20          	shr    $0x20,%rax
   601b1:	41 23 44 24 18       	and    0x18(%r12),%eax
   601b6:	48 c1 e0 06          	shl    $0x6,%rax
   601ba:	c4 e2 7d 40 05 1d 89 	vpmulld -0x576e3(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   601c1:	fa ff 
   601c3:	62 f1 fd 48 6f 0c 01 	vmovdqa64 (%rcx,%rax,1),%zmm1
   601ca:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   601cf:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   601d5:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   601db:	62 f2 fe 58 27 05 bb 	vptestnmq -0x57845(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   601e2:	87 fa ff 
   601e5:	31 c0                	xor    %eax,%eax
   601e7:	c5 f9 98 c0          	kortestb %k0,%k0
   601eb:	0f 94 c0             	sete   %al
   601ee:	89 03                	mov    %eax,(%rbx)
   601f0:	e9 44 04 00 00       	jmp    60639 <compare_benchmark::lookup+0x4d9>
   601f5:	84 c0                	test   %al,%al
   601f7:	0f 84 b0 01 00 00    	je     603ad <compare_benchmark::lookup+0x24d>
   601fd:	49 83 ff 10          	cmp    $0x10,%r15
   60201:	0f 83 d5 01 00 00    	jae    603dc <compare_benchmark::lookup+0x27c>
   60207:	4d 85 ff             	test   %r15,%r15
   6020a:	0f 84 29 04 00 00    	je     60639 <compare_benchmark::lookup+0x4d9>
   60210:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   60215:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   6021a:	42 8d 34 bd 00 00 00 	lea    0x0(,%r15,4),%esi
   60221:	00 
   60222:	83 e6 38             	and    $0x38,%esi
   60225:	31 c0                	xor    %eax,%eax
   60227:	62 f1 fd 48 6f 05 4f 	vmovdqa64 -0x56cb1(%rip),%zmm0        # 9580 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3a0>
   6022e:	93 fa ff 
   60231:	62 f2 fd 48 59 0d 65 	vpbroadcastq -0x5789b(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   60238:	87 fa ff 
   6023b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   60240:	49 8b 3c 46          	mov    (%r14,%rax,2),%rdi
   60244:	41 89 f8             	mov    %edi,%r8d
   60247:	48 c1 ef 20          	shr    $0x20,%rdi
   6024b:	21 d7                	and    %edx,%edi
   6024d:	48 c1 e7 06          	shl    $0x6,%rdi
   60251:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   60257:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   6025d:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   60264:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   6026b:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   60271:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   60277:	31 ff                	xor    %edi,%edi
   60279:	c5 f9 98 c0          	kortestb %k0,%k0
   6027d:	40 0f 94 c7          	sete   %dil
   60281:	89 3c 03             	mov    %edi,(%rbx,%rax,1)
   60284:	49 8b 7c 46 08       	mov    0x8(%r14,%rax,2),%rdi
   60289:	41 89 f8             	mov    %edi,%r8d
   6028c:	48 c1 ef 20          	shr    $0x20,%rdi
   60290:	21 d7                	and    %edx,%edi
   60292:	48 c1 e7 06          	shl    $0x6,%rdi
   60296:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   6029c:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   602a2:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   602a9:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   602b0:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   602b6:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   602bc:	31 ff                	xor    %edi,%edi
   602be:	c5 f9 98 c0          	kortestb %k0,%k0
   602c2:	40 0f 94 c7          	sete   %dil
   602c6:	89 7c 03 04          	mov    %edi,0x4(%rbx,%rax,1)
   602ca:	48 83 c0 08          	add    $0x8,%rax
   602ce:	48 39 c6             	cmp    %rax,%rsi
   602d1:	0f 85 69 ff ff ff    	jne    60240 <compare_benchmark::lookup+0xe0>
   602d7:	41 f6 c7 01          	test   $0x1,%r15b
   602db:	0f 84 58 03 00 00    	je     60639 <compare_benchmark::lookup+0x4d9>
   602e1:	49 8b 34 46          	mov    (%r14,%rax,2),%rsi
   602e5:	89 f7                	mov    %esi,%edi
   602e7:	48 c1 ee 20          	shr    $0x20,%rsi
   602eb:	21 f2                	and    %esi,%edx
   602ed:	62 f2 fd 48 7c c7    	vpbroadcastq %rdi,%zmm0
   602f3:	62 f2 7d 48 40 05 83 	vpmulld -0x56d7d(%rip),%zmm0,%zmm0        # 9580 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3a0>
   602fa:	92 fa ff 
   602fd:	48 c1 e2 06          	shl    $0x6,%rdx
   60301:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   60308:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   6030f:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   60315:	62 f2 fe 58 27 05 81 	vptestnmq -0x5797f(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   6031c:	86 fa ff 
   6031f:	31 c9                	xor    %ecx,%ecx
   60321:	c5 f9 98 c0          	kortestb %k0,%k0
   60325:	0f 94 c1             	sete   %cl
   60328:	89 0c 03             	mov    %ecx,(%rbx,%rax,1)
   6032b:	e9 09 03 00 00       	jmp    60639 <compare_benchmark::lookup+0x4d9>
   60330:	49 8b 36             	mov    (%r14),%rsi
   60333:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   60339:	0f 84 68 01 00 00    	je     604a7 <compare_benchmark::lookup+0x347>
   6033f:	49 8b 44 24 08       	mov    0x8(%r12),%rax
   60344:	48 89 f1             	mov    %rsi,%rcx
   60347:	48 c1 e9 20          	shr    $0x20,%rcx
   6034b:	41 23 4c 24 18       	and    0x18(%r12),%ecx
   60350:	48 c1 e1 06          	shl    $0x6,%rcx
   60354:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   6035a:	c4 e2 7d 40 05 7d 87 	vpmulld -0x57883(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   60361:	fa ff 
   60363:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   60368:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   6036d:	c4 e2 7d 59 15 2a 86 	vpbroadcastq -0x579d6(%rip),%ymm2        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   60374:	fa ff 
   60376:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   6037b:	c5 fd 6f 1c 08       	vmovdqa (%rax,%rcx,1),%ymm3
   60380:	c4 e2 7d 17 d9       	vptest %ymm1,%ymm3
   60385:	0f 92 c2             	setb   %dl
   60388:	c5 fd 6f 4c 08 20    	vmovdqa 0x20(%rax,%rcx,1),%ymm1
   6038e:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   60394:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   60399:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   6039e:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   603a3:	0f 92 c0             	setb   %al
   603a6:	20 d0                	and    %dl,%al
   603a8:	e9 02 01 00 00       	jmp    604af <compare_benchmark::lookup+0x34f>
   603ad:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   603b3:	0f 84 00 01 00 00    	je     604b9 <compare_benchmark::lookup+0x359>
   603b9:	4c 89 e7             	mov    %r12,%rdi
   603bc:	4c 89 f6             	mov    %r14,%rsi
   603bf:	4c 89 fa             	mov    %r15,%rdx
   603c2:	48 89 d9             	mov    %rbx,%rcx
   603c5:	4d 89 f8             	mov    %r15,%r8
   603c8:	48 83 c4 48          	add    $0x48,%rsp
   603cc:	5b                   	pop    %rbx
   603cd:	41 5c                	pop    %r12
   603cf:	41 5d                	pop    %r13
   603d1:	41 5e                	pop    %r14
   603d3:	41 5f                	pop    %r15
   603d5:	5d                   	pop    %rbp
   603d6:	ff 25 0c 84 05 00    	jmp    *0x5840c(%rip)        # b87e8 <_DYNAMIC+0x3d0>
   603dc:	31 c0                	xor    %eax,%eax
   603de:	4c 89 f9             	mov    %r15,%rcx
   603e1:	48 83 e9 20          	sub    $0x20,%rcx
   603e5:	48 0f 43 c1          	cmovae %rcx,%rax
   603e9:	0f 86 94 00 00 00    	jbe    60483 <compare_benchmark::lookup+0x323>
   603ef:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   603f4:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   603f9:	bf 20 00 00 00       	mov    $0x20,%edi
   603fe:	c5 fd 6f 05 da 86 fa 	vmovdqa -0x57926(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   60405:	ff 
   60406:	62 f2 fd 48 59 0d 90 	vpbroadcastq -0x57a70(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   6040d:	85 fa ff 
   60410:	49 39 ff             	cmp    %rdi,%r15
   60413:	0f 84 78 02 00 00    	je     60691 <compare_benchmark::lookup+0x531>
   60419:	49 8b b4 fe 00 ff ff 	mov    -0x100(%r14,%rdi,8),%rsi
   60420:	ff 
   60421:	45 8b 44 fe 04       	mov    0x4(%r14,%rdi,8),%r8d
   60426:	41 21 d0             	and    %edx,%r8d
   60429:	49 c1 e0 06          	shl    $0x6,%r8
   6042d:	42 0f 18 0c 01       	prefetcht0 (%rcx,%r8,1)
   60432:	62 f2 7d 28 7c d6    	vpbroadcastd %esi,%ymm2
   60438:	48 c1 ee 20          	shr    $0x20,%rsi
   6043c:	21 d6                	and    %edx,%esi
   6043e:	48 c1 e6 06          	shl    $0x6,%rsi
   60442:	62 f1 fd 48 6f 1c 31 	vmovdqa64 (%rcx,%rsi,1),%zmm3
   60449:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   6044e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   60453:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   60459:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   6045f:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   60465:	31 f6                	xor    %esi,%esi
   60467:	c5 f9 98 c0          	kortestb %k0,%k0
   6046b:	40 0f 94 c6          	sete   %sil
   6046f:	89 74 bb 80          	mov    %esi,-0x80(%rbx,%rdi,4)
   60473:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   60477:	48 83 c7 e1          	add    $0xffffffffffffffe1,%rdi
   6047b:	48 39 c7             	cmp    %rax,%rdi
   6047e:	48 89 f7             	mov    %rsi,%rdi
   60481:	72 8d                	jb     60410 <compare_benchmark::lookup+0x2b0>
   60483:	4c 89 fe             	mov    %r15,%rsi
   60486:	48 29 c6             	sub    %rax,%rsi
   60489:	0f 84 aa 01 00 00    	je     60639 <compare_benchmark::lookup+0x4d9>
   6048f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   60494:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   60499:	48 83 fe 01          	cmp    $0x1,%rsi
   6049d:	75 55                	jne    604f4 <compare_benchmark::lookup+0x394>
   6049f:	45 31 d2             	xor    %r10d,%r10d
   604a2:	e9 38 01 00 00       	jmp    605df <compare_benchmark::lookup+0x47f>
   604a7:	4c 89 e7             	mov    %r12,%rdi
   604aa:	e8 a1 30 00 00       	call   63550 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   604af:	0f b6 c0             	movzbl %al,%eax
   604b2:	89 03                	mov    %eax,(%rbx)
   604b4:	e9 80 01 00 00       	jmp    60639 <compare_benchmark::lookup+0x4d9>
   604b9:	4d 85 ff             	test   %r15,%r15
   604bc:	0f 84 77 01 00 00    	je     60639 <compare_benchmark::lookup+0x4d9>
   604c2:	45 31 ed             	xor    %r13d,%r13d
   604c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   604cc:	00 00 00 00 
   604d0:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   604d4:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   604d8:	4c 89 e7             	mov    %r12,%rdi
   604db:	e8 70 30 00 00       	call   63550 <fastest_bloom_filter_inline::split64::Split64BloomFilter::contains_scalar>
   604e0:	0f b6 c0             	movzbl %al,%eax
   604e3:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   604e7:	49 89 ed             	mov    %rbp,%r13
   604ea:	49 39 ef             	cmp    %rbp,%r15
   604ed:	75 e1                	jne    604d0 <compare_benchmark::lookup+0x370>
   604ef:	e9 45 01 00 00       	jmp    60639 <compare_benchmark::lookup+0x4d9>
   604f4:	48 89 f7             	mov    %rsi,%rdi
   604f7:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
   604fb:	4c 8d 0c f5 00 00 00 	lea    0x0(,%rsi,8),%r9
   60502:	00 
   60503:	4f 8d 04 fe          	lea    (%r14,%r15,8),%r8
   60507:	4d 29 c8             	sub    %r9,%r8
   6050a:	49 83 c0 08          	add    $0x8,%r8
   6050e:	4c 8d 14 b5 00 00 00 	lea    0x0(,%rsi,4),%r10
   60515:	00 
   60516:	4e 8d 0c bb          	lea    (%rbx,%r15,4),%r9
   6051a:	4d 29 d1             	sub    %r10,%r9
   6051d:	49 83 c1 04          	add    $0x4,%r9
   60521:	45 31 db             	xor    %r11d,%r11d
   60524:	c5 fd 6f 05 b4 85 fa 	vmovdqa -0x57a4c(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   6052b:	ff 
   6052c:	62 f2 fd 48 59 0d 6a 	vpbroadcastq -0x57b96(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   60533:	84 fa ff 
   60536:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   6053d:	00 00 00 
   60540:	4f 8b 54 d8 f8       	mov    -0x8(%r8,%r11,8),%r10
   60545:	62 d2 7d 28 7c d2    	vpbroadcastd %r10d,%ymm2
   6054b:	49 c1 ea 20          	shr    $0x20,%r10
   6054f:	41 21 d2             	and    %edx,%r10d
   60552:	49 c1 e2 06          	shl    $0x6,%r10
   60556:	62 b1 fd 48 6f 1c 11 	vmovdqa64 (%rcx,%r10,1),%zmm3
   6055d:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   60562:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   60567:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   6056d:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   60573:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   60579:	45 31 d2             	xor    %r10d,%r10d
   6057c:	c5 f9 98 c0          	kortestb %k0,%k0
   60580:	41 0f 94 c2          	sete   %r10b
   60584:	47 89 54 99 fc       	mov    %r10d,-0x4(%r9,%r11,4)
   60589:	4d 8d 53 02          	lea    0x2(%r11),%r10
   6058d:	4f 8b 3c d8          	mov    (%r8,%r11,8),%r15
   60591:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   60597:	49 c1 ef 20          	shr    $0x20,%r15
   6059b:	41 21 d7             	and    %edx,%r15d
   6059e:	49 c1 e7 06          	shl    $0x6,%r15
   605a2:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   605a7:	62 b1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%r15,1),%zmm3
   605ae:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   605b3:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   605b9:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   605bf:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   605c5:	31 ed                	xor    %ebp,%ebp
   605c7:	c5 f9 98 c0          	kortestb %k0,%k0
   605cb:	40 0f 94 c5          	sete   %bpl
   605cf:	43 89 2c 99          	mov    %ebp,(%r9,%r11,4)
   605d3:	4d 89 d3             	mov    %r10,%r11
   605d6:	4c 39 d7             	cmp    %r10,%rdi
   605d9:	0f 85 61 ff ff ff    	jne    60540 <compare_benchmark::lookup+0x3e0>
   605df:	40 f6 c6 01          	test   $0x1,%sil
   605e3:	74 54                	je     60639 <compare_benchmark::lookup+0x4d9>
   605e5:	49 8d 34 c6          	lea    (%r14,%rax,8),%rsi
   605e9:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
   605ed:	4a 8b 34 d6          	mov    (%rsi,%r10,8),%rsi
   605f1:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   605f7:	48 c1 ee 20          	shr    $0x20,%rsi
   605fb:	21 f2                	and    %esi,%edx
   605fd:	48 c1 e2 06          	shl    $0x6,%rdx
   60601:	c4 e2 7d 40 05 d6 84 	vpmulld -0x57b2a(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   60608:	fa ff 
   6060a:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   60611:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   60616:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   6061c:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   60622:	62 f2 fe 58 27 05 74 	vptestnmq -0x57c8c(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   60629:	83 fa ff 
   6062c:	31 c9                	xor    %ecx,%ecx
   6062e:	c5 f9 98 c0          	kortestb %k0,%k0
   60632:	0f 94 c1             	sete   %cl
   60635:	42 89 0c 90          	mov    %ecx,(%rax,%r10,4)
   60639:	48 83 c4 48          	add    $0x48,%rsp
   6063d:	5b                   	pop    %rbx
   6063e:	41 5c                	pop    %r12
   60640:	41 5d                	pop    %r13
   60642:	41 5e                	pop    %r14
   60644:	41 5f                	pop    %r15
   60646:	5d                   	pop    %rbp
   60647:	c5 f8 77             	vzeroupper
   6064a:	c3                   	ret
   6064b:	48 8d 05 6e 43 05 00 	lea    0x5436e(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   60652:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   60657:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   6065e:	00 00 
   60660:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   60667:	00 00 
   60669:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   6066d:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   60673:	4c 8d 05 3e 4d 05 00 	lea    0x54d3e(%rip),%r8        # b53b8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xbe8>
   6067a:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   6067f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   60684:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   60689:	31 ff                	xor    %edi,%edi
   6068b:	ff 15 5f 81 05 00    	call   *0x5815f(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   60691:	48 8d 15 90 5b 05 00 	lea    0x55b90(%rip),%rdx        # b6228 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749>
   60698:	4c 89 fe             	mov    %r15,%rsi
   6069b:	c5 f8 77             	vzeroupper
   6069e:	ff 15 d4 7f 05 00    	call   *0x57fd4(%rip)        # b8678 <_DYNAMIC+0x260>
   606a4:	cc                   	int3
   606a5:	cc                   	int3
   606a6:	cc                   	int3
   606a7:	cc                   	int3
   606a8:	cc                   	int3
   606a9:	cc                   	int3
   606aa:	cc                   	int3
   606ab:	cc                   	int3
   606ac:	cc                   	int3
   606ad:	cc                   	int3
   606ae:	cc                   	int3
   606af:	cc                   	int3

