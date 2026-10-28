00000000000b7420 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b7420:	test   %rsi,%rsi
   b7423:	je     b75a1 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b7429:	push   %rbp
   b742a:	push   %r15
   b742c:	push   %r14
   b742e:	push   %rbx
   b742f:	mov    %rdx,%rax
   b7432:	xor    %r8d,%r8d
   b7435:	movabs $0xdeadbeefdeadbeef,%r9
   b743f:	movabs $0xe6adbeefdeadbeef,%r10
   b7449:	mov    $0xffffffff,%r11d
   b744f:	vpbroadcastd -0xb41b4(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   b7458:	vpbroadcastd -0xb41b9(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   b7461:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   b7470:	mov    (%rax,%r8,8),%rdx
   b7474:	add    %r9,%rdx
   b7477:	rorx   $0x31,%rdx,%rbx
   b747d:	xor    %r10,%rdx
   b7480:	add    %rbx,%rdx
   b7483:	rorx   $0xc,%rdx,%r14
   b7489:	add    %r14,%rdx
   b748c:	rorx   $0x26,%rdx,%r15
   b7492:	add    %r15,%rdx
   b7495:	xor    %rdx,%rbx
   b7498:	rorx   $0xd,%rdx,%rdx
   b749e:	add    %rdx,%rbx
   b74a1:	xor    %rbx,%r14
   b74a4:	rorx   $0x24,%rbx,%rbx
   b74aa:	add    %rbx,%r14
   b74ad:	xor    %r14,%r15
   b74b0:	rorx   $0x37,%r14,%r14
   b74b6:	add    %r14,%r15
   b74b9:	xor    %r15,%rdx
   b74bc:	rorx   $0x11,%r15,%r15
   b74c2:	add    %r15,%rdx
   b74c5:	xor    %rdx,%rbx
   b74c8:	rorx   $0xa,%rdx,%rdx
   b74ce:	add    %rdx,%rbx
   b74d1:	xor    %rbx,%r14
   b74d4:	rorx   $0x20,%rbx,%rbx
   b74da:	add    %r14,%rbx
   b74dd:	xor    %rbx,%r15
   b74e0:	rorx   $0x27,%rbx,%rbx
   b74e6:	add    %r15,%rbx
   b74e9:	xor    %rbx,%rdx
   b74ec:	rorx   $0x1,%rbx,%rbx
   b74f2:	add    %rbx,%rdx
   b74f5:	rorx   $0x18,%ebx,%ebp
   b74fb:	vmovq  %rbx,%xmm2
   b7500:	shr    $0x20,%rbx
   b7504:	rorx   $0x1c,%edx,%r14d
   b750a:	vmovq  %rdx,%xmm3
   b750f:	shr    $0x20,%rdx
   b7513:	rorx   $0x1a,%ebx,%ebx
   b7519:	xor    %ebp,%ebx
   b751b:	xor    %ebx,%r14d
   b751e:	rorx   $0x1e,%edx,%edx
   b7524:	xor    %r14d,%edx
   b7527:	mov    0x8(%rdi),%ebx
   b752a:	imul   0x10(%rdi),%rdx
   b752f:	mulx   %rbx,%rdx,%rdx
   b7534:	movzbl (%rdi),%ebx
   b7537:	shlx   %rbx,%rdx,%rdx
   b753c:	add    0x20(%rdi),%rdx
   b7540:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   b7544:	add    $0x3,%bl
   b7547:	shlx   %ebx,%r11d,%ebx
   b754c:	vpbroadcastd %ebx,%ymm3
   b7552:	vpsrld $0x10,%xmm2,%xmm4
   b7557:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   b755d:	vpandn %ymm2,%ymm3,%ymm2
   b7561:	vpsrld $0x5,%ymm2,%ymm3
   b7566:	vpcmpeqd %ymm4,%ymm4,%ymm4
   b756a:	vpxor  %xmm5,%xmm5,%xmm5
   b756e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   b7574:	vpand  %ymm0,%ymm2,%ymm2
   b7578:	vpsllvd %ymm2,%ymm1,%ymm2
   b757d:	vpandn %ymm2,%ymm5,%ymm3
   b7581:	xor    %edx,%edx
   b7583:	vptest %ymm2,%ymm3
   b7588:	sete   %dl
   b758b:	mov    %edx,(%rcx,%r8,4)
   b758f:	inc    %r8
   b7592:	cmp    %r8,%rsi
   b7595:	jne    b7470 <void inline_single_kernel<false, external_bloom::Page<8u, false>, unsigned long>(external_bloom::Page<8u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b759b:	pop    %rbx
   b759c:	pop    %r14
   b759e:	pop    %r15
   b75a0:	pop    %rbp
   b75a1:	vzeroupper
   b75a4:	ret
   b75a5:	int3
   b75a6:	int3
   b75a7:	int3
   b75a8:	int3
   b75a9:	int3
   b75aa:	int3
   b75ab:	int3
   b75ac:	int3
   b75ad:	int3
   b75ae:	int3
   b75af:	int3

