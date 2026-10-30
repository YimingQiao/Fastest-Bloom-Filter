00000000000151e0 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)>:
   151e0:	push   %r14
   151e2:	push   %rbx
   151e3:	cmp    $0x1,%esi
   151e6:	jne    1523f <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x5f>
   151e8:	mov    (%rdx),%rax
   151eb:	mov    %rax,%rdx
   151ee:	shr    $0x20,%rdx
   151f2:	and    0x18(%rdi),%edx
   151f5:	vpbroadcastd %eax,%ymm0
   151fb:	mov    (%rdi),%rax
   151fe:	shl    $0x6,%rdx
   15202:	vpmulld -0x131eb(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   1520b:	vmovdqa64 (%rax,%rdx,1),%zmm1
   15212:	vpsrld $0x1a,%ymm0,%ymm0
   15217:	vpmovzxdq %ymm0,%zmm0
   1521d:	vpsrlvq %zmm0,%zmm1,%zmm0
   15223:	vptestnmq -0x13195(%rip){1to8},%zmm0,%k0        # 2098 <_IO_stdin_used+0x90>
   1522d:	xor    %eax,%eax
   1522f:	kortestb %k0,%k0
   15233:	sete   %al
   15236:	mov    %eax,(%rcx)
   15238:	pop    %rbx
   15239:	pop    %r14
   1523b:	vzeroupper
   1523e:	ret
   1523f:	mov    %esi,%eax
   15241:	cmp    $0x10,%esi
   15244:	jae    15256 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x76>
   15246:	test   %esi,%esi
   15248:	je     15238 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   1524a:	cmp    $0x1,%eax
   1524d:	jne    15279 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x99>
   1524f:	xor    %eax,%eax
   15251:	jmp    15352 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x172>
   15256:	cmp    $0x21,%esi
   15259:	jb     15271 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x91>
   1525b:	lea    -0x20(%rax),%r8
   1525f:	cmp    $0x21,%rax
   15263:	jne    153aa <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   15269:	xor    %r9d,%r9d
   1526c:	jmp    154a8 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x2c8>
   15271:	xor    %r8d,%r8d
   15274:	jmp    15510 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x330>
   15279:	mov    %esi,%r8d
   1527c:	and    $0xe,%r8d
   15280:	xor    %eax,%eax
   15282:	vmovdqa64 -0x12c0c(%rip),%zmm0        # 2680 <_IO_stdin_used+0x678>
   1528c:	vpbroadcastq -0x131fe(%rip),%zmm1        # 2098 <_IO_stdin_used+0x90>
   15296:	cs nopw 0x0(%rax,%rax,1)
   152a0:	mov    (%rdx,%rax,8),%r9
   152a4:	mov    %r9d,%r10d
   152a7:	shr    $0x20,%r9
   152ab:	and    0x18(%rdi),%r9d
   152af:	mov    (%rdi),%r11
   152b2:	shl    $0x6,%r9
   152b6:	vmovdqa64 (%r11,%r9,1),%zmm2
   152bd:	vpbroadcastq %r10,%zmm3
   152c3:	vpmulld %zmm0,%zmm3,%zmm3
   152c9:	vpsrlq $0x1a,%zmm3,%zmm3
   152d0:	vpsrlvq %zmm3,%zmm2,%zmm2
   152d6:	vptestnmq %zmm1,%zmm2,%k0
   152dc:	xor    %r9d,%r9d
   152df:	kortestb %k0,%k0
   152e3:	sete   %r9b
   152e7:	mov    %r9d,(%rcx,%rax,4)
   152eb:	mov    0x8(%rdx,%rax,8),%r9
   152f0:	mov    %r9,%r10
   152f3:	shr    $0x20,%r10
   152f7:	and    0x18(%rdi),%r10d
   152fb:	mov    %r9d,%r9d
   152fe:	mov    (%rdi),%r11
   15301:	shl    $0x6,%r10
   15305:	vpbroadcastq %r9,%zmm2
   1530b:	vpmulld %zmm0,%zmm2,%zmm2
   15311:	vmovdqa64 (%r11,%r10,1),%zmm3
   15318:	vpsrlq $0x1a,%zmm2,%zmm2
   1531f:	vpsrlvq %zmm2,%zmm3,%zmm2
   15325:	vptestnmq %zmm1,%zmm2,%k0
   1532b:	xor    %r9d,%r9d
   1532e:	kortestb %k0,%k0
   15332:	sete   %r9b
   15336:	mov    %r9d,0x4(%rcx,%rax,4)
   1533b:	add    $0x2,%rax
   1533f:	cmp    %rax,%r8
   15342:	jne    152a0 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0xc0>
   15348:	test   $0x1,%sil
   1534c:	je     15238 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15352:	mov    (%rdx,%rax,8),%rdx
   15356:	mov    %rdx,%rsi
   15359:	shr    $0x20,%rsi
   1535d:	and    0x18(%rdi),%esi
   15360:	mov    %edx,%edx
   15362:	mov    (%rdi),%rdi
   15365:	vpbroadcastq %rdx,%zmm0
   1536b:	vpmulld -0x12cf5(%rip),%zmm0,%zmm0        # 2680 <_IO_stdin_used+0x678>
   15375:	shl    $0x6,%rsi
   15379:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   15380:	vpsrlq $0x1a,%zmm0,%zmm0
   15387:	vpsrlvq %zmm0,%zmm1,%zmm0
   1538d:	vptestnmq -0x132ff(%rip){1to8},%zmm0,%k0        # 2098 <_IO_stdin_used+0x90>
   15397:	xor    %edx,%edx
   15399:	kortestb %k0,%k0
   1539d:	sete   %dl
   153a0:	mov    %edx,(%rcx,%rax,4)
   153a3:	pop    %rbx
   153a4:	pop    %r14
   153a6:	vzeroupper
   153a9:	ret
   153aa:	and    $0x1,%esi
   153ad:	mov    %r8,%r10
   153b0:	sub    %rsi,%r10
   153b3:	xor    %r9d,%r9d
   153b6:	vmovdqa -0x1339e(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   153be:	vpbroadcastq -0x13330(%rip),%zmm1        # 2098 <_IO_stdin_used+0x90>
   153c8:	nopl   0x0(%rax,%rax,1)
   153d0:	mov    0x18(%rdi),%r11d
   153d4:	mov    0x104(%rdx,%r9,8),%ebx
   153dc:	and    %r11d,%ebx
   153df:	mov    (%rdi),%r14
   153e2:	shl    $0x6,%rbx
   153e6:	prefetcht0 (%r14,%rbx,1)
   153eb:	mov    (%rdx,%r9,8),%rbx
   153ef:	vpbroadcastd %ebx,%ymm2
   153f5:	shr    $0x20,%rbx
   153f9:	and    %r11d,%ebx
   153fc:	shl    $0x6,%rbx
   15400:	vmovdqa64 (%r14,%rbx,1),%zmm3
   15407:	vpmulld %ymm0,%ymm2,%ymm2
   1540c:	vpsrld $0x1a,%ymm2,%ymm2
   15411:	vpmovzxdq %ymm2,%zmm2
   15417:	vpsrlvq %zmm2,%zmm3,%zmm2
   1541d:	vptestnmq %zmm1,%zmm2,%k0
   15423:	xor    %r11d,%r11d
   15426:	kortestb %k0,%k0
   1542a:	sete   %r11b
   1542e:	mov    %r11d,(%rcx,%r9,4)
   15432:	mov    0x18(%rdi),%r11d
   15436:	mov    0x10c(%rdx,%r9,8),%ebx
   1543e:	and    %r11d,%ebx
   15441:	mov    (%rdi),%r14
   15444:	shl    $0x6,%rbx
   15448:	prefetcht0 (%r14,%rbx,1)
   1544d:	mov    0x8(%rdx,%r9,8),%rbx
   15452:	vpbroadcastd %ebx,%ymm2
   15458:	shr    $0x20,%rbx
   1545c:	and    %r11d,%ebx
   1545f:	shl    $0x6,%rbx
   15463:	vmovdqa64 (%r14,%rbx,1),%zmm3
   1546a:	vpmulld %ymm0,%ymm2,%ymm2
   1546f:	vpsrld $0x1a,%ymm2,%ymm2
   15474:	vpmovzxdq %ymm2,%zmm2
   1547a:	vpsrlvq %zmm2,%zmm3,%zmm2
   15480:	vptestnmq %zmm1,%zmm2,%k0
   15486:	xor    %r11d,%r11d
   15489:	kortestb %k0,%k0
   1548d:	sete   %r11b
   15491:	mov    %r11d,0x4(%rcx,%r9,4)
   15496:	add    $0x2,%r9
   1549a:	cmp    %r9,%r10
   1549d:	jne    153d0 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   154a3:	test   %rsi,%rsi
   154a6:	je     15510 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x330>
   154a8:	mov    0x18(%rdi),%esi
   154ab:	mov    0x104(%rdx,%r9,8),%r10d
   154b3:	and    %esi,%r10d
   154b6:	mov    (%rdi),%r11
   154b9:	shl    $0x6,%r10
   154bd:	prefetcht0 (%r11,%r10,1)
   154c2:	mov    (%rdx,%r9,8),%r10
   154c6:	vpbroadcastd %r10d,%ymm0
   154cc:	shr    $0x20,%r10
   154d0:	and    %esi,%r10d
   154d3:	shl    $0x6,%r10
   154d7:	vpmulld -0x134c0(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   154e0:	vmovdqa64 (%r11,%r10,1),%zmm1
   154e7:	vpsrld $0x1a,%ymm0,%ymm0
   154ec:	vpmovzxdq %ymm0,%zmm0
   154f2:	vpsrlvq %zmm0,%zmm1,%zmm0
   154f8:	vptestnmq -0x1346a(%rip){1to8},%zmm0,%k0        # 2098 <_IO_stdin_used+0x90>
   15502:	xor    %esi,%esi
   15504:	kortestb %k0,%k0
   15508:	sete   %sil
   1550c:	mov    %esi,(%rcx,%r9,4)
   15510:	cmp    %rax,%r8
   15513:	jae    15238 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15519:	vmovdqa -0x13501(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   15521:	vpbroadcastq -0x13493(%rip),%zmm1        # 2098 <_IO_stdin_used+0x90>
   1552b:	nopl   0x0(%rax,%rax,1)
   15530:	mov    (%rdx,%r8,8),%rsi
   15534:	vpbroadcastd %esi,%ymm2
   1553a:	shr    $0x20,%rsi
   1553e:	and    0x18(%rdi),%esi
   15541:	mov    (%rdi),%r9
   15544:	shl    $0x6,%rsi
   15548:	vpmulld %ymm0,%ymm2,%ymm2
   1554d:	vmovdqa64 (%r9,%rsi,1),%zmm3
   15554:	vpsrld $0x1a,%ymm2,%ymm2
   15559:	vpmovzxdq %ymm2,%zmm2
   1555f:	vpsrlvq %zmm2,%zmm3,%zmm2
   15565:	vptestnmq %zmm1,%zmm2,%k0
   1556b:	xor    %esi,%esi
   1556d:	kortestb %k0,%k0
   15571:	sete   %sil
   15575:	mov    %esi,(%rcx,%r8,4)
   15579:	inc    %r8
   1557c:	cmp    %r8,%rax
   1557f:	jne    15530 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x350>
   15581:	jmp    15238 <void lookup_kernel<bloom_filters::Split64BitShuffleOriginal, unsigned long>(bloom_filters::Split64BitShuffleOriginal&, unsigned long, unsigned long const*, unsigned int*)+0x58>
   15586:	int3
   15587:	int3
   15588:	int3
   15589:	int3
   1558a:	int3
   1558b:	int3
   1558c:	int3
   1558d:	int3
   1558e:	int3
   1558f:	int3

