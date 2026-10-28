0000000000067750 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   67750:	test   %rsi,%rsi
   67753:	je     67871 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   67759:	cmp    $0x1,%rsi
   6775d:	jne    67766 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   6775f:	xor    %eax,%eax
   67761:	jmp    67823 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   67766:	mov    %rsi,%r8
   67769:	and    $0xfffffffffffffffe,%r8
   6776d:	xor    %eax,%eax
   6776f:	vmovdqa -0x62e57(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67777:	vpbroadcastd -0x644d8(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67780:	mov    (%rdx,%rax,8),%r9
   67784:	mov    0x4(%rdi),%r10d
   67788:	and    %r9d,%r10d
   6778b:	movzbl (%rdi),%r11d
   6778f:	shrx   %r11,%r9,%r9
   67794:	vpbroadcastd %r9d,%ymm2
   6779a:	vpmulld %ymm0,%ymm2,%ymm2
   6779f:	vpsrld $0x1b,%ymm2,%ymm2
   677a4:	vpsllvd %ymm2,%ymm1,%ymm2
   677a9:	mov    0x8(%rdi),%r9
   677ad:	shl    $0x5,%r10
   677b1:	vmovdqa (%r9,%r10,1),%ymm3
   677b7:	xor    %r9d,%r9d
   677ba:	vptest %ymm2,%ymm3
   677bf:	setb   %r9b
   677c3:	mov    %r9d,(%rcx,%rax,4)
   677c7:	mov    0x8(%rdx,%rax,8),%r9
   677cc:	mov    0x4(%rdi),%r10d
   677d0:	and    %r9d,%r10d
   677d3:	movzbl (%rdi),%r11d
   677d7:	shrx   %r11,%r9,%r9
   677dc:	vpbroadcastd %r9d,%ymm2
   677e2:	vpmulld %ymm0,%ymm2,%ymm2
   677e7:	vpsrld $0x1b,%ymm2,%ymm2
   677ec:	vpsllvd %ymm2,%ymm1,%ymm2
   677f1:	mov    0x8(%rdi),%r9
   677f5:	shl    $0x5,%r10
   677f9:	vmovdqa (%r9,%r10,1),%ymm3
   677ff:	xor    %r9d,%r9d
   67802:	vptest %ymm2,%ymm3
   67807:	setb   %r9b
   6780b:	mov    %r9d,0x4(%rcx,%rax,4)
   67810:	add    $0x2,%rax
   67814:	cmp    %rax,%r8
   67817:	jne    67780 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6781d:	test   $0x1,%sil
   67821:	je     67871 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   67823:	mov    (%rdx,%rax,8),%rdx
   67827:	mov    0x4(%rdi),%esi
   6782a:	and    %edx,%esi
   6782c:	movzbl (%rdi),%r8d
   67830:	shrx   %r8,%rdx,%rdx
   67835:	vpbroadcastd %edx,%ymm0
   6783b:	vpmulld -0x62f24(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   67844:	vpsrld $0x1b,%ymm0,%ymm0
   67849:	vpbroadcastd -0x645aa(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   67852:	vpsllvd %ymm0,%ymm1,%ymm0
   67857:	mov    0x8(%rdi),%rdx
   6785b:	shl    $0x5,%rsi
   6785f:	vmovdqa (%rdx,%rsi,1),%ymm1
   67864:	xor    %edx,%edx
   67866:	vptest %ymm0,%ymm1
   6786b:	setb   %dl
   6786e:	mov    %edx,(%rcx,%rax,4)
   67871:	vzeroupper
   67874:	ret
   67875:	int3
   67876:	int3
   67877:	int3
   67878:	int3
   67879:	int3
   6787a:	int3
   6787b:	int3
   6787c:	int3
   6787d:	int3
   6787e:	int3
   6787f:	int3

