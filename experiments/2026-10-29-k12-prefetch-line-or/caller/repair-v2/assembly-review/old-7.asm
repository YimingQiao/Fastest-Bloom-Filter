   152d0:	cmp    $0x4,%esi
   152d3:	jae    152e4 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
   152d5:	xor    %r9d,%r9d
   152d8:	sub    %r9d,%esi
   152db:	lea    (%rdx,%r9,8),%rdx
   152df:	jmp    15950 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   152e4:	push   %rbx
   152e5:	mov    %esi,%eax
   152e7:	xor    %ecx,%ecx
   152e9:	vmovdqa64 -0x128b3(%rip),%zmm0        # 2a40 <_IO_stdin_used+0x9a4>
   152f3:	vmovdqa64 -0x1287d(%rip),%zmm1        # 2a80 <_IO_stdin_used+0x9e4>
   152fd:	vbroadcasti32x4 -0x12097(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
   15307:	vmovdqa64 -0x12811(%rip),%zmm3        # 2b00 <_IO_stdin_used+0xa64>
   15311:	vbroadcasti32x4 -0x120bb(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
   1531b:	vbroadcasti32x4 -0x120a5(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
   15325:	vmovdqa64 -0x1276f(%rip),%zmm6        # 2bc0 <_IO_stdin_used+0xb24>
   1532f:	vpbroadcastd -0x132a9(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
   15339:	vbroadcasti32x4 -0x120b3(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
   15343:	vpbroadcastd -0x132c4(%rip),%xmm9        # 2088 <__abi_tag+0x1dc4>
   1534c:	vpbroadcastd -0x132c1(%rip),%xmm10        # 2094 <__abi_tag+0x1dd0>
   15355:	movabs $0x3ffffffc0,%r8
   1535f:	jmp    1559e <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x2ce>
   15364:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   15370:	vmovdqu (%rdx,%rcx,8),%ymm11
   15375:	vpxor  %xmm12,%xmm12,%xmm12
   1537a:	vpermd %zmm11,%zmm0,%zmm12
   15380:	vprorvd %zmm2,%zmm12,%zmm13
   15386:	vpxor  %xmm12,%xmm12,%xmm12
   1538b:	vpermd %zmm11,%zmm1,%zmm12
   15391:	vpxor  %xmm11,%xmm11,%xmm11
   15396:	vpermd %zmm3,%zmm13,%zmm11
   1539c:	vpsrld $0x4,%zmm13,%zmm13
   153a3:	vprolvd %zmm13,%zmm11,%zmm11
   153a9:	vpsrlvd %zmm4,%zmm12,%zmm13
   153af:	vpandd %zmm5,%zmm13,%zmm14
   153b5:	vpsrld $0x8,%zmm12,%zmm13
   153bc:	vpbroadcastd %r10d,%zmm15
   153c2:	vpmuludq %zmm13,%zmm15,%zmm13
   153c8:	vpsrlq $0x18,%zmm13,%zmm13
   153cf:	vpsrlq $0x28,%zmm12,%zmm16
   153d6:	vpmuludq %zmm16,%zmm15,%zmm15
   153dc:	vpshufb %zmm6,%zmm15,%zmm15
   153e2:	vpord  %zmm13,%zmm15,%zmm13
   153e8:	vpslld $0x4,%zmm13,%zmm13
   153ef:	vpternlogd $0xec,%zmm7,%zmm13,%zmm12
   153f6:	vpternlogd $0x1e,%zmm8,%zmm14,%zmm12
   153fd:	vmovd  %xmm13,%r10d
   15402:	vpand  %xmm9,%xmm12,%xmm14
   15407:	vpsllvd %xmm14,%xmm10,%xmm14
   1540c:	vpshufd $0xee,%xmm14,%xmm15
   15412:	vpor   %xmm15,%xmm14,%xmm14
   15417:	vpshufd $0x55,%xmm14,%xmm15
   1541d:	vpor   %xmm15,%xmm14,%xmm14
   15422:	vmovw  %xmm14,%r11d
   15428:	vinserti128 $0x1,%xmm0,%ymm11,%ymm14
   1542e:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   15435:	kmovd  %r11d,%k1
   1543a:	vpexpandd %zmm14,%zmm14{%k1}{z}
   15440:	vporq  (%r9,%r10,4),%zmm14,%zmm14
   15447:	vmovdqa64 %zmm14,(%r9,%r10,4)
   1544e:	vextracti128 $0x1,%ymm13,%xmm14
   15454:	vmovd  %xmm14,%r9d
   15459:	vextracti128 $0x1,%ymm12,%xmm14
   1545f:	vpand  %xmm9,%xmm14,%xmm14
   15464:	vpsllvd %xmm14,%xmm10,%xmm14
   15469:	vpshufd $0xee,%xmm14,%xmm15
   1546f:	vpor   %xmm15,%xmm14,%xmm14
   15474:	vpshufd $0x55,%xmm14,%xmm15
   1547a:	vpor   %xmm15,%xmm14,%xmm14
   1547f:	vmovw  %xmm14,%r10d
   15485:	vextracti128 $0x1,%ymm11,%xmm14
   1548b:	vinserti128 $0x1,%xmm0,%ymm14,%ymm14
   15491:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   15498:	kmovd  %r10d,%k1
   1549d:	vpexpandd %zmm14,%zmm14{%k1}{z}
   154a3:	mov    (%rdi),%r10
   154a6:	vporq  (%r10,%r9,4),%zmm14,%zmm14
   154ad:	vmovdqa64 %zmm14,(%r10,%r9,4)
   154b4:	vextracti32x4 $0x2,%zmm13,%xmm14
   154bb:	vextracti32x4 $0x2,%zmm12,%xmm15
   154c2:	vpand  %xmm9,%xmm15,%xmm15
   154c7:	vpsllvd %xmm15,%xmm10,%xmm15
   154cc:	vpshufd $0xee,%xmm15,%xmm16
   154d3:	vpord  %xmm16,%xmm15,%xmm15
   154d9:	vpshufd $0x55,%xmm15,%xmm16
   154e0:	vpord  %xmm16,%xmm15,%xmm15
   154e6:	vmovw  %xmm15,%r9d
   154ec:	vextracti32x4 $0x2,%zmm11,%xmm15
   154f3:	vinserti128 $0x1,%xmm0,%ymm15,%ymm15
   154f9:	vinserti64x4 $0x1,%ymm0,%zmm15,%zmm15
   15500:	kmovd  %r9d,%k1
   15505:	vpexpandd %zmm15,%zmm15{%k1}{z}
   1550b:	vmovd  %xmm14,%r9d
   15510:	mov    (%rdi),%r10
   15513:	vporq  (%r10,%r9,4),%zmm15,%zmm14
   1551a:	vmovdqa64 %zmm14,(%r10,%r9,4)
   15521:	vextracti32x4 $0x3,%zmm13,%xmm13
   15528:	vmovd  %xmm13,%r9d
   1552d:	vextracti32x4 $0x3,%zmm12,%xmm12
   15534:	vpand  %xmm9,%xmm12,%xmm12
   15539:	vpsllvd %xmm12,%xmm10,%xmm12
   1553e:	vpshufd $0xee,%xmm12,%xmm13
   15544:	vpor   %xmm13,%xmm12,%xmm12
   15549:	vpshufd $0x55,%xmm12,%xmm13
   1554f:	vpor   %xmm13,%xmm12,%xmm12
   15554:	vmovw  %xmm12,%r10d
   1555a:	vextracti32x4 $0x3,%zmm11,%xmm11
   15561:	vinserti128 $0x1,%xmm0,%ymm11,%ymm11
   15567:	vinserti64x4 $0x1,%ymm0,%zmm11,%zmm11
   1556e:	kmovd  %r10d,%k1
   15573:	vpexpandd %zmm11,%zmm11{%k1}{z}
   15579:	mov    (%rdi),%r10
   1557c:	vporq  (%r10,%r9,4),%zmm11,%zmm11
   15583:	vmovdqa64 %zmm11,(%r10,%r9,4)
   1558a:	lea    0x4(%rcx),%r9
   1558e:	add    $0x8,%rcx
   15592:	cmp    %rax,%rcx
   15595:	mov    %r9,%rcx
   15598:	ja     1565b <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x38b>
   1559e:	lea    0x44(%rcx),%r11
   155a2:	mov    0x18(%rdi),%r10d
   155a6:	mov    (%rdi),%r9
   155a9:	cmp    %rax,%r11
   155ac:	ja     15370 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   155b2:	mov    0x200(%rdx,%rcx,8),%r11
   155ba:	mov    %r11,%rbx
   155bd:	shr    $0x20,%rbx
   155c1:	shr    $0x28,%r11
   155c5:	imul   %r10,%r11
   155c9:	and    $0x3,%ebx
   155cc:	shr    $0x12,%r11
   155d0:	and    %r8,%r11
   155d3:	add    %r9,%r11
   155d6:	prefetchw (%r11,%rbx,4)
   155db:	mov    0x208(%rdx,%rcx,8),%r11
   155e3:	mov    %r11,%rbx
   155e6:	shr    $0x20,%rbx
   155ea:	shr    $0x28,%r11
   155ee:	imul   %r10,%r11
   155f2:	and    $0x3,%ebx
   155f5:	shr    $0x12,%r11
   155f9:	and    %r8,%r11
   155fc:	add    %r9,%r11
   155ff:	prefetchw (%r11,%rbx,4)
   15604:	mov    0x210(%rdx,%rcx,8),%r11
   1560c:	mov    %r11,%rbx
   1560f:	shr    $0x20,%rbx
   15613:	shr    $0x28,%r11
   15617:	imul   %r10,%r11
   1561b:	and    $0x3,%ebx
   1561e:	shr    $0x12,%r11
   15622:	and    %r8,%r11
   15625:	add    %r9,%r11
   15628:	prefetchw (%r11,%rbx,4)
   1562d:	mov    0x218(%rdx,%rcx,8),%r11
   15635:	mov    %r11,%rbx
   15638:	shr    $0x20,%rbx
   1563c:	shr    $0x28,%r11
   15640:	imul   %r10,%r11
   15644:	and    $0x3,%ebx
   15647:	shr    $0x12,%r11
   1564b:	and    %r8,%r11
   1564e:	add    %r9,%r11
   15651:	prefetchw (%r11,%rbx,4)
   15656:	jmp    15370 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   1565b:	pop    %rbx
   1565c:	sub    %r9d,%esi
   1565f:	lea    (%rdx,%r9,8),%rdx
   15663:	vzeroupper
   15666:	jmp    15950 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
