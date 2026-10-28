0000000000175640 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  175640:	48 85 f6             	test   %rsi,%rsi
  175643:	0f 84 97 01 00 00    	je     1757e0 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  175649:	53                   	push   %rbx
  17564a:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
  175651:	fe e8 d6
  175654:	48 83 fe 01          	cmp    $0x1,%rsi
  175658:	75 07                	jne    175661 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  17565a:	31 c0                	xor    %eax,%eax
  17565c:	e9 0e 01 00 00       	jmp    17576f <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x12f>
  175661:	49 89 f1             	mov    %rsi,%r9
  175664:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
  175668:	31 c0                	xor    %eax,%eax
  17566a:	c5 fd 6f 05 ae f2 e8 	vmovdqa -0x170d52(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175671:	ff
  175672:	62 f2 fd 48 59 0d dc 	vpbroadcastq -0x172324(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  175679:	dc e8 ff
  17567c:	0f 1f 40 00          	nopl   0x0(%rax)
  175680:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
  175684:	4d 89 d3             	mov    %r10,%r11
  175687:	49 c1 eb 20          	shr    $0x20,%r11
  17568b:	4d 31 d3             	xor    %r10,%r11
  17568e:	4d 0f af d8          	imul   %r8,%r11
  175692:	4d 89 da             	mov    %r11,%r10
  175695:	49 c1 ea 20          	shr    $0x20,%r10
  175699:	4d 31 da             	xor    %r11,%r10
  17569c:	4d 0f af d0          	imul   %r8,%r10
  1756a0:	4d 89 d3             	mov    %r10,%r11
  1756a3:	49 c1 eb 20          	shr    $0x20,%r11
  1756a7:	45 31 da             	xor    %r11d,%r10d
  1756aa:	44 23 5f 18          	and    0x18(%rdi),%r11d
  1756ae:	48 8b 1f             	mov    (%rdi),%rbx
  1756b1:	49 c1 e3 06          	shl    $0x6,%r11
  1756b5:	62 b1 fd 48 6f 14 1b 	vmovdqa64 (%rbx,%r11,1),%zmm2
  1756bc:	62 d2 7d 28 7c da    	vpbroadcastd %r10d,%ymm3
  1756c2:	c4 e2 65 40 d8       	vpmulld %ymm0,%ymm3,%ymm3
  1756c7:	c5 e5 72 d3 1a       	vpsrld $0x1a,%ymm3,%ymm3
  1756cc:	62 f2 7d 48 35 db    	vpmovzxdq %ymm3,%zmm3
  1756d2:	62 f2 ed 48 45 d3    	vpsrlvq %zmm3,%zmm2,%zmm2
  1756d8:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
  1756de:	45 31 d2             	xor    %r10d,%r10d
  1756e1:	c5 f9 98 c0          	kortestb %k0,%k0
  1756e5:	41 0f 94 c2          	sete   %r10b
  1756e9:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  1756ed:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
  1756f2:	4d 89 d3             	mov    %r10,%r11
  1756f5:	49 c1 eb 20          	shr    $0x20,%r11
  1756f9:	4d 31 d3             	xor    %r10,%r11
  1756fc:	4d 0f af d8          	imul   %r8,%r11
  175700:	4d 89 da             	mov    %r11,%r10
  175703:	49 c1 ea 20          	shr    $0x20,%r10
  175707:	4d 31 da             	xor    %r11,%r10
  17570a:	4d 0f af d0          	imul   %r8,%r10
  17570e:	4d 89 d3             	mov    %r10,%r11
  175711:	49 c1 eb 20          	shr    $0x20,%r11
  175715:	45 31 da             	xor    %r11d,%r10d
  175718:	44 23 5f 18          	and    0x18(%rdi),%r11d
  17571c:	48 8b 1f             	mov    (%rdi),%rbx
  17571f:	49 c1 e3 06          	shl    $0x6,%r11
  175723:	62 b1 fd 48 6f 14 1b 	vmovdqa64 (%rbx,%r11,1),%zmm2
  17572a:	62 d2 7d 28 7c da    	vpbroadcastd %r10d,%ymm3
  175730:	c4 e2 65 40 d8       	vpmulld %ymm0,%ymm3,%ymm3
  175735:	c5 e5 72 d3 1a       	vpsrld $0x1a,%ymm3,%ymm3
  17573a:	62 f2 7d 48 35 db    	vpmovzxdq %ymm3,%zmm3
  175740:	62 f2 ed 48 45 d3    	vpsrlvq %zmm3,%zmm2,%zmm2
  175746:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
  17574c:	45 31 d2             	xor    %r10d,%r10d
  17574f:	c5 f9 98 c0          	kortestb %k0,%k0
  175753:	41 0f 94 c2          	sete   %r10b
  175757:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
  17575c:	48 83 c0 02          	add    $0x2,%rax
  175760:	49 39 c1             	cmp    %rax,%r9
  175763:	0f 85 17 ff ff ff    	jne    175680 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  175769:	40 f6 c6 01          	test   $0x1,%sil
  17576d:	74 70                	je     1757df <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x19f>
  17576f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  175773:	48 89 d6             	mov    %rdx,%rsi
  175776:	48 c1 ee 20          	shr    $0x20,%rsi
  17577a:	48 31 d6             	xor    %rdx,%rsi
  17577d:	49 0f af f0          	imul   %r8,%rsi
  175781:	48 89 f2             	mov    %rsi,%rdx
  175784:	48 c1 ea 20          	shr    $0x20,%rdx
  175788:	48 31 f2             	xor    %rsi,%rdx
  17578b:	49 0f af d0          	imul   %r8,%rdx
  17578f:	48 89 d6             	mov    %rdx,%rsi
  175792:	48 c1 ee 20          	shr    $0x20,%rsi
  175796:	31 f2                	xor    %esi,%edx
  175798:	23 77 18             	and    0x18(%rdi),%esi
  17579b:	48 8b 3f             	mov    (%rdi),%rdi
  17579e:	48 c1 e6 06          	shl    $0x6,%rsi
  1757a2:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
  1757a8:	c4 e2 7d 40 05 6f f1 	vpmulld -0x170e91(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  1757af:	e8 ff
  1757b1:	62 f1 fd 48 6f 0c 37 	vmovdqa64 (%rdi,%rsi,1),%zmm1
  1757b8:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
  1757bd:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
  1757c3:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
  1757c9:	62 f2 fe 58 27 05 85 	vptestnmq -0x17247b(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  1757d0:	db e8 ff
  1757d3:	31 d2                	xor    %edx,%edx
  1757d5:	c5 f9 98 c0          	kortestb %k0,%k0
  1757d9:	0f 94 c2             	sete   %dl
  1757dc:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  1757df:	5b                   	pop    %rbx
  1757e0:	c5 f8 77             	vzeroupper
  1757e3:	c3                   	ret
  1757e4:	cc                   	int3
  1757e5:	cc                   	int3
  1757e6:	cc                   	int3
  1757e7:	cc                   	int3
  1757e8:	cc                   	int3
  1757e9:	cc                   	int3
  1757ea:	cc                   	int3
  1757eb:	cc                   	int3
  1757ec:	cc                   	int3
  1757ed:	cc                   	int3
  1757ee:	cc                   	int3
  1757ef:	cc                   	int3
