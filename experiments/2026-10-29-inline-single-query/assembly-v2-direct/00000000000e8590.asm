00000000000e8590 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e8590:	test   %rsi,%rsi
   e8593:	je     e865f <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xcf>
   e8599:	push   %rbp
   e859a:	push   %r14
   e859c:	push   %rbx
   e859d:	mov    %rdx,%rax
   e85a0:	xor    %r8d,%r8d
   e85a3:	movabs $0xf1357aea2e62a9c5,%r9
   e85ad:	vmovdqa -0xe3a75(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e85b5:	vpbroadcastd -0xe5316(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e85be:	movabs $0x9e3779b97f4a7c15,%r10
   e85c8:	vmovdqa -0xe3b10(%rip),%ymm2        # 4ac0 <typeinfo name for main::$_60+0x2f0>
   e85d0:	mov    (%rax,%r8,8),%rdx
   e85d4:	or     $0x1,%rdx
   e85d8:	mov    0x20(%rdi),%r11
   e85dc:	mulx   0x10(%rdi),%rbx,%rbx
   e85e2:	lea    (%rbx,%rbx,4),%rbx
   e85e6:	imul   %r9,%rdx
   e85ea:	vmovdqu (%r11,%rbx,8),%ymm3
   e85f0:	vpbroadcastq %rdx,%ymm4
   e85f6:	vpsllvq %ymm0,%ymm4,%ymm4
   e85fb:	vpsrld $0x1b,%ymm4,%ymm4
   e8600:	vpsllvd %ymm4,%ymm1,%ymm4
   e8605:	vptest %ymm4,%ymm3
   e860a:	setb   %bpl
   e860e:	mulx   %r10,%rdx,%r14
   e8613:	xor    %rdx,%r14
   e8616:	vpbroadcastq %r14,%ymm3
   e861c:	prefetcht0 (%r11,%rbx,8)
   e8621:	vmovdqu 0x20(%r11,%rbx,8),%ymm4
   e8628:	vpsllvq %ymm0,%ymm3,%ymm3
   e862d:	vpsrld $0x1b,%ymm3,%ymm3
   e8632:	vpsllvd %ymm3,%ymm2,%ymm3
   e8637:	vptest %ymm3,%ymm4
   e863c:	setb   %dl
   e863f:	prefetcht0 0x40(%r11,%rbx,8)
   e8645:	and    %bpl,%dl
   e8648:	movzbl %dl,%edx
   e864b:	mov    %edx,(%rcx,%r8,4)
   e864f:	inc    %r8
   e8652:	cmp    %r8,%rsi
   e8655:	jne    e85d0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   e865b:	pop    %rbx
   e865c:	pop    %r14
   e865e:	pop    %rbp
   e865f:	vzeroupper
   e8662:	ret
   e8663:	int3
   e8664:	int3
   e8665:	int3
   e8666:	int3
   e8667:	int3
   e8668:	int3
   e8669:	int3
   e866a:	int3
   e866b:	int3
   e866c:	int3
   e866d:	int3
   e866e:	int3
   e866f:	int3

