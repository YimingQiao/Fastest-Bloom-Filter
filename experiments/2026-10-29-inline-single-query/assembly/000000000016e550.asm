000000000016e550 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16e550:	48 85 f6             	test   %rsi,%rsi
  16e553:	0f 84 ff 00 00 00    	je     16e658 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x108>
  16e559:	41 57                	push   %r15
  16e55b:	41 56                	push   %r14
  16e55d:	53                   	push   %rbx
  16e55e:	31 c0                	xor    %eax,%eax
  16e560:	4c 8d 05 79 7a e9 ff 	lea    -0x168587(%rip),%r8        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16e567:	c5 f9 6f 05 71 66 e9 	vmovdqa -0x16998f(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16e56e:	ff
  16e56f:	c5 f9 6f 0d 19 67 e9 	vmovdqa -0x1698e7(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16e576:	ff
  16e577:	c5 f9 6f 15 31 67 e9 	vmovdqa -0x1698cf(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16e57e:	ff
  16e57f:	c5 f9 6f 1d c9 66 e9 	vmovdqa -0x169937(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16e586:	ff
  16e587:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  16e58e:	00 00
  16e590:	4c 8b 34 c2          	mov    (%rdx,%rax,8),%r14
  16e594:	45 89 f1             	mov    %r14d,%r9d
  16e597:	45 89 f2             	mov    %r14d,%r10d
  16e59a:	45 89 f3             	mov    %r14d,%r11d
  16e59d:	c4 c3 7b f0 de 18    	rorx   $0x18,%r14d,%ebx
  16e5a3:	c5 f9 6e e3          	vmovd  %ebx,%xmm4
  16e5a7:	c4 c3 59 22 e6 01    	vpinsrd $0x1,%r14d,%xmm4,%xmm4
  16e5ad:	49 c1 ee 20          	shr    $0x20,%r14
  16e5b1:	41 83 e1 0f          	and    $0xf,%r9d
  16e5b5:	41 c1 ea 06          	shr    $0x6,%r10d
  16e5b9:	41 83 e2 3c          	and    $0x3c,%r10d
  16e5bd:	41 c1 eb 0e          	shr    $0xe,%r11d
  16e5c1:	41 83 e3 3c          	and    $0x3c,%r11d
  16e5c5:	83 e3 0f             	and    $0xf,%ebx
  16e5c8:	4c 8b 3f             	mov    (%rdi),%r15
  16e5cb:	62 d2 7d 08 7c ee    	vpbroadcastd %r14d,%xmm5
  16e5d1:	44 23 77 18          	and    0x18(%rdi),%r14d
  16e5d5:	c4 e2 51 45 e8       	vpsrlvd %xmm0,%xmm5,%xmm5
  16e5da:	c5 d1 db e9          	vpand  %xmm1,%xmm5,%xmm5
  16e5de:	62 d2 7d 08 7c f6    	vpbroadcastd %r14d,%xmm6
  16e5e4:	62 f3 55 08 25 f2 1e 	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16e5eb:	c5 f9 70 e4 54       	vpshufd $0x54,%xmm4,%xmm4
  16e5f0:	c4 e2 7d 35 ee       	vpmovzxdq %xmm6,%ymm5
  16e5f5:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
  16e5f9:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
  16e5fd:	62 d2 7d 29 91 34 af 	vpgatherqd (%r15,%ymm5,4),%xmm6{%k1}
  16e604:	c4 e2 59 45 e3       	vpsrlvd %xmm3,%xmm4,%xmm4
  16e609:	c4 c1 79 6e 2c 98    	vmovd  (%r8,%rbx,4),%xmm5
  16e60f:	c4 83 51 22 2c 03 01 	vpinsrd $0x1,(%r11,%r8,1),%xmm5,%xmm5
  16e616:	c4 83 51 22 2c 02 02 	vpinsrd $0x2,(%r10,%r8,1),%xmm5,%xmm5
  16e61d:	c4 83 51 22 2c 88 03 	vpinsrd $0x3,(%r8,%r9,4),%xmm5,%xmm5
  16e624:	62 f2 55 08 15 e4    	vprolvd %xmm4,%xmm5,%xmm4
  16e62a:	c5 c9 db ec          	vpand  %xmm4,%xmm6,%xmm5
  16e62e:	62 f1 55 08 76 c4    	vpcmpeqd %xmm4,%xmm5,%k0
  16e634:	c5 7b 93 c8          	kmovd  %k0,%r9d
  16e638:	45 31 d2             	xor    %r10d,%r10d
  16e63b:	41 80 f9 0f          	cmp    $0xf,%r9b
  16e63f:	41 0f 94 c2          	sete   %r10b
  16e643:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  16e647:	48 ff c0             	inc    %rax
  16e64a:	48 39 c6             	cmp    %rax,%rsi
  16e64d:	0f 85 3d ff ff ff    	jne    16e590 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  16e653:	5b                   	pop    %rbx
  16e654:	41 5e                	pop    %r14
  16e656:	41 5f                	pop    %r15
  16e658:	c5 f8 77             	vzeroupper
  16e65b:	c3                   	ret
  16e65c:	cc                   	int3
  16e65d:	cc                   	int3
  16e65e:	cc                   	int3
  16e65f:	cc                   	int3
