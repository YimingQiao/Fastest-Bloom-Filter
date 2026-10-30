000000000004c150 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   4c150:	test   %rsi,%rsi
   4c153:	je     4c2e5 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x195>
   4c159:	push   %rbx
   4c15a:	movabs $0xd6e8feb86659fd93,%r8
   4c164:	cmp    $0x1,%rsi
   4c168:	jne    4c171 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   4c16a:	xor    %eax,%eax
   4c16c:	jmp    4c273 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x123>
   4c171:	mov    %rsi,%r9
   4c174:	and    $0xfffffffffffffffe,%r9
   4c178:	xor    %eax,%eax
   4c17a:	vmovdqa -0x47862(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4c182:	vpbroadcastd -0x48ee3(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4c18b:	nopl   0x0(%rax,%rax,1)
   4c190:	mov    (%rdx,%rax,8),%r10
   4c194:	mov    %r10,%r11
   4c197:	shr    $0x20,%r11
   4c19b:	xor    %r10,%r11
   4c19e:	imul   %r8,%r11
   4c1a2:	mov    %r11,%r10
   4c1a5:	shr    $0x20,%r10
   4c1a9:	xor    %r11,%r10
   4c1ac:	imul   %r8,%r10
   4c1b0:	mov    %r10,%r11
   4c1b3:	shr    $0x20,%r11
   4c1b7:	xor    %r11d,%r10d
   4c1ba:	mov    (%rdi),%ebx
   4c1bc:	imul   %r11,%rbx
   4c1c0:	vpbroadcastd %r10d,%ymm2
   4c1c6:	vpmulld %ymm0,%ymm2,%ymm2
   4c1cb:	vpsrld $0x1b,%ymm2,%ymm2
   4c1d0:	vpsllvd %ymm2,%ymm1,%ymm2
   4c1d5:	mov    0x8(%rdi),%r10
   4c1d9:	shr    $0x1b,%rbx
   4c1dd:	and    $0xffffffffffffffe0,%rbx
   4c1e1:	vmovdqa (%r10,%rbx,1),%ymm3
   4c1e7:	xor    %r10d,%r10d
   4c1ea:	vptest %ymm2,%ymm3
   4c1ef:	setb   %r10b
   4c1f3:	mov    %r10d,(%rcx,%rax,4)
   4c1f7:	mov    0x8(%rdx,%rax,8),%r10
   4c1fc:	mov    %r10,%r11
   4c1ff:	shr    $0x20,%r11
   4c203:	xor    %r10,%r11
   4c206:	imul   %r8,%r11
   4c20a:	mov    %r11,%r10
   4c20d:	shr    $0x20,%r10
   4c211:	xor    %r11,%r10
   4c214:	imul   %r8,%r10
   4c218:	mov    %r10,%r11
   4c21b:	shr    $0x20,%r11
   4c21f:	xor    %r11d,%r10d
   4c222:	mov    (%rdi),%ebx
   4c224:	imul   %r11,%rbx
   4c228:	vpbroadcastd %r10d,%ymm2
   4c22e:	vpmulld %ymm0,%ymm2,%ymm2
   4c233:	vpsrld $0x1b,%ymm2,%ymm2
   4c238:	vpsllvd %ymm2,%ymm1,%ymm2
   4c23d:	mov    0x8(%rdi),%r10
   4c241:	shr    $0x1b,%rbx
   4c245:	and    $0xffffffffffffffe0,%rbx
   4c249:	vmovdqa (%r10,%rbx,1),%ymm3
   4c24f:	xor    %r10d,%r10d
   4c252:	vptest %ymm2,%ymm3
   4c257:	setb   %r10b
   4c25b:	mov    %r10d,0x4(%rcx,%rax,4)
   4c260:	add    $0x2,%rax
   4c264:	cmp    %rax,%r9
   4c267:	jne    4c190 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   4c26d:	test   $0x1,%sil
   4c271:	je     4c2e4 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
   4c273:	mov    (%rdx,%rax,8),%rdx
   4c277:	mov    %rdx,%rsi
   4c27a:	shr    $0x20,%rsi
   4c27e:	xor    %rdx,%rsi
   4c281:	imul   %r8,%rsi
   4c285:	mov    %rsi,%rdx
   4c288:	shr    $0x20,%rdx
   4c28c:	xor    %rsi,%rdx
   4c28f:	imul   %r8,%rdx
   4c293:	mov    %rdx,%rsi
   4c296:	shr    $0x20,%rsi
   4c29a:	xor    %esi,%edx
   4c29c:	mov    (%rdi),%r8d
   4c29f:	imul   %rsi,%r8
   4c2a3:	vpbroadcastd %edx,%ymm0
   4c2a9:	vpmulld -0x47992(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4c2b2:	vpsrld $0x1b,%ymm0,%ymm0
   4c2b7:	vpbroadcastd -0x49018(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4c2c0:	vpsllvd %ymm0,%ymm1,%ymm0
   4c2c5:	mov    0x8(%rdi),%rdx
   4c2c9:	shr    $0x1b,%r8
   4c2cd:	and    $0xffffffffffffffe0,%r8
   4c2d1:	vmovdqa (%rdx,%r8,1),%ymm1
   4c2d7:	xor    %edx,%edx
   4c2d9:	vptest %ymm0,%ymm1
   4c2de:	setb   %dl
   4c2e1:	mov    %edx,(%rcx,%rax,4)
   4c2e4:	pop    %rbx
   4c2e5:	vzeroupper
   4c2e8:	ret
   4c2e9:	int3
   4c2ea:	int3
   4c2eb:	int3
   4c2ec:	int3
   4c2ed:	int3
   4c2ee:	int3
   4c2ef:	int3

