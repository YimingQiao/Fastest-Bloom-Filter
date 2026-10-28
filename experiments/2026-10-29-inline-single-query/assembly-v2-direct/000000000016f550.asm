000000000016f550 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16f550:	test   %rsi,%rsi
  16f553:	je     16f658 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x108>
  16f559:	push   %r15
  16f55b:	push   %r14
  16f55d:	push   %rbx
  16f55e:	xor    %eax,%eax
  16f560:	lea    -0x169587(%rip),%r8        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16f567:	vmovdqa -0x16a98f(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16f56f:	vmovdqa -0x16a8e7(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16f577:	vmovdqa -0x16a8cf(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16f57f:	vmovdqa -0x16a937(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16f587:	nopw   0x0(%rax,%rax,1)
  16f590:	mov    (%rdx,%rax,8),%r14
  16f594:	mov    %r14d,%r9d
  16f597:	mov    %r14d,%r10d
  16f59a:	mov    %r14d,%r11d
  16f59d:	rorx   $0x18,%r14d,%ebx
  16f5a3:	vmovd  %ebx,%xmm4
  16f5a7:	vpinsrd $0x1,%r14d,%xmm4,%xmm4
  16f5ad:	shr    $0x20,%r14
  16f5b1:	and    $0xf,%r9d
  16f5b5:	shr    $0x6,%r10d
  16f5b9:	and    $0x3c,%r10d
  16f5bd:	shr    $0xe,%r11d
  16f5c1:	and    $0x3c,%r11d
  16f5c5:	and    $0xf,%ebx
  16f5c8:	mov    (%rdi),%r15
  16f5cb:	vpbroadcastd %r14d,%xmm5
  16f5d1:	and    0x18(%rdi),%r14d
  16f5d5:	vpsrlvd %xmm0,%xmm5,%xmm5
  16f5da:	vpand  %xmm1,%xmm5,%xmm5
  16f5de:	vpbroadcastd %r14d,%xmm6
  16f5e4:	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16f5eb:	vpshufd $0x54,%xmm4,%xmm4
  16f5f0:	vpmovzxdq %xmm6,%ymm5
  16f5f5:	vpxor  %xmm6,%xmm6,%xmm6
  16f5f9:	kxnorw %k0,%k0,%k1
  16f5fd:	vpgatherqd (%r15,%ymm5,4),%xmm6{%k1}
  16f604:	vpsrlvd %xmm3,%xmm4,%xmm4
  16f609:	vmovd  (%r8,%rbx,4),%xmm5
  16f60f:	vpinsrd $0x1,(%r11,%r8,1),%xmm5,%xmm5
  16f616:	vpinsrd $0x2,(%r10,%r8,1),%xmm5,%xmm5
  16f61d:	vpinsrd $0x3,(%r8,%r9,4),%xmm5,%xmm5
  16f624:	vprolvd %xmm4,%xmm5,%xmm4
  16f62a:	vpand  %xmm4,%xmm6,%xmm5
  16f62e:	vpcmpeqd %xmm4,%xmm5,%k0
  16f634:	kmovd  %k0,%r9d
  16f638:	xor    %r10d,%r10d
  16f63b:	cmp    $0xf,%r9b
  16f63f:	sete   %r10b
  16f643:	mov    %r10d,(%rcx,%rax,4)
  16f647:	inc    %rax
  16f64a:	cmp    %rax,%rsi
  16f64d:	jne    16f590 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  16f653:	pop    %rbx
  16f654:	pop    %r14
  16f656:	pop    %r15
  16f658:	vzeroupper
  16f65b:	ret
  16f65c:	int3
  16f65d:	int3
  16f65e:	int3
  16f65f:	int3

