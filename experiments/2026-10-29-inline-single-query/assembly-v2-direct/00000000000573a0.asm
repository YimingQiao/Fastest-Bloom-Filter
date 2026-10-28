00000000000573a0 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)>:
   573a0:	test   %rsi,%rsi
   573a3:	je     575a3 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x203>
   573a9:	push   %rbx
   573aa:	movabs $0xd6e8feb86659fd93,%r8
   573b4:	cmp    $0x1,%rsi
   573b8:	jne    573c1 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   573ba:	xor    %eax,%eax
   573bc:	jmp    57509 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x169>
   573c1:	mov    %rsi,%r9
   573c4:	and    $0xfffffffffffffffe,%r9
   573c8:	xor    %eax,%eax
   573ca:	vmovdqa -0x52ab2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   573d2:	vpxor  %xmm1,%xmm1,%xmm1
   573d6:	vpbroadcastq -0x54087(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
   573df:	nop
   573e0:	mov    (%rdx,%rax,8),%r10
   573e4:	mov    %r10,%r11
   573e7:	shr    $0x20,%r11
   573eb:	xor    %r10,%r11
   573ee:	imul   %r8,%r11
   573f2:	mov    %r11,%r10
   573f5:	shr    $0x20,%r10
   573f9:	xor    %r11,%r10
   573fc:	imul   %r8,%r10
   57400:	mov    %r10,%r11
   57403:	shr    $0x20,%r11
   57407:	xor    %r11d,%r10d
   5740a:	mov    (%rdi),%ebx
   5740c:	imul   %r11,%rbx
   57410:	vpbroadcastd %r10d,%ymm3
   57416:	vpmulld %ymm0,%ymm3,%ymm3
   5741b:	vpsrld $0x1a,%ymm3,%ymm3
   57420:	vpunpckhdq %ymm1,%ymm3,%ymm4
   57424:	vpsllvq %ymm4,%ymm2,%ymm4
   57429:	vpunpckldq %ymm1,%ymm3,%ymm3
   5742d:	vpsllvq %ymm3,%ymm2,%ymm3
   57432:	mov    0x8(%rdi),%r10
   57436:	shr    $0x1a,%rbx
   5743a:	and    $0xffffffffffffffc0,%rbx
   5743e:	vmovdqa (%r10,%rbx,1),%ymm5
   57444:	vmovdqa 0x20(%r10,%rbx,1),%ymm6
   5744b:	vptest %ymm4,%ymm5
   57450:	setb   %r10b
   57454:	vptest %ymm3,%ymm6
   57459:	setb   %r11b
   5745d:	xor    %ebx,%ebx
   5745f:	test   %r10b,%r11b
   57462:	setne  %bl
   57465:	mov    %ebx,(%rcx,%rax,4)
   57468:	mov    0x8(%rdx,%rax,8),%r10
   5746d:	mov    %r10,%r11
   57470:	shr    $0x20,%r11
   57474:	xor    %r10,%r11
   57477:	imul   %r8,%r11
   5747b:	mov    %r11,%r10
   5747e:	shr    $0x20,%r10
   57482:	xor    %r11,%r10
   57485:	imul   %r8,%r10
   57489:	mov    %r10,%r11
   5748c:	shr    $0x20,%r11
   57490:	xor    %r11d,%r10d
   57493:	mov    (%rdi),%ebx
   57495:	imul   %r11,%rbx
   57499:	vpbroadcastd %r10d,%ymm3
   5749f:	vpmulld %ymm0,%ymm3,%ymm3
   574a4:	vpsrld $0x1a,%ymm3,%ymm3
   574a9:	vpunpckhdq %ymm1,%ymm3,%ymm4
   574ad:	vpsllvq %ymm4,%ymm2,%ymm4
   574b2:	vpunpckldq %ymm1,%ymm3,%ymm3
   574b6:	vpsllvq %ymm3,%ymm2,%ymm3
   574bb:	mov    0x8(%rdi),%r10
   574bf:	shr    $0x1a,%rbx
   574c3:	and    $0xffffffffffffffc0,%rbx
   574c7:	vmovdqa (%r10,%rbx,1),%ymm5
   574cd:	vmovdqa 0x20(%r10,%rbx,1),%ymm6
   574d4:	vptest %ymm4,%ymm5
   574d9:	setb   %r10b
   574dd:	vptest %ymm3,%ymm6
   574e2:	setb   %r11b
   574e6:	xor    %ebx,%ebx
   574e8:	test   %r10b,%r11b
   574eb:	setne  %bl
   574ee:	mov    %ebx,0x4(%rcx,%rax,4)
   574f2:	add    $0x2,%rax
   574f6:	cmp    %rax,%r9
   574f9:	jne    573e0 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   574ff:	test   $0x1,%sil
   57503:	je     575a2 <void inline_single_kernel<true, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x202>
   57509:	mov    (%rdx,%rax,8),%rdx
   5750d:	mov    %rdx,%rsi
   57510:	shr    $0x20,%rsi
   57514:	xor    %rdx,%rsi
   57517:	imul   %r8,%rsi
   5751b:	mov    %rsi,%rdx
   5751e:	shr    $0x20,%rdx
   57522:	xor    %rsi,%rdx
   57525:	imul   %r8,%rdx
   57529:	mov    %rdx,%rsi
   5752c:	shr    $0x20,%rsi
   57530:	xor    %esi,%edx
   57532:	mov    (%rdi),%r8d
   57535:	imul   %rsi,%r8
   57539:	vpbroadcastd %edx,%ymm0
   5753f:	vpmulld -0x52c28(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   57548:	vpsrld $0x1a,%ymm0,%ymm0
   5754d:	vpxor  %xmm1,%xmm1,%xmm1
   57551:	vpunpckhdq %ymm1,%ymm0,%ymm2
   57555:	vpbroadcastq -0x54206(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
   5755e:	vpsllvq %ymm2,%ymm3,%ymm2
   57563:	vpunpckldq %ymm1,%ymm0,%ymm0
   57567:	vpsllvq %ymm0,%ymm3,%ymm0
   5756c:	mov    0x8(%rdi),%rdx
   57570:	shr    $0x1a,%r8
   57574:	and    $0xffffffffffffffc0,%r8
   57578:	vmovdqa (%rdx,%r8,1),%ymm1
   5757e:	vmovdqa 0x20(%rdx,%r8,1),%ymm3
   57585:	vptest %ymm2,%ymm1
   5758a:	setb   %dl
   5758d:	vptest %ymm0,%ymm3
   57592:	setb   %sil
   57596:	xor    %edi,%edi
   57598:	test   %dl,%sil
   5759b:	setne  %dil
   5759f:	mov    %edi,(%rcx,%rax,4)
   575a2:	pop    %rbx
   575a3:	vzeroupper
   575a6:	ret
   575a7:	int3
   575a8:	int3
   575a9:	int3
   575aa:	int3
   575ab:	int3
   575ac:	int3
   575ad:	int3
   575ae:	int3
   575af:	int3

