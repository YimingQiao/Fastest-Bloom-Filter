    f660:	cmp    $0x4,%esi
    f663:	jae    f674 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
    f665:	xor    %r8d,%r8d
    f668:	sub    %r8d,%esi
    f66b:	lea    (%rdx,%r8,8),%rdx
    f66f:	jmp    f8f0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    f674:	mov    %esi,%eax
    f676:	xor    %ecx,%ecx
    f678:	vmovdqa64 -0xd202(%rip),%zmm0        # 2480 <_IO_stdin_used+0x3a4>
    f682:	vmovdqa64 -0xd1cc(%rip),%zmm1        # 24c0 <_IO_stdin_used+0x3e4>
    f68c:	vbroadcasti32x4 -0xc316(%rip),%zmm2        # 3380 <typeinfo name for main::$_3+0x28>
    f696:	vmovdqa64 -0xd160(%rip),%zmm3        # 2540 <_IO_stdin_used+0x464>
    f6a0:	vbroadcasti32x4 -0xc33a(%rip),%zmm4        # 3370 <typeinfo name for main::$_3+0x18>
    f6aa:	vbroadcasti32x4 -0xc324(%rip),%zmm5        # 3390 <typeinfo name for main::$_3+0x38>
    f6b4:	vmovdqa64 -0xd0be(%rip),%zmm6        # 2600 <_IO_stdin_used+0x524>
    f6be:	vpbroadcastd -0xd5f8(%rip),%zmm7        # 20d0 <__abi_tag+0x1e0c>
    f6c8:	vbroadcasti32x4 -0xc332(%rip),%zmm8        # 33a0 <typeinfo name for main::$_3+0x48>
    f6d2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    f6e0:	vmovdqu (%rdx,%rcx,8),%ymm9
    f6e5:	vpxor  %xmm10,%xmm10,%xmm10
    f6ea:	vpermd %zmm9,%zmm0,%zmm10
    f6f0:	vprorvd %zmm2,%zmm10,%zmm10
    f6f6:	vpxor  %xmm11,%xmm11,%xmm11
    f6fb:	vpermd %zmm9,%zmm1,%zmm11
    f701:	vpxor  %xmm9,%xmm9,%xmm9
    f706:	vpermd %zmm3,%zmm10,%zmm9
    f70c:	vpsrld $0x4,%zmm10,%zmm10
    f713:	vprolvd %zmm10,%zmm9,%zmm9
    f719:	vpsrlvd %zmm4,%zmm11,%zmm10
    f71f:	vpandd %zmm5,%zmm10,%zmm12
    f725:	vpsrld $0x8,%zmm11,%zmm10
    f72c:	vpbroadcastd 0x18(%rdi),%zmm13
    f733:	vpmuludq %zmm10,%zmm13,%zmm10
    f739:	vpsrlq $0x18,%zmm10,%zmm10
    f740:	vpsrlq $0x28,%zmm11,%zmm14
    f747:	vpmuludq %zmm14,%zmm13,%zmm13
    f74d:	vpshufb %zmm6,%zmm13,%zmm13
    f753:	vpord  %zmm10,%zmm13,%zmm10
    f759:	vpslld $0x4,%zmm10,%zmm10
    f760:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    f767:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    f76e:	vmovd  %xmm9,%r8d
    f773:	vmovd  %xmm10,%r9d
    f778:	mov    (%rdi),%r10
    f77b:	or     %r8d,(%r10,%r9,4)
    f77f:	vpextrd $0x1,%xmm9,%r8d
    f785:	vpextrd $0x1,%xmm10,%r9d
    f78b:	mov    (%rdi),%r10
    f78e:	or     %r8d,(%r10,%r9,4)
    f792:	vpextrd $0x2,%xmm9,%r8d
    f798:	vpextrd $0x2,%xmm10,%r9d
    f79e:	mov    (%rdi),%r10
    f7a1:	or     %r8d,(%r10,%r9,4)
    f7a5:	vpextrd $0x3,%xmm9,%r8d
    f7ab:	vpextrd $0x3,%xmm10,%r9d
    f7b1:	mov    (%rdi),%r10
    f7b4:	or     %r8d,(%r10,%r9,4)
    f7b8:	vextracti128 $0x1,%ymm9,%xmm11
    f7be:	vmovd  %xmm11,%r8d
    f7c3:	vextracti128 $0x1,%ymm10,%xmm12
    f7c9:	vmovd  %xmm12,%r9d
    f7ce:	mov    (%rdi),%r10
    f7d1:	or     %r8d,(%r10,%r9,4)
    f7d5:	vpextrd $0x1,%xmm11,%r8d
    f7db:	vpextrd $0x1,%xmm12,%r9d
    f7e1:	mov    (%rdi),%r10
    f7e4:	or     %r8d,(%r10,%r9,4)
    f7e8:	vpextrd $0x2,%xmm11,%r8d
    f7ee:	vpextrd $0x2,%xmm12,%r9d
    f7f4:	mov    (%rdi),%r10
    f7f7:	or     %r8d,(%r10,%r9,4)
    f7fb:	vpextrd $0x3,%xmm11,%r8d
    f801:	vpextrd $0x3,%xmm12,%r9d
    f807:	mov    (%rdi),%r10
    f80a:	or     %r8d,(%r10,%r9,4)
    f80e:	vextracti32x4 $0x2,%zmm9,%xmm11
    f815:	vmovd  %xmm11,%r8d
    f81a:	vextracti32x4 $0x2,%zmm10,%xmm12
    f821:	vmovd  %xmm12,%r9d
    f826:	mov    (%rdi),%r10
    f829:	or     %r8d,(%r10,%r9,4)
    f82d:	vpextrd $0x1,%xmm11,%r8d
    f833:	vpextrd $0x1,%xmm12,%r9d
    f839:	mov    (%rdi),%r10
    f83c:	or     %r8d,(%r10,%r9,4)
    f840:	vpextrd $0x2,%xmm11,%r8d
    f846:	vpextrd $0x2,%xmm12,%r9d
    f84c:	mov    (%rdi),%r10
    f84f:	or     %r8d,(%r10,%r9,4)
    f853:	vpextrd $0x3,%xmm11,%r8d
    f859:	vpextrd $0x3,%xmm12,%r9d
    f85f:	mov    (%rdi),%r10
    f862:	or     %r8d,(%r10,%r9,4)
    f866:	vextracti32x4 $0x3,%zmm9,%xmm9
    f86d:	vmovd  %xmm9,%r8d
    f872:	vextracti32x4 $0x3,%zmm10,%xmm10
    f879:	vmovd  %xmm10,%r9d
    f87e:	mov    (%rdi),%r10
    f881:	or     %r8d,(%r10,%r9,4)
    f885:	vpextrd $0x1,%xmm9,%r8d
    f88b:	vpextrd $0x1,%xmm10,%r9d
    f891:	mov    (%rdi),%r10
    f894:	or     %r8d,(%r10,%r9,4)
    f898:	vpextrd $0x2,%xmm9,%r8d
    f89e:	vpextrd $0x2,%xmm10,%r9d
    f8a4:	mov    (%rdi),%r10
    f8a7:	or     %r8d,(%r10,%r9,4)
    f8ab:	vpextrd $0x3,%xmm9,%r8d
    f8b1:	vpextrd $0x3,%xmm10,%r9d
    f8b7:	mov    (%rdi),%r10
    f8ba:	or     %r8d,(%r10,%r9,4)
    f8be:	lea    0x4(%rcx),%r8
    f8c2:	add    $0x8,%rcx
    f8c6:	cmp    %rax,%rcx
    f8c9:	mov    %r8,%rcx
    f8cc:	jbe    f6e0 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x80>
    f8d2:	sub    %r8d,%esi
    f8d5:	lea    (%rdx,%r8,8),%rdx
    f8d9:	vzeroupper
    f8dc:	jmp    f8f0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
