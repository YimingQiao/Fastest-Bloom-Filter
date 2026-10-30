000000000004c0d0 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   4c0d0:	test   %rsi,%rsi
   4c0d3:	je     4c265 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x195>
   4c0d9:	push   %rbx
   4c0da:	movabs $0xd6e8feb86659fd93,%r8
   4c0e4:	cmp    $0x1,%rsi
   4c0e8:	jne    4c0f1 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   4c0ea:	xor    %eax,%eax
   4c0ec:	jmp    4c1f3 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x123>
   4c0f1:	mov    %rsi,%r9
   4c0f4:	and    $0xfffffffffffffffe,%r9
   4c0f8:	xor    %eax,%eax
   4c0fa:	vmovdqa -0x477e2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4c102:	vpbroadcastd -0x48e63(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4c10b:	nopl   0x0(%rax,%rax,1)
   4c110:	mov    (%rdx,%rax,8),%r10
   4c114:	mov    %r10,%r11
   4c117:	shr    $0x20,%r11
   4c11b:	xor    %r10,%r11
   4c11e:	imul   %r8,%r11
   4c122:	mov    %r11,%r10
   4c125:	shr    $0x20,%r10
   4c129:	xor    %r11,%r10
   4c12c:	imul   %r8,%r10
   4c130:	mov    %r10,%r11
   4c133:	shr    $0x20,%r11
   4c137:	xor    %r11d,%r10d
   4c13a:	mov    (%rdi),%ebx
   4c13c:	imul   %r11,%rbx
   4c140:	vpbroadcastd %r10d,%ymm2
   4c146:	vpmulld %ymm0,%ymm2,%ymm2
   4c14b:	vpsrld $0x1b,%ymm2,%ymm2
   4c150:	vpsllvd %ymm2,%ymm1,%ymm2
   4c155:	mov    0x8(%rdi),%r10
   4c159:	shr    $0x1b,%rbx
   4c15d:	and    $0xffffffffffffffe0,%rbx
   4c161:	vmovdqa (%r10,%rbx,1),%ymm3
   4c167:	xor    %r10d,%r10d
   4c16a:	vptest %ymm2,%ymm3
   4c16f:	setb   %r10b
   4c173:	mov    %r10d,(%rcx,%rax,4)
   4c177:	mov    0x8(%rdx,%rax,8),%r10
   4c17c:	mov    %r10,%r11
   4c17f:	shr    $0x20,%r11
   4c183:	xor    %r10,%r11
   4c186:	imul   %r8,%r11
   4c18a:	mov    %r11,%r10
   4c18d:	shr    $0x20,%r10
   4c191:	xor    %r11,%r10
   4c194:	imul   %r8,%r10
   4c198:	mov    %r10,%r11
   4c19b:	shr    $0x20,%r11
   4c19f:	xor    %r11d,%r10d
   4c1a2:	mov    (%rdi),%ebx
   4c1a4:	imul   %r11,%rbx
   4c1a8:	vpbroadcastd %r10d,%ymm2
   4c1ae:	vpmulld %ymm0,%ymm2,%ymm2
   4c1b3:	vpsrld $0x1b,%ymm2,%ymm2
   4c1b8:	vpsllvd %ymm2,%ymm1,%ymm2
   4c1bd:	mov    0x8(%rdi),%r10
   4c1c1:	shr    $0x1b,%rbx
   4c1c5:	and    $0xffffffffffffffe0,%rbx
   4c1c9:	vmovdqa (%r10,%rbx,1),%ymm3
   4c1cf:	xor    %r10d,%r10d
   4c1d2:	vptest %ymm2,%ymm3
   4c1d7:	setb   %r10b
   4c1db:	mov    %r10d,0x4(%rcx,%rax,4)
   4c1e0:	add    $0x2,%rax
   4c1e4:	cmp    %rax,%r9
   4c1e7:	jne    4c110 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   4c1ed:	test   $0x1,%sil
   4c1f1:	je     4c264 <void inline_single_kernel<true, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
   4c1f3:	mov    (%rdx,%rax,8),%rdx
   4c1f7:	mov    %rdx,%rsi
   4c1fa:	shr    $0x20,%rsi
   4c1fe:	xor    %rdx,%rsi
   4c201:	imul   %r8,%rsi
   4c205:	mov    %rsi,%rdx
   4c208:	shr    $0x20,%rdx
   4c20c:	xor    %rsi,%rdx
   4c20f:	imul   %r8,%rdx
   4c213:	mov    %rdx,%rsi
   4c216:	shr    $0x20,%rsi
   4c21a:	xor    %esi,%edx
   4c21c:	mov    (%rdi),%r8d
   4c21f:	imul   %rsi,%r8
   4c223:	vpbroadcastd %edx,%ymm0
   4c229:	vpmulld -0x47912(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4c232:	vpsrld $0x1b,%ymm0,%ymm0
   4c237:	vpbroadcastd -0x48f98(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4c240:	vpsllvd %ymm0,%ymm1,%ymm0
   4c245:	mov    0x8(%rdi),%rdx
   4c249:	shr    $0x1b,%r8
   4c24d:	and    $0xffffffffffffffe0,%r8
   4c251:	vmovdqa (%rdx,%r8,1),%ymm1
   4c257:	xor    %edx,%edx
   4c259:	vptest %ymm0,%ymm1
   4c25e:	setb   %dl
   4c261:	mov    %edx,(%rcx,%rax,4)
   4c264:	pop    %rbx
   4c265:	vzeroupper
   4c268:	ret
   4c269:	int3
   4c26a:	int3
   4c26b:	int3
   4c26c:	int3
   4c26d:	int3
   4c26e:	int3
   4c26f:	int3

