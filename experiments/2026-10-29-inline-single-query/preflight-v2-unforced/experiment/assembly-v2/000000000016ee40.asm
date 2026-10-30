000000000016ee40 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16ee40:	test   %rsi,%rsi
  16ee43:	je     16ef7a <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x13a>
  16ee49:	push   %r15
  16ee4b:	push   %r14
  16ee4d:	push   %r12
  16ee4f:	push   %rbx
  16ee50:	movabs $0xd6e8feb86659fd93,%rax
  16ee5a:	xor    %r8d,%r8d
  16ee5d:	lea    -0x168e84(%rip),%r9        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16ee64:	vmovdqa -0x16a28c(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16ee6c:	vmovdqa -0x16a1e4(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16ee74:	vmovdqa -0x16a1cc(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16ee7c:	vmovdqa -0x16a234(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16ee84:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  16ee90:	mov    (%rdx,%r8,8),%r10
  16ee94:	mov    %r10,%r11
  16ee97:	shr    $0x20,%r11
  16ee9b:	xor    %r10,%r11
  16ee9e:	imul   %rax,%r11
  16eea2:	mov    %r11,%r15
  16eea5:	shr    $0x20,%r15
  16eea9:	xor    %r11,%r15
  16eeac:	imul   %rax,%r15
  16eeb0:	mov    %r15,%rbx
  16eeb3:	shr    $0x20,%rbx
  16eeb7:	xor    %ebx,%r15d
  16eeba:	mov    %r15d,%r10d
  16eebd:	mov    %r15d,%r11d
  16eec0:	rorx   $0x18,%r15d,%r14d
  16eec6:	vmovd  %r14d,%xmm4
  16eecb:	vpinsrd $0x1,%r15d,%xmm4,%xmm4
  16eed1:	and    $0xf,%r15d
  16eed5:	shr    $0x6,%r10d
  16eed9:	and    $0x3c,%r10d
  16eedd:	shr    $0xe,%r11d
  16eee1:	and    $0x3c,%r11d
  16eee5:	and    $0xf,%r14d
  16eee9:	mov    (%rdi),%r12
  16eeec:	vpbroadcastd %ebx,%xmm5
  16eef2:	and    0x18(%rdi),%ebx
  16eef5:	vpsrlvd %xmm0,%xmm5,%xmm5
  16eefa:	vpand  %xmm1,%xmm5,%xmm5
  16eefe:	vpbroadcastd %ebx,%xmm6
  16ef04:	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16ef0b:	vpshufd $0x54,%xmm4,%xmm4
  16ef10:	vpmovzxdq %xmm6,%ymm5
  16ef15:	vpxor  %xmm6,%xmm6,%xmm6
  16ef19:	kxnorw %k0,%k0,%k1
  16ef1d:	vpgatherqd (%r12,%ymm5,4),%xmm6{%k1}
  16ef24:	vpsrlvd %xmm3,%xmm4,%xmm4
  16ef29:	vmovd  (%r9,%r14,4),%xmm5
  16ef2f:	vpinsrd $0x1,(%r11,%r9,1),%xmm5,%xmm5
  16ef36:	vpinsrd $0x2,(%r10,%r9,1),%xmm5,%xmm5
  16ef3d:	vpinsrd $0x3,(%r9,%r15,4),%xmm5,%xmm5
  16ef44:	vprolvd %xmm4,%xmm5,%xmm4
  16ef4a:	vpand  %xmm4,%xmm6,%xmm5
  16ef4e:	vpcmpeqd %xmm4,%xmm5,%k0
  16ef54:	kmovd  %k0,%r10d
  16ef58:	xor    %r11d,%r11d
  16ef5b:	cmp    $0xf,%r10b
  16ef5f:	sete   %r11b
  16ef63:	mov    %r11d,(%rcx,%r8,4)
  16ef67:	inc    %r8
  16ef6a:	cmp    %r8,%rsi
  16ef6d:	jne    16ee90 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  16ef73:	pop    %rbx
  16ef74:	pop    %r12
  16ef76:	pop    %r14
  16ef78:	pop    %r15
  16ef7a:	vzeroupper
  16ef7d:	ret
  16ef7e:	int3
  16ef7f:	int3

