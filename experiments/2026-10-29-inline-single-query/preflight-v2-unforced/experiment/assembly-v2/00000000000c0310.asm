00000000000c0310 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c0310:	test   %rsi,%rsi
   c0313:	je     c0491 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c0319:	push   %rbp
   c031a:	push   %r15
   c031c:	push   %r14
   c031e:	push   %rbx
   c031f:	mov    %rdx,%rax
   c0322:	xor    %r8d,%r8d
   c0325:	movabs $0xdeadbeefdeadbeef,%r9
   c032f:	movabs $0xe6adbeefdeadbeef,%r10
   c0339:	mov    $0xffffffff,%r11d
   c033f:	vbroadcasti128 -0xbb758(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   c0348:	vpbroadcastd -0xbd0ad(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   c0351:	vpbroadcastd -0xbd0b2(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   c035a:	nopw   0x0(%rax,%rax,1)
   c0360:	mov    (%rax,%r8,8),%rdx
   c0364:	add    %r9,%rdx
   c0367:	rorx   $0x31,%rdx,%rbx
   c036d:	xor    %r10,%rdx
   c0370:	add    %rbx,%rdx
   c0373:	rorx   $0xc,%rdx,%r14
   c0379:	add    %r14,%rdx
   c037c:	rorx   $0x26,%rdx,%r15
   c0382:	add    %r15,%rdx
   c0385:	xor    %rdx,%rbx
   c0388:	rorx   $0xd,%rdx,%rdx
   c038e:	add    %rdx,%rbx
   c0391:	xor    %rbx,%r14
   c0394:	rorx   $0x24,%rbx,%rbx
   c039a:	add    %rbx,%r14
   c039d:	xor    %r14,%r15
   c03a0:	rorx   $0x37,%r14,%r14
   c03a6:	add    %r14,%r15
   c03a9:	xor    %r15,%rdx
   c03ac:	rorx   $0x11,%r15,%r15
   c03b2:	add    %r15,%rdx
   c03b5:	xor    %rdx,%rbx
   c03b8:	rorx   $0xa,%rdx,%rdx
   c03be:	add    %rdx,%rbx
   c03c1:	xor    %rbx,%r14
   c03c4:	rorx   $0x20,%rbx,%rbx
   c03ca:	add    %r14,%rbx
   c03cd:	xor    %rbx,%r15
   c03d0:	rorx   $0x27,%rbx,%rbx
   c03d6:	add    %r15,%rbx
   c03d9:	xor    %rbx,%rdx
   c03dc:	rorx   $0x1,%rbx,%rbx
   c03e2:	add    %rbx,%rdx
   c03e5:	rorx   $0x18,%ebx,%ebp
   c03eb:	vmovq  %rbx,%xmm3
   c03f0:	shr    $0x20,%rbx
   c03f4:	rorx   $0x1c,%edx,%r14d
   c03fa:	vmovq  %rdx,%xmm4
   c03ff:	shr    $0x20,%rdx
   c0403:	rorx   $0x1a,%ebx,%ebx
   c0409:	xor    %ebp,%ebx
   c040b:	xor    %ebx,%r14d
   c040e:	rorx   $0x1e,%edx,%edx
   c0414:	xor    %r14d,%edx
   c0417:	mov    0x8(%rdi),%ebx
   c041a:	imul   0x10(%rdi),%rdx
   c041f:	mulx   %rbx,%rdx,%rdx
   c0424:	movzbl (%rdi),%ebx
   c0427:	shlx   %rbx,%rdx,%rdx
   c042c:	add    0x20(%rdi),%rdx
   c0430:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   c0434:	add    $0x3,%bl
   c0437:	shlx   %ebx,%r11d,%ebx
   c043c:	vpbroadcastd %ebx,%ymm4
   c0442:	vpsrld $0x10,%xmm3,%xmm5
   c0447:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   c044d:	vpandn %ymm3,%ymm4,%ymm3
   c0451:	vpsrld $0x5,%ymm3,%ymm4
   c0456:	vmovdqa %ymm0,%ymm5
   c045a:	vpcmpeqd %ymm6,%ymm6,%ymm6
   c045e:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   c0464:	vpand  %ymm1,%ymm3,%ymm3
   c0468:	vpsllvd %ymm3,%ymm2,%ymm3
   c046d:	vpandn %ymm3,%ymm6,%ymm4
   c0471:	xor    %edx,%edx
   c0473:	vptest %ymm3,%ymm4
   c0478:	sete   %dl
   c047b:	mov    %edx,(%rcx,%r8,4)
   c047f:	inc    %r8
   c0482:	cmp    %r8,%rsi
   c0485:	jne    c0360 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c048b:	pop    %rbx
   c048c:	pop    %r14
   c048e:	pop    %r15
   c0490:	pop    %rbp
   c0491:	vzeroupper
   c0494:	ret
   c0495:	int3
   c0496:	int3
   c0497:	int3
   c0498:	int3
   c0499:	int3
   c049a:	int3
   c049b:	int3
   c049c:	int3
   c049d:	int3
   c049e:	int3
   c049f:	int3

