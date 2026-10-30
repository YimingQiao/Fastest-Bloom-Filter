   15370:	cmp    $0x4,%esi
   15373:	jae    15384 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
   15375:	xor    %r8d,%r8d
   15378:	sub    %r8d,%esi
   1537b:	lea    (%rdx,%r8,8),%rdx
   1537f:	jmp    15650 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   15384:	mov    %esi,%eax
   15386:	xor    %ecx,%ecx
   15388:	vmovdqa64 -0x12752(%rip),%zmm0        # 2c40 <_IO_stdin_used+0xba4>
   15392:	vmovdqa64 -0x1271c(%rip),%zmm1        # 2c80 <_IO_stdin_used+0xbe4>
   1539c:	vbroadcasti32x4 -0x12136(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
   153a6:	vmovdqa64 -0x126b0(%rip),%zmm3        # 2d00 <_IO_stdin_used+0xc64>
   153b0:	vbroadcasti32x4 -0x1215a(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
   153ba:	vbroadcasti32x4 -0x12144(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
   153c4:	vmovdqa64 -0x1260e(%rip),%zmm6        # 2dc0 <_IO_stdin_used+0xd24>
   153ce:	vpbroadcastd -0x13348(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
   153d8:	vbroadcasti32x4 -0x12152(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
   153e2:	vpbroadcastd -0x13363(%rip),%xmm9        # 2088 <__abi_tag+0x1dc4>
   153eb:	vpbroadcastd -0x13360(%rip),%xmm10        # 2094 <__abi_tag+0x1dd0>
   153f4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   15400:	vmovdqu (%rdx,%rcx,8),%ymm11
   15405:	vpxor  %xmm12,%xmm12,%xmm12
   1540a:	vpermd %zmm11,%zmm0,%zmm12
   15410:	vprorvd %zmm2,%zmm12,%zmm13
   15416:	vpxor  %xmm12,%xmm12,%xmm12
   1541b:	vpermd %zmm11,%zmm1,%zmm12
   15421:	vpxor  %xmm11,%xmm11,%xmm11
   15426:	vpermd %zmm3,%zmm13,%zmm11
   1542c:	vpsrld $0x4,%zmm13,%zmm13
   15433:	vprolvd %zmm13,%zmm11,%zmm11
   15439:	vpsrlvd %zmm4,%zmm12,%zmm13
   1543f:	vpandd %zmm5,%zmm13,%zmm14
   15445:	vpsrld $0x8,%zmm12,%zmm13
   1544c:	vpbroadcastd 0x18(%rdi),%zmm15
   15453:	vpmuludq %zmm13,%zmm15,%zmm13
   15459:	vpsrlq $0x18,%zmm13,%zmm13
   15460:	vpsrlq $0x28,%zmm12,%zmm16
   15467:	vpmuludq %zmm16,%zmm15,%zmm15
   1546d:	vpshufb %zmm6,%zmm15,%zmm15
   15473:	vpord  %zmm13,%zmm15,%zmm13
   15479:	vpslld $0x4,%zmm13,%zmm13
   15480:	vpternlogd $0xec,%zmm7,%zmm13,%zmm12
   15487:	vpternlogd $0x1e,%zmm8,%zmm14,%zmm12
   1548e:	vmovd  %xmm13,%r8d
   15493:	vpand  %xmm9,%xmm12,%xmm14
   15498:	vpsllvd %xmm14,%xmm10,%xmm14
   1549d:	vpshufd $0xee,%xmm14,%xmm15
   154a3:	vpor   %xmm15,%xmm14,%xmm14
   154a8:	vpshufd $0x55,%xmm14,%xmm15
   154ae:	vpor   %xmm15,%xmm14,%xmm14
   154b3:	vmovw  %xmm14,%r9d
   154b9:	vinserti128 $0x1,%xmm0,%ymm11,%ymm14
   154bf:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   154c6:	kmovd  %r9d,%k1
   154cb:	vpexpandd %zmm14,%zmm14{%k1}{z}
   154d1:	mov    (%rdi),%r9
   154d4:	vporq  (%r9,%r8,4),%zmm14,%zmm14
   154db:	vmovdqa64 %zmm14,(%r9,%r8,4)
   154e2:	vextracti128 $0x1,%ymm13,%xmm14
   154e8:	vmovd  %xmm14,%r8d
   154ed:	vextracti128 $0x1,%ymm12,%xmm14
   154f3:	vpand  %xmm9,%xmm14,%xmm14
   154f8:	vpsllvd %xmm14,%xmm10,%xmm14
   154fd:	vpshufd $0xee,%xmm14,%xmm15
   15503:	vpor   %xmm15,%xmm14,%xmm14
   15508:	vpshufd $0x55,%xmm14,%xmm15
   1550e:	vpor   %xmm15,%xmm14,%xmm14
   15513:	vmovw  %xmm14,%r9d
   15519:	vextracti128 $0x1,%ymm11,%xmm14
   1551f:	vinserti128 $0x1,%xmm0,%ymm14,%ymm14
   15525:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   1552c:	kmovd  %r9d,%k1
   15531:	vpexpandd %zmm14,%zmm14{%k1}{z}
   15537:	mov    (%rdi),%r9
   1553a:	vporq  (%r9,%r8,4),%zmm14,%zmm14
   15541:	vmovdqa64 %zmm14,(%r9,%r8,4)
   15548:	vextracti32x4 $0x2,%zmm13,%xmm14
   1554f:	vextracti32x4 $0x2,%zmm12,%xmm15
   15556:	vpand  %xmm9,%xmm15,%xmm15
   1555b:	vpsllvd %xmm15,%xmm10,%xmm15
   15560:	vpshufd $0xee,%xmm15,%xmm16
   15567:	vpord  %xmm16,%xmm15,%xmm15
   1556d:	vpshufd $0x55,%xmm15,%xmm16
   15574:	vpord  %xmm16,%xmm15,%xmm15
   1557a:	vmovw  %xmm15,%r8d
   15580:	vextracti32x4 $0x2,%zmm11,%xmm15
   15587:	vinserti128 $0x1,%xmm0,%ymm15,%ymm15
   1558d:	vinserti64x4 $0x1,%ymm0,%zmm15,%zmm15
   15594:	kmovd  %r8d,%k1
   15599:	vpexpandd %zmm15,%zmm15{%k1}{z}
   1559f:	vmovd  %xmm14,%r8d
   155a4:	mov    (%rdi),%r9
   155a7:	vporq  (%r9,%r8,4),%zmm15,%zmm14
   155ae:	vmovdqa64 %zmm14,(%r9,%r8,4)
   155b5:	vextracti32x4 $0x3,%zmm13,%xmm13
   155bc:	vmovd  %xmm13,%r8d
   155c1:	vextracti32x4 $0x3,%zmm12,%xmm12
   155c8:	vpand  %xmm9,%xmm12,%xmm12
   155cd:	vpsllvd %xmm12,%xmm10,%xmm12
   155d2:	vpshufd $0xee,%xmm12,%xmm13
   155d8:	vpor   %xmm13,%xmm12,%xmm12
   155dd:	vpshufd $0x55,%xmm12,%xmm13
   155e3:	vpor   %xmm13,%xmm12,%xmm12
   155e8:	vmovw  %xmm12,%r9d
   155ee:	vextracti32x4 $0x3,%zmm11,%xmm11
   155f5:	vinserti128 $0x1,%xmm0,%ymm11,%ymm11
   155fb:	vinserti64x4 $0x1,%ymm0,%zmm11,%zmm11
   15602:	kmovd  %r9d,%k1
   15607:	vpexpandd %zmm11,%zmm11{%k1}{z}
   1560d:	mov    (%rdi),%r9
   15610:	vporq  (%r9,%r8,4),%zmm11,%zmm11
   15617:	vmovdqa64 %zmm11,(%r9,%r8,4)
   1561e:	lea    0x4(%rcx),%r8
   15622:	add    $0x8,%rcx
   15626:	cmp    %rax,%rcx
   15629:	mov    %r8,%rcx
   1562c:	jbe    15400 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x90>
   15632:	sub    %r8d,%esi
   15635:	lea    (%rdx,%r8,8),%rdx
   15639:	vzeroupper
   1563c:	jmp    15650 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
