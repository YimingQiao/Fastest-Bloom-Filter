0000000000176640 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  176640:	test   %rsi,%rsi
  176643:	je     1767e0 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  176649:	push   %rbx
  17664a:	movabs $0xd6e8feb86659fd93,%r8
  176654:	cmp    $0x1,%rsi
  176658:	jne    176661 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  17665a:	xor    %eax,%eax
  17665c:	jmp    17676f <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x12f>
  176661:	mov    %rsi,%r9
  176664:	and    $0xfffffffffffffffe,%r9
  176668:	xor    %eax,%eax
  17666a:	vmovdqa -0x171d52(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  176672:	vpbroadcastq -0x173324(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  17667c:	nopl   0x0(%rax)
  176680:	mov    (%rdx,%rax,8),%r10
  176684:	mov    %r10,%r11
  176687:	shr    $0x20,%r11
  17668b:	xor    %r10,%r11
  17668e:	imul   %r8,%r11
  176692:	mov    %r11,%r10
  176695:	shr    $0x20,%r10
  176699:	xor    %r11,%r10
  17669c:	imul   %r8,%r10
  1766a0:	mov    %r10,%r11
  1766a3:	shr    $0x20,%r11
  1766a7:	xor    %r11d,%r10d
  1766aa:	and    0x18(%rdi),%r11d
  1766ae:	mov    (%rdi),%rbx
  1766b1:	shl    $0x6,%r11
  1766b5:	vmovdqa64 (%rbx,%r11,1),%zmm2
  1766bc:	vpbroadcastd %r10d,%ymm3
  1766c2:	vpmulld %ymm0,%ymm3,%ymm3
  1766c7:	vpsrld $0x1a,%ymm3,%ymm3
  1766cc:	vpmovzxdq %ymm3,%zmm3
  1766d2:	vpsrlvq %zmm3,%zmm2,%zmm2
  1766d8:	vptestnmq %zmm1,%zmm2,%k0
  1766de:	xor    %r10d,%r10d
  1766e1:	kortestb %k0,%k0
  1766e5:	sete   %r10b
  1766e9:	mov    %r10d,(%rcx,%rax,4)
  1766ed:	mov    0x8(%rdx,%rax,8),%r10
  1766f2:	mov    %r10,%r11
  1766f5:	shr    $0x20,%r11
  1766f9:	xor    %r10,%r11
  1766fc:	imul   %r8,%r11
  176700:	mov    %r11,%r10
  176703:	shr    $0x20,%r10
  176707:	xor    %r11,%r10
  17670a:	imul   %r8,%r10
  17670e:	mov    %r10,%r11
  176711:	shr    $0x20,%r11
  176715:	xor    %r11d,%r10d
  176718:	and    0x18(%rdi),%r11d
  17671c:	mov    (%rdi),%rbx
  17671f:	shl    $0x6,%r11
  176723:	vmovdqa64 (%rbx,%r11,1),%zmm2
  17672a:	vpbroadcastd %r10d,%ymm3
  176730:	vpmulld %ymm0,%ymm3,%ymm3
  176735:	vpsrld $0x1a,%ymm3,%ymm3
  17673a:	vpmovzxdq %ymm3,%zmm3
  176740:	vpsrlvq %zmm3,%zmm2,%zmm2
  176746:	vptestnmq %zmm1,%zmm2,%k0
  17674c:	xor    %r10d,%r10d
  17674f:	kortestb %k0,%k0
  176753:	sete   %r10b
  176757:	mov    %r10d,0x4(%rcx,%rax,4)
  17675c:	add    $0x2,%rax
  176760:	cmp    %rax,%r9
  176763:	jne    176680 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  176769:	test   $0x1,%sil
  17676d:	je     1767df <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x19f>
  17676f:	mov    (%rdx,%rax,8),%rdx
  176773:	mov    %rdx,%rsi
  176776:	shr    $0x20,%rsi
  17677a:	xor    %rdx,%rsi
  17677d:	imul   %r8,%rsi
  176781:	mov    %rsi,%rdx
  176784:	shr    $0x20,%rdx
  176788:	xor    %rsi,%rdx
  17678b:	imul   %r8,%rdx
  17678f:	mov    %rdx,%rsi
  176792:	shr    $0x20,%rsi
  176796:	xor    %esi,%edx
  176798:	and    0x18(%rdi),%esi
  17679b:	mov    (%rdi),%rdi
  17679e:	shl    $0x6,%rsi
  1767a2:	vpbroadcastd %edx,%ymm0
  1767a8:	vpmulld -0x171e91(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  1767b1:	vmovdqa64 (%rdi,%rsi,1),%zmm1
  1767b8:	vpsrld $0x1a,%ymm0,%ymm0
  1767bd:	vpmovzxdq %ymm0,%zmm0
  1767c3:	vpsrlvq %zmm0,%zmm1,%zmm0
  1767c9:	vptestnmq -0x17347b(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  1767d3:	xor    %edx,%edx
  1767d5:	kortestb %k0,%k0
  1767d9:	sete   %dl
  1767dc:	mov    %edx,(%rcx,%rax,4)
  1767df:	pop    %rbx
  1767e0:	vzeroupper
  1767e3:	ret
  1767e4:	int3
  1767e5:	int3
  1767e6:	int3
  1767e7:	int3
  1767e8:	int3
  1767e9:	int3
  1767ea:	int3
  1767eb:	int3
  1767ec:	int3
  1767ed:	int3
  1767ee:	int3
  1767ef:	int3

