   15670:	cmp    $0x4,%esi
   15673:	jae    15684 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
   15675:	xor    %r8d,%r8d
   15678:	sub    %r8d,%esi
   1567b:	lea    (%rdx,%r8,8),%rdx
   1567f:	jmp    15950 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   15684:	mov    %esi,%eax
   15686:	xor    %ecx,%ecx
   15688:	vmovdqa64 -0x12a52(%rip),%zmm0        # 2c40 <_IO_stdin_used+0xba4>
   15692:	vmovdqa64 -0x12a1c(%rip),%zmm1        # 2c80 <_IO_stdin_used+0xbe4>
   1569c:	vbroadcasti32x4 -0x12436(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
   156a6:	vmovdqa64 -0x129b0(%rip),%zmm3        # 2d00 <_IO_stdin_used+0xc64>
   156b0:	vbroadcasti32x4 -0x1245a(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
   156ba:	vbroadcasti32x4 -0x12444(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
   156c4:	vmovdqa64 -0x1290e(%rip),%zmm6        # 2dc0 <_IO_stdin_used+0xd24>
   156ce:	vpbroadcastd -0x13648(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
   156d8:	vbroadcasti32x4 -0x12452(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
   156e2:	vpbroadcastd -0x13663(%rip),%xmm9        # 2088 <__abi_tag+0x1dc4>
   156eb:	vpbroadcastd -0x13660(%rip),%xmm10        # 2094 <__abi_tag+0x1dd0>
   156f4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   15700:	vmovdqu (%rdx,%rcx,8),%ymm11
   15705:	vpxor  %xmm12,%xmm12,%xmm12
   1570a:	vpermd %zmm11,%zmm0,%zmm12
   15710:	vprorvd %zmm2,%zmm12,%zmm13
   15716:	vpxor  %xmm12,%xmm12,%xmm12
   1571b:	vpermd %zmm11,%zmm1,%zmm12
   15721:	vpxor  %xmm11,%xmm11,%xmm11
   15726:	vpermd %zmm3,%zmm13,%zmm11
   1572c:	vpsrld $0x4,%zmm13,%zmm13
   15733:	vprolvd %zmm13,%zmm11,%zmm11
   15739:	vpsrlvd %zmm4,%zmm12,%zmm13
   1573f:	vpandd %zmm5,%zmm13,%zmm14
   15745:	vpsrld $0x8,%zmm12,%zmm13
   1574c:	vpbroadcastd 0x18(%rdi),%zmm15
   15753:	vpmuludq %zmm13,%zmm15,%zmm13
   15759:	vpsrlq $0x18,%zmm13,%zmm13
   15760:	vpsrlq $0x28,%zmm12,%zmm16
   15767:	vpmuludq %zmm16,%zmm15,%zmm15
   1576d:	vpshufb %zmm6,%zmm15,%zmm15
   15773:	vpord  %zmm13,%zmm15,%zmm13
   15779:	vpslld $0x4,%zmm13,%zmm13
   15780:	vpternlogd $0xec,%zmm7,%zmm13,%zmm12
   15787:	vpternlogd $0x1e,%zmm8,%zmm14,%zmm12
   1578e:	vmovd  %xmm13,%r8d
   15793:	vpand  %xmm9,%xmm12,%xmm14
   15798:	vpsllvd %xmm14,%xmm10,%xmm14
   1579d:	vpshufd $0xee,%xmm14,%xmm15
   157a3:	vpor   %xmm15,%xmm14,%xmm14
   157a8:	vpshufd $0x55,%xmm14,%xmm15
   157ae:	vpor   %xmm15,%xmm14,%xmm14
   157b3:	vmovw  %xmm14,%r9d
   157b9:	vinserti128 $0x1,%xmm0,%ymm11,%ymm14
   157bf:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   157c6:	kmovd  %r9d,%k1
   157cb:	vpexpandd %zmm14,%zmm14{%k1}{z}
   157d1:	mov    (%rdi),%r9
   157d4:	vporq  (%r9,%r8,4),%zmm14,%zmm14
   157db:	vmovdqa64 %zmm14,(%r9,%r8,4)
   157e2:	vextracti128 $0x1,%ymm13,%xmm14
   157e8:	vmovd  %xmm14,%r8d
   157ed:	vextracti128 $0x1,%ymm12,%xmm14
   157f3:	vpand  %xmm9,%xmm14,%xmm14
   157f8:	vpsllvd %xmm14,%xmm10,%xmm14
   157fd:	vpshufd $0xee,%xmm14,%xmm15
   15803:	vpor   %xmm15,%xmm14,%xmm14
   15808:	vpshufd $0x55,%xmm14,%xmm15
   1580e:	vpor   %xmm15,%xmm14,%xmm14
   15813:	vmovw  %xmm14,%r9d
   15819:	vextracti128 $0x1,%ymm11,%xmm14
   1581f:	vinserti128 $0x1,%xmm0,%ymm14,%ymm14
   15825:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   1582c:	kmovd  %r9d,%k1
   15831:	vpexpandd %zmm14,%zmm14{%k1}{z}
   15837:	mov    (%rdi),%r9
   1583a:	vporq  (%r9,%r8,4),%zmm14,%zmm14
   15841:	vmovdqa64 %zmm14,(%r9,%r8,4)
   15848:	vextracti32x4 $0x2,%zmm13,%xmm14
   1584f:	vextracti32x4 $0x2,%zmm12,%xmm15
   15856:	vpand  %xmm9,%xmm15,%xmm15
   1585b:	vpsllvd %xmm15,%xmm10,%xmm15
   15860:	vpshufd $0xee,%xmm15,%xmm16
   15867:	vpord  %xmm16,%xmm15,%xmm15
   1586d:	vpshufd $0x55,%xmm15,%xmm16
   15874:	vpord  %xmm16,%xmm15,%xmm15
   1587a:	vmovw  %xmm15,%r8d
   15880:	vextracti32x4 $0x2,%zmm11,%xmm15
   15887:	vinserti128 $0x1,%xmm0,%ymm15,%ymm15
   1588d:	vinserti64x4 $0x1,%ymm0,%zmm15,%zmm15
   15894:	kmovd  %r8d,%k1
   15899:	vpexpandd %zmm15,%zmm15{%k1}{z}
   1589f:	vmovd  %xmm14,%r8d
   158a4:	mov    (%rdi),%r9
   158a7:	vporq  (%r9,%r8,4),%zmm15,%zmm14
   158ae:	vmovdqa64 %zmm14,(%r9,%r8,4)
   158b5:	vextracti32x4 $0x3,%zmm13,%xmm13
   158bc:	vmovd  %xmm13,%r8d
   158c1:	vextracti32x4 $0x3,%zmm12,%xmm12
   158c8:	vpand  %xmm9,%xmm12,%xmm12
   158cd:	vpsllvd %xmm12,%xmm10,%xmm12
   158d2:	vpshufd $0xee,%xmm12,%xmm13
   158d8:	vpor   %xmm13,%xmm12,%xmm12
   158dd:	vpshufd $0x55,%xmm12,%xmm13
   158e3:	vpor   %xmm13,%xmm12,%xmm12
   158e8:	vmovw  %xmm12,%r9d
   158ee:	vextracti32x4 $0x3,%zmm11,%xmm11
   158f5:	vinserti128 $0x1,%xmm0,%ymm11,%ymm11
   158fb:	vinserti64x4 $0x1,%ymm0,%zmm11,%zmm11
   15902:	kmovd  %r9d,%k1
   15907:	vpexpandd %zmm11,%zmm11{%k1}{z}
   1590d:	mov    (%rdi),%r9
   15910:	vporq  (%r9,%r8,4),%zmm11,%zmm11
   15917:	vmovdqa64 %zmm11,(%r9,%r8,4)
   1591e:	lea    0x4(%rcx),%r8
   15922:	add    $0x8,%rcx
   15926:	cmp    %rax,%rcx
   15929:	mov    %r8,%rcx
   1592c:	jbe    15700 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x90>
   15932:	sub    %r8d,%esi
   15935:	lea    (%rdx,%r8,8),%rdx
   15939:	vzeroupper
   1593c:	jmp    15950 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
