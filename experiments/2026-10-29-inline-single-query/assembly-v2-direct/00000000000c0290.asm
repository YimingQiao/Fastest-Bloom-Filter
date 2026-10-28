00000000000c0290 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c0290:	test   %rsi,%rsi
   c0293:	je     c0411 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c0299:	push   %rbp
   c029a:	push   %r15
   c029c:	push   %r14
   c029e:	push   %rbx
   c029f:	mov    %rdx,%rax
   c02a2:	xor    %r8d,%r8d
   c02a5:	movabs $0xdeadbeefdeadbeef,%r9
   c02af:	movabs $0xe6adbeefdeadbeef,%r10
   c02b9:	mov    $0xffffffff,%r11d
   c02bf:	vbroadcasti128 -0xbb6d8(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   c02c8:	vpbroadcastd -0xbd02d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   c02d1:	vpbroadcastd -0xbd032(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   c02da:	nopw   0x0(%rax,%rax,1)
   c02e0:	mov    (%rax,%r8,8),%rdx
   c02e4:	add    %r9,%rdx
   c02e7:	rorx   $0x31,%rdx,%rbx
   c02ed:	xor    %r10,%rdx
   c02f0:	add    %rbx,%rdx
   c02f3:	rorx   $0xc,%rdx,%r14
   c02f9:	add    %r14,%rdx
   c02fc:	rorx   $0x26,%rdx,%r15
   c0302:	add    %r15,%rdx
   c0305:	xor    %rdx,%rbx
   c0308:	rorx   $0xd,%rdx,%rdx
   c030e:	add    %rdx,%rbx
   c0311:	xor    %rbx,%r14
   c0314:	rorx   $0x24,%rbx,%rbx
   c031a:	add    %rbx,%r14
   c031d:	xor    %r14,%r15
   c0320:	rorx   $0x37,%r14,%r14
   c0326:	add    %r14,%r15
   c0329:	xor    %r15,%rdx
   c032c:	rorx   $0x11,%r15,%r15
   c0332:	add    %r15,%rdx
   c0335:	xor    %rdx,%rbx
   c0338:	rorx   $0xa,%rdx,%rdx
   c033e:	add    %rdx,%rbx
   c0341:	xor    %rbx,%r14
   c0344:	rorx   $0x20,%rbx,%rbx
   c034a:	add    %r14,%rbx
   c034d:	xor    %rbx,%r15
   c0350:	rorx   $0x27,%rbx,%rbx
   c0356:	add    %r15,%rbx
   c0359:	xor    %rbx,%rdx
   c035c:	rorx   $0x1,%rbx,%rbx
   c0362:	add    %rbx,%rdx
   c0365:	rorx   $0x18,%ebx,%ebp
   c036b:	vmovq  %rbx,%xmm3
   c0370:	shr    $0x20,%rbx
   c0374:	rorx   $0x1c,%edx,%r14d
   c037a:	vmovq  %rdx,%xmm4
   c037f:	shr    $0x20,%rdx
   c0383:	rorx   $0x1a,%ebx,%ebx
   c0389:	xor    %ebp,%ebx
   c038b:	xor    %ebx,%r14d
   c038e:	rorx   $0x1e,%edx,%edx
   c0394:	xor    %r14d,%edx
   c0397:	mov    0x8(%rdi),%ebx
   c039a:	imul   0x10(%rdi),%rdx
   c039f:	mulx   %rbx,%rdx,%rdx
   c03a4:	movzbl (%rdi),%ebx
   c03a7:	shlx   %rbx,%rdx,%rdx
   c03ac:	add    0x20(%rdi),%rdx
   c03b0:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   c03b4:	add    $0x3,%bl
   c03b7:	shlx   %ebx,%r11d,%ebx
   c03bc:	vpbroadcastd %ebx,%ymm4
   c03c2:	vpsrld $0x10,%xmm3,%xmm5
   c03c7:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   c03cd:	vpandn %ymm3,%ymm4,%ymm3
   c03d1:	vpsrld $0x5,%ymm3,%ymm4
   c03d6:	vmovdqa %ymm0,%ymm5
   c03da:	vpcmpeqd %ymm6,%ymm6,%ymm6
   c03de:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   c03e4:	vpand  %ymm1,%ymm3,%ymm3
   c03e8:	vpsllvd %ymm3,%ymm2,%ymm3
   c03ed:	vpandn %ymm3,%ymm6,%ymm4
   c03f1:	xor    %edx,%edx
   c03f3:	vptest %ymm3,%ymm4
   c03f8:	sete   %dl
   c03fb:	mov    %edx,(%rcx,%r8,4)
   c03ff:	inc    %r8
   c0402:	cmp    %r8,%rsi
   c0405:	jne    c02e0 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c040b:	pop    %rbx
   c040c:	pop    %r14
   c040e:	pop    %r15
   c0410:	pop    %rbp
   c0411:	vzeroupper
   c0414:	ret
   c0415:	int3
   c0416:	int3
   c0417:	int3
   c0418:	int3
   c0419:	int3
   c041a:	int3
   c041b:	int3
   c041c:	int3
   c041d:	int3
   c041e:	int3
   c041f:	int3

