0000000000062490 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   62490:	test   %rsi,%rsi
   62493:	je     62613 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   62499:	push   %rbx
   6249a:	movabs $0xd6e8feb86659fd93,%r8
   624a4:	cmp    $0x1,%rsi
   624a8:	jne    624b1 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   624aa:	xor    %eax,%eax
   624ac:	jmp    625a7 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   624b1:	mov    %rsi,%r9
   624b4:	and    $0xfffffffffffffffe,%r9
   624b8:	xor    %eax,%eax
   624ba:	vmovdqa -0x5d882(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   624c2:	vpbroadcastq -0x5f1db(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   624cb:	nopl   0x0(%rax,%rax,1)
   624d0:	mov    (%rdx,%rax,8),%r10
   624d4:	mov    %r10,%r11
   624d7:	shr    $0x20,%r11
   624db:	xor    %r10,%r11
   624de:	imul   %r8,%r11
   624e2:	mov    %r11,%r10
   624e5:	shr    $0x20,%r10
   624e9:	xor    %r11,%r10
   624ec:	imul   %r8,%r10
   624f0:	mov    %r10,%r11
   624f3:	shr    $0x20,%r11
   624f7:	xor    %r11d,%r10d
   624fa:	mov    (%rdi),%ebx
   624fc:	imul   %r11,%rbx
   62500:	vpbroadcastd %r10d,%xmm2
   62506:	vpmulhw %xmm0,%xmm2,%xmm2
   6250a:	vpshufb %xmm2,%xmm1,%xmm2
   6250f:	mov    0x8(%rdi),%r10
   62513:	shr    $0x1c,%rbx
   62517:	and    $0xfffffffffffffff0,%rbx
   6251b:	vmovdqu (%r10,%rbx,1),%xmm3
   62521:	xor    %r10d,%r10d
   62524:	vptest %xmm2,%xmm3
   62529:	setb   %r10b
   6252d:	mov    %r10d,(%rcx,%rax,4)
   62531:	mov    0x8(%rdx,%rax,8),%r10
   62536:	mov    %r10,%r11
   62539:	shr    $0x20,%r11
   6253d:	xor    %r10,%r11
   62540:	imul   %r8,%r11
   62544:	mov    %r11,%r10
   62547:	shr    $0x20,%r10
   6254b:	xor    %r11,%r10
   6254e:	imul   %r8,%r10
   62552:	mov    %r10,%r11
   62555:	shr    $0x20,%r11
   62559:	xor    %r11d,%r10d
   6255c:	mov    (%rdi),%ebx
   6255e:	imul   %r11,%rbx
   62562:	vpbroadcastd %r10d,%xmm2
   62568:	vpmulhw %xmm0,%xmm2,%xmm2
   6256c:	vpshufb %xmm2,%xmm1,%xmm2
   62571:	mov    0x8(%rdi),%r10
   62575:	shr    $0x1c,%rbx
   62579:	and    $0xfffffffffffffff0,%rbx
   6257d:	vmovdqu (%r10,%rbx,1),%xmm3
   62583:	xor    %r10d,%r10d
   62586:	vptest %xmm2,%xmm3
   6258b:	setb   %r10b
   6258f:	mov    %r10d,0x4(%rcx,%rax,4)
   62594:	add    $0x2,%rax
   62598:	cmp    %rax,%r9
   6259b:	jne    624d0 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   625a1:	test   $0x1,%sil
   625a5:	je     62612 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   625a7:	mov    (%rdx,%rax,8),%rdx
   625ab:	mov    %rdx,%rsi
   625ae:	shr    $0x20,%rsi
   625b2:	xor    %rdx,%rsi
   625b5:	imul   %r8,%rsi
   625b9:	mov    %rsi,%rdx
   625bc:	shr    $0x20,%rdx
   625c0:	xor    %rsi,%rdx
   625c3:	imul   %r8,%rdx
   625c7:	mov    %rdx,%rsi
   625ca:	shr    $0x20,%rsi
   625ce:	xor    %esi,%edx
   625d0:	mov    (%rdi),%r8d
   625d3:	imul   %rsi,%r8
   625d7:	vpbroadcastd %edx,%xmm0
   625dd:	vpmulhw -0x5d9a5(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   625e5:	vpbroadcastq -0x5f2fe(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   625ee:	vpshufb %xmm0,%xmm1,%xmm0
   625f3:	mov    0x8(%rdi),%rdx
   625f7:	shr    $0x1c,%r8
   625fb:	and    $0xfffffffffffffff0,%r8
   625ff:	vmovdqu (%rdx,%r8,1),%xmm1
   62605:	xor    %edx,%edx
   62607:	vptest %xmm0,%xmm1
   6260c:	setb   %dl
   6260f:	mov    %edx,(%rcx,%rax,4)
   62612:	pop    %rbx
   62613:	ret
   62614:	int3
   62615:	int3
   62616:	int3
   62617:	int3
   62618:	int3
   62619:	int3
   6261a:	int3
   6261b:	int3
   6261c:	int3
   6261d:	int3
   6261e:	int3
   6261f:	int3

