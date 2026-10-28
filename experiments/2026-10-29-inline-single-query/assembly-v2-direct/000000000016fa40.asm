000000000016fa40 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16fa40:	test   %rsi,%rsi
  16fa43:	je     16fb7a <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x13a>
  16fa49:	push   %r15
  16fa4b:	push   %r14
  16fa4d:	push   %r12
  16fa4f:	push   %rbx
  16fa50:	movabs $0xd6e8feb86659fd93,%rax
  16fa5a:	xor    %r8d,%r8d
  16fa5d:	lea    -0x169a84(%rip),%r9        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16fa64:	vmovdqa -0x16ae8c(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16fa6c:	vmovdqa -0x16ade4(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16fa74:	vmovdqa -0x16adcc(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16fa7c:	vmovdqa -0x16ae34(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16fa84:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  16fa90:	mov    (%rdx,%r8,8),%r10
  16fa94:	mov    %r10,%r11
  16fa97:	shr    $0x20,%r11
  16fa9b:	xor    %r10,%r11
  16fa9e:	imul   %rax,%r11
  16faa2:	mov    %r11,%r15
  16faa5:	shr    $0x20,%r15
  16faa9:	xor    %r11,%r15
  16faac:	imul   %rax,%r15
  16fab0:	mov    %r15,%rbx
  16fab3:	shr    $0x20,%rbx
  16fab7:	xor    %ebx,%r15d
  16faba:	mov    %r15d,%r10d
  16fabd:	mov    %r15d,%r11d
  16fac0:	rorx   $0x18,%r15d,%r14d
  16fac6:	vmovd  %r14d,%xmm4
  16facb:	vpinsrd $0x1,%r15d,%xmm4,%xmm4
  16fad1:	and    $0xf,%r15d
  16fad5:	shr    $0x6,%r10d
  16fad9:	and    $0x3c,%r10d
  16fadd:	shr    $0xe,%r11d
  16fae1:	and    $0x3c,%r11d
  16fae5:	and    $0xf,%r14d
  16fae9:	mov    (%rdi),%r12
  16faec:	vpbroadcastd %ebx,%xmm5
  16faf2:	and    0x18(%rdi),%ebx
  16faf5:	vpsrlvd %xmm0,%xmm5,%xmm5
  16fafa:	vpand  %xmm1,%xmm5,%xmm5
  16fafe:	vpbroadcastd %ebx,%xmm6
  16fb04:	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16fb0b:	vpshufd $0x54,%xmm4,%xmm4
  16fb10:	vpmovzxdq %xmm6,%ymm5
  16fb15:	vpxor  %xmm6,%xmm6,%xmm6
  16fb19:	kxnorw %k0,%k0,%k1
  16fb1d:	vpgatherqd (%r12,%ymm5,4),%xmm6{%k1}
  16fb24:	vpsrlvd %xmm3,%xmm4,%xmm4
  16fb29:	vmovd  (%r9,%r14,4),%xmm5
  16fb2f:	vpinsrd $0x1,(%r11,%r9,1),%xmm5,%xmm5
  16fb36:	vpinsrd $0x2,(%r10,%r9,1),%xmm5,%xmm5
  16fb3d:	vpinsrd $0x3,(%r9,%r15,4),%xmm5,%xmm5
  16fb44:	vprolvd %xmm4,%xmm5,%xmm4
  16fb4a:	vpand  %xmm4,%xmm6,%xmm5
  16fb4e:	vpcmpeqd %xmm4,%xmm5,%k0
  16fb54:	kmovd  %k0,%r10d
  16fb58:	xor    %r11d,%r11d
  16fb5b:	cmp    $0xf,%r10b
  16fb5f:	sete   %r11b
  16fb63:	mov    %r11d,(%rcx,%r8,4)
  16fb67:	inc    %r8
  16fb6a:	cmp    %r8,%rsi
  16fb6d:	jne    16fa90 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  16fb73:	pop    %rbx
  16fb74:	pop    %r12
  16fb76:	pop    %r14
  16fb78:	pop    %r15
  16fb7a:	vzeroupper
  16fb7d:	ret
  16fb7e:	int3
  16fb7f:	int3

