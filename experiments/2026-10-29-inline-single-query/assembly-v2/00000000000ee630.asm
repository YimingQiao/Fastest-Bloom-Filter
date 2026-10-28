00000000000ee630 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   ee630:	test   %rsi,%rsi
   ee633:	je     ee703 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   ee639:	push   %rbp
   ee63a:	push   %r14
   ee63c:	push   %rbx
   ee63d:	mov    %rdx,%rax
   ee640:	xor    %r8d,%r8d
   ee643:	movabs $0xf1357aea2e62a9c5,%r9
   ee64d:	vmovdqa -0xe9b15(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   ee655:	vpbroadcastd -0xeb3b6(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   ee65e:	movabs $0x9e3779b97f4a7c15,%r10
   ee668:	vmovdqa -0xe9d10(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   ee670:	mov    (%rax,%r8,8),%rdx
   ee674:	or     $0x1,%rdx
   ee678:	mov    0x20(%rdi),%r11
   ee67c:	mulx   0x10(%rdi),%rbx,%rbx
   ee682:	lea    (%rbx,%rbx,2),%rbx
   ee686:	shl    $0x4,%rbx
   ee68a:	imul   %r9,%rdx
   ee68e:	vmovdqu (%r11,%rbx,1),%ymm3
   ee694:	vpbroadcastq %rdx,%ymm4
   ee69a:	vpsllvq %ymm0,%ymm4,%ymm4
   ee69f:	vpsrld $0x1b,%ymm4,%ymm4
   ee6a4:	vpsllvd %ymm4,%ymm1,%ymm4
   ee6a9:	vptest %ymm4,%ymm3
   ee6ae:	setb   %bpl
   ee6b2:	mulx   %r10,%rdx,%r14
   ee6b7:	xor    %rdx,%r14
   ee6ba:	vpbroadcastq %r14,%ymm3
   ee6c0:	prefetcht0 (%r11,%rbx,1)
   ee6c5:	vmovdqu 0x20(%r11,%rbx,1),%ymm4
   ee6cc:	vpsllvq %ymm0,%ymm3,%ymm3
   ee6d1:	vpsrld $0x1b,%ymm3,%ymm3
   ee6d6:	vpsllvd %ymm3,%ymm2,%ymm3
   ee6db:	vptest %ymm3,%ymm4
   ee6e0:	setb   %dl
   ee6e3:	prefetcht0 0x40(%r11,%rbx,1)
   ee6e9:	and    %bpl,%dl
   ee6ec:	movzbl %dl,%edx
   ee6ef:	mov    %edx,(%rcx,%r8,4)
   ee6f3:	inc    %r8
   ee6f6:	cmp    %r8,%rsi
   ee6f9:	jne    ee670 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   ee6ff:	pop    %rbx
   ee700:	pop    %r14
   ee702:	pop    %rbp
   ee703:	vzeroupper
   ee706:	ret
   ee707:	int3
   ee708:	int3
   ee709:	int3
   ee70a:	int3
   ee70b:	int3
   ee70c:	int3
   ee70d:	int3
   ee70e:	int3
   ee70f:	int3

