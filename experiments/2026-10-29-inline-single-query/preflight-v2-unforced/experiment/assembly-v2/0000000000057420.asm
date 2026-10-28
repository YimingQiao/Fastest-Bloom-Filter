0000000000057420 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)>:
   57420:	test   %rsi,%rsi
   57423:	je     57623 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x203>
   57429:	push   %rbx
   5742a:	movabs $0xd6e8feb86659fd93,%r8
   57434:	cmp    $0x1,%rsi
   57438:	jne    57441 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   5743a:	xor    %eax,%eax
   5743c:	jmp    57589 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x169>
   57441:	mov    %rsi,%r9
   57444:	and    $0xfffffffffffffffe,%r9
   57448:	xor    %eax,%eax
   5744a:	vmovdqa -0x52b32(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   57452:	vpxor  %xmm1,%xmm1,%xmm1
   57456:	vpbroadcastq -0x54107(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
   5745f:	nop
   57460:	mov    (%rdx,%rax,8),%r10
   57464:	mov    %r10,%r11
   57467:	shr    $0x20,%r11
   5746b:	xor    %r10,%r11
   5746e:	imul   %r8,%r11
   57472:	mov    %r11,%r10
   57475:	shr    $0x20,%r10
   57479:	xor    %r11,%r10
   5747c:	imul   %r8,%r10
   57480:	mov    %r10,%r11
   57483:	shr    $0x20,%r11
   57487:	xor    %r11d,%r10d
   5748a:	mov    (%rdi),%ebx
   5748c:	imul   %r11,%rbx
   57490:	vpbroadcastd %r10d,%ymm3
   57496:	vpmulld %ymm0,%ymm3,%ymm3
   5749b:	vpsrld $0x1a,%ymm3,%ymm3
   574a0:	vpunpckhdq %ymm1,%ymm3,%ymm4
   574a4:	vpsllvq %ymm4,%ymm2,%ymm4
   574a9:	vpunpckldq %ymm1,%ymm3,%ymm3
   574ad:	vpsllvq %ymm3,%ymm2,%ymm3
   574b2:	mov    0x8(%rdi),%r10
   574b6:	shr    $0x1a,%rbx
   574ba:	and    $0xffffffffffffffc0,%rbx
   574be:	vmovdqa (%r10,%rbx,1),%ymm5
   574c4:	vmovdqa 0x20(%r10,%rbx,1),%ymm6
   574cb:	vptest %ymm4,%ymm5
   574d0:	setb   %r10b
   574d4:	vptest %ymm3,%ymm6
   574d9:	setb   %r11b
   574dd:	xor    %ebx,%ebx
   574df:	test   %r10b,%r11b
   574e2:	setne  %bl
   574e5:	mov    %ebx,(%rcx,%rax,4)
   574e8:	mov    0x8(%rdx,%rax,8),%r10
   574ed:	mov    %r10,%r11
   574f0:	shr    $0x20,%r11
   574f4:	xor    %r10,%r11
   574f7:	imul   %r8,%r11
   574fb:	mov    %r11,%r10
   574fe:	shr    $0x20,%r10
   57502:	xor    %r11,%r10
   57505:	imul   %r8,%r10
   57509:	mov    %r10,%r11
   5750c:	shr    $0x20,%r11
   57510:	xor    %r11d,%r10d
   57513:	mov    (%rdi),%ebx
   57515:	imul   %r11,%rbx
   57519:	vpbroadcastd %r10d,%ymm3
   5751f:	vpmulld %ymm0,%ymm3,%ymm3
   57524:	vpsrld $0x1a,%ymm3,%ymm3
   57529:	vpunpckhdq %ymm1,%ymm3,%ymm4
   5752d:	vpsllvq %ymm4,%ymm2,%ymm4
   57532:	vpunpckldq %ymm1,%ymm3,%ymm3
   57536:	vpsllvq %ymm3,%ymm2,%ymm3
   5753b:	mov    0x8(%rdi),%r10
   5753f:	shr    $0x1a,%rbx
   57543:	and    $0xffffffffffffffc0,%rbx
   57547:	vmovdqa (%r10,%rbx,1),%ymm5
   5754d:	vmovdqa 0x20(%r10,%rbx,1),%ymm6
   57554:	vptest %ymm4,%ymm5
   57559:	setb   %r10b
   5755d:	vptest %ymm3,%ymm6
   57562:	setb   %r11b
   57566:	xor    %ebx,%ebx
   57568:	test   %r10b,%r11b
   5756b:	setne  %bl
   5756e:	mov    %ebx,0x4(%rcx,%rax,4)
   57572:	add    $0x2,%rax
   57576:	cmp    %rax,%r9
   57579:	jne    57460 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   5757f:	test   $0x1,%sil
   57583:	je     57622 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x202>
   57589:	mov    (%rdx,%rax,8),%rdx
   5758d:	mov    %rdx,%rsi
   57590:	shr    $0x20,%rsi
   57594:	xor    %rdx,%rsi
   57597:	imul   %r8,%rsi
   5759b:	mov    %rsi,%rdx
   5759e:	shr    $0x20,%rdx
   575a2:	xor    %rsi,%rdx
   575a5:	imul   %r8,%rdx
   575a9:	mov    %rdx,%rsi
   575ac:	shr    $0x20,%rsi
   575b0:	xor    %esi,%edx
   575b2:	mov    (%rdi),%r8d
   575b5:	imul   %rsi,%r8
   575b9:	vpbroadcastd %edx,%ymm0
   575bf:	vpmulld -0x52ca8(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   575c8:	vpsrld $0x1a,%ymm0,%ymm0
   575cd:	vpxor  %xmm1,%xmm1,%xmm1
   575d1:	vpunpckhdq %ymm1,%ymm0,%ymm2
   575d5:	vpbroadcastq -0x54286(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
   575de:	vpsllvq %ymm2,%ymm3,%ymm2
   575e3:	vpunpckldq %ymm1,%ymm0,%ymm0
   575e7:	vpsllvq %ymm0,%ymm3,%ymm0
   575ec:	mov    0x8(%rdi),%rdx
   575f0:	shr    $0x1a,%r8
   575f4:	and    $0xffffffffffffffc0,%r8
   575f8:	vmovdqa (%rdx,%r8,1),%ymm1
   575fe:	vmovdqa 0x20(%rdx,%r8,1),%ymm3
   57605:	vptest %ymm2,%ymm1
   5760a:	setb   %dl
   5760d:	vptest %ymm0,%ymm3
   57612:	setb   %sil
   57616:	xor    %edi,%edi
   57618:	test   %dl,%sil
   5761b:	setne  %dil
   5761f:	mov    %edi,(%rcx,%rax,4)
   57622:	pop    %rbx
   57623:	vzeroupper
   57626:	ret
   57627:	int3
   57628:	int3
   57629:	int3
   5762a:	int3
   5762b:	int3
   5762c:	int3
   5762d:	int3
   5762e:	int3
   5762f:	int3

