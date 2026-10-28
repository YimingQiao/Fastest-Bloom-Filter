00000000000dc4b0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   dc4b0:	test   %rsi,%rsi
   dc4b3:	je     dc698 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e8>
   dc4b9:	push   %r15
   dc4bb:	push   %r14
   dc4bd:	push   %rbx
   dc4be:	mov    %rdx,%rax
   dc4c1:	movabs $0xf1357aea2e62a9c5,%r9
   dc4cb:	movabs $0xd6e8feb86659fd93,%r10
   dc4d5:	cmp    $0x1,%rsi
   dc4d9:	jne    dc4e3 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x33>
   dc4db:	xor    %r8d,%r8d
   dc4de:	jmp    dc60f <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x15f>
   dc4e3:	mov    %rsi,%r11
   dc4e6:	and    $0xfffffffffffffffe,%r11
   dc4ea:	xor    %r8d,%r8d
   dc4ed:	vmovdqa -0xd79b5(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   dc4f5:	vmovdqa -0xd799d(%rip),%ymm1        # 4b60 <typeinfo name for main::$_60+0x390>
   dc4fd:	nopl   (%rax)
   dc500:	mov    (%rax,%r8,8),%rdx
   dc504:	mov    %rdx,%rbx
   dc507:	shr    $0x20,%rbx
   dc50b:	xor    %rdx,%rbx
   dc50e:	imul   %r10,%rbx
   dc512:	mov    %rbx,%r14
   dc515:	shr    $0x20,%r14
   dc519:	xor    %rbx,%r14
   dc51c:	imul   %r10,%r14
   dc520:	mov    %r14,%rdx
   dc523:	shr    $0x20,%rdx
   dc527:	xor    %r14,%rdx
   dc52a:	or     $0x1,%rdx
   dc52e:	mov    0x20(%rdi),%rbx
   dc532:	mulx   0x10(%rdi),%r14,%r14
   dc538:	lea    (%r14,%r14,8),%r15
   dc53c:	lea    (%r15,%r15,2),%r15
   dc540:	add    %r14,%r15
   dc543:	prefetcht0 (%rbx,%r15,1)
   dc548:	imul   %r9,%rdx
   dc54c:	vmovdqu (%rbx,%r15,1),%ymm2
   dc552:	vpbroadcastq %rdx,%ymm3
   dc558:	vpsllvq %ymm0,%ymm3,%ymm3
   dc55d:	vpsrld $0x1b,%ymm3,%ymm3
   dc562:	vpsllvd %ymm3,%ymm1,%ymm3
   dc567:	xor    %edx,%edx
   dc569:	vptest %ymm3,%ymm2
   dc56e:	setb   %dl
   dc571:	prefetcht0 0x40(%rbx,%r15,1)
   dc577:	mov    %edx,(%rcx,%r8,4)
   dc57b:	mov    0x8(%rax,%r8,8),%rdx
   dc580:	mov    %rdx,%rbx
   dc583:	shr    $0x20,%rbx
   dc587:	xor    %rdx,%rbx
   dc58a:	imul   %r10,%rbx
   dc58e:	mov    %rbx,%r14
   dc591:	shr    $0x20,%r14
   dc595:	xor    %rbx,%r14
   dc598:	imul   %r10,%r14
   dc59c:	mov    %r14,%rdx
   dc59f:	shr    $0x20,%rdx
   dc5a3:	xor    %r14,%rdx
   dc5a6:	or     $0x1,%rdx
   dc5aa:	mov    0x20(%rdi),%rbx
   dc5ae:	mulx   0x10(%rdi),%r14,%r14
   dc5b4:	lea    (%r14,%r14,8),%r15
   dc5b8:	lea    (%r15,%r15,2),%r15
   dc5bc:	add    %r14,%r15
   dc5bf:	prefetcht0 (%rbx,%r15,1)
   dc5c4:	prefetcht0 0x40(%rbx,%r15,1)
   dc5ca:	imul   %r9,%rdx
   dc5ce:	vmovdqu (%rbx,%r15,1),%ymm2
   dc5d4:	vpbroadcastq %rdx,%ymm3
   dc5da:	vpsllvq %ymm0,%ymm3,%ymm3
   dc5df:	vpsrld $0x1b,%ymm3,%ymm3
   dc5e4:	vpsllvd %ymm3,%ymm1,%ymm3
   dc5e9:	xor    %edx,%edx
   dc5eb:	vptest %ymm3,%ymm2
   dc5f0:	setb   %dl
   dc5f3:	mov    %edx,0x4(%rcx,%r8,4)
   dc5f8:	add    $0x2,%r8
   dc5fc:	cmp    %r8,%r11
   dc5ff:	jne    dc500 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   dc605:	test   $0x1,%sil
   dc609:	je     dc693 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e3>
   dc60f:	mov    (%rax,%r8,8),%rax
   dc613:	mov    %rax,%rdx
   dc616:	shr    $0x20,%rdx
   dc61a:	xor    %rax,%rdx
   dc61d:	imul   %r10,%rdx
   dc621:	mov    %rdx,%rax
   dc624:	shr    $0x20,%rax
   dc628:	xor    %rdx,%rax
   dc62b:	imul   %r10,%rax
   dc62f:	mov    %rax,%rdx
   dc632:	shr    $0x20,%rdx
   dc636:	xor    %rax,%rdx
   dc639:	or     $0x1,%rdx
   dc63d:	mov    0x20(%rdi),%rax
   dc641:	mulx   0x10(%rdi),%rsi,%rsi
   dc647:	lea    (%rsi,%rsi,8),%rdi
   dc64b:	lea    (%rdi,%rdi,2),%rdi
   dc64f:	add    %rsi,%rdi
   dc652:	prefetcht0 (%rax,%rdi,1)
   dc656:	prefetcht0 0x40(%rax,%rdi,1)
   dc65b:	imul   %r9,%rdx
   dc65f:	vmovdqu (%rax,%rdi,1),%ymm0
   dc664:	vpbroadcastq %rdx,%ymm1
   dc66a:	vpsllvq -0xd7b33(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   dc673:	vpsrld $0x1b,%ymm1,%ymm1
   dc678:	vmovdqa -0xd7b20(%rip),%ymm2        # 4b60 <typeinfo name for main::$_60+0x390>
   dc680:	vpsllvd %ymm1,%ymm2,%ymm1
   dc685:	xor    %eax,%eax
   dc687:	vptest %ymm1,%ymm0
   dc68c:	setb   %al
   dc68f:	mov    %eax,(%rcx,%r8,4)
   dc693:	pop    %rbx
   dc694:	pop    %r14
   dc696:	pop    %r15
   dc698:	vzeroupper
   dc69b:	ret
   dc69c:	int3
   dc69d:	int3
   dc69e:	int3
   dc69f:	int3

