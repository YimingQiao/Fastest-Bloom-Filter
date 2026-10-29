    e510:	cmp    $0x4,%esi
    e513:	jae    e524 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
    e515:	xor    %r8d,%r8d
    e518:	sub    %r8d,%esi
    e51b:	lea    (%rdx,%r8,8),%rdx
    e51f:	jmp    e7a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    e524:	mov    %esi,%eax
    e526:	xor    %ecx,%ecx
    e528:	vmovdqa64 -0xc132(%rip),%zmm0        # 2400 <_IO_stdin_used+0x364>
    e532:	vmovdqa64 -0xc0fc(%rip),%zmm1        # 2440 <_IO_stdin_used+0x3a4>
    e53c:	vbroadcasti32x4 -0xb2d6(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
    e546:	vmovdqa64 -0xc090(%rip),%zmm3        # 24c0 <_IO_stdin_used+0x424>
    e550:	vbroadcasti32x4 -0xb2fa(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
    e55a:	vbroadcasti32x4 -0xb2e4(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
    e564:	vmovdqa64 -0xbfee(%rip),%zmm6        # 2580 <_IO_stdin_used+0x4e4>
    e56e:	vpbroadcastd -0xc4e8(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
    e578:	vbroadcasti32x4 -0xb2f2(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
    e582:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    e590:	vmovdqu (%rdx,%rcx,8),%ymm9
    e595:	vpxor  %xmm10,%xmm10,%xmm10
    e59a:	vpermd %zmm9,%zmm0,%zmm10
    e5a0:	vprorvd %zmm2,%zmm10,%zmm10
    e5a6:	vpxor  %xmm11,%xmm11,%xmm11
    e5ab:	vpermd %zmm9,%zmm1,%zmm11
    e5b1:	vpxor  %xmm9,%xmm9,%xmm9
    e5b6:	vpermd %zmm3,%zmm10,%zmm9
    e5bc:	vpsrld $0x4,%zmm10,%zmm10
    e5c3:	vprolvd %zmm10,%zmm9,%zmm9
    e5c9:	vpsrlvd %zmm4,%zmm11,%zmm10
    e5cf:	vpandd %zmm5,%zmm10,%zmm12
    e5d5:	vpsrld $0x8,%zmm11,%zmm10
    e5dc:	vpbroadcastd 0x18(%rdi),%zmm13
    e5e3:	vpmuludq %zmm10,%zmm13,%zmm10
    e5e9:	vpsrlq $0x18,%zmm10,%zmm10
    e5f0:	vpsrlq $0x28,%zmm11,%zmm14
    e5f7:	vpmuludq %zmm14,%zmm13,%zmm13
    e5fd:	vpshufb %zmm6,%zmm13,%zmm13
    e603:	vpord  %zmm10,%zmm13,%zmm10
    e609:	vpslld $0x4,%zmm10,%zmm10
    e610:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    e617:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    e61e:	vmovd  %xmm9,%r8d
    e623:	vmovd  %xmm10,%r9d
    e628:	mov    (%rdi),%r10
    e62b:	or     %r8d,(%r10,%r9,4)
    e62f:	vpextrd $0x1,%xmm9,%r8d
    e635:	vpextrd $0x1,%xmm10,%r9d
    e63b:	mov    (%rdi),%r10
    e63e:	or     %r8d,(%r10,%r9,4)
    e642:	vpextrd $0x2,%xmm9,%r8d
    e648:	vpextrd $0x2,%xmm10,%r9d
    e64e:	mov    (%rdi),%r10
    e651:	or     %r8d,(%r10,%r9,4)
    e655:	vpextrd $0x3,%xmm9,%r8d
    e65b:	vpextrd $0x3,%xmm10,%r9d
    e661:	mov    (%rdi),%r10
    e664:	or     %r8d,(%r10,%r9,4)
    e668:	vextracti128 $0x1,%ymm9,%xmm11
    e66e:	vmovd  %xmm11,%r8d
    e673:	vextracti128 $0x1,%ymm10,%xmm12
    e679:	vmovd  %xmm12,%r9d
    e67e:	mov    (%rdi),%r10
    e681:	or     %r8d,(%r10,%r9,4)
    e685:	vpextrd $0x1,%xmm11,%r8d
    e68b:	vpextrd $0x1,%xmm12,%r9d
    e691:	mov    (%rdi),%r10
    e694:	or     %r8d,(%r10,%r9,4)
    e698:	vpextrd $0x2,%xmm11,%r8d
    e69e:	vpextrd $0x2,%xmm12,%r9d
    e6a4:	mov    (%rdi),%r10
    e6a7:	or     %r8d,(%r10,%r9,4)
    e6ab:	vpextrd $0x3,%xmm11,%r8d
    e6b1:	vpextrd $0x3,%xmm12,%r9d
    e6b7:	mov    (%rdi),%r10
    e6ba:	or     %r8d,(%r10,%r9,4)
    e6be:	vextracti32x4 $0x2,%zmm9,%xmm11
    e6c5:	vmovd  %xmm11,%r8d
    e6ca:	vextracti32x4 $0x2,%zmm10,%xmm12
    e6d1:	vmovd  %xmm12,%r9d
    e6d6:	mov    (%rdi),%r10
    e6d9:	or     %r8d,(%r10,%r9,4)
    e6dd:	vpextrd $0x1,%xmm11,%r8d
    e6e3:	vpextrd $0x1,%xmm12,%r9d
    e6e9:	mov    (%rdi),%r10
    e6ec:	or     %r8d,(%r10,%r9,4)
    e6f0:	vpextrd $0x2,%xmm11,%r8d
    e6f6:	vpextrd $0x2,%xmm12,%r9d
    e6fc:	mov    (%rdi),%r10
    e6ff:	or     %r8d,(%r10,%r9,4)
    e703:	vpextrd $0x3,%xmm11,%r8d
    e709:	vpextrd $0x3,%xmm12,%r9d
    e70f:	mov    (%rdi),%r10
    e712:	or     %r8d,(%r10,%r9,4)
    e716:	vextracti32x4 $0x3,%zmm9,%xmm9
    e71d:	vmovd  %xmm9,%r8d
    e722:	vextracti32x4 $0x3,%zmm10,%xmm10
    e729:	vmovd  %xmm10,%r9d
    e72e:	mov    (%rdi),%r10
    e731:	or     %r8d,(%r10,%r9,4)
    e735:	vpextrd $0x1,%xmm9,%r8d
    e73b:	vpextrd $0x1,%xmm10,%r9d
    e741:	mov    (%rdi),%r10
    e744:	or     %r8d,(%r10,%r9,4)
    e748:	vpextrd $0x2,%xmm9,%r8d
    e74e:	vpextrd $0x2,%xmm10,%r9d
    e754:	mov    (%rdi),%r10
    e757:	or     %r8d,(%r10,%r9,4)
    e75b:	vpextrd $0x3,%xmm9,%r8d
    e761:	vpextrd $0x3,%xmm10,%r9d
    e767:	mov    (%rdi),%r10
    e76a:	or     %r8d,(%r10,%r9,4)
    e76e:	lea    0x4(%rcx),%r8
    e772:	add    $0x8,%rcx
    e776:	cmp    %rax,%rcx
    e779:	mov    %r8,%rcx
    e77c:	jbe    e590 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x80>
    e782:	sub    %r8d,%esi
    e785:	lea    (%rdx,%r8,8),%rdx
    e789:	vzeroupper
    e78c:	jmp    e7a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
