0000000000175510 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  175510:	test   %rsi,%rsi
  175513:	je     175650 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  175519:	cmp    $0x1,%rsi
  17551d:	jne    175526 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
  17551f:	xor    %eax,%eax
  175521:	jmp    1755fe <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  175526:	mov    %rsi,%r8
  175529:	and    $0xfffffffffffffffe,%r8
  17552d:	xor    %eax,%eax
  17552f:	vmovdqa -0x170c17(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175537:	vpbroadcastq -0x1721e9(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  175541:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  175550:	mov    (%rdx,%rax,8),%r9
  175554:	vpbroadcastd %r9d,%ymm2
  17555a:	shr    $0x20,%r9
  17555e:	and    0x18(%rdi),%r9d
  175562:	mov    (%rdi),%r10
  175565:	shl    $0x6,%r9
  175569:	vmovdqa64 (%r10,%r9,1),%zmm3
  175570:	vpmulld %ymm0,%ymm2,%ymm2
  175575:	vpsrld $0x1a,%ymm2,%ymm2
  17557a:	vpmovzxdq %ymm2,%zmm2
  175580:	vpsrlvq %zmm2,%zmm3,%zmm2
  175586:	vptestnmq %zmm1,%zmm2,%k0
  17558c:	xor    %r9d,%r9d
  17558f:	kortestb %k0,%k0
  175593:	sete   %r9b
  175597:	mov    %r9d,(%rcx,%rax,4)
  17559b:	mov    0x8(%rdx,%rax,8),%r9
  1755a0:	mov    %r9,%r10
  1755a3:	shr    $0x20,%r10
  1755a7:	and    0x18(%rdi),%r10d
  1755ab:	vpbroadcastd %r9d,%ymm2
  1755b1:	mov    (%rdi),%r9
  1755b4:	shl    $0x6,%r10
  1755b8:	vmovdqa64 (%r9,%r10,1),%zmm3
  1755bf:	vpmulld %ymm0,%ymm2,%ymm2
  1755c4:	vpsrld $0x1a,%ymm2,%ymm2
  1755c9:	vpmovzxdq %ymm2,%zmm2
  1755cf:	vpsrlvq %zmm2,%zmm3,%zmm2
  1755d5:	vptestnmq %zmm1,%zmm2,%k0
  1755db:	xor    %r9d,%r9d
  1755de:	kortestb %k0,%k0
  1755e2:	sete   %r9b
  1755e6:	mov    %r9d,0x4(%rcx,%rax,4)
  1755eb:	add    $0x2,%rax
  1755ef:	cmp    %rax,%r8
  1755f2:	jne    175550 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1755f8:	test   $0x1,%sil
  1755fc:	je     175650 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  1755fe:	mov    (%rdx,%rax,8),%rdx
  175602:	mov    %rdx,%rsi
  175605:	shr    $0x20,%rsi
  175609:	and    0x18(%rdi),%esi
  17560c:	vpbroadcastd %edx,%ymm0
  175612:	mov    (%rdi),%rdx
  175615:	shl    $0x6,%rsi
  175619:	vpmulld -0x170d02(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175622:	vmovdqa64 (%rdx,%rsi,1),%zmm1
  175629:	vpsrld $0x1a,%ymm0,%ymm0
  17562e:	vpmovzxdq %ymm0,%zmm0
  175634:	vpsrlvq %zmm0,%zmm1,%zmm0
  17563a:	vptestnmq -0x1722ec(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  175644:	xor    %edx,%edx
  175646:	kortestb %k0,%k0
  17564a:	sete   %dl
  17564d:	mov    %edx,(%rcx,%rax,4)
  175650:	vzeroupper
  175653:	ret
  175654:	int3
  175655:	int3
  175656:	int3
  175657:	int3
  175658:	int3
  175659:	int3
  17565a:	int3
  17565b:	int3
  17565c:	int3
  17565d:	int3
  17565e:	int3
  17565f:	int3

