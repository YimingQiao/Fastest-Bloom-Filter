00000000000b74a0 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b74a0:	test   %rsi,%rsi
   b74a3:	je     b7621 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b74a9:	push   %rbp
   b74aa:	push   %r15
   b74ac:	push   %r14
   b74ae:	push   %rbx
   b74af:	mov    %rdx,%rax
   b74b2:	xor    %r8d,%r8d
   b74b5:	movabs $0xdeadbeefdeadbeef,%r9
   b74bf:	movabs $0xe6adbeefdeadbeef,%r10
   b74c9:	mov    $0xffffffff,%r11d
   b74cf:	vpbroadcastd -0xb4234(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   b74d8:	vpbroadcastd -0xb4239(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   b74e1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   b74f0:	mov    (%rax,%r8,8),%rdx
   b74f4:	add    %r9,%rdx
   b74f7:	rorx   $0x31,%rdx,%rbx
   b74fd:	xor    %r10,%rdx
   b7500:	add    %rbx,%rdx
   b7503:	rorx   $0xc,%rdx,%r14
   b7509:	add    %r14,%rdx
   b750c:	rorx   $0x26,%rdx,%r15
   b7512:	add    %r15,%rdx
   b7515:	xor    %rdx,%rbx
   b7518:	rorx   $0xd,%rdx,%rdx
   b751e:	add    %rdx,%rbx
   b7521:	xor    %rbx,%r14
   b7524:	rorx   $0x24,%rbx,%rbx
   b752a:	add    %rbx,%r14
   b752d:	xor    %r14,%r15
   b7530:	rorx   $0x37,%r14,%r14
   b7536:	add    %r14,%r15
   b7539:	xor    %r15,%rdx
   b753c:	rorx   $0x11,%r15,%r15
   b7542:	add    %r15,%rdx
   b7545:	xor    %rdx,%rbx
   b7548:	rorx   $0xa,%rdx,%rdx
   b754e:	add    %rdx,%rbx
   b7551:	xor    %rbx,%r14
   b7554:	rorx   $0x20,%rbx,%rbx
   b755a:	add    %r14,%rbx
   b755d:	xor    %rbx,%r15
   b7560:	rorx   $0x27,%rbx,%rbx
   b7566:	add    %r15,%rbx
   b7569:	xor    %rbx,%rdx
   b756c:	rorx   $0x1,%rbx,%rbx
   b7572:	add    %rbx,%rdx
   b7575:	rorx   $0x18,%ebx,%ebp
   b757b:	vmovq  %rbx,%xmm2
   b7580:	shr    $0x20,%rbx
   b7584:	rorx   $0x1c,%edx,%r14d
   b758a:	vmovq  %rdx,%xmm3
   b758f:	shr    $0x20,%rdx
   b7593:	rorx   $0x1a,%ebx,%ebx
   b7599:	xor    %ebp,%ebx
   b759b:	xor    %ebx,%r14d
   b759e:	rorx   $0x1e,%edx,%edx
   b75a4:	xor    %r14d,%edx
   b75a7:	mov    0x8(%rdi),%ebx
   b75aa:	imul   0x10(%rdi),%rdx
   b75af:	mulx   %rbx,%rdx,%rdx
   b75b4:	movzbl (%rdi),%ebx
   b75b7:	shlx   %rbx,%rdx,%rdx
   b75bc:	add    0x20(%rdi),%rdx
   b75c0:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   b75c4:	add    $0x3,%bl
   b75c7:	shlx   %ebx,%r11d,%ebx
   b75cc:	vpbroadcastd %ebx,%ymm3
   b75d2:	vpsrld $0x10,%xmm2,%xmm4
   b75d7:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   b75dd:	vpandn %ymm2,%ymm3,%ymm2
   b75e1:	vpsrld $0x5,%ymm2,%ymm3
   b75e6:	vpcmpeqd %ymm4,%ymm4,%ymm4
   b75ea:	vpxor  %xmm5,%xmm5,%xmm5
   b75ee:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   b75f4:	vpand  %ymm0,%ymm2,%ymm2
   b75f8:	vpsllvd %ymm2,%ymm1,%ymm2
   b75fd:	vpandn %ymm2,%ymm5,%ymm3
   b7601:	xor    %edx,%edx
   b7603:	vptest %ymm2,%ymm3
   b7608:	sete   %dl
   b760b:	mov    %edx,(%rcx,%r8,4)
   b760f:	inc    %r8
   b7612:	cmp    %r8,%rsi
   b7615:	jne    b74f0 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b761b:	pop    %rbx
   b761c:	pop    %r14
   b761e:	pop    %r15
   b7620:	pop    %rbp
   b7621:	vzeroupper
   b7624:	ret
   b7625:	int3
   b7626:	int3
   b7627:	int3
   b7628:	int3
   b7629:	int3
   b762a:	int3
   b762b:	int3
   b762c:	int3
   b762d:	int3
   b762e:	int3
   b762f:	int3

