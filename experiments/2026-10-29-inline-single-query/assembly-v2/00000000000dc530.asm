00000000000dc530 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   dc530:	test   %rsi,%rsi
   dc533:	je     dc718 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e8>
   dc539:	push   %r15
   dc53b:	push   %r14
   dc53d:	push   %rbx
   dc53e:	mov    %rdx,%rax
   dc541:	movabs $0xf1357aea2e62a9c5,%r9
   dc54b:	movabs $0xd6e8feb86659fd93,%r10
   dc555:	cmp    $0x1,%rsi
   dc559:	jne    dc563 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x33>
   dc55b:	xor    %r8d,%r8d
   dc55e:	jmp    dc68f <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x15f>
   dc563:	mov    %rsi,%r11
   dc566:	and    $0xfffffffffffffffe,%r11
   dc56a:	xor    %r8d,%r8d
   dc56d:	vmovdqa -0xd7a35(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   dc575:	vmovdqa -0xd7a1d(%rip),%ymm1        # 4b60 <typeinfo name for main::$_60+0x390>
   dc57d:	nopl   (%rax)
   dc580:	mov    (%rax,%r8,8),%rdx
   dc584:	mov    %rdx,%rbx
   dc587:	shr    $0x20,%rbx
   dc58b:	xor    %rdx,%rbx
   dc58e:	imul   %r10,%rbx
   dc592:	mov    %rbx,%r14
   dc595:	shr    $0x20,%r14
   dc599:	xor    %rbx,%r14
   dc59c:	imul   %r10,%r14
   dc5a0:	mov    %r14,%rdx
   dc5a3:	shr    $0x20,%rdx
   dc5a7:	xor    %r14,%rdx
   dc5aa:	or     $0x1,%rdx
   dc5ae:	mov    0x20(%rdi),%rbx
   dc5b2:	mulx   0x10(%rdi),%r14,%r14
   dc5b8:	lea    (%r14,%r14,8),%r15
   dc5bc:	lea    (%r15,%r15,2),%r15
   dc5c0:	add    %r14,%r15
   dc5c3:	prefetcht0 (%rbx,%r15,1)
   dc5c8:	imul   %r9,%rdx
   dc5cc:	vmovdqu (%rbx,%r15,1),%ymm2
   dc5d2:	vpbroadcastq %rdx,%ymm3
   dc5d8:	vpsllvq %ymm0,%ymm3,%ymm3
   dc5dd:	vpsrld $0x1b,%ymm3,%ymm3
   dc5e2:	vpsllvd %ymm3,%ymm1,%ymm3
   dc5e7:	xor    %edx,%edx
   dc5e9:	vptest %ymm3,%ymm2
   dc5ee:	setb   %dl
   dc5f1:	prefetcht0 0x40(%rbx,%r15,1)
   dc5f7:	mov    %edx,(%rcx,%r8,4)
   dc5fb:	mov    0x8(%rax,%r8,8),%rdx
   dc600:	mov    %rdx,%rbx
   dc603:	shr    $0x20,%rbx
   dc607:	xor    %rdx,%rbx
   dc60a:	imul   %r10,%rbx
   dc60e:	mov    %rbx,%r14
   dc611:	shr    $0x20,%r14
   dc615:	xor    %rbx,%r14
   dc618:	imul   %r10,%r14
   dc61c:	mov    %r14,%rdx
   dc61f:	shr    $0x20,%rdx
   dc623:	xor    %r14,%rdx
   dc626:	or     $0x1,%rdx
   dc62a:	mov    0x20(%rdi),%rbx
   dc62e:	mulx   0x10(%rdi),%r14,%r14
   dc634:	lea    (%r14,%r14,8),%r15
   dc638:	lea    (%r15,%r15,2),%r15
   dc63c:	add    %r14,%r15
   dc63f:	prefetcht0 (%rbx,%r15,1)
   dc644:	prefetcht0 0x40(%rbx,%r15,1)
   dc64a:	imul   %r9,%rdx
   dc64e:	vmovdqu (%rbx,%r15,1),%ymm2
   dc654:	vpbroadcastq %rdx,%ymm3
   dc65a:	vpsllvq %ymm0,%ymm3,%ymm3
   dc65f:	vpsrld $0x1b,%ymm3,%ymm3
   dc664:	vpsllvd %ymm3,%ymm1,%ymm3
   dc669:	xor    %edx,%edx
   dc66b:	vptest %ymm3,%ymm2
   dc670:	setb   %dl
   dc673:	mov    %edx,0x4(%rcx,%r8,4)
   dc678:	add    $0x2,%r8
   dc67c:	cmp    %r8,%r11
   dc67f:	jne    dc580 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   dc685:	test   $0x1,%sil
   dc689:	je     dc713 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e3>
   dc68f:	mov    (%rax,%r8,8),%rax
   dc693:	mov    %rax,%rdx
   dc696:	shr    $0x20,%rdx
   dc69a:	xor    %rax,%rdx
   dc69d:	imul   %r10,%rdx
   dc6a1:	mov    %rdx,%rax
   dc6a4:	shr    $0x20,%rax
   dc6a8:	xor    %rdx,%rax
   dc6ab:	imul   %r10,%rax
   dc6af:	mov    %rax,%rdx
   dc6b2:	shr    $0x20,%rdx
   dc6b6:	xor    %rax,%rdx
   dc6b9:	or     $0x1,%rdx
   dc6bd:	mov    0x20(%rdi),%rax
   dc6c1:	mulx   0x10(%rdi),%rsi,%rsi
   dc6c7:	lea    (%rsi,%rsi,8),%rdi
   dc6cb:	lea    (%rdi,%rdi,2),%rdi
   dc6cf:	add    %rsi,%rdi
   dc6d2:	prefetcht0 (%rax,%rdi,1)
   dc6d6:	prefetcht0 0x40(%rax,%rdi,1)
   dc6db:	imul   %r9,%rdx
   dc6df:	vmovdqu (%rax,%rdi,1),%ymm0
   dc6e4:	vpbroadcastq %rdx,%ymm1
   dc6ea:	vpsllvq -0xd7bb3(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   dc6f3:	vpsrld $0x1b,%ymm1,%ymm1
   dc6f8:	vmovdqa -0xd7ba0(%rip),%ymm2        # 4b60 <typeinfo name for main::$_60+0x390>
   dc700:	vpsllvd %ymm1,%ymm2,%ymm1
   dc705:	xor    %eax,%eax
   dc707:	vptest %ymm1,%ymm0
   dc70c:	setb   %al
   dc70f:	mov    %eax,(%rcx,%r8,4)
   dc713:	pop    %rbx
   dc714:	pop    %r14
   dc716:	pop    %r15
   dc718:	vzeroupper
   dc71b:	ret
   dc71c:	int3
   dc71d:	int3
   dc71e:	int3
   dc71f:	int3

