0000000000125400 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  125400:	test   %rsi,%rsi
  125403:	je     125596 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x196>
  125409:	push   %r15
  12540b:	push   %r14
  12540d:	push   %r12
  12540f:	push   %rbx
  125410:	mov    %rdx,%rax
  125413:	movabs $0xd6e8feb86659fd93,%r8
  12541d:	xor    %r9d,%r9d
  125420:	movabs $0xf1357aea2e62a9c5,%r10
  12542a:	movabs $0x9e3779b97f4a7c15,%r11
  125434:	vmovdqa -0x120a5c(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  12543c:	vmovdqa -0x120bc4(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  125444:	vpbroadcastd -0x1221c9(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  12544d:	vmovdqa -0x120b55(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  125455:	vmovdqa -0x120a9d(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  12545d:	vpbroadcastq -0x1220c6(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  125466:	cs nopw 0x0(%rax,%rax,1)
  125470:	mov    (%rax,%r9,8),%rdx
  125474:	mov    %rdx,%rbx
  125477:	shr    $0x20,%rbx
  12547b:	xor    %rdx,%rbx
  12547e:	imul   %r8,%rbx
  125482:	mov    %rbx,%r14
  125485:	shr    $0x20,%r14
  125489:	xor    %rbx,%r14
  12548c:	imul   %r8,%r14
  125490:	mov    %r14,%rdx
  125493:	shr    $0x20,%rdx
  125497:	xor    %r14,%rdx
  12549a:	or     $0x1,%rdx
  12549e:	mov    0x20(%rdi),%r14
  1254a2:	mulx   0x10(%rdi),%r15,%r15
  1254a8:	imul   %r10,%rdx
  1254ac:	mulx   %r11,%r12,%rbx
  1254b1:	xor    %r12,%rbx
  1254b4:	shl    $0x6,%r15
  1254b8:	vpbroadcastq %rdx,%ymm6
  1254be:	lea    (%r14,%r15,1),%rdx
  1254c2:	vpbroadcastq %rbx,%xmm7
  1254c8:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  1254ce:	vpsrlvq %ymm1,%ymm6,%ymm8
  1254d3:	vpmovqd %ymm8,%xmm8
  1254d9:	vpand  %xmm2,%xmm8,%xmm8
  1254dd:	kxnorw %k0,%k0,%k1
  1254e1:	vpxor  %xmm9,%xmm9,%xmm9
  1254e6:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  1254ed:	vpsrlvq %ymm0,%ymm7,%ymm8
  1254f2:	vpmovqd %ymm8,%xmm8
  1254f8:	vpand  %xmm2,%xmm8,%xmm8
  1254fc:	kxnorw %k0,%k0,%k1
  125500:	vpxor  %xmm10,%xmm10,%xmm10
  125505:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  12550c:	prefetcht0 (%r14,%r15,1)
  125511:	vpsrlvq %ymm3,%ymm7,%ymm7
  125516:	vpsrlvq %ymm4,%ymm6,%ymm6
  12551b:	vpand  %ymm5,%ymm7,%ymm7
  12551f:	vpsrlvq %ymm7,%ymm10,%ymm7
  125524:	vpand  %ymm5,%ymm6,%ymm6
  125528:	mov    %ebx,%r14d
  12552b:	shr    $0x18,%r14d
  12552f:	and    $0x38,%r14d
  125533:	mov    %rbx,%r15
  125536:	shr    $0x1e,%r15
  12553a:	shrx   %r15,(%r14,%rdx,1),%r14
  125540:	vpsrlvq %ymm6,%ymm9,%ymm6
  125545:	mov    %rbx,%r15
  125548:	shr    $0x24,%r15
  12554c:	and    $0x7,%r15d
  125550:	shr    $0x27,%rbx
  125554:	shrx   %rbx,(%rdx,%r15,8),%rdx
  12555a:	vpand  %ymm7,%ymm6,%ymm6
  12555e:	vextracti128 $0x1,%ymm6,%xmm7
  125564:	vpand  %xmm7,%xmm6,%xmm6
  125568:	vpshufd $0xee,%xmm6,%xmm7
  12556d:	vpand  %xmm6,%xmm7,%xmm6
  125571:	vmovd  %xmm6,%ebx
  125575:	and    %edx,%r14d
  125578:	and    %ebx,%r14d
  12557b:	and    $0x1,%r14d
  12557f:	mov    %r14d,(%rcx,%r9,4)
  125583:	inc    %r9
  125586:	cmp    %r9,%rsi
  125589:	jne    125470 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x70>
  12558f:	pop    %rbx
  125590:	pop    %r12
  125592:	pop    %r14
  125594:	pop    %r15
  125596:	vzeroupper
  125599:	ret
  12559a:	int3
  12559b:	int3
  12559c:	int3
  12559d:	int3
  12559e:	int3
  12559f:	int3

