000000000016ea40 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  16ea40:	48 85 f6             	test   %rsi,%rsi
  16ea43:	0f 84 31 01 00 00    	je     16eb7a <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x13a>
  16ea49:	41 57                	push   %r15
  16ea4b:	41 56                	push   %r14
  16ea4d:	41 54                	push   %r12
  16ea4f:	53                   	push   %rbx
  16ea50:	48 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%rax
  16ea57:	fe e8 d6
  16ea5a:	45 31 c0             	xor    %r8d,%r8d
  16ea5d:	4c 8d 0d 7c 75 e9 ff 	lea    -0x168a84(%rip),%r9        # 5fe0 <bloom_filters::FourSectorBloomFilter::patterns2>
  16ea64:	c5 f9 6f 05 74 61 e9 	vmovdqa -0x169e8c(%rip),%xmm0        # 4be0 <typeinfo name for main::$_60+0x410>
  16ea6b:	ff
  16ea6c:	c5 f9 6f 0d 1c 62 e9 	vmovdqa -0x169de4(%rip),%xmm1        # 4c90 <typeinfo name for main::$_60+0x4c0>
  16ea73:	ff
  16ea74:	c5 f9 6f 15 34 62 e9 	vmovdqa -0x169dcc(%rip),%xmm2        # 4cb0 <typeinfo name for main::$_60+0x4e0>
  16ea7b:	ff
  16ea7c:	c5 f9 6f 1d cc 61 e9 	vmovdqa -0x169e34(%rip),%xmm3        # 4c50 <typeinfo name for main::$_60+0x480>
  16ea83:	ff
  16ea84:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  16ea8b:	00 00 00 00 00
  16ea90:	4e 8b 14 c2          	mov    (%rdx,%r8,8),%r10
  16ea94:	4d 89 d3             	mov    %r10,%r11
  16ea97:	49 c1 eb 20          	shr    $0x20,%r11
  16ea9b:	4d 31 d3             	xor    %r10,%r11
  16ea9e:	4c 0f af d8          	imul   %rax,%r11
  16eaa2:	4d 89 df             	mov    %r11,%r15
  16eaa5:	49 c1 ef 20          	shr    $0x20,%r15
  16eaa9:	4d 31 df             	xor    %r11,%r15
  16eaac:	4c 0f af f8          	imul   %rax,%r15
  16eab0:	4c 89 fb             	mov    %r15,%rbx
  16eab3:	48 c1 eb 20          	shr    $0x20,%rbx
  16eab7:	41 31 df             	xor    %ebx,%r15d
  16eaba:	45 89 fa             	mov    %r15d,%r10d
  16eabd:	45 89 fb             	mov    %r15d,%r11d
  16eac0:	c4 43 7b f0 f7 18    	rorx   $0x18,%r15d,%r14d
  16eac6:	c4 c1 79 6e e6       	vmovd  %r14d,%xmm4
  16eacb:	c4 c3 59 22 e7 01    	vpinsrd $0x1,%r15d,%xmm4,%xmm4
  16ead1:	41 83 e7 0f          	and    $0xf,%r15d
  16ead5:	41 c1 ea 06          	shr    $0x6,%r10d
  16ead9:	41 83 e2 3c          	and    $0x3c,%r10d
  16eadd:	41 c1 eb 0e          	shr    $0xe,%r11d
  16eae1:	41 83 e3 3c          	and    $0x3c,%r11d
  16eae5:	41 83 e6 0f          	and    $0xf,%r14d
  16eae9:	4c 8b 27             	mov    (%rdi),%r12
  16eaec:	62 f2 7d 08 7c eb    	vpbroadcastd %ebx,%xmm5
  16eaf2:	23 5f 18             	and    0x18(%rdi),%ebx
  16eaf5:	c4 e2 51 45 e8       	vpsrlvd %xmm0,%xmm5,%xmm5
  16eafa:	c5 d1 db e9          	vpand  %xmm1,%xmm5,%xmm5
  16eafe:	62 f2 7d 08 7c f3    	vpbroadcastd %ebx,%xmm6
  16eb04:	62 f3 55 08 25 f2 1e 	vpternlogd $0x1e,%xmm2,%xmm5,%xmm6
  16eb0b:	c5 f9 70 e4 54       	vpshufd $0x54,%xmm4,%xmm4
  16eb10:	c4 e2 7d 35 ee       	vpmovzxdq %xmm6,%ymm5
  16eb15:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
  16eb19:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
  16eb1d:	62 d2 7d 29 91 34 ac 	vpgatherqd (%r12,%ymm5,4),%xmm6{%k1}
  16eb24:	c4 e2 59 45 e3       	vpsrlvd %xmm3,%xmm4,%xmm4
  16eb29:	c4 81 79 6e 2c b1    	vmovd  (%r9,%r14,4),%xmm5
  16eb2f:	c4 83 51 22 2c 0b 01 	vpinsrd $0x1,(%r11,%r9,1),%xmm5,%xmm5
  16eb36:	c4 83 51 22 2c 0a 02 	vpinsrd $0x2,(%r10,%r9,1),%xmm5,%xmm5
  16eb3d:	c4 83 51 22 2c b9 03 	vpinsrd $0x3,(%r9,%r15,4),%xmm5,%xmm5
  16eb44:	62 f2 55 08 15 e4    	vprolvd %xmm4,%xmm5,%xmm4
  16eb4a:	c5 c9 db ec          	vpand  %xmm4,%xmm6,%xmm5
  16eb4e:	62 f1 55 08 76 c4    	vpcmpeqd %xmm4,%xmm5,%k0
  16eb54:	c5 7b 93 d0          	kmovd  %k0,%r10d
  16eb58:	45 31 db             	xor    %r11d,%r11d
  16eb5b:	41 80 fa 0f          	cmp    $0xf,%r10b
  16eb5f:	41 0f 94 c3          	sete   %r11b
  16eb63:	46 89 1c 81          	mov    %r11d,(%rcx,%r8,4)
  16eb67:	49 ff c0             	inc    %r8
  16eb6a:	4c 39 c6             	cmp    %r8,%rsi
  16eb6d:	0f 85 1d ff ff ff    	jne    16ea90 <void inline_single_kernel<true, bloom_filters::FourSectorBloomFilter, unsigned long>(bloom_filters::FourSectorBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  16eb73:	5b                   	pop    %rbx
  16eb74:	41 5c                	pop    %r12
  16eb76:	41 5e                	pop    %r14
  16eb78:	41 5f                	pop    %r15
  16eb7a:	c5 f8 77             	vzeroupper
  16eb7d:	c3                   	ret
  16eb7e:	cc                   	int3
  16eb7f:	cc                   	int3
