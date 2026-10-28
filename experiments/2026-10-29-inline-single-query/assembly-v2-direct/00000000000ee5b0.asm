00000000000ee5b0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   ee5b0:	test   %rsi,%rsi
   ee5b3:	je     ee683 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   ee5b9:	push   %rbp
   ee5ba:	push   %r14
   ee5bc:	push   %rbx
   ee5bd:	mov    %rdx,%rax
   ee5c0:	xor    %r8d,%r8d
   ee5c3:	movabs $0xf1357aea2e62a9c5,%r9
   ee5cd:	vmovdqa -0xe9a95(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   ee5d5:	vpbroadcastd -0xeb336(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   ee5de:	movabs $0x9e3779b97f4a7c15,%r10
   ee5e8:	vmovdqa -0xe9c90(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   ee5f0:	mov    (%rax,%r8,8),%rdx
   ee5f4:	or     $0x1,%rdx
   ee5f8:	mov    0x20(%rdi),%r11
   ee5fc:	mulx   0x10(%rdi),%rbx,%rbx
   ee602:	lea    (%rbx,%rbx,2),%rbx
   ee606:	shl    $0x4,%rbx
   ee60a:	imul   %r9,%rdx
   ee60e:	vmovdqu (%r11,%rbx,1),%ymm3
   ee614:	vpbroadcastq %rdx,%ymm4
   ee61a:	vpsllvq %ymm0,%ymm4,%ymm4
   ee61f:	vpsrld $0x1b,%ymm4,%ymm4
   ee624:	vpsllvd %ymm4,%ymm1,%ymm4
   ee629:	vptest %ymm4,%ymm3
   ee62e:	setb   %bpl
   ee632:	mulx   %r10,%rdx,%r14
   ee637:	xor    %rdx,%r14
   ee63a:	vpbroadcastq %r14,%ymm3
   ee640:	prefetcht0 (%r11,%rbx,1)
   ee645:	vmovdqu 0x20(%r11,%rbx,1),%ymm4
   ee64c:	vpsllvq %ymm0,%ymm3,%ymm3
   ee651:	vpsrld $0x1b,%ymm3,%ymm3
   ee656:	vpsllvd %ymm3,%ymm2,%ymm3
   ee65b:	vptest %ymm3,%ymm4
   ee660:	setb   %dl
   ee663:	prefetcht0 0x40(%r11,%rbx,1)
   ee669:	and    %bpl,%dl
   ee66c:	movzbl %dl,%edx
   ee66f:	mov    %edx,(%rcx,%r8,4)
   ee673:	inc    %r8
   ee676:	cmp    %r8,%rsi
   ee679:	jne    ee5f0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   ee67f:	pop    %rbx
   ee680:	pop    %r14
   ee682:	pop    %rbp
   ee683:	vzeroupper
   ee686:	ret
   ee687:	int3
   ee688:	int3
   ee689:	int3
   ee68a:	int3
   ee68b:	int3
   ee68c:	int3
   ee68d:	int3
   ee68e:	int3
   ee68f:	int3

