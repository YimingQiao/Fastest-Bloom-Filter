00000000000c4640 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c4640:	test   %rsi,%rsi
   c4643:	je     c47c1 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c4649:	push   %rbp
   c464a:	push   %r15
   c464c:	push   %r14
   c464e:	push   %rbx
   c464f:	mov    %rdx,%rax
   c4652:	xor    %r8d,%r8d
   c4655:	movabs $0xdeadbeefdeadbeef,%r9
   c465f:	movabs $0xe6adbeefdeadbeef,%r10
   c4669:	mov    $0xffffffff,%r11d
   c466f:	vpbroadcastd -0xc13d4(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   c4678:	vpbroadcastd -0xc13d9(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   c4681:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   c4690:	mov    (%rax,%r8,8),%rdx
   c4694:	add    %r9,%rdx
   c4697:	rorx   $0x31,%rdx,%rbx
   c469d:	xor    %r10,%rdx
   c46a0:	add    %rbx,%rdx
   c46a3:	rorx   $0xc,%rdx,%r14
   c46a9:	add    %r14,%rdx
   c46ac:	rorx   $0x26,%rdx,%r15
   c46b2:	add    %r15,%rdx
   c46b5:	xor    %rdx,%rbx
   c46b8:	rorx   $0xd,%rdx,%rdx
   c46be:	add    %rdx,%rbx
   c46c1:	xor    %rbx,%r14
   c46c4:	rorx   $0x24,%rbx,%rbx
   c46ca:	add    %rbx,%r14
   c46cd:	xor    %r14,%r15
   c46d0:	rorx   $0x37,%r14,%r14
   c46d6:	add    %r14,%r15
   c46d9:	xor    %r15,%rdx
   c46dc:	rorx   $0x11,%r15,%r15
   c46e2:	add    %r15,%rdx
   c46e5:	xor    %rdx,%rbx
   c46e8:	rorx   $0xa,%rdx,%rdx
   c46ee:	add    %rdx,%rbx
   c46f1:	xor    %rbx,%r14
   c46f4:	rorx   $0x20,%rbx,%rbx
   c46fa:	add    %r14,%rbx
   c46fd:	xor    %rbx,%r15
   c4700:	rorx   $0x27,%rbx,%rbx
   c4706:	add    %r15,%rbx
   c4709:	xor    %rbx,%rdx
   c470c:	rorx   $0x1,%rbx,%rbx
   c4712:	add    %rbx,%rdx
   c4715:	rorx   $0x18,%ebx,%ebp
   c471b:	vmovq  %rbx,%xmm2
   c4720:	shr    $0x20,%rbx
   c4724:	rorx   $0x1c,%edx,%r14d
   c472a:	vmovq  %rdx,%xmm3
   c472f:	shr    $0x20,%rdx
   c4733:	rorx   $0x1a,%ebx,%ebx
   c4739:	xor    %ebp,%ebx
   c473b:	xor    %ebx,%r14d
   c473e:	rorx   $0x1e,%edx,%edx
   c4744:	xor    %r14d,%edx
   c4747:	mov    0x8(%rdi),%ebx
   c474a:	imul   0x10(%rdi),%rdx
   c474f:	mulx   %rbx,%rdx,%rdx
   c4754:	movzbl (%rdi),%ebx
   c4757:	shlx   %rbx,%rdx,%rdx
   c475c:	add    0x20(%rdi),%rdx
   c4760:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   c4764:	add    $0x3,%bl
   c4767:	shlx   %ebx,%r11d,%ebx
   c476c:	vpbroadcastd %ebx,%ymm3
   c4772:	vpsrld $0x10,%xmm2,%xmm4
   c4777:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   c477d:	vpandn %ymm2,%ymm3,%ymm2
   c4781:	vpsrld $0x5,%ymm2,%ymm3
   c4786:	vpcmpeqd %ymm4,%ymm4,%ymm4
   c478a:	vpxor  %xmm5,%xmm5,%xmm5
   c478e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   c4794:	vpand  %ymm0,%ymm2,%ymm2
   c4798:	vpsllvd %ymm2,%ymm1,%ymm2
   c479d:	vpandn %ymm2,%ymm5,%ymm3
   c47a1:	xor    %edx,%edx
   c47a3:	vptest %ymm2,%ymm3
   c47a8:	sete   %dl
   c47ab:	mov    %edx,(%rcx,%r8,4)
   c47af:	inc    %r8
   c47b2:	cmp    %r8,%rsi
   c47b5:	jne    c4690 <void inline_single_kernel<true, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c47bb:	pop    %rbx
   c47bc:	pop    %r14
   c47be:	pop    %r15
   c47c0:	pop    %rbp
   c47c1:	vzeroupper
   c47c4:	ret
   c47c5:	int3
   c47c6:	int3
   c47c7:	int3
   c47c8:	int3
   c47c9:	int3
   c47ca:	int3
   c47cb:	int3
   c47cc:	int3
   c47cd:	int3
   c47ce:	int3
   c47cf:	int3

