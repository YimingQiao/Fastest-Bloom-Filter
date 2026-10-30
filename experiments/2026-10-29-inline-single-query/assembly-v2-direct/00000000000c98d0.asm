00000000000c98d0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c98d0:	test   %rsi,%rsi
   c98d3:	je     c9a19 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   c98d9:	push   %rbx
   c98da:	mov    %rdx,%rax
   c98dd:	movabs $0xf1357aea2e62a9c5,%r9
   c98e7:	cmp    $0x1,%rsi
   c98eb:	jne    c98f5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   c98ed:	xor    %r8d,%r8d
   c98f0:	jmp    c99c1 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   c98f5:	mov    %rsi,%r10
   c98f8:	and    $0xfffffffffffffffe,%r10
   c98fc:	xor    %r8d,%r8d
   c98ff:	vmovdqa -0xc4dc7(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   c9907:	vpbroadcastd -0xc6668(%rip),%xmm1        # 32a8 <__abi_tag+0x2fe4>
   c9910:	mov    (%rax,%r8,8),%rdx
   c9914:	or     $0x1,%rdx
   c9918:	mov    0x20(%rdi),%r11
   c991c:	mulx   0x10(%rdi),%rbx,%rbx
   c9922:	shl    $0x4,%rbx
   c9926:	prefetcht0 (%r11,%rbx,1)
   c992b:	prefetcht0 0x40(%r11,%rbx,1)
   c9931:	imul   %r9,%rdx
   c9935:	vmovdqu (%r11,%rbx,1),%ymm2
   c993b:	vpbroadcastq %rdx,%ymm3
   c9941:	vpsllvq %ymm0,%ymm3,%ymm3
   c9946:	vpsrld $0x1b,%ymm3,%ymm3
   c994b:	vpsllvd %ymm3,%ymm1,%ymm3
   c9950:	xor    %edx,%edx
   c9952:	vptest %ymm3,%ymm2
   c9957:	setb   %dl
   c995a:	mov    %edx,(%rcx,%r8,4)
   c995e:	mov    0x8(%rax,%r8,8),%rdx
   c9963:	or     $0x1,%rdx
   c9967:	mov    0x20(%rdi),%r11
   c996b:	mulx   0x10(%rdi),%rbx,%rbx
   c9971:	shl    $0x4,%rbx
   c9975:	prefetcht0 (%r11,%rbx,1)
   c997a:	prefetcht0 0x40(%r11,%rbx,1)
   c9980:	imul   %r9,%rdx
   c9984:	vmovdqu (%r11,%rbx,1),%ymm2
   c998a:	vpbroadcastq %rdx,%ymm3
   c9990:	vpsllvq %ymm0,%ymm3,%ymm3
   c9995:	vpsrld $0x1b,%ymm3,%ymm3
   c999a:	vpsllvd %ymm3,%ymm1,%ymm3
   c999f:	xor    %edx,%edx
   c99a1:	vptest %ymm3,%ymm2
   c99a6:	setb   %dl
   c99a9:	mov    %edx,0x4(%rcx,%r8,4)
   c99ae:	add    $0x2,%r8
   c99b2:	cmp    %r8,%r10
   c99b5:	jne    c9910 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   c99bb:	test   $0x1,%sil
   c99bf:	je     c9a18 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   c99c1:	mov    (%rax,%r8,8),%rdx
   c99c5:	or     $0x1,%rdx
   c99c9:	mov    0x20(%rdi),%rax
   c99cd:	mulx   0x10(%rdi),%rsi,%rsi
   c99d3:	shl    $0x4,%rsi
   c99d7:	prefetcht0 (%rax,%rsi,1)
   c99db:	prefetcht0 0x40(%rax,%rsi,1)
   c99e0:	imul   %r9,%rdx
   c99e4:	vmovdqu (%rax,%rsi,1),%ymm0
   c99e9:	vpbroadcastq %rdx,%ymm1
   c99ef:	vpsllvq -0xc4eb8(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   c99f8:	vpsrld $0x1b,%ymm1,%ymm1
   c99fd:	vmovdqa -0xc50a5(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   c9a05:	vpsllvd %ymm1,%ymm2,%ymm1
   c9a0a:	xor    %eax,%eax
   c9a0c:	vptest %ymm1,%ymm0
   c9a11:	setb   %al
   c9a14:	mov    %eax,(%rcx,%r8,4)
   c9a18:	pop    %rbx
   c9a19:	vzeroupper
   c9a1c:	ret
   c9a1d:	int3
   c9a1e:	int3
   c9a1f:	int3

