00000000000e27f0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e27f0:	test   %rsi,%rsi
   e27f3:	je     e29ad <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
   e27f9:	push   %r14
   e27fb:	push   %rbx
   e27fc:	mov    %rdx,%rax
   e27ff:	movabs $0xf1357aea2e62a9c5,%r9
   e2809:	movabs $0xd6e8feb86659fd93,%r10
   e2813:	cmp    $0x1,%rsi
   e2817:	jne    e2821 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   e2819:	xor    %r8d,%r8d
   e281c:	jmp    e2931 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x141>
   e2821:	mov    %rsi,%r11
   e2824:	and    $0xfffffffffffffffe,%r11
   e2828:	xor    %r8d,%r8d
   e282b:	vmovdqa -0xddcf3(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e2833:	vpbroadcastd -0xdf594(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e283c:	nopl   0x0(%rax)
   e2840:	mov    (%rax,%r8,8),%rdx
   e2844:	mov    %rdx,%rbx
   e2847:	shr    $0x20,%rbx
   e284b:	xor    %rdx,%rbx
   e284e:	imul   %r10,%rbx
   e2852:	mov    %rbx,%r14
   e2855:	shr    $0x20,%r14
   e2859:	xor    %rbx,%r14
   e285c:	imul   %r10,%r14
   e2860:	mov    %r14,%rdx
   e2863:	shr    $0x20,%rdx
   e2867:	xor    %r14,%rdx
   e286a:	or     $0x1,%rdx
   e286e:	mov    0x20(%rdi),%rbx
   e2872:	mulx   0x10(%rdi),%r14,%r14
   e2878:	imul   %r9,%rdx
   e287c:	shl    $0x5,%r14
   e2880:	vmovdqa (%rbx,%r14,1),%ymm2
   e2886:	vpbroadcastq %rdx,%ymm3
   e288c:	vpsllvq %ymm0,%ymm3,%ymm3
   e2891:	vpsrld $0x1b,%ymm3,%ymm3
   e2896:	vpsllvd %ymm3,%ymm1,%ymm3
   e289b:	xor    %edx,%edx
   e289d:	vptest %ymm3,%ymm2
   e28a2:	prefetcht0 (%rbx,%r14,1)
   e28a7:	setb   %dl
   e28aa:	mov    %edx,(%rcx,%r8,4)
   e28ae:	mov    0x8(%rax,%r8,8),%rdx
   e28b3:	mov    %rdx,%rbx
   e28b6:	shr    $0x20,%rbx
   e28ba:	xor    %rdx,%rbx
   e28bd:	imul   %r10,%rbx
   e28c1:	mov    %rbx,%r14
   e28c4:	shr    $0x20,%r14
   e28c8:	xor    %rbx,%r14
   e28cb:	imul   %r10,%r14
   e28cf:	mov    %r14,%rdx
   e28d2:	shr    $0x20,%rdx
   e28d6:	xor    %r14,%rdx
   e28d9:	or     $0x1,%rdx
   e28dd:	mov    0x20(%rdi),%rbx
   e28e1:	mulx   0x10(%rdi),%r14,%r14
   e28e7:	imul   %r9,%rdx
   e28eb:	shl    $0x5,%r14
   e28ef:	prefetcht0 (%rbx,%r14,1)
   e28f4:	vmovdqa (%rbx,%r14,1),%ymm2
   e28fa:	vpbroadcastq %rdx,%ymm3
   e2900:	vpsllvq %ymm0,%ymm3,%ymm3
   e2905:	vpsrld $0x1b,%ymm3,%ymm3
   e290a:	vpsllvd %ymm3,%ymm1,%ymm3
   e290f:	xor    %edx,%edx
   e2911:	vptest %ymm3,%ymm2
   e2916:	setb   %dl
   e2919:	mov    %edx,0x4(%rcx,%r8,4)
   e291e:	add    $0x2,%r8
   e2922:	cmp    %r8,%r11
   e2925:	jne    e2840 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   e292b:	test   $0x1,%sil
   e292f:	je     e29aa <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ba>
   e2931:	mov    (%rax,%r8,8),%rax
   e2935:	mov    %rax,%rdx
   e2938:	shr    $0x20,%rdx
   e293c:	xor    %rax,%rdx
   e293f:	imul   %r10,%rdx
   e2943:	mov    %rdx,%rax
   e2946:	shr    $0x20,%rax
   e294a:	xor    %rdx,%rax
   e294d:	imul   %r10,%rax
   e2951:	mov    %rax,%rdx
   e2954:	shr    $0x20,%rdx
   e2958:	xor    %rax,%rdx
   e295b:	or     $0x1,%rdx
   e295f:	mov    0x20(%rdi),%rax
   e2963:	mulx   0x10(%rdi),%rsi,%rsi
   e2969:	imul   %r9,%rdx
   e296d:	shl    $0x5,%rsi
   e2971:	prefetcht0 (%rax,%rsi,1)
   e2975:	vmovdqa (%rax,%rsi,1),%ymm0
   e297a:	vpbroadcastq %rdx,%ymm1
   e2980:	vpsllvq -0xdde49(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e2989:	vpsrld $0x1b,%ymm1,%ymm1
   e298e:	vpbroadcastd -0xdf6ef(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e2997:	vpsllvd %ymm1,%ymm2,%ymm1
   e299c:	xor    %eax,%eax
   e299e:	vptest %ymm1,%ymm0
   e29a3:	setb   %al
   e29a6:	mov    %eax,(%rcx,%r8,4)
   e29aa:	pop    %rbx
   e29ab:	pop    %r14
   e29ad:	vzeroupper
   e29b0:	ret
   e29b1:	int3
   e29b2:	int3
   e29b3:	int3
   e29b4:	int3
   e29b5:	int3
   e29b6:	int3
   e29b7:	int3
   e29b8:	int3
   e29b9:	int3
   e29ba:	int3
   e29bb:	int3
   e29bc:	int3
   e29bd:	int3
   e29be:	int3
   e29bf:	int3

