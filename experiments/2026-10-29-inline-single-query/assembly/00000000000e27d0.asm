00000000000e27d0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e27d0:	48 85 f6             	test   %rsi,%rsi
   e27d3:	0f 84 b4 01 00 00    	je     e298d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
   e27d9:	41 56                	push   %r14
   e27db:	53                   	push   %rbx
   e27dc:	48 89 d0             	mov    %rdx,%rax
   e27df:	49 b9 c5 a9 62 2e ea 	movabs $0xf1357aea2e62a9c5,%r9
   e27e6:	7a 35 f1
   e27e9:	49 ba 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r10
   e27f0:	fe e8 d6
   e27f3:	48 83 fe 01          	cmp    $0x1,%rsi
   e27f7:	75 08                	jne    e2801 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   e27f9:	45 31 c0             	xor    %r8d,%r8d
   e27fc:	e9 10 01 00 00       	jmp    e2911 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x141>
   e2801:	49 89 f3             	mov    %rsi,%r11
   e2804:	49 83 e3 fe          	and    $0xfffffffffffffffe,%r11
   e2808:	45 31 c0             	xor    %r8d,%r8d
   e280b:	c5 fd 6f 05 2d 23 f2 	vmovdqa -0xddcd3(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e2812:	ff
   e2813:	c4 e2 7d 58 0d 8c 0a 	vpbroadcastd -0xdf574(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e281a:	f2 ff
   e281c:	0f 1f 40 00          	nopl   0x0(%rax)
   e2820:	4a 8b 14 c0          	mov    (%rax,%r8,8),%rdx
   e2824:	48 89 d3             	mov    %rdx,%rbx
   e2827:	48 c1 eb 20          	shr    $0x20,%rbx
   e282b:	48 31 d3             	xor    %rdx,%rbx
   e282e:	49 0f af da          	imul   %r10,%rbx
   e2832:	49 89 de             	mov    %rbx,%r14
   e2835:	49 c1 ee 20          	shr    $0x20,%r14
   e2839:	49 31 de             	xor    %rbx,%r14
   e283c:	4d 0f af f2          	imul   %r10,%r14
   e2840:	4c 89 f2             	mov    %r14,%rdx
   e2843:	48 c1 ea 20          	shr    $0x20,%rdx
   e2847:	4c 31 f2             	xor    %r14,%rdx
   e284a:	48 83 ca 01          	or     $0x1,%rdx
   e284e:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
   e2852:	c4 62 8b f6 77 10    	mulx   0x10(%rdi),%r14,%r14
   e2858:	49 0f af d1          	imul   %r9,%rdx
   e285c:	49 c1 e6 05          	shl    $0x5,%r14
   e2860:	c4 a1 7d 6f 14 33    	vmovdqa (%rbx,%r14,1),%ymm2
   e2866:	62 f2 fd 28 7c da    	vpbroadcastq %rdx,%ymm3
   e286c:	c4 e2 e5 47 d8       	vpsllvq %ymm0,%ymm3,%ymm3
   e2871:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
   e2876:	c4 e2 75 47 db       	vpsllvd %ymm3,%ymm1,%ymm3
   e287b:	31 d2                	xor    %edx,%edx
   e287d:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
   e2882:	42 0f 18 0c 33       	prefetcht0 (%rbx,%r14,1)
   e2887:	0f 92 c2             	setb   %dl
   e288a:	42 89 14 81          	mov    %edx,(%rcx,%r8,4)
   e288e:	4a 8b 54 c0 08       	mov    0x8(%rax,%r8,8),%rdx
   e2893:	48 89 d3             	mov    %rdx,%rbx
   e2896:	48 c1 eb 20          	shr    $0x20,%rbx
   e289a:	48 31 d3             	xor    %rdx,%rbx
   e289d:	49 0f af da          	imul   %r10,%rbx
   e28a1:	49 89 de             	mov    %rbx,%r14
   e28a4:	49 c1 ee 20          	shr    $0x20,%r14
   e28a8:	49 31 de             	xor    %rbx,%r14
   e28ab:	4d 0f af f2          	imul   %r10,%r14
   e28af:	4c 89 f2             	mov    %r14,%rdx
   e28b2:	48 c1 ea 20          	shr    $0x20,%rdx
   e28b6:	4c 31 f2             	xor    %r14,%rdx
   e28b9:	48 83 ca 01          	or     $0x1,%rdx
   e28bd:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
   e28c1:	c4 62 8b f6 77 10    	mulx   0x10(%rdi),%r14,%r14
   e28c7:	49 0f af d1          	imul   %r9,%rdx
   e28cb:	49 c1 e6 05          	shl    $0x5,%r14
   e28cf:	42 0f 18 0c 33       	prefetcht0 (%rbx,%r14,1)
   e28d4:	c4 a1 7d 6f 14 33    	vmovdqa (%rbx,%r14,1),%ymm2
   e28da:	62 f2 fd 28 7c da    	vpbroadcastq %rdx,%ymm3
   e28e0:	c4 e2 e5 47 d8       	vpsllvq %ymm0,%ymm3,%ymm3
   e28e5:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
   e28ea:	c4 e2 75 47 db       	vpsllvd %ymm3,%ymm1,%ymm3
   e28ef:	31 d2                	xor    %edx,%edx
   e28f1:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
   e28f6:	0f 92 c2             	setb   %dl
   e28f9:	42 89 54 81 04       	mov    %edx,0x4(%rcx,%r8,4)
   e28fe:	49 83 c0 02          	add    $0x2,%r8
   e2902:	4d 39 c3             	cmp    %r8,%r11
   e2905:	0f 85 15 ff ff ff    	jne    e2820 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   e290b:	40 f6 c6 01          	test   $0x1,%sil
   e290f:	74 79                	je     e298a <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ba>
   e2911:	4a 8b 04 c0          	mov    (%rax,%r8,8),%rax
   e2915:	48 89 c2             	mov    %rax,%rdx
   e2918:	48 c1 ea 20          	shr    $0x20,%rdx
   e291c:	48 31 c2             	xor    %rax,%rdx
   e291f:	49 0f af d2          	imul   %r10,%rdx
   e2923:	48 89 d0             	mov    %rdx,%rax
   e2926:	48 c1 e8 20          	shr    $0x20,%rax
   e292a:	48 31 d0             	xor    %rdx,%rax
   e292d:	49 0f af c2          	imul   %r10,%rax
   e2931:	48 89 c2             	mov    %rax,%rdx
   e2934:	48 c1 ea 20          	shr    $0x20,%rdx
   e2938:	48 31 c2             	xor    %rax,%rdx
   e293b:	48 83 ca 01          	or     $0x1,%rdx
   e293f:	48 8b 47 20          	mov    0x20(%rdi),%rax
   e2943:	c4 e2 cb f6 77 10    	mulx   0x10(%rdi),%rsi,%rsi
   e2949:	49 0f af d1          	imul   %r9,%rdx
   e294d:	48 c1 e6 05          	shl    $0x5,%rsi
   e2951:	0f 18 0c 30          	prefetcht0 (%rax,%rsi,1)
   e2955:	c5 fd 6f 04 30       	vmovdqa (%rax,%rsi,1),%ymm0
   e295a:	62 f2 fd 28 7c ca    	vpbroadcastq %rdx,%ymm1
   e2960:	c4 e2 f5 47 0d d7 21 	vpsllvq -0xdde29(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e2967:	f2 ff
   e2969:	c5 f5 72 d1 1b       	vpsrld $0x1b,%ymm1,%ymm1
   e296e:	c4 e2 7d 58 15 31 09 	vpbroadcastd -0xdf6cf(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e2975:	f2 ff
   e2977:	c4 e2 6d 47 c9       	vpsllvd %ymm1,%ymm2,%ymm1
   e297c:	31 c0                	xor    %eax,%eax
   e297e:	c4 e2 7d 17 c1       	vptest %ymm1,%ymm0
   e2983:	0f 92 c0             	setb   %al
   e2986:	42 89 04 81          	mov    %eax,(%rcx,%r8,4)
   e298a:	5b                   	pop    %rbx
   e298b:	41 5e                	pop    %r14
   e298d:	c5 f8 77             	vzeroupper
   e2990:	c3                   	ret
   e2991:	cc                   	int3
   e2992:	cc                   	int3
   e2993:	cc                   	int3
   e2994:	cc                   	int3
   e2995:	cc                   	int3
   e2996:	cc                   	int3
   e2997:	cc                   	int3
   e2998:	cc                   	int3
   e2999:	cc                   	int3
   e299a:	cc                   	int3
   e299b:	cc                   	int3
   e299c:	cc                   	int3
   e299d:	cc                   	int3
   e299e:	cc                   	int3
   e299f:	cc                   	int3
