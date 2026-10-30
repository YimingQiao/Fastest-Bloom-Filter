0000000000062510 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)>:
   62510:	test   %rsi,%rsi
   62513:	je     62693 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   62519:	push   %rbx
   6251a:	movabs $0xd6e8feb86659fd93,%r8
   62524:	cmp    $0x1,%rsi
   62528:	jne    62531 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   6252a:	xor    %eax,%eax
   6252c:	jmp    62627 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   62531:	mov    %rsi,%r9
   62534:	and    $0xfffffffffffffffe,%r9
   62538:	xor    %eax,%eax
   6253a:	vmovdqa -0x5d902(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62542:	vpbroadcastq -0x5f25b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6254b:	nopl   0x0(%rax,%rax,1)
   62550:	mov    (%rdx,%rax,8),%r10
   62554:	mov    %r10,%r11
   62557:	shr    $0x20,%r11
   6255b:	xor    %r10,%r11
   6255e:	imul   %r8,%r11
   62562:	mov    %r11,%r10
   62565:	shr    $0x20,%r10
   62569:	xor    %r11,%r10
   6256c:	imul   %r8,%r10
   62570:	mov    %r10,%r11
   62573:	shr    $0x20,%r11
   62577:	xor    %r11d,%r10d
   6257a:	mov    (%rdi),%ebx
   6257c:	imul   %r11,%rbx
   62580:	vpbroadcastd %r10d,%xmm2
   62586:	vpmulhw %xmm0,%xmm2,%xmm2
   6258a:	vpshufb %xmm2,%xmm1,%xmm2
   6258f:	mov    0x8(%rdi),%r10
   62593:	shr    $0x1c,%rbx
   62597:	and    $0xfffffffffffffff0,%rbx
   6259b:	vmovdqu (%r10,%rbx,1),%xmm3
   625a1:	xor    %r10d,%r10d
   625a4:	vptest %xmm2,%xmm3
   625a9:	setb   %r10b
   625ad:	mov    %r10d,(%rcx,%rax,4)
   625b1:	mov    0x8(%rdx,%rax,8),%r10
   625b6:	mov    %r10,%r11
   625b9:	shr    $0x20,%r11
   625bd:	xor    %r10,%r11
   625c0:	imul   %r8,%r11
   625c4:	mov    %r11,%r10
   625c7:	shr    $0x20,%r10
   625cb:	xor    %r11,%r10
   625ce:	imul   %r8,%r10
   625d2:	mov    %r10,%r11
   625d5:	shr    $0x20,%r11
   625d9:	xor    %r11d,%r10d
   625dc:	mov    (%rdi),%ebx
   625de:	imul   %r11,%rbx
   625e2:	vpbroadcastd %r10d,%xmm2
   625e8:	vpmulhw %xmm0,%xmm2,%xmm2
   625ec:	vpshufb %xmm2,%xmm1,%xmm2
   625f1:	mov    0x8(%rdi),%r10
   625f5:	shr    $0x1c,%rbx
   625f9:	and    $0xfffffffffffffff0,%rbx
   625fd:	vmovdqu (%r10,%rbx,1),%xmm3
   62603:	xor    %r10d,%r10d
   62606:	vptest %xmm2,%xmm3
   6260b:	setb   %r10b
   6260f:	mov    %r10d,0x4(%rcx,%rax,4)
   62614:	add    $0x2,%rax
   62618:	cmp    %rax,%r9
   6261b:	jne    62550 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   62621:	test   $0x1,%sil
   62625:	je     62692 <void inline_single_kernel<true, external_bloom::SingleShortcutV1<external_bloom::Fixed16>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::Fixed16> const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   62627:	mov    (%rdx,%rax,8),%rdx
   6262b:	mov    %rdx,%rsi
   6262e:	shr    $0x20,%rsi
   62632:	xor    %rdx,%rsi
   62635:	imul   %r8,%rsi
   62639:	mov    %rsi,%rdx
   6263c:	shr    $0x20,%rdx
   62640:	xor    %rsi,%rdx
   62643:	imul   %r8,%rdx
   62647:	mov    %rdx,%rsi
   6264a:	shr    $0x20,%rsi
   6264e:	xor    %esi,%edx
   62650:	mov    (%rdi),%r8d
   62653:	imul   %rsi,%r8
   62657:	vpbroadcastd %edx,%xmm0
   6265d:	vpmulhw -0x5da25(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   62665:	vpbroadcastq -0x5f37e(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   6266e:	vpshufb %xmm0,%xmm1,%xmm0
   62673:	mov    0x8(%rdi),%rdx
   62677:	shr    $0x1c,%r8
   6267b:	and    $0xfffffffffffffff0,%r8
   6267f:	vmovdqu (%rdx,%r8,1),%xmm1
   62685:	xor    %edx,%edx
   62687:	vptest %xmm0,%xmm1
   6268c:	setb   %dl
   6268f:	mov    %edx,(%rcx,%rax,4)
   62692:	pop    %rbx
   62693:	ret
   62694:	int3
   62695:	int3
   62696:	int3
   62697:	int3
   62698:	int3
   62699:	int3
   6269a:	int3
   6269b:	int3
   6269c:	int3
   6269d:	int3
   6269e:	int3
   6269f:	int3

