00000000000b35d0 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b35d0:	test   %rsi,%rsi
   b35d3:	je     b3751 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b35d9:	push   %rbp
   b35da:	push   %r15
   b35dc:	push   %r14
   b35de:	push   %rbx
   b35df:	mov    %rdx,%rax
   b35e2:	xor    %r8d,%r8d
   b35e5:	movabs $0xdeadbeefdeadbeef,%r9
   b35ef:	movabs $0xe6adbeefdeadbeef,%r10
   b35f9:	mov    $0xffffffff,%r11d
   b35ff:	vbroadcasti128 -0xaea18(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   b3608:	vpbroadcastd -0xb036d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   b3611:	vpbroadcastd -0xb0372(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   b361a:	nopw   0x0(%rax,%rax,1)
   b3620:	mov    (%rax,%r8,8),%rdx
   b3624:	add    %r9,%rdx
   b3627:	rorx   $0x31,%rdx,%rbx
   b362d:	xor    %r10,%rdx
   b3630:	add    %rbx,%rdx
   b3633:	rorx   $0xc,%rdx,%r14
   b3639:	add    %r14,%rdx
   b363c:	rorx   $0x26,%rdx,%r15
   b3642:	add    %r15,%rdx
   b3645:	xor    %rdx,%rbx
   b3648:	rorx   $0xd,%rdx,%rdx
   b364e:	add    %rdx,%rbx
   b3651:	xor    %rbx,%r14
   b3654:	rorx   $0x24,%rbx,%rbx
   b365a:	add    %rbx,%r14
   b365d:	xor    %r14,%r15
   b3660:	rorx   $0x37,%r14,%r14
   b3666:	add    %r14,%r15
   b3669:	xor    %r15,%rdx
   b366c:	rorx   $0x11,%r15,%r15
   b3672:	add    %r15,%rdx
   b3675:	xor    %rdx,%rbx
   b3678:	rorx   $0xa,%rdx,%rdx
   b367e:	add    %rdx,%rbx
   b3681:	xor    %rbx,%r14
   b3684:	rorx   $0x20,%rbx,%rbx
   b368a:	add    %r14,%rbx
   b368d:	xor    %rbx,%r15
   b3690:	rorx   $0x27,%rbx,%rbx
   b3696:	add    %r15,%rbx
   b3699:	xor    %rbx,%rdx
   b369c:	rorx   $0x1,%rbx,%rbx
   b36a2:	add    %rbx,%rdx
   b36a5:	rorx   $0x18,%ebx,%ebp
   b36ab:	vmovq  %rbx,%xmm3
   b36b0:	shr    $0x20,%rbx
   b36b4:	rorx   $0x1c,%edx,%r14d
   b36ba:	vmovq  %rdx,%xmm4
   b36bf:	shr    $0x20,%rdx
   b36c3:	rorx   $0x1a,%ebx,%ebx
   b36c9:	xor    %ebp,%ebx
   b36cb:	xor    %ebx,%r14d
   b36ce:	rorx   $0x1e,%edx,%edx
   b36d4:	xor    %r14d,%edx
   b36d7:	mov    0x8(%rdi),%ebx
   b36da:	imul   0x10(%rdi),%rdx
   b36df:	mulx   %rbx,%rdx,%rdx
   b36e4:	movzbl (%rdi),%ebx
   b36e7:	shlx   %rbx,%rdx,%rdx
   b36ec:	add    0x20(%rdi),%rdx
   b36f0:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   b36f4:	add    $0x3,%bl
   b36f7:	shlx   %ebx,%r11d,%ebx
   b36fc:	vpbroadcastd %ebx,%ymm4
   b3702:	vpsrld $0x10,%xmm3,%xmm5
   b3707:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   b370d:	vpandn %ymm3,%ymm4,%ymm3
   b3711:	vpsrld $0x5,%ymm3,%ymm4
   b3716:	vmovdqa %ymm0,%ymm5
   b371a:	vpcmpeqd %ymm6,%ymm6,%ymm6
   b371e:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   b3724:	vpand  %ymm1,%ymm3,%ymm3
   b3728:	vpsllvd %ymm3,%ymm2,%ymm3
   b372d:	vpandn %ymm3,%ymm6,%ymm4
   b3731:	xor    %edx,%edx
   b3733:	vptest %ymm3,%ymm4
   b3738:	sete   %dl
   b373b:	mov    %edx,(%rcx,%r8,4)
   b373f:	inc    %r8
   b3742:	cmp    %r8,%rsi
   b3745:	jne    b3620 <void inline_single_kernel<true, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b374b:	pop    %rbx
   b374c:	pop    %r14
   b374e:	pop    %r15
   b3750:	pop    %rbp
   b3751:	vzeroupper
   b3754:	ret
   b3755:	int3
   b3756:	int3
   b3757:	int3
   b3758:	int3
   b3759:	int3
   b375a:	int3
   b375b:	int3
   b375c:	int3
   b375d:	int3
   b375e:	int3
   b375f:	int3

