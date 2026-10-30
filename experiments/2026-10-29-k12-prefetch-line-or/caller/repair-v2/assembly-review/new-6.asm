   167c0:	cmp    $0x4,%esi
   167c3:	jae    167d4 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
   167c5:	xor    %r8d,%r8d
   167c8:	sub    %r8d,%esi
   167cb:	lea    (%rdx,%r8,8),%rdx
   167cf:	jmp    16a50 <bloom_filters::K12PrefetchLineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   167d4:	mov    %esi,%eax
   167d6:	xor    %ecx,%ecx
   167d8:	vmovdqa64 -0x13b22(%rip),%zmm0        # 2cc0 <_IO_stdin_used+0xbe4>
   167e2:	vmovdqa64 -0x13aec(%rip),%zmm1        # 2d00 <_IO_stdin_used+0xc24>
   167ec:	vbroadcasti32x4 -0x13476(%rip),%zmm2        # 3380 <typeinfo name for main::$_3+0x28>
   167f6:	vmovdqa64 -0x13a80(%rip),%zmm3        # 2d80 <_IO_stdin_used+0xca4>
   16800:	vbroadcasti32x4 -0x1349a(%rip),%zmm4        # 3370 <typeinfo name for main::$_3+0x18>
   1680a:	vbroadcasti32x4 -0x13484(%rip),%zmm5        # 3390 <typeinfo name for main::$_3+0x38>
   16814:	vmovdqa64 -0x139de(%rip),%zmm6        # 2e40 <_IO_stdin_used+0xd64>
   1681e:	vpbroadcastd -0x14758(%rip),%zmm7        # 20d0 <__abi_tag+0x1e0c>
   16828:	vbroadcasti32x4 -0x13492(%rip),%zmm8        # 33a0 <typeinfo name for main::$_3+0x48>
   16832:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   16840:	vmovdqu (%rdx,%rcx,8),%ymm9
   16845:	vpxor  %xmm10,%xmm10,%xmm10
   1684a:	vpermd %zmm9,%zmm0,%zmm10
   16850:	vprorvd %zmm2,%zmm10,%zmm10
   16856:	vpxor  %xmm11,%xmm11,%xmm11
   1685b:	vpermd %zmm9,%zmm1,%zmm11
   16861:	vpxor  %xmm9,%xmm9,%xmm9
   16866:	vpermd %zmm3,%zmm10,%zmm9
   1686c:	vpsrld $0x4,%zmm10,%zmm10
   16873:	vprolvd %zmm10,%zmm9,%zmm9
   16879:	vpsrlvd %zmm4,%zmm11,%zmm10
   1687f:	vpandd %zmm5,%zmm10,%zmm12
   16885:	vpsrld $0x8,%zmm11,%zmm10
   1688c:	vpbroadcastd 0x18(%rdi),%zmm13
   16893:	vpmuludq %zmm10,%zmm13,%zmm10
   16899:	vpsrlq $0x18,%zmm10,%zmm10
   168a0:	vpsrlq $0x28,%zmm11,%zmm14
   168a7:	vpmuludq %zmm14,%zmm13,%zmm13
   168ad:	vpshufb %zmm6,%zmm13,%zmm13
   168b3:	vpord  %zmm10,%zmm13,%zmm10
   168b9:	vpslld $0x4,%zmm10,%zmm10
   168c0:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
   168c7:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
   168ce:	vmovd  %xmm9,%r8d
   168d3:	vmovd  %xmm10,%r9d
   168d8:	mov    (%rdi),%r10
   168db:	or     %r8d,(%r10,%r9,4)
   168df:	vpextrd $0x1,%xmm9,%r8d
   168e5:	vpextrd $0x1,%xmm10,%r9d
   168eb:	mov    (%rdi),%r10
   168ee:	or     %r8d,(%r10,%r9,4)
   168f2:	vpextrd $0x2,%xmm9,%r8d
   168f8:	vpextrd $0x2,%xmm10,%r9d
   168fe:	mov    (%rdi),%r10
   16901:	or     %r8d,(%r10,%r9,4)
   16905:	vpextrd $0x3,%xmm9,%r8d
   1690b:	vpextrd $0x3,%xmm10,%r9d
   16911:	mov    (%rdi),%r10
   16914:	or     %r8d,(%r10,%r9,4)
   16918:	vextracti128 $0x1,%ymm9,%xmm11
   1691e:	vmovd  %xmm11,%r8d
   16923:	vextracti128 $0x1,%ymm10,%xmm12
   16929:	vmovd  %xmm12,%r9d
   1692e:	mov    (%rdi),%r10
   16931:	or     %r8d,(%r10,%r9,4)
   16935:	vpextrd $0x1,%xmm11,%r8d
   1693b:	vpextrd $0x1,%xmm12,%r9d
   16941:	mov    (%rdi),%r10
   16944:	or     %r8d,(%r10,%r9,4)
   16948:	vpextrd $0x2,%xmm11,%r8d
   1694e:	vpextrd $0x2,%xmm12,%r9d
   16954:	mov    (%rdi),%r10
   16957:	or     %r8d,(%r10,%r9,4)
   1695b:	vpextrd $0x3,%xmm11,%r8d
   16961:	vpextrd $0x3,%xmm12,%r9d
   16967:	mov    (%rdi),%r10
   1696a:	or     %r8d,(%r10,%r9,4)
   1696e:	vextracti32x4 $0x2,%zmm9,%xmm11
   16975:	vmovd  %xmm11,%r8d
   1697a:	vextracti32x4 $0x2,%zmm10,%xmm12
   16981:	vmovd  %xmm12,%r9d
   16986:	mov    (%rdi),%r10
   16989:	or     %r8d,(%r10,%r9,4)
   1698d:	vpextrd $0x1,%xmm11,%r8d
   16993:	vpextrd $0x1,%xmm12,%r9d
   16999:	mov    (%rdi),%r10
   1699c:	or     %r8d,(%r10,%r9,4)
   169a0:	vpextrd $0x2,%xmm11,%r8d
   169a6:	vpextrd $0x2,%xmm12,%r9d
   169ac:	mov    (%rdi),%r10
   169af:	or     %r8d,(%r10,%r9,4)
   169b3:	vpextrd $0x3,%xmm11,%r8d
   169b9:	vpextrd $0x3,%xmm12,%r9d
   169bf:	mov    (%rdi),%r10
   169c2:	or     %r8d,(%r10,%r9,4)
   169c6:	vextracti32x4 $0x3,%zmm9,%xmm9
   169cd:	vmovd  %xmm9,%r8d
   169d2:	vextracti32x4 $0x3,%zmm10,%xmm10
   169d9:	vmovd  %xmm10,%r9d
   169de:	mov    (%rdi),%r10
   169e1:	or     %r8d,(%r10,%r9,4)
   169e5:	vpextrd $0x1,%xmm9,%r8d
   169eb:	vpextrd $0x1,%xmm10,%r9d
   169f1:	mov    (%rdi),%r10
   169f4:	or     %r8d,(%r10,%r9,4)
   169f8:	vpextrd $0x2,%xmm9,%r8d
   169fe:	vpextrd $0x2,%xmm10,%r9d
   16a04:	mov    (%rdi),%r10
   16a07:	or     %r8d,(%r10,%r9,4)
   16a0b:	vpextrd $0x3,%xmm9,%r8d
   16a11:	vpextrd $0x3,%xmm10,%r9d
   16a17:	mov    (%rdi),%r10
   16a1a:	or     %r8d,(%r10,%r9,4)
   16a1e:	lea    0x4(%rcx),%r8
   16a22:	add    $0x8,%rcx
   16a26:	cmp    %rax,%rcx
   16a29:	mov    %r8,%rcx
   16a2c:	jbe    16840 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)+0x80>
   16a32:	sub    %r8d,%esi
   16a35:	lea    (%rdx,%r8,8),%rdx
   16a39:	vzeroupper
   16a3c:	jmp    16a50 <bloom_filters::K12PrefetchLineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
