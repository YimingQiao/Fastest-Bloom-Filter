00000000000624f0 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   624f0:	48 85 f6             	test   %rsi,%rsi
   624f3:	0f 84 7a 01 00 00    	je     62673 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   624f9:	53                   	push   %rbx
   624fa:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
   62501:	fe e8 d6
   62504:	48 83 fe 01          	cmp    $0x1,%rsi
   62508:	75 07                	jne    62511 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   6250a:	31 c0                	xor    %eax,%eax
   6250c:	e9 f6 00 00 00       	jmp    62607 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   62511:	49 89 f1             	mov    %rsi,%r9
   62514:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
   62518:	31 c0                	xor    %eax,%eax
   6251a:	c5 f9 6f 05 1e 27 fa 	vmovdqa -0x5d8e2(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62521:	ff
   62522:	c4 e2 79 59 0d c5 0d 	vpbroadcastq -0x5f23b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   62529:	fa ff
   6252b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   62530:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
   62534:	4d 89 d3             	mov    %r10,%r11
   62537:	49 c1 eb 20          	shr    $0x20,%r11
   6253b:	4d 31 d3             	xor    %r10,%r11
   6253e:	4d 0f af d8          	imul   %r8,%r11
   62542:	4d 89 da             	mov    %r11,%r10
   62545:	49 c1 ea 20          	shr    $0x20,%r10
   62549:	4d 31 da             	xor    %r11,%r10
   6254c:	4d 0f af d0          	imul   %r8,%r10
   62550:	4d 89 d3             	mov    %r10,%r11
   62553:	49 c1 eb 20          	shr    $0x20,%r11
   62557:	45 31 da             	xor    %r11d,%r10d
   6255a:	8b 1f                	mov    (%rdi),%ebx
   6255c:	49 0f af db          	imul   %r11,%rbx
   62560:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   62566:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   6256a:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   6256f:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   62573:	48 c1 eb 1c          	shr    $0x1c,%rbx
   62577:	48 83 e3 f0          	and    $0xfffffffffffffff0,%rbx
   6257b:	c4 c1 7a 6f 1c 1a    	vmovdqu (%r10,%rbx,1),%xmm3
   62581:	45 31 d2             	xor    %r10d,%r10d
   62584:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   62589:	41 0f 92 c2          	setb   %r10b
   6258d:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
   62591:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
   62596:	4d 89 d3             	mov    %r10,%r11
   62599:	49 c1 eb 20          	shr    $0x20,%r11
   6259d:	4d 31 d3             	xor    %r10,%r11
   625a0:	4d 0f af d8          	imul   %r8,%r11
   625a4:	4d 89 da             	mov    %r11,%r10
   625a7:	49 c1 ea 20          	shr    $0x20,%r10
   625ab:	4d 31 da             	xor    %r11,%r10
   625ae:	4d 0f af d0          	imul   %r8,%r10
   625b2:	4d 89 d3             	mov    %r10,%r11
   625b5:	49 c1 eb 20          	shr    $0x20,%r11
   625b9:	45 31 da             	xor    %r11d,%r10d
   625bc:	8b 1f                	mov    (%rdi),%ebx
   625be:	49 0f af db          	imul   %r11,%rbx
   625c2:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   625c8:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   625cc:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   625d1:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   625d5:	48 c1 eb 1c          	shr    $0x1c,%rbx
   625d9:	48 83 e3 f0          	and    $0xfffffffffffffff0,%rbx
   625dd:	c4 c1 7a 6f 1c 1a    	vmovdqu (%r10,%rbx,1),%xmm3
   625e3:	45 31 d2             	xor    %r10d,%r10d
   625e6:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   625eb:	41 0f 92 c2          	setb   %r10b
   625ef:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
   625f4:	48 83 c0 02          	add    $0x2,%rax
   625f8:	49 39 c1             	cmp    %rax,%r9
   625fb:	0f 85 2f ff ff ff    	jne    62530 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   62601:	40 f6 c6 01          	test   $0x1,%sil
   62605:	74 6b                	je     62672 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   62607:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   6260b:	48 89 d6             	mov    %rdx,%rsi
   6260e:	48 c1 ee 20          	shr    $0x20,%rsi
   62612:	48 31 d6             	xor    %rdx,%rsi
   62615:	49 0f af f0          	imul   %r8,%rsi
   62619:	48 89 f2             	mov    %rsi,%rdx
   6261c:	48 c1 ea 20          	shr    $0x20,%rdx
   62620:	48 31 f2             	xor    %rsi,%rdx
   62623:	49 0f af d0          	imul   %r8,%rdx
   62627:	48 89 d6             	mov    %rdx,%rsi
   6262a:	48 c1 ee 20          	shr    $0x20,%rsi
   6262e:	31 f2                	xor    %esi,%edx
   62630:	44 8b 07             	mov    (%rdi),%r8d
   62633:	4c 0f af c6          	imul   %rsi,%r8
   62637:	62 f2 7d 08 7c c2    	vpbroadcastd %edx,%xmm0
   6263d:	c5 f9 e5 05 fb 25 fa 	vpmulhw -0x5da05(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62644:	ff
   62645:	c4 e2 79 59 0d a2 0c 	vpbroadcastq -0x5f35e(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6264c:	fa ff
   6264e:	c4 e2 71 00 c0       	vpshufb %xmm0,%xmm1,%xmm0
   62653:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   62657:	49 c1 e8 1c          	shr    $0x1c,%r8
   6265b:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
   6265f:	c4 a1 7a 6f 0c 02    	vmovdqu (%rdx,%r8,1),%xmm1
   62665:	31 d2                	xor    %edx,%edx
   62667:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   6266c:	0f 92 c2             	setb   %dl
   6266f:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   62672:	5b                   	pop    %rbx
   62673:	c3                   	ret
   62674:	cc                   	int3
   62675:	cc                   	int3
   62676:	cc                   	int3
   62677:	cc                   	int3
   62678:	cc                   	int3
   62679:	cc                   	int3
   6267a:	cc                   	int3
   6267b:	cc                   	int3
   6267c:	cc                   	int3
   6267d:	cc                   	int3
   6267e:	cc                   	int3
   6267f:	cc                   	int3
