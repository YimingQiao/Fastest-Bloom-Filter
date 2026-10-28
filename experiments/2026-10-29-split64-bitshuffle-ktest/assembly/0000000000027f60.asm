0000000000027f60 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)>:
   27f60:	push   %r14
   27f62:	push   %rbx
   27f63:	cmp    $0x1,%esi
   27f66:	jne    27fc5 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x65>
   27f68:	mov    (%rdx),%rax
   27f6b:	mov    %rax,%rdx
   27f6e:	shr    $0x20,%rdx
   27f72:	and    0x18(%rdi),%edx
   27f75:	vpbroadcastd %eax,%ymm0
   27f7b:	mov    (%rdi),%rax
   27f7e:	shl    $0x6,%rdx
   27f82:	vpmulld -0x25f2b(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   27f8b:	vpsrld $0x1a,%ymm0,%ymm0
   27f90:	vpmovzxdq %ymm0,%zmm0
   27f96:	vmovdqa64 (%rax,%rdx,1),%zmm1
   27f9d:	vpshufbitqmb %zmm0,%zmm1,%k0
   27fa3:	movabs $0x101010101010101,%rax
   27fad:	kmovq  %rax,%k1
   27fb2:	xor    %eax,%eax
   27fb4:	ktestq %k1,%k0
   27fb9:	setb   %al
   27fbc:	mov    %eax,(%rcx)
   27fbe:	pop    %rbx
   27fbf:	pop    %r14
   27fc1:	vzeroupper
   27fc4:	ret
   27fc5:	mov    %esi,%eax
   27fc7:	cmp    $0x10,%esi
   27fca:	jae    27fdc <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x7c>
   27fcc:	test   %esi,%esi
   27fce:	je     27fbe <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x5e>
   27fd0:	cmp    $0x1,%eax
   27fd3:	jne    27fff <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x9f>
   27fd5:	xor    %eax,%eax
   27fd7:	jmp    280d8 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x178>
   27fdc:	cmp    $0x21,%esi
   27fdf:	jb     27ff7 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x97>
   27fe1:	lea    -0x20(%rax),%r8
   27fe5:	cmp    $0x21,%rax
   27fe9:	jne    28136 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x1d6>
   27fef:	xor    %r9d,%r9d
   27ff2:	jmp    2822e <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x2ce>
   27ff7:	xor    %r8d,%r8d
   27ffa:	jmp    2829c <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x33c>
   27fff:	mov    %esi,%r8d
   28002:	and    $0xe,%r8d
   28006:	xor    %eax,%eax
   28008:	vmovdqa64 -0x257d2(%rip),%zmm0        # 2840 <_IO_stdin_used+0x7f8>
   28012:	movabs $0x101010101010101,%r9
   2801c:	kmovq  %r9,%k0
   28021:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   28030:	mov    (%rdx,%rax,8),%r9
   28034:	mov    %r9d,%r10d
   28037:	shr    $0x20,%r9
   2803b:	and    0x18(%rdi),%r9d
   2803f:	mov    (%rdi),%r11
   28042:	shl    $0x6,%r9
   28046:	vpbroadcastq %r10,%zmm1
   2804c:	vpmulld %zmm0,%zmm1,%zmm1
   28052:	vpsrlq $0x1a,%zmm1,%zmm1
   28059:	vmovaps (%r11,%r9,1),%zmm2
   28060:	vpshufbitqmb %zmm1,%zmm2,%k1
   28066:	xor    %r9d,%r9d
   28069:	ktestq %k0,%k1
   2806e:	setb   %r9b
   28072:	mov    %r9d,(%rcx,%rax,4)
   28076:	mov    0x8(%rdx,%rax,8),%r9
   2807b:	mov    %r9,%r10
   2807e:	shr    $0x20,%r10
   28082:	and    0x18(%rdi),%r10d
   28086:	mov    %r9d,%r9d
   28089:	mov    (%rdi),%r11
   2808c:	shl    $0x6,%r10
   28090:	vpbroadcastq %r9,%zmm1
   28096:	vpmulld %zmm0,%zmm1,%zmm1
   2809c:	vpsrlq $0x1a,%zmm1,%zmm1
   280a3:	vmovaps (%r11,%r10,1),%zmm2
   280aa:	vpshufbitqmb %zmm1,%zmm2,%k1
   280b0:	xor    %r9d,%r9d
   280b3:	ktestq %k0,%k1
   280b8:	setb   %r9b
   280bc:	mov    %r9d,0x4(%rcx,%rax,4)
   280c1:	add    $0x2,%rax
   280c5:	cmp    %rax,%r8
   280c8:	jne    28030 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   280ce:	test   $0x1,%sil
   280d2:	je     27fbe <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x5e>
   280d8:	mov    (%rdx,%rax,8),%rdx
   280dc:	mov    %rdx,%rsi
   280df:	shr    $0x20,%rsi
   280e3:	and    0x18(%rdi),%esi
   280e6:	mov    %edx,%edx
   280e8:	mov    (%rdi),%rdi
   280eb:	vpbroadcastq %rdx,%zmm0
   280f1:	vpmulld -0x258bb(%rip),%zmm0,%zmm0        # 2840 <_IO_stdin_used+0x7f8>
   280fb:	shl    $0x6,%rsi
   280ff:	vpsrlq $0x1a,%zmm0,%zmm0
   28106:	vmovaps (%rdi,%rsi,1),%zmm1
   2810d:	vpshufbitqmb %zmm0,%zmm1,%k0
   28113:	movabs $0x101010101010101,%rdx
   2811d:	kmovq  %rdx,%k1
   28122:	xor    %edx,%edx
   28124:	ktestq %k1,%k0
   28129:	setb   %dl
   2812c:	mov    %edx,(%rcx,%rax,4)
   2812f:	pop    %rbx
   28130:	pop    %r14
   28132:	vzeroupper
   28135:	ret
   28136:	and    $0x1,%esi
   28139:	mov    %r8,%r10
   2813c:	sub    %rsi,%r10
   2813f:	xor    %r9d,%r9d
   28142:	vmovdqa -0x260ea(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   2814a:	movabs $0x101010101010101,%r11
   28154:	kmovq  %r11,%k0
   28159:	nopl   0x0(%rax)
   28160:	mov    0x18(%rdi),%r11d
   28164:	mov    0x104(%rdx,%r9,8),%ebx
   2816c:	and    %r11d,%ebx
   2816f:	mov    (%rdi),%r14
   28172:	shl    $0x6,%rbx
   28176:	prefetcht0 (%r14,%rbx,1)
   2817b:	mov    (%rdx,%r9,8),%rbx
   2817f:	vpbroadcastd %ebx,%ymm1
   28185:	shr    $0x20,%rbx
   28189:	and    %r11d,%ebx
   2818c:	shl    $0x6,%rbx
   28190:	vpmulld %ymm0,%ymm1,%ymm1
   28195:	vpsrld $0x1a,%ymm1,%ymm1
   2819a:	vpmovzxdq %ymm1,%zmm1
   281a0:	vmovaps (%r14,%rbx,1),%zmm2
   281a7:	vpshufbitqmb %zmm1,%zmm2,%k1
   281ad:	xor    %r11d,%r11d
   281b0:	ktestq %k0,%k1
   281b5:	setb   %r11b
   281b9:	mov    %r11d,(%rcx,%r9,4)
   281bd:	mov    0x18(%rdi),%r11d
   281c1:	mov    0x10c(%rdx,%r9,8),%ebx
   281c9:	and    %r11d,%ebx
   281cc:	mov    (%rdi),%r14
   281cf:	shl    $0x6,%rbx
   281d3:	prefetcht0 (%r14,%rbx,1)
   281d8:	mov    0x8(%rdx,%r9,8),%rbx
   281dd:	vpbroadcastd %ebx,%ymm1
   281e3:	shr    $0x20,%rbx
   281e7:	and    %r11d,%ebx
   281ea:	shl    $0x6,%rbx
   281ee:	vpmulld %ymm0,%ymm1,%ymm1
   281f3:	vpsrld $0x1a,%ymm1,%ymm1
   281f8:	vpmovzxdq %ymm1,%zmm1
   281fe:	vmovaps (%r14,%rbx,1),%zmm2
   28205:	vpshufbitqmb %zmm1,%zmm2,%k1
   2820b:	xor    %r11d,%r11d
   2820e:	ktestq %k0,%k1
   28213:	setb   %r11b
   28217:	mov    %r11d,0x4(%rcx,%r9,4)
   2821c:	add    $0x2,%r9
   28220:	cmp    %r9,%r10
   28223:	jne    28160 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x200>
   28229:	test   %rsi,%rsi
   2822c:	je     2829c <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x33c>
   2822e:	mov    0x18(%rdi),%esi
   28231:	mov    0x104(%rdx,%r9,8),%r10d
   28239:	and    %esi,%r10d
   2823c:	mov    (%rdi),%r11
   2823f:	shl    $0x6,%r10
   28243:	prefetcht0 (%r11,%r10,1)
   28248:	mov    (%rdx,%r9,8),%r10
   2824c:	vpbroadcastd %r10d,%ymm0
   28252:	shr    $0x20,%r10
   28256:	and    %esi,%r10d
   28259:	shl    $0x6,%r10
   2825d:	vpmulld -0x26206(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   28266:	vpsrld $0x1a,%ymm0,%ymm0
   2826b:	vpmovzxdq %ymm0,%zmm0
   28271:	vmovdqa64 (%r11,%r10,1),%zmm1
   28278:	vpshufbitqmb %zmm0,%zmm1,%k0
   2827e:	movabs $0x101010101010101,%rsi
   28288:	kmovq  %rsi,%k1
   2828d:	xor    %esi,%esi
   2828f:	ktestq %k1,%k0
   28294:	setb   %sil
   28298:	mov    %esi,(%rcx,%r9,4)
   2829c:	cmp    %rax,%r8
   2829f:	jae    27fbe <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x5e>
   282a5:	vmovdqa -0x2624d(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   282ad:	movabs $0x101010101010101,%rsi
   282b7:	kmovq  %rsi,%k0
   282bc:	nopl   0x0(%rax)
   282c0:	mov    (%rdx,%r8,8),%rsi
   282c4:	vpbroadcastd %esi,%ymm1
   282ca:	shr    $0x20,%rsi
   282ce:	and    0x18(%rdi),%esi
   282d1:	mov    (%rdi),%r9
   282d4:	shl    $0x6,%rsi
   282d8:	vpmulld %ymm0,%ymm1,%ymm1
   282dd:	vpsrld $0x1a,%ymm1,%ymm1
   282e2:	vpmovzxdq %ymm1,%zmm1
   282e8:	vmovaps (%r9,%rsi,1),%zmm2
   282ef:	vpshufbitqmb %zmm1,%zmm2,%k1
   282f5:	xor    %esi,%esi
   282f7:	ktestq %k0,%k1
   282fc:	setb   %sil
   28300:	mov    %esi,(%rcx,%r8,4)
   28304:	inc    %r8
   28307:	cmp    %r8,%rax
   2830a:	jne    282c0 <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x360>
   2830c:	jmp    27fbe <void lookup_kernel<bloom_filters::Split64BitShuffleKtestCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleKtestCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x5e>
   28311:	int3
   28312:	int3
   28313:	int3
   28314:	int3
   28315:	int3
   28316:	int3
   28317:	int3
   28318:	int3
   28319:	int3
   2831a:	int3
   2831b:	int3
   2831c:	int3
   2831d:	int3
   2831e:	int3
   2831f:	int3

