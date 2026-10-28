00000000000c46c0 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c46c0:	test   %rsi,%rsi
   c46c3:	je     c4841 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c46c9:	push   %rbp
   c46ca:	push   %r15
   c46cc:	push   %r14
   c46ce:	push   %rbx
   c46cf:	mov    %rdx,%rax
   c46d2:	xor    %r8d,%r8d
   c46d5:	movabs $0xdeadbeefdeadbeef,%r9
   c46df:	movabs $0xe6adbeefdeadbeef,%r10
   c46e9:	mov    $0xffffffff,%r11d
   c46ef:	vpbroadcastd -0xc1454(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   c46f8:	vpbroadcastd -0xc1459(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   c4701:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   c4710:	mov    (%rax,%r8,8),%rdx
   c4714:	add    %r9,%rdx
   c4717:	rorx   $0x31,%rdx,%rbx
   c471d:	xor    %r10,%rdx
   c4720:	add    %rbx,%rdx
   c4723:	rorx   $0xc,%rdx,%r14
   c4729:	add    %r14,%rdx
   c472c:	rorx   $0x26,%rdx,%r15
   c4732:	add    %r15,%rdx
   c4735:	xor    %rdx,%rbx
   c4738:	rorx   $0xd,%rdx,%rdx
   c473e:	add    %rdx,%rbx
   c4741:	xor    %rbx,%r14
   c4744:	rorx   $0x24,%rbx,%rbx
   c474a:	add    %rbx,%r14
   c474d:	xor    %r14,%r15
   c4750:	rorx   $0x37,%r14,%r14
   c4756:	add    %r14,%r15
   c4759:	xor    %r15,%rdx
   c475c:	rorx   $0x11,%r15,%r15
   c4762:	add    %r15,%rdx
   c4765:	xor    %rdx,%rbx
   c4768:	rorx   $0xa,%rdx,%rdx
   c476e:	add    %rdx,%rbx
   c4771:	xor    %rbx,%r14
   c4774:	rorx   $0x20,%rbx,%rbx
   c477a:	add    %r14,%rbx
   c477d:	xor    %rbx,%r15
   c4780:	rorx   $0x27,%rbx,%rbx
   c4786:	add    %r15,%rbx
   c4789:	xor    %rbx,%rdx
   c478c:	rorx   $0x1,%rbx,%rbx
   c4792:	add    %rbx,%rdx
   c4795:	rorx   $0x18,%ebx,%ebp
   c479b:	vmovq  %rbx,%xmm2
   c47a0:	shr    $0x20,%rbx
   c47a4:	rorx   $0x1c,%edx,%r14d
   c47aa:	vmovq  %rdx,%xmm3
   c47af:	shr    $0x20,%rdx
   c47b3:	rorx   $0x1a,%ebx,%ebx
   c47b9:	xor    %ebp,%ebx
   c47bb:	xor    %ebx,%r14d
   c47be:	rorx   $0x1e,%edx,%edx
   c47c4:	xor    %r14d,%edx
   c47c7:	mov    0x8(%rdi),%ebx
   c47ca:	imul   0x10(%rdi),%rdx
   c47cf:	mulx   %rbx,%rdx,%rdx
   c47d4:	movzbl (%rdi),%ebx
   c47d7:	shlx   %rbx,%rdx,%rdx
   c47dc:	add    0x20(%rdi),%rdx
   c47e0:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   c47e4:	add    $0x3,%bl
   c47e7:	shlx   %ebx,%r11d,%ebx
   c47ec:	vpbroadcastd %ebx,%ymm3
   c47f2:	vpsrld $0x10,%xmm2,%xmm4
   c47f7:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   c47fd:	vpandn %ymm2,%ymm3,%ymm2
   c4801:	vpsrld $0x5,%ymm2,%ymm3
   c4806:	vpcmpeqd %ymm4,%ymm4,%ymm4
   c480a:	vpxor  %xmm5,%xmm5,%xmm5
   c480e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   c4814:	vpand  %ymm0,%ymm2,%ymm2
   c4818:	vpsllvd %ymm2,%ymm1,%ymm2
   c481d:	vpandn %ymm2,%ymm5,%ymm3
   c4821:	xor    %edx,%edx
   c4823:	vptest %ymm2,%ymm3
   c4828:	sete   %dl
   c482b:	mov    %edx,(%rcx,%r8,4)
   c482f:	inc    %r8
   c4832:	cmp    %r8,%rsi
   c4835:	jne    c4710 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c483b:	pop    %rbx
   c483c:	pop    %r14
   c483e:	pop    %r15
   c4840:	pop    %rbp
   c4841:	vzeroupper
   c4844:	ret
   c4845:	int3
   c4846:	int3
   c4847:	int3
   c4848:	int3
   c4849:	int3
   c484a:	int3
   c484b:	int3
   c484c:	int3
   c484d:	int3
   c484e:	int3
   c484f:	int3

