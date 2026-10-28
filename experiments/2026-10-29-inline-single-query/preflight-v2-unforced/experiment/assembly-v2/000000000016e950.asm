000000000016e950 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16e950:	test   %rsi,%rsi
  16e953:	je     16ea58 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x108>
  16e959:	push   %r15
  16e95b:	push   %r14
  16e95d:	push   %rbx
  16e95e:	xor    %eax,%eax
  16e960:	lea    -0x168987(%rip),%r8        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16e967:	vmovdqa -0x169d8f(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16e96f:	vmovdqa -0x169ce7(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16e977:	vmovdqa -0x169ccf(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16e97f:	vmovdqa -0x169d37(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16e987:	nopw   0x0(%rax,%rax,1)
  16e990:	mov    (%rdx,%rax,8),%r14
  16e994:	mov    %r14d,%r9d
  16e997:	mov    %r14d,%r10d
  16e99a:	mov    %r14d,%r11d
  16e99d:	rorx   $0x18,%r14d,%ebx
  16e9a3:	vmovd  %ebx,%xmm4
  16e9a7:	vpinsrd $0x1,%r14d,%xmm4,%xmm4
  16e9ad:	shr    $0x20,%r14
  16e9b1:	and    $0xf,%r9d
  16e9b5:	shr    $0x6,%r10d
  16e9b9:	and    $0x3c,%r10d
  16e9bd:	shr    $0xe,%r11d
  16e9c1:	and    $0x3c,%r11d
  16e9c5:	and    $0xf,%ebx
  16e9c8:	mov    (%rdi),%r15
  16e9cb:	vpbroadcastd %r14d,%xmm5
  16e9d1:	and    0x18(%rdi),%r14d
  16e9d5:	vpsrlvd %xmm0,%xmm5,%xmm5
  16e9da:	vpand  %xmm1,%xmm5,%xmm5
  16e9de:	vpbroadcastd %r14d,%xmm6
  16e9e4:	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16e9eb:	vpshufd $0x54,%xmm4,%xmm4
  16e9f0:	vpmovzxdq %xmm6,%ymm5
  16e9f5:	vpxor  %xmm6,%xmm6,%xmm6
  16e9f9:	kxnorw %k0,%k0,%k1
  16e9fd:	vpgatherqd (%r15,%ymm5,4),%xmm6{%k1}
  16ea04:	vpsrlvd %xmm3,%xmm4,%xmm4
  16ea09:	vmovd  (%r8,%rbx,4),%xmm5
  16ea0f:	vpinsrd $0x1,(%r11,%r8,1),%xmm5,%xmm5
  16ea16:	vpinsrd $0x2,(%r10,%r8,1),%xmm5,%xmm5
  16ea1d:	vpinsrd $0x3,(%r8,%r9,4),%xmm5,%xmm5
  16ea24:	vprolvd %xmm4,%xmm5,%xmm4
  16ea2a:	vpand  %xmm4,%xmm6,%xmm5
  16ea2e:	vpcmpeqd %xmm4,%xmm5,%k0
  16ea34:	kmovd  %k0,%r9d
  16ea38:	xor    %r10d,%r10d
  16ea3b:	cmp    $0xf,%r9b
  16ea3f:	sete   %r10b
  16ea43:	mov    %r10d,(%rcx,%rax,4)
  16ea47:	inc    %rax
  16ea4a:	cmp    %rax,%rsi
  16ea4d:	jne    16e990 <void inline_single_kernel<false, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  16ea53:	pop    %rbx
  16ea54:	pop    %r14
  16ea56:	pop    %r15
  16ea58:	vzeroupper
  16ea5b:	ret
  16ea5c:	int3
  16ea5d:	int3
  16ea5e:	int3
  16ea5f:	int3

