   16420:	cmp    $0x4,%esi
   16423:	jae    16434 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
   16425:	xor    %r9d,%r9d
   16428:	sub    %r9d,%esi
   1642b:	lea    (%rdx,%r9,8),%rdx
   1642f:	jmp    16a50 <bloom_filters::K12PrefetchLineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   16434:	push   %rbx
   16435:	mov    %esi,%eax
   16437:	xor    %ecx,%ecx
   16439:	vmovdqa64 -0x13983(%rip),%zmm0        # 2ac0 <_IO_stdin_used+0x9e4>
   16443:	vmovdqa64 -0x1394d(%rip),%zmm1        # 2b00 <_IO_stdin_used+0xa24>
   1644d:	vbroadcasti32x4 -0x130d7(%rip),%zmm2        # 3380 <typeinfo name for main::$_3+0x28>
   16457:	vmovdqa64 -0x138e1(%rip),%zmm3        # 2b80 <_IO_stdin_used+0xaa4>
   16461:	vbroadcasti32x4 -0x130fb(%rip),%zmm4        # 3370 <typeinfo name for main::$_3+0x18>
   1646b:	vbroadcasti32x4 -0x130e5(%rip),%zmm5        # 3390 <typeinfo name for main::$_3+0x38>
   16475:	vmovdqa64 -0x1383f(%rip),%zmm6        # 2c40 <_IO_stdin_used+0xb64>
   1647f:	vpbroadcastd -0x143b9(%rip),%zmm7        # 20d0 <__abi_tag+0x1e0c>
   16489:	vbroadcasti32x4 -0x130f3(%rip),%zmm8        # 33a0 <typeinfo name for main::$_3+0x48>
   16493:	vpbroadcastd -0x143d4(%rip),%xmm9        # 20c8 <__abi_tag+0x1e04>
   1649c:	vpbroadcastd -0x143d1(%rip),%xmm10        # 20d4 <__abi_tag+0x1e10>
   164a5:	movabs $0x3ffffffc0,%r8
   164af:	jmp    166ee <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x2ce>
   164b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   164c0:	vmovdqu (%rdx,%rcx,8),%ymm11
   164c5:	vpxor  %xmm12,%xmm12,%xmm12
   164ca:	vpermd %zmm11,%zmm0,%zmm12
   164d0:	vprorvd %zmm2,%zmm12,%zmm13
   164d6:	vpxor  %xmm12,%xmm12,%xmm12
   164db:	vpermd %zmm11,%zmm1,%zmm12
   164e1:	vpxor  %xmm11,%xmm11,%xmm11
   164e6:	vpermd %zmm3,%zmm13,%zmm11
   164ec:	vpsrld $0x4,%zmm13,%zmm13
   164f3:	vprolvd %zmm13,%zmm11,%zmm11
   164f9:	vpsrlvd %zmm4,%zmm12,%zmm13
   164ff:	vpandd %zmm5,%zmm13,%zmm14
   16505:	vpsrld $0x8,%zmm12,%zmm13
   1650c:	vpbroadcastd %r10d,%zmm15
   16512:	vpmuludq %zmm13,%zmm15,%zmm13
   16518:	vpsrlq $0x18,%zmm13,%zmm13
   1651f:	vpsrlq $0x28,%zmm12,%zmm16
   16526:	vpmuludq %zmm16,%zmm15,%zmm15
   1652c:	vpshufb %zmm6,%zmm15,%zmm15
   16532:	vpord  %zmm13,%zmm15,%zmm13
   16538:	vpslld $0x4,%zmm13,%zmm13
   1653f:	vpternlogd $0xec,%zmm7,%zmm13,%zmm12
   16546:	vpternlogd $0x1e,%zmm8,%zmm14,%zmm12
   1654d:	vmovd  %xmm13,%r10d
   16552:	vpand  %xmm9,%xmm12,%xmm14
   16557:	vpsllvd %xmm14,%xmm10,%xmm14
   1655c:	vpshufd $0xee,%xmm14,%xmm15
   16562:	vpor   %xmm15,%xmm14,%xmm14
   16567:	vpshufd $0x55,%xmm14,%xmm15
   1656d:	vpor   %xmm15,%xmm14,%xmm14
   16572:	vmovw  %xmm14,%r11d
   16578:	vinserti128 $0x1,%xmm0,%ymm11,%ymm14
   1657e:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   16585:	kmovd  %r11d,%k1
   1658a:	vpexpandd %zmm14,%zmm14{%k1}{z}
   16590:	vporq  (%r9,%r10,4),%zmm14,%zmm14
   16597:	vmovdqa64 %zmm14,(%r9,%r10,4)
   1659e:	vextracti128 $0x1,%ymm13,%xmm14
   165a4:	vmovd  %xmm14,%r9d
   165a9:	vextracti128 $0x1,%ymm12,%xmm14
   165af:	vpand  %xmm9,%xmm14,%xmm14
   165b4:	vpsllvd %xmm14,%xmm10,%xmm14
   165b9:	vpshufd $0xee,%xmm14,%xmm15
   165bf:	vpor   %xmm15,%xmm14,%xmm14
   165c4:	vpshufd $0x55,%xmm14,%xmm15
   165ca:	vpor   %xmm15,%xmm14,%xmm14
   165cf:	vmovw  %xmm14,%r10d
   165d5:	vextracti128 $0x1,%ymm11,%xmm14
   165db:	vinserti128 $0x1,%xmm0,%ymm14,%ymm14
   165e1:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   165e8:	kmovd  %r10d,%k1
   165ed:	vpexpandd %zmm14,%zmm14{%k1}{z}
   165f3:	mov    (%rdi),%r10
   165f6:	vporq  (%r10,%r9,4),%zmm14,%zmm14
   165fd:	vmovdqa64 %zmm14,(%r10,%r9,4)
   16604:	vextracti32x4 $0x2,%zmm13,%xmm14
   1660b:	vextracti32x4 $0x2,%zmm12,%xmm15
   16612:	vpand  %xmm9,%xmm15,%xmm15
   16617:	vpsllvd %xmm15,%xmm10,%xmm15
   1661c:	vpshufd $0xee,%xmm15,%xmm16
   16623:	vpord  %xmm16,%xmm15,%xmm15
   16629:	vpshufd $0x55,%xmm15,%xmm16
   16630:	vpord  %xmm16,%xmm15,%xmm15
   16636:	vmovw  %xmm15,%r9d
   1663c:	vextracti32x4 $0x2,%zmm11,%xmm15
   16643:	vinserti128 $0x1,%xmm0,%ymm15,%ymm15
   16649:	vinserti64x4 $0x1,%ymm0,%zmm15,%zmm15
   16650:	kmovd  %r9d,%k1
   16655:	vpexpandd %zmm15,%zmm15{%k1}{z}
   1665b:	vmovd  %xmm14,%r9d
   16660:	mov    (%rdi),%r10
   16663:	vporq  (%r10,%r9,4),%zmm15,%zmm14
   1666a:	vmovdqa64 %zmm14,(%r10,%r9,4)
   16671:	vextracti32x4 $0x3,%zmm13,%xmm13
   16678:	vmovd  %xmm13,%r9d
   1667d:	vextracti32x4 $0x3,%zmm12,%xmm12
   16684:	vpand  %xmm9,%xmm12,%xmm12
   16689:	vpsllvd %xmm12,%xmm10,%xmm12
   1668e:	vpshufd $0xee,%xmm12,%xmm13
   16694:	vpor   %xmm13,%xmm12,%xmm12
   16699:	vpshufd $0x55,%xmm12,%xmm13
   1669f:	vpor   %xmm13,%xmm12,%xmm12
   166a4:	vmovw  %xmm12,%r10d
   166aa:	vextracti32x4 $0x3,%zmm11,%xmm11
   166b1:	vinserti128 $0x1,%xmm0,%ymm11,%ymm11
   166b7:	vinserti64x4 $0x1,%ymm0,%zmm11,%zmm11
   166be:	kmovd  %r10d,%k1
   166c3:	vpexpandd %zmm11,%zmm11{%k1}{z}
   166c9:	mov    (%rdi),%r10
   166cc:	vporq  (%r10,%r9,4),%zmm11,%zmm11
   166d3:	vmovdqa64 %zmm11,(%r10,%r9,4)
   166da:	lea    0x4(%rcx),%r9
   166de:	add    $0x8,%rcx
   166e2:	cmp    %rax,%rcx
   166e5:	mov    %r9,%rcx
   166e8:	ja     167ab <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x38b>
   166ee:	lea    0x44(%rcx),%r11
   166f2:	mov    0x18(%rdi),%r10d
   166f6:	mov    (%rdi),%r9
   166f9:	cmp    %rax,%r11
   166fc:	ja     164c0 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   16702:	mov    0x200(%rdx,%rcx,8),%r11
   1670a:	mov    %r11,%rbx
   1670d:	shr    $0x20,%rbx
   16711:	shr    $0x28,%r11
   16715:	imul   %r10,%r11
   16719:	and    $0x3,%ebx
   1671c:	shr    $0x12,%r11
   16720:	and    %r8,%r11
   16723:	add    %r9,%r11
   16726:	prefetchw (%r11,%rbx,4)
   1672b:	mov    0x208(%rdx,%rcx,8),%r11
   16733:	mov    %r11,%rbx
   16736:	shr    $0x20,%rbx
   1673a:	shr    $0x28,%r11
   1673e:	imul   %r10,%r11
   16742:	and    $0x3,%ebx
   16745:	shr    $0x12,%r11
   16749:	and    %r8,%r11
   1674c:	add    %r9,%r11
   1674f:	prefetchw (%r11,%rbx,4)
   16754:	mov    0x210(%rdx,%rcx,8),%r11
   1675c:	mov    %r11,%rbx
   1675f:	shr    $0x20,%rbx
   16763:	shr    $0x28,%r11
   16767:	imul   %r10,%r11
   1676b:	and    $0x3,%ebx
   1676e:	shr    $0x12,%r11
   16772:	and    %r8,%r11
   16775:	add    %r9,%r11
   16778:	prefetchw (%r11,%rbx,4)
   1677d:	mov    0x218(%rdx,%rcx,8),%r11
   16785:	mov    %r11,%rbx
   16788:	shr    $0x20,%rbx
   1678c:	shr    $0x28,%r11
   16790:	imul   %r10,%r11
   16794:	and    $0x3,%ebx
   16797:	shr    $0x12,%r11
   1679b:	and    %r8,%r11
   1679e:	add    %r9,%r11
   167a1:	prefetchw (%r11,%rbx,4)
   167a6:	jmp    164c0 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   167ab:	pop    %rbx
   167ac:	sub    %r9d,%esi
   167af:	lea    (%rdx,%r9,8),%rdx
   167b3:	vzeroupper
   167b6:	jmp    16a50 <bloom_filters::K12PrefetchLineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
