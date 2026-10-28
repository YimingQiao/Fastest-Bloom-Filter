00000000000b3550 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b3550:	test   %rsi,%rsi
   b3553:	je     b36d1 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b3559:	push   %rbp
   b355a:	push   %r15
   b355c:	push   %r14
   b355e:	push   %rbx
   b355f:	mov    %rdx,%rax
   b3562:	xor    %r8d,%r8d
   b3565:	movabs $0xdeadbeefdeadbeef,%r9
   b356f:	movabs $0xe6adbeefdeadbeef,%r10
   b3579:	mov    $0xffffffff,%r11d
   b357f:	vbroadcasti128 -0xae998(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   b3588:	vpbroadcastd -0xb02ed(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   b3591:	vpbroadcastd -0xb02f2(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   b359a:	nopw   0x0(%rax,%rax,1)
   b35a0:	mov    (%rax,%r8,8),%rdx
   b35a4:	add    %r9,%rdx
   b35a7:	rorx   $0x31,%rdx,%rbx
   b35ad:	xor    %r10,%rdx
   b35b0:	add    %rbx,%rdx
   b35b3:	rorx   $0xc,%rdx,%r14
   b35b9:	add    %r14,%rdx
   b35bc:	rorx   $0x26,%rdx,%r15
   b35c2:	add    %r15,%rdx
   b35c5:	xor    %rdx,%rbx
   b35c8:	rorx   $0xd,%rdx,%rdx
   b35ce:	add    %rdx,%rbx
   b35d1:	xor    %rbx,%r14
   b35d4:	rorx   $0x24,%rbx,%rbx
   b35da:	add    %rbx,%r14
   b35dd:	xor    %r14,%r15
   b35e0:	rorx   $0x37,%r14,%r14
   b35e6:	add    %r14,%r15
   b35e9:	xor    %r15,%rdx
   b35ec:	rorx   $0x11,%r15,%r15
   b35f2:	add    %r15,%rdx
   b35f5:	xor    %rdx,%rbx
   b35f8:	rorx   $0xa,%rdx,%rdx
   b35fe:	add    %rdx,%rbx
   b3601:	xor    %rbx,%r14
   b3604:	rorx   $0x20,%rbx,%rbx
   b360a:	add    %r14,%rbx
   b360d:	xor    %rbx,%r15
   b3610:	rorx   $0x27,%rbx,%rbx
   b3616:	add    %r15,%rbx
   b3619:	xor    %rbx,%rdx
   b361c:	rorx   $0x1,%rbx,%rbx
   b3622:	add    %rbx,%rdx
   b3625:	rorx   $0x18,%ebx,%ebp
   b362b:	vmovq  %rbx,%xmm3
   b3630:	shr    $0x20,%rbx
   b3634:	rorx   $0x1c,%edx,%r14d
   b363a:	vmovq  %rdx,%xmm4
   b363f:	shr    $0x20,%rdx
   b3643:	rorx   $0x1a,%ebx,%ebx
   b3649:	xor    %ebp,%ebx
   b364b:	xor    %ebx,%r14d
   b364e:	rorx   $0x1e,%edx,%edx
   b3654:	xor    %r14d,%edx
   b3657:	mov    0x8(%rdi),%ebx
   b365a:	imul   0x10(%rdi),%rdx
   b365f:	mulx   %rbx,%rdx,%rdx
   b3664:	movzbl (%rdi),%ebx
   b3667:	shlx   %rbx,%rdx,%rdx
   b366c:	add    0x20(%rdi),%rdx
   b3670:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   b3674:	add    $0x3,%bl
   b3677:	shlx   %ebx,%r11d,%ebx
   b367c:	vpbroadcastd %ebx,%ymm4
   b3682:	vpsrld $0x10,%xmm3,%xmm5
   b3687:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   b368d:	vpandn %ymm3,%ymm4,%ymm3
   b3691:	vpsrld $0x5,%ymm3,%ymm4
   b3696:	vmovdqa %ymm0,%ymm5
   b369a:	vpcmpeqd %ymm6,%ymm6,%ymm6
   b369e:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   b36a4:	vpand  %ymm1,%ymm3,%ymm3
   b36a8:	vpsllvd %ymm3,%ymm2,%ymm3
   b36ad:	vpandn %ymm3,%ymm6,%ymm4
   b36b1:	xor    %edx,%edx
   b36b3:	vptest %ymm3,%ymm4
   b36b8:	sete   %dl
   b36bb:	mov    %edx,(%rcx,%r8,4)
   b36bf:	inc    %r8
   b36c2:	cmp    %r8,%rsi
   b36c5:	jne    b35a0 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b36cb:	pop    %rbx
   b36cc:	pop    %r14
   b36ce:	pop    %r15
   b36d0:	pop    %rbp
   b36d1:	vzeroupper
   b36d4:	ret
   b36d5:	int3
   b36d6:	int3
   b36d7:	int3
   b36d8:	int3
   b36d9:	int3
   b36da:	int3
   b36db:	int3
   b36dc:	int3
   b36dd:	int3
   b36de:	int3
   b36df:	int3

