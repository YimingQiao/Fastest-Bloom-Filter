00000000000fa3c0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   fa3c0:	test   %rsi,%rsi
   fa3c3:	je     fa519 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x159>
   fa3c9:	push   %rbx
   fa3ca:	mov    %rdx,%rax
   fa3cd:	movabs $0xf1357aea2e62a9c5,%r9
   fa3d7:	cmp    $0x1,%rsi
   fa3db:	jne    fa3e5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   fa3dd:	xor    %r8d,%r8d
   fa3e0:	jmp    fa4bb <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xfb>
   fa3e5:	mov    %rsi,%r10
   fa3e8:	and    $0xfffffffffffffffe,%r10
   fa3ec:	xor    %r8d,%r8d
   fa3ef:	vmovdqa -0xf5797(%rip),%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa3f7:	vpbroadcastq -0xf70a8(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa400:	mov    (%rax,%r8,8),%rdx
   fa404:	or     $0x1,%rdx
   fa408:	mov    0x20(%rdi),%r11
   fa40c:	mulx   0x10(%rdi),%rbx,%rbx
   fa412:	shl    $0x5,%rbx
   fa416:	prefetcht0 (%r11,%rbx,1)
   fa41b:	prefetcht0 0x40(%r11,%rbx,1)
   fa421:	imul   %r9,%rdx
   fa425:	vpbroadcastq %rdx,%xmm2
   fa42b:	vpsllvq %xmm0,%xmm2,%xmm2
   fa430:	vpsrld $0x1a,%xmm2,%xmm2
   fa435:	vpmovzxdq %xmm2,%ymm2
   fa43a:	vpsllvq %ymm2,%ymm1,%ymm2
   fa43f:	vmovdqa (%r11,%rbx,1),%ymm3
   fa445:	xor    %edx,%edx
   fa447:	vptest %ymm2,%ymm3
   fa44c:	setb   %dl
   fa44f:	mov    %edx,(%rcx,%r8,4)
   fa453:	mov    0x8(%rax,%r8,8),%rdx
   fa458:	or     $0x1,%rdx
   fa45c:	mov    0x20(%rdi),%r11
   fa460:	mulx   0x10(%rdi),%rbx,%rbx
   fa466:	shl    $0x5,%rbx
   fa46a:	prefetcht0 (%r11,%rbx,1)
   fa46f:	prefetcht0 0x40(%r11,%rbx,1)
   fa475:	imul   %r9,%rdx
   fa479:	vpbroadcastq %rdx,%xmm2
   fa47f:	vpsllvq %xmm0,%xmm2,%xmm2
   fa484:	vpsrld $0x1a,%xmm2,%xmm2
   fa489:	vpmovzxdq %xmm2,%ymm2
   fa48e:	vpsllvq %ymm2,%ymm1,%ymm2
   fa493:	vmovdqa (%r11,%rbx,1),%ymm3
   fa499:	xor    %edx,%edx
   fa49b:	vptest %ymm2,%ymm3
   fa4a0:	setb   %dl
   fa4a3:	mov    %edx,0x4(%rcx,%r8,4)
   fa4a8:	add    $0x2,%r8
   fa4ac:	cmp    %r8,%r10
   fa4af:	jne    fa400 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   fa4b5:	test   $0x1,%sil
   fa4b9:	je     fa518 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
   fa4bb:	mov    (%rax,%r8,8),%rdx
   fa4bf:	or     $0x1,%rdx
   fa4c3:	mov    0x20(%rdi),%rax
   fa4c7:	mulx   0x10(%rdi),%rsi,%rsi
   fa4cd:	shl    $0x5,%rsi
   fa4d1:	prefetcht0 (%rax,%rsi,1)
   fa4d5:	prefetcht0 0x40(%rax,%rsi,1)
   fa4da:	imul   %r9,%rdx
   fa4de:	vpbroadcastq %rdx,%xmm0
   fa4e4:	vpsllvq -0xf588d(%rip),%xmm0,%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa4ed:	vpsrld $0x1a,%xmm0,%xmm0
   fa4f2:	vpmovzxdq %xmm0,%ymm0
   fa4f7:	vpbroadcastq -0xf71a8(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa500:	vpsllvq %ymm0,%ymm1,%ymm0
   fa505:	vmovdqa (%rax,%rsi,1),%ymm1
   fa50a:	xor    %eax,%eax
   fa50c:	vptest %ymm0,%ymm1
   fa511:	setb   %al
   fa514:	mov    %eax,(%rcx,%r8,4)
   fa518:	pop    %rbx
   fa519:	vzeroupper
   fa51c:	ret
   fa51d:	int3
   fa51e:	int3
   fa51f:	int3

