00000000000f45b0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   f45b0:	test   %rsi,%rsi
   f45b3:	je     f4679 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xc9>
   f45b9:	push   %rbp
   f45ba:	push   %r14
   f45bc:	push   %rbx
   f45bd:	mov    %rdx,%rax
   f45c0:	xor    %r8d,%r8d
   f45c3:	movabs $0xf1357aea2e62a9c5,%r9
   f45cd:	vmovdqa -0xefa95(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   f45d5:	vpbroadcastd -0xf1336(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   f45de:	movabs $0x9e3779b97f4a7c15,%r10
   f45e8:	nopl   0x0(%rax,%rax,1)
   f45f0:	mov    (%rax,%r8,8),%rdx
   f45f4:	or     $0x1,%rdx
   f45f8:	mov    0x20(%rdi),%r11
   f45fc:	mulx   0x10(%rdi),%rbx,%rbx
   f4602:	imul   %r9,%rdx
   f4606:	shl    $0x6,%rbx
   f460a:	vpbroadcastq %rdx,%ymm2
   f4610:	vpsllvq %ymm0,%ymm2,%ymm2
   f4615:	vpsrld $0x1b,%ymm2,%ymm2
   f461a:	vpsllvd %ymm2,%ymm1,%ymm2
   f461f:	vmovdqa (%r11,%rbx,1),%ymm3
   f4625:	vptest %ymm2,%ymm3
   f462a:	setb   %bpl
   f462e:	mulx   %r10,%rdx,%r14
   f4633:	xor    %rdx,%r14
   f4636:	vpbroadcastq %r14,%ymm2
   f463c:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
   f4643:	vpsllvq %ymm0,%ymm2,%ymm2
   f4648:	vpsrld $0x1b,%ymm2,%ymm2
   f464d:	vpsllvd %ymm2,%ymm1,%ymm2
   f4652:	vptest %ymm2,%ymm3
   f4657:	setb   %dl
   f465a:	prefetcht0 (%r11,%rbx,1)
   f465f:	and    %bpl,%dl
   f4662:	movzbl %dl,%edx
   f4665:	mov    %edx,(%rcx,%r8,4)
   f4669:	inc    %r8
   f466c:	cmp    %r8,%rsi
   f466f:	jne    f45f0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   f4675:	pop    %rbx
   f4676:	pop    %r14
   f4678:	pop    %rbp
   f4679:	vzeroupper
   f467c:	ret
   f467d:	int3
   f467e:	int3
   f467f:	int3

