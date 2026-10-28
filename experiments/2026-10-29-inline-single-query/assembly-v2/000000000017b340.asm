000000000017b340 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17b340:	test   %rsi,%rsi
  17b343:	je     17b4ab <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16b>
  17b349:	push   %rbx
  17b34a:	movabs $0xd6e8feb86659fd93,%r8
  17b354:	cmp    $0x1,%rsi
  17b358:	jne    17b361 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  17b35a:	xor    %eax,%eax
  17b35c:	jmp    17b449 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x109>
  17b361:	mov    %rsi,%r9
  17b364:	and    $0xfffffffffffffffe,%r9
  17b368:	xor    %eax,%eax
  17b36a:	vmovdqa -0x176732(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17b372:	vpbroadcastq -0x17808b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17b37b:	nopl   0x0(%rax,%rax,1)
  17b380:	mov    (%rdx,%rax,8),%r10
  17b384:	mov    %r10,%r11
  17b387:	shr    $0x20,%r11
  17b38b:	xor    %r10,%r11
  17b38e:	imul   %r8,%r11
  17b392:	mov    %r11,%r10
  17b395:	shr    $0x20,%r10
  17b399:	xor    %r11,%r10
  17b39c:	imul   %r8,%r10
  17b3a0:	mov    %r10,%r11
  17b3a3:	shr    $0x20,%r11
  17b3a7:	xor    %r11d,%r10d
  17b3aa:	and    0x18(%rdi),%r11d
  17b3ae:	mov    (%rdi),%rbx
  17b3b1:	shl    $0x4,%r11
  17b3b5:	vmovdqa (%rbx,%r11,1),%xmm2
  17b3bb:	vpbroadcastd %r10d,%xmm3
  17b3c1:	vpmulhw %xmm0,%xmm3,%xmm3
  17b3c5:	vpshufb %xmm3,%xmm1,%xmm3
  17b3ca:	xor    %r10d,%r10d
  17b3cd:	vptest %xmm3,%xmm2
  17b3d2:	setb   %r10b
  17b3d6:	mov    %r10d,(%rcx,%rax,4)
  17b3da:	mov    0x8(%rdx,%rax,8),%r10
  17b3df:	mov    %r10,%r11
  17b3e2:	shr    $0x20,%r11
  17b3e6:	xor    %r10,%r11
  17b3e9:	imul   %r8,%r11
  17b3ed:	mov    %r11,%r10
  17b3f0:	shr    $0x20,%r10
  17b3f4:	xor    %r11,%r10
  17b3f7:	imul   %r8,%r10
  17b3fb:	mov    %r10,%r11
  17b3fe:	shr    $0x20,%r11
  17b402:	xor    %r11d,%r10d
  17b405:	and    0x18(%rdi),%r11d
  17b409:	mov    (%rdi),%rbx
  17b40c:	shl    $0x4,%r11
  17b410:	vmovdqa (%rbx,%r11,1),%xmm2
  17b416:	vpbroadcastd %r10d,%xmm3
  17b41c:	vpmulhw %xmm0,%xmm3,%xmm3
  17b420:	vpshufb %xmm3,%xmm1,%xmm3
  17b425:	xor    %r10d,%r10d
  17b428:	vptest %xmm3,%xmm2
  17b42d:	setb   %r10b
  17b431:	mov    %r10d,0x4(%rcx,%rax,4)
  17b436:	add    $0x2,%rax
  17b43a:	cmp    %rax,%r9
  17b43d:	jne    17b380 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17b443:	test   $0x1,%sil
  17b447:	je     17b4aa <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16a>
  17b449:	mov    (%rdx,%rax,8),%rdx
  17b44d:	mov    %rdx,%rsi
  17b450:	shr    $0x20,%rsi
  17b454:	xor    %rdx,%rsi
  17b457:	imul   %r8,%rsi
  17b45b:	mov    %rsi,%rdx
  17b45e:	shr    $0x20,%rdx
  17b462:	xor    %rsi,%rdx
  17b465:	imul   %r8,%rdx
  17b469:	mov    %rdx,%rsi
  17b46c:	shr    $0x20,%rsi
  17b470:	xor    %esi,%edx
  17b472:	and    0x18(%rdi),%esi
  17b475:	mov    (%rdi),%rdi
  17b478:	shl    $0x4,%rsi
  17b47c:	vmovdqa (%rdi,%rsi,1),%xmm0
  17b481:	vpbroadcastd %edx,%xmm1
  17b487:	vpmulhw -0x17684f(%rip),%xmm1,%xmm1        # 4c40 <typeinfo name for main::$_60+0x470>
  17b48f:	vpbroadcastq -0x1781a8(%rip),%xmm2        # 32f0 <_IO_stdin_used+0x3c>
  17b498:	vpshufb %xmm1,%xmm2,%xmm1
  17b49d:	xor    %edx,%edx
  17b49f:	vptest %xmm1,%xmm0
  17b4a4:	setb   %dl
  17b4a7:	mov    %edx,(%rcx,%rax,4)
  17b4aa:	pop    %rbx
  17b4ab:	ret
  17b4ac:	int3
  17b4ad:	int3
  17b4ae:	int3
  17b4af:	int3

