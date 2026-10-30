00000000000f4630 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   f4630:	test   %rsi,%rsi
   f4633:	je     f46f9 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xc9>
   f4639:	push   %rbp
   f463a:	push   %r14
   f463c:	push   %rbx
   f463d:	mov    %rdx,%rax
   f4640:	xor    %r8d,%r8d
   f4643:	movabs $0xf1357aea2e62a9c5,%r9
   f464d:	vmovdqa -0xefb15(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   f4655:	vpbroadcastd -0xf13b6(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   f465e:	movabs $0x9e3779b97f4a7c15,%r10
   f4668:	nopl   0x0(%rax,%rax,1)
   f4670:	mov    (%rax,%r8,8),%rdx
   f4674:	or     $0x1,%rdx
   f4678:	mov    0x20(%rdi),%r11
   f467c:	mulx   0x10(%rdi),%rbx,%rbx
   f4682:	imul   %r9,%rdx
   f4686:	shl    $0x6,%rbx
   f468a:	vpbroadcastq %rdx,%ymm2
   f4690:	vpsllvq %ymm0,%ymm2,%ymm2
   f4695:	vpsrld $0x1b,%ymm2,%ymm2
   f469a:	vpsllvd %ymm2,%ymm1,%ymm2
   f469f:	vmovdqa (%r11,%rbx,1),%ymm3
   f46a5:	vptest %ymm2,%ymm3
   f46aa:	setb   %bpl
   f46ae:	mulx   %r10,%rdx,%r14
   f46b3:	xor    %rdx,%r14
   f46b6:	vpbroadcastq %r14,%ymm2
   f46bc:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
   f46c3:	vpsllvq %ymm0,%ymm2,%ymm2
   f46c8:	vpsrld $0x1b,%ymm2,%ymm2
   f46cd:	vpsllvd %ymm2,%ymm1,%ymm2
   f46d2:	vptest %ymm2,%ymm3
   f46d7:	setb   %dl
   f46da:	prefetcht0 (%r11,%rbx,1)
   f46df:	and    %bpl,%dl
   f46e2:	movzbl %dl,%edx
   f46e5:	mov    %edx,(%rcx,%r8,4)
   f46e9:	inc    %r8
   f46ec:	cmp    %r8,%rsi
   f46ef:	jne    f4670 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   f46f5:	pop    %rbx
   f46f6:	pop    %r14
   f46f8:	pop    %rbp
   f46f9:	vzeroupper
   f46fc:	ret
   f46fd:	int3
   f46fe:	int3
   f46ff:	int3

