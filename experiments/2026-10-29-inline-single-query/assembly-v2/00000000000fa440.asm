00000000000fa440 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   fa440:	test   %rsi,%rsi
   fa443:	je     fa599 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x159>
   fa449:	push   %rbx
   fa44a:	mov    %rdx,%rax
   fa44d:	movabs $0xf1357aea2e62a9c5,%r9
   fa457:	cmp    $0x1,%rsi
   fa45b:	jne    fa465 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   fa45d:	xor    %r8d,%r8d
   fa460:	jmp    fa53b <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xfb>
   fa465:	mov    %rsi,%r10
   fa468:	and    $0xfffffffffffffffe,%r10
   fa46c:	xor    %r8d,%r8d
   fa46f:	vmovdqa -0xf5817(%rip),%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa477:	vpbroadcastq -0xf7128(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa480:	mov    (%rax,%r8,8),%rdx
   fa484:	or     $0x1,%rdx
   fa488:	mov    0x20(%rdi),%r11
   fa48c:	mulx   0x10(%rdi),%rbx,%rbx
   fa492:	shl    $0x5,%rbx
   fa496:	prefetcht0 (%r11,%rbx,1)
   fa49b:	prefetcht0 0x40(%r11,%rbx,1)
   fa4a1:	imul   %r9,%rdx
   fa4a5:	vpbroadcastq %rdx,%xmm2
   fa4ab:	vpsllvq %xmm0,%xmm2,%xmm2
   fa4b0:	vpsrld $0x1a,%xmm2,%xmm2
   fa4b5:	vpmovzxdq %xmm2,%ymm2
   fa4ba:	vpsllvq %ymm2,%ymm1,%ymm2
   fa4bf:	vmovdqa (%r11,%rbx,1),%ymm3
   fa4c5:	xor    %edx,%edx
   fa4c7:	vptest %ymm2,%ymm3
   fa4cc:	setb   %dl
   fa4cf:	mov    %edx,(%rcx,%r8,4)
   fa4d3:	mov    0x8(%rax,%r8,8),%rdx
   fa4d8:	or     $0x1,%rdx
   fa4dc:	mov    0x20(%rdi),%r11
   fa4e0:	mulx   0x10(%rdi),%rbx,%rbx
   fa4e6:	shl    $0x5,%rbx
   fa4ea:	prefetcht0 (%r11,%rbx,1)
   fa4ef:	prefetcht0 0x40(%r11,%rbx,1)
   fa4f5:	imul   %r9,%rdx
   fa4f9:	vpbroadcastq %rdx,%xmm2
   fa4ff:	vpsllvq %xmm0,%xmm2,%xmm2
   fa504:	vpsrld $0x1a,%xmm2,%xmm2
   fa509:	vpmovzxdq %xmm2,%ymm2
   fa50e:	vpsllvq %ymm2,%ymm1,%ymm2
   fa513:	vmovdqa (%r11,%rbx,1),%ymm3
   fa519:	xor    %edx,%edx
   fa51b:	vptest %ymm2,%ymm3
   fa520:	setb   %dl
   fa523:	mov    %edx,0x4(%rcx,%r8,4)
   fa528:	add    $0x2,%r8
   fa52c:	cmp    %r8,%r10
   fa52f:	jne    fa480 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   fa535:	test   $0x1,%sil
   fa539:	je     fa598 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
   fa53b:	mov    (%rax,%r8,8),%rdx
   fa53f:	or     $0x1,%rdx
   fa543:	mov    0x20(%rdi),%rax
   fa547:	mulx   0x10(%rdi),%rsi,%rsi
   fa54d:	shl    $0x5,%rsi
   fa551:	prefetcht0 (%rax,%rsi,1)
   fa555:	prefetcht0 0x40(%rax,%rsi,1)
   fa55a:	imul   %r9,%rdx
   fa55e:	vpbroadcastq %rdx,%xmm0
   fa564:	vpsllvq -0xf590d(%rip),%xmm0,%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa56d:	vpsrld $0x1a,%xmm0,%xmm0
   fa572:	vpmovzxdq %xmm0,%ymm0
   fa577:	vpbroadcastq -0xf7228(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa580:	vpsllvq %ymm0,%ymm1,%ymm0
   fa585:	vmovdqa (%rax,%rsi,1),%ymm1
   fa58a:	xor    %eax,%eax
   fa58c:	vptest %ymm0,%ymm1
   fa591:	setb   %al
   fa594:	mov    %eax,(%rcx,%r8,4)
   fa598:	pop    %rbx
   fa599:	vzeroupper
   fa59c:	ret
   fa59d:	int3
   fa59e:	int3
   fa59f:	int3

