000000000005a270 <compare_benchmark::lookup>:
   5a270:	55                   	push   %rbp
   5a271:	41 57                	push   %r15
   5a273:	41 56                	push   %r14
   5a275:	41 55                	push   %r13
   5a277:	41 54                	push   %r12
   5a279:	53                   	push   %rbx
   5a27a:	48 83 ec 48          	sub    $0x48,%rsp
   5a27e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5a283:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   5a288:	4c 39 c2             	cmp    %r8,%rdx
   5a28b:	0f 85 60 0e 00 00    	jne    5b0f1 <compare_benchmark::lookup+0xe81>
   5a291:	48 89 c8             	mov    %rcx,%rax
   5a294:	48 83 fa 04          	cmp    $0x4,%rdx
   5a298:	0f 83 96 01 00 00    	jae    5a434 <compare_benchmark::lookup+0x1c4>
   5a29e:	48 85 d2             	test   %rdx,%rdx
   5a2a1:	0f 84 38 0e 00 00    	je     5b0df <compare_benchmark::lookup+0xe6f>
   5a2a7:	44 8b 57 20          	mov    0x20(%rdi),%r10d
   5a2ab:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   5a2af:	48 8b 1e             	mov    (%rsi),%rbx
   5a2b2:	49 89 de             	mov    %rbx,%r14
   5a2b5:	49 c1 ee 20          	shr    $0x20,%r14
   5a2b9:	45 21 d6             	and    %r10d,%r14d
   5a2bc:	45 89 f1             	mov    %r14d,%r9d
   5a2bf:	41 c1 e9 04          	shr    $0x4,%r9d
   5a2c3:	4d 39 c1             	cmp    %r8,%r9
   5a2c6:	0f 83 c1 0e 00 00    	jae    5b18d <compare_benchmark::lookup+0xf1d>
   5a2cc:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   5a2d0:	89 d9                	mov    %ebx,%ecx
   5a2d2:	c1 e9 08             	shr    $0x8,%ecx
   5a2d5:	83 e1 7c             	and    $0x7c,%ecx
   5a2d8:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   5a2dc:	89 d9                	mov    %ebx,%ecx
   5a2de:	c1 e9 0f             	shr    $0xf,%ecx
   5a2e1:	d3 c5                	rol    %cl,%ebp
   5a2e3:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
   5a2e7:	89 d9                	mov    %ebx,%ecx
   5a2e9:	83 e1 1f             	and    $0x1f,%ecx
   5a2ec:	45 8b 3c 8b          	mov    (%r11,%rcx,4),%r15d
   5a2f0:	89 d9                	mov    %ebx,%ecx
   5a2f2:	c1 e9 05             	shr    $0x5,%ecx
   5a2f5:	41 d3 c7             	rol    %cl,%r15d
   5a2f8:	44 89 f1             	mov    %r14d,%ecx
   5a2fb:	83 e1 0f             	and    $0xf,%ecx
   5a2fe:	49 c1 e1 06          	shl    $0x6,%r9
   5a302:	49 01 f9             	add    %rdi,%r9
   5a305:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
   5a309:	c4 c2 70 f2 cf       	andn   %r15d,%ecx,%ecx
   5a30e:	c1 eb 14             	shr    $0x14,%ebx
   5a311:	83 cb 08             	or     $0x8,%ebx
   5a314:	44 31 f3             	xor    %r14d,%ebx
   5a317:	83 e3 0f             	and    $0xf,%ebx
   5a31a:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
   5a31e:	c4 62 30 f2 cd       	andn   %ebp,%r9d,%r9d
   5a323:	31 db                	xor    %ebx,%ebx
   5a325:	41 09 c9             	or     %ecx,%r9d
   5a328:	0f 94 c3             	sete   %bl
   5a32b:	89 18                	mov    %ebx,(%rax)
   5a32d:	48 83 fa 01          	cmp    $0x1,%rdx
   5a331:	0f 84 a8 0d 00 00    	je     5b0df <compare_benchmark::lookup+0xe6f>
   5a337:	48 8b 5e 08          	mov    0x8(%rsi),%rbx
   5a33b:	49 89 de             	mov    %rbx,%r14
   5a33e:	49 c1 ee 20          	shr    $0x20,%r14
   5a342:	45 21 d6             	and    %r10d,%r14d
   5a345:	45 89 f1             	mov    %r14d,%r9d
   5a348:	41 c1 e9 04          	shr    $0x4,%r9d
   5a34c:	4d 39 c1             	cmp    %r8,%r9
   5a34f:	0f 83 38 0e 00 00    	jae    5b18d <compare_benchmark::lookup+0xf1d>
   5a355:	89 d9                	mov    %ebx,%ecx
   5a357:	c1 e9 08             	shr    $0x8,%ecx
   5a35a:	83 e1 7c             	and    $0x7c,%ecx
   5a35d:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   5a361:	89 d9                	mov    %ebx,%ecx
   5a363:	c1 e9 0f             	shr    $0xf,%ecx
   5a366:	d3 c5                	rol    %cl,%ebp
   5a368:	89 d9                	mov    %ebx,%ecx
   5a36a:	83 e1 1f             	and    $0x1f,%ecx
   5a36d:	45 8b 3c 8b          	mov    (%r11,%rcx,4),%r15d
   5a371:	89 d9                	mov    %ebx,%ecx
   5a373:	c1 e9 05             	shr    $0x5,%ecx
   5a376:	41 d3 c7             	rol    %cl,%r15d
   5a379:	44 89 f1             	mov    %r14d,%ecx
   5a37c:	83 e1 0f             	and    $0xf,%ecx
   5a37f:	49 c1 e1 06          	shl    $0x6,%r9
   5a383:	49 01 f9             	add    %rdi,%r9
   5a386:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
   5a38a:	c4 c2 70 f2 cf       	andn   %r15d,%ecx,%ecx
   5a38f:	c1 eb 14             	shr    $0x14,%ebx
   5a392:	83 cb 08             	or     $0x8,%ebx
   5a395:	44 31 f3             	xor    %r14d,%ebx
   5a398:	83 e3 0f             	and    $0xf,%ebx
   5a39b:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
   5a39f:	c4 62 30 f2 cd       	andn   %ebp,%r9d,%r9d
   5a3a4:	31 db                	xor    %ebx,%ebx
   5a3a6:	41 09 c9             	or     %ecx,%r9d
   5a3a9:	0f 94 c3             	sete   %bl
   5a3ac:	89 58 04             	mov    %ebx,0x4(%rax)
   5a3af:	48 83 fa 02          	cmp    $0x2,%rdx
   5a3b3:	0f 84 26 0d 00 00    	je     5b0df <compare_benchmark::lookup+0xe6f>
   5a3b9:	48 8b 56 10          	mov    0x10(%rsi),%rdx
   5a3bd:	48 89 d1             	mov    %rdx,%rcx
   5a3c0:	48 c1 e9 20          	shr    $0x20,%rcx
   5a3c4:	41 21 ca             	and    %ecx,%r10d
   5a3c7:	45 89 d1             	mov    %r10d,%r9d
   5a3ca:	41 c1 e9 04          	shr    $0x4,%r9d
   5a3ce:	4d 39 c1             	cmp    %r8,%r9
   5a3d1:	0f 83 b6 0d 00 00    	jae    5b18d <compare_benchmark::lookup+0xf1d>
   5a3d7:	89 d1                	mov    %edx,%ecx
   5a3d9:	c1 e9 08             	shr    $0x8,%ecx
   5a3dc:	83 e1 7c             	and    $0x7c,%ecx
   5a3df:	41 8b 34 0b          	mov    (%r11,%rcx,1),%esi
   5a3e3:	89 d1                	mov    %edx,%ecx
   5a3e5:	c1 e9 0f             	shr    $0xf,%ecx
   5a3e8:	d3 c6                	rol    %cl,%esi
   5a3ea:	89 d1                	mov    %edx,%ecx
   5a3ec:	83 e1 1f             	and    $0x1f,%ecx
   5a3ef:	45 8b 04 8b          	mov    (%r11,%rcx,4),%r8d
   5a3f3:	89 d1                	mov    %edx,%ecx
   5a3f5:	c1 e9 05             	shr    $0x5,%ecx
   5a3f8:	41 d3 c0             	rol    %cl,%r8d
   5a3fb:	44 89 d1             	mov    %r10d,%ecx
   5a3fe:	83 e1 0f             	and    $0xf,%ecx
   5a401:	49 c1 e1 06          	shl    $0x6,%r9
   5a405:	4c 01 cf             	add    %r9,%rdi
   5a408:	8b 0c 8f             	mov    (%rdi,%rcx,4),%ecx
   5a40b:	c4 c2 70 f2 c8       	andn   %r8d,%ecx,%ecx
   5a410:	c1 ea 14             	shr    $0x14,%edx
   5a413:	83 ca 08             	or     $0x8,%edx
   5a416:	44 31 d2             	xor    %r10d,%edx
   5a419:	83 e2 0f             	and    $0xf,%edx
   5a41c:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
   5a41f:	c4 e2 68 f2 d6       	andn   %esi,%edx,%edx
   5a424:	31 f6                	xor    %esi,%esi
   5a426:	09 ca                	or     %ecx,%edx
   5a428:	40 0f 94 c6          	sete   %sil
   5a42c:	89 70 08             	mov    %esi,0x8(%rax)
   5a42f:	e9 ab 0c 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5a434:	80 7f 24 00          	cmpb   $0x0,0x24(%rdi)
   5a438:	74 4f                	je     5a489 <compare_benchmark::lookup+0x219>
   5a43a:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   5a43e:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
   5a445:	76 7a                	jbe    5a4c1 <compare_benchmark::lookup+0x251>
   5a447:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5a44b:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   5a44f:	62 d1 fe 48 6f 03    	vmovdqu64 (%r11),%zmm0
   5a455:	62 d1 fe 48 6f 4b 01 	vmovdqu64 0x40(%r11),%zmm1
   5a45c:	48 83 fa 10          	cmp    $0x10,%rdx
   5a460:	0f 83 28 01 00 00    	jae    5a58e <compare_benchmark::lookup+0x31e>
   5a466:	31 c9                	xor    %ecx,%ecx
   5a468:	48 89 cb             	mov    %rcx,%rbx
   5a46b:	48 83 cb 08          	or     $0x8,%rbx
   5a46f:	48 39 d3             	cmp    %rdx,%rbx
   5a472:	0f 86 60 06 00 00    	jbe    5aad8 <compare_benchmark::lookup+0x868>
   5a478:	48 89 cb             	mov    %rcx,%rbx
   5a47b:	48 39 d3             	cmp    %rdx,%rbx
   5a47e:	0f 82 e0 06 00 00    	jb     5ab64 <compare_benchmark::lookup+0x8f4>
   5a484:	e9 56 0c 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5a489:	80 7f 25 00          	cmpb   $0x0,0x25(%rdi)
   5a48d:	74 59                	je     5a4e8 <compare_benchmark::lookup+0x278>
   5a48f:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
   5a493:	48 89 0c 24          	mov    %rcx,(%rsp)
   5a497:	48 81 f9 00 80 00 00 	cmp    $0x8000,%rcx
   5a49e:	0f 86 cc 03 00 00    	jbe    5a870 <compare_benchmark::lookup+0x600>
   5a4a4:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   5a4a8:	8b 5f 20             	mov    0x20(%rdi),%ebx
   5a4ab:	48 83 fa 07          	cmp    $0x7,%rdx
   5a4af:	0f 87 53 07 00 00    	ja     5ac08 <compare_benchmark::lookup+0x998>
   5a4b5:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   5a4b9:	45 31 ff             	xor    %r15d,%r15d
   5a4bc:	e9 6c 0b 00 00       	jmp    5b02d <compare_benchmark::lookup+0xdbd>
   5a4c1:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5a4c5:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   5a4c9:	62 d1 fe 48 6f 03    	vmovdqu64 (%r11),%zmm0
   5a4cf:	62 d1 fe 48 6f 4b 01 	vmovdqu64 0x40(%r11),%zmm1
   5a4d6:	48 83 fa 10          	cmp    $0x10,%rdx
   5a4da:	0f 83 ad 03 00 00    	jae    5a88d <compare_benchmark::lookup+0x61d>
   5a4e0:	45 31 c9             	xor    %r9d,%r9d
   5a4e3:	e9 a6 04 00 00       	jmp    5a98e <compare_benchmark::lookup+0x71e>
   5a4e8:	44 8b 4f 20          	mov    0x20(%rdi),%r9d
   5a4ec:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5a4f0:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   5a4f4:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   5a4f8:	31 db                	xor    %ebx,%ebx
   5a4fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   5a500:	4c 8b 34 de          	mov    (%rsi,%rbx,8),%r14
   5a504:	4d 89 f7             	mov    %r14,%r15
   5a507:	49 c1 ef 20          	shr    $0x20,%r15
   5a50b:	45 21 cf             	and    %r9d,%r15d
   5a50e:	44 89 ff             	mov    %r15d,%edi
   5a511:	c1 ef 04             	shr    $0x4,%edi
   5a514:	4c 39 c7             	cmp    %r8,%rdi
   5a517:	0f 83 1a 0c 00 00    	jae    5b137 <compare_benchmark::lookup+0xec7>
   5a51d:	44 89 f1             	mov    %r14d,%ecx
   5a520:	c1 e9 08             	shr    $0x8,%ecx
   5a523:	83 e1 7c             	and    $0x7c,%ecx
   5a526:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   5a52a:	44 89 f1             	mov    %r14d,%ecx
   5a52d:	c1 e9 0f             	shr    $0xf,%ecx
   5a530:	d3 c5                	rol    %cl,%ebp
   5a532:	44 89 f1             	mov    %r14d,%ecx
   5a535:	83 e1 1f             	and    $0x1f,%ecx
   5a538:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   5a53c:	44 89 f1             	mov    %r14d,%ecx
   5a53f:	c1 e9 05             	shr    $0x5,%ecx
   5a542:	41 d3 c4             	rol    %cl,%r12d
   5a545:	44 89 f9             	mov    %r15d,%ecx
   5a548:	83 e1 0f             	and    $0xf,%ecx
   5a54b:	48 c1 e7 06          	shl    $0x6,%rdi
   5a54f:	4c 01 d7             	add    %r10,%rdi
   5a552:	8b 0c 8f             	mov    (%rdi,%rcx,4),%ecx
   5a555:	c4 c2 70 f2 cc       	andn   %r12d,%ecx,%ecx
   5a55a:	41 c1 ee 14          	shr    $0x14,%r14d
   5a55e:	41 83 ce 08          	or     $0x8,%r14d
   5a562:	45 31 fe             	xor    %r15d,%r14d
   5a565:	41 83 e6 0f          	and    $0xf,%r14d
   5a569:	42 8b 3c b7          	mov    (%rdi,%r14,4),%edi
   5a56d:	c4 e2 40 f2 fd       	andn   %ebp,%edi,%edi
   5a572:	31 ed                	xor    %ebp,%ebp
   5a574:	09 cf                	or     %ecx,%edi
   5a576:	40 0f 94 c5          	sete   %bpl
   5a57a:	89 2c 98             	mov    %ebp,(%rax,%rbx,4)
   5a57d:	48 ff c3             	inc    %rbx
   5a580:	48 39 da             	cmp    %rbx,%rdx
   5a583:	0f 85 77 ff ff ff    	jne    5a500 <compare_benchmark::lookup+0x290>
   5a589:	e9 51 0b 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5a58e:	44 8b 4f 20          	mov    0x20(%rdi),%r9d
   5a592:	62 d2 7d 48 7c d1    	vpbroadcastd %r9d,%zmm2
   5a598:	31 db                	xor    %ebx,%ebx
   5a59a:	62 f1 fd 48 6f 1d 5c 	vmovdqa64 -0x511a4(%rip),%zmm3        # 9400 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x5d0>
   5a5a1:	ee fa ff 
   5a5a4:	62 f1 fd 48 6f 25 92 	vmovdqa64 -0x5116e(%rip),%zmm4        # 9440 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x610>
   5a5ab:	ee fa ff 
   5a5ae:	62 f2 7d 48 58 2d e4 	vpbroadcastd -0x5211c(%rip),%zmm5        # 849c <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x120>
   5a5b5:	de fa ff 
   5a5b8:	62 f2 7d 48 58 35 3a 	vpbroadcastd -0x520c6(%rip),%zmm6        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   5a5bf:	df fa ff 
   5a5c2:	e9 e6 00 00 00       	jmp    5a6ad <compare_benchmark::lookup+0x43d>
   5a5c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   5a5ce:	00 00 
   5a5d0:	8b 8c de 7c 02 00 00 	mov    0x27c(%rsi,%rbx,8),%ecx
   5a5d7:	44 21 c9             	and    %r9d,%ecx
   5a5da:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a5df:	62 f1 fe 48 6f 3c de 	vmovdqu64 (%rsi,%rbx,8),%zmm7
   5a5e6:	62 71 fe 48 6f 44 de 	vmovdqu64 0x40(%rsi,%rbx,8),%zmm8
   5a5ed:	01 
   5a5ee:	62 71 fd 48 6f cf    	vmovdqa64 %zmm7,%zmm9
   5a5f4:	62 52 65 48 7e c8    	vpermt2d %zmm8,%zmm3,%zmm9
   5a5fa:	62 d2 5d 48 7e f8    	vpermt2d %zmm8,%zmm4,%zmm7
   5a600:	62 f1 45 48 db fa    	vpandd %zmm2,%zmm7,%zmm7
   5a606:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   5a60b:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5a60f:	62 52 7d 49 90 04 ba 	vpgatherdd (%r10,%zmm7,4),%zmm8{%k1}
   5a616:	62 d1 2d 48 72 d1 14 	vpsrld $0x14,%zmm9,%zmm10
   5a61d:	62 71 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm10
   5a623:	62 73 45 48 25 d6 36 	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   5a62a:	62 f1 fd 48 6f f8    	vmovdqa64 %zmm0,%zmm7
   5a630:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   5a635:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5a639:	62 12 7d 49 90 1c 92 	vpgatherdd (%r10,%zmm10,4),%zmm11{%k1}
   5a640:	62 f2 35 48 7e f9    	vpermt2d %zmm1,%zmm9,%zmm7
   5a646:	62 d1 2d 48 72 d1 05 	vpsrld $0x5,%zmm9,%zmm10
   5a64d:	62 d2 45 48 15 fa    	vprolvd %zmm10,%zmm7,%zmm7
   5a653:	62 d1 2d 48 72 d1 0a 	vpsrld $0xa,%zmm9,%zmm10
   5a65a:	62 72 7d 48 76 d1    	vpermi2d %zmm1,%zmm0,%zmm10
   5a660:	62 d1 35 48 72 d1 0f 	vpsrld $0xf,%zmm9,%zmm9
   5a667:	62 52 2d 48 15 c9    	vprolvd %zmm9,%zmm10,%zmm9
   5a66d:	62 71 3d 48 db c7    	vpandd %zmm7,%zmm8,%zmm8
   5a673:	62 f1 3d 48 76 cf    	vpcmpeqd %zmm7,%zmm8,%k1
   5a679:	62 d1 25 48 db f9    	vpandd %zmm9,%zmm11,%zmm7
   5a67f:	62 d1 45 49 76 c1    	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   5a685:	62 f2 7e 48 38 f8    	vpmovm2d %k0,%zmm7
   5a68b:	62 f1 45 48 72 d7 1f 	vpsrld $0x1f,%zmm7,%zmm7
   5a692:	62 f1 fe 48 7f 3c 98 	vmovdqu64 %zmm7,(%rax,%rbx,4)
   5a699:	48 8d 4b 10          	lea    0x10(%rbx),%rcx
   5a69d:	48 83 c3 20          	add    $0x20,%rbx
   5a6a1:	48 39 d3             	cmp    %rdx,%rbx
   5a6a4:	48 89 cb             	mov    %rcx,%rbx
   5a6a7:	0f 87 bb fd ff ff    	ja     5a468 <compare_benchmark::lookup+0x1f8>
   5a6ad:	48 8d 4b 50          	lea    0x50(%rbx),%rcx
   5a6b1:	48 39 d1             	cmp    %rdx,%rcx
   5a6b4:	0f 87 25 ff ff ff    	ja     5a5df <compare_benchmark::lookup+0x36f>
   5a6ba:	48 8d 4b 40          	lea    0x40(%rbx),%rcx
   5a6be:	48 39 d1             	cmp    %rdx,%rcx
   5a6c1:	0f 83 90 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a6c7:	8b 8c de 04 02 00 00 	mov    0x204(%rsi,%rbx,8),%ecx
   5a6ce:	44 21 c9             	and    %r9d,%ecx
   5a6d1:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a6d6:	48 8d 4b 41          	lea    0x41(%rbx),%rcx
   5a6da:	48 39 d1             	cmp    %rdx,%rcx
   5a6dd:	0f 83 74 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a6e3:	8b 8c de 0c 02 00 00 	mov    0x20c(%rsi,%rbx,8),%ecx
   5a6ea:	44 21 c9             	and    %r9d,%ecx
   5a6ed:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a6f2:	48 8d 4b 42          	lea    0x42(%rbx),%rcx
   5a6f6:	48 39 d1             	cmp    %rdx,%rcx
   5a6f9:	0f 83 58 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a6ff:	8b 8c de 14 02 00 00 	mov    0x214(%rsi,%rbx,8),%ecx
   5a706:	44 21 c9             	and    %r9d,%ecx
   5a709:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a70e:	48 8d 4b 43          	lea    0x43(%rbx),%rcx
   5a712:	48 39 d1             	cmp    %rdx,%rcx
   5a715:	0f 83 3c 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a71b:	8b 8c de 1c 02 00 00 	mov    0x21c(%rsi,%rbx,8),%ecx
   5a722:	44 21 c9             	and    %r9d,%ecx
   5a725:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a72a:	48 8d 4b 44          	lea    0x44(%rbx),%rcx
   5a72e:	48 39 d1             	cmp    %rdx,%rcx
   5a731:	0f 83 20 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a737:	8b 8c de 24 02 00 00 	mov    0x224(%rsi,%rbx,8),%ecx
   5a73e:	44 21 c9             	and    %r9d,%ecx
   5a741:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a746:	48 8d 4b 45          	lea    0x45(%rbx),%rcx
   5a74a:	48 39 d1             	cmp    %rdx,%rcx
   5a74d:	0f 83 04 01 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a753:	8b 8c de 2c 02 00 00 	mov    0x22c(%rsi,%rbx,8),%ecx
   5a75a:	44 21 c9             	and    %r9d,%ecx
   5a75d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a762:	48 8d 4b 46          	lea    0x46(%rbx),%rcx
   5a766:	48 39 d1             	cmp    %rdx,%rcx
   5a769:	0f 83 e8 00 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a76f:	8b 8c de 34 02 00 00 	mov    0x234(%rsi,%rbx,8),%ecx
   5a776:	44 21 c9             	and    %r9d,%ecx
   5a779:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a77e:	48 8d 4b 47          	lea    0x47(%rbx),%rcx
   5a782:	48 39 d1             	cmp    %rdx,%rcx
   5a785:	0f 83 cc 00 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a78b:	8b 8c de 3c 02 00 00 	mov    0x23c(%rsi,%rbx,8),%ecx
   5a792:	44 21 c9             	and    %r9d,%ecx
   5a795:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a79a:	48 8d 4b 48          	lea    0x48(%rbx),%rcx
   5a79e:	48 39 d1             	cmp    %rdx,%rcx
   5a7a1:	0f 83 b0 00 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a7a7:	8b 8c de 44 02 00 00 	mov    0x244(%rsi,%rbx,8),%ecx
   5a7ae:	44 21 c9             	and    %r9d,%ecx
   5a7b1:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a7b6:	48 8d 4b 49          	lea    0x49(%rbx),%rcx
   5a7ba:	48 39 d1             	cmp    %rdx,%rcx
   5a7bd:	0f 83 94 00 00 00    	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a7c3:	8b 8c de 4c 02 00 00 	mov    0x24c(%rsi,%rbx,8),%ecx
   5a7ca:	44 21 c9             	and    %r9d,%ecx
   5a7cd:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a7d2:	48 8d 4b 4a          	lea    0x4a(%rbx),%rcx
   5a7d6:	48 39 d1             	cmp    %rdx,%rcx
   5a7d9:	73 7c                	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a7db:	8b 8c de 54 02 00 00 	mov    0x254(%rsi,%rbx,8),%ecx
   5a7e2:	44 21 c9             	and    %r9d,%ecx
   5a7e5:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a7ea:	48 8d 4b 4b          	lea    0x4b(%rbx),%rcx
   5a7ee:	48 39 d1             	cmp    %rdx,%rcx
   5a7f1:	73 64                	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a7f3:	8b 8c de 5c 02 00 00 	mov    0x25c(%rsi,%rbx,8),%ecx
   5a7fa:	44 21 c9             	and    %r9d,%ecx
   5a7fd:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a802:	48 8d 4b 4c          	lea    0x4c(%rbx),%rcx
   5a806:	48 39 d1             	cmp    %rdx,%rcx
   5a809:	73 4c                	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a80b:	8b 8c de 64 02 00 00 	mov    0x264(%rsi,%rbx,8),%ecx
   5a812:	44 21 c9             	and    %r9d,%ecx
   5a815:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a81a:	48 8d 4b 4d          	lea    0x4d(%rbx),%rcx
   5a81e:	48 39 d1             	cmp    %rdx,%rcx
   5a821:	73 34                	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a823:	8b 8c de 6c 02 00 00 	mov    0x26c(%rsi,%rbx,8),%ecx
   5a82a:	44 21 c9             	and    %r9d,%ecx
   5a82d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a832:	48 8d 4b 4e          	lea    0x4e(%rbx),%rcx
   5a836:	48 39 d1             	cmp    %rdx,%rcx
   5a839:	73 1c                	jae    5a857 <compare_benchmark::lookup+0x5e7>
   5a83b:	8b 8c de 74 02 00 00 	mov    0x274(%rsi,%rbx,8),%ecx
   5a842:	44 21 c9             	and    %r9d,%ecx
   5a845:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   5a84a:	48 8d 4b 4f          	lea    0x4f(%rbx),%rcx
   5a84e:	48 39 d1             	cmp    %rdx,%rcx
   5a851:	0f 82 79 fd ff ff    	jb     5a5d0 <compare_benchmark::lookup+0x360>
   5a857:	48 8d 05 4a 19 05 00 	lea    0x5194a(%rip),%rax        # ac1a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa78>
   5a85e:	48 89 cf             	mov    %rcx,%rdi
   5a861:	48 89 d6             	mov    %rdx,%rsi
   5a864:	48 89 c2             	mov    %rax,%rdx
   5a867:	c5 f8 77             	vzeroupper
   5a86a:	ff 15 50 4b 05 00    	call   *0x54b50(%rip)        # af3c0 <_DYNAMIC+0x230>
   5a870:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   5a874:	8b 5f 20             	mov    0x20(%rdi),%ebx
   5a877:	48 83 fa 07          	cmp    $0x7,%rdx
   5a87b:	0f 87 a7 05 00 00    	ja     5ae28 <compare_benchmark::lookup+0xbb8>
   5a881:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   5a885:	45 31 ff             	xor    %r15d,%r15d
   5a888:	e9 db 06 00 00       	jmp    5af68 <compare_benchmark::lookup+0xcf8>
   5a88d:	62 f2 7d 48 58 57 08 	vpbroadcastd 0x20(%rdi),%zmm2
   5a894:	31 c9                	xor    %ecx,%ecx
   5a896:	62 f1 fd 48 6f 1d 60 	vmovdqa64 -0x514a0(%rip),%zmm3        # 9400 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x5d0>
   5a89d:	eb fa ff 
   5a8a0:	62 f1 fd 48 6f 25 96 	vmovdqa64 -0x5146a(%rip),%zmm4        # 9440 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x610>
   5a8a7:	eb fa ff 
   5a8aa:	62 f2 7d 48 58 2d e8 	vpbroadcastd -0x52418(%rip),%zmm5        # 849c <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x120>
   5a8b1:	db fa ff 
   5a8b4:	62 f2 7d 48 58 35 3e 	vpbroadcastd -0x523c2(%rip),%zmm6        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   5a8bb:	dc fa ff 
   5a8be:	66 90                	xchg   %ax,%ax
   5a8c0:	62 f1 fe 48 6f 3c ce 	vmovdqu64 (%rsi,%rcx,8),%zmm7
   5a8c7:	62 71 fe 48 6f 44 ce 	vmovdqu64 0x40(%rsi,%rcx,8),%zmm8
   5a8ce:	01 
   5a8cf:	62 71 fd 48 6f cf    	vmovdqa64 %zmm7,%zmm9
   5a8d5:	62 52 65 48 7e c8    	vpermt2d %zmm8,%zmm3,%zmm9
   5a8db:	62 d2 5d 48 7e f8    	vpermt2d %zmm8,%zmm4,%zmm7
   5a8e1:	62 f1 45 48 db fa    	vpandd %zmm2,%zmm7,%zmm7
   5a8e7:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   5a8ec:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5a8f0:	62 52 7d 49 90 04 ba 	vpgatherdd (%r10,%zmm7,4),%zmm8{%k1}
   5a8f7:	62 d1 2d 48 72 d1 14 	vpsrld $0x14,%zmm9,%zmm10
   5a8fe:	62 71 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm10
   5a904:	62 73 45 48 25 d6 36 	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   5a90b:	62 f1 fd 48 6f f8    	vmovdqa64 %zmm0,%zmm7
   5a911:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   5a916:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5a91a:	62 12 7d 49 90 1c 92 	vpgatherdd (%r10,%zmm10,4),%zmm11{%k1}
   5a921:	62 f2 35 48 7e f9    	vpermt2d %zmm1,%zmm9,%zmm7
   5a927:	62 d1 2d 48 72 d1 05 	vpsrld $0x5,%zmm9,%zmm10
   5a92e:	62 d2 45 48 15 fa    	vprolvd %zmm10,%zmm7,%zmm7
   5a934:	62 d1 2d 48 72 d1 0a 	vpsrld $0xa,%zmm9,%zmm10
   5a93b:	62 72 7d 48 76 d1    	vpermi2d %zmm1,%zmm0,%zmm10
   5a941:	62 d1 35 48 72 d1 0f 	vpsrld $0xf,%zmm9,%zmm9
   5a948:	62 52 2d 48 15 c9    	vprolvd %zmm9,%zmm10,%zmm9
   5a94e:	62 71 3d 48 db c7    	vpandd %zmm7,%zmm8,%zmm8
   5a954:	62 f1 3d 48 76 cf    	vpcmpeqd %zmm7,%zmm8,%k1
   5a95a:	62 d1 25 48 db f9    	vpandd %zmm9,%zmm11,%zmm7
   5a960:	62 d1 45 49 76 c1    	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   5a966:	62 f2 7e 48 38 f8    	vpmovm2d %k0,%zmm7
   5a96c:	62 f1 45 48 72 d7 1f 	vpsrld $0x1f,%zmm7,%zmm7
   5a973:	62 f1 fe 48 7f 3c 88 	vmovdqu64 %zmm7,(%rax,%rcx,4)
   5a97a:	4c 8d 49 10          	lea    0x10(%rcx),%r9
   5a97e:	48 83 c1 20          	add    $0x20,%rcx
   5a982:	48 39 d1             	cmp    %rdx,%rcx
   5a985:	4c 89 c9             	mov    %r9,%rcx
   5a988:	0f 86 32 ff ff ff    	jbe    5a8c0 <compare_benchmark::lookup+0x650>
   5a98e:	4c 89 cb             	mov    %r9,%rbx
   5a991:	48 83 cb 08          	or     $0x8,%rbx
   5a995:	48 39 d3             	cmp    %rdx,%rbx
   5a998:	76 11                	jbe    5a9ab <compare_benchmark::lookup+0x73b>
   5a99a:	4c 89 cb             	mov    %r9,%rbx
   5a99d:	48 39 d3             	cmp    %rdx,%rbx
   5a9a0:	0f 82 92 00 00 00    	jb     5aa38 <compare_benchmark::lookup+0x7c8>
   5a9a6:	e9 34 07 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5a9ab:	62 b1 fe 48 6f 14 ce 	vmovdqu64 (%rsi,%r9,8),%zmm2
   5a9b2:	62 f1 7d 48 70 da f5 	vpshufd $0xf5,%zmm2,%zmm3
   5a9b9:	62 f1 65 58 db 5f 08 	vpandd 0x20(%rdi){1to16},%zmm3,%zmm3
   5a9c0:	62 f1 dd 48 73 f2 0c 	vpsllq $0xc,%zmm2,%zmm4
   5a9c7:	62 f1 dd 58 db 25 2f 	vpandq -0x523d1(%rip){1to8},%zmm4,%zmm4        # 8600 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x284>
   5a9ce:	dc fa ff 
   5a9d1:	62 f3 e5 58 25 25 e4 	vpternlogq $0x36,-0x5231c(%rip){1to8},%zmm3,%zmm4        # 86c0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x70>
   5a9d8:	dc fa ff 36 
   5a9dc:	62 f1 7d 48 70 d2 a0 	vpshufd $0xa0,%zmm2,%zmm2
   5a9e3:	62 f2 6d 48 45 1d 13 	vpsrlvd -0x514ed(%rip),%zmm2,%zmm3        # 9500 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6d0>
   5a9ea:	eb fa ff 
   5a9ed:	62 f2 65 48 7e c1    	vpermt2d %zmm1,%zmm3,%zmm0
   5a9f3:	62 f2 6d 48 45 0d 43 	vpsrlvd -0x514bd(%rip),%zmm2,%zmm1        # 9540 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x710>
   5a9fa:	eb fa ff 
   5a9fd:	62 f2 7d 48 15 c1    	vprolvd %zmm1,%zmm0,%zmm0
   5aa03:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5aa07:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   5aa0b:	62 d2 7d 49 90 0c a2 	vpgatherdd (%r10,%zmm4,4),%zmm1{%k1}
   5aa12:	62 f1 7d 48 db c9    	vpandd %zmm1,%zmm0,%zmm1
   5aa18:	62 f2 f5 48 29 c0    	vpcmpeqq %zmm0,%zmm1,%k0
   5aa1e:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   5aa24:	c5 fd 72 d0 1f       	vpsrld $0x1f,%ymm0,%ymm0
   5aa29:	c4 a1 7e 7f 04 88    	vmovdqu %ymm0,(%rax,%r9,4)
   5aa2f:	48 39 d3             	cmp    %rdx,%rbx
   5aa32:	0f 83 a7 06 00 00    	jae    5b0df <compare_benchmark::lookup+0xe6f>
   5aa38:	8b 6f 20             	mov    0x20(%rdi),%ebp
   5aa3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   5aa40:	4c 8b 0c de          	mov    (%rsi,%rbx,8),%r9
   5aa44:	4d 89 ce             	mov    %r9,%r14
   5aa47:	49 c1 ee 20          	shr    $0x20,%r14
   5aa4b:	41 21 ee             	and    %ebp,%r14d
   5aa4e:	44 89 f7             	mov    %r14d,%edi
   5aa51:	c1 ef 04             	shr    $0x4,%edi
   5aa54:	4c 39 c7             	cmp    %r8,%rdi
   5aa57:	0f 83 da 06 00 00    	jae    5b137 <compare_benchmark::lookup+0xec7>
   5aa5d:	48 c1 e7 06          	shl    $0x6,%rdi
   5aa61:	4c 01 d7             	add    %r10,%rdi
   5aa64:	45 89 f7             	mov    %r14d,%r15d
   5aa67:	41 83 e7 0f          	and    $0xf,%r15d
   5aa6b:	44 89 c9             	mov    %r9d,%ecx
   5aa6e:	83 e1 1f             	and    $0x1f,%ecx
   5aa71:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   5aa75:	44 89 c9             	mov    %r9d,%ecx
   5aa78:	c1 e9 05             	shr    $0x5,%ecx
   5aa7b:	41 d3 c4             	rol    %cl,%r12d
   5aa7e:	46 8b 3c bf          	mov    (%rdi,%r15,4),%r15d
   5aa82:	45 21 e7             	and    %r12d,%r15d
   5aa85:	45 31 e7             	xor    %r12d,%r15d
   5aa88:	45 89 cc             	mov    %r9d,%r12d
   5aa8b:	41 c1 ec 14          	shr    $0x14,%r12d
   5aa8f:	41 83 cc 08          	or     $0x8,%r12d
   5aa93:	45 31 f4             	xor    %r14d,%r12d
   5aa96:	44 89 c9             	mov    %r9d,%ecx
   5aa99:	c1 e9 08             	shr    $0x8,%ecx
   5aa9c:	83 e1 7c             	and    $0x7c,%ecx
   5aa9f:	45 8b 34 0b          	mov    (%r11,%rcx,1),%r14d
   5aaa3:	41 c1 e9 0f          	shr    $0xf,%r9d
   5aaa7:	44 89 c9             	mov    %r9d,%ecx
   5aaaa:	41 d3 c6             	rol    %cl,%r14d
   5aaad:	41 83 e4 0f          	and    $0xf,%r12d
   5aab1:	42 8b 0c a7          	mov    (%rdi,%r12,4),%ecx
   5aab5:	44 21 f1             	and    %r14d,%ecx
   5aab8:	44 31 f1             	xor    %r14d,%ecx
   5aabb:	31 ff                	xor    %edi,%edi
   5aabd:	44 09 f9             	or     %r15d,%ecx
   5aac0:	40 0f 94 c7          	sete   %dil
   5aac4:	89 3c 98             	mov    %edi,(%rax,%rbx,4)
   5aac7:	48 ff c3             	inc    %rbx
   5aaca:	48 39 da             	cmp    %rbx,%rdx
   5aacd:	0f 85 6d ff ff ff    	jne    5aa40 <compare_benchmark::lookup+0x7d0>
   5aad3:	e9 07 06 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5aad8:	62 f1 fe 48 6f 14 ce 	vmovdqu64 (%rsi,%rcx,8),%zmm2
   5aadf:	62 f1 7d 48 70 da f5 	vpshufd $0xf5,%zmm2,%zmm3
   5aae6:	62 f1 65 58 db 5f 08 	vpandd 0x20(%rdi){1to16},%zmm3,%zmm3
   5aaed:	62 f1 dd 48 73 f2 0c 	vpsllq $0xc,%zmm2,%zmm4
   5aaf4:	62 f1 dd 58 db 25 02 	vpandq -0x524fe(%rip){1to8},%zmm4,%zmm4        # 8600 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x284>
   5aafb:	db fa ff 
   5aafe:	62 f3 e5 58 25 25 b7 	vpternlogq $0x36,-0x52449(%rip){1to8},%zmm3,%zmm4        # 86c0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x70>
   5ab05:	db fa ff 36 
   5ab09:	62 f1 7d 48 70 d2 a0 	vpshufd $0xa0,%zmm2,%zmm2
   5ab10:	62 f2 6d 48 45 1d e6 	vpsrlvd -0x5161a(%rip),%zmm2,%zmm3        # 9500 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6d0>
   5ab17:	e9 fa ff 
   5ab1a:	62 f2 65 48 7e c1    	vpermt2d %zmm1,%zmm3,%zmm0
   5ab20:	62 f2 6d 48 45 0d 16 	vpsrlvd -0x515ea(%rip),%zmm2,%zmm1        # 9540 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x710>
   5ab27:	ea fa ff 
   5ab2a:	62 f2 7d 48 15 c1    	vprolvd %zmm1,%zmm0,%zmm0
   5ab30:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   5ab34:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   5ab38:	62 d2 7d 49 90 0c a2 	vpgatherdd (%r10,%zmm4,4),%zmm1{%k1}
   5ab3f:	62 f1 7d 48 db c9    	vpandd %zmm1,%zmm0,%zmm1
   5ab45:	62 f2 f5 48 29 c0    	vpcmpeqq %zmm0,%zmm1,%k0
   5ab4b:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   5ab51:	c5 fd 72 d0 1f       	vpsrld $0x1f,%ymm0,%ymm0
   5ab56:	c5 fe 7f 04 88       	vmovdqu %ymm0,(%rax,%rcx,4)
   5ab5b:	48 39 d3             	cmp    %rdx,%rbx
   5ab5e:	0f 83 7b 05 00 00    	jae    5b0df <compare_benchmark::lookup+0xe6f>
   5ab64:	8b 6f 20             	mov    0x20(%rdi),%ebp
   5ab67:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   5ab6e:	00 00 
   5ab70:	4c 8b 0c de          	mov    (%rsi,%rbx,8),%r9
   5ab74:	4d 89 ce             	mov    %r9,%r14
   5ab77:	49 c1 ee 20          	shr    $0x20,%r14
   5ab7b:	41 21 ee             	and    %ebp,%r14d
   5ab7e:	44 89 f7             	mov    %r14d,%edi
   5ab81:	c1 ef 04             	shr    $0x4,%edi
   5ab84:	4c 39 c7             	cmp    %r8,%rdi
   5ab87:	0f 83 aa 05 00 00    	jae    5b137 <compare_benchmark::lookup+0xec7>
   5ab8d:	48 c1 e7 06          	shl    $0x6,%rdi
   5ab91:	4c 01 d7             	add    %r10,%rdi
   5ab94:	45 89 f7             	mov    %r14d,%r15d
   5ab97:	41 83 e7 0f          	and    $0xf,%r15d
   5ab9b:	44 89 c9             	mov    %r9d,%ecx
   5ab9e:	83 e1 1f             	and    $0x1f,%ecx
   5aba1:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   5aba5:	44 89 c9             	mov    %r9d,%ecx
   5aba8:	c1 e9 05             	shr    $0x5,%ecx
   5abab:	41 d3 c4             	rol    %cl,%r12d
   5abae:	46 8b 3c bf          	mov    (%rdi,%r15,4),%r15d
   5abb2:	45 21 e7             	and    %r12d,%r15d
   5abb5:	45 31 e7             	xor    %r12d,%r15d
   5abb8:	45 89 cc             	mov    %r9d,%r12d
   5abbb:	41 c1 ec 14          	shr    $0x14,%r12d
   5abbf:	41 83 cc 08          	or     $0x8,%r12d
   5abc3:	45 31 f4             	xor    %r14d,%r12d
   5abc6:	44 89 c9             	mov    %r9d,%ecx
   5abc9:	c1 e9 08             	shr    $0x8,%ecx
   5abcc:	83 e1 7c             	and    $0x7c,%ecx
   5abcf:	45 8b 34 0b          	mov    (%r11,%rcx,1),%r14d
   5abd3:	41 c1 e9 0f          	shr    $0xf,%r9d
   5abd7:	44 89 c9             	mov    %r9d,%ecx
   5abda:	41 d3 c6             	rol    %cl,%r14d
   5abdd:	41 83 e4 0f          	and    $0xf,%r12d
   5abe1:	42 8b 0c a7          	mov    (%rdi,%r12,4),%ecx
   5abe5:	44 21 f1             	and    %r14d,%ecx
   5abe8:	44 31 f1             	xor    %r14d,%ecx
   5abeb:	31 ff                	xor    %edi,%edi
   5abed:	44 09 f9             	or     %r15d,%ecx
   5abf0:	40 0f 94 c7          	sete   %dil
   5abf4:	89 3c 98             	mov    %edi,(%rax,%rbx,4)
   5abf7:	48 ff c3             	inc    %rbx
   5abfa:	48 39 da             	cmp    %rbx,%rdx
   5abfd:	0f 85 6d ff ff ff    	jne    5ab70 <compare_benchmark::lookup+0x900>
   5ac03:	e9 d7 04 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5ac08:	62 f2 7d 28 7c c3    	vpbroadcastd %ebx,%ymm0
   5ac0e:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   5ac12:	31 c9                	xor    %ecx,%ecx
   5ac14:	c5 fd 6f 0d 04 dd fa 	vmovdqa -0x522fc(%rip),%ymm1        # 8920 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x2d0>
   5ac1b:	ff 
   5ac1c:	c4 e2 7d 58 15 c7 d8 	vpbroadcastd -0x52739(%rip),%ymm2        # 84ec <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x170>
   5ac23:	fa ff 
   5ac25:	c4 e2 7d 58 1d ca d8 	vpbroadcastd -0x52736(%rip),%ymm3        # 84f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17c>
   5ac2c:	fa ff 
   5ac2e:	c4 e2 7d 58 25 65 d8 	vpbroadcastd -0x5279b(%rip),%ymm4        # 849c <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x120>
   5ac35:	fa ff 
   5ac37:	c4 e2 7d 58 2d bc d8 	vpbroadcastd -0x52744(%rip),%ymm5        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   5ac3e:	fa ff 
   5ac40:	c4 e2 7d 59 35 a7 da 	vpbroadcastq -0x52559(%rip),%ymm6        # 86f0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xa0>
   5ac47:	fa ff 
   5ac49:	e9 f0 00 00 00       	jmp    5ad3e <compare_benchmark::lookup+0xace>
   5ac4e:	66 90                	xchg   %ax,%ax
   5ac50:	62 f1 fe 48 6f 3c ce 	vmovdqu64 (%rsi,%rcx,8),%zmm7
   5ac57:	62 d2 7e 48 35 f8    	vpmovqd %zmm7,%ymm8
   5ac5d:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   5ac61:	62 f2 75 48 36 3c ce 	vpermd (%rsi,%rcx,8),%zmm1,%zmm7
   5ac68:	c5 3d db ca          	vpand  %ymm2,%ymm8,%ymm9
   5ac6c:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   5ac71:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   5ac76:	c4 02 25 90 14 8e    	vpgatherdd %ymm11,(%r14,%ymm9,4),%ymm10
   5ac7c:	c5 c5 db f8          	vpand  %ymm0,%ymm7,%ymm7
   5ac80:	c4 c1 35 72 d0 0a    	vpsrld $0xa,%ymm8,%ymm9
   5ac86:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
   5ac8a:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   5ac8f:	c4 41 1d 76 e4       	vpcmpeqd %ymm12,%ymm12,%ymm12
   5ac94:	c4 02 1d 90 1c 8e    	vpgatherdd %ymm12,(%r14,%ymm9,4),%ymm11
   5ac9a:	c4 c1 35 72 d0 14    	vpsrld $0x14,%ymm8,%ymm9
   5aca0:	c5 35 db cc          	vpand  %ymm4,%ymm9,%ymm9
   5aca4:	c4 c1 1d 72 d0 05    	vpsrld $0x5,%ymm8,%ymm12
   5acaa:	c5 1d db e2          	vpand  %ymm2,%ymm12,%ymm12
   5acae:	c4 42 2d 47 ec       	vpsllvd %ymm12,%ymm10,%ymm13
   5acb3:	c4 41 65 fa e4       	vpsubd %ymm12,%ymm3,%ymm12
   5acb8:	c4 42 2d 45 d4       	vpsrlvd %ymm12,%ymm10,%ymm10
   5acbd:	c4 41 15 eb d2       	vpor   %ymm10,%ymm13,%ymm10
   5acc2:	c4 c1 3d 72 d0 0f    	vpsrld $0xf,%ymm8,%ymm8
   5acc8:	c5 3d db c2          	vpand  %ymm2,%ymm8,%ymm8
   5accc:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   5acd1:	c4 41 15 76 ed       	vpcmpeqd %ymm13,%ymm13,%ymm13
   5acd6:	c4 42 15 90 24 bb    	vpgatherdd %ymm13,(%r11,%ymm7,4),%ymm12
   5acdc:	c4 42 25 47 e8       	vpsllvd %ymm8,%ymm11,%ymm13
   5ace1:	c4 41 65 fa c0       	vpsubd %ymm8,%ymm3,%ymm8
   5ace6:	c4 42 25 45 c0       	vpsrlvd %ymm8,%ymm11,%ymm8
   5aceb:	62 73 45 28 25 cd 36 	vpternlogd $0x36,%ymm5,%ymm7,%ymm9
   5acf2:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   5acf6:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   5acfb:	c4 82 25 90 3c 8b    	vpgatherdd %ymm11,(%r11,%ymm9,4),%ymm7
   5ad01:	c4 41 15 eb c0       	vpor   %ymm8,%ymm13,%ymm8
   5ad06:	c4 41 2d db cc       	vpand  %ymm12,%ymm10,%ymm9
   5ad0b:	62 d1 35 28 76 ca    	vpcmpeqd %ymm10,%ymm9,%k1
   5ad11:	c5 bd db ff          	vpand  %ymm7,%ymm8,%ymm7
   5ad15:	62 d1 45 29 76 c0    	vpcmpeqd %ymm8,%ymm7,%k0{%k1}
   5ad1b:	62 f2 7e 28 38 f8    	vpmovm2d %k0,%ymm7
   5ad21:	c5 c5 db fe          	vpand  %ymm6,%ymm7,%ymm7
   5ad25:	c5 fe 7f 3c 88       	vmovdqu %ymm7,(%rax,%rcx,4)
   5ad2a:	4c 8d 79 08          	lea    0x8(%rcx),%r15
   5ad2e:	48 83 c1 10          	add    $0x10,%rcx
   5ad32:	48 39 d1             	cmp    %rdx,%rcx
   5ad35:	4c 89 f9             	mov    %r15,%rcx
   5ad38:	0f 87 e6 02 00 00    	ja     5b024 <compare_benchmark::lookup+0xdb4>
   5ad3e:	48 8d 79 48          	lea    0x48(%rcx),%rdi
   5ad42:	48 39 d7             	cmp    %rdx,%rdi
   5ad45:	0f 87 05 ff ff ff    	ja     5ac50 <compare_benchmark::lookup+0x9e0>
   5ad4b:	48 8d 79 40          	lea    0x40(%rcx),%rdi
   5ad4f:	48 39 d7             	cmp    %rdx,%rdi
   5ad52:	0f 83 f2 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5ad58:	8b bc ce 04 02 00 00 	mov    0x204(%rsi,%rcx,8),%edi
   5ad5f:	21 df                	and    %ebx,%edi
   5ad61:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5ad66:	48 8d 79 41          	lea    0x41(%rcx),%rdi
   5ad6a:	48 39 d7             	cmp    %rdx,%rdi
   5ad6d:	0f 83 d7 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5ad73:	8b bc ce 0c 02 00 00 	mov    0x20c(%rsi,%rcx,8),%edi
   5ad7a:	21 df                	and    %ebx,%edi
   5ad7c:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5ad81:	48 8d 79 42          	lea    0x42(%rcx),%rdi
   5ad85:	48 39 d7             	cmp    %rdx,%rdi
   5ad88:	0f 83 bc 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5ad8e:	8b bc ce 14 02 00 00 	mov    0x214(%rsi,%rcx,8),%edi
   5ad95:	21 df                	and    %ebx,%edi
   5ad97:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5ad9c:	48 8d 79 43          	lea    0x43(%rcx),%rdi
   5ada0:	48 39 d7             	cmp    %rdx,%rdi
   5ada3:	0f 83 a1 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5ada9:	8b bc ce 1c 02 00 00 	mov    0x21c(%rsi,%rcx,8),%edi
   5adb0:	21 df                	and    %ebx,%edi
   5adb2:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5adb7:	48 8d 79 44          	lea    0x44(%rcx),%rdi
   5adbb:	48 39 d7             	cmp    %rdx,%rdi
   5adbe:	0f 83 86 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5adc4:	8b bc ce 24 02 00 00 	mov    0x224(%rsi,%rcx,8),%edi
   5adcb:	21 df                	and    %ebx,%edi
   5adcd:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5add2:	48 8d 79 45          	lea    0x45(%rcx),%rdi
   5add6:	48 39 d7             	cmp    %rdx,%rdi
   5add9:	0f 83 6b 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5addf:	8b bc ce 2c 02 00 00 	mov    0x22c(%rsi,%rcx,8),%edi
   5ade6:	21 df                	and    %ebx,%edi
   5ade8:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5aded:	48 8d 79 46          	lea    0x46(%rcx),%rdi
   5adf1:	48 39 d7             	cmp    %rdx,%rdi
   5adf4:	0f 83 50 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5adfa:	8b bc ce 34 02 00 00 	mov    0x234(%rsi,%rcx,8),%edi
   5ae01:	21 df                	and    %ebx,%edi
   5ae03:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5ae08:	48 8d 79 47          	lea    0x47(%rcx),%rdi
   5ae0c:	48 39 d7             	cmp    %rdx,%rdi
   5ae0f:	0f 83 35 03 00 00    	jae    5b14a <compare_benchmark::lookup+0xeda>
   5ae15:	8b bc ce 3c 02 00 00 	mov    0x23c(%rsi,%rcx,8),%edi
   5ae1c:	21 df                	and    %ebx,%edi
   5ae1e:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   5ae23:	e9 28 fe ff ff       	jmp    5ac50 <compare_benchmark::lookup+0x9e0>
   5ae28:	62 f2 7d 28 7c c3    	vpbroadcastd %ebx,%ymm0
   5ae2e:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   5ae32:	45 31 ff             	xor    %r15d,%r15d
   5ae35:	c5 fd 6f 0d e3 da fa 	vmovdqa -0x5251d(%rip),%ymm1        # 8920 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x2d0>
   5ae3c:	ff 
   5ae3d:	c4 e2 7d 58 15 a6 d6 	vpbroadcastd -0x5295a(%rip),%ymm2        # 84ec <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x170>
   5ae44:	fa ff 
   5ae46:	c4 e2 7d 58 1d a9 d6 	vpbroadcastd -0x52957(%rip),%ymm3        # 84f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17c>
   5ae4d:	fa ff 
   5ae4f:	c4 e2 7d 58 25 44 d6 	vpbroadcastd -0x529bc(%rip),%ymm4        # 849c <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x120>
   5ae56:	fa ff 
   5ae58:	c4 e2 7d 58 2d 9b d6 	vpbroadcastd -0x52965(%rip),%ymm5        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   5ae5f:	fa ff 
   5ae61:	c4 e2 7d 59 35 86 d8 	vpbroadcastq -0x5277a(%rip),%ymm6        # 86f0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xa0>
   5ae68:	fa ff 
   5ae6a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   5ae70:	4c 89 f9             	mov    %r15,%rcx
   5ae73:	62 b1 fe 48 6f 3c fe 	vmovdqu64 (%rsi,%r15,8),%zmm7
   5ae7a:	62 d2 7e 48 35 f8    	vpmovqd %zmm7,%ymm8
   5ae80:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   5ae84:	62 b2 75 48 36 3c fe 	vpermd (%rsi,%r15,8),%zmm1,%zmm7
   5ae8b:	c5 3d db ca          	vpand  %ymm2,%ymm8,%ymm9
   5ae8f:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   5ae94:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   5ae99:	c4 02 25 90 14 8e    	vpgatherdd %ymm11,(%r14,%ymm9,4),%ymm10
   5ae9f:	c5 c5 db f8          	vpand  %ymm0,%ymm7,%ymm7
   5aea3:	c4 c1 35 72 d0 0a    	vpsrld $0xa,%ymm8,%ymm9
   5aea9:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
   5aead:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   5aeb2:	c4 41 1d 76 e4       	vpcmpeqd %ymm12,%ymm12,%ymm12
   5aeb7:	c4 02 1d 90 1c 8e    	vpgatherdd %ymm12,(%r14,%ymm9,4),%ymm11
   5aebd:	c4 c1 35 72 d0 14    	vpsrld $0x14,%ymm8,%ymm9
   5aec3:	c5 35 db cc          	vpand  %ymm4,%ymm9,%ymm9
   5aec7:	c4 c1 1d 72 d0 05    	vpsrld $0x5,%ymm8,%ymm12
   5aecd:	c5 1d db e2          	vpand  %ymm2,%ymm12,%ymm12
   5aed1:	c4 42 2d 47 ec       	vpsllvd %ymm12,%ymm10,%ymm13
   5aed6:	c4 41 65 fa e4       	vpsubd %ymm12,%ymm3,%ymm12
   5aedb:	c4 42 2d 45 d4       	vpsrlvd %ymm12,%ymm10,%ymm10
   5aee0:	c4 41 15 eb d2       	vpor   %ymm10,%ymm13,%ymm10
   5aee5:	c4 c1 3d 72 d0 0f    	vpsrld $0xf,%ymm8,%ymm8
   5aeeb:	c5 3d db c2          	vpand  %ymm2,%ymm8,%ymm8
   5aeef:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   5aef4:	c4 41 15 76 ed       	vpcmpeqd %ymm13,%ymm13,%ymm13
   5aef9:	c4 42 15 90 24 bb    	vpgatherdd %ymm13,(%r11,%ymm7,4),%ymm12
   5aeff:	c4 42 25 47 e8       	vpsllvd %ymm8,%ymm11,%ymm13
   5af04:	c4 41 65 fa c0       	vpsubd %ymm8,%ymm3,%ymm8
   5af09:	c4 42 25 45 c0       	vpsrlvd %ymm8,%ymm11,%ymm8
   5af0e:	62 73 45 28 25 cd 36 	vpternlogd $0x36,%ymm5,%ymm7,%ymm9
   5af15:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   5af19:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   5af1e:	c4 82 25 90 3c 8b    	vpgatherdd %ymm11,(%r11,%ymm9,4),%ymm7
   5af24:	c4 41 15 eb c0       	vpor   %ymm8,%ymm13,%ymm8
   5af29:	c4 41 2d db cc       	vpand  %ymm12,%ymm10,%ymm9
   5af2e:	62 d1 35 28 76 ca    	vpcmpeqd %ymm10,%ymm9,%k1
   5af34:	c5 bd db ff          	vpand  %ymm7,%ymm8,%ymm7
   5af38:	62 d1 45 29 76 c0    	vpcmpeqd %ymm8,%ymm7,%k0{%k1}
   5af3e:	62 f2 7e 28 38 f8    	vpmovm2d %k0,%ymm7
   5af44:	c5 c5 db fe          	vpand  %ymm6,%ymm7,%ymm7
   5af48:	c4 a1 7e 7f 3c b8    	vmovdqu %ymm7,(%rax,%r15,4)
   5af4e:	49 83 c7 08          	add    $0x8,%r15
   5af52:	48 83 c1 10          	add    $0x10,%rcx
   5af56:	48 39 d1             	cmp    %rdx,%rcx
   5af59:	0f 86 11 ff ff ff    	jbe    5ae70 <compare_benchmark::lookup+0xc00>
   5af5f:	49 39 d7             	cmp    %rdx,%r15
   5af62:	0f 83 77 01 00 00    	jae    5b0df <compare_benchmark::lookup+0xe6f>
   5af68:	49 39 d7             	cmp    %rdx,%r15
   5af6b:	48 89 d7             	mov    %rdx,%rdi
   5af6e:	49 0f 47 ff          	cmova  %r15,%rdi
   5af72:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   5af79:	1f 84 00 00 00 00 00 
   5af80:	4e 8b 14 fe          	mov    (%rsi,%r15,8),%r10
   5af84:	4d 89 d4             	mov    %r10,%r12
   5af87:	49 c1 ec 20          	shr    $0x20,%r12
   5af8b:	41 21 dc             	and    %ebx,%r12d
   5af8e:	45 89 e1             	mov    %r12d,%r9d
   5af91:	41 c1 e9 04          	shr    $0x4,%r9d
   5af95:	4c 3b 0c 24          	cmp    (%rsp),%r9
   5af99:	0f 83 d7 01 00 00    	jae    5b176 <compare_benchmark::lookup+0xf06>
   5af9f:	4c 39 ff             	cmp    %r15,%rdi
   5afa2:	0f 84 b8 01 00 00    	je     5b160 <compare_benchmark::lookup+0xef0>
   5afa8:	49 c1 e1 06          	shl    $0x6,%r9
   5afac:	4d 01 d9             	add    %r11,%r9
   5afaf:	45 89 e5             	mov    %r12d,%r13d
   5afb2:	41 83 e5 0f          	and    $0xf,%r13d
   5afb6:	44 89 d1             	mov    %r10d,%ecx
   5afb9:	83 e1 1f             	and    $0x1f,%ecx
   5afbc:	45 8b 04 8e          	mov    (%r14,%rcx,4),%r8d
   5afc0:	44 89 d1             	mov    %r10d,%ecx
   5afc3:	c1 e9 05             	shr    $0x5,%ecx
   5afc6:	41 d3 c0             	rol    %cl,%r8d
   5afc9:	43 8b 2c a9          	mov    (%r9,%r13,4),%ebp
   5afcd:	44 21 c5             	and    %r8d,%ebp
   5afd0:	44 31 c5             	xor    %r8d,%ebp
   5afd3:	45 89 d0             	mov    %r10d,%r8d
   5afd6:	41 c1 e8 14          	shr    $0x14,%r8d
   5afda:	41 83 c8 08          	or     $0x8,%r8d
   5afde:	45 31 e0             	xor    %r12d,%r8d
   5afe1:	44 89 d1             	mov    %r10d,%ecx
   5afe4:	c1 e9 08             	shr    $0x8,%ecx
   5afe7:	83 e1 7c             	and    $0x7c,%ecx
   5afea:	45 8b 24 0e          	mov    (%r14,%rcx,1),%r12d
   5afee:	41 c1 ea 0f          	shr    $0xf,%r10d
   5aff2:	44 89 d1             	mov    %r10d,%ecx
   5aff5:	41 d3 c4             	rol    %cl,%r12d
   5aff8:	41 83 e0 0f          	and    $0xf,%r8d
   5affc:	43 8b 0c 81          	mov    (%r9,%r8,4),%ecx
   5b000:	44 21 e1             	and    %r12d,%ecx
   5b003:	44 31 e1             	xor    %r12d,%ecx
   5b006:	45 31 c0             	xor    %r8d,%r8d
   5b009:	09 e9                	or     %ebp,%ecx
   5b00b:	41 0f 94 c0          	sete   %r8b
   5b00f:	46 89 04 b8          	mov    %r8d,(%rax,%r15,4)
   5b013:	49 ff c7             	inc    %r15
   5b016:	4c 39 fa             	cmp    %r15,%rdx
   5b019:	0f 85 61 ff ff ff    	jne    5af80 <compare_benchmark::lookup+0xd10>
   5b01f:	e9 bb 00 00 00       	jmp    5b0df <compare_benchmark::lookup+0xe6f>
   5b024:	49 39 d7             	cmp    %rdx,%r15
   5b027:	0f 83 b2 00 00 00    	jae    5b0df <compare_benchmark::lookup+0xe6f>
   5b02d:	49 39 d7             	cmp    %rdx,%r15
   5b030:	48 89 d7             	mov    %rdx,%rdi
   5b033:	49 0f 47 ff          	cmova  %r15,%rdi
   5b037:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   5b03e:	00 00 
   5b040:	4e 8b 14 fe          	mov    (%rsi,%r15,8),%r10
   5b044:	4d 89 d4             	mov    %r10,%r12
   5b047:	49 c1 ec 20          	shr    $0x20,%r12
   5b04b:	41 21 dc             	and    %ebx,%r12d
   5b04e:	45 89 e1             	mov    %r12d,%r9d
   5b051:	41 c1 e9 04          	shr    $0x4,%r9d
   5b055:	4c 3b 0c 24          	cmp    (%rsp),%r9
   5b059:	0f 83 17 01 00 00    	jae    5b176 <compare_benchmark::lookup+0xf06>
   5b05f:	4c 39 ff             	cmp    %r15,%rdi
   5b062:	0f 84 f8 00 00 00    	je     5b160 <compare_benchmark::lookup+0xef0>
   5b068:	49 c1 e1 06          	shl    $0x6,%r9
   5b06c:	4d 01 d9             	add    %r11,%r9
   5b06f:	45 89 e0             	mov    %r12d,%r8d
   5b072:	41 83 e0 0f          	and    $0xf,%r8d
   5b076:	44 89 d1             	mov    %r10d,%ecx
   5b079:	83 e1 1f             	and    $0x1f,%ecx
   5b07c:	45 8b 2c 8e          	mov    (%r14,%rcx,4),%r13d
   5b080:	44 89 d1             	mov    %r10d,%ecx
   5b083:	c1 e9 05             	shr    $0x5,%ecx
   5b086:	41 d3 c5             	rol    %cl,%r13d
   5b089:	43 8b 2c 81          	mov    (%r9,%r8,4),%ebp
   5b08d:	44 21 ed             	and    %r13d,%ebp
   5b090:	44 31 ed             	xor    %r13d,%ebp
   5b093:	45 89 d0             	mov    %r10d,%r8d
   5b096:	41 c1 e8 14          	shr    $0x14,%r8d
   5b09a:	41 83 c8 08          	or     $0x8,%r8d
   5b09e:	45 31 e0             	xor    %r12d,%r8d
   5b0a1:	44 89 d1             	mov    %r10d,%ecx
   5b0a4:	c1 e9 08             	shr    $0x8,%ecx
   5b0a7:	83 e1 7c             	and    $0x7c,%ecx
   5b0aa:	45 8b 24 0e          	mov    (%r14,%rcx,1),%r12d
   5b0ae:	41 c1 ea 0f          	shr    $0xf,%r10d
   5b0b2:	44 89 d1             	mov    %r10d,%ecx
   5b0b5:	41 d3 c4             	rol    %cl,%r12d
   5b0b8:	41 83 e0 0f          	and    $0xf,%r8d
   5b0bc:	43 8b 0c 81          	mov    (%r9,%r8,4),%ecx
   5b0c0:	44 21 e1             	and    %r12d,%ecx
   5b0c3:	44 31 e1             	xor    %r12d,%ecx
   5b0c6:	45 31 c0             	xor    %r8d,%r8d
   5b0c9:	09 e9                	or     %ebp,%ecx
   5b0cb:	41 0f 94 c0          	sete   %r8b
   5b0cf:	46 89 04 b8          	mov    %r8d,(%rax,%r15,4)
   5b0d3:	49 ff c7             	inc    %r15
   5b0d6:	4c 39 fa             	cmp    %r15,%rdx
   5b0d9:	0f 85 61 ff ff ff    	jne    5b040 <compare_benchmark::lookup+0xdd0>
   5b0df:	48 83 c4 48          	add    $0x48,%rsp
   5b0e3:	5b                   	pop    %rbx
   5b0e4:	41 5c                	pop    %r12
   5b0e6:	41 5d                	pop    %r13
   5b0e8:	41 5e                	pop    %r14
   5b0ea:	41 5f                	pop    %r15
   5b0ec:	5d                   	pop    %rbp
   5b0ed:	c5 f8 77             	vzeroupper
   5b0f0:	c3                   	ret
   5b0f1:	48 8d 05 28 08 05 00 	lea    0x50828(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5b0f8:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5b0fd:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5b104:	00 00 
   5b106:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5b10d:	00 00 
   5b10f:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5b113:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5b119:	4c 8d 05 a0 10 05 00 	lea    0x510a0(%rip),%r8        # ac1c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa90>
   5b120:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5b125:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5b12a:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5b12f:	31 ff                	xor    %edi,%edi
   5b131:	ff 15 01 44 05 00    	call   *0x54401(%rip)        # af538 <_DYNAMIC+0x3a8>
   5b137:	48 8d 15 22 10 05 00 	lea    0x51022(%rip),%rdx        # ac160 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa30>
   5b13e:	4c 89 c6             	mov    %r8,%rsi
   5b141:	c5 f8 77             	vzeroupper
   5b144:	ff 15 76 42 05 00    	call   *0x54276(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b14a:	48 8d 05 f7 0f 05 00 	lea    0x50ff7(%rip),%rax        # ac148 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa18>
   5b151:	48 89 d6             	mov    %rdx,%rsi
   5b154:	48 89 c2             	mov    %rax,%rdx
   5b157:	c5 f8 77             	vzeroupper
   5b15a:	ff 15 60 42 05 00    	call   *0x54260(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b160:	48 8d 05 c9 0f 05 00 	lea    0x50fc9(%rip),%rax        # ac130 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa00>
   5b167:	48 89 d6             	mov    %rdx,%rsi
   5b16a:	48 89 c2             	mov    %rax,%rdx
   5b16d:	c5 f8 77             	vzeroupper
   5b170:	ff 15 4a 42 05 00    	call   *0x5424a(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b176:	48 8d 15 e3 0f 05 00 	lea    0x50fe3(%rip),%rdx        # ac160 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa30>
   5b17d:	4c 89 cf             	mov    %r9,%rdi
   5b180:	48 8b 34 24          	mov    (%rsp),%rsi
   5b184:	c5 f8 77             	vzeroupper
   5b187:	ff 15 33 42 05 00    	call   *0x54233(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b18d:	48 8d 15 cc 0f 05 00 	lea    0x50fcc(%rip),%rdx        # ac160 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa30>
   5b194:	4c 89 cf             	mov    %r9,%rdi
   5b197:	4c 89 c6             	mov    %r8,%rsi
   5b19a:	ff 15 20 42 05 00    	call   *0x54220(%rip)        # af3c0 <_DYNAMIC+0x230>

