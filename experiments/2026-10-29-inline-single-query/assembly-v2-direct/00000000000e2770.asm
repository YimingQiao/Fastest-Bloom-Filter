00000000000e2770 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e2770:	test   %rsi,%rsi
   e2773:	je     e292d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
   e2779:	push   %r14
   e277b:	push   %rbx
   e277c:	mov    %rdx,%rax
   e277f:	movabs $0xf1357aea2e62a9c5,%r9
   e2789:	movabs $0xd6e8feb86659fd93,%r10
   e2793:	cmp    $0x1,%rsi
   e2797:	jne    e27a1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   e2799:	xor    %r8d,%r8d
   e279c:	jmp    e28b1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x141>
   e27a1:	mov    %rsi,%r11
   e27a4:	and    $0xfffffffffffffffe,%r11
   e27a8:	xor    %r8d,%r8d
   e27ab:	vmovdqa -0xddc73(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e27b3:	vpbroadcastd -0xdf514(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e27bc:	nopl   0x0(%rax)
   e27c0:	mov    (%rax,%r8,8),%rdx
   e27c4:	mov    %rdx,%rbx
   e27c7:	shr    $0x20,%rbx
   e27cb:	xor    %rdx,%rbx
   e27ce:	imul   %r10,%rbx
   e27d2:	mov    %rbx,%r14
   e27d5:	shr    $0x20,%r14
   e27d9:	xor    %rbx,%r14
   e27dc:	imul   %r10,%r14
   e27e0:	mov    %r14,%rdx
   e27e3:	shr    $0x20,%rdx
   e27e7:	xor    %r14,%rdx
   e27ea:	or     $0x1,%rdx
   e27ee:	mov    0x20(%rdi),%rbx
   e27f2:	mulx   0x10(%rdi),%r14,%r14
   e27f8:	imul   %r9,%rdx
   e27fc:	shl    $0x5,%r14
   e2800:	vmovdqa (%rbx,%r14,1),%ymm2
   e2806:	vpbroadcastq %rdx,%ymm3
   e280c:	vpsllvq %ymm0,%ymm3,%ymm3
   e2811:	vpsrld $0x1b,%ymm3,%ymm3
   e2816:	vpsllvd %ymm3,%ymm1,%ymm3
   e281b:	xor    %edx,%edx
   e281d:	vptest %ymm3,%ymm2
   e2822:	prefetcht0 (%rbx,%r14,1)
   e2827:	setb   %dl
   e282a:	mov    %edx,(%rcx,%r8,4)
   e282e:	mov    0x8(%rax,%r8,8),%rdx
   e2833:	mov    %rdx,%rbx
   e2836:	shr    $0x20,%rbx
   e283a:	xor    %rdx,%rbx
   e283d:	imul   %r10,%rbx
   e2841:	mov    %rbx,%r14
   e2844:	shr    $0x20,%r14
   e2848:	xor    %rbx,%r14
   e284b:	imul   %r10,%r14
   e284f:	mov    %r14,%rdx
   e2852:	shr    $0x20,%rdx
   e2856:	xor    %r14,%rdx
   e2859:	or     $0x1,%rdx
   e285d:	mov    0x20(%rdi),%rbx
   e2861:	mulx   0x10(%rdi),%r14,%r14
   e2867:	imul   %r9,%rdx
   e286b:	shl    $0x5,%r14
   e286f:	prefetcht0 (%rbx,%r14,1)
   e2874:	vmovdqa (%rbx,%r14,1),%ymm2
   e287a:	vpbroadcastq %rdx,%ymm3
   e2880:	vpsllvq %ymm0,%ymm3,%ymm3
   e2885:	vpsrld $0x1b,%ymm3,%ymm3
   e288a:	vpsllvd %ymm3,%ymm1,%ymm3
   e288f:	xor    %edx,%edx
   e2891:	vptest %ymm3,%ymm2
   e2896:	setb   %dl
   e2899:	mov    %edx,0x4(%rcx,%r8,4)
   e289e:	add    $0x2,%r8
   e28a2:	cmp    %r8,%r11
   e28a5:	jne    e27c0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   e28ab:	test   $0x1,%sil
   e28af:	je     e292a <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ba>
   e28b1:	mov    (%rax,%r8,8),%rax
   e28b5:	mov    %rax,%rdx
   e28b8:	shr    $0x20,%rdx
   e28bc:	xor    %rax,%rdx
   e28bf:	imul   %r10,%rdx
   e28c3:	mov    %rdx,%rax
   e28c6:	shr    $0x20,%rax
   e28ca:	xor    %rdx,%rax
   e28cd:	imul   %r10,%rax
   e28d1:	mov    %rax,%rdx
   e28d4:	shr    $0x20,%rdx
   e28d8:	xor    %rax,%rdx
   e28db:	or     $0x1,%rdx
   e28df:	mov    0x20(%rdi),%rax
   e28e3:	mulx   0x10(%rdi),%rsi,%rsi
   e28e9:	imul   %r9,%rdx
   e28ed:	shl    $0x5,%rsi
   e28f1:	prefetcht0 (%rax,%rsi,1)
   e28f5:	vmovdqa (%rax,%rsi,1),%ymm0
   e28fa:	vpbroadcastq %rdx,%ymm1
   e2900:	vpsllvq -0xdddc9(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e2909:	vpsrld $0x1b,%ymm1,%ymm1
   e290e:	vpbroadcastd -0xdf66f(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e2917:	vpsllvd %ymm1,%ymm2,%ymm1
   e291c:	xor    %eax,%eax
   e291e:	vptest %ymm1,%ymm0
   e2923:	setb   %al
   e2926:	mov    %eax,(%rcx,%r8,4)
   e292a:	pop    %rbx
   e292b:	pop    %r14
   e292d:	vzeroupper
   e2930:	ret
   e2931:	int3
   e2932:	int3
   e2933:	int3
   e2934:	int3
   e2935:	int3
   e2936:	int3
   e2937:	int3
   e2938:	int3
   e2939:	int3
   e293a:	int3
   e293b:	int3
   e293c:	int3
   e293d:	int3
   e293e:	int3
   e293f:	int3

