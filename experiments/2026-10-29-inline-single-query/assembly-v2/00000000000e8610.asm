00000000000e8610 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e8610:	test   %rsi,%rsi
   e8613:	je     e86df <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xcf>
   e8619:	push   %rbp
   e861a:	push   %r14
   e861c:	push   %rbx
   e861d:	mov    %rdx,%rax
   e8620:	xor    %r8d,%r8d
   e8623:	movabs $0xf1357aea2e62a9c5,%r9
   e862d:	vmovdqa -0xe3af5(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e8635:	vpbroadcastd -0xe5396(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e863e:	movabs $0x9e3779b97f4a7c15,%r10
   e8648:	vmovdqa -0xe3b90(%rip),%ymm2        # 4ac0 <typeinfo name for main::$_60+0x2f0>
   e8650:	mov    (%rax,%r8,8),%rdx
   e8654:	or     $0x1,%rdx
   e8658:	mov    0x20(%rdi),%r11
   e865c:	mulx   0x10(%rdi),%rbx,%rbx
   e8662:	lea    (%rbx,%rbx,4),%rbx
   e8666:	imul   %r9,%rdx
   e866a:	vmovdqu (%r11,%rbx,8),%ymm3
   e8670:	vpbroadcastq %rdx,%ymm4
   e8676:	vpsllvq %ymm0,%ymm4,%ymm4
   e867b:	vpsrld $0x1b,%ymm4,%ymm4
   e8680:	vpsllvd %ymm4,%ymm1,%ymm4
   e8685:	vptest %ymm4,%ymm3
   e868a:	setb   %bpl
   e868e:	mulx   %r10,%rdx,%r14
   e8693:	xor    %rdx,%r14
   e8696:	vpbroadcastq %r14,%ymm3
   e869c:	prefetcht0 (%r11,%rbx,8)
   e86a1:	vmovdqu 0x20(%r11,%rbx,8),%ymm4
   e86a8:	vpsllvq %ymm0,%ymm3,%ymm3
   e86ad:	vpsrld $0x1b,%ymm3,%ymm3
   e86b2:	vpsllvd %ymm3,%ymm2,%ymm3
   e86b7:	vptest %ymm3,%ymm4
   e86bc:	setb   %dl
   e86bf:	prefetcht0 0x40(%r11,%rbx,8)
   e86c5:	and    %bpl,%dl
   e86c8:	movzbl %dl,%edx
   e86cb:	mov    %edx,(%rcx,%r8,4)
   e86cf:	inc    %r8
   e86d2:	cmp    %r8,%rsi
   e86d5:	jne    e8650 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   e86db:	pop    %rbx
   e86dc:	pop    %r14
   e86de:	pop    %rbp
   e86df:	vzeroupper
   e86e2:	ret
   e86e3:	int3
   e86e4:	int3
   e86e5:	int3
   e86e6:	int3
   e86e7:	int3
   e86e8:	int3
   e86e9:	int3
   e86ea:	int3
   e86eb:	int3
   e86ec:	int3
   e86ed:	int3
   e86ee:	int3
   e86ef:	int3

